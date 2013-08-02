Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab3HBWnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 18:43:21 -0400
Received: from mail-db9lp0249.outbound.messaging.microsoft.com ([213.199.154.249]:28152
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752362Ab3HBWnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 18:43:14 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VPS4(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hz70kd2iz1de098h8275bh1de097hz2dh668h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1155h)
X-WSS-ID: 0MQXDRV-01-0MS-02
X-M-MSG: 
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <dougthompson@xmission.com>, <bp@alien8.de>, <bhelgaas@google.com>,
        <jbeulich@suse.com>, <linux-kernel@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-pci@vger.kernel.org>
CC: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH 2/3 V2] EDAC, AMD64_EDAC: Add relevant condition checks as F15h M30h does not support GART or L3.
Date: Fri, 2 Aug 2013 17:43:03 -0500
Message-ID: <1375483384-2302-3-git-send-email-Aravind.Gopalakrishnan@amd.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1375483384-2302-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
References: <1375483384-2302-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding code to check for specific model (F15h, M30h) and if yes,
do not add flag AMD_NB_GART. Also check cpuid_edx(0x80000006) for
prescence of L3. If no L3, do not add any L3 flags.

Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>

diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index 3048ded..3ee7a4d 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -20,6 +20,7 @@ const struct pci_device_id amd_nb_misc_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M10H_F3) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M30H_NB_F3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_NB_F3) },
 	{}
 };
@@ -27,6 +28,7 @@ EXPORT_SYMBOL(amd_nb_misc_ids);
 
 static const struct pci_device_id amd_nb_link_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M30H_NB_F4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_NB_F4) },
 	{}
 };
@@ -81,13 +83,21 @@ int amd_cache_northbridges(void)
 			next_northbridge(misc, amd_nb_misc_ids);
 		node_to_amd_nb(i)->link = link =
 			next_northbridge(link, amd_nb_link_ids);
-        }
+	}
 
+	/* GART present only on Fam15h upto model 0fh */
 	if (boot_cpu_data.x86 == 0xf || boot_cpu_data.x86 == 0x10 ||
-	    boot_cpu_data.x86 == 0x15)
+	    (boot_cpu_data.x86 == 0x15 && boot_cpu_data.x86_model < 0x10))
 		amd_northbridges.flags |= AMD_NB_GART;
 
 	/*
+	 * Check CPUID Fn8000_0006_EDX: L3 Cache Identifiers.
+	 * If == 0, then no need to proceed as there is no L3.
+	 */
+	if (cpuid_edx(0x80000006) == 0)
+		return 0;
+
+	/*
 	 * Some CPU families support L3 Cache Index Disable. There are some
 	 * limitations because of E382 and E388 on family 0x10.
 	 */
-- 
1.7.10.4


