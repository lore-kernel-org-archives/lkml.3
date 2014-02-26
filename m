Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbaBZJOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 04:14:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:52394 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbaBZJLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 04:11:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,546,1389772800"; 
   d="scan'208";a="488297821"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com,
        Zhang Rui <rui.zhang@intel.com>
Subject: [RFC PATCH 2/8] PNPACPI: use whilte list for pnpacpi device enumeration
Date: Wed, 26 Feb 2014 17:11:08 +0800
Message-Id: <1393405874-3266-3-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393405874-3266-1-git-send-email-rui.zhang@intel.com>
References: <1393405874-3266-1-git-send-email-rui.zhang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI can be used to enumerate PNP devices, but the code does not
handle this in a good manner.

Currently, if an ACPI device
1. has _CRS method,
2. has an identifications of
   "three capital charactors followed by four hex numbers",
3. is not in the exclude list,
it is enumerated to PNP bus.

So actually, PNP bus is used as the default bus for enumerating _HID devices.

But, nowadays, more and more _HID devices are needed to be enumerate to
platform bus instead. And a white list is used for those devices to avoid
overlapping with PNP bus.
The problem is that this list is continuously growing.

So, a solution that uses platform bus as the default bus for _HID enumeration
is preferred.
In order to do this, this patch changes the way of enumerating PNP devices.
As the first step, we use a white list to create PNP devices instead.
This white list contains all the pnp_device_id strings in all the pnp drivers,
thus this change is transparent to PNP core and all the PNP drivers.

Note: I just grep all the id strings in all pnp_device_id instances and
      copy them to the new white list, with a few changes to the comments
      only, to follow the format of:

      /* driver name, or file name if not a PNP driver */
      {"id-string"}, /* optional comments for the id-string */
      ...

The next steps would be reduce this PNPACPI white list by
1. remove the ids for the devices that are never enumerated via ACPI
2. remove the ids and convert the drivers to platform bus drivers
   for the devices that are not PNP devices in nature.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/scan.c        |    2 +
 drivers/pnp/pnpacpi/core.c |  395 ++++++++++++++++++++++++++++++++++++++++----
 include/linux/pnp.h        |    3 +
 3 files changed, 366 insertions(+), 34 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index dca22eb..5967338 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -11,6 +11,7 @@
 #include <linux/kthread.h>
 #include <linux/dmi.h>
 #include <linux/nls.h>
+#include <linux/pnp.h>
 
 #include <asm/pgtable.h>
 
@@ -2190,6 +2191,7 @@ int __init acpi_scan_init(void)
 	acpi_container_init();
 	acpi_memory_hotplug_init();
 	acpi_dock_init();
