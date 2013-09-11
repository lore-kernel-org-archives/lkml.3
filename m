Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab3IKQ5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:57:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22899 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251Ab3IKQ4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:56:46 -0400
X-Authority-Analysis: v=2.0 cv=R/aB6KtX c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=nYR95F3ITGEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=vc3DlsMMTOkA:10 a=xNf9USuDAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=tmtSDGaQAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=MSl-tDqOz04A:10 a=jkObVMfX7fAA:10 a=jeBq3FmKZ4MA:10 a=E_we-EB6crTedyOQ:21 a=0gpM41rBtkkAS5KI:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042902.812387930@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Adam Radford <aradford@gmail.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [062/251] megaraid_sas: fix memory leak if SGL has zero length entries
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0062-megaraid_sas-fix-memory-leak-if-SGL-has-zero-length-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>

[ Upstream commit 7a6a731bd00ca90d0e250867c3b9c05b5ff0fa49 ]

commit 98cb7e44 ([SCSI] megaraid_sas: Sanity check user
supplied length before passing it to dma_alloc_coherent())
introduced a memory leak.  Memory allocated for entries
following zero length SGL entries will not be freed.

Reference: http://bugs.debian.org/688198

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Cc: <stable@vger.kernel.org>
Acked-by: Adam Radford <aradford@gmail.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index ed38454..d525297 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4817,10 +4817,12 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
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
1.7.10.4


