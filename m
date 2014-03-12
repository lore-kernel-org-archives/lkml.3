Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbaCLEeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 00:34:16 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:3433
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750866AbaCLEeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 00:34:15 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(z579ehz98dI936eI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2dh2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h16a6h1758h1806h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1de2h1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h1155h)
Date: Wed, 12 Mar 2014 12:34:07 +0800
From: Chenhui Zhao <chenhui.zhao@freescale.com>
To: Scott Wood <scottwood@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <leoli@freescale.com>, <Jason.Jin@freescale.com>
Subject: Re: [PATCH 4/9] powerpc/85xx: support CPU hotplug for e500mc and
 e5500
Message-ID: <20140312043407.GC4706@localhost.localdomain>
References: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
 <1394168285-32275-4-git-send-email-chenhui.zhao@freescale.com>
 <1394581693.13761.66.camel@snotra.buserror.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1394581693.13761.66.camel@snotra.buserror.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 06:48:13PM -0500, Scott Wood wrote:
> On Fri, 2014-03-07 at 12:58 +0800, Chenhui Zhao wrote:
> > diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
> > index ac2621a..f3f4401 100644
> > --- a/arch/powerpc/kernel/smp.c
> > +++ b/arch/powerpc/kernel/smp.c
> > @@ -405,8 +405,12 @@ void generic_cpu_die(unsigned int cpu)
> >  
> >  	for (i = 0; i < 100; i++) {
> >  		smp_rmb();
> > -		if (per_cpu(cpu_state, cpu) == CPU_DEAD)
> > +		if (per_cpu(cpu_state, cpu) == CPU_DEAD) {
> > +#ifdef CONFIG_PPC64
> > +			paca[cpu].cpu_start = 0;
> > +#endif
> 
> Why wasn't this needed by previous ppc64 machines?

If not clear, cpu can't start in the case of cpu hotpolug.
The function pseries_cpu_die() in arch/powerpc/platforms/pseries/hotplug-cpu.c
also clears the flag.

> 
> > diff --git a/arch/powerpc/platforms/85xx/smp.c b/arch/powerpc/platforms/85xx/smp.c
> > index 2e5911e..0047883 100644
> > --- a/arch/powerpc/platforms/85xx/smp.c
> > +++ b/arch/powerpc/platforms/85xx/smp.c
> > @@ -19,6 +19,7 @@
> >  #include <linux/kexec.h>
> >  #include <linux/highmem.h>
> >  #include <linux/cpu.h>
> > +#include <linux/smp.h>
> >  
> >  #include <asm/machdep.h>
> >  #include <asm/pgtable.h>
> > @@ -46,6 +47,17 @@ static u64 timebase;
> >  static int tb_req;
> >  static int tb_valid;
> >  
> > +#ifdef CONFIG_PPC_E500MC
> > +/* specify the cpu PM state when cpu dies, PH15/NAP is the default */
> > +int qoriq_cpu_die_state = E500_PM_PH15;
> > +#endif
> 
> static?  Is there any way to modify this other than modifying source
> code?
> 
> BTW, QorIQ doesn't imply an e500mc derivative.

Will support e500, but for now these code support e500mc derivative in
advance.

Supposed qoriq_cpu_die_state can be changed by platform init code
if the default value is not proper for a specific platform.

> 
> > @@ -125,6 +138,34 @@ static void mpc85xx_take_timebase(void)
> >  }
> >  
> >  #ifdef CONFIG_HOTPLUG_CPU
> > +#ifdef CONFIG_PPC_E500MC
> > +static void qoriq_cpu_die(void)
> > +{
> > +	unsigned int cpu = smp_processor_id();
> > +
> > +	local_irq_disable();
> > +#ifdef CONFIG_PPC64
> > +	__hard_irq_disable();
> > +#endif
> 
> Why this instead of one call to hard_irq_disable() (no leading
> underscores)?
> 
> -Scott

hard_irq_disable() will clear soft_enabled again. local_irq_disable()
has cleared it.

Will use hard_irq_disable() to replace these lines.

  local_irq_disable();
  #ifdef CONFIG_PPC64
  	__hard_irq_disable();
  #endif

-Chenhui