+	acpi_pnp_init();
 
 	mutex_lock(&acpi_scan_lock);
 	/*
diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
index 9f611cb..76df7fc 100644
--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
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
@@ -73,6 +53,317 @@ static int __init ispnpidacpi(const char *id)
 	return 1;
 }
 
+static const struct acpi_device_id acpi_pnp_device_ids[]= {
+	/* pata_isapnp */
+	{"PNP0600"}, /* Generic ESDI/IDE/ATA compatible hard disk controller */
+	/* floppy */
+	{"PNP0700"},
+	/* ipmi_si */
+	{"IPI0001"},
+	/* tpm_inf_pnp */
+	{"IFX0101"}, /* Infineon TPMs */
+	{"IFX0102"}, /* Infineon TPMs */
+	/*tpm_tis */
+	{"PNP0C31"}, /* TPM */
+	{"ATM1200"}, /* Atmel */
+	{"IFX0102"}, /* Infineon */
+	{"BCM0101"}, /* Broadcom */
+	{"BCM0102"}, /* Broadcom */
+	{"NSC1200"}, /* National */
+	{"ICO0102"}, /* Intel */
+	/* ide	 */
+	{"PNP0600"}, /* Generic ESDI/IDE/ATA compatible hard disk controller */
+	/* ns558 */
+	{"@P@0001"}, /* ALS 100 */
+	{"@P@0020"}, /* ALS 200 */
+	{"@P@1001"}, /* ALS 100+ */
+	{"@P@2001"}, /* ALS 120 */
+	{"ASB16fd"}, /* AdLib NSC16 */
+	{"AZT3001"}, /* AZT1008 */
+	{"CDC0001"}, /* Opl3-SAx */
+	{"CSC0001"}, /* CS4232 */
+	{"CSC000f"}, /* CS4236 */
+	{"CSC0101"}, /* CS4327 */
+	{"CTL7001"}, /* SB16 */
+	{"CTL7002"}, /* AWE64 */
+	{"CTL7005"}, /* Vibra16 */
+	{"ENS2020"}, /* SoundscapeVIVO */
+	{"ESS0001"}, /* ES1869 */
+	{"ESS0005"}, /* ES1878 */
+	{"ESS6880"}, /* ES688 */
+	{"IBM0012"}, /* CS4232 */
+	{"OPT0001"}, /* OPTi Audio16 */
+	{"YMH0006"}, /* Opl3-SA */
+	{"YMH0022"}, /* Opl3-SAx */
+	{"PNPb02f"}, /* Generic */
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
+	{"MSM0c24"}, /* ADS Cadet AM/FM Radio Card */
+	/* radio-gemtek */
+	{"ADS7183"}, /* AOpen FX-3D/Pro Radio */
+	/* radio-sf16fmr2 */
+	{"MFRad13"}, /* tuner subdevice of SF16-FMD2 */
+	/* ene_ir */
+	{"ENE0100"},
+	{"ENE0200"},
+	{"ENE0201"},
+	{"ENE0202"},
+	/* fintek-cir */
+	{"FIT0002"}, /* CIR */
+	/* ite-cir */
+	{"ITE8704"}, /* Default model */
+	{"ITE8713"}, /* CIR found in EEEBox 1501U */
+	{"ITE8708"}, /* Bridged IT8512 */
+	{"ITE8709"}, /* SRAM-Bridged IT8512 */
+	/* nuvoton-cir */
+	{"WEC0530"}, /* CIR */
+	{"NTN0530"}, /* CIR for new chip's pnp id*/
+	/* Winbond CIR */
+	{"WEC1022"},
+	/* wbsd */
+	{"WEC0517"},
+	{"WEC0518"},
+	/* Winbond CIR */
+	{"TCM5090"}, /* 3Com Etherlink III (TP) */
+	{"TCM5091"}, /* 3Com Etherlink III */
+	{"TCM5094"}, /* 3Com Etherlink III (combo) */
+	{"TCM5095"}, /* 3Com Etherlink III (TPO) */
+	{"TCM5098"}, /* 3Com Etherlink III (TPC) */
+	{"PNP80f7"}, /* 3Com Etherlink III compatible */
+	{"PNP80f8"}, /* 3Com Etherlink III compatible */
+	/* nsc-ircc */
+	{"NSC6001"},
+	{"HWPC224"},
+	{"IBM0071"},
+	/* smsc-ircc2 */
+	{"SMCf010"},
+	/* sb1000 */
+	{"GIC1000"},
+	/* parport_pc */
+	{"PNP0400"}, /* Standard LPT Printer Port */
+	{"PNP0401"}, /* ECP Printer Port */
+	/* apple-gmux */
+	{"APP000B"},
+	/* fujitsu-laptop.c */
+	{"FUJ02bf"},
+	{"FUJ02B1"},
+	{"FUJ02E3"},
+	/* system */
+	{"PNP0c02"}, /* General ID for reserving resources */
+	{"PNP0c01"}, /* memory controller */
+	/* rtc_cmos */
+	{"PNP0b00"},
+	{"PNP0b01"},
+	{"PNP0b02"},
+	/* c6xdigio */
+        {"PNP0400"}, /* Standard LPT Printer Port */
+        {"PNP0401"}, /* ECP Printer Port */
+	/* ni_atmio.c */
+	{"NIC1900"},
+	{"NIC2400"},
+	{"NIC2500"},
+	{"NIC2600"},
+	{"NIC2700"},
+	/* serial */
+	{"AAC000F"}, /* Archtek America Corp. Archtek SmartLink Modem 3334BT Plug & Play */
+	{"ADC0001"}, /* Anchor Datacomm BV. SXPro 144 External Data Fax Modem Plug & Play */
+	{"ADC0002"}, /* SXPro 288 External Data Fax Modem Plug & Play */
+	{"AEI0250"}, /* PROLiNK 1456VH ISA PnP K56flex Fax Modem */
+	{"AEI1240"}, /* Actiontec ISA PNP 56K X2 Fax Modem */
+	{"AKY1021"}, /* Rockwell 56K ACF II Fax+Data+Voice Modem */
+	{"AZT4001"}, /* AZT3005 PnP SOUND DEVICE */
+	{"BDP3336"}, /* Best Data Products Inc. Smart One 336F PnP Modem */
+	{"BRI0A49"}, /* Boca Complete Ofc Communicator 14.4 Data-FAX */
+	{"BRI1400"}, /* Boca Research 33,600 ACF Modem */
+	{"BRI3400"}, /* Boca 33.6 Kbps Internal FD34FSVD */
+	{"BRI0A49"}, /* Boca 33.6 Kbps Internal FD34FSVD */
+	{"BDP3336"}, /* Best Data Products Inc. Smart One 336F PnP Modem */
+	{"CPI4050"}, /* Computer Peripherals Inc. EuroViVa CommCenter-33.6 SP PnP */
+	{"CTL3001"}, /* Creative Labs Phone Blaster 28.8 DSVD PnP Voice */
+	{"CTL3011"}, /* Creative Labs Modem Blaster 28.8 DSVD PnP Voice */
+	{"DAV0336"}, /* Davicom ISA 33.6K Modem */
+	{"DMB1032"}, /* Creative Modem Blaster Flash56 DI5601-1 */
+	{"DMB2001"}, /* Creative Modem Blaster V.90 DI5660 */
+	{"ETT0002"}, /* E-Tech CyberBULLET PC56RVP */
+	{"FUJ0202"}, /* Fujitsu 33600 PnP-I2 R Plug & Play */
+	{"FUJ0205"}, /* Fujitsu FMV-FX431 Plug & Play */
+	{"FUJ0206"}, /* Fujitsu 33600 PnP-I4 R Plug & Play */
+	{"FUJ0209"}, /* Fujitsu Fax Voice 33600 PNP-I5 R Plug & Play */
+	{"GVC000F"}, /* Archtek SmartLink Modem 3334BT Plug & Play */
+	{"GVC0303"}, /* Archtek SmartLink Modem 3334BRV 33.6K Data Fax Voice */
+	{"HAY0001"}, /* Hayes Optima 288 V.34-V.FC + FAX + Voice Plug & Play */
+	{"HAY000C"}, /* Hayes Optima 336 V.34 + FAX + Voice PnP */
+	{"HAY000D"}, /* Hayes Optima 336B V.34 + FAX + Voice PnP */
+	{"HAY5670"}, /* Hayes Accura 56K Ext Fax Modem PnP */
+	{"HAY5674"}, /* Hayes Accura 56K Ext Fax Modem PnP */
+	{"HAY5675"}, /* Hayes Accura 56K Fax Modem PnP */
+	{"HAYF000"}, /* Hayes 288, V.34 + FAX */
+	{"HAYF001"}, /* Hayes Optima 288 V.34 + FAX + Voice, Plug & Play */
+	{"IBM0033"}, /* IBM Thinkpad 701 Internal Modem Voice */
+	{"PNP4972"}, /* Intermec CV60 touchscreen port */
+	{"IXDC801"}, /* Intertex 28k8 33k6 Voice EXT PnP */
+	{"IXDC901"}, /* Intertex 33k6 56k Voice EXT PnP */
+	{"IXDD801"}, /* Intertex 28k8 33k6 Voice SP EXT PnP */
+	{"IXDD901"}, /* Intertex 33k6 56k Voice SP EXT PnP */
+	{"IXDF401"}, /* Intertex 28k8 33k6 Voice SP INT PnP */
+	{"IXDF801"}, /* Intertex 28k8 33k6 Voice SP EXT PnP */
+	{"IXDF901"}, /* Intertex 33k6 56k Voice SP EXT PnP */
+	{"KOR4522"}, /* KORTEX 28800 Externe PnP */
+	{"KORF661"}, /* KXPro 33.6 Vocal ASVD PnP */
+	{"LAS4040"}, /* LASAT Internet 33600 PnP */
+	{"LAS4540"}, /* Lasat Safire 560 PnP */
+	{"LAS5440"}, /* Lasat Safire 336  PnP */
+	{"MNP0281"}, /* Microcom TravelPorte FAST V.34 Plug & Play */
+	{"MNP0336"}, /* Microcom DeskPorte V.34 FAST or FAST+ Plug & Play */
+	{"MNP0339"}, /* Microcom DeskPorte FAST EP 28.8 Plug & Play */
+	{"MNP0342"}, /* Microcom DeskPorte 28.8P Plug & Play */
+	{"MNP0500"}, /* Microcom DeskPorte FAST ES 28.8 Plug & Play */
+	{"MNP0501"}, /* Microcom DeskPorte FAST ES 28.8 Plug & Play */
+	{"MNP0502"}, /* Microcom DeskPorte 28.8S Internal Plug & Play */
+	{"MOT1105"}, /* Motorola BitSURFR Plug & Play */
+	{"MOT1111"}, /* Motorola TA210 Plug & Play */
+	{"MOT1114"}, /* Motorola HMTA 200 (ISDN) Plug & Play */
+	{"MOT1115"}, /* Motorola BitSURFR Plug & Play */
+	{"MOT1190"}, /* Motorola Lifestyle 28.8 Internal */
+	{"MOT1501"}, /* Motorola V.3400 Plug & Play */
+	{"MOT1502"}, /* Motorola Lifestyle 28.8 V.34 Plug & Play */
+	{"MOT1505"}, /* Motorola Power 28.8 V.34 Plug & Play */
+	{"MOT1509"}, /* Motorola ModemSURFR External 28.8 Plug & Play */
+	{"MOT150A"}, /* Motorola Premier 33.6 Desktop Plug & Play */
+	{"MOT150F"}, /* Motorola VoiceSURFR 56K External PnP */
+	{"MOT1510"}, /* Motorola ModemSURFR 56K External PnP */
+	{"MOT1550"}, /* Motorola ModemSURFR 56K Internal PnP */
+	{"MOT1560"}, /* Motorola ModemSURFR Internal 28.8 Plug & Play */
+	{"MOT1580"}, /* Motorola Premier 33.6 Internal Plug & Play */
+	{"MOT15B0"}, /* Motorola OnlineSURFR 28.8 Internal Plug & Play */
+	{"MOT15F0"}, /* Motorola VoiceSURFR 56K Internal PnP */
+	{"MVX00A1"}, /*  Deskline K56 Phone System PnP */
+	{"MVX00F2"}, /* PC Rider K56 Phone System PnP */
+	{"nEC8241"}, /* NEC 98NOTE SPEAKER PHONE FAX MODEM(33600bps) */
+	{"PMC2430"}, /* Pace 56 Voice Internal Plug & Play Modem */
+	{"PNP0500"}, /* Generic standard PC COM port	 */
+	{"PNP0501"}, /* Generic 16550A-compatible COM port */
+	{"PNPC000"}, /* Compaq 14400 Modem */
+	{"PNPC001"}, /* Compaq 2400/9600 Modem */
+	{"PNPC031"}, /* Dial-Up Networking Serial Cable between 2 PCs */
+	{"PNPC032"}, /* Dial-Up Networking Parallel Cable between 2 PCs */
+	{"PNPC100"}, /* Standard 9600 bps Modem */
+	{"PNPC101"}, /* Standard 14400 bps Modem */
+	{"PNPC102"}, /*  Standard 28800 bps Modem*/
+	{"PNPC103"}, /*  Standard Modem*/
+	{"PNPC104"}, /*  Standard 9600 bps Modem*/
+	{"PNPC105"}, /*  Standard 14400 bps Modem*/
+	{"PNPC106"}, /*  Standard 28800 bps Modem*/
+	{"PNPC107"}, /*  Standard Modem */
+	{"PNPC108"}, /* Standard 9600 bps Modem */
+	{"PNPC109"}, /* Standard 14400 bps Modem */
+	{"PNPC10A"}, /* Standard 28800 bps Modem */
+	{"PNPC10B"}, /* Standard Modem */
+	{"PNPC10C"}, /* Standard 9600 bps Modem */
+	{"PNPC10D"}, /* Standard 14400 bps Modem */
+	{"PNPC10E"}, /* Standard 28800 bps Modem */
+	{"PNPC10F"}, /* Standard Modem */
+	{"PNP2000"}, /* Standard PCMCIA Card Modem */
+	{"ROK0030"}, /* Rockwell 33.6 DPF Internal PnP, Modular Technology 33.6 Internal PnP */
+	{"ROK0100"}, /* KORTEX 14400 Externe PnP */
+	{"ROK4120"}, /* Rockwell 28.8 */
+	{"ROK4920"}, /* Viking 28.8 INTERNAL Fax+Data+Voice PnP */
+	{"RSS00A0"}, /* Rockwell 33.6 DPF External PnP, BT Prologue 33.6 External PnP, Modular Technology 33.6 External PnP */
+	{"RSS0262"}, /* Viking 56K FAX INT */
+	{"RSS0250"}, /* K56 par,VV,Voice,Speakphone,AudioSpan,PnP */
+	{"SUP1310"}, /* SupraExpress 28.8 Data/Fax PnP modem */
+	{"SUP1381"}, /* SupraExpress 336i PnP Voice Modem */
+	{"SUP1421"}, /* SupraExpress 33.6 Data/Fax PnP modem */
+	{"SUP1590"}, /* SupraExpress 33.6 Data/Fax PnP modem */
+	{"SUP1620"}, /* SupraExpress 336i Sp ASVD */
+	{"SUP1760"}, /* SupraExpress 33.6 Data/Fax PnP modem */
+	{"SUP2171"}, /* SupraExpress 56i Sp Intl */
+	{"TEX0011"}, /* Phoebe Micro 33.6 Data Fax 1433VQH Plug & Play */
+	{"UAC000F"}, /* Archtek SmartLink Modem 3334BT Plug & Play */
+	{"USR0000"}, /* 3Com Corp. Gateway Telepath IIvi 33.6 */
+	{"USR0002"}, /* U.S. Robotics Sporster 33.6K Fax INT PnP */
+	{"USR0004"}, /*  Sportster Vi 14.4 PnP FAX Voicemail */
+	{"USR0006"}, /* U.S. Robotics 33.6K Voice INT PnP */
+	{"USR0007"}, /* U.S. Robotics 33.6K Voice EXT PnP */
+	{"USR0009"}, /* U.S. Robotics Courier V.Everything INT PnP */
+	{"USR2002"}, /* U.S. Robotics 33.6K Voice INT PnP */
+	{"USR2070"}, /* U.S. Robotics 56K Voice INT PnP */
+	{"USR2080"}, /* U.S. Robotics 56K Voice EXT PnP */
+	{"USR3031"}, /* U.S. Robotics 56K FAX INT */
+	{"USR3050"}, /* U.S. Robotics 56K FAX INT */
+	{"USR3070"}, /* U.S. Robotics 56K Voice INT PnP */
+	{"USR3080"}, /* U.S. Robotics 56K Voice EXT PnP */
+	{"USR3090"}, /* U.S. Robotics 56K Voice INT PnP */
+	{"USR9100"}, /* U.S. Robotics 56K Message  */
+	{"USR9160"}, /* U.S. Robotics 56K FAX EXT PnP*/
+	{"USR9170"}, /* U.S. Robotics 56K FAX INT PnP*/
+	{"USR9180"}, /* U.S. Robotics 56K Voice EXT PnP*/
+	{"USR9190"}, /* U.S. Robotics 56K Voice INT PnP*/
+	{"WACFXXX"}, /* Wacom tablets */
+	{"FPI2002"}, /* Compaq touchscreen */
+	{"FUJ02B2"}, /* Fujitsu Stylistic touchscreens */
+	{"FUJ02B3"},
+	{"FUJ02B4"}, /* Fujitsu Stylistic LT touchscreens */
+	{"FUJ02B6"}, /* Passive Fujitsu Stylistic touchscreens */
+	{"FUJ02B7"},
+	{"FUJ02B8"},
+	{"FUJ02B9"},
+	{"FUJ02BC"},
+	{"FUJ02E5"}, /* Fujitsu Wacom Tablet PC device */
+	{"FUJ02E6"}, /* Fujitsu P-series tablet PC device */
+	{"FUJ02E7"}, /* Fujitsu Wacom 2FGT Tablet PC device */
+	{"FUJ02E9"}, /* Fujitsu Wacom 1FGT Tablet PC device */
+	{"LTS0001"}, /* LG C1 EXPRESS DUAL (C1-PB11A3) touch screen (actually a FUJ02E6 in disguise) */
+	{"WCI0003"}, /* Rockwell's (PORALiNK) 33600 INT PNP */
+	{"WEC1022"}, /* Winbond CIR port, should not be probed. We should keep track of it to prevent the legacy serial driver from probing it */
+	{"PNPCXXX"}, /* Unknown PnP modems */
+	{"PNPDXXX"}, /* More unknown PnP modems */
+	/* scl200wdt */
+	{"NSC0800"}, /* National Semiconductor PC87307/PC97307 watchdog component */
+	/* mpu401 */
+	{"PNPb006"},
+	/* cs423x-pnpbios */
+	{"CSC0100"},
+	{"CSC0000"},
+	{"GIM0100"}, /* Guillemot Turtlebeach something appears to be cs4232 compatible */
+	/* es18xx-pnpbios */
+	{"ESS1869"},
+	{"ESS1879"},
+	/* snd-opl3sa2-pnpbios */
+	{"YMH0021"},
+	{"NMX2210"}, /* Gateway Solo 2500 */
+	{""},
+};
+
 static int pnpacpi_get_resources(struct pnp_dev *dev)
 {
 	pnp_dbg(&dev->dev, "get resources\n");
@@ -258,7 +549,7 @@ static int __init pnpacpi_add_device(struct acpi_device *device)
 	if (!pnpid)
 		return 0;
 
-	if (is_exclusive_device(device) || !device->status.present)
+	if (!device->status.present)
 		return 0;
 
 	dev = pnp_alloc_dev(&pnpacpi_protocol, num, pnpid);
@@ -312,19 +603,6 @@ static int __init pnpacpi_add_device(struct acpi_device *device)
 	return 0;
 }
 
