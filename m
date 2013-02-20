Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934977Ab3BTUq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:46:29 -0500
Received: from www.linutronix.de ([62.245.132.108]:42817 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758788Ab3BTUq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:46:28 -0500
Date: Wed, 20 Feb 2013 21:46:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Jones <davej@redhat.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, x86@kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Tang Chen <tangchen@cn.fujitsu.com>, Tony Luck <tony.luck@intel.com>
Subject: Re: odd GPF bug on resume from hibernate.
In-Reply-To: <20130220201348.GB3137@redhat.com>
Message-ID: <alpine.LFD.2.02.1302202130080.22263@ionos>
References: <20130220192826.GA3137@redhat.com> <11452407.3H88HXekKp@vostro.rjw.lan> <20130220201348.GB3137@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2013, Dave Jones wrote:

> On Wed, Feb 20, 2013 at 08:42:46PM +0100, Rafael J. Wysocki wrote:
>  > On Wednesday, February 20, 2013 02:28:26 PM Dave Jones wrote:
>  > > We had two users report hitting a bug that looks like this..
>  > > 
>  > > general protection fault: 8800 [#1] SMP 
>  > > 
>  > >    0:	ca 00 55             	lret   $0x5500
>  > > 
>  > > At this point I don't know where to begin debugging..
>  > > 
>  > > Is that 8800 error code a clue ?
>  > 
>  > Does CPU offline/online work on this machine?
> 
> I just asked the user to give that a try at https://bugzilla.redhat.com/show_bug.cgi?id=910162
> 
> Incidentally, I found that offlining a cpu in Linus' current tree
> causes a mess..
> 
> 
> numa_remove_cpu cpu 1 node 0: mask now 0,2-3
> smpboot: CPU 1 is now offline
> BUG: using smp_processor_id() in preemptible [00000000] code: bash/5976
> caller is cmci_rediscover+0x6b/0xe0
> Pid: 5976, comm: bash Not tainted 3.8.0-rc7+ #63
> Call Trace:
>  [<ffffffff812fb901>] debug_smp_processor_id+0xe1/0x100
>  [<ffffffff8101e4bb>] cmci_rediscover+0x6b/0xe0
>  [<ffffffff8158f55f>] mce_cpu_callback+0x1af/0x1c3
>  [<ffffffff815a6893>] notifier_call_chain+0x53/0xa0
>  [<ffffffff8107338e>] __raw_notifier_call_chain+0xe/0x10
>  [<ffffffff810491e0>] __cpu_notify+0x20/0x40
>  [<ffffffff81049215>] cpu_notify+0x15/0x20
>  [<ffffffff8104939e>] cpu_notify_nofail+0xe/0x20
>  [<ffffffff81588512>] _cpu_down+0x242/0x2b0
>  [<ffffffff815885b6>] cpu_down+0x36/0x50

That's caused by: commit 85b97637bb40a9f486459dd254598759af9c3d50

       x86/mce: Do not change worker's running cpu in cmci_rediscover().

mce_cpu_callback() does:

        if (action == CPU_POST_DEAD) {
                /* intentionally ignoring frozen here */
                cmci_rediscover(cpu);
        }

This is called from preemptible context.

Now cmci_rediscover() grew the following addon:

+   		      if (cpu == smp_processor_id()) {
+		      	      cmci_rediscover_work_func(NULL);
					continue;

Which causes the above splat. It seems testing with full debugging is
overrated.

Find the fix below, though it's debatable whether that "optimization"
of calling the function directly is worth the trouble.

Thanks,

	tglx

Index: linux-2.6/arch/x86/kernel/cpu/mcheck/mce_intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -311,10 +311,12 @@ void cmci_rediscover(int dying)
 		if (cpu == dying)
 			continue;
 
-		if (cpu == smp_processor_id()) {
+		if (cpu == get_cpu()) {
 			cmci_rediscover_work_func(NULL);
+			put_cpu();
 			continue;
 		}
+		put_cpu();
 
 		work_on_cpu(cpu, cmci_rediscover_work_func, NULL);
 	}
