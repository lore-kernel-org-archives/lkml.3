Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbbAJKeA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 05:34:00 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:43772 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbbAJKd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 05:33:59 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 1/4] perf tools: Allow use of an exclusive option more than once
Date: Sat, 10 Jan 2015 19:33:45 +0900
Message-Id: <1420886028-15135-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The exclusive options are to prohibit use of conflicting options at the
same time.  But it had a side effect that it also limits a such option
can be used at most once.  Currently the only user of the flag is perf
probe and it allows to use such options more than once, but when one
tries to use it, perf will fail like below:

  $ sudo perf probe -x /lib/libc-2.20.so --add malloc --add free
    Error: option `add' cannot be used with add
  ...

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/parse-options.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/parse-options.c b/tools/perf/util/parse-options.c
index f62dee7bd924..4a015f77e2b5 100644
--- a/tools/perf/util/parse-options.c
+++ b/tools/perf/util/parse-options.c
@@ -46,7 +46,7 @@ static int get_value(struct parse_opt_ctx_t *p,
 		return opterror(opt, "is not usable", flags);
 
 	if (opt->flags & PARSE_OPT_EXCLUSIVE) {
-		if (p->excl_opt) {
+		if (p->excl_opt && p->excl_opt != opt) {
 			char msg[128];
 
 			if (((flags & OPT_SHORT) && p->excl_opt->short_name) ||
-- 
2.2.1

