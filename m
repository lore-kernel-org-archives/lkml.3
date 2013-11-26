Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab3KZRnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 12:43:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754247Ab3KZRnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 12:43:18 -0500
Date: Tue, 26 Nov 2013 18:44:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [RFC PATCH 1/2] tracing: Don't update sc->addr in
	update_symbol_cache()
Message-ID: <20131126174423.GC14028@redhat.com>
References: <20131123201543.GA22148@redhat.com> <20131125172106.GA14516@redhat.com> <20131125172206.GD14516@redhat.com> <52946B42.40603@hitachi.com> <20131126174355.GB14028@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131126174355.GB14028@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparation for the next changes. Shift "+= offset" from
update_symbol_cache() to ->fetch[FETCH_MTD_symbol], this
allows to detect the per-cpu symbols.

Also remove the !offset check in traceprobe_split_symbol_offset(),
it is never called with offset == NULL.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_probe.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index fce222f..097cc80 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -219,14 +219,9 @@ struct symbol_cache {
 	unsigned long	addr;
 };
 
-static unsigned long update_symbol_cache(struct symbol_cache *sc)
+static void update_symbol_cache(struct symbol_cache *sc)
 {
 	sc->addr = (unsigned long)kallsyms_lookup_name(sc->symbol);
-
-	if (sc->addr)
-		sc->addr += sc->offset;
-
-	return sc->addr;
 }
 
 static void free_symbol_cache(struct symbol_cache *sc)
@@ -262,8 +257,9 @@ static __kprobes void FETCH_FUNC_NAME(symbol, type)(struct pt_regs *regs,\
 					  void *data, void *dest)	\
 {									\
 	struct symbol_cache *sc = data;					\
+	long off = sc->offset;						\
 	if (sc->addr)							\
-		fetch_memory_##type(regs, (void *)sc->addr, dest);	\
+		fetch_memory_##type(regs, (void *)sc->addr + off, dest);\
 	else								\
 		*(type *)dest = 0;					\
 }
@@ -485,9 +481,6 @@ int traceprobe_split_symbol_offset(char *symbol, unsigned long *offset)
 	char *tmp;
 	int ret;
 
-	if (!offset)
-		return -EINVAL;
-
 	tmp = strchr(symbol, '+');
 	if (tmp) {
 		/* skip sign because kstrtoul doesn't accept '+' */
-- 
1.5.5.1


