Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbaIIO2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:28:50 -0400
Received: from mail.pawisda.de ([213.157.4.156]:46180 "EHLO
	mailrelay.pawisda.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593AbaIIO2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:28:48 -0400
X-Greylist: delayed 1965 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Sep 2014 10:28:48 EDT
Message-ID: <540F06F1.1040608@lsexperts.de>
Date: Tue, 09 Sep 2014 15:56:01 +0200
From: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Conrad Kostecki <ck@conrad-kostecki.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: Re: AW: AW: AW: [PATCH] x86: HPET force enable for Soekris net6501
References: <4729ad4b8d3342c1b0e29fefe4b04d6a@DB4PR04MB265.eurprd04.prod.outlook.com> <52FE5683.6030708@zytor.com> <aedabafbb1f0433c9d67ee998971150c@DB4PR04MB265.eurprd04.prod.outlook.com> <52FE5BB6.9070405@zytor.com> <1051d374173243b2828efcd21f60ac36@DB4PR04MB265.e <0363648bf9644167bf5aa0a954cd145b@DB4PR04MB265.eurprd04.prod.outlook.com>
In-Reply-To: <0363648bf9644167bf5aa0a954cd145b@DB4PR04MB265.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Conrad,

On 02/14/2014 07:28 PM, Conrad Kostecki wrote:
>> On 02/14/2014 10:13 AM, Conrad Kostecki wrote:
>>>>
>>>> Does it have DMI?
>>>
>>> Unfortunately not.
>>>
>>> # dmidecode 2.12
>>> # No SMBIOS nor DMI entry point found, sorry.
>>>
>>
>> Sigh.  Does anyone have contacts at Soekris who can 
>> complain about this stuff?
> 
> I don't think, that Soekris will fix this. No model of Soekris ever
> had implemented DMI. Their BIOS (called comBIOS) is completely written
> by them. Output is via serial port only. 
> At least I know, that the technical engineers at Soekris respond on 
> sales@soekris.com.
> 
> Maybe the patch could be extended, that HPET would be only enabled if 
> there is no ACPI present?
we are facing the same issue with these systems. Maybe the following patch,
which is based on yours, would be acceptable for mainline.

Best regards,
Eric Sesterhenn


This patch enables a quirk for the Soekris net6501 HPET if
pciquirks=soekris_e6xx" is supplied at the kernel commandline,
Without these patches the clocksource defaults to jiffies, which
is unstable.

Signed-off-by: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index ff898bb..7c3faf5 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -6,6 +6,25 @@

 #include <asm/hpet.h>

+static int pciquirk_soekris;
+
+static int __init parse_pciquirks(char *str)
+{
+
+	while (str) {
+		char *next = strchr(str, ',');
+
+		if (next)
+			*next++ = 0;
+		if (!strncmp("soekris_e6xx", str, 12))
+			pciquirk_soekris = 1;
+		str = next;
+	}
+        return 1;
+}
+__setup("pciquirks=", parse_pciquirks);
+
+
 #if defined(CONFIG_X86_IO_APIC) && defined(CONFIG_SMP) && defined(CONFIG_PCI)

 static void quirk_intel_irqbalance(struct pci_dev *dev)
@@ -498,6 +517,28 @@ void force_hpet_resume(void)
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
+	if (pciquirk_soekris != 1)
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
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 6ed0bb7..aa0d390 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2860,6 +2860,7 @@
 #define PCI_DEVICE_ID_INTEL_82372FB_1	0x7601
 #define PCI_DEVICE_ID_INTEL_SCH_LPC	0x8119
 #define PCI_DEVICE_ID_INTEL_SCH_IDE	0x811a
+#define PCI_DEVICE_ID_INTEL_E6XX_CU	0x8183
 #define PCI_DEVICE_ID_INTEL_ITC_LPC	0x8186
 #define PCI_DEVICE_ID_INTEL_82454GX	0x84c4
 #define PCI_DEVICE_ID_INTEL_82450GX	0x84c5











