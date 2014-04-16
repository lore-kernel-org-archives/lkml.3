Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbaDPUbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 16:31:44 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:61942 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930AbaDPUbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 16:31:41 -0400
Date: Wed, 16 Apr 2014 14:31:38 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Zhang, Rui" <rui.zhang@intel.com>, "Lu, Aaron" <aaron.lu@intel.com>,
        lkml <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>,
        "Yan, Zheng Z" <zheng.z.yan@intel.com>
Subject: Re: Info: mapping multiple BARs. Your kernel is fine.
Message-ID: <20140416203138.GA17661@google.com>
References: <20140224162400.GE16457@pd.tnic>
 <744357E9AAD1214791ACBA4B0B9092630121F201@SHSMSX101.ccr.corp.intel.com>
 <CAErSpo55DjkGQB=7ksow34BpCObnY+o3eNnt0n5oQEh6Lfw1pw@mail.gmail.com>
 <1558044.S1G2VU7srO@vostro.rjw.lan>
 <CAErSpo4pDYMhHo6e-1TN6XDRO0xy0u8H+=oucFnrEK+kbjZvzw@mail.gmail.com>
 <20140416190404.GA7070@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140416190404.GA7070@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 09:04:04PM +0200, Borislav Petkov wrote:
> On Thu, Mar 20, 2014 at 02:48:30PM -0600, Bjorn Helgaas wrote:
> > Right.  Even if we had this long-term solution, we'd still have
> > Stephane's current problem, because the PNP0C02 _CRS is still wrong.
> > 
> > We do have a drivers/pnp/quirks.c where we could conceivably adjust
> > the PNP resource if we found the matching PCI device and MCHBAR.  That
> > should solve Stephane's problem even with the current
> > drivers/pnp/system.c.
> 
> Guys, this still triggers in -rc1. Do we have a fix or something
> testable at least?

Hi Boris,

Can you try the patch below?



PNP: Work around Haswell BIOS defect in MCH area reporting

From: Bjorn Helgaas <bhelgaas@google.com>

Work around a Haswell BIOS defect that causes part of the MCH area to be
unreported.

MCHBAR is not an architected PCI BAR, so MCH space is usually reported as a
PNP0C02 resource.  The MCH space was 16KB prior to Haswell, but it is 32KB
in Haswell.  Some Haswell BIOSes still report a PNP0C02 resource that is
only 16KB, which means the rest of the MCH space is consumed but
unreported.

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
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pnp/quirks.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
index 258fef272ea7..023edf592371 100644
--- a/drivers/pnp/quirks.c
+++ b/drivers/pnp/quirks.c
@@ -334,6 +334,57 @@ static void quirk_amd_mmconfig_area(struct pnp_dev *dev)
 }
 #endif
 
+static void quirk_intel_haswell_mch(struct pnp_dev *dev)
+{
+	struct pci_dev *host;
+	u32 addr_lo, addr_hi;
+	struct pci_bus_region region;
+	struct resource mch;
+	struct pnp_resource *pnp_res;
+	struct resource *res;
+
+	host = pci_get_device(PCI_VENDOR_ID_INTEL, 0x0c00, NULL);
+	if (!host)
+		return;
+
+	/*
+	 * MCHBAR is not an architected PCI BAR, so MCH space is usually
+	 * reported as a PNP0C02 resource.  The MCH space was 16KB prior to
+	 * Haswell, but it is 32KB in Haswell.  Some Haswell BIOSes still
+	 * report a PNP0C02 resource that is only 16KB, which means the
+	 * rest of the MCH space is consumed but unreported.
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
+	region.start |= (dma_addr_t) addr_hi << 32;
+	region.end = region.start + 32*1024 - 1 ;
+	pcibios_bus_to_resource(host->bus, &mch, &region);
+
+	list_for_each_entry(pnp_res, &dev->resources, list) {
+		res = &pnp_res->res;
+		if (res->end < mch.start || res->start > mch.end)
+			continue;	/* no overlap */
+		if (res->start == mch.start && res->end == mch.end)
+			continue;	/* exact match */
+
+		dev_info(&dev->dev, FW_BUG
+			 "%pR covers only part of Intel Haswell MCH; extending to %pR\n",
+			 res, &mch);
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
@@ -364,6 +415,7 @@ static struct pnp_fixup pnp_fixups[] = {
 #ifdef CONFIG_AMD_NB
 	{"PNP0c01", quirk_amd_mmconfig_area},
 #endif
+	{"PNP0c02", quirk_intel_haswell_mch},
 	{""}
 };
 
