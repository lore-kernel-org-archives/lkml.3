Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab3J1IFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 04:05:18 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:63713 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab3J1IFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 04:05:15 -0400
From: Azat Khuzhin <a3at.mail@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Azat Khuzhin <a3at.mail@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH] perf probe: add '--demangle'/'--no-demangle'
Date: Mon, 28 Oct 2013 12:04:24 +0400
Message-Id: <1382947464-31266-1-git-send-email-a3at.mail@gmail.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 tools/perf/builtin-probe.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index e8a66f9..7620f2e 100644
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
1.8.4.rc3

