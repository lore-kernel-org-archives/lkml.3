Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbaEMTrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 15:47:11 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:49306 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbaEMTq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 15:46:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Felipe Balbi <balbi@ti.com>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2] usb: phy: msm: reset controller is mandatory now
Date: Tue, 13 May 2014 21:46:52 +0200
Message-ID: <4319810.IibMxJ0Qvk@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:OciVEvsAhKLW7xNyk4X0KDM5kVaxmtrtHTTzonhM/jd
 HxV6khK0x6c4hg49aI31u1HrvTUQnJNkogDYMEl6HFvXKDbyS+
 xLvUJdMw4ZamldwQPx370vukZxfi2ZmU3G1rYM0mRkdIgGgtko
 l+wN+wCpWVp0q/Lf63koQ/IhYqbRq0frG1DsXI9ePZGCkRBwU6
 qlOWeJVjnDWrW8j9jPv6TVHCvsr91lMjRplJYELVif+CZNVEV8
 j8Y7D1C68Nnjo2Kib06Qbb6DhKWIhaR73SZQfID6KuUplzTGvz
 jHu6c9aoxZVZjsibhLYBkFCH7DId4Qb7O7Brx26kXFJKs41/+T
 vhoxIMOkLeVgxhol+TaQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a27345434134 "usb: phy: msm: Use reset framework for LINK
and PHY resets" introduced a mandatory call to reset_control_get
into the msm usb phy driver, which means we have to add a Kconfig
dependency on the API to avoid this build error:

phy/phy-msm-usb.c: In function 'msm_otg_read_dt':
phy/phy-msm-usb.c:1461:2: error: implicit declaration of function 'devm_reset_control_get' [-Werror=implicit-function-declaration]
  motg->link_rst = devm_reset_control_get(&pdev->dev, "link");
  ^

Since the usb-ehci-msm driver currently selects the OTG driver,
we could still get a broken dependency here. To solve that,
this patch also removes the 'select', which turns out to be
unnecessary.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 3d9e540..7a39ae8 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -170,7 +170,6 @@ config USB_EHCI_MSM
 	tristate "Support for Qualcomm QSD/MSM on-chip EHCI USB controller"
 	depends on ARCH_MSM
 	select USB_EHCI_ROOT_HUB_TT
-	select USB_MSM_OTG
 	---help---
 	  Enables support for the USB Host controller present on the
 	  Qualcomm chipsets. Root Hub has inbuilt TT.
diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index 359a6c1..65bec8f 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -165,6 +165,7 @@ config USB_ISP1301
 config USB_MSM_OTG
 	tristate "Qualcomm on-chip USB OTG controller support"
 	depends on (USB || USB_GADGET) && (ARCH_MSM || ARCH_QCOM)
+	depends on RESET_CONTROLLER
 	select USB_PHY
 	help
 	  Enable this to support the USB OTG transceiver on Qualcomm chips. It

