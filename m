Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbaBTJAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 04:00:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:27408 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754397AbaBTJAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 04:00:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,511,1389772800"; 
   d="scan'208";a="458684774"
Message-ID: <5305C43D.8090206@intel.com>
Date: Thu, 20 Feb 2014 17:00:45 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [PATCH] perf/x86/uncore: Fix IVT/SNB-EP uncore CBOX NID filter
 table
References: <20140219131018.GA24475@quad>	<53059E9D.1030109@intel.com> <CABPqkBRcSiVwDYvknAK2QRjxFkfzhdTmx_0he1_JbDA2bsVRig@mail.gmail.com>
In-Reply-To: <CABPqkBRcSiVwDYvknAK2QRjxFkfzhdTmx_0he1_JbDA2bsVRig@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2014 04:56 PM, Stephane Eranian wrote:
> On Thu, Feb 20, 2014 at 7:20 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
>> On 02/19/2014 09:10 PM, Stephane Eranian wrote:
>>>
>>> This patch updates the CBOX PMU filters mapping tables for SNB-EP
>>> and IVT (model 45 and 62 respectively).
>>>
>>> The NID umask always comes in addition to another umask.
>>> When set, the NID filter is applied.
>>
>> Do you means the NID always applies for LLC_LOOKUP no matter what umask is.
>> If yes, I think it's better to define filter as SNBEP_CBO_EVENT_EXTRA_REG(0x34, 0xff, 0x6)
>>
> No. I mean you can add NID umask to any other umask but it cannot be
> used by itself.
> In other words, LLC_LOOKUP.NID is not allowed but LLC_LOOKUP.DATA_READ.NID is.
> 
> That is what I gathered from the description in the specs.

Thanks

Reviewed-by: Yan, Zheng <zheng.z.yan@intel.com>

> 
> 
>> Regards
>> Yan, Zheng
>>
>>>
>>> The current mapping tables were missing some code/umask
>>> combinations to account for the NID umask. This patch
>>> fixes that.
>>>
>>> Signed-off-by: Stephane Eranian <eranian@google.com>
>>>
>>> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
>>> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
>>> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
>>> @@ -501,8 +501,11 @@ static struct extra_reg snbep_uncore_cbox_extra_regs[] = {
>>>       SNBEP_CBO_EVENT_EXTRA_REG(SNBEP_CBO_PMON_CTL_TID_EN,
>>>                                 SNBEP_CBO_PMON_CTL_TID_EN, 0x1),
>>>       SNBEP_CBO_EVENT_EXTRA_REG(0x0334, 0xffff, 0x4),
>>> +     SNBEP_CBO_EVENT_EXTRA_REG(0x4334, 0xffff, 0x6),
>>>       SNBEP_CBO_EVENT_EXTRA_REG(0x0534, 0xffff, 0x4),
>>> +     SNBEP_CBO_EVENT_EXTRA_REG(0x4534, 0xffff, 0x6),
>>>       SNBEP_CBO_EVENT_EXTRA_REG(0x0934, 0xffff, 0x4),
>>> +     SNBEP_CBO_EVENT_EXTRA_REG(0x4934, 0xffff, 0x6),
>>>       SNBEP_CBO_EVENT_EXTRA_REG(0x4134, 0xffff, 0x6),
>>>       SNBEP_CBO_EVENT_EXTRA_REG(0x0135, 0xffff, 0x8),
>>>       SNBEP_CBO_EVENT_EXTRA_REG(0x0335, 0xffff, 0x8),
>>> @@ -1178,10 +1181,15 @@ static struct extra_reg ivt_uncore_cbox_extra_regs[] = {
>>>       SNBEP_CBO_EVENT_EXTRA_REG(SNBEP_CBO_PMON_CTL_TID_EN,
>>>                                 SNBEP_CBO_PMON_CTL_TID_EN, 0x1),
>>>       SNBEP_CBO_EVENT_EXTRA_REG(0x1031, 0x10ff, 0x2),
>>> +     SNBEP_CBO_EVENT_EXTRA_REG(0x1134, 0xffff, 0x4),
>>> +     SNBEP_CBO_EVENT_EXTRA_REG(0x4134, 0xffff, 0xc),
>>> +     SNBEP_CBO_EVENT_EXTRA_REG(0x5134, 0xffff, 0xc),
>>>       SNBEP_CBO_EVENT_EXTRA_REG(0x0334, 0xffff, 0x4),
>>> +     SNBEP_CBO_EVENT_EXTRA_REG(0x4334, 0xffff, 0xc),
>>>       SNBEP_CBO_EVENT_EXTRA_REG(0x0534, 0xffff, 0x4),
>>> +     SNBEP_CBO_EVENT_EXTRA_REG(0x4534, 0xffff, 0xc),
>>>       SNBEP_CBO_EVENT_EXTRA_REG(0x0934, 0xffff, 0x4),
>>> -     SNBEP_CBO_EVENT_EXTRA_REG(0x4134, 0xffff, 0xc),
>>> +     SNBEP_CBO_EVENT_EXTRA_REG(0x4934, 0xffff, 0xc),
>>>       SNBEP_CBO_EVENT_EXTRA_REG(0x0135, 0xffff, 0x10),
>>>       SNBEP_CBO_EVENT_EXTRA_REG(0x0335, 0xffff, 0x10),
>>>       SNBEP_CBO_EVENT_EXTRA_REG(0x2135, 0xffff, 0x10),
>>>
>>

