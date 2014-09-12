Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbaILLGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 07:06:17 -0400
Received: from mail.pawisda.de ([213.157.4.156]:49395 "EHLO
	mailrelay.pawisda.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbaILLGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 07:06:15 -0400
Message-ID: <5412D3A5.2030909@lsexperts.de>
Date: Fri, 12 Sep 2014 13:06:13 +0200
From: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, Conrad Kostecki <ck@conrad-kostecki.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Peter Neubauer <pneubauer@bluerwhite.org>
Subject: [PATCH] x86: HPET force enable for e6xx based systems
References: <4729ad4b8d3342c1b0e29fefe4b04d6a@DB4PR04MB265.eurprd04.prod.outlook.com> <52FE5683.6030708@zytor.com> <aedabafbb1f0433c9d67ee998971150c@DB4PR04MB265.eurprd04.prod.outlook.com> <52FE5BB6.9070405@zytor.com> <1051d374173243b2828efcd21f60ac36@DB4PR04MB265.e <0363648bf9644167bf5aa0a954cd145b@DB4PR04MB265.eurprd04.prod.outlook.com> <540F06F1.1040608@lsexperts.de> <alpine.DEB.2.10.1409091649510.11037@nanos> <540F1C43.2080708@zytor.com> <5412BFAF.7050900@lsexperts.de> <alpine.DEB.2.10.1409121221580.4178@nanos>
In-Reply-To: <alpine.DEB.2.10.1409121221580.4178@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Neubauer <pneubauer@bluerwhite.org>

as the Soekris net6501 and other e6xx based systems do not have
any ACPI implementation, HPET won't get enabled.
This patch enables HPET on such platforms.

[    0.430149] pci 0000:00:01.0: Force enabled HPET at 0xfed00000
[    0.644838] HPET: 3 timers in total, 0 timers will be used for per-cpu timer

Original patch by Peter Neubauer (http://www.mail-archive.com/soekris-tech@lists.soekris.com/msg06462.html)
slightly modified by Conrad Kostecki <ck@conrad-kostecki.de> and massaged
accoring to Thomas Gleixners <tglx@linutronix.de> by me.

Signed-off-by: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>

---
I am not quite sure how to include Conrad in the tags and if the
Suggested-by tag would be the right way to do this, therefore I have
included him in the description.
The patch is against Linux current git.

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index ff898bb..176a0f9 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -498,6 +498,24 @@ void force_hpet_resume(void)
 }

 /*
+ * According to the datasheet e6xx systems have the HPET hardwired to
+ * 0xfed00000
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
