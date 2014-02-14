Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaBNKir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 05:38:47 -0500
Received: from mail-db3lp0077.outbound.protection.outlook.com ([213.199.154.77]:40591
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751323AbaBNKiq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 05:38:46 -0500
X-Greylist: delayed 896 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Feb 2014 05:38:45 EST
From: Conrad Kostecki <ck@conrad-kostecki.de>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>
Subject: [PATCH] x86: HPET force enable for Soekris net6501
Thread-Topic: [PATCH] x86: HPET force enable for Soekris net6501
Thread-Index: AQHPKW68eF3VOEekGkmzriEhDKIWtg==
Date: Fri, 14 Feb 2014 10:23:45 +0000
Message-ID: <4729ad4b8d3342c1b0e29fefe4b04d6a@DB4PR04MB265.eurprd04.prod.outlook.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.124.237.237]
x-forefront-prvs: 01221E3973
x-forefront-antispam-report: SFV:NSPM;SFS:(10019001)(6009001)(189002)(199002)(65816001)(33646001)(94946001)(53806001)(54356001)(63696002)(85306002)(56776001)(80976001)(59766001)(77982001)(19580395003)(19580405001)(83322001)(66066001)(46102001)(94316002)(74482001)(47446002)(75402002)(575784001)(93516002)(47976001)(86362001)(50986001)(74662001)(31966008)(81816001)(51856001)(15975445006)(47736001)(95416001)(49866001)(93136001)(76576001)(15202345003)(76786001)(74366001)(69226001)(90146001)(74316001)(74876001)(2656002)(87266001)(74706001)(87936001)(81342001)(81542001)(76796001)(81686001)(56816005)(85852003)(92566001)(4396001)(79102001)(54316002)(83072002)(76176001)(95666001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:DB4PR04MB266;H:DB4PR04MB265.eurprd04.prod.outlook.com;CLIP:192.124.237.237;FPR:E2B1D1E3.CCA9B1A.1D86F50.C0E29EB0.202AA;InfoNoRecordsMX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: conrad-kostecki.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
as the Soekris net6501 does not have any ACPI implementation, HPET won't get enabled.
This patch enables HPET on such platforms.

[    0.430149] pci 0000:00:01.0: Force enabled HPET at 0xfed00000
[    0.644838] HPET: 3 timers in total, 0 timers will be used for per-cpu timer

Original patch by Peter Neubauer, slightly modified by me.
-> http://www.mail-archive.com/soekris-tech@lists.soekris.com/msg06462.html

Cheers
Conrad

Signed-off-by: Peter Neubauer <pneubauer@bluerwhite.org>
Signed-off-by: Conrad Kostecki <ck@conrad-kostecki.de>

--- a/arch/x86/kernel/quirks.c	2014-02-14 11:13:27.703432732 +0100
+++ b/arch/x86/kernel/quirks.c	2014-02-14 11:14:32.327496474 +0100
@@ -498,6 +498,25 @@ void force_hpet_resume(void)
 }
 
 /*
+ * Soekris net6501, based on Atom E6xx series, does not have ACPI.
+ * HPET should be force enabled on such platforms.
+ */
+static void e6xx_force_enable_hpet(struct pci_dev *dev)
+{
+	if (hpet_address || force_hpet_address)
+		return;
+
+	force_hpet_address = 0xFED00000;
+	force_hpet_resume_type = NONE_FORCE_HPET_RESUME;
+	dev_printk(KERN_DEBUG, &dev->dev, "Force enabled HPET at "
+		"0x%lx\n", force_hpet_address);
+	return;
+}
+
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_E6XX_CU,
+			 e6xx_force_enable_hpet);
+
+/*
  * HPET MSI on some boards (ATI SB700/SB800) has side effect on
  * floppy DMA. Disable HPET MSI on such platforms.
  * See erratum #27 (Misinterpreted MSI Requests May Result in
--- a/include/linux/pci_ids.h	2014-02-14 11:13:00.575408953 +0100
+++ b/include/linux/pci_ids.h	2014-02-14 11:13:37.819442066 +0100
@@ -2854,6 +2854,7 @@
 #define PCI_DEVICE_ID_INTEL_82372FB_1	0x7601
 #define PCI_DEVICE_ID_INTEL_SCH_LPC	0x8119
 #define PCI_DEVICE_ID_INTEL_SCH_IDE	0x811a
+#define PCI_DEVICE_ID_INTEL_E6XX_CU	0x8183
 #define PCI_DEVICE_ID_INTEL_ITC_LPC	0x8186
 #define PCI_DEVICE_ID_INTEL_82454GX	0x84c4
 #define PCI_DEVICE_ID_INTEL_82450GX	0x84c5

