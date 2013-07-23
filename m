Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934720Ab3GWWpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:45:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41665 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934635Ab3GWW1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        NeilBrown <neilb@suse.de>
Subject: [ 050/103] md/raid10: fix two bugs affecting RAID10 reshape.
Date: Tue, 23 Jul 2013 15:26:01 -0700
Message-Id: <20130723220424.149166996@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 78eaa0d4cbcdb345992fa3dd22b3bcbb473cc064 upstream.

1/ If a RAID10 is being reshaped to a fewer number of devices
 and is stopped while this is ongoing, then when the array is
 reassembled the 'mirrors' array will be allocated too small.
 This will lead to an access error or memory corruption.

2/ A sanity test for a reshaping RAID10 array is restarted
 is slightly incorrect.

Due to the first bug, this is suitable for any -stable
kernel since 3.5 where this code was introduced.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid10.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3531,7 +3531,7 @@ static struct r10conf *setup_conf(struct
 
 	/* FIXME calc properly */
 	conf->mirrors = kzalloc(sizeof(struct raid10_info)*(mddev->raid_disks +
-							    max(0,mddev->delta_disks)),
+							    max(0,-mddev->delta_disks)),
 				GFP_KERNEL);
 	if (!conf->mirrors)
 		goto out;
@@ -3690,7 +3690,7 @@ static int run(struct mddev *mddev)
 		    conf->geo.far_offset == 0)
 			goto out_free_conf;
 		if (conf->prev.far_copies != 1 &&
-		    conf->geo.far_offset == 0)
+		    conf->prev.far_offset == 0)
 			goto out_free_conf;
 	}
 


