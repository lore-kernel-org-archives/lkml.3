Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbaLAR2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 12:28:14 -0500
Received: from mail-qg0-f43.google.com ([209.85.192.43]:34496 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbaLAR2M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 12:28:12 -0500
MIME-Version: 1.0
In-Reply-To: <20141128112650.GD27703@krava.brq.redhat.com>
References: <53F38C74.4030300@voxpopuli.im>
	<20140820092858.GA1203@krava.brq.redhat.com>
	<53F4F38C.4080407@voxpopuli.im>
	<5457C259.8030605@linutronix.de>
	<545829CA.7040900@voxpopuli.im>
	<20141105125028.GA30087@linutronix.de>
	<545AEA37.601@voxpopuli.im>
	<5460156E.3050601@voxpopuli.im>
	<5463DBD5.9080303@voxpopuli.im>
	<20141126173721.GA6829@linutronix.de>
	<20141128112650.GD27703@krava.brq.redhat.com>
Date: Mon, 1 Dec 2014 12:28:08 -0500
X-Google-Sender-Auth: Su7vDKFaDoxKlmbt0fJQ0cFqmcU
Message-ID: <CA+jJMxsM6iX8wGjWw_kR6Db=of8d8pOg0wEFUxAdktCVsMOpXA@mail.gmail.com>
Subject: Re: Support for Perf CTF traces now in master (was Re: FW: [RFC 0/5]
 perf tools: Add perf data CTF conversion)
From: =?UTF-8?Q?J=C3=A9r=C3=A9mie_Galarneau?= 
	<jeremie.galarneau@efficios.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexandre Montplaisir <alexmonthy@voxpopuli.im>,
        linux-kernel@vger.kernel.org,
        Dominique Toupin <dominique.toupin@ericsson.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Trace Compass Developer Discussions 
	<tracecompass-dev@eclipse.org>,
        Matthew Khouzam <matthew.khouzam@ericsson.com>, andreas@linutronix.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 6:26 AM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Wed, Nov 26, 2014 at 06:37:21PM +0100, Sebastian Andrzej Siewior wrote:
>> * Alexandre Montplaisir | 2014-11-12 17:14:45 [-0500]:
>
> SNIP
>
>>
>> >This was based on the most recent file format I was aware of, we will
>> >update it accordingly if required.
>> >
>> >Testing welcome!
>>
>> I pushed the perf changes I mentioned to
>>
>>   git://git.breakpoint.cc/bigeasy/linux.git ctf_convert_7
>>
>
> from perf data convert point of view (and libbabeltrace).. ;-)
>
> I tried to convert big perf.data (2GB) and my laptop got stuck
> for few minutes.. the reason is that perf allocated too much memory
>
> I needed to add occasional bt_ctf_stream_flush into the
> processing (patch attached)
>
> What I do now is checking if we processed given amount of events
> for the stream and once the value is crossed I flush it.
>
> My question is if there's a way to find out the allocated memory
> for the stream?  It'd be nicer to setup maximum allocation size
> rather than the number of events.
>

Not currently, although I agree that this would be a nice feature.
Perhaps by setting a maximal packet size, CTF Writer could handle the
automatic flushing.

Thoughts?

Jérémie

