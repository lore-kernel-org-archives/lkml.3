Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbaEOWer (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 18:34:47 -0400
Received: from madhathacker.net ([178.63.244.10]:60439 "EHLO madhathacker.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbaEOWeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 18:34:46 -0400
Date: Fri, 16 May 2014 00:32:22 +0200
From: Erik Bosman <erik@minemu.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] x86: SROP mitigation: implement signal canaries
Message-ID: <20140515223222.GA9727@pizzadoos.com>
References: <20140515211004.GA9575@pizzadoos.com>
 <87vbt6rao3.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vbt6rao3.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 02:31:40PM -0700, Andi Kleen wrote:
> Erik Bosman <erik@minemu.org> writes:
> 
> >  
> > diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
> > index 2206757..1a9285a 100644
> > --- a/arch/x86/ia32/ia32_signal.c
> > +++ b/arch/x86/ia32/ia32_signal.c
> > @@ -212,9 +212,18 @@ asmlinkage long sys32_sigreturn(void)
> >  	struct sigframe_ia32 __user *frame = (struct sigframe_ia32 __user *)(regs->sp-8);
> >  	sigset_t set;
> >  	unsigned int ax;
> > +#ifdef CONFIG_SIGNAL_CANARY
> > +	u32 canary;
> > +#endif
> 
> Don't you completely break the ABI here? I'm sure there are programs out
> there who hard code the offset into the FP state.
> 
> I think you either need to put it at the total end or somewhere
> currently unused
> 

Hrmz.. FP state is aligned on a 64 byte boundary, the signal frame (separately)
on a 16 byte-sizeof(long) boundary.  But it looks like that for 32 and 64 bit
rt_sigreturn this means no padding :-/

It looks like I'll have to put the canary beyond the fp state. :-(
I had hoped to avoid pointer arithmetic. :-/

Erik

> Besides that I would remove the CONFIG_* once it works and just do it
> unconditionally.
> 
> -Andi
> 
> 
> -- 
> ak@linux.intel.com -- Speaking for myself only
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
