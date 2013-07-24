Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab3GXO2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:28:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45844 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752257Ab3GXOGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:35 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Adam Radford" <aradford@gmail.com>,
        "=?UTF-8?q?Bj=C3=B8rn=20Mork?=" <bjorn@mork.no>,
        "James Bottomley" <JBottomley@Parallels.com>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.790440972@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [72/85] [SCSI] megaraid_sas: fix memory leak if SGL has zero
 length entries
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit 7a6a731bd00ca90d0e250867c3b9c05b5ff0fa49 upstream.

commit 98cb7e44 ([SCSI] megaraid_sas: Sanity check user
supplied length before passing it to dma_alloc_coherent())
introduced a memory leak.  Memory allocated for entries
following zero length SGL entries will not be freed.

Reference: http://bugs.debian.org/688198

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Acked-by: Adam Radford <aradford@gmail.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4886,10 +4886,12 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
 				    sense, sense_handle);
 	}
 
-	for (i = 0; i < ioc->sge_count && kbuff_arr[i]; i++) {
-		dma_free_coherent(&instance->pdev->dev,
-				    kern_sge32[i].length,
-				    kbuff_arr[i], kern_sge32[i].phys_addr);
+	for (i = 0; i < ioc->sge_count; i++) {
+		if (kbuff_arr[i])
+			dma_free_coherent(&instance->pdev->dev,
+					  kern_sge32[i].length,
+					  kbuff_arr[i],
+					  kern_sge32[i].phys_addr);
 	}
 
 	megasas_return_cmd(instance, cmd);

