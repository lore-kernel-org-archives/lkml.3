Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbaKZPna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 10:43:30 -0500
Received: from mga03.intel.com ([134.134.136.65]:15285 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbaKZPn3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 10:43:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,462,1413270000"; 
   d="scan'208";a="643930162"
From: "Berthier, Emmanuel" <emmanuel.berthier@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Jarzmik, Robert" <robert.jarzmik@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] [LBR] Dump LBRs on Oops
Thread-Topic: [PATCH] [LBR] Dump LBRs on Oops
Thread-Index: AQHQBa06swP7VVqtjkGZ0Sl9b+2CXJxr0WOAgAbwn5CAACa3gIAAC51AgAAP9QCAAAwlsA==
Date: Wed, 26 Nov 2014 15:43:25 +0000
Message-ID: <65CD3FC07F3BF942ABE211646D72D770356EACA5@IRSMSX110.ger.corp.intel.com>
References: <1416589419-9952-1-git-send-email-emmanuel.berthier@intel.com>
 <alpine.DEB.2.11.1411212240390.6439@nanos>
 <65CD3FC07F3BF942ABE211646D72D770356EA9E0@IRSMSX110.ger.corp.intel.com>
 <alpine.DEB.2.11.1411261318050.3961@nanos>
 <65CD3FC07F3BF942ABE211646D72D770356EAC51@IRSMSX110.ger.corp.intel.com>
 <alpine.DEB.2.11.1411261536400.3961@nanos>
In-Reply-To: <alpine.DEB.2.11.1411261536400.3961@nanos>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.182]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Wednesday, November 26, 2014 3:47 PM
> To: Berthier, Emmanuel
> Cc: mingo@redhat.com; hpa@zytor.com; x86@kernel.org; Jarzmik, Robert;
> linux-kernel@vger.kernel.org
> Subject: RE: [PATCH] [LBR] Dump LBRs on Oops
> 
> On Wed, 26 Nov 2014, Berthier, Emmanuel wrote:
> > > We add printks not for people who work on the support of unreleased
> > > hardware. They should better know what they are doing. If they can't
> > > figure that out they should not touch the kernel in the first place.
> >
> > LoL
> > I'm part of those people, I've touched the kernel and I've figured out what
> was wrong.
> > And I would like to be helped next year for the next Core: I'm an old
> > man and I need to leave a white stone trail  ;-) Could we agree on
> > that one?
> 
> We already have a printk in init_intel_pmu() where we tell about the
> 'unidentified cpu', so we better extend that instead of having something
> dependent on a OOPS.

That's right, I have a patch for that also.

> > > > > Aside of that if we want to debug with the LBR then we better
> > > > > freeze that whole thing across a dump and be done with it.
> > > >
> > > > I met that case but did no dig deeply into it...
> > >
> > > Hmm, a corrupted stack might trigger this together with some of the
> > > other debug options enabled. So we really might to put it in front.
> >
> > Didn't catch you. Could you elaborate on that?
> 
> Assume a stack corruption, so the stack dumper follows it w/o noticing and
> hits an unmapped page. So that would be an argument to move the LBR print
> out ahead of the stack dump.

Ok, so no need to change anything here?

> > > 1) We want to enable/disable this at boot time.
> > >
> > >    In the disabled case we might also stub out the test/jz and replace
> > >    it by an unconditional jump, but that needs more thought.
> >
> > I can add a cmdline option to disable it at boot time.
> 
> Enable. Should be disabled by default I think.

ok

> > Do you propose to use code instruction patching (same as ftrace) also?
> > Is-it really worth to bypass test/jz as page fault handling is much
> > more than few instructions?
> 
> That's why I said: but that needs more thought.
> 
> Though OTOH we keep adding stuff there and if we want to enable that LBR
> feature more widely we should think about keeping the overhead low if it is
> disabled.
> 
> We can discuss this after we have a agreed on patch for that feature.

Ok

> > > 2) Right now you stop the trace on every exception no matter whether
> > >    it comes from user or kernel space.
> > >
> > >    Stopping the trace when we handle a user space fault does not make
> > >    any sense and inflicts just pointless overhead.
> > >
> > >    Aside of that if the fault handler then crashes we do not have the
> > >    LBR information because we froze it when entering from user space
> > >    in the first place.
> >
> > Agree, but the LBR buffer contains only 8 records: we have to stop it
> > as soon as possible.  If we add some test/jump/call before stopping
> > it, relevant info will be flushed out.
> 
> Well, you can certainly test that w/o a jump. Hint:
> 
>       if (enabled && is_kernel)
>       	 goto x;
> 
> can be written in ASM with a single branch as well :)
> 
> That adds more instructions before the jz, which might in fact make the code
> patching for the disabled case more interesting.

I will keep it small, trust me! ;-)
