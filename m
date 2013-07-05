Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964839Ab3GENYt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 09:24:49 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:44325 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756495Ab3GENYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 09:24:48 -0400
MIME-Version: 1.0
In-Reply-To: <1372944040-32690-21-git-send-email-adrian.hunter@intel.com>
References: <1372944040-32690-1-git-send-email-adrian.hunter@intel.com> <1372944040-32690-21-git-send-email-adrian.hunter@intel.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Fri, 5 Jul 2013 22:24:27 +0900
X-Google-Sender-Auth: ChNbbuzCB-ipOU82q4ffDG5tAVY
Message-ID: <CAM9d7cgXKMUcSdFFs2fbe=eeb6pJMe5pTrRjkmt4eVvr6fWqcg@mail.gmail.com>
Subject: Re: [PATCH V4 20/21] perf: make events stream always parsable
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

On Thu, Jul 4, 2013 at 10:20 PM, Adrian Hunter <adrian.hunter@intel.com> wrote:
> The event stream is not always parsable because the format of a sample
> is dependent on the sample_type of the selected event.  When there
> is more than one selected event and the sample_types are not the
> same then parsing becomes problematic.  A sample can be matched to its
> selected event using the ID that is allocated when the event is opened.
> Unfortunately, to get the ID from the sample means first parsing it.
>
> This patch adds a new sample format bit PERF_SAMPLE_IDENTIFER that puts
> the ID at a fixed position so that the ID can be retrieved without
> parsing the sample.  For sample events, that is the first position
> immediately after the header.  For non-sample events, that is the last
> position.

Why do we have to keep another ID again?
If all we need is the sample_type, why not just saving it directly?

And for the implementation, I guess it'll break old perf tools
by parsing invalid position of data. IOW if it's recorded on a newer
kernel/tool and then reported on an older perf tool (maybe on a
different machine).  In this case the old tool cannot recognize the
PERF_SAMPLE_IDENTIFIER and try to parse it as a different
type of data, right?

So I suggest put the data at the end of sample data like other new
sample types added.  Older tools would simply ignore that part, and
newer tools can access it directly by checking event.header.size
and/or evsel->sample_size.

Thanks,
Namhyung

>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  include/uapi/linux/perf_event.h |  3 ++-
>  kernel/events/core.c            | 11 ++++++++++-
>  2 files changed, 12 insertions(+), 2 deletions(-)
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
> index 1db3af9..ca532f2 100644
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
> +       if (sample_type & PERF_SAMPLE_IDENTIFIER)
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
> --
> 1.7.11.7
>
