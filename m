Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424Ab3ARGok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 01:44:40 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:57370 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab3ARGof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 01:44:35 -0500
From: Joe Millenbach <jmillenbach@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Jiri Slaby <jirislaby@gmail.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Joe Millenbach <jmillenbach@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>, Jamey Sharp <jamey@minilop.net>
Subject: [PATCHv4] tty: Added a CONFIG_TTY option to allow removal of TTY
Date: Thu, 17 Jan 2013 22:44:22 -0800
Message-Id: <1358491462-16562-1-git-send-email-jmillenbach@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The option allows you to remove TTY and compile without errors. This
saves space on systems that won't support TTY interfaces anyway.
bloat-o-meter output is below.

The bulk of this patch consists of Kconfig changes adding "depends on
TTY" to various serial devices and similar drivers that require the TTY
layer.  Ideally, these dependencies would occur on a common intermediate
symbol such as SERIO, but most drivers "select SERIO" rather than
"depends on SERIO", and "select" does not respect dependencies.

bloat-o-meter output comparing our previous minimal to new minimal by
removing TTY.  The list is filtered to not show removed entries with awk
'$3 != "-"' as the list was very long.

add/remove: 0/226 grow/shrink: 2/14 up/down: 6/-35356 (-35350)
function                                     old     new   delta
chr_dev_init                                 166     170      +4
allow_signal                                  80      82      +2
static.__warned                              143     142      -1
disallow_signal                               63      62      -1
__set_special_pids                            95      94      -1
unregister_console                           126     121      -5
start_kernel                                 546     541      -5
register_console                             593     588      -5
copy_from_user                                45      40      -5
sys_setsid                                   128     120      -8
sys_vhangup                                   32      19     -13
do_exit                                     1543    1526     -17
bitmap_zero                                   60      40     -20
arch_local_irq_save                          137     117     -20
release_task                                 674     652     -22
static.spin_unlock_irqrestore                308     260     -48

Signed-off-by: Joe Millenbach <jmillenbach@gmail.com>
Reviewed-by: Jamey Sharp <jamey@minilop.net>
---
v4: Rebasing to 3.8 rc to allow longer testing as requested by Greg
    Kroah-Hartman, and applying same checks as in v3 to new code as
    requested by Jiri Slaby.
v3: Incorporated feedback from Jiri Slaby: fixed compilation issues on non
    x86/x64 platforms by finding all calls to alloc_tty_driver and
    tty_alloc_driver, then added "depends on" or "selects" TTY to config
    options that enabled compilation of those files.  Also rebased to newer
    kernel sources.
v2: Incorporated feedback from Alan Cox: used "if TTY ... endif" to wrap
    long runs of symbols that all need "depends on TTY"; grouped all the
    stubbed-out functions together in linux/tty.h.
---
 arch/alpha/Kconfig                  |    2 ++
 arch/ia64/hp/sim/Kconfig            |    1 +
 arch/m68k/Kconfig.devices           |    2 +-
 arch/parisc/Kconfig                 |    1 +
 arch/tile/Kconfig                   |    1 +
 arch/um/Kconfig.common              |    1 +
 arch/xtensa/Kconfig                 |    1 +
 drivers/bluetooth/Kconfig           |    1 +
 drivers/char/Kconfig                |    7 +++---
 drivers/char/pcmcia/Kconfig         |    4 ++--
 drivers/i2c/busses/Kconfig          |    2 +-
 drivers/input/joystick/Kconfig      |    4 ++++
 drivers/input/keyboard/Kconfig      |   10 +++++++-
 drivers/input/mouse/Kconfig         |    3 +++
 drivers/input/serio/Kconfig         |    1 +
 drivers/input/touchscreen/Kconfig   |   22 ++++++++++++++++++
 drivers/ipack/devices/Kconfig       |    2 +-
 drivers/isdn/Kconfig                |    1 +
 drivers/isdn/capi/Kconfig           |    1 +
 drivers/isdn/gigaset/Kconfig        |    1 +
 drivers/isdn/hardware/mISDN/Kconfig |    1 +
 drivers/lguest/Kconfig              |    2 +-
 drivers/media/radio/wl128x/Kconfig  |    2 +-
 drivers/misc/Kconfig                |    2 +-
 drivers/misc/ti-st/Kconfig          |    2 +-
 drivers/mmc/card/Kconfig            |    1 +
 drivers/net/caif/Kconfig            |    2 +-
 drivers/net/can/Kconfig             |    2 +-
 drivers/net/hamradio/Kconfig        |    4 ++--
 drivers/net/irda/Kconfig            |    2 +-
 drivers/net/ppp/Kconfig             |    3 +++
 drivers/net/slip/Kconfig            |    1 +
 drivers/net/usb/Kconfig             |    4 ++--
 drivers/net/wan/Kconfig             |    2 +-
 drivers/pps/clients/Kconfig         |    2 +-
 drivers/s390/char/Kconfig           |    8 +++----
 drivers/staging/ccg/Kconfig         |    2 +-
 drivers/staging/dgrp/Kconfig        |    2 +-
 drivers/staging/fwserial/Kconfig    |    2 +-
 drivers/staging/sb105x/Kconfig      |    2 +-
 drivers/tty/Kconfig                 |   13 +++++++++++
 drivers/tty/Makefile                |    2 +-
 drivers/tty/hvc/Kconfig             |    3 +++
 drivers/tty/serial/Kconfig          |    4 ++++
 drivers/usb/class/Kconfig           |    2 +-
 drivers/usb/gadget/Kconfig          |    6 +++++
 drivers/usb/serial/Kconfig          |    2 +-
 fs/proc/Makefile                    |    3 ++-
 include/linux/console.h             |    5 ++++
 include/linux/proc_fs.h             |    5 ++++
 include/linux/tty.h                 |   44 ++++++++++++++++++++++++++---------
 lib/Kconfig.kgdb                    |    1 +
 net/bluetooth/rfcomm/Kconfig        |    1 +
 net/irda/ircomm/Kconfig             |    2 +-
 sound/soc/codecs/Kconfig            |    3 ++-
 55 files changed, 165 insertions(+), 47 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 9d5904c..1ef196d 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -125,6 +125,7 @@ choice
 
 config ALPHA_GENERIC
 	bool "Generic"
+	depends on TTY
 	help
 	  A generic kernel will run on all supported Alpha hardware.
 
