Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab3JWLCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 07:02:24 -0400
Received: from intranet.asianux.com ([58.214.24.6]:56885 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab3JWLCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 07:02:23 -0400
X-Spam-Score: -100.8
Message-ID: <5267AC7C.2040803@asianux.com>
Date: Wed, 23 Oct 2013 19:01:16 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, khilman@linaro.org,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: context_tracking: use extern function instead
 of static inline function for user_enter/exit()
References: <5267A72B.7060808@asianux.com> <1382525244.5283.3.camel@pippen.local.home>
In-Reply-To: <1382525244.5283.3.camel@pippen.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2013 06:47 PM, Steven Rostedt wrote:
> On Wed, 2013-10-23 at 18:38 +0800, Chen Gang wrote:
> 
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> ---
>>  include/linux/context_tracking.h |   14 ++------------
>>  kernel/context_tracking.c        |   12 ++++++++++++
>>  2 files changed, 14 insertions(+), 12 deletions(-)
>>
>> diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
>> index 1581587..bf220f7 100644
>> --- a/include/linux/context_tracking.h
>> +++ b/include/linux/context_tracking.h
>> @@ -10,23 +10,13 @@
>>  #ifdef CONFIG_CONTEXT_TRACKING
>>  extern void context_tracking_cpu_set(int cpu);
>>  
>> +extern void user_enter(void);
>> +extern void user_exit(void);
>>  extern void context_tracking_user_enter(void);
>>  extern void context_tracking_user_exit(void);
>>  extern void __context_tracking_task_switch(struct task_struct *prev,
>>  					   struct task_struct *next);
>>  
>> -static inline void user_enter(void)
>> -{
>> -	if (static_key_false(&context_tracking_enabled))
>> -		context_tracking_user_enter();
>> -
>> -}
>> -static inline void user_exit(void)
>> -{
>> -	if (static_key_false(&context_tracking_enabled))
>> -		context_tracking_user_exit();
>> -}
>> -
>>  static inline enum ctx_state exception_enter(void)
>>  {
>>  	enum ctx_state prev_ctx;
>> diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
>> index 013161f..c03d0d6 100644
>> --- a/kernel/context_tracking.c
>> +++ b/kernel/context_tracking.c
>> @@ -29,6 +29,18 @@ EXPORT_SYMBOL_GPL(context_tracking_enabled);
>>  DEFINE_PER_CPU(struct context_tracking, context_tracking);
>>  EXPORT_SYMBOL_GPL(context_tracking);
>>  
>> +void user_enter(void)
>> +{
>> +	if (static_key_false(&context_tracking_enabled))
>> +		context_tracking_user_enter();
>> +}
>> +
>> +void user_exit(void)
>> +{
>> +	if (static_key_false(&context_tracking_enabled))
>> +		context_tracking_user_exit();
>> +}
>> +
>>  void context_tracking_cpu_set(int cpu)
>>  {
>>  	if (!per_cpu(context_tracking.active, cpu)) {
> 
> Ug, you just put an unneeded function call into a fast path because of a
> failure with a particular arch.
> 
> If you need the assembly to call this code, then make yourself a wrapper
> function to call that does the user_enter/exit() calls.
> 
> void arch_user_enter(void)
> {
> 	user_enter();
> }
> 

OK, thanks. That sounds reasonable to me. I will send related patch to
arm guys. :-)


Thanks.
-- 
Chen Gang
