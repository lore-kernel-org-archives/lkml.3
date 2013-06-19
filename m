Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934356Ab3FSLM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 07:12:26 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51960 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933666Ab3FSLMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 07:12:24 -0400
Date: Wed, 19 Jun 2013 12:11:32 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Chris Johnson <CJohnson@nvidia.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Karan Jhavar <kjhavar@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Joseph Lo <josephl@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/3] ARM: tegra: basic support for Trusted Foundations
Message-ID: <20130619111126.GA3582@localhost.localdomain>
References: <1371114745-24710-1-git-send-email-acourbot@nvidia.com>
 <1371114745-24710-2-git-send-email-acourbot@nvidia.com>
 <51BA1B41.6030002@wwwdotorg.org>
 <CAAVeFuLc57pV=To5yaE5x9mrVy1yknH2e90QockCiNbEXRm0WQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAVeFuLc57pV=To5yaE5x9mrVy1yknH2e90QockCiNbEXRm0WQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 05:43:03PM +0900, Alexandre Courbot wrote:
> On Thu, Jun 13, 2013 at 11:35 PM, Dave Martin <Dave.Martin@arm.com> wrote:
> >> diff --git a/Documentation/devicetree/bindings/arm/tegra.txt b/Documentation/devicetree/bindings/arm/tegra.txt
> >> index ed9c853..d59bc19 100644
> >> --- a/Documentation/devicetree/bindings/arm/tegra.txt
> >> +++ b/Documentation/devicetree/bindings/arm/tegra.txt
> >> @@ -32,3 +32,14 @@ board-specific compatible values:
> >>    nvidia,whistler
> >>    toradex,colibri_t20-512
> >>    toradex,iris
> >> +
> >> +Optional nodes
> >> +-------------------------------------------
> >> +
> >> +Trusted Foundations:
> >> +Boards using the Trusted Foundations secure monitor should signal its
> >> +presence by declaring a node compatible with "tl,trusted-foundations":
> >> +
> >> +     firmware {
> >
> > You need to make a clear statement about whether the node name is
> >
> > I think it shouldn't required to be exactly equal to "firmware", because
> > that would lead to problems if there were multiple independent firmware
> > APIs present (which is certainly possible, whether or not it is true
> > on Tegra).
> 
> Yes, the name of the node is not fixed (doing so would make its lookup
> faster, but the gain is not obvious). Will make it explicit in the
> doc.
> 
> >> +             compatible = "tl,trusted-foundations";
> >> +     };
> >
> > For now, it might make more sense to make this binding tegra-specific,
> > and to interpret the node is only implying the presence of the low-
> > level SoC functions you are using on Tegra, not TF as a whole.
> 
> Do you mean the vendor should be changed from "tl" to "nvidia" here?

Since this is a Tegra-specific integration, I think that would be wise,
unless you can confirm by looking at the API specs that the functionality
you are trying to describe and use it truly intended to be generic across
all deployments of TF (either always present, or at least as a well-
specified optional feature).

> > Otherwise, it feels too generic.  There is no description of exactly
> > what functionality will be available if this node it present: if
> > this is going to be a generic binding for TF, then it needs to work
> > for all deployments of TF, not just your specific case.  For example,
> > how to you find out what functionality is present?  Will there be
> > a standard probing ABI for all versions and deployments of TF, or
> > would extra information need to be described in the DT?
> >
> > Partly, this depends on whether the TF_SET_CPU_BOOT_ADDR_SMC call will
> > be present, working, and with compatible ABI and semantics, on every SoC
> > where an implementation of TF is present.  Someone from Trusted Logic, or
> > someone with visibility of the relevant ABI/API specs would need to
> > judge on that -- do you have that info?
> 
> I'm currently looking into that. This patch makes the assumption that
> all TF implementations have the same features and the same interface -
> if this is the case, do you agree this binding is ok as it is?

It's a judgement call, but if the SMC you use is a mandatory part of
TF after a certain version, and if it's guaranteed to have a fixed ABI
(including function ID) and behaviour, then that binding works.

If the function is an optional or SoC-specific feature, then it's not
sufficient to say that TF firmware is present -- we need to describe
something about the SoC-specific and optional features present, unless
there's a well-defined generic way to probe for them.

> If indeed TF's functionality and ABI is the same no matter whether we
> are on Tegra on not, then its support should even be moved outside of
> mach-tegra.

Agreed, that's the ideal outcome.  I'm just not convinced we're ready
for that just now (but I'm happy to be corrected).

> >> --- /dev/null
> >> +++ b/arch/arm/mach-tegra/firmware.c
> >> @@ -0,0 +1,40 @@
> >> +/*
> >> + * SecureOS support for Tegra CPUs
> >
> > Should the name "SecureOS" change in these comment headers? (affects
> > multiple files)
> 
> Yes, I missed these ones, thanks. Another missed opportunity to use git grep...
> 
> >> +     node = of_find_compatible_node(NULL, NULL, "tl,trusted-foundations");
> >> +     if (node && !IS_ENABLED(CONFIG_TEGRA_TRUSTED_FOUNDATIONS))
> >> +             pr_warn("Trusted Foundations detected but support missing!\n");
> >
> > Should this be more than just a warning?
> >
> > It looks to me like tegra_cpu_reset_handler_set() might either silently
> > fail or trigger an external abort in this situation, depending on the
> > hardware and on how TF sets things up.
> 
> What will happen (from 3.10) is that tegra_cpu_reset_handler_set()
> will output a "CPUX: failed to come online" for each secondary CPU and
> boot will continue (albeit on one CPU). The system's features are
> degraded, but it is not fatal, so I think it is reasonable to continue
> here.

I don't think we should rely on ignoring in imprecise external abort,
because such aborts indicate serious or potentially fatal system errors
or bugs.

If you're getting a precise abort (so that we know the faulted address)
or no abort at all, that's less harmful, though it's hard to guarantee
across all SoCs, because the ARM Architecture doesn't guarantee synchronous
aborts for slave errors on writes.

What was heppening differently on 3.9 compared with 3.10?

> > There seems to be no way to signal an error when attempting to set a
> > CPU's reset address.
> 
> Indeed. But even if that fails the system can still survive, at least on Tegra.
> 
> >> +#if IS_ENABLED(CONFIG_TEGRA_TRUSTED_FOUNDATIONS)
> >> +     else if (node)
> >> +             register_firmware_ops(&tegra_trusted_foundations_ops);
> >> +#endif
> >> +}
> >
> >
> > IS_ENABLED() allows #ifdefs to be avoided -- maybe this would be clearer
> > as:
> >
> >         node = of_find_compatible_node(NULL, NULL, "tl,trusted-foundations");
> >         if (!node)
> >                 return;
> >
> >         if (WARN_ON(!IS_ENABLED(CONFIG_TEGRA_TRUSTED_FOUNDATIONS))) {
> >                 pr_warn("Trusted Foundations detected but support missing!\n");
> >                 return;
> >         }
> >
> >         register_firmware_ops(&tegra_trusted_foundations_ops);
> 
> But then you will get a link error when TF support is not compiled in
> because tegra_trusted_foundations_ops will not be defined. That's why
> I used a #ifdef here - I agree it is terribly inelegant though.

Hmmm, fair point.  Dead code elimination in the compiler may solve that,
but I've never been too keen on relying on that.

Cheers
---Dave
