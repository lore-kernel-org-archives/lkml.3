Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbaHGAEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 20:04:24 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:57023 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbaHGAEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 20:04:23 -0400
X-Originating-IP: 173.246.103.110
Date: Wed, 6 Aug 2014 17:04:14 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: Add "make tinyconfig" to configure the tiniest
 possible kernel
Message-ID: <20140807000414.GA17455@jtriplet-mobl1>
References: <20140806222419.GA2566@jtriplet-mobl1>
 <20140806223152.GA14348@jtriplet-mobl1>
 <alpine.DEB.2.02.1408061537220.13545@chino.kir.corp.google.com>
 <20140806224903.GA14782@jtriplet-mobl1>
 <alpine.DEB.2.02.1408061637110.13545@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1408061637110.13545@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 04:37:54PM -0700, David Rientjes wrote:
> On Wed, 6 Aug 2014, Josh Triplett wrote:
> > On Wed, Aug 06, 2014 at 03:38:56PM -0700, David Rientjes wrote:
> > > On Wed, 6 Aug 2014, Josh Triplett wrote:
> > > > diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> > > > index 1568678..2b5ca16 100644
> > > > --- a/arch/x86/Makefile
> > > > +++ b/arch/x86/Makefile
> > > > @@ -257,6 +257,10 @@ PHONY += kvmconfig
> > > >  kvmconfig:
> > > >  	$(call mergeconfig,kvm_guest)
> > > >  
> > > > +PHONY += tinyconfig
> > > > +tinyconfig: allnoconfig
> > > 
> > > Calling allnoconfig here makes "make tinyconfig" default to CONFIG_X86_32 
> > > even on 64 bit platforms and the caller would need to explicitly do
> > > "make ARCH=x86_64 tinyconfig" to avoid it.  It's not clear that this is 
> > > intended from the documentation of tinyconfig, that tiniest == 32 bit by 
> > > default.
> > 
> > Calling allnoconfig was quite intentional; this is intended to be the
> > smallest possible configuration, and unlike kvmconfig (which modifies an
> > existing configuration to make it suitable for a KVM guest), this
> > intentionally creates a specific new configuration from scratch.
> > 
> > 32-bit produces a far smaller kernel than 64-bit, so having that as the
> > default for tinyconfig seems quite appropriate.  As you showed, it's
> > easy enough to override it if needed.  I'd expect many potential users
> > of tinyconfig for embedded systems to start with tinyconfig and then
> > immediately use menuconfig to enable a pile of additional options.
> 
> In that case, any reason to make tinyconfig x86 only?

The set of configuration options may vary by architecture.  For
instance, NOHIGHMEM only exists on x86.  So, at a minimum, different
architectures will require different versions of tiny.config.

The target itself and the common options could theoretically be shared,
but that would require splitting the configuration, and it isn't obvious
where the non-arch-specific tiny.config would live.  There doesn't
appear to be any precedent for that kind of setup; only x86 has a
configuration other than defconfigs (specifically, kvm_guest.config).  I
don't think it's likely that new targets like this will pop up often in
the future, either.

Nonetheless, I could modify scripts/kconfig/Makefile to add this target
instead, if someone has a good suggestion for where the
non-arch-specific tiny.config should live.  (kernel/configs/ ?)

- Josh Triplett
