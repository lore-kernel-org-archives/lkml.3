Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760680AbaGPAKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 20:10:40 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:51003 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759845AbaGPAKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 20:10:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140715141625.GH9918@twins.programming.kicks-ass.net>
References: <1405384304-26816-1-git-send-email-eranian@google.com>
	<1405384304-26816-2-git-send-email-eranian@google.com>
	<20140715141625.GH9918@twins.programming.kicks-ass.net>
Date: Wed, 16 Jul 2014 02:05:20 +0200
Message-ID: <CABPqkBR35LjKEK=UyGygU4F3GZT=DegH2A6LOX58Lcb2K596Cg@mail.gmail.com>
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

On Tue, Jul 15, 2014 at 4:16 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Jul 15, 2014 at 02:31:40AM +0200, Stephane Eranian wrote:
>> @@ -595,7 +595,8 @@ struct perf_sample_data {
>>       struct perf_callchain_entry     *callchain;
>>       struct perf_raw_record          *raw;
>>       struct perf_branch_stack        *br_stack;
>> -     struct perf_regs_user           regs_user;
>> +     struct perf_regs                regs_user;
>> +     struct perf_regs                regs_intr;
>>       u64                             stack_user_size;
>>       u64                             weight;
>>       /*
>> @@ -618,6 +619,8 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
>>       data->weight = 0;
>>       data->data_src.val = 0;
>>       data->txn = 0;
>> +     data->regs_intr.abi = PERF_SAMPLE_REGS_ABI_NONE;
>> +     data->regs_intr.regs = NULL;
>>  }
>
> I don't think we've been very careful here; does the below make sense?
>
> AFAICT we don't need to set stack_user_size at all,
> perf_prepare_sample() will set it when required, and with the change to
> perf_sample_regs_user() the same is true for the regs_user thing.
>
> This again reduces the cost of perf_sample_data_init() to touching a
> single cacheline.
>
> I'm not entirely sure the ____cacheline_aligned makes sense though, the
> previous stack line is probably touched already so any next cacheline is
> the one, and one avg we'd gain 0.5 cachelines worth of data.
>
>
I am okay with the changes in this patch.

>
> ---
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 707617a8c0f6..d27fec8118b1 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -575,34 +575,40 @@ extern u64 perf_event_read_value(struct perf_event *event,
>
>
>  struct perf_sample_data {
> -       u64                             type;
> +       /*
> +        * Fields set by perf_sample_data_init(), group so as to
> +        * minimize the cachelines touched.
> +        */
> +       u64                             addr;
> +       struct perf_raw_record          *raw;
> +       struct perf_branch_stack        *br_stack;
> +       u64                             period;
> +       u64                             weight;
> +       u64                             txn;
> +       union  perf_mem_data_src        data_src;
> +
>
> +       /*
> +        * The other fields, optionally {set,used} by
> +        * perf_{prepare,output}_sample().
> +        */
> +       u64                             type;
>         u64                             ip;
>         struct {
>                 u32     pid;
>                 u32     tid;
>         }                               tid_entry;
>         u64                             time;
> -       u64                             addr;
>         u64                             id;
>         u64                             stream_id;
>         struct {
>                 u32     cpu;
>                 u32     reserved;
>         }                               cpu_entry;
> -       u64                             period;
> -       union  perf_mem_data_src        data_src;
>         struct perf_callchain_entry     *callchain;
> -       struct perf_raw_record          *raw;
> -       struct perf_branch_stack        *br_stack;
>         struct perf_regs_user           regs_user;
>         u64                             stack_user_size;
> -       u64                             weight;
> -       /*
> -        * Transaction flags for abort events:
> -        */
> -       u64                             txn;
> -};
> +} ____cacheline_aligned;
>
>  static inline void perf_sample_data_init(struct perf_sample_data *data,
>                                          u64 addr, u64 period)
> @@ -612,9 +618,6 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
>         data->raw  = NULL;
>         data->br_stack = NULL;
>         data->period = period;
> -       data->regs_user.abi = PERF_SAMPLE_REGS_ABI_NONE;
> -       data->regs_user.regs = NULL;
> -       data->stack_user_size = 0;
>         data->weight = 0;
>         data->data_src.val = 0;
>         data->txn = 0;
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index c8b53c94d41d..926cd7aafc14 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -4299,6 +4299,8 @@ perf_output_sample_regs(struct perf_output_handle *handle,
>  static void perf_sample_regs_user(struct perf_regs_user *regs_user,
>                                   struct pt_regs *regs)
>  {
> +       regs_user->abi = PERF_SAMPLE_REGS_ABI_NONE;
> +
>         if (!user_mode(regs)) {
>                 if (current->mm)
>                         regs = task_pt_regs(current);
