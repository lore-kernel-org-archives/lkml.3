Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934471AbbA1Uty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:49:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759386AbbA1Utt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:49:49 -0500
Date: Wed, 28 Jan 2015 07:01:32 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-de4809999dac44c51e1f9ad892deb0336296dc4e@git.kernel.org>
Cc: namhyung@kernel.org, mingo@kernel.org, dsahern@gmail.com, hpa@zytor.com,
        jolsa@redhat.com, tglx@linutronix.de, acme@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com
Reply-To: acme@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, mingo@kernel.org, dsahern@gmail.com,
        hpa@zytor.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
In-Reply-To: <1421234288-22758-2-git-send-email-namhyung@kernel.org>
References: <1421234288-22758-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols:
  Return the first entry with a given name in find_by_name method
Git-Commit-ID: de4809999dac44c51e1f9ad892deb0336296dc4e
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

Commit-ID:  de4809999dac44c51e1f9ad892deb0336296dc4e
Gitweb:     http://git.kernel.org/tip/de4809999dac44c51e1f9ad892deb0336296dc4e
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Fri, 16 Jan 2015 15:31:28 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 21 Jan 2015 10:05:44 -0300

perf symbols: Return the first entry with a given name in find_by_name method

When a dso contains multiple symbols which have same name, current
dso__find_symbol_by_name() only finds an one of them and there's no way
to get the all symbols without going through the rbtree.

So make symbols__find_by_name() return the first entry with the given
name and the next patch in this series will provide a way to iterate
from there, by the name ordered rb_tree, till a suitable symbol is
found.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Link: http://lkml.kernel.org/r/1421234288-22758-2-git-send-email-namhyung@kernel.org
[ Yanked this independent hunk, without changes, from a larger patch  ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index c24c5b8..3cb928e 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -396,6 +396,7 @@ static struct symbol *symbols__find_by_name(struct rb_root *symbols,
 					    const char *name)
 {
 	struct rb_node *n;
+	struct symbol_name_rb_node *s;
 
 	if (symbols == NULL)
 		return NULL;
@@ -403,7 +404,6 @@ static struct symbol *symbols__find_by_name(struct rb_root *symbols,
 	n = symbols->rb_node;
 
 	while (n) {
-		struct symbol_name_rb_node *s;
 		int cmp;
 
 		s = rb_entry(n, struct symbol_name_rb_node, rb_node);
@@ -414,10 +414,24 @@ static struct symbol *symbols__find_by_name(struct rb_root *symbols,
 		else if (cmp > 0)
 			n = n->rb_right;
 		else
-			return &s->sym;
+			break;
 	}
 
-	return NULL;
+	if (n == NULL)
+		return NULL;
+
+	/* return first symbol that has same name (if any) */
+	for (n = rb_prev(n); n; n = rb_prev(n)) {
+		struct symbol_name_rb_node *tmp;
+
+		tmp = rb_entry(n, struct symbol_name_rb_node, rb_node);
+		if (strcmp(tmp->sym.name, s->sym.name))
+			break;
+
+		s = tmp;
+	}
+
+	return &s->sym;
 }
 
 struct symbol *dso__find_symbol(struct dso *dso,
