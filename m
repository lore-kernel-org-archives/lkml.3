Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbaEHNwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 09:52:44 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:57777 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbaEHNwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 09:52:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [PATCH 5/8] usb: phy: msm: reset controller is mandatory now
Date: Thu,  8 May 2014 15:52:18 +0200
Message-Id: <1399557141-1346645-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399557141-1346645-1-git-send-email-arnd@arndb.de>
References: <1399557141-1346645-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:ElAzaXJy47HWWYKAGmgncqOg7ZzPlZlpTKz1QH/eHc+
 zy3PX07Fs876ZzN7qIwPhikSrl6hYmMRDP0lyIK/xji1xehFdn
 ivQ42WhFHA5SJFftWXg90c56WK5LqsbXmN2O+93kTBpPaeMdNT
 zuVA5KVXpUYaE435ThMYKY1tqBZxmzVdOibNnzZJp7n1U1vI5f
 ZzfdV9xIza0IJyNngtXQQI/c75Sy3bo8rXde9L1FQ56C/YOYQL
 1as42Avjp28XWbCQ4DvZZZ2lzLghhfHH0Z8jwU64/2rg1lSguu
 hP9bn+awl0jD1vHR24HAc2I53g0lEEct1Gz80FfWKEdTDdbUiM
 c1ZMwNrKGFRMOzzrt4vT7Sj/BKUK8FWs6CCNiRKyy
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

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>
---
 drivers/usb/host/Kconfig | 2 +-
 drivers/usb/phy/Kconfig  | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 3d9e540..890fc8c 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -168,7 +168,7 @@ config USB_EHCI_HCD_AT91
 
 config USB_EHCI_MSM
 	tristate "Support for Qualcomm QSD/MSM on-chip EHCI USB controller"
-	depends on ARCH_MSM
+	depends on ARCH_MSM && RESET_CONTROLLER
 	select USB_EHCI_ROOT_HUB_TT
 	select USB_MSM_OTG
 	---help---
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
-- 
1.8.3.2

