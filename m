Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbaG2Qj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 12:39:57 -0400
Received: from service87.mimecast.com ([91.220.42.44]:41119 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944AbaG2Qjy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 12:39:54 -0400
Message-ID: <53D7CE79.1080809@arm.com>
Date: Tue, 29 Jul 2014 17:40:25 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@linaro.org>, Robert Richter <rric@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/19] ARM64 / ACPI: Make PCI optional for ACPI on ARM64
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org> <1406206825-15590-6-git-send-email-hanjun.guo@linaro.org>
In-Reply-To: <1406206825-15590-6-git-send-email-hanjun.guo@linaro.org>
X-OriginalArrivalTime: 29 Jul 2014 16:39:51.0284 (UTC) FILETIME=[B7DFFB40:01CFAB4B]
X-MC-Unique: 114072917395207301
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 24/07/14 14:00, Hanjun Guo wrote:
> As PCI for ARM64 is not ready, so introduce some stub functions
> to make PCI optional for ACPI, and make ACPI core run without
> CONFIG_PCI on ARM64.
>
> Since ACPI on X86 and IA64 depends on PCI and this patch only makes
> PCI optinal for ARM64, it will not break anything on X86 and IA64.
>
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>   arch/arm64/include/asm/pci.h |   11 +++++++++++
>   drivers/acpi/Makefile        |    2 +-
>   drivers/acpi/internal.h      |    5 +++++
>   include/linux/pci.h          |   37 +++++++++++++++++++++++++++----------
>   4 files changed, 44 insertions(+), 11 deletions(-)
>   create mode 100644 arch/arm64/include/asm/pci.h
>
> diff --git a/arch/arm64/include/asm/pci.h b/arch/arm64/include/asm/pci.h
> new file mode 100644
> index 0000000..250cd24
> --- /dev/null
> +++ b/arch/arm64/include/asm/pci.h
> @@ -0,0 +1,11 @@
> +#ifndef __ASM_PCI_H
> +#define __ASM_PCI_H
> +#ifdef __KERNEL__
> +
> +/*
> + * PCI address space differs from physical memory address space
> + */
> +#define PCI_DMA_BUS_IS_PHYS	(0)
> +
> +#endif  /* __KERNEL__ */
> +#endif  /* __ASM_PCI_H */
> diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
> index 505d4d7..8e9bbe6 100644
> --- a/drivers/acpi/Makefile
> +++ b/drivers/acpi/Makefile
> @@ -39,7 +39,7 @@ acpi-y				+= processor_core.o
>   acpi-$(CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC) += processor_pdc.o
>   acpi-y				+= ec.o
>   acpi-$(CONFIG_ACPI_DOCK)	+= dock.o
> -acpi-y				+= pci_root.o pci_link.o pci_irq.o
> +acpi-$(CONFIG_PCI)		+= pci_root.o pci_link.o pci_irq.o
>   acpi-y				+= acpi_lpss.o
>   acpi-y				+= acpi_platform.o
>   acpi-y				+= acpi_pnp.o
> diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
> index 4c5cf77..e1e6487 100644
> --- a/drivers/acpi/internal.h
> +++ b/drivers/acpi/internal.h
> @@ -26,8 +26,13 @@
>   acpi_status acpi_os_initialize1(void);
>   int init_acpi_device_notify(void);
>   int acpi_scan_init(void);
> +#ifdef CONFIG_PCI
>   void acpi_pci_root_init(void);
>   void acpi_pci_link_init(void);
> +#else
> +static inline void acpi_pci_root_init(void) {}
> +static inline void acpi_pci_link_init(void) {}
> +#endif
>   void acpi_processor_init(void);
>   void acpi_platform_init(void);
>   void acpi_pnp_init(void);
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 466bcd1..27d7354 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h

[...]

> @@ -1394,6 +1395,23 @@ static inline struct pci_dev *pci_get_bus_and_slot(unsigned int bus,
>   						unsigned int devfn)
>   { return NULL; }
>
> +static inline struct pci_bus *pci_find_bus(int domain, int busnr)
> +{ return NULL; }
> +
> +static inline int pci_bus_write_config_byte(struct pci_bus *bus,
> +				unsigned int devfn, int where, u8 val)
> +{ return -ENODEV; }
> +
> +static inline int raw_pci_read(unsigned int domain, unsigned int bus,
> +			unsigned int devfn, int reg, int len, u32 *val)
> +{ return -EINVAL; }
> +
> +static inline int raw_pci_write(unsigned int domain, unsigned int bus,
> +			unsigned int devfn, int reg, int len, u32 val)
> +{ return -EINVAL; }

IMO -ENOSYS is more suitable as these functions are not implemented
for !CONFIG_PCI

Regards,
Sudeep

