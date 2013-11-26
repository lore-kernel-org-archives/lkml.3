Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab3KZRnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 12:43:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754404Ab3KZRnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 12:43:39 -0500
Date: Tue, 26 Nov 2013 18:44:46 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [RFC PATCH 2/2] tracing: Teach FETCH_MTD_symbol to handle per-cpu
	data
Message-ID: <20131126174446.GD14028@redhat.com>
References: <20131123201543.GA22148@redhat.com> <20131125172106.GA14516@redhat.com> <20131125172206.GD14516@redhat.com> <52946B42.40603@hitachi.com> <20131126174355.GB14028@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131126174355.GB14028@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FETCH_FUNC_NAME(symbol) blindly dereferences sc->addr + sc->offset,
this is not what we want if this symbol is per-cpu. Change this code
to use this_cpu_ptr(sc->addr) in this case.

Note: this doesn't work for modules, but module's per-cpu data is
not visible for kallsyms_lookup_name() anyway.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_probe.c |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 097cc80..a0144b6 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -252,14 +252,28 @@ static struct symbol_cache *alloc_symbol_cache(const char *sym, long offset)
 	return sc;
 }
 
+static void *sc_calc_addr(struct symbol_cache *sc)
+{
+	void *addr = (void*)sc->addr;
+
+	if (addr) {
+		if (addr >= (void *)__per_cpu_start &&
+		    addr <  (void *)__per_cpu_end)
+			addr = this_cpu_ptr(addr);
+
+		addr += sc->offset;
+	}
+
+	return addr;
+}
+
 #define DEFINE_FETCH_symbol(type)					\
 static __kprobes void FETCH_FUNC_NAME(symbol, type)(struct pt_regs *regs,\
 					  void *data, void *dest)	\
 {									\
-	struct symbol_cache *sc = data;					\
-	long off = sc->offset;						\
-	if (sc->addr)							\
-		fetch_memory_##type(regs, (void *)sc->addr + off, dest);\
+	void *addr = sc_calc_addr(data);				\
+	if (addr)							\
+		fetch_memory_##type(regs, addr, dest);			\
 	else								\
 		*(type *)dest = 0;					\
 }
-- 
1.5.5.1


