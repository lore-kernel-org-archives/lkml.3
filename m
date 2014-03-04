Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026AbaCDUnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:43:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41401 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756929AbaCDUEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:04:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.13 162/172] dm mpath: fix stalls when handling invalid ioctls
Date: Tue,  4 Mar 2014 12:04:06 -0800
Message-Id: <20140304200304.890494319@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-mpath.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1626,8 +1626,11 @@ static int multipath_ioctl(struct dm_tar
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


