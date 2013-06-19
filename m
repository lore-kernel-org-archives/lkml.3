Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934671Ab3FSNFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 09:05:34 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:58861 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933869Ab3FSNFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 09:05:32 -0400
Message-ID: <51C1AC93.6010001@redhat.com>
Date: Wed, 19 Jun 2013 15:05:23 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Eugene Batalov <ebatalov@parallels.com>, kvm@vger.kernel.org,
        imammedo@redhat.com, linux-kernel@vger.kernel.org,
        eabatalov89@gmail.com
Subject: Re: [PATCHv1] kvm guest: fix uninitialized kvmclock read by KVM guest
References: <20130610201933.GA31409@amt.cnet> <1371319305-590-1-git-send-email-ebatalov@parallels.com> <20130618222114.GC13856@amt.cnet>
In-Reply-To: <20130618222114.GC13856@amt.cnet>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/06/2013 00:21, Marcelo Tosatti ha scritto:
> On Sat, Jun 15, 2013 at 10:01:45PM +0400, Eugene Batalov wrote:
>> Due to unintialized kvmclock read KVM guest is hanging on SMP boot stage.
>> If unintialized memory contains fatal garbage then hang reproduction is 100%.
>> Unintialized memory is allocated by memblock_alloc. So the garbage values
>> depend on many many things.
>>
>> See the detailed description of the bug and possible ways to fix it
>> in the kernel bug tracker.
>> "Bug 59521 - KVM linux guest reads uninitialized pvclock values before
>> executing rdmsr MSR_KVM_WALL_CLOCK"
>>
>> I decided to fix it simply returning 0ULL from kvm_clock_read when
>> kvm clocksource is not initialized yet.
>> The same as kernel bootstrap CPU doesn on boot stage when kernel
>> clocksources are not initialized yet.
>>
>> Signed-off-by: Eugene Batalov <ebatalov@parallels.com>
>> ---
>> I dont' use kernel percpu variables because for each SMP CPU
>> their contents are copied from the bootstrap CPU. And I don't
>> think that fixing the value for each SMP CPU is a good style.
>> If you know a better approach to store the is_pv_clock_ready flags
>> I am ready to use it.
>>
>> The patch applies cleanly to
>> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>>
>> I've tested the changes with Ubuntu 13.04 "raring" userspace and
>> Ubuntu-3.8.0.19-30 kernel tag.
>>
>>  arch/x86/kernel/kvmclock.c |   13 +++++++++++--
>>  1 file changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
>> index 5bedbdd..a6e0af4 100644
>> --- a/arch/x86/kernel/kvmclock.c
>> +++ b/arch/x86/kernel/kvmclock.c
>> @@ -43,6 +43,9 @@ early_param("no-kvmclock", parse_no_kvmclock);
>>  static struct pvclock_vsyscall_time_info *hv_clock;
>>  static struct pvclock_wall_clock wall_clock;
>>  
>> +/* For each cpu store here a flag which tells whether pvclock is initialized */
>> +static int __cacheline_aligned_in_smp is_pv_clock_ready[NR_CPUS] = {};
>> +
>>  /*
>>   * The wallclock is the time of day when we booted. Since then, some time may
>>   * have elapsed since the hypervisor wrote the data. So we try to account for
>> @@ -84,8 +87,11 @@ static cycle_t kvm_clock_read(void)
>>  
>>  	preempt_disable_notrace();
>>  	cpu = smp_processor_id();
>> -	src = &hv_clock[cpu].pvti;
>> -	ret = pvclock_clocksource_read(src);
>> +	if (is_pv_clock_ready[cpu]) {
>> +		src = &hv_clock[cpu].pvti;
>> +		ret = pvclock_clocksource_read(src);
>> +	} else
>> +		ret = 0ULL;
>>  	preempt_enable_notrace();
>>  	return ret;
>>  }
>> @@ -168,6 +174,9 @@ int kvm_register_clock(char *txt)
>>  	printk(KERN_INFO "kvm-clock: cpu %d, msr %x:%x, %s\n",
>>  	       cpu, high, low, txt);
>>  
>> +	if (!ret)
>> +		is_pv_clock_ready[cpu] = 1;
>> +
>>  	return ret;
>>  }
> 
> The path can be really hot, so better avoid it if possible. The patch
> to zero the memblock_alloc'd area from Igor brings the behaviour back
> to before regression: return 0 until kvmclock is initialized. On top of
> your analysis in the BZ, it now seems the right (and safer) thing to do.

Yeah, definitely safer for master and stable.  I'm applying that to master.

But if we can invert cpu_init with early_clock_percpu_init, it would be
nicer to do that for 3.11.

Paolo
