Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab3FCKnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 06:43:31 -0400
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:1635 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753081Ab3FCKn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 06:43:29 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h16a6h1758h1806h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1de2h1dfeh1dffh1155h)
Date: Mon, 3 Jun 2013 18:43:15 +0800
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] powerpc/sysfs: disable hotplug for the boot cpu
Message-ID: <20130603104315.GA1365@localhost.localdomain>
References: <1369727984-21505-1-git-send-email-chenhui.zhao@freescale.com>
 <1369727984-21505-2-git-send-email-chenhui.zhao@freescale.com>
 <1370036984.3928.144.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1370036984.3928.144.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 01, 2013 at 07:49:44AM +1000, Benjamin Herrenschmidt wrote:
> On Tue, 2013-05-28 at 15:59 +0800, Zhao Chenhui wrote:
> > Some features depend on the boot cpu, for instance, hibernate/suspend.
> > So disable hotplug for the boot cpu.
> 
> Don't we have code to "move" the boot CPU around when that happens ?
> 
> Ben.
> 

Currently, the code in generic_cpu_disable() likes this:

        if (cpu == boot_cpuid)                                                 
	                return -EBUSY;

If the dying cpu is the boot cpu, it will return -EBUSY. In the subsequent error handling,
cpu_notify_nofail(CPU_DOWN_FAILED) in _cpu_down() will be called. Unfortunately, some
cpu notifier callbacks handled CPU_DOWN_PREPARE, but not CPU_DOWN_FAILED, such as sched_cpu_inactive().
So it will cause issues.

If we set the hotpluggable for the boot cpu, we can prevent user applications from disabling the boot cpu.

-Chenhui

> > Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> > ---
> >  arch/powerpc/kernel/sysfs.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/powerpc/kernel/sysfs.c b/arch/powerpc/kernel/sysfs.c
> > index e68a845..294b1c4e 100644
> > --- a/arch/powerpc/kernel/sysfs.c
> > +++ b/arch/powerpc/kernel/sysfs.c
> > @@ -655,8 +655,10 @@ static int __init topology_init(void)
> >  		 * CPU.  For instance, the boot cpu might never be valid
> >  		 * for hotplugging.
> >  		 */
> > -		if (ppc_md.cpu_die)
> > +		if (ppc_md.cpu_die && cpu != boot_cpuid)
> >  			c->hotpluggable = 1;
> > +		else
> > +			c->hotpluggable = 0;
> >  
> >  		if (cpu_online(cpu) || c->hotpluggable) {
> >  			register_cpu(c, cpu);
> 
> 
> 

