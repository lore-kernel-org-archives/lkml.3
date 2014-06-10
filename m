Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbaFJUJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:09:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35407 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180AbaFJTwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:52:17 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 146/160] fsl-usb: do not test for PHY_CLK_VALID bit on controller version 1.6
Date: Tue, 10 Jun 2014 12:46:26 -0700
Message-Id: <1402429600-20477-147-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/ehci-fsl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-fsl.c b/drivers/usb/host/ehci-fsl.c
index a06d501..df1fdca 100644
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
1.9.1

