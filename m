Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbaD3E5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 00:57:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:51929 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbaD3E5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 00:57:21 -0400
Message-ID: <1398833787.31586.8.camel@pasglop>
Subject: Re: [PATCH] powerpc 32: Provides VIRT_CPU_ACCOUNTING
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Scott Wood <scottwood@freescale.com>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date: Wed, 30 Apr 2014 14:56:27 +1000
In-Reply-To: <1395266717.12479.293.camel@snotra.buserror.net>
References: <20140319215241.236B21A4BDE@localhost.localdomain>
	 <1395266717.12479.293.camel@snotra.buserror.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-19 at 17:05 -0500, Scott Wood wrote:
> On Wed, 2014-03-19 at 22:52 +0100, Christophe Leroy wrote:
> > This patch provides VIRT_CPU_ACCOUTING to PPC32 architecture.
> > Unlike PPC64, PPC32 doesn't provide the PACA register. Therefore the
> > implementation is similar to the one done in the IA64 architecture.
> > It is based on additional information added to the Task Info structure.
> 
> PACA isn't a register -- just a convention for how Linux uses a GPR.
> Maybe it's time to use it on PPC32 as well?

PACA is actually a data structure and you really really don't want it
on ppc32 :-) Having a register point to current works, having a register
point to per-cpu data instead works too (ie, change what we do today),
but don't introduce a PACA *please* :-)

> 
> > Index: b/arch/powerpc/kernel/asm-offsets.c
> > ===================================================================
> > --- b/arch/powerpc/kernel/asm-offsets.c	(revision 5607)
> > +++ b/arch/powerpc/kernel/asm-offsets.c	(revision 5608)
> > @@ -167,6 +167,10 @@
> >  	DEFINE(TI_PREEMPT, offsetof(struct thread_info, preempt_count));
> >  	DEFINE(TI_TASK, offsetof(struct thread_info, task));
> >  	DEFINE(TI_CPU, offsetof(struct thread_info, cpu));
> > +	DEFINE(TI_AC_STAMP, offsetof(struct thread_info, ac_stamp));
> > +	DEFINE(TI_AC_LEAVE, offsetof(struct thread_info, ac_leave));
> > +	DEFINE(TI_AC_STIME, offsetof(struct thread_info, ac_stime));
> > +	DEFINE(TI_AC_UTIME, offsetof(struct thread_info, ac_utime));
> 
> Doesn't this need to be protected by #ifdef
> CONFIG_VIRT_CPU_ACCOUNTING_NATIVE?
> 
> >  
> >  #ifdef CONFIG_PPC64
> >  	DEFINE(DCACHEL1LINESIZE, offsetof(struct ppc64_caches, dline_size));
> > Index: b/arch/powerpc/include/asm/thread_info.h
> > ===================================================================
> > --- b/arch/powerpc/include/asm/thread_info.h	(revision 5607)
> > +++ b/arch/powerpc/include/asm/thread_info.h	(revision 5608)
> > @@ -43,6 +43,12 @@
> >  	int		cpu;			/* cpu we're on */
> >  	int		preempt_count;		/* 0 => preemptable,
> >  						   <0 => BUG */
> > +#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
> > +	__u32 ac_stamp;
> > +	__u32 ac_leave;
> > +	__u32 ac_stime;
> > +	__u32 ac_utime;
> > +#endif
> 
> This isn't uapi; why not use "u32"?
> 
> Plus, it should be made clear that this is only used on 32-bit.
> 
> >  	struct restart_block restart_block;
> >  	unsigned long	local_flags;		/* private flags for thread */
> >  
> > @@ -58,6 +64,8 @@
> >  	.task =		&tsk,			\
> >  	.exec_domain =	&default_exec_domain,	\
> >  	.cpu =		0,			\
> > +	.ac_stime =	0,			\
> > +	.ac_utime =	0,			\
> 
> Also needs to be ifdeffed -- which isn't going to work in a macro, so
> maybe remove the ifdef from the variable declarations, or just let the
> fields be initialized to zero by default.  Or add PACA to 32-bit. :-)
> 
> -Scott
> 


