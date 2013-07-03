Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab3GCGkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 02:40:33 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:41441 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551Ab3GCGkc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 02:40:32 -0400
MIME-Version: 1.0
In-Reply-To: <51D27A04.7040705@intel.com>
References: <1372319707-13892-1-git-send-email-adrian.hunter@intel.com>
	<1372319707-13892-13-git-send-email-adrian.hunter@intel.com>
	<51CC6AAF.4030404@gmail.com>
	<51D14CB6.206@intel.com>
	<51D1D043.5030509@gmail.com>
	<CABPqkBRJNcSi_qdmn9Bfw57MbX=RcaSC9RLt-u6FKfW+q5jM0A@mail.gmail.com>
	<51D27A04.7040705@intel.com>
Date: Wed, 3 Jul 2013 08:40:31 +0200
Message-ID: <CABPqkBTMZ77Bo=qJppaUFx0_8OPOXVhA+UmiDbZZzzwbB3XV_w@mail.gmail.com>
Subject: Re: [PATCH V2 12/15] perf tools: allow non-matching sample types
From: Stephane Eranian <eranian@google.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 2, 2013 at 8:58 AM, Adrian Hunter <adrian.hunter@intel.com> wrote:
> On 01/07/13 22:10, Stephane Eranian wrote:
>> On Mon, Jul 1, 2013 at 8:53 PM, David Ahern <dsahern@gmail.com> wrote:
>>>
>>> On 7/1/13 3:32 AM, Adrian Hunter wrote:
>>>>
>>>> Snip
>>>>
>>>>>
>>>>> While this works for a combined S/W and tracepoint events session, I do not
>>>>> like promoting sample types to the minimum compatible level for all events
>>>>> in the session. perf needs to allow each event to have its own sample_type
>>>>> and not force a minimal compatibility.
>>>>
>>>>
>>>> Why?  The impact is small. The kernel API is completely unchanged.
>>>
>>>
>>> I'd like to see libperf become a stable, usable library - usable by more than the perf binary and its builtin commands. I have already done this once for a daemon, and it was a PITA to get the specific use functional without memory leaks/growth in the libperf part.
>>>
>>> With respect to this specific patch it means appropriate flexibility in the data collected for events. ie., each event can have its own sample_type. For example if the tracepoint already contains task information TID is not needed - and IP may not be wanted either. The code processing the samples should not require all events to have some minimum data format - that just wastes buffer space.
>>>
>> I agree. This kernel needs to allow for any bit combination on
>> sample_type and yet provide enough info
>> to parse the buffer in the case of multi-event sampling. This is
>> kernel bug. Tools should not have to handle
>> this. Because it'd have to be repeated for each tool.
>>
>> Later this week, I'll post a patch that address the kernel limitation.
>
> But isn't it trivial.  Just add a new sample type that puts the ID first.
> Anyone using the new PERF_SAMPLE_IDENTIFIER gets the new ABI.
>
>
You could do that but then how many aliases do we need for the event ID.

>
> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> index 0b1df41..6bb217e 100644
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -134,8 +134,9 @@ enum perf_event_sample_format {
>         PERF_SAMPLE_STACK_USER                  = 1U << 13,
>         PERF_SAMPLE_WEIGHT                      = 1U << 14,
>         PERF_SAMPLE_DATA_SRC                    = 1U << 15,
> +       PERF_SAMPLE_IDENTIFIER                  = 1U << 16,
>
> -       PERF_SAMPLE_MAX = 1U << 16,             /* non-ABI */
> +       PERF_SAMPLE_MAX = 1U << 17,             /* non-ABI */
>  };
>
>  /*
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 1db3af9..a3707af 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -1203,6 +1203,9 @@ static void perf_event__id_header_size(struct perf_event *event)
>         if (sample_type & PERF_SAMPLE_TIME)
>                 size += sizeof(data->time);
>
> +       if (sample_type & PERF_SAMPLE_IDENTIFIER)
> +               size += sizeof(data->id);
> +
>         if (sample_type & PERF_SAMPLE_ID)
>                 size += sizeof(data->id);
>
> @@ -4229,7 +4232,7 @@ static void __perf_event_header__init_id(struct perf_event_header *header,
>         if (sample_type & PERF_SAMPLE_TIME)
>                 data->time = perf_clock();
>
> -       if (sample_type & PERF_SAMPLE_ID)
> +       if (sample_type & (PERF_SAMPLE_ID | PERF_SAMPLE_IDENTIFIER))
>                 data->id = primary_event_id(event);
>
>         if (sample_type & PERF_SAMPLE_STREAM_ID)
> @@ -4268,6 +4271,9 @@ static void __perf_event__output_id_sample(struct perf_output_handle *handle,
>
>         if (sample_type & PERF_SAMPLE_CPU)
>                 perf_output_put(handle, data->cpu_entry);
> +
> +       if (sample_type & PERF_SAMPLE_IDENTIFER)
> +               perf_output_put(handle, data->id);
>  }
>
>  void perf_event__output_id_sample(struct perf_event *event,
> @@ -4380,6 +4386,9 @@ void perf_output_sample(struct perf_output_handle *handle,
>
>         perf_output_put(handle, *header);
>
> +       if (sample_type & PERF_SAMPLE_IDENTIFIER)
> +               perf_output_put(handle, data->id);
> +
>         if (sample_type & PERF_SAMPLE_IP)
>                 perf_output_put(handle, data->ip);
>
