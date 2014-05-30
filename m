Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbaE3CPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 22:15:39 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51249 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754590AbaE3COf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 22:14:35 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        matthew.garrett@nebula.com, mika.westerberg@linux.intel.com
Subject: [PATCH 2/10] ACPI / PNP: use device ID list for PNPACPI device enumeration
Date: Fri, 30 May 2014 04:23:01 +0200
Message-ID: <4693928.AuXTtcWpjv@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <35042328.kk6ZUUdfyN@vostro.rjw.lan>
References: <1400781753-2682-1-git-send-email-rui.zhang@intel.com> <35042328.kk6ZUUdfyN@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>

ACPI can be used to enumerate PNP devices, but the code does not
handle this in the right way currently.  Namely, if an ACPI device
object
 1. Has a _CRS method,
 2. Has an identification of
    "three capital characters followed by four hex digits",
 3. Is not in the excluded IDs list,
it will be enumerated to PNP bus (that is, a PNP device object will
be create for it).  This means that, actually, the PNP bus type is
used as the default bus type for enumerating _HID devices in ACPI.

However, more and more _HID devices need to be enumerated to the
platform bus instead (that is, platform device objects need to be
created for them).  As a result, the device ID list in acpi_platform.c
is used to enforce creating platform device objects rather than PNP
device objects for matching devices.  That list has been continuously
growing recently, unfortunately, and it is pretty much guaranteed to
grow even more in the future.

To address that problem it is better to enumerate _HID devices
as platform devices by default.  To this end, change the way of
enumerating PNP devices by adding a PNP ACPI scan handler that
will use a device ID list to create PNP devices for the ACPI
device objects whose device IDs are present in that list.

The initial device ID list in the PNP ACPI scan handler contains
all of the pnp_device_id strings from all the existing PNP drivers,
so this change should be transparent to the PNP core and all of the
PNP drivers.  Still, in the future it should be possible to reduce
its size by converting PNP drivers that need not be PNP for any
technical reasons into platform drivers.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
[rjw: Rewrote the changelog, modified the PNP ACPI scan handler code]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/Makefile        |    1 
 drivers/acpi/acpi_cmos_rtc.c |    2 
 drivers/acpi/acpi_pnp.c      |  401 +++++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/internal.h      |    1 
 drivers/acpi/scan.c          |    1 
 drivers/pnp/pnpacpi/core.c   |   28 ---
 include/linux/acpi.h         |    2 
 7 files changed, 411 insertions(+), 25 deletions(-)
 create mode 100644 drivers/acpi/acpi_pnp.c

Index: linux-pm/drivers/acpi/Makefile
===================================================================
--- linux-pm.orig/drivers/acpi/Makefile
+++ linux-pm/drivers/acpi/Makefile
@@ -41,6 +41,7 @@ acpi-$(CONFIG_ACPI_DOCK)	+= dock.o
 acpi-y				+= pci_root.o pci_link.o pci_irq.o
 acpi-$(CONFIG_X86_INTEL_LPSS)	+= acpi_lpss.o
 acpi-y				+= acpi_platform.o
+acpi-y				+= acpi_pnp.o
 acpi-y				+= power.o
 acpi-y				+= event.o
 acpi-y				+= sysfs.o
Index: linux-pm/drivers/acpi/acpi_cmos_rtc.c
===================================================================
--- linux-pm.orig/drivers/acpi/acpi_cmos_rtc.c
+++ linux-pm/drivers/acpi/acpi_cmos_rtc.c
@@ -68,7 +68,7 @@ static int acpi_install_cmos_rtc_space_h
 		return -ENODEV;
 	}
 
-	return 0;
+	return 1;
 }
 
 static void acpi_remove_cmos_rtc_space_handler(struct acpi_device *adev)