-static acpi_status __init pnpacpi_add_device_handler(acpi_handle handle,
-						     u32 lvl, void *context,
-						     void **rv)
-{
-	struct acpi_device *device;
-
-	if (!acpi_bus_get_device(handle, &device))
-		pnpacpi_add_device(device);
-	else
-		return AE_CTRL_DEPTH;
-	return AE_OK;
-}
-
 static int __init acpi_pnp_match(struct device *dev, void *_pnp)
 {
 	struct acpi_device *acpi = to_acpi_device(dev);
@@ -361,6 +639,55 @@ static struct acpi_bus_type __initdata acpi_pnp_bus = {
 };
 
 int pnpacpi_disabled __initdata;
+
+static int __init acpi_pnp_scan_handler_attach(struct acpi_device *adev,
+                                   const struct acpi_device_id *id)
+{
+	return 1;
+}
+
+static int __init acpi_pnp_scan_handler_match(char *devid, char *handlerid)
+{
+	int i;
+
+	if (!ispnpidacpi(devid))
+		return 0;
+
+	if (memcmp(devid, handlerid, 3))
+		return 0;
+
+        for (i = 3; i < 7; i++) {
+                if (handlerid[i] != 'X' &&
+		    toupper(devid[i]) != toupper(handlerid[i]))
+                        return 0;
+        }
+	return 1;
+}
+
+static struct acpi_scan_handler pnpacpi_handler __initdata = {
+	.ids = acpi_pnp_device_ids,
+	.match = acpi_pnp_scan_handler_match,
+	.attach = acpi_pnp_scan_handler_attach,
+};
+
+void __init acpi_pnp_init(void)
+{
+	acpi_scan_add_handler(&pnpacpi_handler);
+}
+
+static acpi_status __init pnpacpi_add_device_handler(acpi_handle handle,
+						     u32 lvl, void *context,
+						     void **rv)
+{
+	struct acpi_device *device;
+
+	if (acpi_bus_get_device(handle, &device))
+		return AE_CTRL_DEPTH;
+	if (device->handler == &pnpacpi_handler)
+		pnpacpi_add_device(device);
+	return AE_OK;
+}
+
 static int __init pnpacpi_init(void)
 {
 	if (acpi_disabled || pnpacpi_disabled) {
diff --git a/include/linux/pnp.h b/include/linux/pnp.h
index 195aafc..b329699 100644
--- a/include/linux/pnp.h
+++ b/include/linux/pnp.h
@@ -343,8 +343,11 @@ static inline struct acpi_device *pnp_acpi_device(struct pnp_dev *dev)
 		return dev->data;
 	return NULL;
 }
+
+void acpi_pnp_init(void);
 #else
 #define pnp_acpi_device(dev) 0
+static inline void acpi_pnp_init(void) {}
 #endif
 
 /* status */
-- 
1.7.9.5

