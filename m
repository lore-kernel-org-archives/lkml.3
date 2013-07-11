Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933190Ab3GKOk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:40:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43119 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932931Ab3GKO0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:26:34 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 62/98] md/raid10: fix two bugs affecting RAID10 reshape.
Date: Thu, 11 Jul 2013 15:24:32 +0100
Message-Id: <1373552708-15235-63-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/raid10.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e76227e..a829557 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3410,7 +3410,7 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 
 	/* FIXME calc properly */
 	conf->mirrors = kzalloc(sizeof(struct mirror_info)*(mddev->raid_disks +
-							    max(0,mddev->delta_disks)),
+							    max(0,-mddev->delta_disks)),
 				GFP_KERNEL);
 	if (!conf->mirrors)
 		goto out;
@@ -3551,7 +3551,7 @@ static int run(struct mddev *mddev)
 		    conf->geo.far_offset == 0)
 			goto out_free_conf;
 		if (conf->prev.far_copies != 1 &&
-		    conf->geo.far_offset == 0)
+		    conf->prev.far_offset == 0)
 			goto out_free_conf;
 	}
 
-- 
1.8.1.2

