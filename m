Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865AbaIOUau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:30:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55101 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683AbaIOThE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:37:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Ewan Milne <emilne@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3.14 038/114] scsi_scan: Restrict sequential scan to 256 LUNs
Date: Mon, 15 Sep 2014 12:25:38 -0700
Message-Id: <20140915192642.636330693@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192641.428509513@linuxfoundation.org>
References: <20140915192641.428509513@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@suse.de>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/scsi_scan.c    |    6 ++++++
 include/scsi/scsi_devinfo.h |    2 ++
 2 files changed, 8 insertions(+)

--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1236,6 +1236,12 @@ static void scsi_sequential_lun_scan(str
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
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -32,4 +32,6 @@
 #define BLIST_ATTACH_PQ3	0x1000000 /* Scan: Attach to PQ3 devices */
 #define BLIST_NO_DIF		0x2000000 /* Disable T10 PI (DIF) */
 #define BLIST_SKIP_VPD_PAGES	0x4000000 /* Ignore SBC-3 VPD pages */
+#define BLIST_SCSI3LUN		0x8000000 /* Scan more than 256 LUNs
+					     for sequential scan */
 #endif


