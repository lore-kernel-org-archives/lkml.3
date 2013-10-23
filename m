Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab3JWHzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 03:55:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56001 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab3JWHzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 03:55:15 -0400
Date: Wed, 23 Oct 2013 00:54:57 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-09600e0f9ebb06235b852a646a3644b7d4a71aca@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1381802517-18812-1-git-send-email-namhyung@kernel.org>
References: <1381802517-18812-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Compare dso'
 s also when comparing symbols
Git-Commit-ID: 09600e0f9ebb06235b852a646a3644b7d4a71aca
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 23 Oct 2013 00:55:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  09600e0f9ebb06235b852a646a3644b7d4a71aca
Gitweb:     http://git.kernel.org/tip/09600e0f9ebb06235b852a646a3644b7d4a71aca
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 15 Oct 2013 11:01:56 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 21 Oct 2013 17:33:23 -0300

perf tools: Compare dso's also when comparing symbols

Linus reported that sometimes 'perf report -s symbol' exits without any
message on TUI.  David and Jiri found that it's because it failed to add
a hist entry due to an invalid symbol length.

It turns out that sorting by symbol (address) was broken since it only
compares symbol addresses.  The symbol address is a relative address
within a dso thus just checking its address can result in merging
unrelated symbols together.  Fix it by checking dso before comparing
symbol address.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1381802517-18812-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 32c5637..1f9821d 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -182,9 +182,19 @@ static int64_t _sort__sym_cmp(struct symbol *sym_l, struct symbol *sym_r)
 static int64_t
 sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
 {
+	int64_t ret;
+
 	if (!left->ms.sym && !right->ms.sym)
 		return right->level - left->level;
 
+	/*
+	 * comparing symbol address alone is not enough since it's a
+	 * relative address within a dso.
+	 */
+	ret = sort__dso_cmp(left, right);
+	if (ret != 0)
+		return ret;
+
 	return _sort__sym_cmp(left->ms.sym, right->ms.sym);
 }
 
