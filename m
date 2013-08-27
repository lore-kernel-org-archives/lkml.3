Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab3H0IxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:53:17 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:52972 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab3H0ItB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:49:01 -0400
X-AuditID: 9c930197-b7b44ae00000347f-46-521c67fa1c06
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>, Hyeoncheol Lee <cheol.lee@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 04/13] tracing/kprobes: Add fetch{,_size} member into deref fetch method
Date: Tue, 27 Aug 2013 17:48:47 +0900
Message-Id: <1377593336-16828-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1377593336-16828-1-git-send-email-namhyung@kernel.org>
References: <1377593336-16828-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hyeoncheol Lee <cheol.lee@lge.com>

The deref fetch methods access a memory region but it assumes that
it's a kernel memory since uprobes does not support them.

Add ->fetch and ->fetch_size member in order to provide a proper
access methods for supporting uprobes.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Hyeoncheol Lee <cheol.lee@lge.com>
[namhyung@kernel.org: Split original patch into pieces as requested]
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace_probe.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 41f654d24cd9..b7b8bda02d6e 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -97,6 +97,8 @@ DEFINE_BASIC_FETCH_FUNCS(retval)
 struct deref_fetch_param {
 	struct fetch_param	orig;
 	long			offset;
+	fetch_func_t		fetch;
+	fetch_func_t		fetch_size;
 };
 
 #define DEFINE_FETCH_deref(type)					\
@@ -108,13 +110,26 @@ __kprobes void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,	\
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
@@ -394,6 +409,9 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 				return -ENOMEM;
 
 			dprm->offset = offset;
+			dprm->fetch = t->fetch[FETCH_MTD_memory];
+			dprm->fetch_size = get_fetch_size_function(t,
+							dprm->fetch, ttbl);
 			ret = parse_probe_arg(arg, t2, &dprm->orig, is_return,
 							is_kprobe);
 			if (ret)
-- 
1.7.11.7

