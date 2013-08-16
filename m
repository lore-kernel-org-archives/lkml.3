Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab3HPJhX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 05:37:23 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37627 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754610Ab3HPJhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 05:37:18 -0400
Date: Fri, 16 Aug 2013 10:37:14 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Rohit Vaswani <rvaswani@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Nicolas Pitre <nico@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Subject: Re: [RESEND PATCH 2/4] ARM: msm: Re-organize platsmp to make it
 extensible
Message-ID: <20130816093714.GG32421@e106331-lin.cambridge.arm.com>
References: <1375409725-22004-1-git-send-email-rvaswani@codeaurora.org>
 <1375409725-22004-3-git-send-email-rvaswani@codeaurora.org>
 <20130812155016.GC27165@e106331-lin.cambridge.arm.com>
 <520BEEC3.6060805@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520BEEC3.6060805@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 09:55:31PM +0100, Rohit Vaswani wrote:
> On 8/12/2013 8:50 AM, Mark Rutland wrote:
> > Hi,
> >
> > Apologies for the long delay for review on this.
> >
> > I really like the direction this is going, but I have some qualms with
> > the implementation.
> 
> Thanks for your review, but a few direct recommendations would help in
> making the implementation right.

Sorry, I'll try to be clearer below :)

> >
> > On Fri, Aug 02, 2013 at 03:15:23AM +0100, Rohit Vaswani wrote:
> >> This makes it easy to add SMP support for new targets
> >> by adding cpus property and the release sequence.
> >> We add the enable-method property for the cpus property to
> >> specify which release sequence to use.
> >> While at it, add the 8660 cpus bindings to make SMP work.
> >>
> >> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
> >> ---
> >>   Documentation/devicetree/bindings/arm/cpus.txt     |  6 ++
> >>   Documentation/devicetree/bindings/arm/msm/scss.txt | 15 ++++
> >>   arch/arm/boot/dts/msm8660-surf.dts                 | 23 +++++-
> >>   arch/arm/mach-msm/platsmp.c                        | 94 +++++++++++++++++-----
> >>   4 files changed, 115 insertions(+), 23 deletions(-)
> >>   create mode 100644 Documentation/devicetree/bindings/arm/msm/scss.txt
> >>
> >> diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
> >> index f32494d..327aad2 100644
> >> --- a/Documentation/devicetree/bindings/arm/cpus.txt
> >> +++ b/Documentation/devicetree/bindings/arm/cpus.txt
> >> @@ -44,6 +44,12 @@ For the ARM architecture every CPU node must contain the following properties:
> >>              "marvell,mohawk"
> >>              "marvell,xsc3"
> >>              "marvell,xscale"
> >> +            "qcom,scorpion"
> >> +- enable-method: Specifies the method used to enable or take the secondary cores
> >> +             out of reset. This allows different reset sequence for
> >> +             different types of cpus.
> >> +             This should be one of:
> >> +             "qcom,scss"
> > While I'd certainly like to see a move to using enable-method for
> > 32-bit, I think this needs a bit more thought:
> >
> > What does "qcom,scss" mean, precisely? It seems to be that we poke some
> > registers in a "qcom,scss" device. I think we need to document
> > enable-methods *very* carefully (and we need to do that for 64-bit as
> > well with psci), as it's very likely there'll be subtle
> > incompatibilities between platforms, especially if firmware is involved.
> > We should try to leaves as little room for error as possible.
> Yes qcom,scss implies poking registers in the qcom,scss device. How
> could I make that more clear in the documentation ?

A description of that should be in the binding document to that effect.

Just having "qcom,scss" may not be enough, as we don't necessarily know
which bit in a register needs to be poked for a specific CPU. While
today you may have a single cluster and it's the bit at offset
MPIDR.Aff0 in the register, that might not be true in future (either
because you have multiple clusters or some arbitrary mappnig from CPU to
bit), and we may need to describe that.

Presumably we need to write the start address for the secondary CPU
somewhere -- is that a register in the SCSS, does the CPU start at some
fixed address that we need to install a trampoline at, or is there some
other mechanism for controlling this?

