Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbaLHINp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 03:13:45 -0500
Received: from mail-oi0-f41.google.com ([209.85.218.41]:57776 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbaLHINn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 03:13:43 -0500
MIME-Version: 1.0
In-Reply-To: <1417623842-14331-4-git-send-email-jolsa@kernel.org>
References: <1417623842-14331-1-git-send-email-jolsa@kernel.org> <1417623842-14331-4-git-send-email-jolsa@kernel.org>
From: Namhyung Kim <namhyung@kernel.org>
Date: Mon, 8 Dec 2014 17:13:23 +0900
X-Google-Sender-Auth: KmuGiiw9SC7hN0Jtd2Mt5BpnuHA
Message-ID: <CAM9d7cgzo95YOm9Y8WaLNhZ8aY97Te33_KihWG0yfXDVBjMLeg@mail.gmail.com>
Subject: Re: [PATCH 3/8] perf data: Add perf data to CTF conversion support
To: Jiri Olsa <jolsa@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tom Zanussi <tzanussi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2014 at 1:23 AM, Jiri Olsa <jolsa@kernel.org> wrote:
> diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> index 33864dd316e5..2d3229ec0a23 100644
> --- a/tools/perf/Makefile.perf
> +++ b/tools/perf/Makefile.perf
> @@ -402,6 +402,10 @@ LIB_OBJS += $(OUTPUT)util/tsc.o
>  LIB_OBJS += $(OUTPUT)util/cloexec.o
>  LIB_OBJS += $(OUTPUT)util/thread-stack.o
>
> +ifneq ($(NO_LIBBABELTRACE),1)

I think we usually do it with just "ifndef".


> +LIB_OBJS += $(OUTPUT)util/data-convert-bt.o
> +endif
> +
>  LIB_OBJS += $(OUTPUT)ui/setup.o
>  LIB_OBJS += $(OUTPUT)ui/helpline.o
>  LIB_OBJS += $(OUTPUT)ui/progress.o

[SNIP]
> +static int add_generic_values(struct ctf_writer *cw,
> +                             struct bt_ctf_event *event,
> +                             struct perf_evsel *evsel,
> +                             struct perf_sample *sample)
> +{
> +       u64 type = evsel->attr.sample_type;
> +       int ret;
> +
> +       /*
> +        * missing:
> +        *   PERF_SAMPLE_TIME         - not needed as we have it in
> +        *                              ctf event header
> +        *   PERF_SAMPLE_READ         - TODO
> +        *   PERF_SAMPLE_CALLCHAIN    - TODO
> +        *   PERF_SAMPLE_RAW          - tracepoint fields are handled separately
> +        *   PERF_SAMPLE_BRANCH_STACK - TODO
> +        *   PERF_SAMPLE_REGS_USER    - TODO
> +        *   PERF_SAMPLE_STACK_USER   - TODO
> +        */
> +
> +       if (type & PERF_SAMPLE_IP) {
> +               ret = value_set_u64_hex(cw, event, "ip", sample->ip);
> +               if (ret)
> +                       return -1;
> +       }
> +
> +       if (type & PERF_SAMPLE_TID) {
> +               ret = value_set_s32(cw, event, "tid", sample->tid);
> +               if (ret)
> +                       return -1;
> +
> +               ret = value_set_s32(cw, event, "pid", sample->tid);

sample->pid ?


> +               if (ret)
> +                       return -1;
> +       }
> +
> +       if ((type & PERF_SAMPLE_ID) ||
> +           (type & PERF_SAMPLE_IDENTIFIER)) {
> +               ret = value_set_u64(cw, event, "id", sample->id);
> +               if (ret)
> +                       return -1;
> +       }
> +
> +       if (type & PERF_SAMPLE_STREAM_ID) {
> +               ret = value_set_u64(cw, event, "stream_id", sample->id);

sample->stream_id ?

Thanks,
Namhyung


> +               if (ret)
> +                       return -1;
> +       }
