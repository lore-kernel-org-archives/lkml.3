Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab3EVGon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 02:44:43 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:50572 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369Ab3EVGok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 02:44:40 -0400
Message-ID: <519C68FC.2060304@linux.vnet.ibm.com>
Date: Wed, 22 May 2013 12:13:08 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Michael Neuling <mikey@neuling.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 3/3] perf, x86, lbr: Demand proper privileges for PERF_SAMPLE_BRANCH_KERNEL
References: <20130503121122.931661809@chello.nl> <20130503121256.230745028@chello.nl> <CABPqkBTvcQAyXfeiJwpPsNtbs4ffsVguXE631dK_rbzHpwBdOg@mail.gmail.com> <20130516090916.GF19669@dyad.programming.kicks-ass.net> <8578.1368699317@ale.ozlabs.ibm.com> <CABPqkBRpbh4BO7cMBysE+E+n5E_o_KesEhEZ3Wq49B3MeW786A@mail.gmail.com>
In-Reply-To: <CABPqkBRpbh4BO7cMBysE+E+n5E_o_KesEhEZ3Wq49B3MeW786A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052206-2000-0000-0000-00000C34AD6B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2013 07:25 PM, Stephane Eranian wrote:
> On Thu, May 16, 2013 at 12:15 PM, Michael Neuling <mikey@neuling.org> wrote:
>> Peter Zijlstra <peterz@infradead.org> wrote:
>>
>>> On Wed, May 15, 2013 at 03:37:22PM +0200, Stephane Eranian wrote:
>>>> On Fri, May 3, 2013 at 2:11 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>>>>> We should always have proper privileges when requesting kernel data.
>>>>>
>>>>> Cc: Andi Kleen <ak@linux.intel.com>
>>>>> Cc: eranian@google.com
>>>>> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>>>>> Link: http://lkml.kernel.org/n/tip-v0x9ky3ahzr6nm3c6ilwrili@git.kernel.org
>>>>> ---
>>>>>  arch/x86/kernel/cpu/perf_event_intel_lbr.c |    5 ++++-
>>>>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>>>>
>>>>> --- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
>>>>> +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
>>>>> @@ -318,8 +318,11 @@ static void intel_pmu_setup_sw_lbr_filte
>>>>>         if (br_type & PERF_SAMPLE_BRANCH_USER)
>>>>>                 mask |= X86_BR_USER;
>>>>>
>>>>> -       if (br_type & PERF_SAMPLE_BRANCH_KERNEL)
>>>>> +       if (br_type & PERF_SAMPLE_BRANCH_KERNEL) {
>>>>> +               if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
>>>>> +                       return -EACCES;
>>>>>                 mask |= X86_BR_KERNEL;
>>>>> +       }
>>>>>
>>>> This will prevent regular users from capturing kernel -> kernel branches.
>>>> But it won't prevent users from getting kernel -> user branches. Thus
>>>> some kernel address will still be captured. I guess they could be eliminated
>>>> by the sw_filter.
>>>>
>>>> When using LBR priv level filtering, the filter applies to the branch target
>>>> only.
>>>
>>> How about something like the below? It also adds the branch flags
>>> Mikey wanted for PowerPC.
>>
>> Peter,
>>
>> BTW PowerPC also has the ability to filter on conditional branches.  Any
>> chance we could add something like the follow to perf also?
>>
>> Mikey
>>
>> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
>> index fb104e5..891c769 100644
>> --- a/include/uapi/linux/perf_event.h
>> +++ b/include/uapi/linux/perf_event.h
>> @@ -157,8 +157,9 @@ enum perf_branch_sample_type {
>>         PERF_SAMPLE_BRANCH_ANY_CALL     = 1U << 4, /* any call branch */
>>         PERF_SAMPLE_BRANCH_ANY_RETURN   = 1U << 5, /* any return branch */
>>         PERF_SAMPLE_BRANCH_IND_CALL     = 1U << 6, /* indirect calls */
>> +       PERF_SAMPLE_BRANCH_CONDITIONAL  = 1U << 7, /* conditional branches */
>>
> I would use PERF_SAMPLE_BRANCH_COND here.
> 
>> -       PERF_SAMPLE_BRANCH_MAX          = 1U << 7, /* non-ABI */
>> +       PERF_SAMPLE_BRANCH_MAX          = 1U << 8, /* non-ABI */
>>  };
>>
>>  #define PERF_SAMPLE_BRANCH_PLM_ALL \
>> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
>> index cdf58ec..5b0b89d 100644
>> --- a/tools/perf/builtin-record.c
>> +++ b/tools/perf/builtin-record.c
>> @@ -676,6 +676,7 @@ static const struct branch_mode branch_modes[] = {
>>         BRANCH_OPT("any_call", PERF_SAMPLE_BRANCH_ANY_CALL),
>>         BRANCH_OPT("any_ret", PERF_SAMPLE_BRANCH_ANY_RETURN),
>>         BRANCH_OPT("ind_call", PERF_SAMPLE_BRANCH_IND_CALL),
>> +       BRANCH_OPT("cnd", PERF_SAMPLE_BRANCH_CONDITIONAL),
> 
> use "cond"
> 
>>         BRANCH_END
>>  };
>>
> 
> And if you do this, you also need to update the x86
> perf_event_intel_lbr.c mapping
> tables to fill out the entries for PERF_SAMPLE_BRANCH_COND:
> 
>         [PERF_SAMPLE_BRANCH_COND]       = LBR_JCC,
> 
> And you also need to update intel_pmu_setup_sw_lbr_filter()
> to handle the conversion to x86 instructions:
> 
>        if (br_type & PERF_SAMPLE_BRANCH_COND)
>                 mask |= X86_BR_JCC;
> 
> 
> You also need to update the perf-record.txt documentation to list cond
> as a possible
> branch filter.

Hey Stephane,

I have incorporated all the review comments into the patch series
https://lkml.org/lkml/2013/5/22/51.

Regards
Anshuman

