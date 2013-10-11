Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab3JKWEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 18:04:48 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:59766 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab3JKWEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 18:04:47 -0400
Message-ID: <525875FB.1090104@gmail.com>
Date: Fri, 11 Oct 2013 16:04:43 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHSET 0/8] perf tools: Fix scalability problem on callchain
 merging (v5)
References: <1381468543-25334-1-git-send-email-namhyung@kernel.org> <20131011055829.GA4975@gmail.com> <20131011073448.GA11064@krava.redhat.com> <52581511.2010909@gmail.com> <52581737.8090309@gmail.com> <87wqljxyqg.fsf@tassilo.jf.intel.com>
In-Reply-To: <87wqljxyqg.fsf@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/13 3:51 PM, Andi Kleen wrote:
> David Ahern <dsahern@gmail.com> writes:
>
>> On 10/11/13 9:11 AM, David Ahern wrote:
>>> It would be nice to fix the callchain arg handler to not attempt to
>>> process the next argument if it is not fp or dwarf.
>>
>> Specifically, something like this which maintains syntax and default
>> fp option:
>
> Yes please! This happens to me all the time too
>
> (usually I train myself to use -g --, but i still sometimes forget)
>
> It still wouldn't handle -ga, but naked -g seems to be the common case.

grrr... you're right. I ran right through that. With -ga the 'a' gets lost.

This seems to do the trick:

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 92ca541..726d2c2 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -721,7 +721,11 @@ int record_parse_callchain_opt(const struct option 
*opt,
         return 0;

     /* We specified default option if none is provided. */
-   BUG_ON(!arg);
+   if (!arg) {
+       opts->call_graph = CALLCHAIN_FP;
+       return 0;
+   }
+

     /* We need buffer that we know we can write to. */
     buf = malloc(strlen(arg) + 1);
@@ -766,8 +770,8 @@ int record_parse_callchain_opt(const struct option *opt,
                      opts->stack_dump_size);
  #endif /* HAVE_LIBUNWIND_SUPPORT */
         } else {
-           pr_err("callchain: Unknown -g option "
-                  "value: %s\n", arg);
+           opts->call_graph = CALLCHAIN_FP;
+           ret = 0;
             break;
         }

@@ -855,7 +859,7 @@ const struct option record_options[] = {
              perf_evlist__parse_mmap_pages),
     OPT_BOOLEAN(0, "group", &record.opts.group,
             "put the counters into a counter group"),
-   OPT_CALLBACK_DEFAULT('g', "call-graph", &record.opts,
+   OPT_CALLBACK_DEFAULT_NOOPT('g', "call-graph", &record.opts,
                  "mode[,dump_size]", record_callchain_help,
                  &record_parse_callchain_opt, "fp"),
     OPT_INCR('v', "verbose", &verbose,
