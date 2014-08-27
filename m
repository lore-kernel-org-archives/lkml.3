Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008AbaH0Cas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 22:30:48 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:39201 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757840AbaH0Cak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 22:30:40 -0400
From: Alexei Starovoitov <ast@plumgrid.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC v7 net-next 16/28] bpf: split eBPF out of NET
Date: Tue, 26 Aug 2014 19:29:30 -0700
Message-Id: <1409106582-10095-17-git-send-email-ast@plumgrid.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409106582-10095-1-git-send-email-ast@plumgrid.com>
References: <1409106582-10095-1-git-send-email-ast@plumgrid.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

let eBPF have its own CONFIG_BPF, so that tracing and other subsystems don't
need to depend on all of NET

Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
---
 arch/Kconfig      |    3 +++
 kernel/Makefile   |    2 +-
 kernel/bpf/core.c |   12 ++++++++++++
 net/Kconfig       |    1 +
 4 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 0eae9df35b88..80a72f6f6b60 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -333,6 +333,9 @@ config SECCOMP_FILTER
 
 	  See Documentation/prctl/seccomp_filter.txt for details.
 
+config BPF
+	boolean
+
 config HAVE_CC_STACKPROTECTOR
 	bool
 	help
diff --git a/kernel/Makefile b/kernel/Makefile
index dc5c77544fd6..17ea6d4a9a24 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -86,7 +86,7 @@ obj-$(CONFIG_RING_BUFFER) += trace/
 obj-$(CONFIG_TRACEPOINTS) += trace/
 obj-$(CONFIG_IRQ_WORK) += irq_work.o
 obj-$(CONFIG_CPU_PM) += cpu_pm.o
-obj-$(CONFIG_NET) += bpf/
+obj-$(CONFIG_BPF) += bpf/
 
 obj-$(CONFIG_PERF_EVENTS) += events/
 
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 0434c2170f2b..c17ba0ef3dcf 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -537,3 +537,15 @@ void bpf_prog_free(struct bpf_prog *fp)
 	bpf_jit_free(fp);
 }
 EXPORT_SYMBOL_GPL(bpf_prog_free);
+
+/* To emulate LD_ABS/LD_IND instructions __sk_run_filter() may call
+ * skb_copy_bits(), so provide a weak definition for it in NET-less config.
+ * seccomp_check_filter() verifies that seccomp filters are not using
+ * LD_ABS/LD_IND instructions. Other BPF users (like tracing filters)
+ * must not use these instructions unless ctx==skb
+ */
+int __weak skb_copy_bits(const struct sk_buff *skb, int offset, void *to,
+			 int len)
+{
+	return -EFAULT;
+}
diff --git a/net/Kconfig b/net/Kconfig
index 4051fdfa4367..9a99e16d6f28 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -6,6 +6,7 @@ menuconfig NET
 	bool "Networking support"
 	select NLATTR
 	select GENERIC_NET_UTILS
+	select BPF
 	---help---
 	  Unless you really know what you are doing, you should say Y here.
 	  The reason is that some programs need kernel networking support even
-- 
1.7.9.5

