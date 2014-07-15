Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959AbaGOX7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:59:05 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:46704 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760058AbaGOX64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:58:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140715142524.GI9918@twins.programming.kicks-ass.net>
References: <1405384304-26816-1-git-send-email-eranian@google.com>
	<1405384304-26816-2-git-send-email-eranian@google.com>
	<20140715142524.GI9918@twins.programming.kicks-ass.net>
Date: Wed, 16 Jul 2014 01:58:55 +0200
Message-ID: <CABPqkBQ1dRnTTW7=8XCRUDoeZM0UqgtLnXE0CJEZbeCD8qo1KA@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] perf: add ability to sample machine state on interrupt
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 4:25 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Jul 15, 2014 at 02:31:40AM +0200, Stephane Eranian wrote:
>> @@ -618,6 +619,8 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
>>       data->weight = 0;
>>       data->data_src.val = 0;
>>       data->txn = 0;
>> +     data->regs_intr.abi = PERF_SAMPLE_REGS_ABI_NONE;
>> +     data->regs_intr.regs = NULL;
>>  }
>
>> +static void perf_sample_regs_intr(struct perf_regs *regs_intr,
>> +                               struct pt_regs *regs)
>> +{
>> +     regs_intr->regs = regs;
>> +     regs_intr->abi  = perf_reg_abi(current);
>> +}
>
>> @@ -4800,6 +4824,20 @@ void perf_prepare_sample(struct perf_event_header *header,
>>               data->stack_user_size = stack_size;
>>               header->size += size;
>>       }
>> +
>> +     if (sample_type & PERF_SAMPLE_REGS_INTR) {
>> +             /* regs dump ABI info */
>> +             int size = sizeof(u64);
>> +
>> +             perf_sample_regs_intr(&data->regs_intr, regs);
>> +
>> +             if (data->regs_intr.regs) {
>> +                     u64 mask = event->attr.sample_regs_intr;
>> +                     size += hweight64(mask) * sizeof(u64);
>> +             }
>> +
>> +             header->size += size;
>> +     }
>
> Given that the prepare_sample hunk sets both regs_intr fields, the
> addition to perf_sample_data_init() is entirely superfluous, no?

Yes, looks like it, though having an initialization there prevents
any random values for the two fields, in case code tries to check
without first testing the sample_format bitmask. So yes, it is redundant
but may  prevent future errors.
