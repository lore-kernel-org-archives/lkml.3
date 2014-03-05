Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561AbaCEOl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:41:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41802 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757895AbaCEOi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:38:28 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 53/62] dm mpath: fix stalls when handling invalid ioctls
Date: Wed,  5 Mar 2014 14:36:57 +0000
Message-Id: <1394030226-26652-54-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
References: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.32 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@suse.de>

commit a1989b330093578ea5470bea0a00f940c444c466 upstream.

An invalid ioctl will never be valid, irrespective of whether multipath
has active paths or not.  So for invalid ioctls we do not have to wait
for multipath to activate any paths, but can rather return an error
code immediately.  This fix resolves numerous instances of:

 udevd[]: worker [] unexpectedly returned with status 0x0100

that have been seen during testing.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/dm-mpath.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 274354d..72398e5 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1562,8 +1562,11 @@ static int multipath_ioctl(struct dm_target *ti, unsigned int cmd,
 	/*
 	 * Only pass ioctls through if the device sizes match exactly.
 	 */
-	if (!r && ti->len != i_size_read(bdev->bd_inode) >> SECTOR_SHIFT)
-		r = scsi_verify_blk_ioctl(NULL, cmd);
+	if (!bdev || ti->len != i_size_read(bdev->bd_inode) >> SECTOR_SHIFT) {
+		int err = scsi_verify_blk_ioctl(NULL, cmd);
+		if (err)
+			r = err;
+	}
 
 	if (r == -ENOTCONN && !fatal_signal_pending(current))
 		queue_work(kmultipathd, &m->process_queued_ios);
-- 
1.9.0

