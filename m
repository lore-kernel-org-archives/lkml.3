Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933790Ab3GEDTe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 23:19:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:9187 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933735Ab3GEDTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 23:19:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,999,1363158000"; 
   d="scan'208";a="340737387"
Message-ID: <51D63B43.9050604@intel.com>
Date: Fri, 05 Jul 2013 11:19:31 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        andi@firstfloor.org
Subject: Re: [PATCH v2 3/7] perf, x86: Introduce x86 special perf event context
References: <1372663387-11754-1-git-send-email-zheng.z.yan@intel.com> <1372663387-11754-4-git-send-email-zheng.z.yan@intel.com> <20130704124148.GI23916@twins.programming.kicks-ass.net>
In-Reply-To: <20130704124148.GI23916@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2013 08:41 PM, Peter Zijlstra wrote:
> On Mon, Jul 01, 2013 at 03:23:03PM +0800, Yan, Zheng wrote:
>> From: "Yan, Zheng" <zheng.z.yan@intel.com>
>>
>> The x86 special perf event context is named x86_perf_event_context,
>> We can enlarge it later to store PMU special data.
> 
> This changelog is completely inadequate. It fails to state what and why
> we do things.
> 
> I hate doing this; but I can't see another way around it either. That
> said:
> 
>> @@ -274,6 +274,11 @@ struct pmu {
>>  	 * flush branch stack on context-switches (needed in cpu-wide mode)
>>  	 */
>>  	void (*flush_branch_stack)	(void);
>> +
>> +	/*
>> +	 * Allocate PMU special perf event context
>> +	 */
>> +	void *(*event_context_alloc)	(struct perf_event_context *parent_ctx);
>>  };
> 
> It should be *optional*, also wtf is that parent_ctx thing for?

parent_ctx is for the fork() case, used for checking if the callstack feature
is enabled for the parent task. If yes, clone  parent task's LBR stack.
For the simple program below:

--- 
void func0()
{
  ...
}

int main(int argc, char *argv[])
{
        if (fork() > 0) {
                int foo;
                wait(&foo);
        }
        while (1) func0();
}

if clone LBR stack on fork(), the output of perf report looks like:
----
0.35%     test  test               [.] func0
          |
          --- func0
              main
              _start

if not clone LBR stack on fork(), the output of perf report looks like:
----

     0.17%     test  test               [.] func0
               |
               --- func0
                   main

> 
>> +++ b/kernel/events/core.c
>> @@ -2961,13 +2961,20 @@ static void __perf_event_init_context(struct perf_event_context *ctx)
>>  }
>>  
>>  static struct perf_event_context *
>> -alloc_perf_context(struct pmu *pmu, struct task_struct *task)
>> +alloc_perf_context(struct pmu *pmu, struct task_struct *task,
>> +		   struct perf_event_context *parent_ctx)
>>  {
>>  	struct perf_event_context *ctx;
>>  
>> -	ctx = kzalloc(sizeof(struct perf_event_context), GFP_KERNEL);
>> -	if (!ctx)
>> -		return NULL;
>> +	if (pmu->event_context_alloc) {
>> +		ctx = pmu->event_context_alloc(parent_ctx);
>> +		if (IS_ERR(ctx))
>> +			return ctx;
>> +	} else {
>> +		ctx = kzalloc(sizeof(struct perf_event_context), GFP_KERNEL);
>> +		if (!ctx)
>> +			return ERR_PTR(-ENOMEM);
>> +	}
>>  
>>  	__perf_event_init_context(ctx);
>>  	if (task) {
> 
> I'm not at all sure we want to do it like this; why not simply query the
> size. Something like:

Because we need to initialize x86 PMU special data.(not just zero them)

Regards
Yan, Zheng 


> 
>   alloc_perf_context(struct pmu *pmu, struct task_struct *task)
>   {
>     size_t ctx_size = sizeof(struct perf_event_context);
> 
>     if (pmu->task_context_size)
>       size = pmu->task_context_size();
> 
>     ctx = kzalloc(size, GFP_KERNEL);
>     if (!ctx)
>       return ERR_PTR(-ENOMEM);
> 
>     ...
> 
>   }
> 
> 

