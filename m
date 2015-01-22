Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbbAVLkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 06:40:06 -0500
Received: from www.linutronix.de ([62.245.132.108]:59320 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbbAVLkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 06:40:04 -0500
Date: Thu, 22 Jan 2015 12:39:44 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Borislav Petkov <bp@alien8.de>
cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [patch 01/23] x86/apic: Avoid open coded x2apic detection
In-Reply-To: <20150116095927.GA18880@pd.tnic>
Message-ID: <alpine.DEB.2.11.1501221239040.5526@nanos>
References: <20150115210458.625399149@linutronix.de> <20150115211702.285038186@linutronix.de> <20150116095927.GA18880@pd.tnic>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2015, Borislav Petkov wrote:
> On Thu, Jan 15, 2015 at 09:22:09PM -0000, Thomas Gleixner wrote:
> > enable_IR_x2apic() grew a open coded x2apic detection. Implement a
> > proper helper function which shares the code with the already existing
> > x2apic_enabled().
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > ---
> >  arch/x86/include/asm/apic.h |   18 +++++++++---------
> >  arch/x86/kernel/apic/apic.c |    5 +----
> >  2 files changed, 10 insertions(+), 13 deletions(-)
> > 
> > Index: tip/arch/x86/include/asm/apic.h
> > ===================================================================
> > --- tip.orig/arch/x86/include/asm/apic.h
> > +++ tip/arch/x86/include/asm/apic.h
> > @@ -108,6 +108,14 @@ extern u64 native_apic_icr_read(void);
> >  
> >  extern int x2apic_mode;
> >  
> > +static inline bool apic_is_x2apic_enabled(void)
> > +{
> > +	u64 msr;
> > +
> > +	rdmsrl(MSR_IA32_APICBASE, msr);
> 
> Let's do
> 
> 	struct msr m;
> 
> 	if (msr_read(MSR_IA32_APICBASE, &m))
> 		return false;
> 
> 	return m.l & X2APIC_ENABLE;
> 
> so that we do the safe MSR access too. Who knows where this code gets
> executed in the future.

Updated.
 
> > +}
> > +
> >  #ifdef CONFIG_X86_X2APIC
> >  /*
> >   * Make previous memory operations globally visible before
> > @@ -175,15 +183,7 @@ extern void check_x2apic(void);
> >  extern void enable_x2apic(void);
> >  static inline int x2apic_enabled(void)
> >  {
> > -	u64 msr;
> > -
> > -	if (!cpu_has_x2apic)
> > -		return 0;
> > -
> > -	rdmsrl(MSR_IA32_APICBASE, msr);
> > -	if (msr & X2APIC_ENABLE)
> > -		return 1;
> > -	return 0;
> > +	return cpu_has_x2apic && apic_is_x2apic_enabled();
> 
> ... and then there's
> 
> #define x2apic_supported()      (cpu_has_x2apic)
> 
> which does the cpufeature test.
> 
> Can we agree on one interface only and simplify this a bit more?

I think I do that later on, but will make sure.
