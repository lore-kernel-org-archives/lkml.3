Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbbALLlw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:41:52 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:59854 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbbALLlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:41:50 -0500
Date: Mon, 12 Jan 2015 11:41:41 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh@kernel.org>, Robert Richter <rric@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Timur Tabi <timur@codeaurora.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH v6 08/17] ARM64 / ACPI: Parse FADT table to get PSCI
 flags for PSCI init
Message-ID: <20150112114141.GA14519@red-moon>
References: <1420368918-5086-1-git-send-email-hanjun.guo@linaro.org>
 <1420368918-5086-9-git-send-email-hanjun.guo@linaro.org>
 <20150109190400.GD13478@red-moon>
 <54B34D01.8090600@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54B34D01.8090600@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 04:26:41AM +0000, Hanjun Guo wrote:
> On 2015年01月10日 03:04, Lorenzo Pieralisi wrote:
> > On Sun, Jan 04, 2015 at 10:55:09AM +0000, Hanjun Guo wrote:
> >> There are two flags: PSCI_COMPLIANT and PSCI_USE_HVC. When set,
> >> the former signals to the OS that the firmware is PSCI compliant.
> >> The latter selects the appropriate conduit for PSCI calls by
> >> toggling between Hypervisor Calls (HVC) and Secure Monitor Calls
> >> (SMC).
> >>
> >> FADT table contains such information, parse FADT to get the flags
> >> for PSCI init. Since ACPI 5.1 doesn't support self defined PSCI
> >> function IDs, which means that only PSCI 0.2+ is supported in ACPI.
> >>
> >> At the same time, only ACPI 5.1 or higher verison supports PSCI,
> >> and FADT Major.Minor version was introduced in ACPI 5.1, so we
> >> will check the version and only parse FADT table with version >= 5.1.
> >>
> >> If firmware provides ACPI tables with ACPI version less than 5.1,
> >> OS will be messed up with those information and have no way to init
> >> smp and GIC, so disable ACPI if we get an FADT table with version
> >> less that 5.1.
> >
> > I am a bit confused by this log. I understand the problem is that,
> > for versions predating 5.1, PSCI information is missing. So, I would
> > say:
> >
> > "OS will not be able to boot properly owing to missing PSCI bindings
> > data in the ACPI tables".
> >
> > Is that the message you want to get across ?
> 
> Not exactly. PSCI is part of the updates for ACPI 5.1, and more updates
> are for GIC (MADT table), without those updates in GIC (MADT table), we
> can not get the MPIDR for SMP init, and can not get the right GICC
> base_address for GICv2 init too (GICC base_address was there in ACPI 5.0
> , but the offset to the start of the structure was changed in ACPI 5.1)
> so if we use the ACPI 5.1 OS code to parse ACPI 5.0 firmware table, it
> will messed up teh OS boot, not only because of PSCI.
> 
> Should I update the Change log here?

Thanks for the explanation.

So basically this means you can't boot arm64 ACPI with table versions
predating 5.1, right ? Or (version >= 5.1) is a requirement only if
PSCI is the enable method ?

It is what I thought, basically IIUC you are merging two patches in one.
This patch is supposed to get PSCI flags from ACPI tables (ie init PSCI from
ACPI tables), checking the version (which of course is a prerequisite
for parsing PSCI flags too) should have been done in a separate patch,
possibly squashed with the ACPI tables initialization.

I think you should split the patch and be done with that.

[...]

