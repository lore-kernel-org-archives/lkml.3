Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab3KOH00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 02:26:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50376 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756266Ab3KOH0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 02:26:06 -0500
Date: Thu, 14 Nov 2013 23:25:45 -0800
From: tip-bot for Azat Khuzhin <tipbot@zytor.com>
Message-ID: <tip-35e17b2450e09968f9702d4048c228199af171bc@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, a3at.mail@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        a3at.mail@gmail.com, tglx@linutronix.de
In-Reply-To: <1382947464-31266-1-git-send-email-a3at.mail@gmail.com>
References: <1382947464-31266-1-git-send-email-a3at.mail@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Add '--demangle'/'--no-demangle'
Git-Commit-ID: 35e17b2450e09968f9702d4048c228199af171bc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 14 Nov 2013 23:25:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  35e17b2450e09968f9702d4048c228199af171bc
Gitweb:     http://git.kernel.org/tip/35e17b2450e09968f9702d4048c228199af171bc
Author:     Azat Khuzhin <a3at.mail@gmail.com>
AuthorDate: Mon, 28 Oct 2013 12:04:24 +0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 14 Nov 2013 16:06:28 -0300

perf probe: Add '--demangle'/'--no-demangle'

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
index 89acc17..6ea9e85 100644
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
