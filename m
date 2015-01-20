Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbbATPQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 10:16:50 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:39210 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbbATPQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 10:16:48 -0500
Date: Tue, 20 Jan 2015 15:16:28 +0000
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
        "wangyijing@huawei.com" <wangyijing@huawei.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH v7 10/17] ARM64 / ACPI: Parse MADT for SMP initialization
Message-ID: <20150120151628.GI5398@red-moon>
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
 <1421247905-3749-11-git-send-email-hanjun.guo@linaro.org>
 <20150116181836.GA15836@red-moon>
 <54BE53A3.5010706@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BE53A3.5010706@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 01:09:55PM +0000, Hanjun Guo wrote:

[...]

> >> +{
> >> +       int cpu;
> >> +
> >> +       if (mpidr == INVALID_HWID) {
> >> +               pr_info("Skip MADT cpu entry with invalid MPIDR\n");
> >> +               return -EINVAL;
> >> +       }
> >> +
> >> +       total_cpus++;
> >> +       if (!enabled)
> >> +               return -EINVAL;
> >> +
> >> +       if (enabled_cpus >=  NR_CPUS) {
> >> +               pr_warn("NR_CPUS limit of %d reached, Processor %d/0x%llx ignored.\n",
> >> +                       NR_CPUS, total_cpus, mpidr);
> >> +               return -EINVAL;
> >> +       }
> >> +
> >> +       /* No need to check duplicate MPIDRs for the first CPU */
> >> +       if (enabled_cpus) {
> >> +               /*
> >> +                * Duplicate MPIDRs are a recipe for disaster. Scan
> >> +                * all initialized entries and check for
> >> +                * duplicates. If any is found just ignore the CPU.
> >> +                */
> >> +               for_each_possible_cpu(cpu) {
> >> +                       if (cpu_logical_map(cpu) == mpidr) {
> >> +                               pr_err("Firmware bug, duplicate CPU MPIDR: 0x%llx in MADT\n",
> >> +                                      mpidr);
> >> +                               return -EINVAL;
> >> +                       }
> >> +               }
> >> +
> >> +               /* allocate a logical cpu id for the new comer */
> >> +               cpu = cpumask_next_zero(-1, cpu_possible_mask);
> >> +       } else {
> >> +               /*
> >> +                * First GICC entry must be BSP as ACPI spec said
> >> +                * in section 5.2.12.15
> >> +                */
> >> +               if  (cpu_logical_map(0) != mpidr) {
> >> +                       pr_err("First GICC entry with MPIDR 0x%llx is not BSP\n",
> >> +                              mpidr);
> >> +                       return -EINVAL;
> >> +               }
> >> +
> >> +               /*
> >> +                * boot_cpu_init() already hold bit 0 in cpu_present_mask
> >
> > You mean cpu_possible_mask ? That's what you allocate from above.
> 
> Another hot-plug piece leaved, will update it.
> 
> >
> >> +                * for BSP, no need to allocate again.
> >> +                */
> >> +               cpu = 0;
> >> +       }
> >> +
> >> +       /* CPU 0 was already initialized */
> >> +       if (cpu) {
> >> +               cpu_ops[cpu] = cpu_get_ops(acpi_psci_present() ? "psci" : NULL);
> >> +               if (!cpu_ops[cpu])
> >> +                       return -EINVAL;
> >> +
> >> +               if (cpu_ops[cpu]->cpu_init(NULL, cpu))
> >> +                       return -EOPNOTSUPP;
> >> +
> >> +               /* map the logical cpu id to cpu MPIDR */
> >> +               cpu_logical_map(cpu) = mpidr;
> >> +
> >> +               set_cpu_possible(cpu, true);
> >> +       } else {
> >> +               /* get cpu0's ops, no need to return if ops is null */
> >> +               cpu_ops[0] = cpu_get_ops(acpi_psci_present() ? "psci" : NULL);
> >> +       }
> >
> > I do not see much point in calling cpu_get_ops with NULL, and adding
> > the check in it to return NULL when the parameter is NULL.
> >
> > What would you expect from cpu_get_ops when called with NULL other than
> > a NULL pointer ?
> 
> I'm lost here since it is best way for the implementation I think, any
> suggestions?

My suggestion is: no PSCI, no secondaries booting, that's what your code
wants to achieve, right ? What's the point in calling cpu_get_ops() when
PSCI is not present then ? What do you expect from calling cpu_get_ops(NULL)
other than a NULL pointer in return ?

Put it differently, if !acpi_psci_present() parsing code should bail out,
there are no CPU ops to initialize for secondaries, that's what I think
your aim is, correct ?

On a side note, if ACPI PSCI is not present you still keep booting on
the boot processor.

What piece of code initialize cpu_ops[0] in that case ? I could not
find any, basically you would run the kernel with cpu_ops[0] == NULL.

> 
> >
> > You could move:
> >
> > cpu_ops[cpu] = cpu_get_ops(acpi_psci_present() ? "psci" : NULL);
> >
> > out of the if and remove the else, do not know if it makes code clearer,
> > shorter for certain.
> >
> >> +
> >> +       enabled_cpus++;
> >> +       return cpu;
> >> +}
> >> +
> >> +static int __init
> >> +acpi_parse_gic_cpu_interface(struct acpi_subtable_header *header,
> >> +                               const unsigned long end)
> >> +{
> >> +       struct acpi_madt_generic_interrupt *processor;
> >> +
> >> +       processor = (struct acpi_madt_generic_interrupt *)header;
> >> +
> >> +       if (BAD_MADT_ENTRY(processor, end))
> >> +               return -EINVAL;
> >> +
> >> +       acpi_table_print_madt_entry(header);
> >> +
> >> +       acpi_map_gic_cpu_interface(processor->arm_mpidr & MPIDR_HWID_BITMASK,
> >> +               processor->flags & ACPI_MADT_ENABLED);
> >> +
> >> +       return 0;
> >> +}
> >> +
> >> +/* Parse GIC cpu interface entries in MADT for SMP init */
> >> +void __init acpi_smp_init_cpus(void)
> >> +{
> >> +       int count;
> >> +
> >> +       /*
> >> +        * do a partial walk of MADT to determine how many CPUs
> >> +        * we have including disabled CPUs, and get information
> >> +        * we need for SMP init
> >> +        */
> >> +       count = acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_INTERRUPT,
> >> +                       acpi_parse_gic_cpu_interface, 0);
> >> +
> >> +       if (!count) {
> >> +               pr_err("No GIC CPU interface entries present\n");
> >> +               return;
> >> +       } else if (count < 0) {
> >> +               pr_err("Error parsing GIC CPU interface entry\n");
> >> +               return;
> >> +       }
> >> +
> >> +       /* Make boot-up look pretty */
> >> +       pr_info("%d CPUs enabled, %d CPUs total\n", enabled_cpus, total_cpus);
> >> +}
> >> +
> >>   static int __init acpi_parse_fadt(struct acpi_table_header *table)
> >>   {
> >>          struct acpi_table_fadt *fadt = (struct acpi_table_fadt *)table;
> >> @@ -62,8 +196,20 @@ static int __init acpi_parse_fadt(struct acpi_table_header *table)
> >>           * to get arm boot flags, or we will disable ACPI.
> >>           */
> >>          if (table->revision > 5 ||
> >> -           (table->revision == 5 && fadt->minor_revision >= 1))
> >> -               return 0;
> >> +           (table->revision == 5 && fadt->minor_revision >= 1)) {
> >> +               /*
> >> +                * ACPI 5.1 only has two explicit methods to boot up SMP,
> >> +                * PSCI and Parking protocol, but the Parking protocol is
> >> +                * only specified for ARMv7 now, so make PSCI as the only
> >> +                * way for the SMP boot protocol before some updates for
> >> +                * the ACPI spec or the Parking protocol spec.
> >> +                */
> >> +               if (acpi_psci_present())
> >> +                       return 0;
> >> +
> >> +               pr_warn("No PSCI support, will not bring up secondary CPUs\n");
> >> +               return -EOPNOTSUPP;
> >> +       }
> >>
> >>          pr_warn("Unsupported FADT revision %d.%d, should be 5.1+, will disable ACPI\n",
> >>                  table->revision, fadt->minor_revision);
> >> diff --git a/arch/arm64/kernel/cpu_ops.c b/arch/arm64/kernel/cpu_ops.c
> >> index cce9524..1ea7b9f 100644
> >> --- a/arch/arm64/kernel/cpu_ops.c
> >> +++ b/arch/arm64/kernel/cpu_ops.c
> >> @@ -27,7 +27,7 @@ extern const struct cpu_operations cpu_psci_ops;
> >>
> >>   const struct cpu_operations *cpu_ops[NR_CPUS];
> >>
> >> -static const struct cpu_operations *supported_cpu_ops[] __initconst = {
> >> +static const struct cpu_operations *supported_cpu_ops[] = {
> >
> > This __initconst removal should be explained either with code needing
> > it or through a comment. You can't make changes with future patches
> > in mind, since they may never get merged and you leave code in this
> > patch incomplete.
> >
> > As far as I know if physical CPU hotplug can't/won't be done on ARM64 your
> > patch would make changes that are not needed, and miss some changes
> > that are (eg removing enabled_cpus or make it __initdata).
> 
> I agree with you :)
> 
> >
> > You can't write a patch with assumptions on subsequent patches.
> >
> >>   #ifdef CONFIG_SMP
> >>          &smp_spin_table_ops,
> >>   #endif
> >> @@ -35,10 +35,13 @@ static const struct cpu_operations *supported_cpu_ops[] __initconst = {
> >>          NULL,
> >>   };
> >>
> >> -static const struct cpu_operations * __init cpu_get_ops(const char *name)
> >> +const struct cpu_operations *cpu_get_ops(const char *name)
> >
> > Ditto.
> >
> >>   {
> >>          const struct cpu_operations **ops = supported_cpu_ops;
> >>
> >> +       if (!name)
> >> +               return NULL;
> >> +
> >
> > See above.
> >
> >>          while (*ops) {
> >>                  if (!strcmp(name, (*ops)->name))
> >>                          return *ops;
> >> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
> >> index ef5b1e1..54e39e3 100644
> >> --- a/arch/arm64/kernel/setup.c
> >> +++ b/arch/arm64/kernel/setup.c
> >> @@ -414,13 +414,16 @@ void __init setup_arch(char **cmdline_p)
> >>          if (acpi_disabled) {
> >>                  unflatten_device_tree();
> >>                  psci_dt_init();
> >> +               cpu_read_bootcpu_ops();
> >> +#ifdef CONFIG_SMP
> >> +               of_smp_init_cpus();
> >> +#endif
> >>          } else {
> >>                  psci_acpi_init();
> >> +               acpi_smp_init_cpus();
> >
> > With DT you call cpu_read_bootcpu_ops() and then of_smp_init_cpus()
> > with acpi you have one function that does both, it is not really
> > neat.
> 
> The mechanism for ACPI table entry scanning is that for every matched
> structure (such as GICC) found, the parse function will be called, so
> if we separate them it will duplicate the scanning of ACPI tables.

Call it acpi_init_cpus() then.

Lorenzo
