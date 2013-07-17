Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965112Ab3GQXLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:11:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56671 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964981Ab3GQWzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:55:53 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        James Bottomley <JBottomley@Parallels.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 123/145] [SCSI] megaraid_sas: fix memory leak if SGL has zero length entries
Date: Wed, 17 Jul 2013 15:47:35 -0700
Message-Id: <1374101277-7915-124-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>

commit 7a6a731bd00ca90d0e250867c3b9c05b5ff0fa49 upstream.

commit 98cb7e44 ([SCSI] megaraid_sas: Sanity check user
supplied length before passing it to dma_alloc_coherent())
introduced a memory leak.  Memory allocated for entries
following zero length SGL entries will not be freed.

Reference: http://bugs.debian.org/688198

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Acked-by: Adam Radford <aradford@gmail.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 66a0fec..996a314 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4852,10 +4852,12 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
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
-- 
1.8.1.2

