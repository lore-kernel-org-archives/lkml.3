Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab3JCR7E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 13:59:04 -0400
Received: from relay3.sgi.com ([192.48.152.1]:36689 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754249Ab3JCR7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 13:59:02 -0400
Message-ID: <524DB05F.3030906@sgi.com>
Date: Thu, 03 Oct 2013 10:58:55 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Jason Wessel <jason.wessel@windriver.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dimitri Sivanich <sivanich@sgi.com>, Hedi Berriche <hedi@sgi.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] PATCH: KGDB/KDB Fix no KDB config problem.
References: <20131003163824.966169920@asylum.americas.sgi.com> <20131003163825.184494258@asylum.americas.sgi.com> <20131003165122.GB32755@gmail.com> <524DA381.2050108@sgi.com> <20131003171520.GA5144@gmail.com> <524DAF17.8040104@sgi.com>
In-Reply-To: <524DAF17.8040104@sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/3/2013 10:53 AM, Mike Travis wrote:
> 
> 
> On 10/3/2013 10:15 AM, Ingo Molnar wrote:
>>
>> * Mike Travis <travis@sgi.com> wrote:
>>
>>>
>>>
>>> On 10/3/2013 9:51 AM, Ingo Molnar wrote:
>>>>
>>>> * Mike Travis <travis@sgi.com> wrote:
>>>>
>>>>> Some code added to the debug_core module had KDB dependencies
>>>>> that it shouldn't have.
>>>>>
>>>>> Signed-off-by: Mike Travis <travis@sgi.com>
>>>>> ---
>>>>>  kernel/debug/debug_core.c |    8 ++++----
>>>>>  kernel/debug/debug_core.h |    2 ++
>>>>>  2 files changed, 6 insertions(+), 4 deletions(-)
>>>>>
>>>>> --- linux.orig/kernel/debug/debug_core.c
>>>>> +++ linux/kernel/debug/debug_core.c
>>>>> @@ -575,8 +575,8 @@ return_normal:
>>>>>  		raw_spin_lock(&dbg_slave_lock);
>>>>>  
>>>>>  #ifdef CONFIG_SMP
>>>>> -	/* If SYSTEM_NMI, slaves are already waiting */
>>>>> -	if (ks->err_code == KDB_REASON_SYSTEM_NMI)
>>>>> +	/* If send_ready set, slaves are already waiting */
>>>>> +	if (ks->send_ready)
>>>>>  		atomic_set(ks->send_ready, 1);
>>>>>  
>>>>>  	/* Signal the other CPUs to enter kgdb_wait() */
>>>>> @@ -682,11 +682,11 @@ kgdb_handle_exception(int evector, int s
>>>>>  	if (arch_kgdb_ops.enable_nmi)
>>>>>  		arch_kgdb_ops.enable_nmi(0);
>>>>>  
>>>>> +	memset(ks, 0, sizeof(struct kgdb_state));
>>>>>  	ks->cpu			= raw_smp_processor_id();
>>>>>  	ks->ex_vector		= evector;
>>>>>  	ks->signo		= signo;
>>>>>  	ks->err_code		= ecode;
>>>>> -	ks->kgdb_usethreadid	= 0;
>>>>>  	ks->linux_regs		= regs;
>>>>>  
>>>>>  	if (kgdb_reenter_check(ks))
>>>>> @@ -750,7 +750,7 @@ int kgdb_nmicallin(int cpu, int trapnr,
>>>>>  		ks->cpu			= cpu;
>>>>>  		ks->ex_vector		= trapnr;
>>>>>  		ks->signo		= SIGTRAP;
>>>>> -		ks->err_code		= KDB_REASON_SYSTEM_NMI;
>>>>> +		ks->err_code		= KGDB_KDB_REASON_SYSTEM_NMI;
>>>>>  		ks->linux_regs		= regs;
>>>>>  		ks->send_ready		= send_ready;
>>>>>  		kgdb_cpu_enter(ks, regs, DCPU_WANT_MASTER);
>>>>> --- linux.orig/kernel/debug/debug_core.h
>>>>> +++ linux/kernel/debug/debug_core.h
>>>>> @@ -75,11 +75,13 @@ extern int kdb_stub(struct kgdb_state *k
>>>>>  extern int kdb_parse(const char *cmdstr);
>>>>>  extern int kdb_common_init_state(struct kgdb_state *ks);
>>>>>  extern int kdb_common_deinit_state(void);
>>>>> +#define KGDB_KDB_REASON_SYSTEM_NMI KDB_REASON_SYSTEM_NMI
>>>>>  #else /* ! CONFIG_KGDB_KDB */
>>>>>  static inline int kdb_stub(struct kgdb_state *ks)
>>>>>  {
>>>>>  	return DBG_PASS_EVENT;
>>>>>  }
>>>>> +#define KGDB_KDB_REASON_SYSTEM_NMI 0
>>>>>  #endif /* CONFIG_KGDB_KDB */
>>>>>  
>>>>>  #endif /* _DEBUG_CORE_H_ */
>>>>
>>>> Hm, the KGDB_KDB_REASON_SYSTEM_NMI definition is a bit ugly. I still think 
>>>> there are layering violations here and just kludging it around doesn't 
>>>> solve it - a helper function that keeps kgdb details to the kgdb code 
>>>> would.
>>>>
>>>> Anyway, if Jason is fine with this solution and upholds his Acked-by then 
>>>> I'll merge this into the first patch and apply the two patches.
>>>>
>>>> Thanks,
>>>>
>>>> 	Ingo
>>>>
>>>
>>> Would you prefer a simple #ifdef CONFIG_KGDB_KDB around the assignment?
>>
>> An #ifdef doesn't solve the layering violation!
>>
>> kernel/debug/debug_core.c didn't have any serious use of #ifdef 
>> CONFIG_KGDB_KDB before (it used it to flavor a few printks) and I'm not 
>> convinced it needs one for this feature either.
>>
>> So if that whole chunk is kdb dependent, why not shuffle that into a 
>> nicely named function and host it somewhere appropriate in 
>> kernel/debug/kdb/? That function would turn into an empty inline function 
>> in the !CONFIG_KGDB_KDB case.
>>
>> But ... it's up to Jason really whether he wants to abstract that piece of 
>> code out, I'm just kibitzing here really.
>>
>> Thanks,
>>
>> 	Ingo
>>
> 
> If I moved it to KDB then we would lose the capability to enter KGDB
> mode and the gdb_stub functionality.  The #ifdef could have a comment
> to this effect?
> 

Another option would be to pass the code in as the caller knows if KDB
is defined or not?
