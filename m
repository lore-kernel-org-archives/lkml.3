Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933484Ab3LINHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 08:07:09 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:35640 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932548Ab3LINHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 08:07:06 -0500
Message-ID: <52A5C024.5050702@linaro.org>
Date: Mon, 09 Dec 2013 21:05:40 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Arnd Bergmann <arnd@arndb.de>, Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "patches@linaro.org" <patches@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Linaro-acpi] [RFC part1 PATCH 1/7] ACPI: Make ACPI core running
 without PCI on ARM64
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org> <201312052304.22302.arnd@arndb.de> <52A1E794.1040008@linaro.org> <201312061823.26481.arnd@arndb.de> <52A54328.3000709@linaro.org> <20131209115050.GA19163@arm.com>
In-Reply-To: <20131209115050.GA19163@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-12-9 19:50, Catalin Marinas wrote:
> On Mon, Dec 09, 2013 at 04:12:24AM +0000, Hanjun Guo wrote:
>> On 2013-12-7 1:23, Arnd Bergmann wrote:
>>> On Friday 06 December 2013, Tomasz Nowicki wrote:
>>>> On 05.12.2013 23:04, Arnd Bergmann wrote:
>>>>> On Wednesday 04 December 2013, Hanjun Guo wrote:
>>>>>> On 2013年12月04日 00:41, Matthew Garrett wrote:
>>>>>>> Given the number of #ifdefs you're adding, wouldn't it make more sense
>>>>>>> to just add stub functions to include/linux/pci.h?
>>>>>>
>>>>>> Thanks for the suggestion :)
>>>>>>
>>>>>> I can add stub functions in include/linux/pci.h for raw_pci_read()/
>>>>>> raw_pci_write(), then can remove #ifdefs for acpi_os_read/write_pci_configuration().
>>>>>
>>>>> Actually I wonder about the usefulness of this patch in either form: Since ACPI
>>>>> on ARM64 is only for servers, I would very much expect them to always come with
>>>>> PCI, either physical host bridges with attached devices, or logical PCI functions
>>>>> used to describe the on-SoC I/O devices. Even in case of virtual machines, you'd
>>>>> normally use PCI as the method to communicate data about the virtio channels.
>>>>>
>>>>> Can you name a realistic use-case where you'd want ACPI but not PCI?
>>>>
>>>> Yes you can describe SoC I/O devices using logical PCI functions only if 
>>>> they are on PCI, correct me if I am wrong. Also, devices can be placed 
>>>> only on IOMEM (like for ARM SoC) and it is hard to predict which way 
>>>> vendors chose. So way don't let it be configurable? ACPI spec says 
>>>> nothing like PCI is needed for ACPI, AFAIK.
>>>
>>> You are right that today's ARM SoCs basically never use PCI to describe
>>> internal devices (IIRC VIA VT8500 is an exception, but their PCI was
>>> just a software fabrication).
>>>
>>> However, when we're talking about ACPI on ARM64, that is nothing like classic
>>> ARM SoCs: As Jon Masters mentioned, this is about new server hardware following
>>> a (still secret, but hopefully not much longer) hardware specification that is
>>> explicitly designed to allow interoperability between vendors, so they
>>> must have put some thought into how to make the hardware discoverable. It
>>> seems that they are modeling things after how it's done on x86, and the
>>> only sensible way to have discoverable hardware there is PCI. This is
>>> also what all x86 SoCs do.
>>
>> I think the concern here is that ACPI is only for server platform or not.
>>
>> Since ACPI has lots of content related to power management, I think ACPI
>> can be used for mobile devices and other platform too, not only for ARM
>> servers, and with this patch, we can support both requirement.
> 
> 'Can be used' is one thing, will it really be used is another? I don't
> think so, it was (well, is) difficult enough to make the transition to
> FDT, I don't see how ACPI would solve the current issues.
> 
> I see ACPI as a server distro requirement and there are indeed benefits
> in abstracting the hardware behind standard description, AML. Of course,
> this would work even better with probe-able buses like PCIe and I'm
> pretty sure this would be the case on high-end servers. But even if a
> server distro like RHEL supports a SoC without PCIe, I would expect them
> to only provide a single binary Image with CONFIG_PCI enabled.
> 
> This patch is small enough and allows ACPI build with !CONFIG_PCI for
> the time being but longer term I would expect such SoCs without PCI to
> be able to run on a kernel with CONFIG_PCI enabled.

Yes, we will support PCI in ACPI in the long run, and we just make PCI
optional for ACPI in this patch.

Actually, I had reworked this patch and make the code with minimal
changes to ACPI code:


Not all the ARM64 targets that are using ACPI have PCI, so introduce
some stub functions to make ACPI core run without CONFIG_PCI on ARM64.

