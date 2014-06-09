Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933323AbaFIJMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:12:08 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58436 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754875AbaFIIvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:24 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 055/146] fsl-usb: do not test for PHY_CLK_VALID bit on controller version 1.6
Date: Mon,  9 Jun 2014 10:49:50 +0200
Message-Id: <9c7d0b459c3d169fd4fbe2f831444c1669cef8c2.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d183c81929beeba842b74422f754446ef2b8b49c upstream.

Per reference manuals of Freescale P1020 and P2020 SoCs, USB controller
present in these SoCs has bit 17 of USBx_CONTROL register marked as
Reserved - there is no PHY_CLK_VALID bit there.

Testing for this bit in ehci_fsl_setup_phy() behaves differently on two
P1020RDB boards available here - on one board test passes and fsl-usb
init succeeds, but on other board test fails, causing fsl-usb init to
fail.

This patch changes ehci_fsl_setup_phy() not to test PHY_CLK_VALID on
controller version 1.6 that (per manual) does not have this bit.

Signed-off-by: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/host/ehci-fsl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-fsl.c b/drivers/usb/host/ehci-fsl.c
index f2407b2e8a99..ce65c4ec6550 100644
--- a/drivers/usb/host/ehci-fsl.c
+++ b/drivers/usb/host/ehci-fsl.c
@@ -261,7 +261,8 @@ static int ehci_fsl_setup_phy(struct usb_hcd *hcd,
 		break;
 	}
 
-	if (pdata->have_sysif_regs && pdata->controller_ver &&
+	if (pdata->have_sysif_regs &&
+	    pdata->controller_ver > FSL_USB_VER_1_6 &&
 	    (phy_mode == FSL_USB2_PHY_ULPI)) {
 		/* check PHY_CLK_VALID to get phy clk valid */
 		if (!(spin_event_timeout(in_be32(non_ehci + FSL_SOC_USB_CTRL) &
-- 
1.9.3

