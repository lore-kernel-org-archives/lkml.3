Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbaBML2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 06:28:18 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:50613 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbaBML2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 06:28:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-kernel@lists.linaro.org
Cc: Jingoo Han <jg1.han@samsung.com>, "'Tanmay Inamdar'" <tinamdar@apm.com>,
        devicetree@vger.kernel.org,
        "'Catalin Marinas'" <Catalin.Marinas@arm.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'linux-pci'" <linux-pci@vger.kernel.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'LAKML'" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] pci: Add support for creating a generic host_bridge from device tree
Date: Thu, 13 Feb 2014 12:27:05 +0100
Message-ID: <3204351.WykFFcX4zJ@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <000001cf2899$a6eb75b0$f4c26110$%han@samsung.com>
References: <1391452428-22917-1-git-send-email-Liviu.Dudau@arm.com> <CACoXjc=epN8=tFQKw6kZ27hTA=a+c56q1pikX_SSMKK1rsScCw@mail.gmail.com> <000001cf2899$a6eb75b0$f4c26110$%han@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:2QmTYhR6kn+ZYly90kCc67oJdrefFWpYOecSUSEVrkH
 2dwPDDJWyrEZbatsCGxlv5KSgQLrWDTKwx+GzcyfOrCkQ9TWvs
 iCw3QDuHH5YKdJ3rk4uMRHIq5uNEqgcOh6GvNTJHH+uenM3zXm
 7IDPhNOgHlJd+lPmztnZYEl9XzxsTiKaxvqLHUSaA1vl0Dr/zk
 exJzP3ds4u2rAQP0uU3TifgzGbbY04hGhy1Z4MuH0OPpBQCH+q
 CV5NjSc45HGEqnGNTobDB1WU0er5EnSk8Tev+5KD0BIESW0M2Z
 v5tDxKKAH081Azr6GU6aOU3Vj2DrNSLyDnHveD0IcKu4SAEZ2u
 Fjogxt6bZGpshDqdSMWY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 February 2014 17:57:41 Jingoo Han wrote:
> I want to use 'drivers/pci/host/pcie-designware.c' for both arm32
> and arm64, without any code changes. However, it looks impossible.

It is impossible at the moment, and I agree we have to fix that.

> I made 'drivers/pci/host/pcie-designware.c' based on 32bit arm PCI
> support. Then, with Liviu's patch, do I have to make new code for arm64,
> even though the same HW PCIe IP is used?
> 
> - For arm32
>   drivers/pci/host/pcie-designware.c
> 
> - For arm64
>   drivers/pci/host/pcie-designware-arm64.c

As a start, I'd suggest using "#ifdef CONFIG_ARM" in the driver,
but sharing as much code as you can. We should try to make the #else
section of the #ifdef architecture independent and get have the arm64
implementation shared with any architecture that doesn't have or want
its own pcibios32.c implementation.

> > > I am reviewing and compiling your patch.
> > > Would you consider adding 'struct pci_sys_data' and 'struct hw_pci'?

I would rather get rid of struct hw_pci for architecture independent
drivers and add a different registration method on arm32 that is
compatible with what we come up with on arm64. The main purpose of
hw_pci is to allow multiple PCI controllers to be initialized at
once, but we don't actually need that for any of the "modern" platforms
where we already have a probe function that gets called once for
each controller.

As a start, we could add a pci_host_bridge_register() function like
the one below to arm32 and migrate the drivers/pci/host/ drivers
over to use it with little effort. Instead of filling out hw_pci,
these drivers would allocate (by embedding in their device struct)
and fill out pci_sys_data directly. After that, we can gradually
move more code out of the arm32 implementation into common code, if
it doesn't already exist there, up to the point where a host driver
no longer has to call any function in bios32.c.

	Arnd

diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
index 317da88..12c2178 100644
--- a/arch/arm/kernel/bios32.c
+++ b/arch/arm/kernel/bios32.c
@@ -514,6 +514,26 @@ static void pcibios_init_hw(struct device *parent, struct hw_pci *hw,
 	}
 }
 
+static void pci_common_bus_probe(struct pci_bus *bus)
+{
+	if (!pci_has_flag(PCI_PROBE_ONLY)) {
+		/*
+		 * Size the bridge windows.
+		 */
+		pci_bus_size_bridges(bus);
+
+		/*
+		 * Assign resources.
+		 */
+		pci_bus_assign_resources(bus);
+	}
+
+	/*
+	 * Tell drivers about devices found.
+	 */
+	pci_bus_add_devices(bus);
+}
+
 void pci_common_init_dev(struct device *parent, struct hw_pci *hw)
 {
 	struct pci_sys_data *sys;
@@ -528,27 +548,38 @@ void pci_common_init_dev(struct device *parent, struct hw_pci *hw)
 
 	pci_fixup_irqs(pcibios_swizzle, pcibios_map_irq);
 
-	list_for_each_entry(sys, &head, node) {
-		struct pci_bus *bus = sys->bus;
+	list_for_each_entry(sys, &head, node)
+		pci_common_bus_probe(sys->bus);
+}
 
-		if (!pci_has_flag(PCI_PROBE_ONLY)) {
-			/*
-			 * Size the bridge windows.
-			 */
-			pci_bus_size_bridges(bus);
 
-			/*
-			 * Assign resources.
-			 */
-			pci_bus_assign_resources(bus);
-		}
 
-		/*
-		 * Tell drivers about devices found.
-		 */
-		pci_bus_add_devices(bus);
-	}
+
+int pci_host_bridge_register(struct device *parent, struct pci_sys_data *sys, struct pci_ops *ops, int (*setup)(int nr, struct pci_sys_data *))
+{
+	int ret;
+
+	pci_add_flags(PCI_REASSIGN_ALL_RSRC);
+	INIT_LIST_HEAD(&sys->resources);
+
+	ret = setup(0, sys);
+	if (ret)
+		return ret;
+
+	ret = pcibios_init_resources(0, sys);
+	if (ret)
+		return ret;
+
+	sys->bus = pci_scan_root_bus(parent, sys->busnr, ops, sys, &sys->resources);
+	if (!sys->bus)
+		return -ENODEV;
+
+	pci_fixup_irqs(pcibios_swizzle, pcibios_map_irq);
+
+	pci_common_bus_probe(sys->bus);
+	return ret;
 }
+EXPORT_SYMBOL_GPL(pci_host_bridge_register);
 
 #ifndef CONFIG_PCI_HOST_ITE8152
 void pcibios_set_master(struct pci_dev *dev)

