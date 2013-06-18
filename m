Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933759Ab3FRWWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 18:22:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755322Ab3FRWVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 18:21:51 -0400
Date: Tue, 18 Jun 2013 19:21:15 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Eugene Batalov <ebatalov@parallels.com>
Cc: kvm@vger.kernel.org, imammedo@redhat.com, linux-kernel@vger.kernel.org,
        eabatalov89@gmail.com
Subject: Re: [PATCHv1] kvm guest: fix uninitialized kvmclock read by KVM guest
Message-ID: <20130618222114.GC13856@amt.cnet>
References: <20130610201933.GA31409@amt.cnet>
 <1371319305-590-1-git-send-email-ebatalov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371319305-590-1-git-send-email-ebatalov@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 15, 2013 at 10:01:45PM +0400, Eugene Batalov wrote:
> Due to unintialized kvmclock read KVM guest is hanging on SMP boot stage.
> If unintialized memory contains fatal garbage then hang reproduction is 100%.
> Unintialized memory is allocated by memblock_alloc. So the garbage values
> depend on many many things.
> 
> See the detailed description of the bug and possible ways to fix it
> in the kernel bug tracker.
> "Bug 59521 - KVM linux guest reads uninitialized pvclock values before
> executing rdmsr MSR_KVM_WALL_CLOCK"
> 
> I decided to fix it simply returning 0ULL from kvm_clock_read when
> kvm clocksource is not initialized yet.
> The same as kernel bootstrap CPU doesn on boot stage when kernel
> clocksources are not initialized yet.
> 
> Signed-off-by: Eugene Batalov <ebatalov@parallels.com>
> ---
> I dont' use kernel percpu variables because for each SMP CPU
> their contents are copied from the bootstrap CPU. And I don't
> think that fixing the value for each SMP CPU is a good style.
> If you know a better approach to store the is_pv_clock_ready flags
> I am ready to use it.
> 
> The patch applies cleanly to
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> 
> I've tested the changes with Ubuntu 13.04 "raring" userspace and
> Ubuntu-3.8.0.19-30 kernel tag.
> 
>  arch/x86/kernel/kvmclock.c |   13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index 5bedbdd..a6e0af4 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -43,6 +43,9 @@ early_param("no-kvmclock", parse_no_kvmclock);
>  static struct pvclock_vsyscall_time_info *hv_clock;
>  static struct pvclock_wall_clock wall_clock;
>  
> +/* For each cpu store here a flag which tells whether pvclock is initialized */
> +static int __cacheline_aligned_in_smp is_pv_clock_ready[NR_CPUS] = {};
> +
>  /*
>   * The wallclock is the time of day when we booted. Since then, some time may
>   * have elapsed since the hypervisor wrote the data. So we try to account for
> @@ -84,8 +87,11 @@ static cycle_t kvm_clock_read(void)
>  
>  	preempt_disable_notrace();
>  	cpu = smp_processor_id();
> -	src = &hv_clock[cpu].pvti;
> -	ret = pvclock_clocksource_read(src);
> +	if (is_pv_clock_ready[cpu]) {
> +		src = &hv_clock[cpu].pvti;
> +		ret = pvclock_clocksource_read(src);
> +	} else
> +		ret = 0ULL;
>  	preempt_enable_notrace();
>  	return ret;
>  }
> @@ -168,6 +174,9 @@ int kvm_register_clock(char *txt)
>  	printk(KERN_INFO "kvm-clock: cpu %d, msr %x:%x, %s\n",
>  	       cpu, high, low, txt);
>  
> +	if (!ret)
> +		is_pv_clock_ready[cpu] = 1;
> +
>  	return ret;
>  }

The path can be really hot, so better avoid it if possible. The patch
to zero the memblock_alloc'd area from Igor brings the behaviour back
to before regression: return 0 until kvmclock is initialized. On top of
your analysis in the BZ, it now seems the right (and safer) thing to do.


