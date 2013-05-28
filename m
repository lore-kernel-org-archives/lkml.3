Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759132Ab3E1H3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 03:29:43 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:60379 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758941Ab3E1H3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 03:29:42 -0400
Message-ID: <1369726176.23856.6.camel@x61.thuisdomein>
Subject: [PATCH] [RESEND] stallion: final cleanup
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Date: Tue, 28 May 2013 09:29:36 +0200
In-Reply-To: <20130520183941.GB14851@kroah.com>
References: <1363871896.1390.138.camel@x61.thuisdomein>
	 <201303211429.29502.arnd@arndb.de>
	 <1368736525.1350.214.camel@x61.thuisdomein>
	 <20130520183941.GB14851@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 May 2013 07:29:39.0967 (UTC) FILETIME=[1D3580F0:01CE5B75]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for the Stallion multiport serial drivers was removed in v3.1.
Clean up their last references in the tree: mainly an outdated Kconfig
entry and unneeded documentation.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
0) Resend at Greg's request. This patch is rebased on top of v3.10-rc3,
which is unlikely to have changed anything, and has Arnd's ACK added to
it.

1) Still only tested with git grep.

2) grepping the tree for "stallion" now only gives references to things
like IDs and magic numbers that, I think, can never be deleted.

 Documentation/serial/00-INDEX     |   2 -
 Documentation/serial/stallion.txt | 392 --------------------------------------
 drivers/char/Kconfig              |  12 --
 drivers/tty/serial/8250/Kconfig   |   5 +-
 4 files changed, 2 insertions(+), 409 deletions(-)
 delete mode 100644 Documentation/serial/stallion.txt

diff --git a/Documentation/serial/00-INDEX b/Documentation/serial/00-INDEX
index f7b0c7d..1f1b22f 100644
--- a/Documentation/serial/00-INDEX
+++ b/Documentation/serial/00-INDEX
@@ -16,8 +16,6 @@ serial-rs485.txt
 	- info about RS485 structures and support in the kernel.
 specialix.txt
 	- info on hardware/driver for specialix IO8+ multiport serial card.
-stallion.txt
-	- info on using the Stallion multiport serial driver.
 sx.txt
 	- info on the Specialix SX/SI multiport serial driver.
 tty.txt
