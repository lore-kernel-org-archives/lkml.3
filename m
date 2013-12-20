Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab3LTBUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 20:20:42 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56289 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841Ab3LTBUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 20:20:40 -0500
X-AuditID: 9c930179-b7bedae000000f15-87-52b39b65e2d4
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHSET 0/6] perf tools: A couple of TUI improvements
References: <1387436411-20160-1-git-send-email-namhyung@kernel.org>
	<20131219121435.GB11279@gmail.com>
Date: Fri, 20 Dec 2013 10:20:37 +0900
In-Reply-To: <20131219121435.GB11279@gmail.com> (Ingo Molnar's message of
	"Thu, 19 Dec 2013 13:14:35 +0100")
Message-ID: <87vbyke2sa.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Thu, 19 Dec 2013 13:14:35 +0100, Ingo Molnar wrote:
> * Namhyung Kim <namhyung@kernel.org> wrote:
>
>> Hello,
>> 
>> I was playing with TUI code and added two new windows.  One for
>> showing log messages and another for showing header information.
>> (Maybe they can be implemented on the GTK code too someday.)
>> 
>> Please try to use it! :)
>> 
>> I put the patches on 'perf/tui-v1' branch in my tree:
>> 
>>   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
>> 
>> Any feedbacks are more than welcome, thanks
>> Namhyung
>
> In the morning haze it took me some time to figure out that typing 'l' 
> gives leads to the log window, 'i' to the header information.
>
> 'l' seems to work (no log messages though :-), but in perf-top 'i' 
> segfaulted:
>
>   comet:~/tip/tools/perf> perf top
>   perf: Segmentation fault

Ah, forgot to test perf top - I just played with perf report at this
time. :-/

>
> Program received signal SIGSEGV, Segmentation fault.
> [Switching to Thread 0x7ffff0d39700 (LWP 14785)]
> perf_header__fprintf_info (session=session@entry=0x957bf0, fp=fp@entry=0x7fffec000a30, full=full@entry=true) at util/header.c:2195
> 2195            int fd = perf_data_file__fd(session->file);
> Missing separate debuginfos, use: debuginfo-install audit-libs-2.3.2-1.fc19.x86_64 bzip2-libs-1.0.6-8.fc19.x86_64 elfutils-libelf-0.156-5.fc19.x86_64 elfutils-libs-0.156-5.fc19.x86_64 glibc-2.17-19.fc19.x86_64 libgcc-4.8.2-1.fc19.x86_64 libunwind-1.1-2.fc19.x86_64 nss-softokn-freebl-3.15.2-2.fc19.x86_64 numactl-libs-2.0.8-4.fc19.x86_64 perl-libs-5.16.3-266.fc19.x86_64 python-libs-2.7.5-9.fc19.x86_64 slang-2.2.4-8.fc19.x86_64 xz-libs-5.1.2-4alpha.fc19.x86_64 zlib-1.2.7-10.fc19.x86_64
> (gdb) bt
> #0  perf_header__fprintf_info (session=session@entry=0x957bf0, fp=fp@entry=0x7fffec000a30, full=full@entry=true) at util/header.c:2195
> #1  0x00000000004ce3fe in tui__header_window (env=env@entry=0x957c30) at ui/browsers/header.c:92
> #2  0x00000000004cbdfd in perf_evsel__hists_browse (evsel=evsel@entry=0x957560, nr_events=nr_events@entry=1, 
>     helpline=helpline@entry=0x57db88 "For a higher level overview, try: perf top --sort comm,dso", ev_name=0x957870 "cycles", left_exits=left_exits@entry=false, 
>     hbt=hbt@entry=0x7ffff0d38ea0, min_pcnt=min_pcnt@entry=0, env=env@entry=0x957c30) at ui/browsers/hists.c:1491
> #3  0x00000000004cd5a5 in perf_evlist__tui_browse_hists (evlist=0x8e5930, help=help@entry=0x57db88 "For a higher level overview, try: perf top --sort comm,dso", 
>     hbt=hbt@entry=0x7ffff0d38ea0, min_pcnt=0, env=0x957c30) at ui/browsers/hists.c:1957
> #4  0x0000000000433b48 in display_thread_tui (arg=0x7fffffffb150) at builtin-top.c:584
> #5  0x0000003e59407c53 in start_thread () from /lib64/libpthread.so.0
> #6  0x0000003e590f5dbd in clone () from /lib64/libc.so.6
> (gdb) 
>
> I suspect it got surprised by perf top not having a header per se? 
> Still it might make sense to also robustify 
> perf_header__fprintf_info() against segfaulting and such.

Right.  To be precise, perf top do have header.env but not set the
actual info in it.  I had to check it, sorry.  The patch below will fix
the problem.


>From 451a267fb2243860f62390151cc156a9eab7d317 Mon Sep 17 00:00:00 2001
From: Namhyung Kim <namhyung.kim@lge.com>
Date: Fri, 20 Dec 2013 09:14:23 +0900
Subject: [PATCH 1/3] perf ui/tui: fixup for header window on perf-top

It should check whether header.env is valid.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index d710c6403a14..c25859cae32d 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1488,7 +1488,9 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			tui__log_window();
 			continue;
 		case 'i':
-			tui__header_window(env);
+			/* env->arch is NULL for live-mode (i.e. perf top) */
+			if (env->arch)
+				tui__header_window(env);
 			continue;
 		case K_F1:
 		case 'h':
-- 
1.7.11.7


I'll fold it to the original patch.

>
> But it's a nice feature nevertheless!

Thanks! :)

>
> Btw., it would be nice if 'P' worked on these screens, so any 
> interesting data can be extracted! Cut & paste is usually a PITA due 
> to the graphical TUI characters.

Ah, okay.  I think it should be easy, will cook a patch.

>
> Btw., in case you are taking TUI usability bugreports, here's a few I 
> noticed while playing with your changes:

Hmm.. I'll take a look at them next week too. :)

>
> 1)
>
> In histogram view it would be nice if 'P' gave some status bar 
> indication that it just wrote to perf.hist.0 or so - otherwise the 
> user is kept in the dark.
>
> 2)
>
> Likewise, in a TUI every keypress must produce some tangible feedback 
> to the user. Try hitting 'o' for example - it should probably output 
> into the status bar that 'o' is not a bound keypress or so.
>
> 3)
>
> Same goes for page up / page down in histogram view if we are at the 
> end of the list: some low-key, single-character feedback should be 
> given that the keypress was seen but we are at the end of the list. 
> For exampe the scrollbar 'diamond' character could briefly 
> inverse-flash or so.
>
> Thanks,
>
> 	Ingo