> >> +static int __init acpi_parse_fadt(struct acpi_table_header *table)
> >> +{
> >> +    struct acpi_table_fadt *fadt = (struct acpi_table_fadt *)table;
> >> +
> >> +    /*
> >> +     * Revision in table header is the FADT Major revision,
> >> +     * and there is a minor revision of FADT which was introduced
> >> +     * by ACPI 5.1, we only deal with ACPI 5.1 or newer revision
> >> +     * to get arm boot flags, or we will disable ACPI.
> >> +     */
> >> +    if (table->revision > 5 ||
> >> +        (table->revision == 5 && fadt->minor_revision >= 1))
> >> +            return 0;
> >> +
> >> +    pr_warn("Unsupported FADT revision %d.%d, should be 5.1+, will disable ACPI\n",
> >> +            table->revision, fadt->minor_revision);
> >> +    disable_acpi();
> >
> > I would rename this function, function is checking the FADT
> > revision, make that clear. I think that disable_acpi() should be
> > called on function return, if it fails.
> >
> > To make the "acpi disabling" clearer, why not call this function in
> >
> > psci_acpi_init()
> >
> > something like:
> >
> > int __init psci_acpi_init(void)
> > {
> >
> >       if (acpi_table_parse(ACPI_SIG_FADT, acpi_parse_fadt)) {
> >               pr_err("Can't find FADT or error happened during parsing FADT\n");
> >               disable_acpi();
> >       }
> >       ...
> > }
> >
> > After all you disable ACPI because you can't retrieve PSCI information,
> > am I right ?
> 
> I think we need to consider two scenes:
> 
>   - ACPI version less than 5.1, it definitely needs to disable ACPI
>     because of OS doesn't support that and we don't need to do it;

Patch 1. Actually, why can't you carry out the check at acpi tables
init instead of executing the check when PSCI is initialized ?

Is version >5.1 a requirement only if booting with PSCI ? It does not
seem so from what you said above.

>   - if ACPI version is 5.1 or later, and PSCI flags are missing in
>     FADT table, I think we still can boot the OS with single core (
>     if Parking Protocol is still missing) and print some warning message
>     instead (you can refer to patch 10/17). just disable ACPI may lead
>     to boot failure.

And patch 2, which is what this patch was devised for, to initialize
PSCI from ACPI tables.

> Does it make sense?

Yes, that's why this patch should be split, because it is implementing two
pieces of functionality at once.

Put it differently, checking the version is a requirement that goes beyond
PSCI, as you described above, I do not see why you want to merge the
version check and PSCI init together, it obfuscates.

> 
> >
> >> +
> >> +    return -EINVAL;
> >> +}
> >> +
> >>   /*
> >>    * acpi_boot_table_init() called from setup_arch(), always.
> >>    * 1. find RSDP and get its address, and then find XSDT
> >>    * 2. extract all tables and checksums them all
> >> + *  3. check ACPI FADT revisoin
> >
> > s/revisoin/revision
> 
> Good catch, will update it.
> 
> >
> >>    *
> >>    * We can parse ACPI boot-time tables such as MADT after
> >>    * this function is called.
> >> @@ -64,8 +88,13 @@ void __init acpi_boot_table_init(void)
> >>              return;
> >>
> >>      /* Initialize the ACPI boot-time table parser. */
> >> -    if (acpi_table_init())
> >> +    if (acpi_table_init()) {
> >>              disable_acpi();
> >> +            return;
> >> +    }
> >> +
> >> +    if (acpi_table_parse(ACPI_SIG_FADT, acpi_parse_fadt))
> >> +            pr_err("Can't find FADT or error happened during parsing FADT\n");
> >
> > As I said above this is a bit sneaky. It is not clear you are disabling
> > ACPI when the acpi_table_parse() call fails. Is it not better to move
> > the revision check in the PSCI ACPI init call ?
> 
> please refer to the comments above.
> 
> >
> >>   }
> >>
> >>   static int __init parse_acpi(char *arg)
> >> diff --git a/arch/arm64/kernel/psci.c b/arch/arm64/kernel/psci.c
> >> index f1dbca7..dbb3945 100644
> >> --- a/arch/arm64/kernel/psci.c
> >> +++ b/arch/arm64/kernel/psci.c
> >> @@ -15,6 +15,7 @@
> >>
> >>   #define pr_fmt(fmt) "psci: " fmt
> >>
> >> +#include <linux/acpi.h>
> >>   #include <linux/init.h>
> >>   #include <linux/of.h>
> >>   #include <linux/smp.h>
> >> @@ -24,6 +25,7 @@
> >>   #include <linux/slab.h>
> >>   #include <uapi/linux/psci.h>
> >>
> >> +#include <asm/acpi.h>
> >>   #include <asm/compiler.h>
> >>   #include <asm/cpu_ops.h>
> >>   #include <asm/errno.h>
> >> @@ -304,6 +306,33 @@ static void psci_sys_poweroff(void)
> >>      invoke_psci_fn(PSCI_0_2_FN_SYSTEM_OFF, 0, 0, 0);
> >>   }
> >>
> >> +static void psci_0_2_set_functions(void)
> >
> > __init ?
> 
> Yes, it only called by __init function, can be defined as
> __init too.
> 

It can and should :)

[...]

> >> -int __init psci_init(void)
> >> +int __init psci_dt_init(void)
> >>   {
> >>      struct device_node *np;
> >>      const struct of_device_id *matched_np;
> >> @@ -427,6 +434,29 @@ int __init psci_init(void)
> >>      return init_fn(np);
> >>   }
> >>
> >> +/*
> >> + * We use PSCI 0.2+ when ACPI is deployed on ARM64 and it's
> >> + * explicitly clarified in SBBR
> >> + */
> >> +int __init psci_acpi_init(void)
> >> +{
> >> +    if (!acpi_psci_present()) {
> >> +            pr_info("is not implemented in ACPI.\n");
> >> +            return -EOPNOTSUPP;
> >> +    }
> >> +
> >> +    pr_info("probing for conduit method from ACPI.\n");
> >> +
> >> +    if (acpi_psci_use_hvc())
> >> +            invoke_psci_fn = __invoke_psci_fn_hvc;
> >> +    else
> >> +            invoke_psci_fn = __invoke_psci_fn_smc;
> >> +
> >> +    psci_0_2_set_functions();
> >> +
> >> +    return 0;
> >
> > As I asked above, is not there a better way to have a common init
> > function and factor out the acpi/dt paths in it instead of adding
> > multiple calls in setup_arch() ?
> 
> We tried, but it introduced more complexity, so Catalin suggested
> that adding multiple calls in setup_arch (which the way he preferred).

I missed that sorry, I will go back to previous threads and check.

Thanks,
Lorenzo