@@ -491,6 +492,7 @@ config VGA_HOSE
 
 config ALPHA_SRM
 	bool "Use SRM as bootloader" if ALPHA_CABRIOLET || ALPHA_AVANTI_CH || ALPHA_EB64P || ALPHA_PC164 || ALPHA_TAKARA || ALPHA_EB164 || ALPHA_ALCOR || ALPHA_MIATA || ALPHA_LX164 || ALPHA_SX164 || ALPHA_NAUTILUS || ALPHA_NONAME
+	depends on TTY
 	default y if ALPHA_JENSEN || ALPHA_MIKASA || ALPHA_SABLE || ALPHA_LYNX || ALPHA_NORITAKE || ALPHA_DP264 || ALPHA_RAWHIDE || ALPHA_EIGER || ALPHA_WILDFIRE || ALPHA_TITAN || ALPHA_SHARK || ALPHA_MARVEL
 	---help---
 	  There are two different types of booting firmware on Alphas: SRM,
diff --git a/arch/ia64/hp/sim/Kconfig b/arch/ia64/hp/sim/Kconfig
index 8d513a8..d84707d 100644
--- a/arch/ia64/hp/sim/Kconfig
+++ b/arch/ia64/hp/sim/Kconfig
@@ -8,6 +8,7 @@ config HP_SIMETH
 
 config HP_SIMSERIAL
 	bool "Simulated serial driver support"
+	depends on TTY
 
 config HP_SIMSERIAL_CONSOLE
 	bool "Console for HP simulator"
diff --git a/arch/m68k/Kconfig.devices b/arch/m68k/Kconfig.devices
index c4cdfe4..4bc945d 100644
--- a/arch/m68k/Kconfig.devices
+++ b/arch/m68k/Kconfig.devices
@@ -41,7 +41,7 @@ config NFBLOCK
 
 config NFCON
 	tristate "NatFeat console driver"
-	depends on NATFEAT
+	depends on TTY && NATFEAT
 	help
 	  Say Y to include support for the ARAnyM NatFeat console driver
 	  which allows the console output to be redirected to the stderr
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index b77feff..df5beb6 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -23,6 +23,7 @@ config PARISC
 	select HAVE_MOD_ARCH_SPECIFIC
 	select MODULES_USE_ELF_RELA
 	select CLONE_BACKWARDS
+	select TTY # Needed for pdc_cons.c
 
 	help
 	  The PA-RISC microprocessor is designed by Hewlett-Packard and used
diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 875d008..ae8a7ca 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -121,6 +121,7 @@ config DEBUG_COPY_FROM_USER
 	def_bool n
 
 config HVC_TILE
+	depends on TTY
 	select HVC_DRIVER
 	def_bool y
 
diff --git a/arch/um/Kconfig.common b/arch/um/Kconfig.common
index 648121b..bceee66 100644
--- a/arch/um/Kconfig.common
+++ b/arch/um/Kconfig.common
@@ -12,6 +12,7 @@ config UML
 	select GENERIC_CPU_DEVICES
 	select GENERIC_IO
 	select GENERIC_CLOCKEVENTS
+	select TTY # Needed for line.c
 
 config MMU
 	bool
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index 5aab1ac..ad64c73 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -132,6 +132,7 @@ choice
 
 config XTENSA_PLATFORM_ISS
 	bool "ISS"
+	depends on TTY
 	select XTENSA_CALIBRATE_CCOUNT
 	select SERIAL_CONSOLE
 	select XTENSA_ISS_NETWORK
diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
index e9f203e..fdfd61a 100644
--- a/drivers/bluetooth/Kconfig
+++ b/drivers/bluetooth/Kconfig
@@ -26,6 +26,7 @@ config BT_HCIBTSDIO
 
 config BT_HCIUART
 	tristate "HCI UART driver"
+	depends on TTY
 	help
 	  Bluetooth HCI UART driver.
 	  This driver is required if you want to use Bluetooth devices with
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 72bedad..3bb6fa3 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -53,7 +53,7 @@ source "drivers/tty/serial/Kconfig"
 
 config TTY_PRINTK
 	bool "TTY driver to output user messages via printk"
