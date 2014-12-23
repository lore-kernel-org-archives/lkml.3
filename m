Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247AbaLWPMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 10:12:00 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:31325 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862AbaLWPL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 10:11:59 -0500
Message-ID: <549986B8.3030606@oracle.com>
Date: Tue, 23 Dec 2014 10:14:00 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [Xen-devel] [RFC 2/2] x86, vdso, pvclock: Simplify and speed
 up the vdso pvclock reader
References: <cover.1419295081.git.luto@amacapital.net> <8d09c16eb39cbe264417cc66c4aca730af10b70b.1419295081.git.luto@amacapital.net>
In-Reply-To: <8d09c16eb39cbe264417cc66c4aca730af10b70b.1419295081.git.luto@amacapital.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2014 07:39 PM, Andy Lutomirski wrote:
> The pvclock vdso code was too abstracted to understand easily and
> excessively paranoid.  Simplify it for a huge speedup.
>
> This opens the door for additional simplifications, as the vdso no
> longer accesses the pvti for any vcpu other than vcpu 0.
>
> Before, vclock_gettime using kvm-clock took about 64ns on my machine.
> With this change, it takes 19ns, which is almost as fast as the pure TSC
> implementation.
>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>   arch/x86/vdso/vclock_gettime.c | 82 ++++++++++++++++++++++++------------------
>   1 file changed, 47 insertions(+), 35 deletions(-)
>
> diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
> index 9793322751e0..f2e0396d5629 100644
> --- a/arch/x86/vdso/vclock_gettime.c
> +++ b/arch/x86/vdso/vclock_gettime.c
> @@ -78,47 +78,59 @@ static notrace const struct pvclock_vsyscall_time_info *get_pvti(int cpu)
>   
>   static notrace cycle_t vread_pvclock(int *mode)
>   {
> -	const struct pvclock_vsyscall_time_info *pvti;
> +	const struct pvclock_vcpu_time_info *pvti = &get_pvti(0)->pvti;
>   	cycle_t ret;
> -	u64 last;
> -	u32 version;
> -	u8 flags;
> -	unsigned cpu, cpu1;
> -
> +	u64 tsc, pvti_tsc;
> +	u64 last, delta, pvti_system_time;
> +	u32 version, pvti_tsc_to_system_mul, pvti_tsc_shift;
>   
>   	/*
> -	 * Note: hypervisor must guarantee that:
> -	 * 1. cpu ID number maps 1:1 to per-CPU pvclock time info.
> -	 * 2. that per-CPU pvclock time info is updated if the
> -	 *    underlying CPU changes.
> -	 * 3. that version is increased whenever underlying CPU
> -	 *    changes.
> +	 * Note: The kernel and hypervisor must guarantee that cpu ID
> +	 * number maps 1:1 to per-CPU pvclock time info.
> +	 *
> +	 * Because the hypervisor is entirely unaware of guest userspace
> +	 * preemption, it cannot guarantee that per-CPU pvclock time
> +	 * info is updated if the underlying CPU changes or that that
> +	 * version is increased whenever underlying CPU changes.
> +	 *
> +	 * On KVM, we are guaranteed that pvti updates for any vCPU are
> +	 * atomic as seen by *all* vCPUs.  This is an even stronger
> +	 * guarantee than we get with a normal seqlock.
>   	 *
> +	 * On Xen, we don't appear to have that guarantee, but Xen still
> +	 * supplies a valid seqlock using the version field.
> +
> +	 * We only do pvclock vdso timing at all if
> +	 * PVCLOCK_TSC_STABLE_BIT is set, and we interpret that bit to
> +	 * mean that all vCPUs have matching pvti and that the TSC is
> +	 * synced, so we can just look at vCPU 0's pvti.
>   	 */
> -	do {
> -		cpu = __getcpu() & VGETCPU_CPU_MASK;
> -		/* TODO: We can put vcpu id into higher bits of pvti.version.
> -		 * This will save a couple of cycles by getting rid of
> -		 * __getcpu() calls (Gleb).
> -		 */
> -
> -		pvti = get_pvti(cpu);
> -
> -		version = __pvclock_read_cycles(&pvti->pvti, &ret, &flags);
> -
> -		/*
> -		 * Test we're still on the cpu as well as the version.
> -		 * We could have been migrated just after the first
> -		 * vgetcpu but before fetching the version, so we
> -		 * wouldn't notice a version change.
> -		 */
> -		cpu1 = __getcpu() & VGETCPU_CPU_MASK;
> -	} while (unlikely(cpu != cpu1 ||
> -			  (pvti->pvti.version & 1) ||
> -			  pvti->pvti.version != version));
> -
> -	if (unlikely(!(flags & PVCLOCK_TSC_STABLE_BIT)))
> +
> +	if (unlikely(!(pvti->flags & PVCLOCK_TSC_STABLE_BIT))) {
>   		*mode = VCLOCK_NONE;
> +		return 0;
> +	}
> +
> +	do {
> +		version = pvti->version;
> +
> +		/* This is also a read barrier, so we'll read version first. */
> +		rdtsc_barrier();
> +		tsc = __native_read_tsc();


This will cause VMEXIT on Xen with TSC_MODE_ALWAYS_EMULATE which is 
used, for example, after guest migrated (unless HW is capable of scaling 
TSC rate).

-boris


> +
> +		pvti_tsc_to_system_mul = pvti->tsc_to_system_mul;
> +		pvti_tsc_shift = pvti->tsc_shift;
> +		pvti_system_time = pvti->system_time;
> +		pvti_tsc = pvti->tsc_timestamp;
> +
> +		/* Make sure that the version double-check is last. */
> +		smp_rmb();
> +	} while (unlikely((version & 1) || version != pvti->version));
> +
> +	delta = tsc - pvti_tsc;
> +	ret = pvti_system_time +
> +		pvclock_scale_delta(delta, pvti_tsc_to_system_mul,
> +				    pvti_tsc_shift);
>   
>   	/* refer to tsc.c read_tsc() comment for rationale */
>   	last = gtod->cycle_last;

