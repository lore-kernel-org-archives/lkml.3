Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbaFEAcp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:32:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39968 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbaFDXVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:21:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Subject: [PATCH 3.14 086/228] fsl-usb: do not test for PHY_CLK_VALID bit on controller version 1.6
Date: Wed,  4 Jun 2014 16:21:55 -0700
Message-Id: <20140604232350.823071524@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/host/ehci-fsl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/ehci-fsl.c
+++ b/drivers/usb/host/ehci-fsl.c
@@ -248,7 +248,8 @@ static int ehci_fsl_setup_phy(struct usb
 		break;
 	}
 
-	if (pdata->have_sysif_regs && pdata->controller_ver &&
+	if (pdata->have_sysif_regs &&
+	    pdata->controller_ver > FSL_USB_VER_1_6 &&
 	    (phy_mode == FSL_USB2_PHY_ULPI)) {
 		/* check PHY_CLK_VALID to get phy clk valid */
 		if (!(spin_event_timeout(in_be32(non_ehci + FSL_SOC_USB_CTRL) &


