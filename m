Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbaEOOnE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:43:04 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:46470 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbaEOOnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:43:02 -0400
MIME-Version: 1.0
In-Reply-To: <20140515143258.GA19657@tassilo.jf.intel.com>
References: <20140515115337.GA2855@quad>
	<20140515143258.GA19657@tassilo.jf.intel.com>
Date: Thu, 15 May 2014 16:43:01 +0200
Message-ID: <CABPqkBS6F8+s4ff2=dn-H3ybxeTrknK3SCW5Ro50GpzH9Y27pA@mail.gmail.com>
Subject: Re: [PATCH] perf/x86: fix Haswell precise store data source encoding
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Joe Mario <jmario@redhat.com>,
        Don Zickus <dzickus@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 4:32 PM, Andi Kleen <ak@linux.intel.com> wrote:
> On Thu, May 15, 2014 at 01:53:37PM +0200, Stephane Eranian wrote:
>>
>> This patches fixes a bug in  precise_store_data_hsw() whereby
>> it would set the data source memory level to the wrong value.
>>
>> As per the the SDM Vol 3b Table 18-41 (Layout of Data Linear
>> Address Information in PEBS Record), when status bit 0 is set
>> this is a L1 hit, otherwise this is a L1 miss.
>>
>> This patch encodes the memory level according to the specification.
>
> It's not enough. as I said it needs more fixes.
>
> For most events it should be _NA, _STORE can be only specified
> for the explicit _STORE events.
>
Yes, I forgot about that. Will re-spin the patch.

> -Andi
>
>>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>>
>> diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
>> index ae96cfa..81424f6 100644
>> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
>> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
>> @@ -114,9 +114,13 @@ static u64 precise_store_data_hsw(u64 status)
>>
>>       dse.val = 0;
>>       dse.mem_op = PERF_MEM_OP_STORE;
>> -     dse.mem_lvl = PERF_MEM_LVL_NA;
>> +     dse.mem_lvl = PERF_MEM_LVL_L1;
>> +
>>       if (status & 1)
>> -             dse.mem_lvl = PERF_MEM_LVL_L1;
>> +             dse.mem_lvl |= PERF_MEM_LVL_HIT;
>> +     else
>> +             dse.mem_lvl |= PERF_MEM_LVL_MISS;
>> +
>>       /* Nothing else supported. Sorry. */
>>       return dse.val;
>>  }
>
> --
> ak@linux.intel.com -- Speaking for myself only
