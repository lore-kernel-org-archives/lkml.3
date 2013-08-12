Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab3HLKVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:21:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47928 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab3HLKVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:21:14 -0400
Date: Mon, 12 Aug 2013 03:20:28 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-3445432b7b24665cf4693fc4794c62d4d768a978@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1375875537-4509-6-git-send-email-adrian.hunter@intel.com>
References: <1375875537-4509-6-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: avoid SyS kernel syscall aliases
Git-Commit-ID: 3445432b7b24665cf4693fc4794c62d4d768a978
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:20:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3445432b7b24665cf4693fc4794c62d4d768a978
Gitweb:     http://git.kernel.org/tip/3445432b7b24665cf4693fc4794c62d4d768a978
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Wed, 7 Aug 2013 14:38:49 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:30 -0300

perf symbols: avoid SyS kernel syscall aliases

When removing duplicate symbols, prefer to remove syscall aliases
starting with SyS or compat_SyS.

A side-effect of that is that it results in slightly improved results
for the "vmlinux symtab matches kallsyms" test.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1375875537-4509-6-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 02718e7..ea62ecd 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -87,6 +87,7 @@ static int choose_best_symbol(struct symbol *syma, struct symbol *symb)
 {
 	s64 a;
 	s64 b;
+	size_t na, nb;
 
 	/* Prefer a symbol with non zero length */
 	a = syma->end - syma->start;
@@ -120,11 +121,21 @@ static int choose_best_symbol(struct symbol *syma, struct symbol *symb)
 	else if (a > b)
 		return SYMBOL_B;
 
-	/* If all else fails, choose the symbol with the longest name */
-	if (strlen(syma->name) >= strlen(symb->name))
+	/* Choose the symbol with the longest name */
+	na = strlen(syma->name);
+	nb = strlen(symb->name);
+	if (na > nb)
 		return SYMBOL_A;
-	else
+	else if (na < nb)
+		return SYMBOL_B;
+
+	/* Avoid "SyS" kernel syscall aliases */
+	if (na >= 3 && !strncmp(syma->name, "SyS", 3))
 		return SYMBOL_B;
+	if (na >= 10 && !strncmp(syma->name, "compat_SyS", 10))
+		return SYMBOL_B;
+
+	return SYMBOL_A;
 }
 
 void symbols__fixup_duplicate(struct rb_root *symbols)
