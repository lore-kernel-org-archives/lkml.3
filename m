Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbbADUDJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 15:03:09 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:36434 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbbADUDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 15:03:07 -0500
Date: Sun, 4 Jan 2015 15:03:02 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Pavel Machek <pavel@ucw.cz>
cc: marc.zyngier@arm.com, rmk+kernel@arm.linux.org.uk,
        Linus Torvalds <torvalds@linux-foundation.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
In-Reply-To: <20150104190123.GA20153@amd>
Message-ID: <alpine.LFD.2.11.1501041438130.18844@knanqh.ubzr>
References: <20150104190123.GA20153@amd>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Jan 2015, Pavel Machek wrote:

> 9fc2105aeaaf56b0cf75296a84702d0f9e64437b breaks audio in python, and
> probably elsewhere, with message
> 
> FATAL: cannot locate cpu MHz in /proc/cpuinfo
> 
> I'm not the first one to hit it, see for example
> 
> https://theredblacktree.wordpress.com/2014/08/10/fatal-cannot-locate-cpu-mhz-in-proccpuinfo/
> https://devtalk.nvidia.com/default/topic/765800/workaround-for-fatal-cannot-locate-cpu-mhz-in-proc-cpuinf/?offset=1
> 
> Reading original changelog, I have to say "Stop breaking working
> setups. You know who you are!".
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>

NAK.

No setups actually relying on this completely fony bogomips value 
bearing no links to hardware reality coule have been qualified as 
"working".

The bogomips entry was removed from /proc/cpuinfo in 2013.  We're now in 
2015.  You're apparently the first to suggest moving the kernel back to 
providing random values via /proc/cpuinfo.  So this removal must not 
have inconvenienced that many people in the end.

Broken applications appear to have been fixed already as mentioned via 
those links you provided above.  So if you want a working setup, you may 
stick with a kernel of the same vintage as your user space apps or 
update the later.

If that is still unacceptable to you for whatever reason, then the least 
wrong compromize should be:

	seq_printf(m, "BogoMIPS\t: 1.00\n");

That'D allow for those broken applications to run while making clear 
that the provided value is phony. I was about to suggest 0.00 but that 
could trigger a divide by zero error somewhere I suppose.


> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> index ff6760a..940779c 100644
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -1048,6 +1048,15 @@ static int c_show(struct seq_file *m, void *v)
>  		seq_printf(m, "model name\t: %s rev %d (%s)\n",
>  			   cpu_name, cpuid & 15, elf_platform);
>  
> +#if defined(CONFIG_SMP)
> +		seq_printf(m, "BogoMIPS\t: %lu.%02lu\n",
> +			   per_cpu(cpu_data, i).loops_per_jiffy / (500000UL/HZ),
> +			   (per_cpu(cpu_data, i).loops_per_jiffy / (5000UL/HZ)) % 100);
> +#else
> +		seq_printf(m, "BogoMIPS\t: %lu.%02lu\n",
> +			   loops_per_jiffy / (500000/HZ),
> +			   (loops_per_jiffy / (5000/HZ)) % 100);
> +#endif
>  		/* dump out the processor features */
>  		seq_puts(m, "Features\t: ");
>  
> diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> index 5e6052e..86ef244 100644
> --- a/arch/arm/kernel/smp.c
> +++ b/arch/arm/kernel/smp.c
> @@ -387,6 +387,18 @@ asmlinkage void secondary_start_kernel(void)
>  
>  void __init smp_cpus_done(unsigned int max_cpus)
>  {
> +	int cpu;
> +	unsigned long bogosum = 0;
> +
> +	for_each_online_cpu(cpu)
> +		bogosum += per_cpu(cpu_data, cpu).loops_per_jiffy;
> +
> +	printk(KERN_INFO "SMP: Total of %d processors activated "
> +	       "(%lu.%02lu BogoMIPS).\n",
> +	       num_online_cpus(),
> +	       bogosum / (500000/HZ),
> +	       (bogosum / (5000/HZ)) % 100);
> +
>  	hyp_mode_check();
>  }
>  
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> 
> 
