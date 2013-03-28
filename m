Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab3C1Ms0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 08:48:26 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:2901 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755617Ab3C1MsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 08:48:25 -0400
X-IronPort-AV: E=Sophos;i="4.84,925,1355097600"; 
   d="scan'208";a="15368636"
Date: Thu, 28 Mar 2013 12:48:20 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Will Deacon <will.deacon@arm.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arnd@arndb.de" <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "nico@linaro.org" <nico@linaro.org>
Subject: Re: [PATCH v3] [RFC] arm: use PSCI if available
In-Reply-To: <20130327172306.GB20990@mudshark.cambridge.arm.com>
Message-ID: <alpine.DEB.2.02.1303281225050.4430@kaball.uk.xensource.com>
References: <1364388639-11210-1-git-send-email-stefano.stabellini@eu.citrix.com> <20130327133811.GE18429@mudshark.cambridge.arm.com> <alpine.DEB.2.02.1303271610430.4430@kaball.uk.xensource.com> <20130327172306.GB20990@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Mar 2013, Will Deacon wrote:
> On Wed, Mar 27, 2013 at 04:23:15PM +0000, Stefano Stabellini wrote:
> > OK, let's see if I can make this acceptable to you.
> > 
> > 
> > Would you agree on a patch that moves virt_smp_ops out of mach-virt and
> > renames them to psci_smp_ops (maybe to arch/arm/kernel/psci_smp_ops.c)?
> 
> Moving the code out of psci.c is certainly a good first step, yes.

OK, I'll do that.


> > Would you agree on initializing psci from setup_arch, right after the
> > call to arm_dt_init_cpu_maps()?
> 
> Hmmm. An early_initcall runs before SMP is up, so why do you need this
> earlier than that? Is it because you don't want to set the SMP ops later on?

Because I need to set the right smp_ops before any of the smp_ops
functions are called.
If I wait until early_initcall, the wrong smp_init_cpus is going to be
called.


> > Finally the most controversial point: would you agree on using
> > psci_smp_ops by default if they are available?
> > If not, would you at least agree on letting Xen overwrite the default
> > machine smp_ops?
> > We need one or the other for dom0 support.
> 
> Again, I think there needs to be a dummy layer between the smp_ops and PSCI,
> rather than assigning the things directly if we're going to use this as a
> default implementation. I still question whether default PSCI operations make
> any sense though... I understand that you're currently saying `yes, Xen can
> use the same firmware interface as KVM' but will that always be true? What
> happens when we want to run virtual machines on multi-cluster platforms, for
> example? Will KVM and Xen make sure that CPU affinities are described in the
> same way? What if one or the other decides to pass side-band information in
> the power_state parameters?
> 
> In all of these cases, we'd have to split the code back up, so I don't see
> any long-term value in consolidating everything just because it might be
> possible today. The real problem you're trying to solve seems to stem from
> patching the smp_ops in your dom0 kernel.

That is correct.
Although having a clean generic solution would be preferable to me, if
we cannot reach an agreement or if just cannot be done, an hack that
patch smp_ops would also solve the Xen problem (see
http://marc.info/?l=linux-arm-kernel&m=136440425214113&w=2).
I distaste hacks as anybody else, so I would rather solve the issue in a
different way.


> Can you elaborate a bit more on
> what's going on here please? How would having PSCI default smp_ops help you?

As Arnd quickly explained
(http://marc.info/?l=linux-arm-kernel&m=136440746215589&w=2), the
hardware environment provided by Xen to Dom0 looks very similar to the
native hardware but with a few important differences:

- the amount of memory is probably lower, in fact Xen is going to edit
the device tree and only tell Dom0 about the memory that Dom0 can
actually see;

- the number of cpus might be different, in fact Xen is going to edit
the device tree and tell Dom0 about the vcpus that Dom0 can actually
see;

- not all the devices present might actually be exported to Dom0, in
fact Xen is going to remove these devices from the device tree so that
Dom0 won't try to access them;

- the interface to bring up secondary cpus is different and based on
PSCI, in fact Xen is going to add a PSCI node to the device tree so that
Dom0 can use it.

Oh wait, Dom0 is not going to use the PSCI interface even if the node is
present on device tree because it's going to prefer the platform smp_ops
instead.

Fail.


Xen can however add any nodes to device tree besides PSCI, it already
adds a Xen hypervisor node, unfortunately the smp_ops are not detected
via device tree at the moment so that won't help.

So I guess what we really need is a way to export a set of firmware
operations for cpu bring up via device tree. I thought that PSCI was
exactly meant for this, but if it isn't, then we need to come up with
something else.
