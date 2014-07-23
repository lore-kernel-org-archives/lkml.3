Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbaGWHkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 03:40:40 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:53610 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757186AbaGWHki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 03:40:38 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET 0/6] perf tools: Honor column width setting
References: <1404883694-5342-1-git-send-email-namhyung@kernel.org>
	<20140721090755.GA8865@krava.redhat.com>
Date: Wed, 23 Jul 2014 16:40:36 +0900
In-Reply-To: <20140721090755.GA8865@krava.redhat.com> (Jiri Olsa's message of
	"Mon, 21 Jul 2014 11:07:55 +0200")
Message-ID: <87r41cjzez.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Mon, 21 Jul 2014 11:07:55 +0200, Jiri Olsa wrote:
> On Wed, Jul 09, 2014 at 02:28:08PM +0900, Namhyung Kim wrote:
>> Hello,
>> 
>> This patchset is to control perf report/top output column width by
>> -w/--column-widths option so that it can fit into the terminal size.
>> The -w option is there for perf report but it ignored by recent output
>> field changed due to some reason.  This patchset fixes it and supports
>> perf top also.
>> 
>> This is sometimes useful if your terminal is small and there's some
>> C++ applications which have amazingly long symbol names.  Without this
>> patchset user might not see those symbols on TUI, since it maps
>> left/right arrow keys to other functions.
>> 
>> The -w option sets column width starting from the first column
>> (overhead or optional overhead_children column unless -F option is
>> given).  It doesn't make sense to limit those overhead columns so it's
>> not a hard-limit for them.  But it *is* a hard-limit for other columns
>> such as comm, dso, symbol, and so on.  One can use 0 not to
>> limit/force a width for those columns.
>
> hi,
> I've got broken TUI output for "perf report --group" 
>
> Samples: 17  of event 'anon group { cycles, instructions }', Event count (approx.): 9145256
>  56.44% 31.59%  ls  libc-2.17.so       [.] __strcoll_l
>  39.94% 0.00%  ls  ld-2.17.so         [.] _dl_new_object
>  3.48% 0.00%  ls  [kernel.kallsyms]  [k] setup_arg_pages
>  0.14% 0.33%  ls  [kernel.kallsyms]  [k] native_write_msr_safe
>  0.00% 30.17%  ls  [kernel.kallsyms]  [k] security_inode_permission
>  0.00% 29.78%  ls  ls                 [.] indent
>  0.00% 8.12%  ls  [kernel.kallsyms]  [k] __slab_alloc
>
> I have 'show-headers' set to false in ~/.perfconfig and the output
> got fixed after displaying headers by pressing 'H'

Argh, you're right.  It should be fixed with this patch:

Thanks,
Namhyung



>From a8fffc7802402d5ddd03e02956304199fa20fae9 Mon Sep 17 00:00:00 2001
From: Namhyung Kim <namhyung@kernel.org>
Date: Wed, 23 Jul 2014 16:20:45 +0900
Subject: [PATCH] perf tools: Fix column alignment when headers aren't shown on
 TUI

If user sets ui.show-headers config option to false, it didn't
calculate default column width so it broke the alignment.  This is
because it does the calculation just before showing headers.

Move it to the beginning of the hist browser so that it can be called
regardless of the config option.

Reported-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index f0ef031558dd..ab9ca221fc2c 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -853,9 +853,6 @@ static int hists__scnprintf_headers(char *buf, size_t size, struct hists *hists)
 		if (perf_hpp__should_skip(fmt))
 			continue;
 
-		/* We need to ensure length of the columns header. */
-		perf_hpp__reset_width(fmt, hists);
-
 		ret = fmt->header(fmt, &dummy_hpp, hists_to_evsel(hists));
 		if (advance_hpp_check(&dummy_hpp, ret))
 			break;
@@ -1504,6 +1501,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 	char buf[64];
 	char script_opt[64];
 	int delay_secs = hbt ? hbt->refresh : 0;
+	struct perf_hpp_fmt *fmt;
 
 #define HIST_BROWSER_HELP_COMMON					\
 	"h/?/F1        Show this window\n"				\
@@ -1553,6 +1551,9 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 
 	memset(options, 0, sizeof(options));
 
+	perf_hpp__for_each_format(fmt)
+		perf_hpp__reset_width(fmt, hists);
+
 	if (symbol_conf.col_width_list_str)
 		perf_hpp__set_user_width(symbol_conf.col_width_list_str);
 
-- 
2.0.0

