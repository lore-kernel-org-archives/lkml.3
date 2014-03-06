Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbaCFKWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 05:22:37 -0500
Received: from www.linutronix.de ([62.245.132.108]:51427 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbaCFKWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 05:22:31 -0500
Date: Thu, 6 Mar 2014 11:22:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Rientjes <rientjes@google.com>
cc: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Rui Wang <rui.y.wang@intel.com>,
        Liu Ping Fan <kernelfans@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Lv Zheng <lv.zheng@intel.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@intel.com>, Andi Kleen <ak@linux.intel.com>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Li Fei <fei.li@intel.com>, gong.chen@linux.intel.com
Subject: Re: [PATCH] x86, fix x86 fixup_irqs() error handling
In-Reply-To: <alpine.DEB.2.02.1403051307590.22928@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1403061122010.18573@ionos.tec.linutronix.de>
References: <1394049854-28266-1-git-send-email-prarit@redhat.com> <alpine.DEB.2.02.1403051307590.22928@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 5 Mar 2014, David Rientjes wrote:

> On Wed, 5 Mar 2014, Prarit Bhargava wrote:
> 
> > diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> > index d99f31d..55fab61 100644
> > --- a/arch/x86/kernel/irq.c
> > +++ b/arch/x86/kernel/irq.c
> > @@ -351,6 +351,7 @@ void fixup_irqs(void)
> >  	struct irq_desc *desc;
> >  	struct irq_data *data;
> >  	struct irq_chip *chip;
> > +	int ret;
> >  
> >  	for_each_irq_desc(irq, desc) {
> >  		int break_affinity = 0;
> > @@ -389,8 +390,12 @@ void fixup_irqs(void)
> >  		if (!irqd_can_move_in_process_context(data) && chip->irq_mask)
> >  			chip->irq_mask(data);
> >  
> > -		if (chip->irq_set_affinity)
> > -			chip->irq_set_affinity(data, affinity, true);
> > +		if (chip->irq_set_affinity) {
> > +			ret = chip->irq_set_affinity(data, affinity, true);
> > +			WARN(ret == -ENOSPC,
> > +			     "IRQ %d set affinity failed with %d.  The device assigned to this IRQ is unstable.\n",
> > +			     irq, ret);
> 
> Should this be WARN_ON_ONCE() to avoid filling the kernel log instead?
> 
> It doesn't make much sense to print out the negative return value, maybe 
> you meant to print -ret instead?

Well, that does not make sense either. We only print if ret == -ENOSPC!
 
> > +		}
> >  		else if (!(warned++))
> >  			set_affinity = 0;
> >  
> 