-	depends on EXPERT
+	depends on EXPERT && TTY
 	default n
 	---help---
 	  If you say Y here, the support for writing user messages (i.e.
@@ -159,7 +159,7 @@ source "drivers/tty/hvc/Kconfig"
 
 config VIRTIO_CONSOLE
 	tristate "Virtio console"
-	depends on VIRTIO
+	depends on VIRTIO && TTY
 	select HVC_DRIVER
 	help
 	  Virtio console for use with lguest and other hypervisors.
@@ -392,6 +392,7 @@ config XILINX_HWICAP
 
 config R3964
 	tristate "Siemens R3964 line discipline"
+	depends on TTY
 	---help---
 	  This driver allows synchronous communication with devices using the
 	  Siemens R3964 packet protocol. Unless you are dealing with special
@@ -439,7 +440,7 @@ source "drivers/char/pcmcia/Kconfig"
 
 config MWAVE
 	tristate "ACP Modem (Mwave) support"
-	depends on X86
+	depends on X86 && TTY
 	select SERIAL_8250
 	---help---
 	  The ACP modem (Mwave) for Linux is a WinModem. It is composed of a
diff --git a/drivers/char/pcmcia/Kconfig b/drivers/char/pcmcia/Kconfig
index 6614416..2a166d5 100644
--- a/drivers/char/pcmcia/Kconfig
+++ b/drivers/char/pcmcia/Kconfig
@@ -7,7 +7,7 @@ menu "PCMCIA character devices"
 
 config SYNCLINK_CS
 	tristate "SyncLink PC Card support"
-	depends on PCMCIA
+	depends on PCMCIA && TTY
 	help
 	  Enable support for the SyncLink PC Card serial adapter, running
 	  asynchronous and HDLC communications up to 512Kbps. The port is
@@ -45,7 +45,7 @@ config CARDMAN_4040
 
 config IPWIRELESS
 	tristate "IPWireless 3G UMTS PCMCIA card support"
-	depends on PCMCIA && NETDEVICES
+	depends on PCMCIA && NETDEVICES && TTY
 	select PPP
 	help
 	  This is a driver for 3G UMTS PCMCIA card from IPWireless company. In
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index bdca511..cf474b2 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -803,7 +803,7 @@ config I2C_PARPORT_LIGHT
 
 config I2C_TAOS_EVM
 	tristate "TAOS evaluation module"
-	depends on EXPERIMENTAL
+	depends on EXPERIMENTAL && TTY
 	select SERIO
 	select SERIO_SERPORT
 	default n
diff --git a/drivers/input/joystick/Kconfig b/drivers/input/joystick/Kconfig
index 56eb471..055bcab 100644
--- a/drivers/input/joystick/Kconfig
+++ b/drivers/input/joystick/Kconfig
@@ -132,6 +132,8 @@ config JOYSTICK_TMDC
 
 source "drivers/input/joystick/iforce/Kconfig"
 
+if TTY
+
 config JOYSTICK_WARRIOR
 	tristate "Logitech WingMan Warrior joystick"
 	select SERIO
@@ -205,6 +207,8 @@ config JOYSTICK_ZHENHUA
 	  To compile this driver as a module, choose M here: the
 	  module will be called zhenhua.
 
+endif # TTY
+
 config JOYSTICK_DB9
 	tristate "Multisystem, Sega Genesis, Saturn joysticks and gamepads"
 	depends on PARPORT
diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index 5a240c6..008f96a 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -69,6 +69,7 @@ config KEYBOARD_ATARI
 config KEYBOARD_ATKBD
 	tristate "AT keyboard" if EXPERT || !X86
 	default y
+	depends on TTY
 	select SERIO
 	select SERIO_LIBPS2
 	select SERIO_I8042 if X86
@@ -153,6 +154,7 @@ config KEYBOARD_BFIN
 
 config KEYBOARD_LKKBD
 	tristate "DECstation/VAXstation LK201/LK401 keyboard"
+	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you want to use a LK201 or LK401 style serial
@@ -268,7 +270,7 @@ config KEYBOARD_HIL_OLD
 
 config KEYBOARD_HIL
 	tristate "HP HIL keyboard/pointer support"
-	depends on GSC || HP300
+	depends on (GSC || HP300) && TTY
 	default y
 	select HP_SDC
 	select HIL_MLC
@@ -400,6 +402,7 @@ config KEYBOARD_IMX
 
 config KEYBOARD_NEWTON
 	tristate "Newton keyboard"
+	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you have a Newton keyboard on a serial port.
@@ -479,6 +482,8 @@ config KEYBOARD_SAMSUNG
 	  To compile this driver as a module, choose M here: the
 	  module will be called samsung-keypad.
 
+if TTY
+
 config KEYBOARD_STOWAWAY
 	tristate "Stowaway keyboard"
 	select SERIO
@@ -501,6 +506,8 @@ config KEYBOARD_SUNKBD
 	  To compile this driver as a module, choose M here: the
 	  module will be called sunkbd.
 
+endif # TTY
+
 config KEYBOARD_SH_KEYSC
 	tristate "SuperH KEYSC keypad support"
 	depends on SUPERH || ARCH_SHMOBILE
@@ -597,6 +604,7 @@ config KEYBOARD_TWL4030
 
 config KEYBOARD_XTKBD
 	tristate "XT keyboard"
+	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you want to use the old IBM PC/XT keyboard (or
diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
index cd6268c..fc160f7 100644
--- a/drivers/input/mouse/Kconfig
+++ b/drivers/input/mouse/Kconfig
@@ -14,6 +14,7 @@ if INPUT_MOUSE
 
 config MOUSE_PS2
 	tristate "PS/2 mouse"
+	depends on TTY
 	default y
 	select SERIO
 	select SERIO_LIBPS2
@@ -138,6 +139,7 @@ config MOUSE_PS2_OLPC
 
 config MOUSE_SERIAL
 	tristate "Serial mouse"
+	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you have a serial (RS-232, COM port) mouse connected
@@ -262,6 +264,7 @@ config MOUSE_RISCPC
 
 config MOUSE_VSXXXAA
 	tristate "DEC VSXXX-AA/GA mouse and VSXXX-AB tablet"
+	depends on TTY
 	select SERIO
 	help
 	  Say Y (or M) if you want to use a DEC VSXXX-AA (hockey
diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
index 4a4e182..81ee755 100644
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -4,6 +4,7 @@
 config SERIO
 	tristate "Serial I/O support" if EXPERT || !X86
 	default y
+	depends on TTY
 	help
 	  Say Yes here if you have any input device that uses serial I/O to
 	  communicate with the system. This includes the
diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 515cfe7..3d6f548 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -192,6 +192,8 @@ config TOUCHSCREEN_DA9052
 	  To compile this driver as a module, choose M here: the
 	  module will be called da9052_tsi.
 
+if TTY
+
 config TOUCHSCREEN_DYNAPRO
 	tristate "Dynapro serial touchscreen"
 	select SERIO
@@ -216,6 +218,8 @@ config TOUCHSCREEN_HAMPSHIRE
 	  To compile this driver as a module, choose M here: the
 	  module will be called hampshire.
 
+endif # TTY
+
 config TOUCHSCREEN_EETI
 	tristate "EETI touchscreen panel support"
 	depends on I2C
@@ -237,6 +241,7 @@ config TOUCHSCREEN_EGALAX
 
 config TOUCHSCREEN_FUJITSU
 	tristate "Fujitsu serial touchscreen"
+	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you have the Fujitsu touchscreen (such as one
@@ -275,6 +280,8 @@ config TOUCHSCREEN_S3C2410
 	  To compile this driver as a module, choose M here: the
 	  module will be called s3c2410_ts.
 
+if TTY
+
 config TOUCHSCREEN_GUNZE
 	tristate "Gunze AHL-51S touchscreen"
 	select SERIO
@@ -311,6 +318,8 @@ config TOUCHSCREEN_WACOM_W8001
 	  To compile this driver as a module, choose M here: the
 	  module will be called wacom_w8001.
 
+endif # TTY
+
 config TOUCHSCREEN_WACOM_I2C
 	tristate "Wacom Tablet support (I2C)"
 	depends on I2C
@@ -369,6 +378,8 @@ config TOUCHSCREEN_MMS114
 	  To compile this driver as a module, choose M here: the
 	  module will be called mms114.
 
+if TTY
+
 config TOUCHSCREEN_MTOUCH
 	tristate "MicroTouch serial touchscreens"
 	select SERIO
@@ -393,6 +404,8 @@ config TOUCHSCREEN_INEXIO
 	  To compile this driver as a module, choose M here: the
 	  module will be called inexio.
 
+endif # TTY
+
 config TOUCHSCREEN_INTEL_MID
 	tristate "Intel MID platform resistive touchscreen"
 	depends on INTEL_SCU_IPC
@@ -450,6 +463,7 @@ config TOUCHSCREEN_HTCPEN
 
 config TOUCHSCREEN_PENMOUNT
 	tristate "Penmount serial touchscreen"
+	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you have a Penmount serial touchscreen connected to
@@ -493,6 +507,8 @@ config TOUCHSCREEN_TNETV107X
 	  To compile this driver as a module, choose M here: the
 	  module will be called tnetv107x-ts.
 
+if TTY
+
 config TOUCHSCREEN_TOUCHRIGHT
 	tristate "Touchright serial touchscreen"
 	select SERIO
@@ -517,6 +533,8 @@ config TOUCHSCREEN_TOUCHWIN
 	  To compile this driver as a module, choose M here: the
 	  module will be called touchwin.
 
+endif # TTY
+
 config TOUCHSCREEN_TI_AM335X_TSC
 	tristate "TI Touchscreen Interface"
 	depends on MFD_TI_AM335X_TSCADC
@@ -790,6 +808,8 @@ config TOUCHSCREEN_USB_EASYTOUCH
 	  Say Y here if you have an EasyTouch USB Touch controller.
 	  If unsure, say N.
 
+if TTY
+
 config TOUCHSCREEN_TOUCHIT213
 	tristate "Sahara TouchIT-213 touchscreen"
 	select SERIO
@@ -813,6 +833,8 @@ config TOUCHSCREEN_TSC_SERIO
 	  To compile this driver as a module, choose M here: the
 	  module will be called tsc40.
 
+endif # TTY
+
 config TOUCHSCREEN_TSC2005
         tristate "TSC2005 based touchscreens"
         depends on SPI_MASTER && GENERIC_HARDIRQS
diff --git a/drivers/ipack/devices/Kconfig b/drivers/ipack/devices/Kconfig
index 0b82fdc..907a8cb 100644
--- a/drivers/ipack/devices/Kconfig
+++ b/drivers/ipack/devices/Kconfig
@@ -1,6 +1,6 @@
 config SERIAL_IPOCTAL
 	tristate "IndustryPack IP-OCTAL uart support"
-	depends on IPACK_BUS
+	depends on IPACK_BUS && TTY
 	help
 	  This driver supports the IPOCTAL serial port device for the IndustryPack bus.
 	default n
diff --git a/drivers/isdn/Kconfig b/drivers/isdn/Kconfig
index 86cd75a..ef661ac 100644
--- a/drivers/isdn/Kconfig
+++ b/drivers/isdn/Kconfig
@@ -22,6 +22,7 @@ if ISDN
 
 menuconfig ISDN_I4L
 	tristate "Old ISDN4Linux (deprecated)"
+	depends on TTY
 	---help---
 	  This driver allows you to use an ISDN adapter for networking
 	  connections and as dialin/out device.  The isdn-tty's have a built
diff --git a/drivers/isdn/capi/Kconfig b/drivers/isdn/capi/Kconfig
index 15c3ffd..f046865 100644
--- a/drivers/isdn/capi/Kconfig
+++ b/drivers/isdn/capi/Kconfig
@@ -18,6 +18,7 @@ config CAPI_TRACE
 
 config ISDN_CAPI_MIDDLEWARE
 	bool "CAPI2.0 Middleware support"
+	depends on TTY
 	help
 	  This option will enhance the capabilities of the /dev/capi20
 	  interface.  It will provide a means of moving a data connection,
diff --git a/drivers/isdn/gigaset/Kconfig b/drivers/isdn/gigaset/Kconfig
index b18a92c..dde5e09 100644
--- a/drivers/isdn/gigaset/Kconfig
+++ b/drivers/isdn/gigaset/Kconfig
@@ -1,5 +1,6 @@
 menuconfig ISDN_DRV_GIGASET
 	tristate "Siemens Gigaset support"
+	depends on TTY
 	select CRC_CCITT
 	select BITREVERSE
 	help
diff --git a/drivers/isdn/hardware/mISDN/Kconfig b/drivers/isdn/hardware/mISDN/Kconfig
index eadc1cd..b8611e3 100644
--- a/drivers/isdn/hardware/mISDN/Kconfig
+++ b/drivers/isdn/hardware/mISDN/Kconfig
@@ -76,6 +76,7 @@ config MISDN_NETJET
 	tristate "Support for NETJet cards"
 	depends on MISDN
 	depends on PCI
+	depends on TTY
 	select MISDN_IPAC
 	select ISDN_HDLC
 	select ISDN_I4L
diff --git a/drivers/lguest/Kconfig b/drivers/lguest/Kconfig
index 34ae49d..f9c4314 100644
--- a/drivers/lguest/Kconfig
+++ b/drivers/lguest/Kconfig
@@ -1,6 +1,6 @@
 config LGUEST
 	tristate "Linux hypervisor example code"
-	depends on X86_32 && EXPERIMENTAL && EVENTFD
+	depends on X86_32 && EXPERIMENTAL && EVENTFD && TTY
 	select HVC_DRIVER
 	---help---
 	  This is a very simple module which allows you to run
diff --git a/drivers/media/radio/wl128x/Kconfig b/drivers/media/radio/wl128x/Kconfig
index ea1e654..f359be7 100644
--- a/drivers/media/radio/wl128x/Kconfig
+++ b/drivers/media/radio/wl128x/Kconfig
@@ -4,7 +4,7 @@
 menu "Texas Instruments WL128x FM driver (ST based)"
 config RADIO_WL128X
 	tristate "Texas Instruments WL128x FM Radio"
-	depends on VIDEO_V4L2 && RFKILL && GPIOLIB
+	depends on VIDEO_V4L2 && RFKILL && GPIOLIB && TTY
 	select TI_ST if NET
 	help
 	Choose Y here if you have this FM radio chip.
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index b151b7c..4b2bb93 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -127,7 +127,7 @@ config PHANTOM
 
 config INTEL_MID_PTI
 	tristate "Parallel Trace Interface for MIPI P1149.7 cJTAG standard"
-	depends on PCI
+	depends on PCI && TTY
 	default n
 	help
 	  The PTI (Parallel Trace Interface) driver directs
diff --git a/drivers/misc/ti-st/Kconfig b/drivers/misc/ti-st/Kconfig
index abb5de1..f34dcc5 100644
--- a/drivers/misc/ti-st/Kconfig
+++ b/drivers/misc/ti-st/Kconfig
@@ -5,7 +5,7 @@
 menu "Texas Instruments shared transport line discipline"
 config TI_ST
 	tristate "Shared transport core driver"
-	depends on NET && GPIOLIB
+	depends on NET && GPIOLIB && TTY
 	select FW_LOADER
 	help
 	  This enables the shared transport core driver for TI
diff --git a/drivers/mmc/card/Kconfig b/drivers/mmc/card/Kconfig
index 3b1f783..5562308 100644
--- a/drivers/mmc/card/Kconfig
+++ b/drivers/mmc/card/Kconfig
@@ -52,6 +52,7 @@ config MMC_BLOCK_BOUNCE
 
 config SDIO_UART
 	tristate "SDIO UART/GPS class support"
+	depends on TTY
 	help
 	  SDIO function driver for SDIO cards that implements the UART
 	  class, as well as the GPS class which appears like a UART.
diff --git a/drivers/net/caif/Kconfig b/drivers/net/caif/Kconfig
index abf4d7a..60c2142 100644
--- a/drivers/net/caif/Kconfig
+++ b/drivers/net/caif/Kconfig
@@ -6,7 +6,7 @@ comment "CAIF transport drivers"
 
 config CAIF_TTY
 	tristate "CAIF TTY transport driver"
-	depends on CAIF
+	depends on CAIF && TTY
 	default n
 	---help---
 	The CAIF TTY transport driver is a Line Discipline (ldisc)
diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index b56bd9e..72df3a3 100644
--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -13,7 +13,7 @@ config CAN_VCAN
 
 config CAN_SLCAN
 	tristate "Serial / USB serial CAN Adaptors (slcan)"
-	depends on CAN
+	depends on CAN && TTY
 	---help---
 	  CAN driver for several 'low cost' CAN interfaces that are attached
 	  via serial lines or via USB-to-serial adapters using the LAWICEL
diff --git a/drivers/net/hamradio/Kconfig b/drivers/net/hamradio/Kconfig
index 95dbcfd..bf5e596 100644
--- a/drivers/net/hamradio/Kconfig
+++ b/drivers/net/hamradio/Kconfig
@@ -1,6 +1,6 @@
 config MKISS
 	tristate "Serial port KISS driver"
-	depends on AX25
+	depends on AX25 && TTY
 	select CRC16
 	---help---
 	  KISS is a protocol used for the exchange of data between a computer
@@ -18,7 +18,7 @@ config MKISS
 
 config 6PACK
 	tristate "Serial port 6PACK driver"
-	depends on AX25
+	depends on AX25 && TTY
 	---help---
 	  6pack is a transmission protocol for the data exchange between your
 	  PC and your TNC (the Terminal Node Controller acts as a kind of
diff --git a/drivers/net/irda/Kconfig b/drivers/net/irda/Kconfig
index 5952054..e1454cd 100644
--- a/drivers/net/irda/Kconfig
+++ b/drivers/net/irda/Kconfig
@@ -5,7 +5,7 @@ comment "SIR device drivers"
 
 config IRTTY_SIR
 	tristate "IrTTY (uses Linux serial driver)"
-	depends on IRDA
+	depends on IRDA && TTY
 	help
 	  Say Y here if you want to build support for the IrTTY line
 	  discipline.  To compile it as a module, choose M here: the module
diff --git a/drivers/net/ppp/Kconfig b/drivers/net/ppp/Kconfig
index 872df3e..3d9ef4f 100644
--- a/drivers/net/ppp/Kconfig
+++ b/drivers/net/ppp/Kconfig
@@ -147,6 +147,7 @@ config PPPOL2TP
 	  Support for PPP-over-L2TP socket family. L2TP is a protocol
 	  used by ISPs and enterprises to tunnel PPP traffic over UDP
 	  tunnels. L2TP is replacing PPTP for VPN uses.
+if TTY
 
 config PPP_ASYNC
 	tristate "PPP support for async serial ports"
@@ -172,4 +173,6 @@ config PPP_SYNC_TTY
 
 	  To compile this driver as a module, choose M here.
 
+endif # TTY
+
 endif # PPP
diff --git a/drivers/net/slip/Kconfig b/drivers/net/slip/Kconfig
index 211b160..48e6871 100644
--- a/drivers/net/slip/Kconfig
+++ b/drivers/net/slip/Kconfig
@@ -4,6 +4,7 @@
 
 config SLIP
 	tristate "SLIP (serial line) support"
+	depends on TTY
 	---help---
 	  Say Y if you intend to use SLIP or CSLIP (compressed SLIP) to
 	  connect to your Internet service provider or to connect to some
diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index ef97621..bd33153 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -445,7 +445,7 @@ config USB_NET_QMI_WWAN
 
 config USB_HSO
 	tristate "Option USB High Speed Mobile Devices"
-	depends on USB && RFKILL
+	depends on USB && RFKILL && TTY
 	default n
 	help
 	  Choose this option if you have an Option HSDPA/HSUPA card.
@@ -493,7 +493,7 @@ config USB_SIERRA_NET
 
 config USB_VL600
 	tristate "LG VL600 modem dongle"
-	depends on USB_NET_CDCETHER
+	depends on USB_NET_CDCETHER && TTY
 	select USB_ACM
 	help
 	  Select this if you want to use an LG Electronics 4G/LTE usb modem
diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
index d58431e..61eb899 100644
--- a/drivers/net/wan/Kconfig
+++ b/drivers/net/wan/Kconfig
@@ -429,7 +429,7 @@ config LAPBETHER
 
 config X25_ASY
 	tristate "X.25 async driver (EXPERIMENTAL)"
-	depends on LAPB && X25
+	depends on LAPB && X25 && TTY
 	---help---
 	  Send and receive X.25 frames over regular asynchronous serial
 	  lines such as telephone lines equipped with ordinary modems.
diff --git a/drivers/pps/clients/Kconfig b/drivers/pps/clients/Kconfig
index 445197d..6efd9b6 100644
--- a/drivers/pps/clients/Kconfig
+++ b/drivers/pps/clients/Kconfig
@@ -17,7 +17,7 @@ config PPS_CLIENT_KTIMER
 
 config PPS_CLIENT_LDISC
 	tristate "PPS line discipline"
-	depends on PPS
+	depends on PPS && TTY
 	help
 	  If you say yes here you get support for a PPS source connected
 	  with the CD (Carrier Detect) pin of your serial port.
diff --git a/drivers/s390/char/Kconfig b/drivers/s390/char/Kconfig
index 2c9a776..71bf959 100644
--- a/drivers/s390/char/Kconfig
+++ b/drivers/s390/char/Kconfig
@@ -11,7 +11,7 @@ config TN3270
 config TN3270_TTY
 	def_tristate y
 	prompt "Support for tty input/output on 3270 terminals"
-	depends on TN3270
+	depends on TN3270 && TTY
 	help
 	  Include support for using an IBM 3270 terminal as a Linux tty.
 
@@ -33,7 +33,7 @@ config TN3270_CONSOLE
 config TN3215
 	def_bool y
 	prompt "Support for 3215 line mode terminal"
-	depends on CCW
+	depends on CCW && TTY
 	help
 	  Include support for IBM 3215 line-mode terminals.
 
@@ -51,7 +51,7 @@ config CCW_CONSOLE
 config SCLP_TTY
 	def_bool y
 	prompt "Support for SCLP line mode terminal"
-	depends on S390
+	depends on S390 && TTY
 	help
 	  Include support for IBM SCLP line-mode terminals.
 
@@ -66,7 +66,7 @@ config SCLP_CONSOLE
 config SCLP_VT220_TTY
 	def_bool y
 	prompt "Support for SCLP VT220-compatible terminal"
-	depends on S390
+	depends on S390 && TTY
 	help
 	  Include support for an IBM SCLP VT220-compatible terminal.
 
diff --git a/drivers/staging/ccg/Kconfig b/drivers/staging/ccg/Kconfig
index 8997a8c..7ed5bc6 100644
--- a/drivers/staging/ccg/Kconfig
+++ b/drivers/staging/ccg/Kconfig
@@ -2,7 +2,7 @@ if USB_GADGET
 
 config USB_G_CCG
 	tristate "Configurable Composite Gadget (STAGING)"
-	depends on STAGING && BLOCK && NET && !USB_ZERO && !USB_ZERO_HNPTEST && !USB_AUDIO && !GADGET_UAC1 && !USB_ETH && !USB_ETH_RNDIS && !USB_ETH_EEM && !USB_G_NCM && !USB_GADGETFS && !USB_FUNCTIONFS && !USB_FUNCTIONFS_ETH && !USB_FUNCTIONFS_RNDIS && !USB_FUNCTIONFS_GENERIC && !USB_FILE_STORAGE && !USB_FILE_STORAGE_TEST && !USB_MASS_STORAGE && !USB_G_SERIAL && !USB_MIDI_GADGET && !USB_G_PRINTER && !USB_CDC_COMPOSITE && !USB_G_NOKIA && !USB_G_ACM_MS && !USB_G_MULTI && !USB_G_MULTI_RNDIS && !USB_G_MULTI_CDC && !USB_G_HID && !USB_G_DBGP && !USB_G_WEBCAM
+	depends on STAGING && BLOCK && NET && !USB_ZERO && !USB_ZERO_HNPTEST && !USB_AUDIO && !GADGET_UAC1 && !USB_ETH && !USB_ETH_RNDIS && !USB_ETH_EEM && !USB_G_NCM && !USB_GADGETFS && !USB_FUNCTIONFS && !USB_FUNCTIONFS_ETH && !USB_FUNCTIONFS_RNDIS && !USB_FUNCTIONFS_GENERIC && !USB_FILE_STORAGE && !USB_FILE_STORAGE_TEST && !USB_MASS_STORAGE && !USB_G_SERIAL && !USB_MIDI_GADGET && !USB_G_PRINTER && !USB_CDC_COMPOSITE && !USB_G_NOKIA && !USB_G_ACM_MS && !USB_G_MULTI && !USB_G_MULTI_RNDIS && !USB_G_MULTI_CDC && !USB_G_HID && !USB_G_DBGP && !USB_G_WEBCAM && TTY
 	help
 	  The Configurable Composite Gadget supports multiple USB
 	  functions: acm, mass storage, rndis and FunctionFS.
diff --git a/drivers/staging/dgrp/Kconfig b/drivers/staging/dgrp/Kconfig
index 39f4bb6..e4c4155 100644
--- a/drivers/staging/dgrp/Kconfig
+++ b/drivers/staging/dgrp/Kconfig
@@ -1,7 +1,7 @@
 config DGRP
        tristate "Digi Realport driver"
        default n
-       depends on SYSFS
+       depends on SYSFS && TTY
        ---help---
        Support for Digi Realport devices.  These devices allow you to
        access remote serial ports as if they are local tty devices.  This
diff --git a/drivers/staging/fwserial/Kconfig b/drivers/staging/fwserial/Kconfig
index 580406c..9cdb3cd 100644
--- a/drivers/staging/fwserial/Kconfig
+++ b/drivers/staging/fwserial/Kconfig
@@ -1,6 +1,6 @@
 config FIREWIRE_SERIAL
        tristate "TTY over Firewire"
-       depends on FIREWIRE
+       depends on FIREWIRE && TTY
        help
           This enables TTY over IEEE 1394, providing high-speed serial
 	  connectivity to cabled peers.
diff --git a/drivers/staging/sb105x/Kconfig b/drivers/staging/sb105x/Kconfig
index ac87c5e..403b8c2 100644
--- a/drivers/staging/sb105x/Kconfig
+++ b/drivers/staging/sb105x/Kconfig
@@ -1,7 +1,7 @@
 config SB105X
 	tristate "SystemBase PCI Multiport UART"
 	select SERIAL_CORE
-	depends on PCI
+	depends on PCI && TTY
 	help
 	  A driver for the SystemBase Multi-2/PCI serial card
 
diff --git a/drivers/tty/Kconfig b/drivers/tty/Kconfig
index 0ecf22b..a79fd8e 100644
--- a/drivers/tty/Kconfig
+++ b/drivers/tty/Kconfig
@@ -1,3 +1,14 @@
+config TTY
+	bool "Enable TTY" if EXPERT
+	default y
+	---help---
+	  Allows you to remove TTY support which can save space, and
+	  blocks features that require TTY from inclusion in the kernel.
+	  TTY is required for any text terminals or serial port
+	  communication. Most users should leave this enabled.
+
+if TTY
+
 config VT
 	bool "Virtual terminal" if EXPERT
 	depends on !S390 && !UML
@@ -388,3 +399,5 @@ config PPC_EARLY_DEBUG_EHV_BC_HANDLE
 	  If the number you specify is not a valid byte channel handle, then
 	  there simply will be no early console output.  This is true also
 	  if you don't boot under a hypervisor at all.
+
+endif # TTY
diff --git a/drivers/tty/Makefile b/drivers/tty/Makefile
index 2953059..df5663d 100644
--- a/drivers/tty/Makefile
+++ b/drivers/tty/Makefile
@@ -1,4 +1,4 @@
-obj-y				+= tty_io.o n_tty.o tty_ioctl.o tty_ldisc.o \
+obj-$(CONFIG_TTY)		+= tty_io.o n_tty.o tty_ioctl.o tty_ldisc.o \
 				   tty_buffer.o tty_port.o tty_mutex.o
 obj-$(CONFIG_LEGACY_PTYS)	+= pty.o
 obj-$(CONFIG_UNIX98_PTYS)	+= pty.o
diff --git a/drivers/tty/hvc/Kconfig b/drivers/tty/hvc/Kconfig
index f47b734..8902f9b 100644
--- a/drivers/tty/hvc/Kconfig
+++ b/drivers/tty/hvc/Kconfig
@@ -1,3 +1,5 @@
+if TTY
+
 config HVC_DRIVER
 	bool
 	help
@@ -119,3 +121,4 @@ config HVCS
 	  which will also be compiled when this driver is built as a
 	  module.
 
+endif # TTY
diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 59c23d0..80b1bcc 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -2,6 +2,8 @@
 # Serial device configuration
 #
 
+if TTY
+
 menu "Serial drivers"
 	depends on HAS_IOMEM
 
@@ -1448,3 +1450,5 @@ config SERIAL_ARC_NR_PORTS
 	  to support.
 
 endmenu
+
+endif # TTY
diff --git a/drivers/usb/class/Kconfig b/drivers/usb/class/Kconfig
index 2519e32..316aac8 100644
--- a/drivers/usb/class/Kconfig
+++ b/drivers/usb/class/Kconfig
@@ -6,7 +6,7 @@ comment "USB Device Class drivers"
 
 config USB_ACM
 	tristate "USB Modem (CDC ACM) support"
-	depends on USB
+	depends on USB && TTY
 	---help---
 	  This driver supports USB modems and ISDN adapters which support the
 	  Communication Device Class Abstract Control Model interface.
diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 14625fd..a1bd951 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -750,6 +750,7 @@ config USB_GADGET_TARGET
 
 config USB_G_SERIAL
 	tristate "Serial Gadget (with CDC ACM and CDC OBEX support)"
+	depends on TTY
 	select USB_LIBCOMPOSITE
 	help
 	  The Serial Gadget talks to the Linux-USB generic serial driver.
@@ -799,6 +800,8 @@ config USB_G_PRINTER
 	  For more information, see Documentation/usb/gadget_printer.txt
 	  which includes sample code for accessing the device file.
 
+if TTY
+
 config USB_CDC_COMPOSITE
 	tristate "CDC Composite Device (Ethernet and ACM)"
 	depends on NET
@@ -879,6 +882,8 @@ config USB_G_MULTI_CDC
 
 	  If unsure, say "y".
 
+endif # TTY
+
 config USB_G_HID
 	tristate "HID Gadget"
 	select USB_LIBCOMPOSITE
@@ -895,6 +900,7 @@ config USB_G_HID
 # Standalone / single function gadgets
 config USB_G_DBGP
 	tristate "EHCI Debug Device Gadget"
+	depends on TTY
 	select USB_LIBCOMPOSITE
 	help
 	  This gadget emulates an EHCI Debug device. This is useful when you want
diff --git a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
index 76f4622..d8e35fe 100644
--- a/drivers/usb/serial/Kconfig
+++ b/drivers/usb/serial/Kconfig
@@ -4,7 +4,7 @@
 
 menuconfig USB_SERIAL
 	tristate "USB Serial Converter support"
-	depends on USB
+	depends on USB && TTY
 	---help---
 	  Say Y here if you have a USB device that provides normal serial
 	  ports, or acts like a serial device, and you want to connect it to
diff --git a/fs/proc/Makefile b/fs/proc/Makefile
index 981b056..712f24d 100644
--- a/fs/proc/Makefile
+++ b/fs/proc/Makefile
@@ -8,7 +8,8 @@ proc-y			:= nommu.o task_nommu.o
 proc-$(CONFIG_MMU)	:= mmu.o task_mmu.o
 
 proc-y       += inode.o root.o base.o generic.o array.o \
-		proc_tty.o fd.o
+		fd.o
+proc-$(CONFIG_TTY)      += proc_tty.o
 proc-y	+= cmdline.o
 proc-y	+= consoles.o
 proc-y	+= cpuinfo.o
diff --git a/include/linux/console.h b/include/linux/console.h
index dedb082..3b709da 100644
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -157,7 +157,12 @@ extern int is_console_locked(void);
 extern int braille_register_console(struct console *, int index,
 		char *console_options, char *braille_options);
 extern int braille_unregister_console(struct console *);
+#ifdef CONFIG_TTY
 extern void console_sysfs_notify(void);
+#else
+static inline void console_sysfs_notify(void)
+{ }
+#endif
 extern bool console_suspend_enabled;
 
 /* Suspend and resume console messages over PM events */
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 32676b3..3c22538 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -127,7 +127,12 @@ extern void pid_ns_release_proc(struct pid_namespace *ns);
  * proc_tty.c
  */
 struct tty_driver;
+#ifdef CONFIG_TTY
 extern void proc_tty_init(void);
+#else
+static inline void proc_tty_init(void)
+{ }
+#endif
 extern void proc_tty_register_driver(struct tty_driver *driver);
 extern void proc_tty_unregister_driver(struct tty_driver *driver);
 
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 8db1b56..2d18bb6 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -317,11 +317,43 @@ struct tty_file_private {
 
 #define TTY_WRITE_FLUSH(tty) tty_write_flush((tty))
 
+#ifdef CONFIG_TTY
+extern void console_init(void);
+extern void tty_kref_put(struct tty_struct *tty);
+extern struct pid *tty_get_pgrp(struct tty_struct *tty);
+extern void tty_vhangup_self(void);
+extern void disassociate_ctty(int priv);
+extern dev_t tty_devnum(struct tty_struct *tty);
+extern void proc_clear_tty(struct task_struct *p);
+extern struct tty_struct *get_current_tty(void);
+/* tty_io.c */
+extern int __init tty_init(void);
+#else
+static inline void console_init(void)
+{ }
+static inline void tty_kref_put(struct tty_struct *tty)
+{ }
+static inline struct pid *tty_get_pgrp(struct tty_struct *tty)
+{ return NULL; }
+static inline void tty_vhangup_self(void)
+{ }
+static inline void disassociate_ctty(int priv)
+{ }
+static inline dev_t tty_devnum(struct tty_struct *tty)
+{ return 0; }
+static inline void proc_clear_tty(struct task_struct *p)
+{ }
+static inline struct tty_struct *get_current_tty(void)
+{ return NULL; }
+/* tty_io.c */
+static inline int __init tty_init(void)
+{ return 0; }
+#endif
+
 extern void tty_write_flush(struct tty_struct *);
 
 extern struct ktermios tty_std_termios;
 
-extern void console_init(void);
 extern int vcs_init(void);
 
 extern struct class *tty_class;
@@ -341,7 +373,6 @@ static inline struct tty_struct *tty_kref_get(struct tty_struct *tty)
 		kref_get(&tty->kref);
 	return tty;
 }
-extern void tty_kref_put(struct tty_struct *tty);
 
 extern int tty_paranoia_check(struct tty_struct *tty, struct inode *inode,
 			      const char *routine);
@@ -373,18 +404,15 @@ extern void tty_driver_remove_tty(struct tty_driver *driver,
 				  struct tty_struct *tty);
 extern void tty_free_termios(struct tty_struct *tty);
 extern int is_current_pgrp_orphaned(void);
-extern struct pid *tty_get_pgrp(struct tty_struct *tty);
 extern int is_ignored(int sig);
 extern int tty_signal(int sig, struct tty_struct *tty);
 extern void tty_hangup(struct tty_struct *tty);
 extern void tty_vhangup(struct tty_struct *tty);
 extern void tty_vhangup_locked(struct tty_struct *tty);
-extern void tty_vhangup_self(void);
 extern void tty_unhangup(struct file *filp);
 extern int tty_hung_up_p(struct file *filp);
 extern void do_SAK(struct tty_struct *tty);
 extern void __do_SAK(struct tty_struct *tty);
-extern void disassociate_ctty(int priv);
 extern void no_tty(void);
 extern void tty_flip_buffer_push(struct tty_struct *tty);
 extern void tty_flush_to_ldisc(struct tty_struct *tty);
@@ -415,9 +443,6 @@ extern long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 extern int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 			unsigned int cmd, unsigned long arg);
 extern int tty_perform_flush(struct tty_struct *tty, unsigned long arg);
-extern dev_t tty_devnum(struct tty_struct *tty);
-extern void proc_clear_tty(struct task_struct *p);
-extern struct tty_struct *get_current_tty(void);
 extern void tty_default_fops(struct file_operations *fops);
 extern struct tty_struct *alloc_tty_struct(void);
 extern int tty_alloc_file(struct file *file);
@@ -543,9 +568,6 @@ static inline int tty_audit_push_task(struct task_struct *tsk,
 }
 #endif
 
-/* tty_io.c */
-extern int __init tty_init(void);
-
 /* tty_ioctl.c */
 extern int n_tty_ioctl_helper(struct tty_struct *tty, struct file *file,
 		       unsigned int cmd, unsigned long arg);
diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
index 43cb93f..30894fa 100644
--- a/lib/Kconfig.kgdb
+++ b/lib/Kconfig.kgdb
@@ -22,6 +22,7 @@ config KGDB_SERIAL_CONSOLE
 	tristate "KGDB: use kgdb over the serial console"
 	select CONSOLE_POLL
 	select MAGIC_SYSRQ
+	depends on TTY
 	default y
 	help
 	  Share a serial console with kgdb. Sysrq-g must be used
diff --git a/net/bluetooth/rfcomm/Kconfig b/net/bluetooth/rfcomm/Kconfig
index 22e718b..18d352e 100644
--- a/net/bluetooth/rfcomm/Kconfig
+++ b/net/bluetooth/rfcomm/Kconfig
@@ -12,6 +12,7 @@ config BT_RFCOMM
 config BT_RFCOMM_TTY
 	bool "RFCOMM TTY support"
 	depends on BT_RFCOMM
+	depends on TTY
 	help
 	  This option enables TTY emulation support for RFCOMM channels.
 
diff --git a/net/irda/ircomm/Kconfig b/net/irda/ircomm/Kconfig
index 2d4c6b4..19492c1 100644
--- a/net/irda/ircomm/Kconfig
+++ b/net/irda/ircomm/Kconfig
@@ -1,6 +1,6 @@
 config IRCOMM
 	tristate "IrCOMM protocol"
-	depends on IRDA
+	depends on IRDA && TTY
 	help
 	  Say Y here if you want to build support for the IrCOMM protocol.
 	  To compile it as modules, choose M here: the modules will be
diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 3a84782..298822c 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -34,7 +34,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_CS42L73 if I2C
 	select SND_SOC_CS4270 if I2C
 	select SND_SOC_CS4271 if SND_SOC_I2C_AND_SPI
-	select SND_SOC_CX20442
+	select SND_SOC_CX20442 if TTY
 	select SND_SOC_DA7210 if I2C
 	select SND_SOC_DA732X if I2C
 	select SND_SOC_DA9055 if I2C
@@ -236,6 +236,7 @@ config SND_SOC_CS4271
 
 config SND_SOC_CX20442
 	tristate
+	depends on TTY
 
 config SND_SOC_JZ4740_CODEC
 	select REGMAP_MMIO
-- 
1.7.9.5

