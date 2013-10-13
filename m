Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab3JMKZ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 06:25:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166Ab3JMKZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 06:25:56 -0400
Date: Sun, 13 Oct 2013 12:25:21 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHSET 0/8] perf tools: Fix scalability problem on callchain
 merging (v5)
Message-ID: <20131013102521.GA1044@krava.brq.redhat.com>
References: <1381468543-25334-1-git-send-email-namhyung@kernel.org>
 <20131011055829.GA4975@gmail.com>
 <20131011073448.GA11064@krava.redhat.com>
 <52581511.2010909@gmail.com>
 <52581737.8090309@gmail.com>
 <87wqljxyqg.fsf@tassilo.jf.intel.com>
 <525875FB.1090104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525875FB.1090104@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 04:04:43PM -0600, David Ahern wrote:
> On 10/11/13 3:51 PM, Andi Kleen wrote:
> >David Ahern <dsahern@gmail.com> writes:
> >
> >>On 10/11/13 9:11 AM, David Ahern wrote:
> >>>It would be nice to fix the callchain arg handler to not attempt to
> >>>process the next argument if it is not fp or dwarf.
> >>
> >>Specifically, something like this which maintains syntax and default
> >>fp option:
> >
> >Yes please! This happens to me all the time too
> >
> >(usually I train myself to use -g --, but i still sometimes forget)
> >
> >It still wouldn't handle -ga, but naked -g seems to be the common case.
> 
> grrr... you're right. I ran right through that. With -ga the 'a' gets lost.
> 
> This seems to do the trick:
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 92ca541..726d2c2 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -721,7 +721,11 @@ int record_parse_callchain_opt(const struct
> option *opt,
>         return 0;
> 
>     /* We specified default option if none is provided. */
> -   BUG_ON(!arg);
> +   if (!arg) {
> +       opts->call_graph = CALLCHAIN_FP;
> +       return 0;
> +   }
> +
> 
>     /* We need buffer that we know we can write to. */
>     buf = malloc(strlen(arg) + 1);
> @@ -766,8 +770,8 @@ int record_parse_callchain_opt(const struct option *opt,
>                      opts->stack_dump_size);
>  #endif /* HAVE_LIBUNWIND_SUPPORT */
>         } else {
> -           pr_err("callchain: Unknown -g option "
> -                  "value: %s\n", arg);
> +           opts->call_graph = CALLCHAIN_FP;
> +           ret = 0;
>             break;
>         }
> 
> @@ -855,7 +859,7 @@ const struct option record_options[] = {
>              perf_evlist__parse_mmap_pages),
>     OPT_BOOLEAN(0, "group", &record.opts.group,
>             "put the counters into a counter group"),
> -   OPT_CALLBACK_DEFAULT('g', "call-graph", &record.opts,
> +   OPT_CALLBACK_DEFAULT_NOOPT('g', "call-graph", &record.opts,

hum, this disables the option completely, no?

The issue is a consequence of allowing '-g' to have carry
a value (dwarf,fp). Maybe we could have some sort of new
OPT_OPTION type, where if its value is not recognized it
would be passed to next option.

Or the way Ingo suggested earlier:

---
So, why not keep -g as a shortcut to whatever default call-graph profiling
we want to provide (note, this does not mean it always has to be 'fp'),
and use --call-graph for more specific variants?

a .perfconfig value could even set the default for '-g', so that you don't
have to type '--call-graph dwarf' all the time.
---

I'll try to come up with something later today

jirka