We need to try and make as few assumptions as possible or we can't have
a stable binding here. We already have variations on "spin-table", for
example on arm64 where firmware may have a wfe, so the OS *must* issue a
sev to function with all implementations. At the opposite end, PSCI is
pretty much identical across arm and arm64 (at present).

We'll probably want to factor the enable methods out into a separate
file or directory, as I can see this getting quite large.

> 
> >
> > I don't want to see this devolve into meaning "whatever the Linux driver
> > for this happens to do at the current point in time", as that just leads
> > to breakage as we have no clear distinction between actual requirements
> > and implementation details.
> >
> > Given we already have platforms without an enable-method, we can't make
> > it a required property either -- those platforms are already booting by
> > figuring out an enable method from the platform's compatible string.
> So, you recommend we continue to using the platform compatible string as
> well ?

I'm not making a recommendation to do that, but we need to consider the
trade-off. Adding a new enable-method for each platform and then finding
it can't be shared because we didn't document the general case is
something I'd like to avoid.

> We currently don't have a perfect method to use enable-method in generic
> code. More on this below...

We certainly need to factor out enable-method detection into generic
code. Ideally, if we don't have an smp_ops we'd fall back to
enable-method detection.

> >
> > With PSCI, enable-method also implies a method for disabling a
> > particular CPU, so it would be nice for the description to cover this.
> >
> >>
> >>   Example:
> >>
> >> diff --git a/Documentation/devicetree/bindings/arm/msm/scss.txt b/Documentation/devicetree/bindings/arm/msm/scss.txt
> >> new file mode 100644
> >> index 0000000..21c3e26
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/arm/msm/scss.txt
> >> @@ -0,0 +1,15 @@
> >> +* SCSS - Scorpion Sub-system
> >> +
> >> +Properties
> >> +
> >> +- compatible : Should contain "qcom,scss".
> >> +
> >> +- reg: Specifies the base address for the SCSS registers used for
> >> +       booting up secondary cores.
> >> +
> >> +Example:
> >> +
> >> +    scss@902000 {
> >> +            compatible = "qcom,scss";
> >> +            reg = <0x00902000 0x2000>;
> >> +    };
> >> diff --git a/arch/arm/boot/dts/msm8660-surf.dts b/arch/arm/boot/dts/msm8660-surf.dts
> >> index cdc010e..203e51a 100644
> >> --- a/arch/arm/boot/dts/msm8660-surf.dts
> >> +++ b/arch/arm/boot/dts/msm8660-surf.dts
> >> @@ -7,6 +7,22 @@
> >>      compatible = "qcom,msm8660-surf", "qcom,msm8660";
> >>      interrupt-parent = <&intc>;
> >>
> >> +    cpus {
> >> +            #address-cells = <1>;
> >> +            #size-cells = <0>;
> >> +            compatible = "qcom,scorpion";
> >> +            device_type = "cpu";
> >> +            enable-method = "qcom,scss";
> >> +
> >> +            cpu@0 {
> >> +                    reg = <0>;
> >> +            };
> >> +
> >> +            cpu@1 {
> >> +                    reg = <1>;
> >> +            };
> >> +    };
> >> +
> > I *really* like moving the common properties out into the /cpus node --
> > ePAPR suggests it, it's less error prone, and it takes up less space.
> > However, I'm not sure our generic/arch code handles it properly, and I
> > think we need to audit that before we can start writing dts that depend
> > on it. I'd be happy to be wrong here if anyone can correct me. :)

I was trying to point out that here we have the properties under /cpus,
but the PSCI code in kvmtool currently drops these per-cpu. Either is
technically valid, and the recommendation of ePAPR is to look in a given
/cpus/cpu@N node first, then fall back to the /cpus node.

> >
> > We probably need to factor out the way we read properties for cpu nodes,
> > falling back to ones present in /cpus if not present. There's already a
> > lot of pain getting the node for a logical (rather than physical) cpu
> > id.
> >
> > Sudeep recently factored out finding the cpu node for a logical cpu id
> > [1,2] in generic code with a per-arch callback, it shouldn't be too hard
> > to have shims around that to read (optionally) common properties.
> >

