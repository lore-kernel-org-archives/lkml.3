Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbaIZK0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:26:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33052 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754796AbaIZJqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:07 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Christoph Hellwig <hch@lst.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 065/142] scsi_scan: Restrict sequential scan to 256 LUNs
Date: Fri, 26 Sep 2014 11:44:36 +0200
Message-Id: <efd3133b4ac7fc80f8b61bcee10a734cd9b25e6d.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 22ffeb48b7584d6cd50f2a595ed6065d86a87459 upstream.

Sequential scan for more than 256 LUNs is very fragile as
LUNs might not be numbered sequentially after that point.

SAM revisions later than SCSI-3 impose a structure on
LUNs larger than 256, making LUN numbers between 256
and 16384 illegal.
SCSI-3, however allows for plain 64-bit numbers with
no internal structure.

So restrict sequential LUN scan to 256 LUNs and add a
new blacklist flag 'BLIST_SCSI3LUN' to scan up to
max_lun devices.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Ewan Milne <emilne@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/scsi/scsi_scan.c    | 6 ++++++
 include/scsi/scsi_devinfo.h | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 4109530e92a0..bfad3586d914 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1236,6 +1236,12 @@ static void scsi_sequential_lun_scan(struct scsi_target *starget,
 		max_dev_lun = min(8U, max_dev_lun);
 
 	/*
+	 * Stop scanning at 255 unless BLIST_SCSI3LUN
+	 */
+	if (!(bflags & BLIST_SCSI3LUN))
+		max_dev_lun = min(256U, max_dev_lun);
+
+	/*
 	 * We have already scanned LUN 0, so start at LUN 1. Keep scanning
 	 * until we reach the max, or no LUN is found and we are not
 	 * sparse_lun.
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 447d2d7466fc..8670c04e199e 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -32,4 +32,6 @@
 #define BLIST_ATTACH_PQ3	0x1000000 /* Scan: Attach to PQ3 devices */
 #define BLIST_NO_DIF		0x2000000 /* Disable T10 PI (DIF) */
 #define BLIST_SKIP_VPD_PAGES	0x4000000 /* Ignore SBC-3 VPD pages */
+#define BLIST_SCSI3LUN		0x8000000 /* Scan more than 256 LUNs
+					     for sequential scan */
 #endif
-- 
2.1.0

