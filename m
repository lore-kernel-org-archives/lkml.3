Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbaDUWRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 18:17:32 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:58315 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560AbaDUWRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 18:17:25 -0400
Subject: [PATCH 2] PNP: Work around BIOS defects in Intel MCH area reporting
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Aaron Lu <aaron.lu@intel.com>, linux-pci@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        linux-acpi@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Zheng Z Yan <zheng.z.yan@intel.com>,
        Dave Jones <davej@redhat.com>, Rui Zhang <rui.zhang@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Date: Mon, 21 Apr 2014 16:17:21 -0600
Message-ID: <20140421221721.26308.1891.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Work around BIOSes that don't report the entire Intel MCH area.

MCHBAR is not an architected PCI BAR, so MCH space is usually reported as a
PNP0C02 resource.  The MCH space was once 16KB, but is 32KB in newer parts.
Some BIOSes still report a PNP0C02 resource that is only 16KB, which means
the rest of the MCH space is consumed but unreported.

This can cause resource map sanity check warnings or (theoretically) a
device conflict if we assigned the unreported space to another device.

The Intel perf event uncore driver tripped over this when it claimed the
MCH region:

  resource map sanity check conflict: 0xfed10000 0xfed15fff 0xfed10000 0xfed13fff pnp 00:01
  Info: mapping multiple BARs. Your kernel is fine.

To prevent this, if we find a PNP0C02 resource that covers part of the MCH
space, extend it to cover the entire space.

Link: http://lkml.kernel.org/r/20140224162400.GE16457@pd.tnic
Reported-by: Borislav Petkov <bp@alien8.de>
Tested-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Borislav Petkov <bp@suse.de>
---
 drivers/pnp/quirks.c |   75 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
index 258fef272ea7..0d679068ef1b 100644
--- a/drivers/pnp/quirks.c
+++ b/drivers/pnp/quirks.c
@@ -15,6 +15,7 @@
 
 #include <linux/types.h>
 #include <linux/kernel.h>
+#include <linux/pci.h>
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/pnp.h>
@@ -334,6 +335,79 @@ static void quirk_amd_mmconfig_area(struct pnp_dev *dev)
 }
 #endif
 
+/* Device IDs of parts that have 32KB MCH space */
+static const unsigned int mch_quirk_devices[] = {
+	0x0154,	/* Ivy Bridge */
+	0x0c00,	/* Haswell */
+};
+
+static struct pci_dev *get_intel_host(void)
+{
+	int i;
+	struct pci_dev *host;
+
+	for (i = 0; i < ARRAY_SIZE(mch_quirk_devices); i++) {
+		host = pci_get_device(PCI_VENDOR_ID_INTEL, mch_quirk_devices[i],
+				      NULL);
+		if (host)
+			return host;
+	}
+	return NULL;
+}
+
+static void quirk_intel_mch(struct pnp_dev *dev)
+{
+	struct pci_dev *host;
+	u32 addr_lo, addr_hi;
+	struct pci_bus_region region;
+	struct resource mch;
+	struct pnp_resource *pnp_res;
+	struct resource *res;
+
+	host = get_intel_host();
+	if (!host)
+		return;
+
+	/*
+	 * MCHBAR is not an architected PCI BAR, so MCH space is usually
+	 * reported as a PNP0C02 resource.  The MCH space was originally
+	 * 16KB, but is 32KB in newer parts.  Some BIOSes still report a
+	 * PNP0C02 resource that is only 16KB, which means the rest of the
+	 * MCH space is consumed but unreported.
+	 */
+
+	/*
+	 * Read MCHBAR for Host Member Mapped Register Range Base
+	 * https://www-ssl.intel.com/content/www/us/en/processors/core/4th-gen-core-family-desktop-vol-2-datasheet
+	 * Sec 3.1.12.
+	 */
+	pci_read_config_dword(host, 0x48, &addr_lo);
+	region.start = addr_lo & ~0x7fff;
+	pci_read_config_dword(host, 0x4c, &addr_hi);
+	region.start |= (u64) addr_hi << 32;
+	region.end = region.start + 32*1024 - 1;
+
+	memset(&mch, 0, sizeof(mch));
+	mch.flags = IORESOURCE_MEM;
+	pcibios_bus_to_resource(host->bus, &mch, &region);
+
+	list_for_each_entry(pnp_res, &dev->resources, list) {
+		res = &pnp_res->res;
+		if (res->end < mch.start || res->start > mch.end)
+			continue;	/* no overlap */
+		if (res->start == mch.start && res->end == mch.end)
+			continue;	/* exact match */
+
+		dev_info(&dev->dev, FW_BUG "PNP resource %pR covers only part of %s Intel MCH; extending to %pR\n",
+			 res, pci_name(host), &mch);
+		res->start = mch.start;
+		res->end = mch.end;
+		break;
+	}
+
+	pci_dev_put(host);
+}
+
 /*
  *  PnP Quirks
  *  Cards or devices that need some tweaking due to incomplete resource info
@@ -364,6 +438,7 @@ static struct pnp_fixup pnp_fixups[] = {
 #ifdef CONFIG_AMD_NB
 	{"PNP0c01", quirk_amd_mmconfig_area},
 #endif
+	{"PNP0c02", quirk_intel_mch},
 	{""}
 };
 

