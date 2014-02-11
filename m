Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbaBKNyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 08:54:54 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:52412 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaBKNyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 08:54:52 -0500
MIME-Version: 1.0
In-Reply-To: <52F8436E.8090907@intel.com>
References: <1391432142-18723-1-git-send-email-eranian@google.com>
	<1391432142-18723-4-git-send-email-eranian@google.com>
	<52F8436E.8090907@intel.com>
Date: Tue, 11 Feb 2014 14:54:52 +0100
Message-ID: <CABPqkBS8ruWaAiZ+bsgqZfDYF+n34aDVQUaoTbSW+qip5=nSCg@mail.gmail.com>
Subject: Re: [PATCH v1 03/10] perf/x86/uncore: do not assume PCI fixed ctrs
 have more than 32 bits
From: Stephane Eranian <eranian@google.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yan,

In fact, I realized I was not even using all those fixed counter
changes, thanks to the
pmu bypass from patch 1. So I will drop all of this in V2. It will
make the patch simpler.

Thanks for catching this.


On Mon, Feb 10, 2014 at 4:11 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
> On 02/03/2014 08:55 PM, Stephane Eranian wrote:
>> The current code assumes all PCI fixed counters implement more than
>> 32-bit hardware counters. The actual width is then round up to 64 to
>> enable base + 8 * idx calculations.
>>
>> Not all PMUs necessarily implement counters with more than 32-bits.
>> The patch makes the uncore_pci_perf_ctr() function dynamically
>> determine the actual bits width of a pci perf counter.
>>
>> This patch paves the way for handling more than one uncore fixed
>> counter per PMU box.
>>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>> ---
>>  arch/x86/kernel/cpu/perf_event_intel_uncore.h |   31 ++++++++++++++++---------
>>  1 file changed, 20 insertions(+), 11 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
>> index 77dc9a5..f5549cf 100644
>> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
>> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
>> @@ -548,10 +548,29 @@ unsigned uncore_pci_event_ctl(struct intel_uncore_box *box, int idx)
>>       return idx * 4 + box->pmu->type->event_ctl;
>>  }
>>
>> +static inline int uncore_perf_ctr_bits(struct intel_uncore_box *box)
>> +{
>> +     return box->pmu->type->perf_ctr_bits;
>> +}
>> +
>> +static inline int uncore_fixed_ctr_bits(struct intel_uncore_box *box)
>> +{
>> +     return box->pmu->type->fixed_ctr_bits;
>> +}
>> +
>>  static inline
>>  unsigned uncore_pci_perf_ctr(struct intel_uncore_box *box, int idx)
>>  {
>> -     return idx * 8 + box->pmu->type->perf_ctr;
>> +     int bits, bytes;
>> +
>> +     if (idx == UNCORE_PMC_IDX_FIXED)
>> +             bits = uncore_fixed_ctr_bits(box);
>> +     else
>> +             bits = uncore_perf_ctr_bits(box);
>> +
>> +     bytes = round_up(bits, 8);
>
> should this be "round_up(bits, 32) / 8" ?
>
> Regards
> Yan, Zheng
>
>> +
>> +     return idx * bytes + box->pmu->type->perf_ctr;
>>  }
>>
>>  static inline unsigned uncore_msr_box_offset(struct intel_uncore_box *box)
>> @@ -633,16 +652,6 @@ unsigned uncore_perf_ctr(struct intel_uncore_box *box, int idx)
>>               return uncore_msr_perf_ctr(box, idx);
>>  }
>>
>> -static inline int uncore_perf_ctr_bits(struct intel_uncore_box *box)
>> -{
>> -     return box->pmu->type->perf_ctr_bits;
>> -}
>> -
>> -static inline int uncore_fixed_ctr_bits(struct intel_uncore_box *box)
>> -{
>> -     return box->pmu->type->fixed_ctr_bits;
>> -}
>> -
>>  static inline int uncore_num_counters(struct intel_uncore_box *box)
>>  {
>>       return box->pmu->type->num_counters;
>>
>
