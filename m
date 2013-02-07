Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304Ab3BGGBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 01:01:33 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64004 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab3BGGBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 01:01:32 -0500
X-AuditID: 9c930197-b7ca4ae000006ba8-35-51134338f93b
From: Namhyung Kim <namhyung@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Anton Arapov <anton@redhat.com>,
        Frank Eigler <fche@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] (Was uprobes/perf: pre-filtering)
References: <20130204190225.GA10840@redhat.com>
	<20130206181044.GA3752@redhat.com> <20130206194218.GA11998@redhat.com>
Date: Thu, 07 Feb 2013 15:01:28 +0900
In-Reply-To: <20130206194218.GA11998@redhat.com> (Oleg Nesterov's message of
	"Wed, 6 Feb 2013 20:42:18 +0100")
Message-ID: <87bobwslvr.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

On Wed, 6 Feb 2013 20:42:18 +0100, Oleg Nesterov wrote:
> OK, builtin-record.c:record sets .target->uses_mmap == T, this is correct,
> we are going to use perf_mmap().
>
> But why do we need it? It is for perf_evlist__create_maps() to ensure we
> do not use cpu_map__dummy_new().
>
> But. Even if we use perf_mmap(), "event->cpu == -1 && !event->attr.inherit"
> is fine. And indeed, "perf record -e whatever -p1" creates a single counter
> with "cpu = -1" and this works. Because, damn, perf_evlist__config_attrs()
> notices "evlist->cpus->map[0] < 0" and sets "opts->no_inherit = true".
>
> But at the same time, this does not allow to do, say,
> "perf record -e whatever -C0 -p1". -C0 is simply ignored because when
> perf_evlist__create_maps() is called perf_target__has_task() == T due to "-p1".
>
> Not to mention, there is no way to trace init and the children it will
> fork...
>
> And otoh. "perf record -e whatever -i true" creates a counter for each
> cpu due to ->uses_mmap. This is suboptimal, but of course the hack like
>
> 	--- a/tools/perf/builtin-record.c
> 	+++ b/tools/perf/builtin-record.c
> 	@@ -1081,6 +1078,8 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
> 		if (!argc && perf_target__none(&rec->opts.target))
> 			usage_with_options(record_usage, record_options);
> 	 
> 	+	rec->opts.target.uses_mmap = !rec->opts.no_inherit;
> 	+
> 		if (rec->force && rec->append_file) {
> 			ui__error("Can't overwrite and append at the same time."
> 				  " You need to choose between -f and -A");
>
> should not be even discussed.
>
> And why opts->target.system_wide is only set by OPT_BOOLEAN("all-cpus") ?
> I meant, why I can't do "perf record -e whatever -C0" to create a "global"
> counter on CPU_0? This doesn't work because __cmd_record() sees !.system_wide
> and assumes we need perf_event__synthesize_thread_map() which silently fail.
>
> So I am sending a single patch to fix the problem which complicated my
> testing. It is trivial but I am not sure it correct, please review.

Yes, it's not clear how it handles above (-C0) case.  I think it should
be treated as a system_wide mode like --all-cpus (-a).  So we could set
->system_wide to true if -C is given and/or test perf_target__has_cpu()
for perf_event__synthesize_thread_map() or both.

Thanks,
Namhyung
