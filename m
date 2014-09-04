Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbaIDSQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 14:16:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38302 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbaIDSQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 14:16:27 -0400
Message-ID: <5408AC76.6030404@canonical.com>
Date: Thu, 04 Sep 2014 13:16:22 -0500
From: Chris J Arges <chris.j.arges@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
CC: kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] KVM: x86: fix kvmclock breakage from timers branch merge
References: <1409835487-14371-1-git-send-email-pbonzini@redhat.com> <54088CB5.6050406@canonical.com> <54089DDE.6010004@redhat.com>
In-Reply-To: <54089DDE.6010004@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/04/2014 12:14 PM, Paolo Bonzini wrote:
> Il 04/09/2014 18:00, Chris J Arges ha scritto:
>> Uptime:
>>  15:58:02 up  1:00,  1 user,  load average: 0.59, 0.60, 0.31
>>
>> Here is the output:
>>
>> ./x86-run x86/kvmclock_test.flat -smp 2 --append "10000000 `date +%s`"
>> qemu-system-x86_64 -enable-kvm -device pc-testdev -device
>> isa-debug-exit,iobase=0xf4,iosize=0x4 -display none -serial stdio
>> -device pci-testdev -kernel x86/kvmclock_test.flat -smp 2 --append
>> 10000000 1409846210
>> enabling apic
>> enabling apic
>> kvm-clock: cpu 0, msr 0x:44d4c0
>> kvm-clock: cpu 0, msr 0x:44d4c0
>> Wallclock test, threshold 5
>> Seconds get from host:     1409846210
>> Seconds get from kvmclock: 2819688866
>> Offset:                    1409842656
> 
> With kvm/queue this would have been roughly -3600, now it's 
> host_wallclock-3600.  So the patch hasn't fixed the -3600 part for you.
> 
> Can you try applying this patch on top of 3.16?  This is my backport of
> Thomas's patch.  If this works for you, we "only" have to find out how
> to compute boot_ns and nsec_base in the new timekeeping world order of
> 3.17...

Paolo,
The patch below applied to 3.16 still allows the testcase to pass on my
hardware.
--chris

> 
> Thomas, do you have any ideas?  Every time a VM is started, the kvmclock
> starts at the boot time of the host, instead of the current wallclock time.
> 
> Paolo
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d38abc81db65..70de23f1de51 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1020,9 +1020,8 @@ struct pvclock_gtod_data {
>  		u32	shift;
>  	} clock;
>  
> -	/* open coded 'struct timespec' */
> -	u64		monotonic_time_snsec;
> -	time_t		monotonic_time_sec;
> +	u64		boot_ns;
> +	u64		nsec_base;
>  };
>  
>  static struct pvclock_gtod_data pvclock_gtod_data;
> @@ -1030,6 +1029,12 @@ static struct pvclock_gtod_data pvclock_gtod_data;
>  static void update_pvclock_gtod(struct timekeeper *tk)
>  {
>  	struct pvclock_gtod_data *vdata = &pvclock_gtod_data;
> +	u64 boot_ns;
> +
> +	boot_ns = timespec_to_ns(&tk->total_sleep_time)
> +		+ tk->wall_to_monotonic.tv_sec * (u64)NSEC_PER_SEC
> +		+ tk->wall_to_monotonic.tv_nsec
> +		+ tk->xtime_sec * (u64)NSEC_PER_SEC;
>  
>  	write_seqcount_begin(&vdata->seq);
>  
> @@ -1040,17 +1044,8 @@ static void update_pvclock_gtod(struct timekeeper *tk)
>  	vdata->clock.mult		= tk->mult;
>  	vdata->clock.shift		= tk->shift;
>  
> -	vdata->monotonic_time_sec	= tk->xtime_sec
> -					+ tk->wall_to_monotonic.tv_sec;
> -	vdata->monotonic_time_snsec	= tk->xtime_nsec
> -					+ (tk->wall_to_monotonic.tv_nsec
> -						<< tk->shift);
> -	while (vdata->monotonic_time_snsec >=
> -					(((u64)NSEC_PER_SEC) << tk->shift)) {
> -		vdata->monotonic_time_snsec -=
> -					((u64)NSEC_PER_SEC) << tk->shift;
> -		vdata->monotonic_time_sec++;
> -	}
> +	vdata->boot_ns                  = boot_ns;
> +	vdata->nsec_base		= tk->xtime_nsec;
>  
>  	write_seqcount_end(&vdata->seq);
>  }
> @@ -1414,23 +1409,22 @@ static inline u64 vgettsc(cycle_t *cycle_now)
>  	return v * gtod->clock.mult;
>  }
>  
> -static int do_monotonic(struct timespec *ts, cycle_t *cycle_now)
> +static int do_monotonic_boot(s64 *t, cycle_t *cycle_now)
>  {
> +	struct pvclock_gtod_data *gtod = &pvclock_gtod_data;
>  	unsigned long seq;
> -	u64 ns;
>  	int mode;
> -	struct pvclock_gtod_data *gtod = &pvclock_gtod_data;
> +	u64 ns;
>  
> -	ts->tv_nsec = 0;
>  	do {
>  		seq = read_seqcount_begin(&gtod->seq);
>  		mode = gtod->clock.vclock_mode;
> -		ts->tv_sec = gtod->monotonic_time_sec;
> -		ns = gtod->monotonic_time_snsec;
> +		ns = gtod->nsec_base;
>  		ns += vgettsc(cycle_now);
>  		ns >>= gtod->clock.shift;
> +		ns += gtod->boot_ns;
>  	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
> -	timespec_add_ns(ts, ns);
> +	*t = ns;
>  
>  	return mode;
>  }
> @@ -1438,19 +1432,11 @@ static int do_monotonic(struct timespec *ts, cycle_t *cycle_now)
>  /* returns true if host is using tsc clocksource */
>  static bool kvm_get_time_and_clockread(s64 *kernel_ns, cycle_t *cycle_now)
>  {
> -	struct timespec ts;
> -
>  	/* checked again under seqlock below */
>  	if (pvclock_gtod_data.clock.vclock_mode != VCLOCK_TSC)
>  		return false;
>  
> -	if (do_monotonic(&ts, cycle_now) != VCLOCK_TSC)
> -		return false;
> -
> -	monotonic_to_bootbased(&ts);
> -	*kernel_ns = timespec_to_ns(&ts);
> -
> -	return true;
> +	return do_monotonic_boot(kernel_ns, cycle_now) == VCLOCK_TSC;
>  }
>  #endif
>  
> 
> 
>> My observation is that the kvmclock value seems to be positively biased
>> by the boot_ns value.
> 
