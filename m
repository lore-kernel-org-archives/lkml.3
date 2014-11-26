Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbaKZOrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:47:07 -0500
Received: from www.linutronix.de ([62.245.132.108]:51299 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbaKZOrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:47:05 -0500
Date: Wed, 26 Nov 2014 15:46:56 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Berthier, Emmanuel" <emmanuel.berthier@intel.com>
cc: "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Jarzmik, Robert" <robert.jarzmik@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] [LBR] Dump LBRs on Oops
In-Reply-To: <65CD3FC07F3BF942ABE211646D72D770356EAC51@IRSMSX110.ger.corp.intel.com>
Message-ID: <alpine.DEB.2.11.1411261536400.3961@nanos>
References: <1416589419-9952-1-git-send-email-emmanuel.berthier@intel.com> <alpine.DEB.2.11.1411212240390.6439@nanos> <65CD3FC07F3BF942ABE211646D72D770356EA9E0@IRSMSX110.ger.corp.intel.com> <alpine.DEB.2.11.1411261318050.3961@nanos>
 <65CD3FC07F3BF942ABE211646D72D770356EAC51@IRSMSX110.ger.corp.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2014, Berthier, Emmanuel wrote:
> > We add printks not for people who work on the support of unreleased
> > hardware. They should better know what they are doing. If they can't figure
> > that out they should not touch the kernel in the first place.
> 
> LoL
> I'm part of those people, I've touched the kernel and I've figured out what was wrong.
> And I would like to be helped next year for the next Core: I'm an old man and I need
> to leave a white stone trail  ;-)
> Could we agree on that one?

We already have a printk in init_intel_pmu() where we tell about the
'unidentified cpu', so we better extend that instead of having
something dependent on a OOPS.
 
> > > > Aside of that if we want to debug with the LBR then we better freeze
> > > > that whole thing across a dump and be done with it.
> > >
> > > I met that case but did no dig deeply into it...
> > 
> > Hmm, a corrupted stack might trigger this together with some of the other
> > debug options enabled. So we really might to put it in front.
> 
> Didn't catch you. Could you elaborate on that?

Assume a stack corruption, so the stack dumper follows it w/o noticing
and hits an unmapped page. So that would be an argument to move the
LBR print out ahead of the stack dump.
 
> > 1) We want to enable/disable this at boot time.
> > 
> >    In the disabled case we might also stub out the test/jz and replace
> >    it by an unconditional jump, but that needs more thought.
> 
> I can add a cmdline option to disable it at boot time.

Enable. Should be disabled by default I think.

> Do you propose to use code instruction patching (same as ftrace)
> also?  Is-it really worth to bypass test/jz as page fault handling
> is much more than few instructions?

That's why I said: but that needs more thought.

Though OTOH we keep adding stuff there and if we want to enable that
LBR feature more widely we should think about keeping the overhead low
if it is disabled.

We can discuss this after we have a agreed on patch for that feature.

> > 2) Right now you stop the trace on every exception no matter whether
> >    it comes from user or kernel space.
> > 
> >    Stopping the trace when we handle a user space fault does not make
> >    any sense and inflicts just pointless overhead.
> >
> >    Aside of that if the fault handler then crashes we do not have the
> >    LBR information because we froze it when entering from user space
> >    in the first place.
> 
> Agree, but the LBR buffer contains only 8 records: we have to stop
> it as soon as possible.  If we add some test/jump/call before
> stopping it, relevant info will be flushed out.

Well, you can certainly test that w/o a jump. Hint:

      if (enabled && is_kernel)
      	 goto x;

can be written in ASM with a single branch as well :)

That adds more instructions before the jz, which might in fact make
the code patching for the disabled case more interesting.

Thanks,

	tglx
