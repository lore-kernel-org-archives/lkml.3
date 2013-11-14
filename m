Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338Ab3KNUZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 15:25:49 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36312 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919Ab3KNUZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 15:25:28 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Azat Khuzhin <a3at.mail@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/10] perf probe: Add '--demangle'/'--no-demangle'
Date: Thu, 14 Nov 2013 17:25:14 -0300
Message-Id: <1384460715-23198-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384460715-23198-1-git-send-email-acme@infradead.org>
References: <1384460715-23198-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Azat Khuzhin <a3at.mail@gmail.com>

You can't pass demangled name into "perf probe", because of special chars:
./perf probe -f -x /tmp/a.out 'foo(int)'
Semantic error :There is non-digit char in line number.

And you can't even pass without demangling (because it search symbol in
DSO with demangle=true):
./perf probe -f -x /tmp/a.out _Z3fooi
no symbols found in /tmp/a.out, maybe install a debug package?

However:
nm /tmp/a.out | grep foo
000000000040056d T _Z3fooi

After this patch, using the next command:
./perf probe -f --no-demangle -x /tmp/a.out _Z3fooi

probe will be successfully added.

Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1382947464-31266-1-git-send-email-a3at.mail@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-probe.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 89acc17cf2a0..6ea9e85bdc00 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -325,6 +325,8 @@ int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		     opt_set_filter),
 	OPT_CALLBACK('x', "exec", NULL, "executable|path",
 			"target executable name or path", opt_set_target),
+	OPT_BOOLEAN(0, "demangle", &symbol_conf.demangle,
+		    "Disable symbol demangling"),
 	OPT_END()
 	};
 	int ret;
-- 
1.8.1.4

