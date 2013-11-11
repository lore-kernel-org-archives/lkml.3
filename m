Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab3KKTJ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 14:09:27 -0500
Received: from relay3.sgi.com ([192.48.152.1]:52482 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754922Ab3KKTJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 14:09:20 -0500
Message-ID: <52812B50.7050503@sgi.com>
Date: Mon, 11 Nov 2013 11:09:04 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        jason.wessel@windriver.com, acme@ghostprotocols.net, hedi@sgi.com,
        sivanich@sgi.com, tglx@linutronix.de
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/uv] x86/UV: Add uvtrace support
References: <20130923212501.185052551@asylum.americas.sgi.com> <tip-8eba18428ac926f436064ac281e76d36d51bd631@git.kernel.org> <20131111185340.GA15854@gmail.com>
In-Reply-To: <20131111185340.GA15854@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/11/2013 10:53 AM, Ingo Molnar wrote:
> 
> * tip-bot for Mike Travis <tipbot@zytor.com> wrote:
> 
>> Commit-ID:  8eba18428ac926f436064ac281e76d36d51bd631
>> Gitweb:     http://git.kernel.org/tip/8eba18428ac926f436064ac281e76d36d51bd631
>> Author:     Mike Travis <travis@sgi.com>
>> AuthorDate: Mon, 23 Sep 2013 16:25:06 -0500
>> Committer:  Ingo Molnar <mingo@kernel.org>
>> CommitDate: Tue, 24 Sep 2013 09:02:04 +0200
>>
>> x86/UV: Add uvtrace support
>>
>> This patch adds support for the uvtrace module by providing a
>> skeleton call to the registered trace function.  It also
>> provides another separate 'NMI' tracer that is triggered by the
>> system wide 'power nmi' command.
>>
>> Signed-off-by: Mike Travis <travis@sgi.com>
>> Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
>> Reviewed-by: Hedi Berriche <hedi@sgi.com>
>> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
>> Cc: Jason Wessel <jason.wessel@windriver.com>
>> Link: http://lkml.kernel.org/r/20130923212501.185052551@asylum.americas.sgi.com
>> Signed-off-by: Ingo Molnar <mingo@kernel.org>
>> ---
>>  arch/x86/include/asm/uv/uv.h  |  8 ++++++++
>>  arch/x86/platform/uv/uv_nmi.c | 13 ++++++++++++-
>>  2 files changed, 20 insertions(+), 1 deletion(-)
> 
> So I only noticed this too late:
> 
>> diff --git a/arch/x86/include/asm/uv/uv.h b/arch/x86/include/asm/uv/uv.h
>> index 6b964a0..8b1283d 100644
>> --- a/arch/x86/include/asm/uv/uv.h
>> +++ b/arch/x86/include/asm/uv/uv.h
>> @@ -14,6 +14,13 @@ extern void uv_cpu_init(void);
>>  extern void uv_nmi_init(void);
>>  extern void uv_register_nmi_notifier(void);
>>  extern void uv_system_init(void);
>> +extern void (*uv_trace_nmi_func)(unsigned int reason, struct pt_regs *regs);
>> +extern void (*uv_trace_func)(const char *f, const int l, const char *fmt, ...);
>> +#define uv_trace(fmt, ...)						\
>> +do {									\
>> +	if (unlikely(uv_trace_func))					\
>> +		(uv_trace_func)(__func__, __LINE__, fmt, ##__VA_ARGS__);\
>> +} while (0)
>>  extern const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
>>  						 struct mm_struct *mm,
>>  						 unsigned long start,
>> @@ -26,6 +33,7 @@ static inline enum uv_system_type get_uv_system_type(void) { return UV_NONE; }
>>  static inline int is_uv_system(void)	{ return 0; }
>>  static inline void uv_cpu_init(void)	{ }
>>  static inline void uv_system_init(void)	{ }
>> +static inline void uv_trace(void *fmt, ...)	{ }
>>  static inline void uv_register_nmi_notifier(void) { }
>>  static inline const struct cpumask *
>>  uv_flush_tlb_others(const struct cpumask *cpumask, struct mm_struct *mm,
>> diff --git a/arch/x86/platform/uv/uv_nmi.c b/arch/x86/platform/uv/uv_nmi.c
>> index 2579fbd..c171ca5 100644
>> --- a/arch/x86/platform/uv/uv_nmi.c
>> +++ b/arch/x86/platform/uv/uv_nmi.c
>> @@ -1,5 +1,5 @@
>>  /*
>> - * SGI NMI support routines
>> + * SGI NMI/TRACE support routines
>>   *
>>   *  This program is free software; you can redistribute it and/or modify
>>   *  it under the terms of the GNU General Public License as published by
>> @@ -36,6 +36,13 @@
>>  #include <asm/uv/uv_hub.h>
>>  #include <asm/uv/uv_mmrs.h>
>>  
>> +void (*uv_trace_func)(const char *f, const int l, const char *fmt, ...);
>> +EXPORT_SYMBOL(uv_trace_func);
>> +
>> +void (*uv_trace_nmi_func)(unsigned int reason, struct pt_regs *regs);
>> +EXPORT_SYMBOL(uv_trace_nmi_func);
>> +
>> +
>>  /*
>>   * UV handler for NMI
>>   *
>> @@ -551,6 +558,10 @@ int uv_handle_nmi(unsigned int reason, struct pt_regs *regs)
>>  		return NMI_DONE;
>>  	}
>>  
>> +	/* Call possible NMI trace function */
>> +	if (unlikely(uv_trace_nmi_func))
>> +		(uv_trace_nmi_func)(reason, regs);
> 
> Nothing actually uses the uv_trace() methods, plus nobody actually sets 
> uv_trace_func.
> 
> Whatever hack this is, it has no place in the upstream kernel. I'll queue 
> up a revert to make this pushable in this merge window.
> 
> Thanks,
> 
> 	Ingo
> 

Hi Ingo,

Currently the uvtrace function is a separate module built out of
tree.  It's pretty much prototype right now so not quite ready
for general use.  It's used mostly to debug problems that are
timing and/or load sensitive as it's a very low overhead trace
module that includes high resolution timing.

Should I do this differently, perhaps with a register function?

Thanks,
Mike
