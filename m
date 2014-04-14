Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbaDNOzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:55:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46615 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbaDNOxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:53:46 -0400
Date: Mon, 14 Apr 2014 07:53:13 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-182c228ebcf1ac67a44e62236d8f7a8a9a3c5699@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        acme@kernel.org, namhyung@kernel.org, jolsa@redhat.com,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, acme@kernel.org, namhyung@kernel.org,
        jolsa@redhat.com, masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de
In-Reply-To: <20140402054831.19080.27006.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140402054831.19080.27006.stgit@ltc230.yrl.intra.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe:
  Fix to handle errors in line_range searching
Git-Commit-ID: 182c228ebcf1ac67a44e62236d8f7a8a9a3c5699
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  182c228ebcf1ac67a44e62236d8f7a8a9a3c5699
Gitweb:     http://git.kernel.org/tip/182c228ebcf1ac67a44e62236d8f7a8a9a3c5699
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Wed, 2 Apr 2014 14:48:31 +0900
Committer:  Jiri Olsa <jolsa@redhat.com>
CommitDate: Mon, 14 Apr 2014 12:55:39 +0200

perf probe: Fix to handle errors in line_range searching

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

Reported-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20140402054831.19080.27006.stgit@ltc230.yrl.intra.hitachi.co.jp
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/probe-finder.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 3bf0c8c..fae274e 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1475,14 +1475,15 @@ static int find_line_range_by_line(Dwarf_Die *sp_die, struct line_finder *lf)
 
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
