Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab3FGRsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 13:48:13 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:59380 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755399Ab3FGRsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 13:48:11 -0400
Date: Fri, 7 Jun 2013 18:47:36 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: gnurou@gmail.com, devicetree-discuss@lists.ozlabs.org,
        Chris Johnson <CJohnson@nvidia.com>, linux-kernel@vger.kernel.org,
        Karan Jhavar <kjhavar@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Joseph Lo <josephl@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: tegra: add basic SecureOS support
Message-ID: <20130607174736.GB29344@localhost.localdomain>
References: <1370503687-17767-1-git-send-email-acourbot@nvidia.com>
 <51B0BC80.9040007@wwwdotorg.org>
 <20130606180824.GC3320@localhost.localdomain>
 <51B0D4FA.5070500@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B0D4FA.5070500@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 12:29:14PM -0600, Stephen Warren wrote:
> On 06/06/2013 12:08 PM, Dave Martin wrote:
> > On Thu, Jun 06, 2013 at 10:44:48AM -0600, Stephen Warren wrote:
> >> On 06/06/2013 01:28 AM, Alexandre Courbot wrote:
> >>> Boot loaders on some Tegra devices can be unlocked but do not let the
> >>> system operate without SecureOS. SecureOS prevents access to some
> >>> registers and requires the operating system to perform certain
> >>> operations through Secure Monitor Calls instead of directly accessing
> >>> the hardware.
> >>>
> >>> This patch introduces basic SecureOS support for Tegra. SecureOS support
> >>> can be enabled by adding a "nvidia,secure-os" property to the "chosen"
> >>> node of the device tree.
> ...
> > So, something like
> > 
> > 	foo-firmware {
> > 		compatible = "vendor1,foo-firmware-1.0", "vendor1,foo-firmware";
> > 		method = "smc";
> > 
> > 		// ...
> > 	};
> > 
> > 	bar-firmware {
> > 		compatible = "vendor2,bar-firmware-1.6", "vendor2,bar-firmware";
> > 		method = "smc";
> > 
> > 		// ...
> > 	};
> > 
> > Could make sense.
> 
> I'm not sure if the method property is useful in most cases. For generic

I was mostly illustrating.  It's not useful in most cases, unless we
have standard code parsing these bindings (probably overkill).

> ABIs such as PSCI that actually support multiple communication paths,
> yes, it makes sense. However, it seems like for most custom ABIs, such
> as is presumably implemented by whatever "SecureOS" is on Tegra, the
> firmware type (or compatible value) directly implies that it operates
> over SMC not HVC. After all, presumably if the kernel was virtualized,
> it wouldn't have access to the raw secure monitor? I suppose you could
> argue that the hypervisor might end up emulating the same ABI over HVC
> instead? I'm not sure how likely that is. A compromise might be to
> assume SMC if no property was present, which would allow it to be
> optionally added later if it turned out to be useful.

Sure.

For most firmware interface bindings, the backend could be implied.
The binding could be extended later if an alternative backend were needed.

If an SMC-called firmware interface is visible to a guest running under
a hypervisor at all, it is probably still callable using SMC, since
hypervisors can trap and proxy/emulate it instead of the call bypassing
the hypervisor and going straight to the Secure World.

If the interface is not visible, the hypervisor shouldn't put the relevant
node in the DT supplied to the guest (just as any physical hardware not
accessible to the guest shouldn't be described in the DT).


Firmware interfaces which don't specifically depend on the Security
Extensions need multiple backends, because hypervisors can't trap SMC on
ARMv8 platforms which don't implement the Security Extensions  -- this
was an issue for PSCI, and it's why HVC is used instead by KVM etc.

For "Secure OS" interfaces this won't be an issue since those interfaces
don't make sense if the Security Extensions aren't there.

> > ...where we would require all new firmware interface bindings to
> > include the "-firmware" in their node names and compatible strings
> > (with a version suffix encouraged for the compatible strings, where
> > relevant).
> 
> That's probably a good convention, but I'm not sure it should be
> required (or at least validated by code). Requiring this by code review
> might be OK. Node names aren't meant to be interpreted semantically.

Agreed: I don't think this makes sense as a formal binding, but rather
it's a convention we can follow which avoids DTs being unnecessarily
cryptic.

Cheers
---Dave