Index: linux-pm/drivers/acpi/acpi_pnp.c
===================================================================
--- /dev/null
+++ linux-pm/drivers/acpi/acpi_pnp.c
@@ -0,0 +1,401 @@
+/*
+ * ACPI support for PNP bus type
+ *
+ * Copyright (C) 2014, Intel Corporation
+ * Authors: Zhang Rui <rui.zhang@intel.com>
+ *          Rafael J. Wysocki <rafael.j.wysocki@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/acpi.h>
+#include <linux/module.h>
+
+static const struct acpi_device_id acpi_pnp_device_ids[] = {
+	/* pata_isapnp */
+	{"PNP0600"},		/* Generic ESDI/IDE/ATA compatible hard disk controller */
+	/* floppy */
+	{"PNP0700"},
+	/* ipmi_si */
+	{"IPI0001"},
+	/* tpm_inf_pnp */
+	{"IFX0101"},		/* Infineon TPMs */
+	{"IFX0102"},		/* Infineon TPMs */
+	/*tpm_tis */
+	{"PNP0C31"},		/* TPM */
+	{"ATM1200"},		/* Atmel */
+	{"IFX0102"},		/* Infineon */
+	{"BCM0101"},		/* Broadcom */
+	{"BCM0102"},		/* Broadcom */
+	{"NSC1200"},		/* National */
+	{"ICO0102"},		/* Intel */
+	/* ide   */
+	{"PNP0600"},		/* Generic ESDI/IDE/ATA compatible hard disk controller */
+	/* ns558 */
+	{"@P@0001"},		/* ALS 100 */
+	{"@P@0020"},		/* ALS 200 */
+	{"@P@1001"},		/* ALS 100+ */
+	{"@P@2001"},		/* ALS 120 */
+	{"ASB16fd"},		/* AdLib NSC16 */
+	{"AZT3001"},		/* AZT1008 */
+	{"CDC0001"},		/* Opl3-SAx */
+	{"CSC0001"},		/* CS4232 */
+	{"CSC000f"},		/* CS4236 */
+	{"CSC0101"},		/* CS4327 */
+	{"CTL7001"},		/* SB16 */
+	{"CTL7002"},		/* AWE64 */
+	{"CTL7005"},		/* Vibra16 */
+	{"ENS2020"},		/* SoundscapeVIVO */
+	{"ESS0001"},		/* ES1869 */
+	{"ESS0005"},		/* ES1878 */
+	{"ESS6880"},		/* ES688 */
+	{"IBM0012"},		/* CS4232 */
+	{"OPT0001"},		/* OPTi Audio16 */
+	{"YMH0006"},		/* Opl3-SA */
+	{"YMH0022"},		/* Opl3-SAx */
+	{"PNPb02f"},		/* Generic */
+	/* i8042 kbd */
+	{"PNP0300"},
+	{"PNP0301"},
+	{"PNP0302"},
+	{"PNP0303"},
+	{"PNP0304"},
+	{"PNP0305"},
+	{"PNP0306"},
+	{"PNP0309"},
+	{"PNP030a"},
+	{"PNP030b"},
+	{"PNP0320"},
+	{"PNP0343"},
+	{"PNP0344"},
+	{"PNP0345"},
+	{"CPQA0D7"},
+	/* i8042 aux */
+	{"AUI0200"},
+	{"FJC6000"},
+	{"FJC6001"},
+	{"PNP0f03"},
+	{"PNP0f0b"},
+	{"PNP0f0e"},
+	{"PNP0f12"},
+	{"PNP0f13"},
+	{"PNP0f19"},
+	{"PNP0f1c"},
+	{"SYN0801"},
+	/* fcpnp */
+	{"AVM0900"},
+	/* radio-cadet */
+	{"MSM0c24"},		/* ADS Cadet AM/FM Radio Card */
+	/* radio-gemtek */
+	{"ADS7183"},		/* AOpen FX-3D/Pro Radio */
+	/* radio-sf16fmr2 */
+	{"MFRad13"},		/* tuner subdevice of SF16-FMD2 */
+	/* ene_ir */
+	{"ENE0100"},
+	{"ENE0200"},
+	{"ENE0201"},
+	{"ENE0202"},
+	/* fintek-cir */
+	{"FIT0002"},		/* CIR */
+	/* ite-cir */
+	{"ITE8704"},		/* Default model */
+	{"ITE8713"},		/* CIR found in EEEBox 1501U */
+	{"ITE8708"},		/* Bridged IT8512 */
+	{"ITE8709"},		/* SRAM-Bridged IT8512 */
+	/* nuvoton-cir */
+	{"WEC0530"},		/* CIR */
+	{"NTN0530"},		/* CIR for new chip's pnp id */
+	/* Winbond CIR */
+	{"WEC1022"},
+	/* wbsd */
+	{"WEC0517"},
+	{"WEC0518"},
+	/* Winbond CIR */
+	{"TCM5090"},		/* 3Com Etherlink III (TP) */
+	{"TCM5091"},		/* 3Com Etherlink III */
+	{"TCM5094"},		/* 3Com Etherlink III (combo) */
+	{"TCM5095"},		/* 3Com Etherlink III (TPO) */
+	{"TCM5098"},		/* 3Com Etherlink III (TPC) */
+	{"PNP80f7"},		/* 3Com Etherlink III compatible */
+	{"PNP80f8"},		/* 3Com Etherlink III compatible */
+	/* nsc-ircc */
+	{"NSC6001"},
+	{"HWPC224"},
+	{"IBM0071"},
+	/* smsc-ircc2 */
+	{"SMCf010"},
+	/* sb1000 */
+	{"GIC1000"},
+	/* parport_pc */
+	{"PNP0400"},		/* Standard LPT Printer Port */
+	{"PNP0401"},		/* ECP Printer Port */
+	/* apple-gmux */
+	{"APP000B"},
+	/* fujitsu-laptop.c */
+	{"FUJ02bf"},
+	{"FUJ02B1"},
+	{"FUJ02E3"},
+	/* system */
+	{"PNP0c02"},		/* General ID for reserving resources */
+	{"PNP0c01"},		/* memory controller */
+	/* rtc_cmos */
+	{"PNP0b00"},
+	{"PNP0b01"},
+	{"PNP0b02"},
+	/* c6xdigio */
+	{"PNP0400"},		/* Standard LPT Printer Port */
+	{"PNP0401"},		/* ECP Printer Port */
+	/* ni_atmio.c */
+	{"NIC1900"},
+	{"NIC2400"},
+	{"NIC2500"},
+	{"NIC2600"},
+	{"NIC2700"},
+	/* serial */
+	{"AAC000F"},		/* Archtek America Corp. Archtek SmartLink Modem 3334BT Plug & Play */
+	{"ADC0001"},		/* Anchor Datacomm BV. SXPro 144 External Data Fax Modem Plug & Play */
+	{"ADC0002"},		/* SXPro 288 External Data Fax Modem Plug & Play */
+	{"AEI0250"},		/* PROLiNK 1456VH ISA PnP K56flex Fax Modem */
+	{"AEI1240"},		/* Actiontec ISA PNP 56K X2 Fax Modem */
+	{"AKY1021"},		/* Rockwell 56K ACF II Fax+Data+Voice Modem */
+	{"AZT4001"},		/* AZT3005 PnP SOUND DEVICE */
+	{"BDP3336"},		/* Best Data Products Inc. Smart One 336F PnP Modem */
+	{"BRI0A49"},		/* Boca Complete Ofc Communicator 14.4 Data-FAX */
+	{"BRI1400"},		/* Boca Research 33,600 ACF Modem */
+	{"BRI3400"},		/* Boca 33.6 Kbps Internal FD34FSVD */
+	{"BRI0A49"},		/* Boca 33.6 Kbps Internal FD34FSVD */
+	{"BDP3336"},		/* Best Data Products Inc. Smart One 336F PnP Modem */
+	{"CPI4050"},		/* Computer Peripherals Inc. EuroViVa CommCenter-33.6 SP PnP */
+	{"CTL3001"},		/* Creative Labs Phone Blaster 28.8 DSVD PnP Voice */
+	{"CTL3011"},		/* Creative Labs Modem Blaster 28.8 DSVD PnP Voice */
+	{"DAV0336"},		/* Davicom ISA 33.6K Modem */
+	{"DMB1032"},		/* Creative Modem Blaster Flash56 DI5601-1 */
+	{"DMB2001"},		/* Creative Modem Blaster V.90 DI5660 */
+	{"ETT0002"},		/* E-Tech CyberBULLET PC56RVP */
+	{"FUJ0202"},		/* Fujitsu 33600 PnP-I2 R Plug & Play */
+	{"FUJ0205"},		/* Fujitsu FMV-FX431 Plug & Play */
+	{"FUJ0206"},		/* Fujitsu 33600 PnP-I4 R Plug & Play */
+	{"FUJ0209"},		/* Fujitsu Fax Voice 33600 PNP-I5 R Plug & Play */
+	{"GVC000F"},		/* Archtek SmartLink Modem 3334BT Plug & Play */
+	{"GVC0303"},		/* Archtek SmartLink Modem 3334BRV 33.6K Data Fax Voice */
+	{"HAY0001"},		/* Hayes Optima 288 V.34-V.FC + FAX + Voice Plug & Play */
+	{"HAY000C"},		/* Hayes Optima 336 V.34 + FAX + Voice PnP */
+	{"HAY000D"},		/* Hayes Optima 336B V.34 + FAX + Voice PnP */
+	{"HAY5670"},		/* Hayes Accura 56K Ext Fax Modem PnP */
+	{"HAY5674"},		/* Hayes Accura 56K Ext Fax Modem PnP */
+	{"HAY5675"},		/* Hayes Accura 56K Fax Modem PnP */
+	{"HAYF000"},		/* Hayes 288, V.34 + FAX */
+	{"HAYF001"},		/* Hayes Optima 288 V.34 + FAX + Voice, Plug & Play */
+	{"IBM0033"},		/* IBM Thinkpad 701 Internal Modem Voice */
+	{"PNP4972"},		/* Intermec CV60 touchscreen port */
+	{"IXDC801"},		/* Intertex 28k8 33k6 Voice EXT PnP */
+	{"IXDC901"},		/* Intertex 33k6 56k Voice EXT PnP */
+	{"IXDD801"},		/* Intertex 28k8 33k6 Voice SP EXT PnP */
+	{"IXDD901"},		/* Intertex 33k6 56k Voice SP EXT PnP */
+	{"IXDF401"},		/* Intertex 28k8 33k6 Voice SP INT PnP */
+	{"IXDF801"},		/* Intertex 28k8 33k6 Voice SP EXT PnP */
+	{"IXDF901"},		/* Intertex 33k6 56k Voice SP EXT PnP */
+	{"KOR4522"},		/* KORTEX 28800 Externe PnP */
+	{"KORF661"},		/* KXPro 33.6 Vocal ASVD PnP */
+	{"LAS4040"},		/* LASAT Internet 33600 PnP */
+	{"LAS4540"},		/* Lasat Safire 560 PnP */
+	{"LAS5440"},		/* Lasat Safire 336  PnP */
+	{"MNP0281"},		/* Microcom TravelPorte FAST V.34 Plug & Play */
+	{"MNP0336"},		/* Microcom DeskPorte V.34 FAST or FAST+ Plug & Play */
+	{"MNP0339"},		/* Microcom DeskPorte FAST EP 28.8 Plug & Play */
+	{"MNP0342"},		/* Microcom DeskPorte 28.8P Plug & Play */
+	{"MNP0500"},		/* Microcom DeskPorte FAST ES 28.8 Plug & Play */
+	{"MNP0501"},		/* Microcom DeskPorte FAST ES 28.8 Plug & Play */
+	{"MNP0502"},		/* Microcom DeskPorte 28.8S Internal Plug & Play */
+	{"MOT1105"},		/* Motorola BitSURFR Plug & Play */
+	{"MOT1111"},		/* Motorola TA210 Plug & Play */
+	{"MOT1114"},		/* Motorola HMTA 200 (ISDN) Plug & Play */
+	{"MOT1115"},		/* Motorola BitSURFR Plug & Play */
+	{"MOT1190"},		/* Motorola Lifestyle 28.8 Internal */
+	{"MOT1501"},		/* Motorola V.3400 Plug & Play */
+	{"MOT1502"},		/* Motorola Lifestyle 28.8 V.34 Plug & Play */
+	{"MOT1505"},		/* Motorola Power 28.8 V.34 Plug & Play */
+	{"MOT1509"},		/* Motorola ModemSURFR External 28.8 Plug & Play */
+	{"MOT150A"},		/* Motorola Premier 33.6 Desktop Plug & Play */
+	{"MOT150F"},		/* Motorola VoiceSURFR 56K External PnP */
+	{"MOT1510"},		/* Motorola ModemSURFR 56K External PnP */
+	{"MOT1550"},		/* Motorola ModemSURFR 56K Internal PnP */
+	{"MOT1560"},		/* Motorola ModemSURFR Internal 28.8 Plug & Play */
+	{"MOT1580"},		/* Motorola Premier 33.6 Internal Plug & Play */
+	{"MOT15B0"},		/* Motorola OnlineSURFR 28.8 Internal Plug & Play */
+	{"MOT15F0"},		/* Motorola VoiceSURFR 56K Internal PnP */
+	{"MVX00A1"},		/*  Deskline K56 Phone System PnP */
+	{"MVX00F2"},		/* PC Rider K56 Phone System PnP */
+	{"nEC8241"},		/* NEC 98NOTE SPEAKER PHONE FAX MODEM(33600bps) */
+	{"PMC2430"},		/* Pace 56 Voice Internal Plug & Play Modem */
+	{"PNP0500"},		/* Generic standard PC COM port     */
+	{"PNP0501"},		/* Generic 16550A-compatible COM port */
+	{"PNPC000"},		/* Compaq 14400 Modem */
+	{"PNPC001"},		/* Compaq 2400/9600 Modem */
+	{"PNPC031"},		/* Dial-Up Networking Serial Cable between 2 PCs */
+	{"PNPC032"},		/* Dial-Up Networking Parallel Cable between 2 PCs */
+	{"PNPC100"},		/* Standard 9600 bps Modem */
+	{"PNPC101"},		/* Standard 14400 bps Modem */
+	{"PNPC102"},		/*  Standard 28800 bps Modem */
+	{"PNPC103"},		/*  Standard Modem */
+	{"PNPC104"},		/*  Standard 9600 bps Modem */
+	{"PNPC105"},		/*  Standard 14400 bps Modem */
+	{"PNPC106"},		/*  Standard 28800 bps Modem */
+	{"PNPC107"},		/*  Standard Modem */
+	{"PNPC108"},		/* Standard 9600 bps Modem */
+	{"PNPC109"},		/* Standard 14400 bps Modem */
+	{"PNPC10A"},		/* Standard 28800 bps Modem */
+	{"PNPC10B"},		/* Standard Modem */
+	{"PNPC10C"},		/* Standard 9600 bps Modem */
+	{"PNPC10D"},		/* Standard 14400 bps Modem */
+	{"PNPC10E"},		/* Standard 28800 bps Modem */
+	{"PNPC10F"},		/* Standard Modem */
+	{"PNP2000"},		/* Standard PCMCIA Card Modem */
+	{"ROK0030"},		/* Rockwell 33.6 DPF Internal PnP, Modular Technology 33.6 Internal PnP */
+	{"ROK0100"},		/* KORTEX 14400 Externe PnP */
+	{"ROK4120"},		/* Rockwell 28.8 */
+	{"ROK4920"},		/* Viking 28.8 INTERNAL Fax+Data+Voice PnP */
+	{"RSS00A0"},		/* Rockwell 33.6 DPF External PnP, BT Prologue 33.6 External PnP, Modular Technology 33.6 External PnP */
+	{"RSS0262"},		/* Viking 56K FAX INT */
+	{"RSS0250"},		/* K56 par,VV,Voice,Speakphone,AudioSpan,PnP */
+	{"SUP1310"},		/* SupraExpress 28.8 Data/Fax PnP modem */
+	{"SUP1381"},		/* SupraExpress 336i PnP Voice Modem */
+	{"SUP1421"},		/* SupraExpress 33.6 Data/Fax PnP modem */
+	{"SUP1590"},		/* SupraExpress 33.6 Data/Fax PnP modem */
+	{"SUP1620"},		/* SupraExpress 336i Sp ASVD */
+	{"SUP1760"},		/* SupraExpress 33.6 Data/Fax PnP modem */
+	{"SUP2171"},		/* SupraExpress 56i Sp Intl */
+	{"TEX0011"},		/* Phoebe Micro 33.6 Data Fax 1433VQH Plug & Play */
+	{"UAC000F"},		/* Archtek SmartLink Modem 3334BT Plug & Play */
+	{"USR0000"},		/* 3Com Corp. Gateway Telepath IIvi 33.6 */
+	{"USR0002"},		/* U.S. Robotics Sporster 33.6K Fax INT PnP */
+	{"USR0004"},		/*  Sportster Vi 14.4 PnP FAX Voicemail */
+	{"USR0006"},		/* U.S. Robotics 33.6K Voice INT PnP */
+	{"USR0007"},		/* U.S. Robotics 33.6K Voice EXT PnP */
+	{"USR0009"},		/* U.S. Robotics Courier V.Everything INT PnP */
+	{"USR2002"},		/* U.S. Robotics 33.6K Voice INT PnP */
+	{"USR2070"},		/* U.S. Robotics 56K Voice INT PnP */
+	{"USR2080"},		/* U.S. Robotics 56K Voice EXT PnP */
+	{"USR3031"},		/* U.S. Robotics 56K FAX INT */
+	{"USR3050"},		/* U.S. Robotics 56K FAX INT */
+	{"USR3070"},		/* U.S. Robotics 56K Voice INT PnP */
+	{"USR3080"},		/* U.S. Robotics 56K Voice EXT PnP */
+	{"USR3090"},		/* U.S. Robotics 56K Voice INT PnP */
+	{"USR9100"},		/* U.S. Robotics 56K Message  */
+	{"USR9160"},		/* U.S. Robotics 56K FAX EXT PnP */
+	{"USR9170"},		/* U.S. Robotics 56K FAX INT PnP */
+	{"USR9180"},		/* U.S. Robotics 56K Voice EXT PnP */
+	{"USR9190"},		/* U.S. Robotics 56K Voice INT PnP */
+	{"WACFXXX"},		/* Wacom tablets */
+	{"FPI2002"},		/* Compaq touchscreen */
+	{"FUJ02B2"},		/* Fujitsu Stylistic touchscreens */
+	{"FUJ02B3"},
+	{"FUJ02B4"},		/* Fujitsu Stylistic LT touchscreens */
+	{"FUJ02B6"},		/* Passive Fujitsu Stylistic touchscreens */
+	{"FUJ02B7"},
+	{"FUJ02B8"},
+	{"FUJ02B9"},
+	{"FUJ02BC"},
+	{"FUJ02E5"},		/* Fujitsu Wacom Tablet PC device */
+	{"FUJ02E6"},		/* Fujitsu P-series tablet PC device */
+	{"FUJ02E7"},		/* Fujitsu Wacom 2FGT Tablet PC device */
+	{"FUJ02E9"},		/* Fujitsu Wacom 1FGT Tablet PC device */
+	{"LTS0001"},		/* LG C1 EXPRESS DUAL (C1-PB11A3) touch screen (actually a FUJ02E6 in disguise) */
+	{"WCI0003"},		/* Rockwell's (PORALiNK) 33600 INT PNP */
+	{"WEC1022"},		/* Winbond CIR port, should not be probed. We should keep track of it to prevent the legacy serial driver from probing it */
+	{"PNPCXXX"},		/* Unknown PnP modems */
+	{"PNPDXXX"},		/* More unknown PnP modems */
+	/* scl200wdt */
+	{"NSC0800"},		/* National Semiconductor PC87307/PC97307 watchdog component */
+	/* mpu401 */
+	{"PNPb006"},
+	/* cs423x-pnpbios */
+	{"CSC0100"},
+	{"CSC0000"},
+	{"GIM0100"},		/* Guillemot Turtlebeach something appears to be cs4232 compatible */
+	/* es18xx-pnpbios */
+	{"ESS1869"},
+	{"ESS1879"},
+	/* snd-opl3sa2-pnpbios */
+	{"YMH0021"},
+	{"NMX2210"},		/* Gateway Solo 2500 */
+	{""},
+};
+
+static bool is_hex_digit(char c)
+{
+	return (c >= 0 && c <= '9') || (c >= 'A' && c <= 'F');
+}
+
+static bool matching_id(char *idstr, char *list_id)
+{
+	int i;
+
+	if (memcmp(idstr, list_id, 3))
+		return false;
+
+	for (i = 3; i < 7; i++) {
+		char c = toupper(idstr[i]);
+
+		if (!is_hex_digit(c)
+		    || (list_id[i] != 'X' && c != toupper(list_id[i])))
+			return false;
+	}
+	return true;
+}
+
+static bool acpi_pnp_match(char *idstr, const struct acpi_device_id **matchid)
+{
+	const struct acpi_device_id *devid;
+
+	for (devid = acpi_pnp_device_ids; devid->id[0]; devid++)
+		if (matching_id(idstr, (char *)devid->id)) {
+			if (matchid)
+				*matchid = devid;
+
+			return true;
+		}
+
+	return false;
+}
+
+static int acpi_pnp_attach(struct acpi_device *adev,
+			   const struct acpi_device_id *id)
+{
+	return 1;
+}
+
+static struct acpi_scan_handler acpi_pnp_handler = {
+	.ids = acpi_pnp_device_ids,
+	.match = acpi_pnp_match,
+	.attach = acpi_pnp_attach,
+};
+
+/*
+ * For CMOS RTC devices, the PNP ACPI scan handler does not work, because
+ * there is a CMOS RTC ACPI scan handler installed already, so we need to
+ * check those devices and enumerate them to the PNP bus directly.
+ */
+static int is_cmos_rtc_device(struct acpi_device *adev)
+{
+	struct acpi_device_id ids[] = {
+		{ "PNP0B00" },
+		{ "PNP0B01" },
+		{ "PNP0B02" },
+		{""},
+	};
+	return !acpi_match_device_ids(adev, ids);
+}
+
+bool acpi_is_pnp_device(struct acpi_device *adev)
+{
+	return adev->handler == &acpi_pnp_handler || is_cmos_rtc_device(adev);
+}
+EXPORT_SYMBOL_GPL(acpi_is_pnp_device);
+
+void __init acpi_pnp_init(void)
+{
+	acpi_scan_add_handler(&acpi_pnp_handler);
+}
Index: linux-pm/drivers/acpi/internal.h
===================================================================
--- linux-pm.orig/drivers/acpi/internal.h
+++ linux-pm/drivers/acpi/internal.h
@@ -30,6 +30,7 @@ void acpi_pci_root_init(void);
 void acpi_pci_link_init(void);
 void acpi_processor_init(void);
 void acpi_platform_init(void);
