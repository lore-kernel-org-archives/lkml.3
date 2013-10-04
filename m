Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab3JDBSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 21:18:10 -0400
Received: from relay1.sgi.com ([192.48.179.29]:42128 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628Ab3JDBSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 21:18:08 -0400
Date: Fri, 4 Oct 2013 02:18:06 +0100
From: Hedi Berriche <hedi@sgi.com>
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ethan Zhao <ethan.zhao@oracle.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Commit 07f9b61 breaks systems that don't implement a _CBA method
Message-ID: <20131004011806.GE20450@dangermouse.emea.sgi.com>
Mail-Followup-To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ethan Zhao <ethan.zhao@oracle.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Yinghai Lu <yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chaps,

The following failure was encountered on hardware that does *not*
implement a _CBA method which is AFAICT (and confirmed to me by BIOS
chaps) optional.

[    1.230647] PCI: MMCONFIG for domain 0000 [bus 00-0c] at [mem 0x80000000-0x80cfffff] (base 0x80000000)
[    1.241046] PCI: MMCONFIG for domain 0001 [bus 00-02] at [mem 0xff84000000-0xff842fffff] (base 0xff84000000)
[    1.252025] PCI: MMCONFIG for domain 1000 [bus 3f-3f] at [mem 0xff83f00000-0xff83ffffff] (base 0xff80000000)
[    1.263006] PCI: MMCONFIG for domain 1001 [bus 3f-3f] at [mem 0xff87f00000-0xff87ffffff] (base 0xff84000000)
[    1.273984] PCI: MMCONFIG at [mem 0x80000000-0x80cfffff] reserved in E820
[    1.281564] PCI: MMCONFIG at [mem 0xff84000000-0xff842fffff] reserved in E820
[    1.289535] PCI: MMCONFIG at [mem 0xff83f00000-0xff83ffffff] reserved in E820
[    1.297505] PCI: MMCONFIG at [mem 0xff87f00000-0xff87ffffff] reserved in E820

<snip>

[    1.427926] ACPI: PCI Root Bridge [I001] (domain 0001 [bus 00-3d])
[    1.434968] acpi PNP0A08:00: fail to add MMCONFIG information, can't access PCI configuration space under this host bridge.
[    1.447405] acpi PNP0A08:00: Bus 0001:00 not present in PCI namespace

...

[    1.454608] ACPI: PCI Root Bridge [S000] (domain 1000 [bus 3f])
[    1.461300] acpi PNP0A08:01: fail to add MMCONFIG information, can't access PCI configuration space under this host bridge.
[    1.473735] acpi PNP0A08:01: Bus 1000:3f not present in PCI namespace

...

[    1.480935] ACPI: PCI Root Bridge [S001] (domain 1001 [bus 3f])
[    1.487630] acpi PNP0A08:02: fail to add MMCONFIG information, can't access PCI configuration space under this host bridge.
[    1.500066] acpi PNP0A08:02: Bus 1001:3f not present in PCI namespace

Bisection points to this commit (included in full given its brevity):

commit 07f9b61c3915e8eb156cb4461b3946736356ad02
Author: ethan.zhao <ethan.zhao@oracle.com>
Date:   Fri Jul 26 11:21:24 2013 -0600

    x86/PCI: MMCONFIG: Check earlier for MMCONFIG region at address zero

    We can check for addr being zero earlier and thus avoid the mutex_unlock()
    cleanup path.

    [bhelgaas: drop warning printk]
    Signed-off-by: ethan.zhao <ethan.zhao@oracle.com>
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
    Acked-by: Yinghai Lu <yinghai@kernel.org>

diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 082e881..5596c7b 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -700,7 +700,7 @@ int pci_mmconfig_insert(struct device *dev, u16 seg, u8 start, u8 end,
        if (!(pci_probe & PCI_PROBE_MMCONF) || pci_mmcfg_arch_init_failed)
                return -ENODEV;

-       if (start > end)
+       if (start > end || !addr)
                return -EINVAL;

        mutex_lock(&pci_mmcfg_lock);
@@ -716,11 +716,6 @@ int pci_mmconfig_insert(struct device *dev, u16 seg, u8 start, u8 end,
                return -EEXIST;
        }

-       if (!addr) {
-               mutex_unlock(&pci_mmcfg_lock);
-               return -EINVAL;
-       }
-
        rc = -EBUSY;
        cfg = pci_mmconfig_alloc(seg, start, end, addr);
        if (cfg == NULL) {


With this change in place, pci_mmconfig_insert(), when called with addr==0
bails out (too) early with -EINVAL and no longer calls into pci_mmconfig_lookup():

693 int pci_mmconfig_insert(struct device *dev, u16 seg, u8 start, u8 end,
694                         phys_addr_t addr)
695 {
696         int rc;
697         struct resource *tmp = NULL;
698         struct pci_mmcfg_region *cfg;
699 
700         if (!(pci_probe & PCI_PROBE_MMCONF) || pci_mmcfg_arch_init_failed)
701                 return -ENODEV;
702 
703         if (start > end || !addr)
704                 return -EINVAL;
705 
706         mutex_lock(&pci_mmcfg_lock);
707         cfg = pci_mmconfig_lookup(seg, start);
708         if (cfg) {
709                 if (cfg->end_bus < end)
710                         dev_info(dev, FW_INFO
711                                  "MMCONFIG for "
712                                  "domain %04x [bus %02x-%02x] "
713                                  "only partially covers this bridge\n",
714                                   cfg->segment, cfg->start_bus, cfg->end_bus);
715                 mutex_unlock(&pci_mmcfg_lock);
716                 return -EEXIST;
717         }

And given the code path reads:

pci_acpi_scan_root()
 setup_mcfg_map()
  pci_mmconfig_insert()

this causes setup_mcfg_map() to fail and go down the check_segment() error
path:

171 static int setup_mcfg_map(struct pci_root_info *info, u16 seg, u8 start,
172                           u8 end, phys_addr_t addr)
173 {
...
188         result = pci_mmconfig_insert(dev, seg, start, end, addr);
189         if (result == 0) {
...
194         } else if (result != -EEXIST)
195                 return check_segment(seg, dev,
196                          "fail to add MMCONFIG information,");
197
198         return 0;
199 }

and this finally causes pci_acpi_scan_root() to skip calling pci_create_root_bus()
and all is doom and gloom:

473 struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
474 {
...
550                 if (!setup_mcfg_map(info, domain, (u8)root->secondary.start,
551                                     (u8)root->secondary.end, root->mcfg_addr))
552                         bus = pci_create_root_bus(NULL, busnum, &pci_root_ops,
553                                                   sd, &resources);

Before the early !addr check came around, pci_mmconfig_insert() used to be allowed to
call into pci_mmconfig_lookup() which, on the HW affected by this problem, finds an
MMCONFIG that *partially* covers the bridge, and causes pci_mmconfig_insert() to return
with an -EEXIST.

-EEXIST doesn't cause setup_mcfg_map() to fail, pci_acpi_scan_root() then
proceeds and calls pci_create_root_bus().

Where does the _CBA method fit in all of this? it's merely because addr will be
always 0 in the absence of _CBA as per the following:

- This is where we set addr (i.e. root->mcfg_addr) that will be passed to setup_mcfg_map()
and from it down to pci_mmconfig_insert():

372 static int acpi_pci_root_add(struct acpi_device *device,
373                              const struct acpi_device_id *not_used)
374 {
...
432         root->mcfg_addr = acpi_pci_root_get_mcfg_addr(handle);

We eventually call into pci_acpi_scan_root():

521         root->bus = pci_acpi_scan_root(root);

acpi_pci_root_get_mcfg_addr() itself reads:

110 phys_addr_t acpi_pci_root_get_mcfg_addr(acpi_handle handle)
111 {
112         acpi_status status = AE_NOT_EXIST;
113         unsigned long long mcfg_addr;
114 
115         if (handle)
116                 status = acpi_evaluate_integer(handle, METHOD_NAME__CBA,
117                                                NULL, &mcfg_addr);
118         if (ACPI_FAILURE(status))
119                 return 0;
120 
121         return (phys_addr_t)mcfg_addr;
122 }

which means that it will return 0 if no _CBA.

FWIW, the above was introduced by commit:

	f4b57a3 PCI/ACPI: provide MMCONFIG address for PCI host bridges

which is fine AFAICT given that it doesn't change the outcome of the non _CBA
case..

So the question is should commit

	07f9b61 x86/PCI: MMCONFIG: Check earlier for MMCONFIG region at address zero

be reverted? or am I missing something?

Cheers,
Hedi.
-- 
Be careful of reading health books, you might die of a misprint.
	-- Mark Twain
