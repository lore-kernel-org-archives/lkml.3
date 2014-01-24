Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbaAXMxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 07:53:46 -0500
Received: from service87.mimecast.com ([91.220.42.44]:43889 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbaAXMxm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 07:53:42 -0500
Date: Fri, 24 Jan 2014 12:53:33 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Linaro-acpi] [PATCH 04/20] ARM64 / ACPI: Introduce arm_core.c
 and its related head file
Message-ID: <20140124125332.GA23274@e102568-lin.cambridge.arm.com>
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org>
 <1389961514-13562-5-git-send-email-hanjun.guo@linaro.org>
 <20140122115453.GC24288@e102568-lin.cambridge.arm.com>
 <52E13BBC.5020005@linaro.org>
 <52E22DD4.3050807@linaro.org>
MIME-Version: 1.0
In-Reply-To: <52E22DD4.3050807@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 24 Jan 2014 12:53:36.0730 (UTC) FILETIME=[4BF9EBA0:01CF1903]
X-MC-Unique: 114012412533901801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hanjun,

On Fri, Jan 24, 2014 at 09:09:40AM +0000, Hanjun Guo wrote:
> On 2014?01?23? 23:56, Tomasz Nowicki wrote:
> > Hi Lorenzo,
> >
> > W dniu 22.01.2014 12:54, Lorenzo Pieralisi pisze:
> >> On Fri, Jan 17, 2014 at 12:24:58PM +0000, Hanjun Guo wrote:
> >>
> >> [...]
> >>
> >>> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
> >>> index bd9bbd0..2210353 100644
> >>> --- a/arch/arm64/kernel/setup.c
> >>> +++ b/arch/arm64/kernel/setup.c
> >>> @@ -41,6 +41,7 @@
> >>> #include <linux/memblock.h>
> >>> #include <linux/of_fdt.h>
> >>> #include <linux/of_platform.h>
> >>> +#include <linux/acpi.h>
> >>>
> >>> #include <asm/cputype.h>
> >>> #include <asm/elf.h>
> >>> @@ -225,6 +226,11 @@ void __init setup_arch(char **cmdline_p)
> >>>
> >>> arm64_memblock_init();
> >>>
> >>> + /* Parse the ACPI tables for possible boot-time configuration */
> >>> + acpi_boot_table_init();
> >>> + early_acpi_boot_init();
> >>> + acpi_boot_init();
> >>> +
> >>> paging_init();
> >>
> >> Can I ask you please why we need to parse ACPI tables before
> >> paging_init() ?
> > This is for future usage and because of couple of reasons. Mainly SRAT 
> > table parsing should be done (before paging_init()) for proper NUMA 
> > initialization and then paging_init().

Thank you for the explanation. I still have some questions:

1) What are the other reasons ?
2) NUMA is not supported at the moment and I reckon SRAT needs updating
   since the only way to associate a CPU to a memory node is through
   a local APIC id that is non-existent on ARM and at least deserves a
   new entry.

I am still not sure that providing a hook for parsing the ACPI tables before
paging_init() is the main focus at the moment, it is probably best, as we've
mentioned manifold times, to make sure that the infrastructure to detect
ACPI vs DT at run-time is in place in the kernel and allows us to boot
either with ACPI or DT, in a mutual exclusive way (same binary kernel
supporting both, runtime detection/decision on what data to use, ACPI tables
vs DT nodes, detection made once for all and NOT on a per property basis).

I will have a look at SRAT and how it is used on x86, and get back to you on
this.

[...]

> >>> + * acpi_boot_table_init() and acpi_boot_init()
> >>> + * called from setup_arch(), always.
> >>> + * 1. checksums all tables
> >>> + * 2. enumerates lapics
> >>> + * 3. enumerates io-apics
> >>> + *
> >>> + * acpi_table_init() is separated to allow reading SRAT without
> >>> + * other side effects.
> >>> + */
> >>> +void __init acpi_boot_table_init(void)
> >>> +{
> >>> + /*
> >>> + * If acpi_disabled, bail out
> >>> + */
> >>> + if (acpi_disabled)
> >>> + return;
> >>> +
> >>> + /*
> >>> + * Initialize the ACPI boot-time table parser.
> >>> + */
> >>> + if (acpi_table_init()) {
> >>> + disable_acpi();
> >>> + return;
> >>> + }
> >>> +}
> >>> +
> >>> +int __init early_acpi_boot_init(void)
> >>> +{
> >>> + /*
> >>> + * If acpi_disabled, bail out
> >>> + */
> >>> + if (acpi_disabled)
> >>> + return -ENODEV;
> >>> +
> >>> + /*
> >>> + * Process the Multiple APIC Description Table (MADT), if present
> >>> + */
> >>> + early_acpi_process_madt();
> >>> +
> >>> + return 0;
> >>> +}
> >>> +
> >>> +int __init acpi_boot_init(void)
> >>> +{
> >>> + /*
> >>> + * If acpi_disabled, bail out
> >>> + */
> >>> + if (acpi_disabled)
> >>> + return -ENODEV;
> >>> +
> >>> + acpi_table_parse(ACPI_SIG_FADT, acpi_parse_fadt);
> >>> +
> >>> + /*
> >>> + * Process the Multiple APIC Description Table (MADT), if present
> >>> + */
> >>> + acpi_process_madt();
> >>> +
> >>> + return 0;
> >>> +}
> >>
> >> Well, apart from having three init calls, one returning void and two
> >> returning proper values, do not understand why, and do not understand
> >> why we need three calls in the first place...why should we process MADT
> >> twice in two separate calls ? What is supposed to change in between that
> >> prevents you from merging the two together ?
> 
> Thanks for pointing this out. I can merge acpi_boot_table_init() and
> early_acpi_boot_init() together, but can not merge early_acpi_boot_init()
> and acpi_boot_init() together.
> 
> early_acpi_boot_init() and acpi_boot_init() was separated intentionally for
> memory hotplug reasons. memory allocated in this stage can not be migrated
> and cause memory hot-remove failed, in order to keep memory allocated
> at base node (general NUMA node 0 in the system) at boot stage, we should
> parse SRAT first before CPU is enumerated, does this make sense to you?

Are you parsing the SRAT in this series to get memory info or memory is
still initialized by DT even when system is supposed to be booted with ACPI
(ie there is a valid ACPI root table ?)

I have a hunch the latter is what's happening (and that's wrong, because
memory information when kernel is booted through ACPI must be retrieved
from UEFI - at least that's what has been defined), so I still see an early
hook to initialize ACPI tables before paging_init() that has no use as the
current patchset stands, please correct me if I am wrong.

Thank you,
Lorenzo

