Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933186Ab3E3UFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 16:05:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:35089 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab3E3UFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 16:05:48 -0400
Date: Thu, 30 May 2013 22:05:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: WARNING: at /home/konrad/linux-linus/kernel/time/tick-sched.c:935
 tick_nohz_idle_exit+0x195/0x1b0() on v3.10-rc3
In-Reply-To: <20130530182948.GA11612@phenom.dumpdata.com>
Message-ID: <alpine.LFD.2.02.1305302152410.2905@ionos>
References: <20130530182948.GA11612@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 May 2013, Konrad Rzeszutek Wilk wrote:
> [   40.085841] WARNING: at /home/konrad/linux-linus/kernel/time/tick-sched.c:935 tick_nohz_idle_exit+0x195/0x1b0()
> 
> which I presume is b/c the code does not expect to be run _after_ it has
> offlined. However, under the PV code, the mechanism is that that a CPU
> that has been offlined, can resume (if it is onlined). If you look at:
> 
> 445 static void __cpuinit xen_play_dead(void) /* used only with HOTPLUG_CPU */      
> 446 {                                                                               
> 447         play_dead_common();                                                     
> 448         HYPERVISOR_vcpu_op(VCPUOP_down, smp_processor_id(), NULL);              
> 449         cpu_bringup();                                                          
> 450 }                               
> 
> That is called right after the CPU is put to sleep and the hypercall 
> VCPUOP_down blocks - until the CPU is brough back up. And which point
> we end up calling cpu_bringup - which sets up the clockevets, timers, etc.
>
> I am wondering if part of this is that the ts->inidle gets reset
> b/c we end up resetting all the timers but then when xen_play_dead
> exits, it ends up right back in the cpu_idle_loop() loop - and we
> call tick_nohz_idle_exit().
> 
> Thoughts?

cpu_dead() is definitely not expected to return after the cpu has been
declared dead. I should have put a big fat warning into the generic
idle loop for this :)

The reason why you get that warning only now is commit 4b0c0f294
(tick: Cleanup NOHZ per cpu data on cpu down), which is btw. targeted
for stable as well.

We can't revert the above commit as it fixes a long standing
nastiness, so for now until I come around to make the idle loop return
on cpu down you probably need to call tick_nohz_idle_enter() before
returning from play_dead().

Thanks,

	tglx



    

