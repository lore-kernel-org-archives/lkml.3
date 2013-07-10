Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab3GJVSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 17:18:51 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:37320 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab3GJVSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 17:18:48 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] usb: USB host support should depend on HAS_DMA
Date: Wed, 10 Jul 2013 23:18:32 +0200
Message-Id: <1373491112-15593-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NO_DMA=y:

drivers/built-in.o: In function `usb_hcd_unmap_urb_setup_for_dma':
drivers/usb/core/hcd.c:1361: undefined reference to `dma_unmap_single'
drivers/built-in.o: In function `usb_hcd_unmap_urb_for_dma':
drivers/usb/core/hcd.c:1393: undefined reference to `dma_unmap_sg'
drivers/usb/core/hcd.c:1398: undefined reference to `dma_unmap_page'
drivers/usb/core/hcd.c:1403: undefined reference to `dma_unmap_single'
drivers/built-in.o: In function `usb_hcd_map_urb_for_dma':
drivers/usb/core/hcd.c:1445: undefined reference to `dma_map_single'
drivers/usb/core/hcd.c:1450: undefined reference to `dma_mapping_error'
drivers/usb/core/hcd.c:1480: undefined reference to `dma_map_sg'
drivers/usb/core/hcd.c:1495: undefined reference to `dma_map_page'
drivers/usb/core/hcd.c:1501: undefined reference to `dma_mapping_error'
drivers/usb/core/hcd.c:1507: undefined reference to `dma_map_single'
drivers/usb/core/hcd.c:1512: undefined reference to `dma_mapping_error'
drivers/built-in.o: In function `hcd_buffer_free':
drivers/usb/core/buffer.c:146: undefined reference to `dma_pool_free'
drivers/usb/core/buffer.c:150: undefined reference to `dma_free_coherent'
drivers/built-in.o: In function `hcd_buffer_destroy':
drivers/usb/core/buffer.c:90: undefined reference to `dma_pool_destroy'
drivers/built-in.o: In function `hcd_buffer_create':
drivers/usb/core/buffer.c:65: undefined reference to `dma_pool_create'
drivers/built-in.o: In function `hcd_buffer_alloc':
drivers/usb/core/buffer.c:120: undefined reference to `dma_pool_alloc'
drivers/usb/core/buffer.c:122: undefined reference to `dma_alloc_coherent'
,,,

