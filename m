Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab3KYRU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 12:20:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456Ab3KYRUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 12:20:25 -0500
Date: Mon, 25 Nov 2013 18:21:26 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/3] tracing: Don't mangle sc->addr in
	update_symbol_cache()
Message-ID: <20131125172126.GB14516@redhat.com>
References: <20131123201543.GA22148@redhat.com> <20131125172106.GA14516@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131125172106.GA14516@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparation for the next changes. Shift "+= offset" from
update_symbol_cache() to ->fetch[FETCH_MTD_symbol], this
allows to overload the meaning of sc->offset.

Also remove the !offset check in traceprobe_split_symbol_offset(),
it is never called with offset == NULL.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_probe.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index e167c0a..dcf7780 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -230,14 +230,9 @@ struct symbol_cache {
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
@@ -273,8 +268,9 @@ static __kprobes void FETCH_FUNC_NAME(symbol, type)(struct pt_regs *regs,\
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
@@ -497,9 +493,6 @@ int traceprobe_split_symbol_offset(char *symbol, unsigned long *offset)
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