diff --git a/Documentation/serial/stallion.txt b/Documentation/serial/stallion.txt
deleted file mode 100644
index 4d798c0..0000000
--- a/Documentation/serial/stallion.txt
+++ /dev/null
@@ -1,392 +0,0 @@
-* NOTE - This is an unmaintained driver.  Lantronix, which bought Stallion
-technologies, is not active in driver maintenance, and they have no information
-on when or if they will have a 2.6 driver.
-
-James Nelson <james4765@gmail.com> - 12-12-2004
-
-Stallion Multiport Serial Driver Readme
----------------------------------------
-
-Copyright (C) 1994-1999,  Stallion Technologies.
-
-Version:   5.5.1
-Date:      28MAR99
-
-
-
-1. INTRODUCTION
-
-There are two drivers that work with the different families of Stallion
-multiport serial boards. One is for the Stallion smart boards - that is
-EasyIO, EasyConnection 8/32 and EasyConnection 8/64-PCI, the other for
-the true Stallion intelligent multiport boards - EasyConnection 8/64
-(ISA, EISA), EasyConnection/RA-PCI, ONboard and Brumby.
-
-If you are using any of the Stallion intelligent multiport boards (Brumby,
-ONboard, EasyConnection 8/64 (ISA, EISA), EasyConnection/RA-PCI) with
-Linux you will need to get the driver utility package.  This contains a
-firmware loader and the firmware images necessary to make the devices operate.
-
-The Stallion Technologies ftp site, ftp.stallion.com, will always have
-the latest version of the driver utility package.
-
-ftp://ftp.stallion.com/drivers/ata5/Linux/ata-linux-550.tar.gz
-
-As of the printing of this document the latest version of the driver
-utility package is 5.5.0. If a later version is now available then you
-should use the latest version.
-
-If you are using the EasyIO, EasyConnection 8/32 or EasyConnection 8/64-PCI
-boards then you don't need this package, although it does have a serial stats
-display program.
-
-If you require DIP switch settings, or EISA configuration files, or any
-other information related to Stallion boards then have a look at Stallion's
-web pages at http://www.stallion.com.
-
-
-
-2. INSTALLATION
-
-The drivers can be used as loadable modules or compiled into the kernel.
-You can choose which when doing a "config" on the kernel.
-
-All ISA, and EISA boards that you want to use need to be configured into
-the driver(s). All PCI boards will be automatically detected when you load
-the driver - so they do not need to be entered into the driver(s)
-configuration structure. Note that kernel PCI support is required to use PCI
-boards.
-
-There are two methods of configuring ISA and EISA boards into the drivers.
-If using the driver as a loadable module then the simplest method is to pass
-the driver configuration as module arguments. The other method is to modify
-the driver source to add configuration lines for each board in use.
-
-If you have pre-built Stallion driver modules then the module argument
-configuration method should be used. A lot of Linux distributions come with
-pre-built driver modules in /lib/modules/X.Y.Z/misc for the kernel in use.
-That makes things pretty simple to get going.
-
-
-2.1 MODULE DRIVER CONFIGURATION:
-
-The simplest configuration for modules is to use the module load arguments
-to configure any ISA or EISA boards. PCI boards are automatically
-detected, so do not need any additional configuration at all.
-
-If using EasyIO, EasyConnection 8/32 ISA, or EasyConnection 8/63-PCI
-boards then use the "stallion" driver module, Otherwise if you are using
-an EasyConnection 8/64 ISA or EISA, EasyConnection/RA-PCI, ONboard,
-Brumby or original Stallion board then use the "istallion" driver module.
-
-Typically to load up the smart board driver use:
-
-    modprobe stallion
-
-This will load the EasyIO and EasyConnection 8/32 driver. It will output a
-message to say that it loaded and print the driver version number. It will
-also print out whether it found the configured boards or not. These messages
-may not appear on the console, but typically are always logged to
-/var/adm/messages or /var/log/syslog files - depending on how the klogd and
-syslogd daemons are setup on your system.
-
-To load the intelligent board driver use:
-
-    modprobe istallion
-
-It will output similar messages to the smart board driver.
-
-If not using an auto-detectable board type (that is a PCI board) then you
-will also need to supply command line arguments to the modprobe command
-when loading the driver. The general form of the configuration argument is
-
-    board?=<name>[,<ioaddr>[,<addr>][,<irq>]]
-
-where:
-
-    board?  -- specifies the arbitrary board number of this board,
-               can be in the range 0 to 3.
-
-    name    -- textual name of this board. The board name is the common
-               board name, or any "shortened" version of that. The board
-               type number may also be used here.
-
-    ioaddr  -- specifies the I/O address of this board. This argument is
-               optional, but should generally be specified.
-
-    addr    -- optional second address argument. Some board types require
-               a second I/O address, some require a memory address. The
-               exact meaning of this argument depends on the board type.
-
-    irq     -- optional IRQ line used by this board.
-
-Up to 4 board configuration arguments can be specified on the load line.
-Here is some examples:
-
-    modprobe stallion board0=easyio,0x2a0,5
-
-This configures an EasyIO board as board 0 at I/O address 0x2a0 and IRQ 5.
-
-    modprobe istallion board3=ec8/64,0x2c0,0xcc000
-
-This configures an EasyConnection 8/64 ISA as board 3 at I/O address 0x2c0 at
-memory address 0xcc000.
-
-    modprobe stallion board1=ec8/32-at,0x2a0,0x280,10
-
-This configures an EasyConnection 8/32 ISA board at primary I/O address 0x2a0,
-secondary address 0x280 and IRQ 10.
-
-You will probably want to enter this module load and configuration information
-into your system startup scripts so that the drivers are loaded and configured
-on each system boot. Typically configuration files are put in the
-/etc/modprobe.d/ directory.
-
-
-2.2 STATIC DRIVER CONFIGURATION:
-
-For static driver configuration you need to modify the driver source code.
-Entering ISA and EISA boards into the driver(s) configuration structure
-involves editing the driver(s) source file. It's pretty easy if you follow
-the instructions below. Both drivers can support up to 4 boards. The smart
-card driver (the stallion.c driver) supports any combination of EasyIO and
-EasyConnection 8/32 boards (up to a total of 4). The intelligent driver
-supports any combination of ONboards, Brumbys, Stallions and EasyConnection
-8/64 (ISA and EISA) boards (up to a total of 4).
-
-To set up the driver(s) for the boards that you want to use you need to
-edit the appropriate driver file and add configuration entries.
-
-If using EasyIO or EasyConnection 8/32 ISA boards,
-   In drivers/char/stallion.c:
-      - find the definition of the stl_brdconf array (of structures)
-        near the top of the file
-      - modify this to match the boards you are going to install
-	(the comments before this structure should help)
-      - save and exit
-
-If using ONboard, Brumby, Stallion or EasyConnection 8/64 (ISA or EISA)
-boards,
-   In drivers/char/istallion.c:
-      - find the definition of the stli_brdconf array (of structures)
-        near the top of the file
-      - modify this to match the boards you are going to install
-	(the comments before this structure should help)
-      - save and exit
-
-Once you have set up the board configurations then you are ready to build
-the kernel or modules.
-
-When the new kernel is booted, or the loadable module loaded then the
-driver will emit some kernel trace messages about whether the configured
-boards were detected or not. Depending on how your system logger is set
-up these may come out on the console, or just be logged to
-/var/adm/messages or /var/log/syslog. You should check the messages to
-confirm that all is well.
-
-
-2.3 SHARING INTERRUPTS
-
-It is possible to share interrupts between multiple EasyIO and
-EasyConnection 8/32 boards in an EISA system. To do this you must be using
-static driver configuration, modifying the driver source code to add driver
-configuration. Then a couple of extra things are required:
-
-1. When entering the board resources into the stallion.c file you need to
-   mark the boards as using level triggered interrupts. Do this by replacing
-   the "0" entry at field position 6 (the last field) in the board
-   configuration structure with a "1". (This is the structure that defines
-   the board type, I/O locations, etc. for each board). All boards that are
-   sharing an interrupt must be set this way, and each board should have the
-   same interrupt number specified here as well. Now build the module or
-   kernel as you would normally.
-
-2. When physically installing the boards into the system you must enter
-   the system EISA configuration utility. You will need to install the EISA
-   configuration files for *all* the EasyIO and EasyConnection 8/32 boards
-   that are sharing interrupts. The Stallion EasyIO and EasyConnection 8/32
-   EISA configuration files required are supplied by Stallion Technologies
-   on the EASY Utilities floppy diskette (usually supplied in the box with
-   the board when purchased. If not, you can pick it up from Stallion's FTP
-   site, ftp.stallion.com). You will need to edit the board resources to
-   choose level triggered interrupts, and make sure to set each board's
-   interrupt to the same IRQ number.
-
-You must complete both the above steps for this to work. When you reboot
-or load the driver your EasyIO and EasyConnection 8/32 boards will be
-sharing interrupts.
-
-
-2.4 USING HIGH SHARED MEMORY
-
-The EasyConnection 8/64-EI, ONboard and Stallion boards are capable of
-using shared memory addresses above the usual 640K - 1Mb range. The ONboard
-ISA and the Stallion boards can be programmed to use memory addresses up to
-16Mb (the ISA bus addressing limit), and the EasyConnection 8/64-EI and
-ONboard/E can be programmed for memory addresses up to 4Gb (the EISA bus
-addressing limit).
-
-The higher than 1Mb memory addresses are fully supported by this driver.
-Just enter the address as you normally would for a lower than 1Mb address
-(in the driver's board configuration structure).
-
-
-
-2.5 TROUBLE SHOOTING
-
-If a board is not found by the driver but is actually in the system then the
-most likely problem is that the I/O address is wrong. Change the module load
-argument for the loadable module form. Or change it in the driver stallion.c
-or istallion.c configuration structure and rebuild the kernel or modules, or
-change it on the board.
-
-On EasyIO and EasyConnection 8/32 boards the IRQ is software programmable, so
-if there is a conflict you may need to change the IRQ used for a board. There
-are no interrupts to worry about for ONboard, Brumby or EasyConnection 8/64
-(ISA and EISA) boards. The memory region on EasyConnection 8/64 and
-ONboard boards is software programmable, but not on the Brumby boards.
-
-
-
-3. USING THE DRIVERS
-
-3.1 INTELLIGENT DRIVER OPERATION
-
-The intelligent boards also need to have their "firmware" code downloaded
-to them. This is done via a user level application supplied in the driver
-utility package called "stlload". Compile this program wherever you dropped
-the package files, by typing "make". In its simplest form you can then type
-
-    ./stlload -i cdk.sys
-
-in this directory and that will download board 0 (assuming board 0 is an
-EasyConnection 8/64 or EasyConnection/RA board). To download to an
-ONboard, Brumby or Stallion do:
-
-    ./stlload -i 2681.sys
-
-Normally you would want all boards to be downloaded as part of the standard
-system startup. To achieve this, add one of the lines above into the
-/etc/rc.d/rc.S or /etc/rc.d/rc.serial file. To download each board just add
-the "-b <brd-number>" option to the line. You will need to download code for
-every board. You should probably move the stlload program into a system
-directory, such as /usr/sbin. Also, the default location of the cdk.sys image
-file in the stlload down-loader is /usr/lib/stallion. Create that directory
-and put the cdk.sys and 2681.sys files in it. (It's a convenient place to put
-them anyway). As an example your /etc/rc.d/rc.S file might have the
-following lines added to it (if you had 3 boards):
-
-    /usr/sbin/stlload -b 0 -i /usr/lib/stallion/cdk.sys
-    /usr/sbin/stlload -b 1 -i /usr/lib/stallion/2681.sys
-    /usr/sbin/stlload -b 2 -i /usr/lib/stallion/2681.sys
-
-The image files cdk.sys and 2681.sys are specific to the board types. The
-cdk.sys will only function correctly on an EasyConnection 8/64 board. Similarly
-the 2681.sys image fill only operate on ONboard, Brumby and Stallion boards.
-If you load the wrong image file into a board it will fail to start up, and
-of course the ports will not be operational!
-
-If you are using the modularized version of the driver you might want to put
-the modprobe calls in the startup script as well (before the download lines
-obviously).
-
-
-3.2 USING THE SERIAL PORTS
-
-Once the driver is installed you will need to setup some device nodes to
-access the serial ports. The simplest method is to use the /dev/MAKEDEV program.
-It will automatically create device entries for Stallion boards. This will
-create the normal serial port devices as /dev/ttyE# where# is the port number
-starting from 0. A bank of 64 minor device numbers is allocated to each board,
-so the first port on the second board is port 64,etc. A set of callout type
-devices may also be created. They are created as the devices /dev/cue# where #
-is the same as for the ttyE devices.
-
-For the most part the Stallion driver tries to emulate the standard PC system
-COM ports and the standard Linux serial driver. The idea is that you should
-be able to use Stallion board ports and COM ports interchangeably without
-modifying anything but the device name. Anything that doesn't work like that
-should be considered a bug in this driver!
-
-If you look at the driver code you will notice that it is fairly closely
-based on the Linux serial driver (linux/drivers/char/serial.c). This is
-intentional, obviously this is the easiest way to emulate its behavior!
-
-Since this driver tries to emulate the standard serial ports as much as
-possible, most system utilities should work as they do for the standard
-COM ports. Most importantly "stty" works as expected and "setserial" can
-also be used (excepting the ability to auto-configure the I/O and IRQ
-addresses of boards). Higher baud rates are supported in the usual fashion
-through setserial or using the CBAUDEX extensions. Note that the EasyIO and
-EasyConnection (all types) support at least 57600 and 115200 baud. The newer
-EasyConnection XP modules and new EasyIO boards support 230400 and 460800
-baud as well. The older boards including ONboard and Brumby support a
-maximum baud rate of 38400.
-
-If you are unfamiliar with how to use serial ports, then get the Serial-HOWTO
-by Greg Hankins. It will explain everything you need to know!
-
-
-
-4. NOTES
-
-You can use both drivers at once if you have a mix of board types installed
-in a system. However to do this you will need to change the major numbers
-used by one of the drivers. Currently both drivers use major numbers 24, 25
-and 28 for their devices. Change one driver to use some other major numbers,
-and then modify the mkdevnods script to make device nodes based on those new
-major numbers. For example, you could change the istallion.c driver to use
-major numbers 60, 61 and 62. You will also need to create device nodes with
-different names for the ports, for example ttyF# and cuf#.
-
-The original Stallion board is no longer supported by Stallion Technologies.
-Although it is known to work with the istallion driver.
-
-Finding a free physical memory address range can be a problem. The older
-boards like the Stallion and ONboard need large areas (64K or even 128K), so
-they can be very difficult to get into a system. If you have 16 Mb of RAM
-then you have no choice but to put them somewhere in the 640K -> 1Mb range.
-ONboards require 64K, so typically 0xd0000 is good, or 0xe0000 on some
-systems. If you have an original Stallion board, "V4.0" or Rev.O, then you
-need a 64K memory address space, so again 0xd0000 and 0xe0000 are good.
-Older Stallion boards are a much bigger problem. They need 128K of address
-space and must be on a 128K boundary. If you don't have a VGA card then
-0xc0000 might be usable - there is really no other place you can put them
-below 1Mb.
-
-Both the ONboard and old Stallion boards can use higher memory addresses as
-well, but you must have less than 16Mb of RAM to be able to use them. Usual
-high memory addresses used include 0xec0000 and 0xf00000.
-
-The Brumby boards only require 16Kb of address space, so you can usually
-squeeze them in somewhere. Common addresses are 0xc8000, 0xcc000, or in
-the 0xd0000 range. EasyConnection 8/64 boards are even better, they only
-require 4Kb of address space, again usually 0xc8000, 0xcc000 or 0xd0000
-are good.
-
-If you are using an EasyConnection 8/64-EI or ONboard/E then usually the
-0xd0000 or 0xe0000 ranges are the best options below 1Mb. If neither of
-them can be used then the high memory support to use the really high address
-ranges is the best option. Typically the 2Gb range is convenient for them,
-and gets them well out of the way.
-
-The ports of the EasyIO-8M board do not have DCD or DTR signals. So these
-ports cannot be used as real modem devices. Generally, when using these
-ports you should only use the cueX devices.
-
-The driver utility package contains a couple of very useful programs. One 
-is a serial port statistics collection and display program - very handy
-for solving serial port problems. The other is an extended option setting
-program that works with the intelligent boards.
-
-
-
-5. DISCLAIMER
-
-The information contained in this document is believed to be accurate and
-reliable. However, no responsibility is assumed by Stallion Technologies
-Pty. Ltd. for its use, nor any infringements of patents or other rights
-of third parties resulting from its use. Stallion Technologies reserves
-the right to modify the design of its products and will endeavour to change
-the information in manuals and accompanying documentation accordingly.
-
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 3bb6fa3..1421997 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -15,18 +15,6 @@ config DEVKMEM
 	  kind of kernel debugging operations.
 	  When in doubt, say "N".
 
-config STALDRV
-	bool "Stallion multiport serial support"
-	depends on SERIAL_NONSTANDARD
-	help
-	  Stallion cards give you many serial ports.  You would need something
-	  like this to connect more than two modems to your Linux box, for
-	  instance in order to become a dial-in server.  If you say Y here,
-	  you will be asked for your specific card model in the next
-	  questions.  Make sure to read <file:Documentation/serial/stallion.txt>
-	  in this case.  If you have never heard about all this, it's safe to
-	  say N.
-
 config SGI_SNSC
 	bool "SGI Altix system controller communication support"
 	depends on (IA64_SGI_SN2 || IA64_GENERIC)
diff --git a/drivers/tty/serial/8250/Kconfig b/drivers/tty/serial/8250/Kconfig
index 80fe91e..a1ba94d 100644
--- a/drivers/tty/serial/8250/Kconfig
+++ b/drivers/tty/serial/8250/Kconfig
@@ -12,9 +12,8 @@ config SERIAL_8250
 	  here are those that are setting up dedicated Ethernet WWW/FTP
 	  servers, or users that have one of the various bus mice instead of a
 	  serial mouse and don't intend to use their machine's standard serial
-	  port for anything.  (Note that the Cyclades and Stallion multi
-	  serial port drivers do not need this driver built in for them to
-	  work.)
+	  port for anything.  (Note that the Cyclades multi serial port driver
+	  does not need this driver built in for it to work.)
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called 8250.
-- 
1.7.11.7

