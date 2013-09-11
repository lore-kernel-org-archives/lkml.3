Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab3IKE3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:29:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8621 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab3IKE3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:29:01 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=2NwvbCs_rsIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=FJ5rC3Q_j7AA:10 a=lsPbfN_uAAAA:8 a=VwQbUJbxAAAA:8 a=tmtSDGaQAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=_lD9dG8-Ut4A:10 a=3RCS-MslXnYA:10 a=jkObVMfX7fAA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042855.771423486@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:27:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [022/251] aacraid: Fix for arrays are going offline in the system. System
 hangs
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0022-aacraid-Fix-for-arrays-are-going-offline-in-the-syst.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>

[ Upstream commit c5bebd829dd95602c15f8da8cc50fa938b5e0254 ]

One of the customer had reported that the set of raid logical arrays will
become unavailable (I/O offline) after a long hours of IO stress test.  The OS
wouldn`t be accessible afterwards and require a hard reset.

This driver patch has a fix for race condition between the doorbell and the
circular buffer. The driver is modified to do an extra read after clearing the
doorbell in case there had been a completion posted during the small timing
window.

With this fix, we ran IO stress for ~13 days. There were no IO failures.

Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/scsi/aacraid/src.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 3b021ec..e34418f 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -93,6 +93,9 @@ static irqreturn_t aac_src_intr_message(int irq, void *dev_id)
 			int send_it = 0;
 			extern int aac_sync_mode;
 
+			src_writel(dev, MUnit.ODR_C, bellbits);
+			src_readl(dev, MUnit.ODR_C);
+
 			if (!aac_sync_mode) {
 				src_writel(dev, MUnit.ODR_C, bellbits);
 				src_readl(dev, MUnit.ODR_C);
-- 
1.7.10.4