This was my attempt at a suggestion. We want some generic code for
grabbing cpu properties that falls back to the /cpus node. Something
like a family of of_get_cpu_{property,u32,string} functions (we likely
don't need much more than string at the moment).

Sudeep's patches for getting the cpu node for a logical cpu id could be
the basis for this.

> > [...]
> >
> >> -static void prepare_cold_cpu(unsigned int cpu)
> >> +static int scorpion_release_secondary(void)
> >>   {
> >> -    int ret;
> >> -    ret = scm_set_boot_addr(virt_to_phys(secondary_startup),
> >> -                            SCM_FLAG_COLDBOOT_CPU1);
> >> -    if (ret == 0) {
> >> -            void __iomem *sc1_base_ptr;
> >> -            sc1_base_ptr = ioremap_nocache(0x00902000, SZ_4K*2);
> >> -            if (sc1_base_ptr) {
> >> -                    writel(0, sc1_base_ptr + VDD_SC1_ARRAY_CLAMP_GFS_CTL);
> >> -                    writel(0, sc1_base_ptr + SCSS_CPU1CORE_RESET);
> >> -                    writel(3, sc1_base_ptr + SCSS_DBG_STATUS_CORE_PWRDUP);
> >> -                    iounmap(sc1_base_ptr);
> >> -            }
> >> -    } else
> >> -            printk(KERN_DEBUG "Failed to set secondary core boot "
> >> -                              "address\n");
> >> +    void __iomem *sc1_base_ptr;
> >> +    struct device_node *dn = NULL;
> >> +
> >> +    dn = of_find_compatible_node(dn, NULL, "qcom,scss");
> >> +    if (!dn) {
> >> +            pr_err("%s: Missing scss node in device tree\n", __func__);
> >> +            return -ENXIO;
> >> +    }
> >> +
> >> +    sc1_base_ptr = of_iomap(dn, 0);
> >> +    if (sc1_base_ptr) {
> >> +            writel_relaxed(0, sc1_base_ptr + VDD_SC1_ARRAY_CLAMP_GFS_CTL);
> >> +            writel_relaxed(0, sc1_base_ptr + SCSS_CPU1CORE_RESET);
> >> +            writel_relaxed(3, sc1_base_ptr + SCSS_DBG_STATUS_CORE_PWRDUP);
> >> +            mb();
> >> +            iounmap(sc1_base_ptr);
> > Does this boot *all* secondary CPUs directly into the kernel? Is that
> > safe (e.g. if the kernel supports fewer CPUs than are physically
> > present)?
> Im not sure I understand the concern with safety here. The CPU for which
> the release_secondary will be called will be taken out of reset with
> this sequence.

I was confused that this function was no longer taking a cpu property.
To me that seems to imply that what this was doing was not specific to a
particular CPU,

I must have misunderstood something here -- how does this take a
particular CPU out of reset? It looks like it's poking some shared
registers in the "qcom,scss" device that aren't specific to a single
CPU.

Is there only one secondary? How does this generalise to more?

> 
> >
> > Is this a one-time thing, or are we able to dynamically hotplug CPUs? If
> > the latter, the map/unmap looks odd to me.
> 
> This is a one-time thing done for each CPU that's specified in the
> device tree (or based on the command line over-ride).

Ok. Is it possible for hot unplug to be implemented based on this later?

> >> +    } else {
> >> +            return -ENOMEM;
> >> +    }
> >> +
> >> +    return 0;
> >>   }
> >>
> >> -static int msm_boot_secondary(unsigned int cpu, struct task_struct *idle)
> >> +static DEFINE_PER_CPU(int, cold_boot_done);
> >> +
> >> +static void boot_cold_cpu(unsigned int cpu)
> >>   {
> >> -    static int cold_boot_done;
> >> +    const char *enable_method;
> >> +    struct device_node *dn = NULL;
> >>
> >> -    /* Only need to bring cpu out of reset this way once */
> >> -    if (cold_boot_done == false) {
> >> -            prepare_cold_cpu(cpu);
> >> -            cold_boot_done = true;
> >> +    dn = of_find_node_by_name(dn, "cpus");
> >> +    if (!dn) {
> >> +            pr_err("%s: Missing node cpus in device tree\n", __func__);
> >> +            return;
> >>      }
> >>
> >> +    enable_method = of_get_property(dn, "enable-method", NULL);
> > Please factor this out from the platform code.
> >
> > If we're going to use enable-method, it should be decoupled from
> > platform code -- common code should parse it to find the appropriate
> > handler. Also, we *must* support having an enable-method per-cpu as KVM
> > does for PSCI (though I definitely would like support for shared
> > properties as mentioned above).
> Currently with most platforms, smp.c calls into the boot_secondary
> function which decides which cpu it is
> and then calls the appropriate function. This is because smp ops allow
> only 1 callback function to be registered...
> Hence, using the enable-method in platform specific code works.
> 
> If we create a generic property should it mandate having generic code
> handle that ?

I'd certainly prefer to move enable-method handling into generic code.
Is there no way we could do this if we had a NULL smp_ops entry?

> I currently don't have a good way of incorporating enable-method in
> generic code as it would mean to establish a mechanism to
> associate the enable-method string with cpu specific boot_secondary
> functions.

If we have cpu-specific boot_secondary functions, then surely the
enable-method isn't enough to tell us how to boot the secondary?

Does the cpu's compatible string not give us enough, or is this still
platform-specific? If it's the latter, I'm not sure having the
enable-method buys us anything, as we still need additional platform
information to be able to use it.

> You have an approach in mind that I can try ?

Not at present, but I'm sure we can think of something.

> 
> >> +    if (!enable_method) {
> >> +                    pr_err("%s: cpus node is missing enable-method property\n",
> >> +                                    __func__);
> >> +    } else if (!strcmp(enable_method, "qcom,scss")) {
> >> +            if (per_cpu(cold_boot_done, cpu) == false) {
> >> +                    scorpion_release_secondary();
> >> +                    per_cpu(cold_boot_done, cpu) = true;
> >> +            }
> >> +    } else {
> >> +            pr_err("%s: Invalid enable-method property: %s\n",
> >> +                            __func__, enable_method);
> >> +    }
> >> +}
> >> +
> >> +static int msm_boot_secondary(unsigned int cpu, struct task_struct *idle)
> >> +{
> >> +    boot_cold_cpu(cpu);
> >> +
> >>      /*
> >>       * set synchronisation state between this boot processor
> >>       * and the secondary one
> >> @@ -118,8 +148,28 @@ static void __init msm_smp_init_cpus(void)
> >>              set_cpu_possible(i, true);
> >>   }
> >>
> >> +static const int cold_boot_flags[] __initconst = {
> >> +    0,
> >> +    SCM_FLAG_COLDBOOT_CPU1,
> >> +};
> > So we only ever support booting two CPUs?
> The next patch which adds support for a quadcore chip, adds more flags.
> >
> > Is the mapping of MPIDR to register bits arbitrary? Or do we know what
> > they would be for four CPUs, four clusters, and beyond?
> Four cpus.

Ok. is SCSS based booting always going to be hard-limited to four CPUs,
or do we possibly need to encode some (optional) information in each CPU
node in the dt (i.e. the bits of the register that needs to be poked).

> 
> >
> >> +
> >>   static void __init msm_smp_prepare_cpus(unsigned int max_cpus)
> >>   {
> >> +    int cpu, map;
> >> +    unsigned int flags = 0;
> >> +
> >> +    for_each_present_cpu(cpu) {
> >> +            map = cpu_logical_map(cpu);
> >> +            if (map > ARRAY_SIZE(cold_boot_flags)) {
> >> +                    set_cpu_present(cpu, false);
> >> +                    __WARN();
> >> +                    continue;
> >> +            }
> >> +            flags |= cold_boot_flags[map];
> > It's a shame that this leaves a window where some CPUs seem bootable,
> > but aren't (though I can't offer a better way of handling this given we
> > have dts without enable-method properties).
> Any CPU that seems bootable and is defined in DT, should be bootable.
> The cold_boot_flags are just a mechanism to set appropriate values for
> the scm call and
> they aren't used as a method to disallow CPUs from being bootable and
> hence the __WARN() if this is done incorrectly.

Ok. That sounds reasonable.

Thanks,
Mark.
