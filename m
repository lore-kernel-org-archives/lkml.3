Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbbAATMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 14:12:36 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:35137 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbbAATMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 14:12:35 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: phy: phy-fsl-usb:  Remove some unused functions
Date: Thu,  1 Jan 2015 20:15:34 +0100
Message-Id: <1420139734-3249-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
fsl_otg_tick_timer() view_ulpi()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/usb/phy/phy-fsl-usb.c |   35 -----------------------------------
 1 file changed, 35 deletions(-)

diff --git a/drivers/usb/phy/phy-fsl-usb.c b/drivers/usb/phy/phy-fsl-usb.c
index f1ea599..395d84c 100644
--- a/drivers/usb/phy/phy-fsl-usb.c
+++ b/drivers/usb/phy/phy-fsl-usb.c
@@ -107,19 +107,6 @@ static void (*_fsl_writel)(u32 v, unsigned __iomem *p);
 #define fsl_writel(val, addr)	writel(val, addr)
 #endif /* CONFIG_PPC32 */
 
-/* Routines to access transceiver ULPI registers */
-u8 view_ulpi(u8 addr)
-{
-	u32 temp;
-
-	temp = 0x40000000 | (addr << 16);
-	fsl_writel(temp, &usb_dr_regs->ulpiview);
-	udelay(1000);
-	while (temp & 0x40)
-		temp = fsl_readl(&usb_dr_regs->ulpiview);
-	return (le32_to_cpu(temp) & 0x0000ff00) >> 8;
-}
-
 int write_ulpi(u8 addr, u8 data)
 {
 	u32 temp;
@@ -460,28 +447,6 @@ static void fsl_otg_fsm_del_timer(struct otg_fsm *fsm, enum otg_fsm_timer t)
 	fsl_otg_del_timer(fsm, timer);
 }
 
-/*
- * Reduce timer count by 1, and find timeout conditions.
- * Called by fsl_otg 1ms timer interrupt
- */
-int fsl_otg_tick_timer(void)
-{
-	struct fsl_otg_timer *tmp_timer, *del_tmp;
-	int expired = 0;
-
-	list_for_each_entry_safe(tmp_timer, del_tmp, &active_timers, list) {
-		tmp_timer->count--;
-		/* check if timer expires */
-		if (!tmp_timer->count) {
-			list_del(&tmp_timer->list);
-			tmp_timer->function(tmp_timer->data);
-			expired = 1;
-		}
-	}
-
-	return expired;
-}
-
 /* Reset controller, not reset the bus */
 void otg_reset_controller(void)
 {
-- 
1.7.10.4

