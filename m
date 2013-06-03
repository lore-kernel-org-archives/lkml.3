Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958Ab3FCNnA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:43:00 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:40276 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306Ab3FCNm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:42:57 -0400
Date: Mon, 3 Jun 2013 09:42:41 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: WARNING: at
 /home/konrad/linux-linus/kernel/time/tick-sched.c:935
 tick_nohz_idle_exit+0x195/0x1b0() on v3.10-rc3
Message-ID: <20130603134241.GM6893@phenom.dumpdata.com>
References: <20130530182948.GA11612@phenom.dumpdata.com>
 <alpine.LFD.2.02.1305302152410.2905@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1305302152410.2905@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 10:05:46PM +0200, Thomas Gleixner wrote:
> On Thu, 30 May 2013, Konrad Rzeszutek Wilk wrote:
> > [   40.085841] WARNING: at /home/konrad/linux-linus/kernel/time/tick-sched.c:935 tick_nohz_idle_exit+0x195/0x1b0()
> > 
> > which I presume is b/c the code does not expect to be run _after_ it has
> > offlined. However, under the PV code, the mechanism is that that a CPU
> > that has been offlined, can resume (if it is onlined). If you look at:
> > 
> > 445 static void __cpuinit xen_play_dead(void) /* used only with HOTPLUG_CPU */      
> > 446 {                                                                               
> > 447         play_dead_common();                                                     
> > 448         HYPERVISOR_vcpu_op(VCPUOP_down, smp_processor_id(), NULL);              
> > 449         cpu_bringup();                                                          
> > 450 }                               
> > 
> > That is called right after the CPU is put to sleep and the hypercall 
> > VCPUOP_down blocks - until the CPU is brough back up. And which point
> > we end up calling cpu_bringup - which sets up the clockevets, timers, etc.
> >
> > I am wondering if part of this is that the ts->inidle gets reset
> > b/c we end up resetting all the timers but then when xen_play_dead
> > exits, it ends up right back in the cpu_idle_loop() loop - and we
> > call tick_nohz_idle_exit().
> > 
> > Thoughts?
> 
> cpu_dead() is definitely not expected to return after the cpu has been
> declared dead. I should have put a big fat warning into the generic
> idle loop for this :)
> 
> The reason why you get that warning only now is commit 4b0c0f294
> (tick: Cleanup NOHZ per cpu data on cpu down), which is btw. targeted
> for stable as well.

Ah, that would explain it. Thanks!
> 
> We can't revert the above commit as it fixes a long standing
> nastiness, so for now until I come around to make the idle loop return
> on cpu down you probably need to call tick_nohz_idle_enter() before
> returning from play_dead().

OK.  Could you keep me in mind when you do that cleanup and CC me? Thank you.

