Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbaCKDeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 23:34:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879AbaCKDeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 23:34:02 -0400
Date: Tue, 11 Mar 2014 00:33:45 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        acme@ghostprotocols.net
Subject: Re: [BUG] perf annotate: not reporting all events profiles
Message-ID: <20140311033345.GA2631@infradead.org>
References: <CABPqkBS1A5d-=OBUL6wJA-MAAKK2UTS+_kbYyBN=d-hohSc89Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBS1A5d-=OBUL6wJA-MAAKK2UTS+_kbYyBN=d-hohSc89Q@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Mar 10, 2014 at 10:57:48PM +0100, Stephane Eranian escreveu:
> Arnaldo,
> 
> I am using tip.git perf and I do the following:
> 
> $ perf record -e cycles,instructions foo
> $ perf annotate --stdio
> 
> (no explicit grouping).
> 
> I only see the asm profile for the first event (cycles).
> I don't see a way to display the profile for the second
> event in the cmdline options.
> 
> Yet the code in __cmd_annotate() seems to  try and
> display all profiles.
> 
> If I use the TUI, it prompts me for the event at the first
> screen and I get different asm profiles.
> 
> So what is wrong?

That code went from supporting just one type of sample to suporting
groups, GTK+, TUI, etc, needs some work to untangle things up and make
it clearer...

But TUI works as expected, right?

That being said, try this patch, that is not optimal yet but allows you
to see the events.

I'll continue work on fixing up --stdio tomorrow.

- Arnaldo

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 0da603b79b61..9bf9055da29c 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -180,7 +180,7 @@ find_next:
 			 * symbol, free he->ms.sym->src to signal we already
 			 * processed this symbol.
 			 */
-			zfree(&notes->src);
+			//zfree(&notes->src);
 		}
 	}
 }
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 3aa555ff9d89..7fb2cd70f91a 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -1260,8 +1260,8 @@ int symbol__annotate_printf(struct symbol *sym, struct map *map,
 	if (perf_evsel__is_group_event(evsel))
 		width *= evsel->nr_members;
 
-	printf(" %-*.*s|	Source code & Disassembly of %s\n",
-	       width, width, "Percent", d_filename);
+	printf(" %-*.*s|	Source code & Disassembly of %s for %s samples\n",
+	       width, width, "Percent", d_filename, perf_evsel__name(evsel));
 	printf("-%-*.*s-------------------------------------\n",
 	       width+namelen, width+namelen, graph_dotted_line);
 