+void acpi_pnp_init(void);
 int acpi_sysfs_init(void);
 #ifdef CONFIG_ACPI_CONTAINER
 void acpi_container_init(void);
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -2253,6 +2253,7 @@ int __init acpi_scan_init(void)
 	acpi_cmos_rtc_init();
 	acpi_container_init();
 	acpi_memory_hotplug_init();
+	acpi_pnp_init();
 
 	mutex_lock(&acpi_scan_lock);
 	/*
Index: linux-pm/drivers/pnp/pnpacpi/core.c
===================================================================
--- linux-pm.orig/drivers/pnp/pnpacpi/core.c
+++ linux-pm/drivers/pnp/pnpacpi/core.c
@@ -30,26 +30,6 @@
 
 static int num;
 
-/* We need only to blacklist devices that have already an acpi driver that
- * can't use pnp layer. We don't need to blacklist device that are directly
- * used by the kernel (PCI root, ...), as it is harmless and there were
- * already present in pnpbios. But there is an exception for devices that
- * have irqs (PIC, Timer) because we call acpi_register_gsi.
- * Finally, only devices that have a CRS method need to be in this list.
- */
-static struct acpi_device_id excluded_id_list[] __initdata = {
-	{"PNP0C09", 0},		/* EC */
-	{"PNP0C0F", 0},		/* Link device */
-	{"PNP0000", 0},		/* PIC */
-	{"PNP0100", 0},		/* Timer */
-	{"", 0},
-};
-
-static inline int __init is_exclusive_device(struct acpi_device *dev)
-{
-	return (!acpi_match_device_ids(dev, excluded_id_list));
-}
-
 /*
  * Compatible Device IDs
  */
