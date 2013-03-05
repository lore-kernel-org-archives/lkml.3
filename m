Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab3CEOGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 09:06:19 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:45227 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab3CEOGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 09:06:16 -0500
Date: Tue, 5 Mar 2013 09:04:52 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: Rob Herring <robherring2@gmail.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "Keir (Xen.org)" <keir@xen.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Nicolas Pitre <nico@fluxnic.net>, Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH LINUX v5] xen: event channel arrays are xen_ulong_t and
 not unsigned long
Message-ID: <20130305140452.GE2589@phenom.dumpdata.com>
References: <1361285327.1051.115.camel@zakaz.uk.xensource.com>
 <1361360886-2956-1-git-send-email-ian.campbell@citrix.com>
 <51340ACD.70904@gmail.com>
 <1362455801.8941.24.camel@hastur.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362455801.8941.24.camel@hastur.hellion.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 03:56:41AM +0000, Ian Campbell wrote:
> > > diff --git a/arch/arm/include/asm/xen/events.h b/arch/arm/include/asm/xen/events.h
> > > index 94b4e90..5c27696 100644
> > > --- a/arch/arm/include/asm/xen/events.h
> > > +++ b/arch/arm/include/asm/xen/events.h
> > > @@ -15,4 +15,26 @@ static inline int xen_irqs_disabled(struct pt_regs *regs)
> > >  	return raw_irqs_disabled_flags(regs->ARM_cpsr);
> > >  }
> > >  
> > > +/*
> > > + * We cannot use xchg because it does not support 8-byte
> > > + * values. However it is safe to use {ldr,dtd}exd directly because all
> > > + * platforms which Xen can run on support those instructions.
> > 
> > Why does atomic64_cmpxchg not work here?
> 
> Just that we don't want/need the cmp aspect, we don't mind if an extra
> bit gets set as we read the value, so long as we atomically read and set
> to zero.
> 
> > > + */
> > > +static inline xen_ulong_t xchg_xen_ulong(xen_ulong_t *ptr, xen_ulong_t val)
> > > +{
> > > +	xen_ulong_t oldval;
> > > +	unsigned int tmp;
> > > +
> > > +	wmb();
> > 
> > Based on atomic64_cmpxchg implementation, you could use smp_mb here
> > which avoids an outer cache flush.
> 
> Good point.
> 
> > > +	asm volatile("@ xchg_xen_ulong\n"
> > > +		"1:     ldrexd  %0, %H0, [%3]\n"
> > > +		"       strexd  %1, %2, %H2, [%3]\n"
> > > +		"       teq     %1, #0\n"
> > > +		"       bne     1b"
> > > +		: "=&r" (oldval), "=&r" (tmp)
> > > +		: "r" (val), "r" (ptr)
> > > +		: "memory", "cc");
> > 
> > And a smp_mb is needed here.
> 
> I think for the specific caller which we have here it isn't strictly
> necessary, but for generic correctness I think you are right.
> 
> Thanks for reviewing.
> 
> Konrad, IIRC you have already picked this up (and sent to Linus?) so an

Yes.
> incremental fix is required? See below.

Why don't I wait a bit and wait until you are back from conferences and
can post a nice series that fixes the smp_wmb() and also the atomic one
and has been run-time tested with Xen on ARM.