pcibios_penalize_isa_irq() is arch dependent, introduce asm/pci.h to
include it.

Since ACPI on X86 and IA64 depends on PCI, it will not break X86 and
IA64 with this patch.

Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
Signed-off-by: Al Stone <al.stone@linaro.org>
Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/arm64/include/asm/pci.h |   13 +++++++++++++
 drivers/acpi/Makefile        |    2 +-
 drivers/acpi/internal.h      |    5 +++++
 include/linux/pci.h          |   32 +++++++++++++++++++++++---------
 4 files changed, 42 insertions(+), 10 deletions(-)
 create mode 100644 arch/arm64/include/asm/pci.h

diff --git a/arch/arm64/include/asm/pci.h b/arch/arm64/include/asm/pci.h
new file mode 100644
index 0000000..e682c25
--- /dev/null
+++ b/arch/arm64/include/asm/pci.h
@@ -0,0 +1,13 @@
+#ifndef ASMARM_PCI_H
+#define ASMARM_PCI_H
+
+#ifdef __KERNEL__
+
+static inline void pcibios_penalize_isa_irq(int irq, int active)
+{
+	/* We don't do dynamic PCI IRQ allocation */
+}
+
+#endif /* __KERNEL__ */
+
+#endif
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 0331f91..d8cebe3 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -38,7 +38,7 @@ acpi-y				+= acpi_processor.o
 acpi-y				+= processor_core.o
 acpi-y				+= ec.o
 acpi-$(CONFIG_ACPI_DOCK)	+= dock.o
-acpi-y				+= pci_root.o pci_link.o pci_irq.o
+acpi-$(CONFIG_PCI)		+= pci_root.o pci_link.o pci_irq.o
 acpi-$(CONFIG_X86_INTEL_LPSS)	+= acpi_lpss.o
 acpi-y				+= acpi_platform.o
 acpi-y				+= power.o
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index b125fdb..b1ef8fa 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -26,8 +26,13 @@
 acpi_status acpi_os_initialize1(void);
 int init_acpi_device_notify(void);
 int acpi_scan_init(void);
+#ifdef CONFIG_PCI
 void acpi_pci_root_init(void);
 void acpi_pci_link_init(void);
+#else
+static inline void acpi_pci_root_init(void) {}
+static inline void acpi_pci_link_init(void) {}
+#endif /* CONFIG_PCI */
 void acpi_processor_init(void);
 void acpi_platform_init(void);
 int acpi_sysfs_init(void);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 1084a15..28334dd 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -541,15 +541,6 @@ struct pci_ops {
 	int (*write)(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 val);
 };

-/*
- * ACPI needs to be able to access PCI config space before we've done a
- * PCI bus scan and created pci_bus structures.
- */
-int raw_pci_read(unsigned int domain, unsigned int bus, unsigned int devfn,
-		 int reg, int len, u32 *val);
-int raw_pci_write(unsigned int domain, unsigned int bus, unsigned int devfn,
-		  int reg, int len, u32 val);
-
 struct pci_bus_region {
 	resource_size_t start;
 	resource_size_t end;
@@ -1280,6 +1271,15 @@ typedef int (*arch_set_vga_state_t)(struct pci_dev *pdev, bool decode,
 		      unsigned int command_bits, u32 flags);
 void pci_register_set_vga_state(arch_set_vga_state_t func);

+/*
+ * ACPI needs to be able to access PCI config space before we've done a
+ * PCI bus scan and created pci_bus structures.
+ */
+int raw_pci_read(unsigned int domain, unsigned int bus, unsigned int devfn,
+		 int reg, int len, u32 *val);
+int raw_pci_write(unsigned int domain, unsigned int bus, unsigned int devfn,
+		  int reg, int len, u32 val);
+
 #else /* CONFIG_PCI is not enabled */

 /*
@@ -1476,6 +1476,20 @@ static inline int pci_domain_nr(struct pci_bus *bus)
 static inline struct pci_dev *pci_dev_get(struct pci_dev *dev)
 { return NULL; }

+static inline struct pci_bus *pci_find_bus(int domain, int busnr)
+{ return NULL; }
+
+static inline int pci_bus_write_config_byte(struct pci_bus *bus,
+			unsigned int devfn, int where, u8 val);
+{ return -ENODEV; }
+
+static inline int raw_pci_read(unsigned int domain, unsigned int bus,
+		unsigned int devfn, int reg, int len, u32 *val);
+{ return -EINVAL; }
+static inline int raw_pci_write(unsigned int domain, unsigned int bus,
+		unsigned int devfn, int reg, int len, u32 val);
+{return -EINVAL; }
+
 #define dev_is_pci(d) (false)
 #define dev_is_pf(d) (false)
 #define dev_num_vf(d) (0)

--
Hanjun

