Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab3LCE32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 23:29:28 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:58792 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab3LCE3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 23:29:06 -0500
From: Alexei Starovoitov <ast@plumgrid.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH tip 5/5] tracing filter examples in BPF
Date: Mon,  2 Dec 2013 20:28:50 -0800
Message-Id: <1386044930-15149-6-git-send-email-ast@plumgrid.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

filter_ex1: filter that prints events for loobpack device only

$ cat filter_ex1.bpf > /sys/kernel/debug/tracing/events/net/netif_receive_skb/filter
$ echo 1 > /sys/kernel/debug/tracing/events/net/netif_receive_skb/enable
$ ping -c1 localhost
$ cat /sys/kernel/debug/tracing/trace_pip
            ping-5913  [003] ..s2  3779.285726: __netif_receive_skb_core: skb ffff880808e3a300 dev ffff88080bbf8000
            ping-5913  [003] ..s2  3779.285744: __netif_receive_skb_core: skb ffff880808e3a900 dev ffff88080bbf8000

To pre-check correctness of the filter do:
$ trace_filter_check filter_ex1.bpf
(final filter check always happens in kernel)

bpf/llvm - placeholder for LLVM-BPF backend

Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
---
 GCC-BPF backend is available on github
 (since gcc plugin infrastructure doesn't allow for out-of-tree backends)

 LLVM plugin infra is very flexible.
 LLVM-BPF backend is reusing 'LLVM target independent code generator'
 and currently it's work in progress. It can be built out of LLVM tree.
 The user would need to 'apt-get install llvm-3.x-dev'
 which will bring llvm headers and static libraries
 and then compile BPF backend only.

 Both compilers can compile C into BPF instruction set.

 tools/bpf/llvm/README.txt            |    6 +++
 tools/bpf/trace/Makefile             |   34 ++++++++++++++
 tools/bpf/trace/README.txt           |   15 +++++++
 tools/bpf/trace/filter_ex1.c         |   52 +++++++++++++++++++++
 tools/bpf/trace/filter_ex1_orig.c    |   23 ++++++++++
 tools/bpf/trace/filter_ex2.c         |   74 ++++++++++++++++++++++++++++++
 tools/bpf/trace/filter_ex2_orig.c    |   47 +++++++++++++++++++
 tools/bpf/trace/trace_filter_check.c |   82 ++++++++++++++++++++++++++++++++++
 8 files changed, 333 insertions(+)
 create mode 100644 tools/bpf/llvm/README.txt
 create mode 100644 tools/bpf/trace/Makefile
 create mode 100644 tools/bpf/trace/README.txt
 create mode 100644 tools/bpf/trace/filter_ex1.c
 create mode 100644 tools/bpf/trace/filter_ex1_orig.c
 create mode 100644 tools/bpf/trace/filter_ex2.c
 create mode 100644 tools/bpf/trace/filter_ex2_orig.c
 create mode 100644 tools/bpf/trace/trace_filter_check.c

diff --git a/tools/bpf/llvm/README.txt b/tools/bpf/llvm/README.txt
new file mode 100644
index 0000000..3ca3ece
--- /dev/null
+++ b/tools/bpf/llvm/README.txt
@@ -0,0 +1,6 @@
+placeholder for LLVM BPF backend:
+lib/Target/BPF/*.cpp
+
+prerequisites:
+apt-get install llvm-3.[23]-dev
+
diff --git a/tools/bpf/trace/Makefile b/tools/bpf/trace/Makefile
new file mode 100644
index 0000000..b63f974
--- /dev/null
+++ b/tools/bpf/trace/Makefile
@@ -0,0 +1,34 @@
+CC = gcc
+
+all: trace_filter_check filter_ex1.bpf filter_ex2.bpf
+
+srctree=../../..
+src-perf=../../perf
+
+CFLAGS += -I$(src-perf)/util/include
+CFLAGS += -I$(src-perf)/arch/$(ARCH)/include
+CFLAGS += -I$(srctree)/arch/$(ARCH)/include/uapi
+CFLAGS += -I$(srctree)/arch/$(ARCH)/include
+CFLAGS += -I$(srctree)/include/uapi
+CFLAGS += -I$(srctree)/include
+CFLAGS += -Wall -O2
+
+trace_filter_check: LDLIBS = -Wl,--unresolved-symbols=ignore-all
+trace_filter_check: trace_filter_check.o \
+	$(srctree)/kernel/bpf_jit/bpf_check.o \
+	$(srctree)/kernel/bpf_jit/bpf_run.o \
+	$(srctree)/kernel/trace/bpf_trace_callbacks.o
+
+filter_ex1: filter_ex1.o
+filter_ex1.bpf: filter_ex1
+	./filter_ex1 > filter_ex1.bpf
+	rm filter_ex1
+
+filter_ex2: filter_ex2.o
+filter_ex2.bpf: filter_ex2
+	./filter_ex2 > filter_ex2.bpf
+	rm filter_ex2
+
+clean:
+	rm -rf *.o *.bpf trace_filter_check filter_ex1 filter_ex2
+
diff --git a/tools/bpf/trace/README.txt b/tools/bpf/trace/README.txt
new file mode 100644
index 0000000..7c1fcb9
--- /dev/null
+++ b/tools/bpf/trace/README.txt
@@ -0,0 +1,15 @@
+Tracing filter examples
+
+filter_ex1: tracing filter example that prints events for loobpack device only
+
+$ cat filter_ex1.bpf > /sys/kernel/debug/tracing/events/net/netif_receive_skb/filter
+$ echo 1 > /sys/kernel/debug/tracing/events/net/netif_receive_skb/enable
+$ ping -c1 localhost
+$ cat /sys/kernel/debug/tracing/trace_pip
+            ping-5913  [003] ..s2  3779.285726: __netif_receive_skb_core: skb ffff880808e3a300 dev ffff88080bbf8000
+            ping-5913  [003] ..s2  3779.285744: __netif_receive_skb_core: skb ffff880808e3a900 dev ffff88080bbf8000
+
+To pre-check correctness of the filter do:
+$ trace_filter_check filter_ex1.bpf
+(final filter check always happens in kernel)
+
diff --git a/tools/bpf/trace/filter_ex1.c b/tools/bpf/trace/filter_ex1.c
new file mode 100644
index 0000000..74696ba
--- /dev/null
+++ b/tools/bpf/trace/filter_ex1.c
@@ -0,0 +1,52 @@
+#include <linux/bpf.h>
+
+struct bpf_insn bpf_insns_filter[] = {
+// registers to save R6 R7
+// allocate 24 bytes stack
+	BPF_INSN_ST_IMM(BPF_W, __fp__, -20, 28524), // *(uint32*)(__fp__, -20)=28524
+	BPF_INSN_LD(BPF_DW, R6, R1, 104), // R6=*(uint64*)(R1, 104)
+	BPF_INSN_ALU(BPF_MOV, R1, R6), // R1 = R6
+	BPF_INSN_ALU_IMM(BPF_ADD, R1, 32), // R1 += 32
+	BPF_INSN_CALL(1), // R0=bpf_load_pointer();
+	BPF_INSN_ALU(BPF_MOV, R7, R0), // R7 = R0
+	BPF_INSN_ALU_IMM(BPF_MOV, R3, 2), // R3 = 2
+	BPF_INSN_ALU(BPF_MOV, R2, __fp__), // R2 = __fp__
+	BPF_INSN_ALU_IMM(BPF_ADD, R2, -20), // R2 += -20
+	BPF_INSN_ALU(BPF_MOV, R1, R7), // R1 = R7
+	BPF_INSN_CALL(18), // R0=bpf_memcmp();
+	BPF_INSN_JUMP_IMM(BPF_JNE, R0, 0, 11), // if (R0 != 0) goto LabelL5
+	BPF_INSN_ST_IMM(BPF_W, __fp__, -16, 543320947), // *(uint32*)(__fp__, -16)=543320947
+	BPF_INSN_ST_IMM(BPF_W, __fp__, -12, 1679847461), // *(uint32*)(__fp__, -12)=1679847461
+	BPF_INSN_ST_IMM(BPF_W, __fp__, -8, 622884453), // *(uint32*)(__fp__, -8)=622884453
+	BPF_INSN_ST_IMM(BPF_W, __fp__, -4, 663664), // *(uint32*)(__fp__, -4)=663664
+	BPF_INSN_ALU_IMM(BPF_MOV, R5, 0), // R5 = 0
+	BPF_INSN_ALU(BPF_MOV, R4, R7), // R4 = R7
+	BPF_INSN_ALU(BPF_MOV, R3, R6), // R3 = R6
+	BPF_INSN_ALU_IMM(BPF_MOV, R2, 16), // R2 = 16
+	BPF_INSN_ALU(BPF_MOV, R1, __fp__), // R1 = __fp__
+	BPF_INSN_ALU_IMM(BPF_ADD, R1, -16), // R1 += -16
+	BPF_INSN_CALL(29), // (void)bpf_trace_printk();
+//LabelL5:
+	BPF_INSN_RET(), // return void
+};
+
+const char func_strtab[46] = "\0bpf_load_pointer\0bpf_memcmp\0bpf_trace_printk";
+
+int main()
+{
+	char header[4] = "bpf";
+
+	int insn_size = sizeof(bpf_insns_filter);
+	int htab_size = 0;
+	int strtab_size = sizeof(func_strtab);
+
+	write(1, header, 4);
+	write(1, &insn_size, 4);
+	write(1, &htab_size, 4);
+	write(1, &strtab_size, 4);
+
+	write(1, bpf_insns_filter, insn_size);
+	write(1, func_strtab, strtab_size);
+	return 0;
+}
+
diff --git a/tools/bpf/trace/filter_ex1_orig.c b/tools/bpf/trace/filter_ex1_orig.c
new file mode 100644
index 0000000..e670a82
--- /dev/null
+++ b/tools/bpf/trace/filter_ex1_orig.c
@@ -0,0 +1,23 @@
+/*
+ * tracing filter example
+ * if attached to /sys/kernel/debug/tracing/events/net/netif_receive_skb
+ * it will print events for loobpack device only
+ */
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+#include <linux/bpf.h>
+#include <trace/bpf_trace.h>
+
+void filter(struct bpf_context *ctx)
+{
+	char devname[4] = "lo";
+	struct net_device *dev;
+	struct sk_buff *skb = 0;
+
+	skb = (struct sk_buff *)ctx->regs.si;
+	dev = bpf_load_pointer(&skb->dev);
+	if (bpf_memcmp(dev->name, devname, 2) == 0) {
+		char fmt[] = "skb %p dev %p \n";
+		bpf_trace_printk(fmt, sizeof(fmt), (long)skb, (long)dev, 0);
+	}
+}
diff --git a/tools/bpf/trace/filter_ex2.c b/tools/bpf/trace/filter_ex2.c
new file mode 100644
index 0000000..cf5b7ce
--- /dev/null
+++ b/tools/bpf/trace/filter_ex2.c
@@ -0,0 +1,74 @@
+#include <linux/bpf.h>
+
+struct bpf_insn bpf_insns_filter[] = {
+// registers to save R6 R7
+// allocate 32 bytes stack
+	BPF_INSN_ALU(BPF_MOV, R6, R1), // R6 = R1
+	BPF_INSN_ST_IMM(BPF_DW, __fp__, -32, 0), // *(uint64*)(__fp__, -32)=0
+	BPF_INSN_LD(BPF_DW, R1, R6, 104), // R1=*(uint64*)(R6, 104)
+	BPF_INSN_ALU_IMM(BPF_ADD, R1, 32), // R1 += 32
+	BPF_INSN_CALL(1), // R0=bpf_load_pointer();
+	BPF_INSN_ALU(BPF_MOV, R7, R0), // R7 = R0
+	BPF_INSN_ST(BPF_DW, __fp__, -32, R7), // *(uint64*)(__fp__, -32)=R7
+	BPF_INSN_ALU(BPF_MOV, R3, __fp__), // R3 = __fp__
+	BPF_INSN_ALU_IMM(BPF_ADD, R3, -32), // R3 += -32
+	BPF_INSN_ALU_IMM(BPF_MOV, R2, 0), // R2 = 0
+	BPF_INSN_ALU(BPF_MOV, R1, R6), // R1 = R6
+	BPF_INSN_CALL(18), // R0=bpf_table_lookup();
+	BPF_INSN_JUMP_IMM(BPF_JEQ, R0, 0, 18), // if (R0 == 0) goto LabelL2
+	BPF_INSN_ALU_IMM(BPF_MOV, R1, 1), // R1 = 1
+	BPF_INSN_XADD(BPF_DW, R0, 0, R1), // atomic (*(uint64*)R0, 0) += R1
+	BPF_INSN_LD(BPF_DW, R1, R0, 0), // R1=*(uint64*)(R0, 0)
+	BPF_INSN_ALU_IMM(BPF_MOD, R1, 10000), // R1=((uint64)R1)%((uint64)10000)
+	BPF_INSN_JUMP_IMM(BPF_JNE, R1, 0, 21), // if (R1 != 0) goto LabelL6
+	BPF_INSN_ST_IMM(BPF_W, __fp__, -24, 544630116), // *(uint32*)(__fp__, -24)=544630116
+	BPF_INSN_ST_IMM(BPF_W, __fp__, -20, 538996773), // *(uint32*)(__fp__, -20)=538996773
+	BPF_INSN_ST_IMM(BPF_W, __fp__, -16, 1601465200), // *(uint32*)(__fp__, -16)=1601465200
+	BPF_INSN_ST_IMM(BPF_W, __fp__, -12, 544501347), // *(uint32*)(__fp__, -12)=544501347
+	BPF_INSN_ST_IMM(BPF_W, __fp__, -8, 680997), // *(uint32*)(__fp__, -8)=680997
+	BPF_INSN_ALU_IMM(BPF_MOV, R5, 0), // R5 = 0
+	BPF_INSN_LD(BPF_DW, R4, R0, 0), // R4=*(uint64*)(R0, 0)
+	BPF_INSN_ALU(BPF_MOV, R3, R7), // R3 = R7
+	BPF_INSN_ALU_IMM(BPF_MOV, R2, 20), // R2 = 20
+	BPF_INSN_ALU(BPF_MOV, R1, __fp__), // R1 = __fp__
+	BPF_INSN_ALU_IMM(BPF_ADD, R1, -24), // R1 += -24
+	BPF_INSN_CALL(35), // (void)bpf_trace_printk();
+	BPF_INSN_JUMP(BPF_JA, 0, 0, 8), // goto LabelL6
+//LabelL2:
+	BPF_INSN_ST_IMM(BPF_DW, __fp__, -24, 0), // *(uint64*)(__fp__, -24)=0
+	BPF_INSN_ALU(BPF_MOV, R4, __fp__), // R4 = __fp__
+	BPF_INSN_ALU_IMM(BPF_ADD, R4, -24), // R4 += -24
+	BPF_INSN_ALU(BPF_MOV, R3, __fp__), // R3 = __fp__
+	BPF_INSN_ALU_IMM(BPF_ADD, R3, -32), // R3 += -32
+	BPF_INSN_ALU_IMM(BPF_MOV, R2, 0), // R2 = 0
+	BPF_INSN_ALU(BPF_MOV, R1, R6), // R1 = R6
+	BPF_INSN_CALL(52), // R0=bpf_table_update();
+//LabelL6:
+	BPF_INSN_RET(), // return void
+};
+
+struct bpf_table bpf_filter_tables[] = {
+	{BPF_TABLE_HASH, 8, 8, 4096, 0}
+};
+
+const char func_strtab[69] = "\0bpf_load_pointer\0bpf_table_lookup\0bpf_trace_printk\0bpf_table_update";
+
+int main()
+{
+	char header[4] = "bpf";
+
+	int insn_size = sizeof(bpf_insns_filter);
+	int htab_size = sizeof(bpf_filter_tables);
+	int strtab_size = sizeof(func_strtab);
+
+	write(1, header, 4);
+	write(1, &insn_size, 4);
+	write(1, &htab_size, 4);
+	write(1, &strtab_size, 4);
+
+	write(1, bpf_insns_filter, insn_size);
+	write(1, bpf_filter_tables, htab_size);
+	write(1, func_strtab, strtab_size);
+	return 0;
+}
+
diff --git a/tools/bpf/trace/filter_ex2_orig.c b/tools/bpf/trace/filter_ex2_orig.c
new file mode 100644
index 0000000..a716490
--- /dev/null
+++ b/tools/bpf/trace/filter_ex2_orig.c
@@ -0,0 +1,47 @@
+/*
+ * tracing filter that counts number of events per device
+ * if attached to /sys/kernel/debug/tracing/events/net/netif_receive_skb
+ * it will count number of received packets for different devices
+ */
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+#include <linux/bpf.h>
+#include <trace/bpf_trace.h>
+
+struct dev_key {
+	void *dev;
+};
+
+struct dev_leaf {
+	uint64_t packet_cnt;
+};
+
+void filter(struct bpf_context *ctx)
+{
+	struct net_device *dev;
+	struct sk_buff *skb = 0;
+	struct dev_leaf *leaf;
+	struct dev_key key = {};
+
+	skb = (struct sk_buff *)ctx->regs.si;
+	dev = bpf_load_pointer(&skb->dev);
+
+	key.dev = dev;
+	leaf = bpf_table_lookup(ctx, 0, &key);
+	if (leaf) {
+		__sync_fetch_and_add(&leaf->packet_cnt, 1);
+		if (leaf->packet_cnt % 10000 == 0) {
+			char fmt[] = "dev %p  pkt_cnt %d\n";
+			bpf_trace_printk(fmt, sizeof(fmt), (long)dev,
+					 leaf->packet_cnt, 0);
+		}
+	} else {
+		struct dev_leaf new_leaf = {};
+		bpf_table_update(ctx, 0, &key, &new_leaf);
+	}
+}
+
+struct bpf_table filter_tables[] = {
+	{BPF_TABLE_HASH, sizeof(struct dev_key), sizeof(struct dev_leaf), 4096, 0}
+};
+
diff --git a/tools/bpf/trace/trace_filter_check.c b/tools/bpf/trace/trace_filter_check.c
new file mode 100644
index 0000000..4d408f5
--- /dev/null
+++ b/tools/bpf/trace/trace_filter_check.c
@@ -0,0 +1,82 @@
+/* Copyright (c) 2011-2013 PLUMgrid, http://plumgrid.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ */
+#include <linux/bpf.h>
+#include <trace/bpf_trace.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdarg.h>
+#include <errno.h>
+#include <string.h>
+
+void *__kmalloc(size_t size, int flags)
+{
+	return calloc(size, 1);
+}
+
+void kfree(void *objp)
+{
+	free(objp);
+}
+
+int kmalloc_caches[128];
+void *kmem_cache_alloc_trace(void *caches, int flags, size_t size)
+{
+	return calloc(size, 1);
+}
+
+void bpf_compile(void *prog)
+{
+}
+
+void __bpf_free(void *prog)
+{
+}
+
+int printk(const char *fmt, ...)
+{
+	int ret;
+	va_list ap;
+
+	va_start(ap, fmt);
+	ret = vprintf(fmt, ap);
+	va_end(ap);
+	return ret;
+}
+
+char buf[16000];
+int bpf_load_image(const char *image, int image_len, struct bpf_callbacks *cb,
+		   void **p_prog);
+
+int main(int ac, char **av)
+{
+	FILE *f;
+	int size, err;
+	void *prog;
+
+	if (ac < 2) {
+		printf("Usage: %s bpf_binary_image\n", av[0]);
+		return 1;
+	}
+
+	f = fopen(av[1], "r");
+	if (!f) {
+		printf("fopen %s\n", strerror(errno));
+		return 2;
+	}
+	size = fread(buf, 1, sizeof(buf), f);
+	if (size <= 0) {
+		printf("fread %s\n", strerror(errno));
+		return 3;
+	}
+	err = bpf_load_image(buf, size, &bpf_trace_cb, &prog);
+	if (!err)
+		printf("OK\n");
+	else
+		printf("err %s\n", strerror(-err));
+	fclose(f);
+	return 0;
+}
-- 
1.7.9.5

