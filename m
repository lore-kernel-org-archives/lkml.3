Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061AbaHAMJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 08:09:14 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:32992 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbaHAMJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 08:09:11 -0400
Message-ID: <53DB8375.7090503@gmail.com>
Date: Fri, 01 Aug 2014 05:09:25 -0700
From: Rajat Jain <rajatxjain@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <groeck@juniper.net>,
        Rajat Jain <rajatjain@juniper.net>
Subject: PCI/x86 CPU Hangs: Need to enable CRS Software Visibility (Configuration
 Request Retry Status)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hello,

I'm using an Intel Haswell CPU (/proc/cpu at the end of mail). I have a PCIe endpoint (a PLX 8713 NT bridge) that will take a long time to initialize itself after a reset. In accordance with the PCIe spec, the device responds with the CRS when the kernel tries to enumerate the endpoint, trying to indicate that the device is not yet ready.
[Ref: PCIe spec V3.0, pg119, pg127 for "Configuration Request Retry Status") 

This results in a CPU hang because the CPU root port goes into an endless cycle of retries, as the CRS Software Visibility is not enabled:
[Ref commit ad7edfe "[PCI] Do not enable CRS Software Visibility by default" by Linus]

The problem goes away if I enable the CRS software visibility and I see that the kernel moves on after timing out on that device:
pci 0000:30:00.0 id reading try 50 times with interval 20 ms to get ffff0001

Thus in a nutshell I want to enable the CRS Software visibility flag for my platform. From the commit log of the above commit, I'm trying to understand what would be the best way to do it. When the commit log says we should use white list for systems for which CRS should be enabled, and introduce something like pcibios_enable_crs(), do we mean something like this (suggestive patch only)?

---
 arch/x86/pci/common.c |   18 ++++++++++++++++++
 drivers/pci/pci.c     |    5 +++++
 drivers/pci/probe.c   |    2 ++
 include/linux/pci.h   |    1 +
 4 files changed, 26 insertions(+)

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 81ec592..81b961d 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -634,6 +634,24 @@ char * __init pcibios_setup(char *str)
 	return str;
 }
 
+static const struct pci_device_id crs_whitelist[] = {
+	{ PCI_VDEVICE(INTEL, 0x2f00), },
+	{ PCI_VDEVICE(INTEL, 0x2f02), },
+	{ },
+};
+
+void pcibios_enable_crs(struct pci_dev *dev)
+{
+	if (!pci_is_pcie(dev) ||
+	    pci_pcie_type(dev) != PCI_EXP_TYPE_ROOT_PORT)
+		return;
+
+	/* Enable CRS Software visibility only for whitelisted systems */
+	if (pci_match_id(crs_whitelist, dev))
+		pcie_capability_set_word(dev, PCI_EXP_RTCTL,
+					 PCI_EXP_RTCTL_CRSSVE);
+}
+
 unsigned int pcibios_assign_all_busses(void)
 {
 	return (pci_probe & PCI_ASSIGN_ALL_BUSSES) ? 1 : 0;
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 3387c5e..982e8b1 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2685,6 +2685,11 @@ char * __weak __init pcibios_setup(char *str)
 	return str;
 }
 
+void __weak pcibios_enable_crs(struct pci_dev *dev)
+{
+	/* Do nothing by default, and let platforms decide for themselves */
+}
+
 /**
  * pcibios_set_master - enable PCI bus-mastering for device dev
  * @dev: the PCI device to enable
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 1aa058e..a4c50f7 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -801,6 +801,8 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max, int pass)
 	pci_write_config_word(dev, PCI_BRIDGE_CONTROL,
 			      bctl & ~PCI_BRIDGE_CTL_MASTER_ABORT);
 
+	pcibios_enable_crs(dev);
+
 	if ((secondary || subordinate) && !pcibios_assign_all_busses() &&
 	    !is_cardbus && !broken) {
 		unsigned int cmax;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index dbe746f..8ac0b31 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -723,6 +723,7 @@ void pcibios_fixup_bus(struct pci_bus *);
 int __must_check pcibios_enable_device(struct pci_dev *, int mask);
 /* Architecture-specific versions may override this (weak) */
 char *pcibios_setup(char *str);
+void pcibios_enable_crs(struct pci_dev *dev);
 
 /* Used only when drivers/pci/setup.c is used */
 resource_size_t pcibios_align_resource(void *, const struct resource *,
-- 
1.7.9.5



The enabling of CRS software visibility, going by my own problem, seems like a good thing to me to do by default (and probably maintaining a black-list rather than a white-list may be a better idea?). Or at least it should be enabled by default for those root ports that are known to go into an infinite retry loop (such as the Intel one I am using).

FWIW, currently I see it is only being enabled for a Broadcom root port - bcma_core_pci_enable_crs() and my system is running on an Intel Haswell CPU with the /proc/cpuinfo reporting:

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 63
model name      : Genuine Intel(R) CPU @ 1.80GHz
stepping        : 1
microcode       : 0x14
cpu MHz         : 1800.024
cache size      : 20480 KB
physical id     : 0
siblings        : 16
core id         : 0
cpu cores       : 8
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 15
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 fma cx16 xtpr pdcm pcid dca sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm
bogomips        : 3600.04
clflush size    : 64
cache_alignment : 64
address sizes   : 46 bits physical, 48 bits virtual
power management:


Thanks,

Rajat

