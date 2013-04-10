Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759913Ab3DJTAK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 15:00:10 -0400
Received: from relay3.sgi.com ([192.48.152.1]:52836 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759008Ab3DJTAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 15:00:06 -0400
Date: Wed, 10 Apr 2013 14:00:03 -0500
From: Robin Holt <holt@sgi.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Robin Holt <holt@sgi.com>, Russ Anderson <rja@sgi.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] Do not force shutdown/reboot to boot cpu.
Message-ID: <20130410190003.GH3658@sgi.com>
References: <20130408155701.GB19974@gmail.com>
 <5162EC1A.4050204@zytor.com>
 <20130408165916.GA3672@sgi.com>
 <20130410111620.GB29752@gmail.com>
 <CA+55aFw8bRwMRm8cWtTGRvd1AEP-LR7pYL-pEoBkHqJUuJrjSg@mail.gmail.com>
 <20130410152911.GA3011@sgi.com>
 <20130410165934.GB21951@gmail.com>
 <20130410171420.GF3658@sgi.com>
 <20130410172236.GE21951@gmail.com>
 <20130410175519.GG3658@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410175519.GG3658@sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I'm proposing to make 'reboot' overhead profilable, via a debug hack:
> > 
> >         echo 1 > /proc/sys/kernel/magic_dont_fully_reboot_flag
> > 
> > 	perf record reboot
> > 
> > perf is using NMIs to profile - and since much of cpu_down() is with irqs 
> > disabled, NMI profiling would be needed to see inside the overhead.
> > 
> > (Assuming the 240 msecs is CPU overhead, not waiting for some IRQ/IPI event.)


I had the machine booted as 512 cpus.
I tweaked the kernel like this:

diff --git a/kernel/sys.c b/kernel/sys.c
index 39c9c4a..b42bd4f 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -368,8 +368,10 @@ EXPORT_SYMBOL(unregister_reboot_notifier);
  */
 void kernel_restart(char *cmd)
 {
-       kernel_restart_prepare(cmd);
+       // kernel_restart_prepare(cmd);
        disable_nonboot_cpus();
+       enable_nonboot_cpus();
+       return;
        if (!cmd)
                printk(KERN_EMERG "Restarting system.\n");
        else

perf record -a /sbin/reboot -d -f -n

The top of 'perf report' has:
Events: 14M cycles
    22.58%          swapper  [kernel.kallsyms]           [k] update_cfs_rq_blocked_load
    10.52%          swapper  [kernel.kallsyms]           [k] load_balance
     4.96%          swapper  [kernel.kallsyms]           [k] ktime_get
     4.12%          swapper  [kernel.kallsyms]           [k] update_blocked_averages
     3.55%          swapper  [kernel.kallsyms]           [k] idle_cpu
     1.97%          swapper  [kernel.kallsyms]           [k] uv_read_rtc
     0.98%          swapper  [kernel.kallsyms]           [k] rcu_process_gp_end
     0.84%          swapper  [kernel.kallsyms]           [k] apic_timer_interrupt
     0.84%          swapper  [kernel.kallsyms]           [k] __lock_text_start
     0.84%          swapper  [kernel.kallsyms]           [k] _raw_spin_lock_irqsave
     0.73%          swapper  [kernel.kallsyms]           [k] native_safe_halt
     0.56%          swapper  [kernel.kallsyms]           [k] rcu_check_callbacks
     0.56%          swapper  [kernel.kallsyms]           [k] native_write_msr_safe
     0.44%          swapper  [kernel.kallsyms]           [k] cpumask_next_and
     0.42%           reboot  [kernel.kallsyms]           [k] kmem_cache_alloc_node

The perf data is 676 MB.  I don't know how well it compresses, but the
lzma task has been running for a while.

Thanks,
Robin
