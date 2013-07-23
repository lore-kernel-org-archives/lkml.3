Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934966Ab3GWWlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:41:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41739 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934608Ab3GWW1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 061/103] SCSI: aacraid: Fix for arrays are going offline in the system. System hangs
Date: Tue, 23 Jul 2013 15:26:12 -0700
Message-Id: <20130723220425.503774796@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>

commit c5bebd829dd95602c15f8da8cc50fa938b5e0254 upstream.

One of the customer had reported that the set of raid logical arrays will
become unavailable (I/O offline) after a long hours of IO stress test.  The OS
wouldn`t be accessible afterwards and require a hard reset.

This driver patch has a fix for race condition between the doorbell and the
circular buffer. The driver is modified to do an extra read after clearing the
doorbell in case there had been a completion posted during the small timing
window.

With this fix, we ran IO stress for ~13 days. There were no IO failures.

Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/aacraid/src.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -93,6 +93,9 @@ static irqreturn_t aac_src_intr_message(
 			int send_it = 0;
 			extern int aac_sync_mode;
 
+			src_writel(dev, MUnit.ODR_C, bellbits);
+			src_readl(dev, MUnit.ODR_C);
+
 			if (!aac_sync_mode) {
 				src_writel(dev, MUnit.ODR_C, bellbits);
 				src_readl(dev, MUnit.ODR_C);


