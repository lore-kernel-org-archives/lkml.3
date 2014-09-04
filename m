Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbaIDUhb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 16:37:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38900 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbaIDUha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 16:37:30 -0400
Message-ID: <5408CD83.50904@canonical.com>
Date: Thu, 04 Sep 2014 15:37:23 -0500
From: Chris J Arges <chris.j.arges@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
CC: kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] KVM: x86: fix kvmclock breakage from timers branch merge
References: <1409835487-14371-1-git-send-email-pbonzini@redhat.com> <54088CB5.6050406@canonical.com> <54089DDE.6010004@redhat.com> <5408AC76.6030404@canonical.com> <5408BA6D.1070602@redhat.com> <5408C0B4.5040207@redhat.com>
In-Reply-To: <5408C0B4.5040207@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/04/2014 02:42 PM, Paolo Bonzini wrote:
> Il 04/09/2014 21:15, Paolo Bonzini ha scritto:
>> Il 04/09/2014 20:16, Chris J Arges ha scritto:
>>>> +	boot_ns = timespec_to_ns(&tk->total_sleep_time)
>>>> +		+ tk->wall_to_monotonic.tv_sec * (u64)NSEC_PER_SEC
>>>> +		+ tk->wall_to_monotonic.tv_nsec
>>>> +		+ tk->xtime_sec * (u64)NSEC_PER_SEC;
>>
>> So this means that the above 3.16-based code is not the same as
>>
>>         boot_ns = ktime_to_ns(ktime_add(tk->tkr.base_mono, tk->offs_boot));
>>
>> in 3.17.  Everything else in the patch you tested is the same as the
>> code that is in 3.17, so that's a start.
>>
>> Paolo
>>
> 
> Based on commit 02cba1598a2a3b689e79ad6dad2532521f638271 we have:
> 
>    offs_real - offs_boot = wall_to_monotonic + total_sleep_time
> 
> The patch I posted this morning separates tk->xtime_sec out of boot_ns, so
> all that is missing should be a change in boot_ns from base_mono + offs_boot
> to offs_real - offs_boot.
> 
> Chris, can you try this patch on top of the previous one:
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 92493e10937c..811eecc43fe8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1031,7 +1031,7 @@ static void update_pvclock_gtod(struct timekeeper *tk)
>  	struct pvclock_gtod_data *vdata = &pvclock_gtod_data;
>  	u64 boot_ns;
>  
> -	boot_ns = ktime_to_ns(ktime_add(tk->tkr.base_mono, tk->offs_boot));
> +	boot_ns = ktime_to_ns(ktime_sub(tk->offs_real, tk->offs_boot));
>  
>  	write_seqcount_begin(&vdata->seq);
> 
> If it doesn't work, then commit 02cba1598a2a3b689e79ad6dad2532521f638271
> is also broken.
> 
> Paolo
> 

Paolo,
That modification do your additional patch didn't work. However I was
able to modify the code as follows to get this test case working. The
only additional modification was:
+	vdata->nsec_base		= tk->xtime_sec * (u64)NSEC_PER_SEC
+					- boot_ns;

--chris j arges

--

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7b25aa2..60c0a9b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1023,8 +1023,8 @@ struct pvclock_gtod_data {
 		u32	shift;
 	} clock;

-	u64		boot_ns;
 	u64		nsec_base;
+	u64		snsec_base;
 };

 static struct pvclock_gtod_data pvclock_gtod_data;
@@ -1034,7 +1034,7 @@ static void update_pvclock_gtod(struct timekeeper *tk)
 	struct pvclock_gtod_data *vdata = &pvclock_gtod_data;
 	u64 boot_ns;

-	boot_ns = ktime_to_ns(ktime_add(tk->tkr.base_mono, tk->offs_boot));
+	boot_ns = ktime_to_ns(ktime_sub(tk->offs_real, tk->offs_boot));

 	write_seqcount_begin(&vdata->seq);

@@ -1045,8 +1045,9 @@ static void update_pvclock_gtod(struct timekeeper *tk)
 	vdata->clock.mult		= tk->tkr.mult;
 	vdata->clock.shift		= tk->tkr.shift;

-	vdata->boot_ns			= boot_ns;
-	vdata->nsec_base		= tk->tkr.xtime_nsec;
+	vdata->nsec_base		= tk->xtime_sec * (u64)NSEC_PER_SEC
+					- boot_ns;
+	vdata->snsec_base		= tk->tkr.xtime_nsec;

 	write_seqcount_end(&vdata->seq);
 }
@@ -1416,10 +1417,10 @@ static int do_monotonic_boot(s64 *t, cycle_t
*cycle_now)
 	do {
 		seq = read_seqcount_begin(&gtod->seq);
 		mode = gtod->clock.vclock_mode;
-		ns = gtod->nsec_base;
+		ns = gtod->snsec_base;
 		ns += vgettsc(cycle_now);
 		ns >>= gtod->clock.shift;
-		ns += gtod->boot_ns;
+		ns += gtod->nsec_base;
 	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
 	*t = ns;