Commit d9ea21a779278da06d0cbe989594bf542ed213d7 ("usb: host: make
USB_ARCH_HAS_?HCI obsolete") allowed to enable USB on platforms with
NO_DMA=y, and exposed several input and media USB drivers that just select
USB if USB_ARCH_HAS_HCD, without checking HAS_DMA.

Fix the former by making USB depend on HAS_DMA.

To fix the latter, instead of adding lots of "depends on HAS_DMA", make
those drivers depend on USB, instead of depending on USB_ARCH_HAS_HCD and
selecting USB.  Drivers for other busses (e.g. MOUSE_SYNAPTICS_I2C) already
handle this in a similar way.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/input/joystick/Kconfig    |    3 +--
 drivers/input/misc/Kconfig        |   15 +++++----------
 drivers/input/mouse/Kconfig       |    9 +++------
 drivers/input/tablet/Kconfig      |   15 +++++----------
 drivers/input/touchscreen/Kconfig |    3 +--
 drivers/media/rc/Kconfig          |   21 +++++++--------------
 drivers/usb/Kconfig               |    2 +-
 7 files changed, 23 insertions(+), 45 deletions(-)

diff --git a/drivers/input/joystick/Kconfig b/drivers/input/joystick/Kconfig
index 56eb471..d7e36fb 100644
--- a/drivers/input/joystick/Kconfig
+++ b/drivers/input/joystick/Kconfig
@@ -278,8 +278,7 @@ config JOYSTICK_JOYDUMP
 
 config JOYSTICK_XPAD
 	tristate "X-Box gamepad support"
-	depends on USB_ARCH_HAS_HCD
-	select USB
+	depends on USB
 	help
 	  Say Y here if you want to use the X-Box pad with your computer.
 	  Make sure to say Y to "Joystick support" (CONFIG_INPUT_JOYDEV)
diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 0b541cd..00cdecb 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -286,8 +286,7 @@ config INPUT_ATLAS_BTNS
 
 config INPUT_ATI_REMOTE2
 	tristate "ATI / Philips USB RF remote control"
-	depends on USB_ARCH_HAS_HCD
-	select USB
+	depends on USB
 	help
 	  Say Y here if you want to use an ATI or Philips USB RF remote control.
 	  These are RF remotes with USB receivers.
@@ -301,8 +300,7 @@ config INPUT_ATI_REMOTE2
 
 config INPUT_KEYSPAN_REMOTE
 	tristate "Keyspan DMR USB remote control"
-	depends on USB_ARCH_HAS_HCD
-	select USB
+	depends on USB
 	help
 	  Say Y here if you want to use a Keyspan DMR USB remote control.
 	  Currently only the UIA-11 type of receiver has been tested.  The tag
@@ -333,8 +331,7 @@ config INPUT_KXTJ9_POLLED_MODE
 
 config INPUT_POWERMATE
 	tristate "Griffin PowerMate and Contour Jog support"
-	depends on USB_ARCH_HAS_HCD
-	select USB
+	depends on USB
 	help
 	  Say Y here if you want to use Griffin PowerMate or Contour Jog devices.
 	  These are aluminum dials which can measure clockwise and anticlockwise
@@ -349,8 +346,7 @@ config INPUT_POWERMATE
 
 config INPUT_YEALINK
 	tristate "Yealink usb-p1k voip phone"
-	depends on USB_ARCH_HAS_HCD
-	select USB
+	depends on USB
 	help
 	  Say Y here if you want to enable keyboard and LCD functions of the
 	  Yealink usb-p1k usb phones. The audio part is enabled by the generic
@@ -364,8 +360,7 @@ config INPUT_YEALINK
 
 config INPUT_CM109
 	tristate "C-Media CM109 USB I/O Controller"
-	depends on USB_ARCH_HAS_HCD
-	select USB
+	depends on USB
 	help
 	  Say Y here if you want to enable keyboard and buzzer functions of the
 	  C-Media CM109 usb phones. The audio part is enabled by the generic
diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
index effa9c5..90f8c0b 100644
--- a/drivers/input/mouse/Kconfig
+++ b/drivers/input/mouse/Kconfig
@@ -161,8 +161,7 @@ config MOUSE_SERIAL
 
 config MOUSE_APPLETOUCH
 	tristate "Apple USB Touchpad support"
-	depends on USB_ARCH_HAS_HCD
-	select USB
+	depends on USB
 	help
 	  Say Y here if you want to use an Apple USB Touchpad.
 
@@ -182,8 +181,7 @@ config MOUSE_APPLETOUCH
 
 config MOUSE_BCM5974
 	tristate "Apple USB BCM5974 Multitouch trackpad support"
-	depends on USB_ARCH_HAS_HCD
-	select USB
+	depends on USB
 	help
 	  Say Y here if you have an Apple USB BCM5974 Multitouch
 	  trackpad.
@@ -346,8 +344,7 @@ config MOUSE_SYNAPTICS_I2C
 
 config MOUSE_SYNAPTICS_USB
 	tristate "Synaptics USB device support"
-	depends on USB_ARCH_HAS_HCD
-	select USB
+	depends on USB
 	help
 	  Say Y here if you want to use a Synaptics USB touchpad or pointing
 	  stick.
diff --git a/drivers/input/tablet/Kconfig b/drivers/input/tablet/Kconfig
index bed7cbf..8e27600 100644
--- a/drivers/input/tablet/Kconfig
+++ b/drivers/input/tablet/Kconfig
@@ -13,8 +13,7 @@ if INPUT_TABLET
 
 config TABLET_USB_ACECAD
 	tristate "Acecad Flair tablet support (USB)"
-	depends on USB_ARCH_HAS_HCD
-	select USB
+	depends on USB
 	help
 	  Say Y here if you want to use the USB version of the Acecad Flair
 	  tablet.  Make sure to say Y to "Mouse support"
@@ -26,8 +25,7 @@ config TABLET_USB_ACECAD
 
 config TABLET_USB_AIPTEK
 	tristate "Aiptek 6000U/8000U and Genius G_PEN tablet support (USB)"
-	depends on USB_ARCH_HAS_HCD
-	select USB
+	depends on USB
 	help
 	  Say Y here if you want to use the USB version of the Aiptek 6000U,
 	  Aiptek 8000U or Genius G-PEN 560 tablet.  Make sure to say Y to
@@ -51,8 +49,7 @@ config TABLET_USB_GTCO
 
 config TABLET_USB_HANWANG
 	tristate "Hanwang Art Master III tablet support (USB)"
-	depends on USB_ARCH_HAS_HCD
-	select USB
+	depends on USB
 	help
 	  Say Y here if you want to use the USB version of the Hanwang Art
 	  Master III tablet.
@@ -62,8 +59,7 @@ config TABLET_USB_HANWANG
 
 config TABLET_USB_KBTAB
 	tristate "KB Gear JamStudio tablet support (USB)"
-	depends on USB_ARCH_HAS_HCD
-	select USB
+	depends on USB
 	help
 	  Say Y here if you want to use the USB version of the KB Gear
 	  JamStudio tablet.  Make sure to say Y to "Mouse support"
@@ -75,9 +71,8 @@ config TABLET_USB_KBTAB
 
 config TABLET_USB_WACOM
 	tristate "Wacom Intuos/Graphire tablet support (USB)"
-	depends on USB_ARCH_HAS_HCD
+	depends on USB
 	select POWER_SUPPLY
-	select USB
 	select NEW_LEDS
 	select LEDS_CLASS
 	help
diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 3b9758b..a889c52 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -689,8 +689,7 @@ config TOUCHSCREEN_WM97XX_ZYLONITE
 
 config TOUCHSCREEN_USB_COMPOSITE
 	tristate "USB Touchscreen Driver"
-	depends on USB_ARCH_HAS_HCD
-	select USB
+	depends on USB
 	help
 	  USB Touchscreen driver for:
 	  - eGalax Touchkit USB (also includes eTurboTouch CT-410/510/700)
diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 5a79c33..ee59842 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -126,9 +126,8 @@ if RC_DEVICES
 
 config RC_ATI_REMOTE
 	tristate "ATI / X10 based USB RF remote controls"
-	depends on USB_ARCH_HAS_HCD
+	depends on USB
 	depends on RC_CORE
-	select USB
 	help
 	   Say Y here if you want to use an X10 based USB remote control.
 	   These are RF remotes with USB receivers.
@@ -159,9 +158,8 @@ config IR_ENE
 
 config IR_IMON
 	tristate "SoundGraph iMON Receiver and Display"
-	depends on USB_ARCH_HAS_HCD
+	depends on USB
 	depends on RC_CORE
-	select USB
 	---help---
 	   Say Y here if you want to use a SoundGraph iMON (aka Antec Veris)
 	   IR Receiver and/or LCD/VFD/VGA display.
@@ -171,9 +169,8 @@ config IR_IMON
 
 config IR_MCEUSB
 	tristate "Windows Media Center Ed. eHome Infrared Transceiver"
-	depends on USB_ARCH_HAS_HCD
+	depends on USB
 	depends on RC_CORE
-	select USB
 	---help---
 	   Say Y here if you want to use a Windows Media Center Edition
 	   eHome Infrared Transceiver.
@@ -221,9 +218,8 @@ config IR_NUVOTON
 
 config IR_REDRAT3
 	tristate "RedRat3 IR Transceiver"
-	depends on USB_ARCH_HAS_HCD
+	depends on USB
 	depends on RC_CORE
-	select USB
 	---help---
 	   Say Y here if you want to use a RedRat3 Infrared Transceiver.
 
@@ -232,9 +228,8 @@ config IR_REDRAT3
 
 config IR_STREAMZAP
 	tristate "Streamzap PC Remote IR Receiver"
-	depends on USB_ARCH_HAS_HCD
+	depends on USB
 	depends on RC_CORE
-	select USB
 	---help---
 	   Say Y here if you want to use a Streamzap PC Remote
 	   Infrared Receiver.
@@ -261,9 +256,8 @@ config IR_WINBOND_CIR
 
 config IR_IGUANA
 	tristate "IguanaWorks USB IR Transceiver"
-	depends on USB_ARCH_HAS_HCD
+	depends on USB
 	depends on RC_CORE
-	select USB
 	---help---
 	   Say Y here if you want to use the IguanaWorks USB IR Transceiver.
 	   Both infrared receive and send are supported. If you want to
@@ -277,9 +271,8 @@ config IR_IGUANA
 
 config IR_TTUSBIR
 	tristate "TechnoTrend USB IR Receiver"
-	depends on USB_ARCH_HAS_HCD
+	depends on USB
 	depends on RC_CORE
-	select USB
 	select NEW_LEDS
 	select LEDS_CLASS
 	---help---
diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
index 73f62ca..c530ad9 100644
--- a/drivers/usb/Kconfig
+++ b/drivers/usb/Kconfig
@@ -33,7 +33,7 @@ config USB_ARCH_HAS_HCD
 # ARM SA1111 chips have a non-PCI based "OHCI-compatible" USB host interface.
 config USB
 	tristate "Support for Host-side USB"
-	depends on USB_ARCH_HAS_HCD
+	depends on USB_ARCH_HAS_HCD && HAS_DMA
 	select NLS  # for UTF-8 strings
 	---help---
 	  Universal Serial Bus (USB) is a specification for a serial bus
-- 
1.7.9.5

