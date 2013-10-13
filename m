Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab3JMMfU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 08:35:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499Ab3JMMfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 08:35:18 -0400
Date: Sun, 13 Oct 2013 14:34:44 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHSET 0/8] perf tools: Fix scalability problem on callchain
 merging (v5)
Message-ID: <20131013123444.GB1044@krava.brq.redhat.com>
References: <1381468543-25334-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381468543-25334-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 02:15:35PM +0900, Namhyung Kim wrote:
> Hello,
> 
> This is a new version of callchain improvement patchset.  Basically
> it's almost same as v4 but rebased on current acme/perf/core and some
> functions are renamed as Frederic requested.
> 
> Now I'm hunting down a bug in 'perf report -s sym' which was found
> during the test, but I think it's not related to this change as it can
> be reproduced in earlier versions too.
> 
> I put this series on 'perf/callchain-v5' branch in my tree
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
hi,
while hunting another issue, I got segfault in callchains code:

Press '?' for help on key bindings
Program received signal SIGSEGV, Segmentation fault.
0x00000000004dcd89 in callchain_node__init_have_children_rb_tree (node=0x21a0330) at ui/browsers/hists.c:158
158                                     chain->ms.has_children = chain->list.next == &child->val &&
Missing separate debuginfos, use: debuginfo-install audit-libs-2.2.1-1.fc16.x86_64 elfutils-libelf-0.154-2.fc16.x86_64 elfutils-libs-0.154-2.fc16.x86_64 glibc-2.14.90-24.fc16.9.x86_64 libunwind-0.99-2.20110424git1e10c293.fc16.x86_64 nss-softokn-freebl-3.14.1-3.fc16.x86_64 numactl-2.0.7-2.fc16.x86_64 perl-libs-5.14.3-205.fc16.x86_64 python-libs-2.7.3-4.fc16.x86_64 slang-2.2.4-1.fc16.x86_64 xz-libs-5.1.1-1alpha.fc16.x86_64 zlib-1.2.5-7.fc16.x86_64
(gdb) bt
#0  0x00000000004dcd89 in callchain_node__init_have_children_rb_tree (node=0x21a0330) at ui/browsers/hists.c:158
#1  0x00000000004dcdf9 in callchain_node__init_have_children_rb_tree (node=0x1fa90a0) at ui/browsers/hists.c:162
#2  0x00000000004dcead in callchain_node__init_have_children (node=0x1fa90a0) at ui/browsers/hists.c:173
#3  0x00000000004dcf10 in callchain__init_have_children (root=0x1fa8ff8) at ui/browsers/hists.c:182
#4  0x00000000004dcf97 in hist_entry__init_have_children (he=0x1fa8f00) at ui/browsers/hists.c:190
#5  0x00000000004debf3 in hist_browser__show_entry (browser=0xa27010, entry=0x1fa8f00, row=66) at ui/browsers/hists.c:739
#6  0x00000000004df062 in hist_browser__refresh (browser=0xa27010) at ui/browsers/hists.c:823
#7  0x00000000004d8487 in __ui_browser__refresh (browser=0xa27010) at ui/browser.c:307
#8  0x00000000004d8681 in ui_browser__run (browser=0xa27010, delay_secs=0) at ui/browser.c:362
#9  0x00000000004dd6a7 in hist_browser__run (browser=0xa27010, ev_name=0xa26ff0 "cycles:pp", hbt=0x0) at ui/browsers/hists.c:335
#10 0x00000000004e0d9b in perf_evsel__hists_browse (evsel=0xa24b60, nr_events=1, 
    helpline=0x58e588 "For a higher level overview, try: perf report --sort comm,dso", ev_name=0xa26ff0 "cycles:pp", left_exits=false, 
    hbt=0x0, min_pcnt=0, env=0xa23f90) at ui/browsers/hists.c:1430
#11 0x00000000004e2605 in perf_evlist__tui_browse_hists (evlist=0xa242e0, 
    help=0x58e588 "For a higher level overview, try: perf report --sort comm,dso", hbt=0x0, min_pcnt=0, env=0xa23f90)
    at ui/browsers/hists.c:1950
#12 0x000000000042c3cb in __cmd_report (rep=0x7fffffffdf40) at builtin-report.c:590
#13 0x000000000042d84a in cmd_report (argc=0, argv=0x7fffffffe3a0, prefix=0x0) at builtin-report.c:988
#14 0x0000000000418fed in run_builtin (p=0x803c28, argc=5, argv=0x7fffffffe3a0) at perf.c:319
#15 0x0000000000419225 in handle_internal_command (argc=5, argv=0x7fffffffe3a0) at perf.c:376
#16 0x0000000000419371 in run_argv (argcp=0x7fffffffe27c, argv=0x7fffffffe270) at perf.c:420
#17 0x0000000000419658 in main (argc=5, argv=0x7fffffffe3a0) at perf.c:529


I got it on the original code, so I've tried your's
perf/callchain-v5 with same result.

I put perf archive and data output in here if you're interested:
http://people.redhat.com/jolsa/cc/

thanks,
jirka
