Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109AbbAZRw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 12:52:29 -0500
Received: from mail.kernel.org ([198.145.29.136]:52933 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756758AbbAZRs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 12:48:26 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/26] perf tools: Allow use of an exclusive option more than once
Date: Mon, 26 Jan 2015 14:47:15 -0300
Message-Id: <1422294449-12735-13-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422294449-12735-1-git-send-email-acme@kernel.org>
References: <1422294449-12735-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The exclusive options are to prohibit use of conflicting options at the
same time.  But it had a side effect that it also limits a such option
can be used at most once.  Currently the only user of the flag is perf
probe and it allows to use such options more than once, but when one
tries to use it, perf will fail like below:

  $ sudo perf probe -x /lib/libc-2.20.so --add malloc --add free
    Error: option `add' cannot be used with add
  ...

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1420886028-15135-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.9.3