> thanks,
> jirka
>
>
>
> diff --git a/tools/perf/util/data-bt.c b/tools/perf/util/data-bt.c
> index c5720e13d8f1..981e8ff2c32a 100644
> --- a/tools/perf/util/data-bt.c
> +++ b/tools/perf/util/data-bt.c
> @@ -39,10 +39,15 @@ struct evsel_priv {
>
>  #define MAX_CPUS       4096
>
> +struct ctf_stream {
> +       struct bt_ctf_stream *stream;
> +       u64 count;
> +};
> +
>  struct ctf_writer {
>         /* writer primitives */
>         struct bt_ctf_writer            *writer;
> -       struct bt_ctf_stream            *stream[MAX_CPUS];
> +       struct ctf_stream               *stream[MAX_CPUS];
>         struct bt_ctf_stream_class      *stream_class;
>         struct bt_ctf_clock             *clock;
>         u32                             last_cpu;
> @@ -377,6 +382,73 @@ static int add_generic_values(struct ctf_writer *cw,
>         return 0;
>  }
>
> +#define STREAM_FLUSH_COUNT 1000
> +
> +static bool is_flush_needed(struct ctf_stream *cstream)
> +{
> +       return cstream && (cstream->count >= STREAM_FLUSH_COUNT);
> +}
> +
> +static int flush_stream(struct ctf_writer *cw, int cpu)
> +{
> +       struct ctf_stream *cstream = cw->stream[cpu];
> +       int err = 0;
> +
> +       if (cstream) {
> +               err = bt_ctf_stream_flush(cstream->stream);
> +               if (err)
> +                       pr_err("CTF stream %d flush failed\n", cpu);
> +
> +               cstream->count = 0;
> +       }
> +
> +       return err;
> +}
> +
> +static int create_stream(struct ctf_writer *cw, int cpu)
> +{
> +       struct ctf_stream *cstream;
> +       struct bt_ctf_field *pkt_ctx;
> +       struct bt_ctf_field *cpu_field;
> +       struct bt_ctf_stream *stream;
> +       u32 i = cpu;
> +       int ret;
> +
> +       cstream = zalloc(sizeof(*cstream));
> +       if (!cstream) {
> +               pr_err("Failed to allocate ctf stream\n");
> +               return -1;
> +       }
> +
> +       stream = bt_ctf_writer_create_stream(cw->writer, cw->stream_class);
> +       if (!stream)
> +               return -1;
> +
> +       pkt_ctx = bt_ctf_stream_get_packet_context(stream);
> +       if (!pkt_ctx) {
> +               pr_err("Failed to obtain packet context\n");
> +               return -1;
> +       }
> +
> +       cpu_field = bt_ctf_field_structure_get_field(pkt_ctx, "cpu_id");
> +       bt_ctf_field_put(pkt_ctx);
> +       if (!cpu_field) {
> +               pr_err("Failed to obtain cpu field\n");
> +               return -1;
> +       }
> +
> +       ret = bt_ctf_field_unsigned_integer_set_value(cpu_field, i);
> +       if (ret) {
> +               pr_err("Failed to update CPU number\n");
> +               return -1;
> +       }
> +       bt_ctf_field_put(cpu_field);
> +
> +       cstream->stream = stream;
> +       cw->stream[i] = cstream;
> +       return 0;
> +}
> +
>  static int process_sample_event(struct perf_tool *tool,
>                                 union perf_event *_event __maybe_unused,
>                                 struct perf_sample *sample,
> @@ -431,40 +503,14 @@ static int process_sample_event(struct perf_tool *tool,
>                 cpu = 0;
>         }
>
> -       if (!cw->stream[cpu]) {
> -               struct bt_ctf_field *pkt_ctx;
> -               struct bt_ctf_field *cpu_field;
> -               struct bt_ctf_stream *stream;
> -               u32 i = sample->cpu;
> -
> -               stream = bt_ctf_writer_create_stream(cw->writer, cw->stream_class);
> -               if (!stream)
> -                       return -1;
> -
> -               pkt_ctx = bt_ctf_stream_get_packet_context(stream);
> -               if (!pkt_ctx) {
> -                       pr_err("Failed to obtain packet context\n");
> -                       return -1;
> -               }
> -
> -               cpu_field = bt_ctf_field_structure_get_field(pkt_ctx, "cpu_id");
> -               bt_ctf_field_put(pkt_ctx);
> -               if (!cpu_field) {
> -                       pr_err("Failed to obtain cpu field\n");
> -                       return -1;
> -               }
> +       if (!cw->stream[cpu] && create_stream(cw, cpu))
> +               return -1;
>
> -               ret = bt_ctf_field_unsigned_integer_set_value(cpu_field, i);
> -               if (ret) {
> -                       pr_err("Failed to update CPU number\n");
> -                       return -1;
> -               }
> -               bt_ctf_field_put(cpu_field);
> +       if (is_flush_needed(cw->stream[cpu]))
> +               flush_stream(cw, cpu);
>
> -               cw->stream[i] = stream;
> -       }
> -
> -       bt_ctf_stream_append_event(cw->stream[cpu], event);
> +       cw->stream[cpu]->count++;
> +       bt_ctf_stream_append_event(cw->stream[cpu]->stream, event);
>         bt_ctf_event_put(event);
>         return 0;
>  }
> @@ -745,8 +791,12 @@ static void ctf_writer__cleanup(struct ctf_writer *cw)
>         ctf_writer__cleanup_data(cw);
>
>         bt_ctf_clock_put(cw->clock);
> -       for (i = 0; i < MAX_CPUS; i++)
> -               bt_ctf_stream_put(cw->stream[i]);
> +       for (i = 0; i < MAX_CPUS; i++) {
> +               if (cw->stream[i]) {
> +                       bt_ctf_stream_put(cw->stream[i]->stream);
> +                       free(cw->stream[i]);
> +               }
> +       }
>         bt_ctf_stream_class_put(cw->stream_class);
>         bt_ctf_writer_put(cw->writer);
>
> @@ -862,6 +912,9 @@ int bt_convert__perf2ctf(const char *input, const char *path)
>         if (!session)
>                 goto free_writer;
>
> +       ordered_events__set_alloc_size(&session->ordered_events,
> +                                      100*1024*1024);
> +
>         /* CTF writer env/clock setup  */
>         if (ctf_writer__setup_env(cw, session))
>                 goto free_session;
> @@ -872,15 +925,10 @@ int bt_convert__perf2ctf(const char *input, const char *path)
>
>         err = perf_session__process_events(session, &c.tool);
>         if (!err) {
> -               int i;
> +               int cpu;
>
> -               for (i = 0; i < MAX_CPUS; i++) {
> -                       if (cw->stream[i]) {
> -                               err = bt_ctf_stream_flush(cw->stream[i]);
> -                               if (err)
> -                                       pr_err("CTF stream %d flush failed\n", i);
> -                       }
> -               }
> +               for (cpu = 0; cpu < MAX_CPUS; cpu++)
> +                       flush_stream(cw, cpu);
>         }
>
>         fprintf(stderr,



-- 
Jérémie Galarneau
EfficiOS Inc.
http://www.efficios.com
