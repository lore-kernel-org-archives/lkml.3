Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412Ab3FFSJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 14:09:05 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:46647 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751102Ab3FFSJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 14:09:03 -0400
Date: Thu, 6 Jun 2013 19:08:24 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>, gnurou@gmail.com,
        devicetree-discuss@lists.ozlabs.org,
        Chris Johnson <CJohnson@nvidia.com>, linux-kernel@vger.kernel.org,
        Karan Jhavar <kjhavar@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        Joseph Lo <josephl@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: tegra: add basic SecureOS support
Message-ID: <20130606180824.GC3320@localhost.localdomain>
References: <1370503687-17767-1-git-send-email-acourbot@nvidia.com>
 <51B0BC80.9040007@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B0BC80.9040007@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 10:44:48AM -0600, Stephen Warren wrote:
> On 06/06/2013 01:28 AM, Alexandre Courbot wrote:
> > Boot loaders on some Tegra devices can be unlocked but do not let the
> > system operate without SecureOS. SecureOS prevents access to some
> > registers and requires the operating system to perform certain
> > operations through Secure Monitor Calls instead of directly accessing
> > the hardware.
> > 
> > This patch introduces basic SecureOS support for Tegra. SecureOS support
> > can be enabled by adding a "nvidia,secure-os" property to the "chosen"
> > node of the device tree.
> 
> I suspect "SecureOS" here is the name of a specific implementation of a
> secure monitor, right? It's certainly a very unfortunate name, since it
> sounds like a generic concept rather than a specific implementation:-(
> 
> There certainly could be (and I believe are in practice?) multiple
> implementation of a secure monitor for Tegra. Presumably, each of those
> implementations has (or could have) a different definition for what SVC
> calls it supports, their parameters, etc.
> 
> I think we need to separate the concept of support for *a* secure
> monitor, from support for a *particular* secure monitor.

There is no fixed set of functionality implemented by these interfaces,
so it might be better to think in terms of a generic "firmware" concept.


Come to think of it...

One option could be to have some standard baseline firmware calling
conventions, so that we could have a few specific backends -- perhaps
this could be built on the "method" notion used by PSCI

(see Documentation/devicetree/bindings/arm/psci.tst; this is probably
the most developed firmware interface binding we have today)

There, method = "smc" means:

	populate registers in a certain way
	SMC #0
	return results from register to caller in a certain way

and method = "hvc" means:

	populate registers in a certain way
	HVC #0
	return results from register to caller in a certain way


The backend method arch/arm/kernel/psci.c:__invoke_psci_fn_smc()
is probably close to what's needed for the tegra secureos case,
so in theory it could be common, along with some of the DT binding
conventions.

The backends, and the convention for binding a firmware interface
to the appropriate backend, could then theoretically be handled
by a common framework.

Firmwares with strange calling conventions which don't fit the
standard backend could still add another one, within the framework.

> 
> > diff --git a/Documentation/devicetree/bindings/arm/tegra.txt b/Documentation/devicetree/bindings/arm/tegra.txt
> 
> > +node:
> > +
> > +  nvidia,secure-os: enable SecureOS.
> 
> ... as such, I think some work is needed here to allow specification of
> which secure monitor is present and/or which secure monitor ABI it
> implements. The suggestion to use a specific DT node, and hence use
> compatible values for this, seems reasonable. Alternatively, perhaps:
> 
> nvidia,secure-monitor = "name_of_vendor_or_SMC_ABI";

So, something like

	foo-firmware {
		compatible = "vendor1,foo-firmware-1.0", "vendor1,foo-firmware";
		method = "smc";

		// ...
	};

	bar-firmware {
		compatible = "vendor2,bar-firmware-1.6", "vendor2,bar-firmware";
		method = "smc";

		// ...
	};

Could make sense.

...where we would require all new firmware interface bindings to
include the "-firmware" in their node names and compatible strings
(with a version suffix encouraged for the compatible strings, where
relevant).

This could be a good opportunity to make things a bit more consistent,
otherwise we will just reinvent this over and over.


(Unfortunately the node for PSCI offers no clue that it describes a
firmware interface, unless you go and read the binding documentation.
It may be too late to fix that, but we can at least avoid repeating
the mistake.)


> might be reasonable, although using a node would allow ABI-specific
> additional properties to be defined should they be needed, so I guess I
> would lean towards that.
> 
> Similar comments may apply to the CONFIG_ option and description,
> filenames, etc.
> 
> > diff --git a/arch/arm/mach-tegra/secureos.c b/arch/arm/mach-tegra/secureos.c
> 
> > +void __init tegra_init_secureos(void)
> > +{
> > +	struct device_node *node = of_find_node_by_path("/chosen");
> > +
> > +	if (node && of_property_read_bool(node, "nvidia,secure-os"))
> > +		register_firmware_ops(&tegra_firmware_ops);
> > +}
> 
> I'm tempted to think that function should /always/ exist an be called
> (so no dummy inline in secureos.h).
> 
> In particular, what happens when a kernel without CONFIG_SECUREOS
> enabled is booted under a secure monitor. Presumably we want the init
> code to explicitly check for this condition, and either BUG(), or do
> something to disable any features (like SMP) that require SVCs?
> 
> So, the algorithm here might be more like:
> 
> find node
> if node exists
>     if (!IS_ENABLED(SECURE_OS))
>         BUG/WARN/...
>     else
>         register_firmware_ops()

Agreed, something like that would be needed, but it depends on the
firmware interface being described.

Cheers
---Dave
