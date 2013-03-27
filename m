Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab3C0SMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 14:12:33 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53712 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752159Ab3C0SMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 14:12:32 -0400
Date: Wed, 27 Mar 2013 18:12:06 +0000
From: Will Deacon <will.deacon@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Rob Herring <robherring2@gmail.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "nico@linaro.org" <nico@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3] [RFC] arm: use PSCI if available
Message-ID: <20130327181206.GD20990@mudshark.cambridge.arm.com>
References: <1364388639-11210-1-git-send-email-stefano.stabellini@eu.citrix.com>
 <51531F76.2090200@gmail.com>
 <20130327170555.GA20990@mudshark.cambridge.arm.com>
 <201303271750.52015.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201303271750.52015.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 05:50:51PM +0000, Arnd Bergmann wrote:
> On Wednesday 27 March 2013, Will Deacon wrote:
> > The channel is common, sure, but I wouldn't expect the semantics of each
> > call to be identical between firmware implementations (going back to my
> > previous examples of CPU IDs and implementation-defined state parameters).
> > 
> > If a platform happens to have an id-mapping from smp_operations to psci,
> > then I still think there should be an indirection in there so that we have
> > the flexibility to change the smp_operations if we wish and not give
> > platforms the false impression that these two things are equivalent.
> 
> I think the only reasonably implementation for psci is if we can assume
> that each callback with a specific property name has a well-defined behavior,
> and we should mandate that every platform that implements the callbacks
> we need for SMP actually implements them according to the spec.
> 
> What would be the point of a standard psci interface if the specific
> implementation are not required to follow the same semantics?

The interface *is* standard. The functions have well-defined headers and can
be called in the same way between implementations. The difference is in the
semantics of the parameters. For example:

  int cpu_off(u32 power_state);

If you look at the power_state parameter, it's actually a struct (see struct
psci_power_state) with a u16 id field. The current specification describes
that field as `This is platform specific, the number is understood by the
firmware, and used to program the power controller.'.

So unless we get everybody to agree on the definition of that field, we
can't blindly plug the interfaces together. Furthermore, there are other
parameters like this and, as new functions are specified, I would expect
them to grow.

Will
