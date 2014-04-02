Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbaDBFsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 01:48:43 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:47325 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219AbaDBFsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 01:48:42 -0400
Subject: [PATCH -tip ] [BUGFIX] perf/probe: Fix to handle errors in
 line_range searching
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Namhyung Kim <namhyung.kim@lge.com>, LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>
Date: Wed, 02 Apr 2014 14:48:31 +0900
Message-ID: <20140402054831.19080.27006.stgit@ltc230.yrl.intra.hitachi.co.jp>
In-Reply-To: <CAM9d7cgtuh5BBi34WaZWxfJnNjnazZD+Aas37SsEad1pZxe_kg@mail.gmail.com>
References: <CAM9d7cgtuh5BBi34WaZWxfJnNjnazZD+Aas37SsEad1pZxe_kg@mail.gmail.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Namhyung reported(https://lkml.org/lkml/2014/4/1/89),
current perf-probe -L option doesn't handle errors in line-range
searching correctly. It causes a SEGV if an error occured in the
line-range searching.

  ----
  $ perf probe -x ./perf -v -L map__load
  Open Debuginfo file: /home/namhyung/project/linux/tools/perf/perf
  fname: util/map.c, lineno:153
  New line range: 153 to 2147483647
  path: (null)
  Segmentation fault (core dumped)
  ----

This is because line_range_inline_cb() ignores errors
from find_line_range_by_line() which means that lr->path is
already freed on the error path in find_line_range_by_line().
As a result, get_real_path() accesses the lr->path and it
causes a NULL pointer exception.

This fixes line_range_inline_cb() to handle the error correctly,
and report it to the caller.

Anyway, this just fixes a possible SEGV bug, Namhyung's patch
is also required.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reported-by: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/probe-finder.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index df02386..edcd2ff 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1473,14 +1473,15 @@ static int find_line_range_by_line(Dwarf_Die *sp_die, struct line_finder *lf)
 
 static int line_range_inline_cb(Dwarf_Die *in_die, void *data)
 {
-	find_line_range_by_line(in_die, data);
+	int ret = find_line_range_by_line(in_die, data);
 
 	/*
 	 * We have to check all instances of inlined function, because
 	 * some execution paths can be optimized out depends on the
-	 * function argument of instances
+	 * function argument of instances. However, if an error occurs,
+	 * it should be handled by the caller.
 	 */
-	return 0;
+	return ret < 0 ? ret : 0;
 }
 
 /* Search function definition from function name */


