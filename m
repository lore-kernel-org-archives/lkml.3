Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbaCLOFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 10:05:31 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:49218 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448AbaCLOF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 10:05:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140311033345.GA2631@infradead.org>
References: <CABPqkBS1A5d-=OBUL6wJA-MAAKK2UTS+_kbYyBN=d-hohSc89Q@mail.gmail.com>
	<20140311033345.GA2631@infradead.org>
Date: Wed, 12 Mar 2014 15:05:28 +0100
Message-ID: <CABPqkBRLRYv7SvUHoArfgvLrCyJ8CTvCYQgmECNj69yvwiTvYQ@mail.gmail.com>
Subject: Re: [BUG] perf annotate: not reporting all events profiles
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 4:33 AM, Arnaldo Carvalho de Melo
<acme@redhat.com> wrote:
> Em Mon, Mar 10, 2014 at 10:57:48PM +0100, Stephane Eranian escreveu:
>> Arnaldo,
>>
>> I am using tip.git perf and I do the following:
>>
>> $ perf record -e cycles,instructions foo
>> $ perf annotate --stdio
>>
>> (no explicit grouping).
>>
>> I only see the asm profile for the first event (cycles).
>> I don't see a way to display the profile for the second
>> event in the cmdline options.
>>
>> Yet the code in __cmd_annotate() seems to  try and
>> display all profiles.
>>
>> If I use the TUI, it prompts me for the event at the first
>> screen and I get different asm profiles.
>>
>> So what is wrong?
>
> That code went from supporting just one type of sample to suporting
> groups, GTK+, TUI, etc, needs some work to untangle things up and make
> it clearer...
>
> But TUI works as expected, right?
>
> That being said, try this patch, that is not optimal yet but allows you
> to see the events.
>
> I'll continue work on fixing up --stdio tomorrow.
>
> - Arnaldo
>
> diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
> index 0da603b79b61..9bf9055da29c 100644
> --- a/tools/perf/builtin-annotate.c
> +++ b/tools/perf/builtin-annotate.c
> @@ -180,7 +180,7 @@ find_next:
>                          * symbol, free he->ms.sym->src to signal we already
>                          * processed this symbol.
>                          */
> -                       zfree(&notes->src);
> +                       //zfree(&notes->src);
>                 }
>         }
>  }
> diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
> index 3aa555ff9d89..7fb2cd70f91a 100644
> --- a/tools/perf/util/annotate.c
> +++ b/tools/perf/util/annotate.c
> @@ -1260,8 +1260,8 @@ int symbol__annotate_printf(struct symbol *sym, struct map *map,
>         if (perf_evsel__is_group_event(evsel))
>                 width *= evsel->nr_members;
>
> -       printf(" %-*.*s|        Source code & Disassembly of %s\n",
> -              width, width, "Percent", d_filename);
> +       printf(" %-*.*s|        Source code & Disassembly of %s for %s samples\n",
> +              width, width, "Percent", d_filename, perf_evsel__name(evsel));
>         printf("-%-*.*s-------------------------------------\n",
>                width+namelen, width+namelen, graph_dotted_line);
>
That works, except for the formatting of the graph_dotted_line.
Something like below worked for me:

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 2ac6a54..0f13552 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -1226,7 +1226,7 @@ int symbol__annotate_printf(struct symbol *sym,
struct map *map,
        int more = 0;
        u64 len;
        int width = 8;
-       int namelen;
+       int namelen, evtlen;

        filename = strdup(dso->long_name);
        if (!filename)
@@ -1239,14 +1239,17 @@ int symbol__annotate_printf(struct symbol
*sym, struct map *map,

        len = symbol__size(sym);
        namelen = strlen(d_filename);
+       evtlen = (int)strlen( perf_evsel__name(evsel)) + 5 + 9;

        if (perf_evsel__is_group_event(evsel))
                width *= evsel->nr_members;

-       printf(" %-*.*s|        Source code & Disassembly of %s\n",
-              width, width, "Percent", d_filename);
+       //printf(" %-*.*s|      Source code & Disassembly of %s\n",
width, width, "Percent", d_filename);
+       printf(" %-*.*s|        Source code & Disassembly of %s for %s
samples\n",
+              width, width, "Percent", d_filename, perf_evsel__name(evsel));
+
        printf("-%-*.*s-------------------------------------\n",
-              width+namelen, width+namelen, graph_dotted_line);
+              width+namelen+evtlen, width+namelen+evtlen, graph_dotted_line);