@@ -266,7 +246,7 @@ static int __init pnpacpi_add_device(str
 	if (!pnpid)
 		return 0;
 
-	if (is_exclusive_device(device) || !device->status.present)
+	if (!device->status.present)
 		return 0;
 
 	dev = pnp_alloc_dev(&pnpacpi_protocol, num, pnpid);
@@ -326,10 +306,10 @@ static acpi_status __init pnpacpi_add_de
 {
 	struct acpi_device *device;
 
-	if (!acpi_bus_get_device(handle, &device))
-		pnpacpi_add_device(device);
-	else
+	if (acpi_bus_get_device(handle, &device))
 		return AE_CTRL_DEPTH;
+	if (acpi_is_pnp_device(device))
+		pnpacpi_add_device(device);
 	return AE_OK;
 }
 
Index: linux-pm/include/linux/acpi.h
===================================================================
--- linux-pm.orig/include/linux/acpi.h
+++ linux-pm/include/linux/acpi.h
@@ -184,6 +184,8 @@ extern int ec_transaction(u8 command,
                           u8 *rdata, unsigned rdata_len);
 extern acpi_handle ec_get_handle(void);
 
+extern bool acpi_is_pnp_device(struct acpi_device *);
+
 #if defined(CONFIG_ACPI_WMI) || defined(CONFIG_ACPI_WMI_MODULE)
 
 typedef void (*wmi_notify_handler) (u32 value, void *context);

