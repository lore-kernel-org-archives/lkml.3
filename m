Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbaIDQBB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:01:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37640 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaIDQA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:00:59 -0400
Message-ID: <54088CB5.6050406@canonical.com>
Date: Thu, 04 Sep 2014 11:00:53 -0500
From: Chris J Arges <chris.j.arges@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
CC: kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] KVM: x86: fix kvmclock breakage from timers branch merge
References: <1409835487-14371-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1409835487-14371-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/04/2014 07:58 AM, Paolo Bonzini wrote:
> Commit cbcf2dd3b3d4 (x86: kvm: Make kvm_get_time_and_clockread() nanoseconds
> based, 2014-07-16) forgot to add tk->xtime_sec, thus breaking kvmclock on
> hosts that have a reliable TSC.  Add it back; and since the field boot_ns
> is not anymore related to the host boot-based clock, rename boot_ns->nsec_base
> and the existing nsec_base->snsec_base.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: John Stultz <john.stultz@linaro.org>
> Reported-by: Chris J Arges <chris.j.arges@canonical.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8f1e22d3b286..92493e10937c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1020,8 +1020,8 @@ struct pvclock_gtod_data {
>  		u32	shift;
>  	} clock;
>  
> -	u64		boot_ns;
>  	u64		nsec_base;
> +	u64		snsec_base;
>  };
>  
>  static struct pvclock_gtod_data pvclock_gtod_data;
> @@ -1042,8 +1042,9 @@ static void update_pvclock_gtod(struct timekeeper *tk)
>  	vdata->clock.mult		= tk->tkr.mult;
>  	vdata->clock.shift		= tk->tkr.shift;
>  
> -	vdata->boot_ns			= boot_ns;
> -	vdata->nsec_base		= tk->tkr.xtime_nsec;
> +	vdata->nsec_base		= tk->xtime_sec * (u64)NSEC_PER_SEC
> +					+ boot_ns;
> +	vdata->snsec_base		= tk->tkr.xtime_nsec;
>  
>  	write_seqcount_end(&vdata->seq);
>  }
> @@ -1413,10 +1414,10 @@ static int do_monotonic_boot(s64 *t, cycle_t *cycle_now)
>  	do {
>  		seq = read_seqcount_begin(&gtod->seq);
>  		mode = gtod->clock.vclock_mode;
> -		ns = gtod->nsec_base;
> +		ns = gtod->snsec_base;
>  		ns += vgettsc(cycle_now);
>  		ns >>= gtod->clock.shift;
> -		ns += gtod->boot_ns;
> +		ns += gtod->nsec_base;
>  	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
>  	*t = ns;
>  
> 

Paulo,
I've tested with the above patch and I still have issues with the
kvmclock test offset; however the cycle tests pass now.

Here is trace data:
http://people.canonical.com/~arges/kvm/trace-4.dat.xz

Uptime:
 15:58:02 up  1:00,  1 user,  load average: 0.59, 0.60, 0.31

Here is the output:

./x86-run x86/kvmclock_test.flat -smp 2 --append "10000000 `date +%s`"
qemu-system-x86_64 -enable-kvm -device pc-testdev -device
isa-debug-exit,iobase=0xf4,iosize=0x4 -display none -serial stdio
-device pci-testdev -kernel x86/kvmclock_test.flat -smp 2 --append
10000000 1409846210
enabling apic
enabling apic
kvm-clock: cpu 0, msr 0x:44d4c0
kvm-clock: cpu 0, msr 0x:44d4c0
Wallclock test, threshold 5
Seconds get from host:     1409846210
Seconds get from kvmclock: 2819688866
Offset:                    1409842656
offset too large!
Check the stability of raw cycle ...
Total vcpus: 2
Test  loops: 10000000
Total warps:  0
Total stalls: 0
Worst warp:   0
Raw cycle is stable
Monotonic cycle test:
Total vcpus: 2
Test  loops: 10000000
Total warps:  0
Total stalls: 0
Worst warp:   0
Measure the performance of raw cycle ...
Total vcpus: 2
Test  loops: 10000000
TSC cycles:  1139288710
Measure the performance of adjusted cycle ...
Total vcpus: 2
Test  loops: 10000000
TSC cycles:  1138643774
Return value from qemu: 3

My observation is that the kvmclock value seems to be positively biased
by the boot_ns value.

--chris j arges
