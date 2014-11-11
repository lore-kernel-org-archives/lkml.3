Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaKKEZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 23:25:00 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:49187 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbaKKEY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 23:24:59 -0500
MIME-Version: 1.0
In-Reply-To: <20141110121105.GL3337@twins.programming.kicks-ass.net>
References: <1415337606-2186-1-git-send-email-namhyung@kernel.org>
 <20141107082723.GB23531@worktop.programming.kicks-ass.net>
 <1415372259.1648.51.camel@leonhard> <20141107173718.GD29390@twins.programming.kicks-ass.net>
 <87mw7zva3c.fsf@sejong.aot.lge.com> <20141110121105.GL3337@twins.programming.kicks-ass.net>
From: Namhyung Kim <namhyung@kernel.org>
Date: Tue, 11 Nov 2014 13:24:38 +0900
X-Google-Sender-Auth: nOjq0CrQio9Y1-gpBOws417VWXA
Message-ID: <CAM9d7cgCzkh3_26=g0+6yUr-xBbk7_F8QP2e1sEkYw9o5OTmjw@mail.gmail.com>
Subject: Re: [PATCH 1/3] perf tools: Allow vmlinux to fallback to kallsyms on NO_LIBELF=1
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Mon, Nov 10, 2014 at 9:11 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Nov 10, 2014 at 03:33:11PM +0900, Namhyung Kim wrote:
>> Hmm.. I don't think it's specific to the minimal elf parser.  The return
>> value of dso__load_sym() is a number of symbols found so when it sees a
>> dso with 0 symbols it'll fall back to the next option IMHO (not
>> tested).  Did you see a problem with the current code?
>
> So your patch:
>
> +++ b/tools/perf/util/symbol-minimal.c
> @@ -335,6 +335,9 @@ int dso__load_sym(struct dso *dso, struct map *map __maybe_unused,
>         unsigned char *build_id[BUILD_ID_SIZE];
>         int ret;
>
> +       if (dso->kernel)
> +               return 0;  /* always use kallsyms */
> +
>
> changes the symbol-minimal.c file to add this exception. That is very
> much specific to the minimal elf parser, or am I just seeing things?

What minimal parser does here is just skip kernel dsos (vmlinux) since
it didn't deal with all the details of parsing vmlinux currently.


>
> What I was saying, why not have a util/symbol.c change that disregards
> all DSOs with 0 symbols in.

The util/symbol.c doesn't need this because it can handle vmlinux
reliably.  So after reading symbol table, it'll use the dso if it
actually contains symbols or fallback to next dso if it has 0 symbols.
IOW it already disregards all dsos with 0 symbols in.

-- 
Thanks,
Namhyung
