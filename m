Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaAPB0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 20:26:50 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:65080 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbaAPBZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 20:25:13 -0500
X-AuditID: 9c930197-b7b7cae000000e34-19-52d734f6babd
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 3/5] perf report: Add --percentage option
References: <1389674599-28227-1-git-send-email-namhyung@kernel.org>
	<1389674599-28227-4-git-send-email-namhyung@kernel.org>
	<87zjmy2ryj.fsf@tassilo.jf.intel.com>
	<20140114212555.GE29798@ghostprotocols.net>
	<87ob3e9eds.fsf@sejong.aot.lge.com>
	<20140115183003.GC9750@ghostprotocols.net>
Date: Thu, 16 Jan 2014 10:25:10 +0900
In-Reply-To: <20140115183003.GC9750@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Wed, 15 Jan 2014 15:30:03 -0300")
Message-ID: <878uug90qx.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jan 2014 15:30:03 -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Jan 15, 2014 at 11:18:23AM +0900, Namhyung Kim escreveu:
>> On Tue, 14 Jan 2014 18:25:55 -0300, Arnaldo Carvalho de Melo wrote:
>> > Em Tue, Jan 14, 2014 at 01:07:00PM -0800, Andi Kleen escreveu:
>> >> Namhyung Kim <namhyung@kernel.org> writes:
>> >> >  
>> >> > +--percentage::
>> >> > +	Determine how to display the overhead percentage of filtered
>> >> > entries.
>> >> 
>> >> This should describe also what a "filtered entry" exactly is. It's not clear
>> >> even to me.
>> >
>> > Yeah, the text should give some context, mentioning the "Zoom"
>> > operations that can be done in the TUI (DSO, thread, etc) that allows
>> > applying what he is calling "filters".`
>> 
>> Ah, okay.
>> 
>> How about this:
>
> Ack, much clearer, minor things below:


Here goes an update :)


>From abd3ee476573087339794730bf8797913cf1a909 Mon Sep 17 00:00:00 2001
From: Namhyung Kim <namhyung@kernel.org>
Date: Tue, 14 Jan 2014 11:52:48 +0900
Subject: [PATCH] perf report: Add --percentage option

The --percentage option is for controlling overhead percentage
displayed.  It can only receive either of "relative" or "absolute".

"relative" means it's relative to filtered entries only so that the
sum of shown entries will be always 100%.  "absolute" means it retains
the original value before and after the filter is applied.

  $ perf report -s comm
  # Overhead       Command
  # ........  ............
  #
      74.19%           cc1
       7.61%           gcc
       6.11%            as
       4.35%            sh
       4.14%          make
       1.13%        fixdep
  ...

  $ perf report -s comm -c cc1,gcc --percentage absolute
  # Overhead       Command
  # ........  ............
  #
      74.19%           cc1
       7.61%           gcc

  $ perf report -s comm -c cc1,gcc --percentage relative
  # Overhead       Command
  # ........  ............
  #
      90.69%           cc1
       9.31%           gcc

Note that it has zero effect if no filter was applied.

Suggested-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-report.txt | 24 ++++++++++++++++++------
 tools/perf/builtin-report.c              | 16 ++++++++++++++++
 2 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 8eab8a4bdeb8..09af66298564 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -25,10 +25,6 @@ OPTIONS
 --verbose::
         Be more verbose. (show symbol address, etc)
 
--d::
---dsos=::
-	Only consider symbols in these dsos. CSV that understands
-	file://filename entries.
 -n::
 --show-nr-samples::
 	Show the number of samples for each symbol
@@ -42,11 +38,18 @@ OPTIONS
 -c::
 --comms=::
 	Only consider symbols in these comms. CSV that understands
-	file://filename entries.
+	file://filename entries.  This option will affect the percentage of
+	the overhead column.  See --percentage for more info.
+-d::
+--dsos=::
+	Only consider symbols in these dsos. CSV that understands
+	file://filename entries.  This option will affect the percentage of
+	the overhead column.  See --percentage for more info.
 -S::
 --symbols=::
 	Only consider these symbols. CSV that understands
-	file://filename entries.
+	file://filename entries.  This option will affect the percentage of
+	the overhead column.  See --percentage for more info.
 
 --symbol-filter=::
 	Only show symbols that match (partially) with this filter.
@@ -237,6 +240,15 @@ OPTIONS
 	Do not show entries which have an overhead under that percent.
 	(Default: 0).
 
+--percentage::
+	Determine how to display the overhead percentage of filtered entries.
+	Filters can be applied by --comms, --dsos and/or --symbols options and
+	Zoom operations on the TUI (thread, dso, etc).
+
+	"relative" means it's relative to filtered entries only so that the
+	sum of shown entries will be always 100%.  "absolute" means it retains
+	the original value before and after the filter is applied.
+
 --header::
 	Show header information in the perf.data file.  This includes
 	various information like hostname, OS and perf version, cpu/mem
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index dddacb0056e3..cb81d45e514c 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -699,6 +699,20 @@ parse_percent_limit(const struct option *opt, const char *str,
 	return 0;
 }
 
+static int
+parse_percentage(const struct option *opt __maybe_unused, const char *str,
+		 int unset __maybe_unused)
+{
+	if (!strcmp(str, "relative"))
+		symbol_conf.filter_relative = true;
+	else if (!strcmp(str, "absolute"))
+		symbol_conf.filter_relative = false;
+	else
+		return -1;
+
+	return 0;
+}
+
 int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	struct perf_session *session;
@@ -821,6 +835,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_BOOLEAN(0, "mem-mode", &report.mem_mode, "mem access profile"),
 	OPT_CALLBACK(0, "percent-limit", &report, "percent",
 		     "Don't show entries under that percent", parse_percent_limit),
+	OPT_CALLBACK(0, "percentage", NULL, "relative|absolute",
+		     "how to display percentage of filtered entries", parse_percentage),
 	OPT_END()
 	};
 	struct perf_data_file file = {
-- 
1.7.11.7

