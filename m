Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbaACCNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 21:13:24 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:44074 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753279AbaACCLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 21:11:50 -0500
Message-Id: <20140103021146.104705087@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 02 Jan 2014 21:10:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hyeoncheol Lee <cheol.lee@lge.com>, Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 11/17] tracing/probes: Add fetch{,_size} member into deref fetch method
References: <20140103021021.238772653@goodmis.org>
Content-Disposition: inline; filename=0011-tracing-probes-Add-fetch-_size-member-into-deref-fet.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hyeoncheol Lee <cheol.lee@lge.com>

The deref fetch methods access a memory region but it assumes that
it's a kernel memory since uprobes does not support them.

Add ->fetch and ->fetch_size member in order to provide a proper
access methods for supporting uprobes.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Hyeoncheol Lee <cheol.lee@lge.com>
[namhyung@kernel.org: Split original patch into pieces as requested]
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace_probe.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index a31ad47..8d7231d 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -184,6 +184,8 @@ __kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
 struct deref_fetch_param {
 	struct fetch_param	orig;
 	long			offset;
+	fetch_func_t		fetch;
+	fetch_func_t		fetch_size;
 };
 
 #define DEFINE_FETCH_deref(type)					\
@@ -195,13 +197,26 @@ __kprobes void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,	\
 	call_fetch(&dprm->orig, regs, &addr);				\
 	if (addr) {							\
 		addr += dprm->offset;					\
-		fetch_memory_##type(regs, (void *)addr, dest);		\
+		dprm->fetch(regs, (void *)addr, dest);			\
 	} else								\
 		*(type *)dest = 0;					\
 }
 DEFINE_BASIC_FETCH_FUNCS(deref)
 DEFINE_FETCH_deref(string)
-DEFINE_FETCH_deref(string_size)
+
+__kprobes void FETCH_FUNC_NAME(deref, string_size)(struct pt_regs *regs,
+						   void *data, void *dest)
+{
+	struct deref_fetch_param *dprm = data;
+	unsigned long addr;
+
+	call_fetch(&dprm->orig, regs, &addr);
+	if (addr && dprm->fetch_size) {
+		addr += dprm->offset;
+		dprm->fetch_size(regs, (void *)addr, dest);
+	} else
+		*(string_size *)dest = 0;
+}
 
 static __kprobes void update_deref_fetch_param(struct deref_fetch_param *data)
 {
@@ -477,6 +492,9 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 				return -ENOMEM;
 
 			dprm->offset = offset;
+			dprm->fetch = t->fetch[FETCH_MTD_memory];
+			dprm->fetch_size = get_fetch_size_function(t,
+							dprm->fetch, ftbl);
 			ret = parse_probe_arg(arg, t2, &dprm->orig, is_return,
 							is_kprobe);
 			if (ret)
-- 
1.8.4.3


