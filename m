Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633AbaJGXWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:22:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39888 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932451AbaJGXUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:20:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Shaohua Li <shli@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>, NeilBrown <neilb@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 3.10 08/13] md/raid5: disable DISCARD by default due to safety concerns.
Date: Tue,  7 Oct 2014 16:20:13 -0700
Message-Id: <20141007231920.169944289@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141007231919.924479934@linuxfoundation.org>
References: <20141007231919.924479934@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 8e0e99ba64c7ba46133a7c8a3e3f7de01f23bd93 upstream.

It has come to my attention (thanks Martin) that 'discard_zeroes_data'
is only a hint.  Some devices in some cases don't do what it
says on the label.

The use of DISCARD in RAID5 depends on reads from discarded regions
being predictably zero.  If a write to a previously discarded region
performs a read-modify-write cycle it assumes that the parity block
was consistent with the data blocks.  If all were zero, this would
be the case.  If some are and some aren't this would not be the case.
This could lead to data corruption after a device failure when
data needs to be reconstructed from the parity.

As we cannot trust 'discard_zeroes_data', ignore it by default
and so disallow DISCARD on all raid4/5/6 arrays.

As many devices are trustworthy, and as there are benefits to using
DISCARD, add a module parameter to over-ride this caution and cause
DISCARD to work if discard_zeroes_data is set.

If a site want to enable DISCARD on some arrays but not on others they
should select DISCARD support at the filesystem level, and set the
raid456 module parameter.
    raid456.devices_handle_discard_safely=Y

As this is a data-safety issue, I believe this patch is suitable for
-stable.
DISCARD support for RAID456 was added in 3.7

Cc: Shaohua Li <shli@kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
Acked-by: Mike Snitzer <snitzer@redhat.com>
Fixes: 620125f2bf8ff0c4969b79653b54d7bcc9d40637
Signed-off-by: NeilBrown <neilb@suse.de>
[bwh: Backported to 3.10: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid5.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -60,6 +60,10 @@
 #include "raid0.h"
 #include "bitmap.h"
 
+static bool devices_handle_discard_safely = false;
+module_param(devices_handle_discard_safely, bool, 0644);
+MODULE_PARM_DESC(devices_handle_discard_safely,
+		 "Set to Y if all devices in each array reliably return zeroes on reads from discarded regions");
 /*
  * Stripe cache
  */
@@ -5611,7 +5615,7 @@ static int run(struct mddev *mddev)
 		mddev->queue->limits.discard_granularity = stripe;
 		/*
 		 * unaligned part of discard request will be ignored, so can't
-		 * guarantee discard_zerors_data
+		 * guarantee discard_zeroes_data
 		 */
 		mddev->queue->limits.discard_zeroes_data = 0;
 
@@ -5636,6 +5640,18 @@ static int run(struct mddev *mddev)
 			    !bdev_get_queue(rdev->bdev)->
 						limits.discard_zeroes_data)
 				discard_supported = false;
+			/* Unfortunately, discard_zeroes_data is not currently
+			 * a guarantee - just a hint.  So we only allow DISCARD
+			 * if the sysadmin has confirmed that only safe devices
+			 * are in use by setting a module parameter.
+			 */
+			if (!devices_handle_discard_safely) {
+				if (discard_supported) {
+					pr_info("md/raid456: discard support disabled due to uncertainty.\n");
+					pr_info("Set raid456.devices_handle_discard_safely=Y to override.\n");
+				}
+				discard_supported = false;
+			}
 		}
 
 		if (discard_supported &&


