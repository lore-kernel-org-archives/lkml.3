Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859Ab3FLDZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 23:25:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:46796 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754880Ab3FLDZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 23:25:32 -0400
Message-ID: <1371007522.8250.169.camel@pasglop>
Subject: Re: [PATCH] powerpc/sysfs: disable hotplug for the boot cpu
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Zhao Chenhui <chenhui.zhao@freescale.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Wed, 12 Jun 2013 13:25:22 +1000
In-Reply-To: <20130603104315.GA1365@localhost.localdomain>
References: <1369727984-21505-1-git-send-email-chenhui.zhao@freescale.com>
	 <1369727984-21505-2-git-send-email-chenhui.zhao@freescale.com>
	 <1370036984.3928.144.camel@pasglop>
	 <20130603104315.GA1365@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-03 at 18:43 +0800, Zhao Chenhui wrote:
> On Sat, Jun 01, 2013 at 07:49:44AM +1000, Benjamin Herrenschmidt wrote:
> > On Tue, 2013-05-28 at 15:59 +0800, Zhao Chenhui wrote:
> > > Some features depend on the boot cpu, for instance, hibernate/suspend.
> > > So disable hotplug for the boot cpu.
> > 
> > Don't we have code to "move" the boot CPU around when that happens ?
> > 
> > Ben.
> > 
> 
> Currently, the code in generic_cpu_disable() likes this:
> 
>         if (cpu == boot_cpuid)                                                 
> 	                return -EBUSY;

But the code in pseries/hotplug-cpu.c doesn't, we just "move" the boot
CPU around when that happens. Any reason we can't do that generically ?

Cheers,
Ben.

> If the dying cpu is the boot cpu, it will return -EBUSY. In the subsequent error handling,
> cpu_notify_nofail(CPU_DOWN_FAILED) in _cpu_down() will be called. Unfortunately, some
> cpu notifier callbacks handled CPU_DOWN_PREPARE, but not CPU_DOWN_FAILED, such as sched_cpu_inactive().
> So it will cause issues.
> 
> If we set the hotpluggable for the boot cpu, we can prevent user applications from disabling the boot cpu.
> 
> -Chenhui
> 
> > > Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> > > ---
> > >  arch/powerpc/kernel/sysfs.c |    4 +++-
> > >  1 files changed, 3 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/arch/powerpc/kernel/sysfs.c b/arch/powerpc/kernel/sysfs.c
> > > index e68a845..294b1c4e 100644
> > > --- a/arch/powerpc/kernel/sysfs.c
> > > +++ b/arch/powerpc/kernel/sysfs.c
> > > @@ -655,8 +655,10 @@ static int __init topology_init(void)
> > >  		 * CPU.  For instance, the boot cpu might never be valid
> > >  		 * for hotplugging.
> > >  		 */
> > > -		if (ppc_md.cpu_die)
> > > +		if (ppc_md.cpu_die && cpu != boot_cpuid)
> > >  			c->hotpluggable = 1;
> > > +		else
> > > +			c->hotpluggable = 0;
> > >  
> > >  		if (cpu_online(cpu) || c->hotpluggable) {
> > >  			register_cpu(c, cpu);
> > 
> > 
> > 


