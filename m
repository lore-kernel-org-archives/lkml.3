Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab3FML0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 07:26:16 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:30210
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752088Ab3FML0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 07:26:14 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h16a6h1758h1806h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1de2h1dfeh1dffh1155h)
Date: Thu, 13 Jun 2013 19:25:52 +0800
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] powerpc/sysfs: disable hotplug for the boot cpu
Message-ID: <20130613112552.GC7536@localhost.localdomain>
References: <1369727984-21505-1-git-send-email-chenhui.zhao@freescale.com>
 <1369727984-21505-2-git-send-email-chenhui.zhao@freescale.com>
 <1370036984.3928.144.camel@pasglop>
 <20130603104315.GA1365@localhost.localdomain>
 <1371007522.8250.169.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1371007522.8250.169.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 01:25:22PM +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2013-06-03 at 18:43 +0800, Zhao Chenhui wrote:
> > On Sat, Jun 01, 2013 at 07:49:44AM +1000, Benjamin Herrenschmidt wrote:
> > > On Tue, 2013-05-28 at 15:59 +0800, Zhao Chenhui wrote:
> > > > Some features depend on the boot cpu, for instance, hibernate/suspend.
> > > > So disable hotplug for the boot cpu.
> > > 
> > > Don't we have code to "move" the boot CPU around when that happens ?
> > > 
> > > Ben.
> > > 
> > 
> > Currently, the code in generic_cpu_disable() likes this:
> > 
> >         if (cpu == boot_cpuid)                                                 
> > 	                return -EBUSY;
> 
> But the code in pseries/hotplug-cpu.c doesn't, we just "move" the boot
> CPU around when that happens. Any reason we can't do that generically ?
> 
> Cheers,
> Ben.
> 

Some multicore SoCs firstly boot up the cpu0 after warm reset.
In some suspend/resume cases, SoC will do a warm reset when resuming.
In order to ensure that the suspending and resuming is running
on a same cpu, cpu0 should be the last cpu to suspend. Here, cpu0 is
the boot_cpuid.

-Chenhui

> > If the dying cpu is the boot cpu, it will return -EBUSY. In the subsequent error handling,
> > cpu_notify_nofail(CPU_DOWN_FAILED) in _cpu_down() will be called. Unfortunately, some
> > cpu notifier callbacks handled CPU_DOWN_PREPARE, but not CPU_DOWN_FAILED, such as sched_cpu_inactive().
> > So it will cause issues.
> > 
> > If we set the hotpluggable for the boot cpu, we can prevent user applications from disabling the boot cpu.
> > 
> > -Chenhui
> > 

