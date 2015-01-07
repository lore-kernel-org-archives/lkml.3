Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461AbbAGHmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:42:09 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:64643 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609AbbAGHmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:42:02 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <linux@arm.linux.org.uk>, <mingo@redhat.com>, <x86@kernel.org>,
        <masami.hiramatsu.pt@hitachi.com>, <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>, <ananth@in.ibm.com>, <dave.long@linaro.org>,
        <tixy@linaro.org>
CC: <lizefan@huawei.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 10/11] kprobes: enable 'ekprobe=' cmdline option for early kprobes.
Date: Wed, 7 Jan 2015 15:36:04 +0800
Message-ID: <1420616164-43153-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1420616086-42692-1-git-send-email-wangnan0@huawei.com>
References: <1420616086-42692-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch shows the basic idea of usage of early kprobes. By adding
kernel cmdline options such as 'ekprobe=__alloc_pages_nodemask' or
'ekprobe=0xc00f3c2c', early kprobes are installed. When the probed
instructions get hit, a message is printed.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 kernel/kprobes.c | 71 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 9c3ea9b..73f9b7f 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2611,8 +2611,79 @@ convert_early_kprobes(void)
 	hlist_for_each_entry_safe(p, tmp, &early_kprobe_hlist, hlist)
 		convert_early_kprobe(p);
 };
+
+static int early_kprobe_pre_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	const char *sym = NULL;
+	char *modname, namebuf[KSYM_NAME_LEN];
+	unsigned long offset = 0;
+
+	sym = kallsyms_lookup((unsigned long)p->addr, NULL,
+			&offset, &modname, namebuf);
+	if (sym)
+		pr_info("Hit early kprobe at %s+0x%lx%s%s\n",
+				sym, offset,
+				(modname ? " " : ""),
+				(modname ? modname : ""));
+	else
+		pr_info("Hit early kprobe at %p\n", p->addr);
+	return 0;
+}
+
+DEFINE_EKPROBE_ALLOC_OPS(struct kprobe, early_kprobe_setup, static);
+static int __init early_kprobe_setup(char *p)
+{
+	unsigned long long addr;
+	struct kprobe *kp;
+	int len = strlen(p);
+	int err;
+
+	if (len <= 0) {
+		pr_err("early kprobe: wrong param: %s\n", p);
+		return 0;
+	}
+
+	if ((p[0] == '0') && (p[1] == 'x')) {
+		err = kstrtoull(p, 16, &addr);
+		if (err) {
+			pr_err("early kprobe: wrong address: %p\n", p);
+			return 0;
+		}
+	} else {
+		addr = kallsyms_lookup_name(p);
+		if (!addr) {
+			pr_err("early kprobe: wrong symbol: %s\n", p);
+			return 0;
+		}
+	}
+
+	if ((addr < (unsigned long)_text) ||
+			(addr >= (unsigned long)_etext))
+		pr_err("early kprobe: address of %p out of range\n", p);
+
+	kp = ek_alloc_early_kprobe_setup();
+	if (kp == NULL) {
+		pr_err("early kprobe: no enough early kprobe slot\n");
+		return 0;
+	}
+	kp->addr = (void *)(unsigned long)(addr);
+	kp->pre_handler = early_kprobe_pre_handler;
+	err = register_kprobe(kp);
+	if (err) {
+		pr_err("early kprobe: register early kprobe %s failed\n", p);
+		ek_free_early_kprobe_setup(kp);
+	}
+	return 0;
+}
 #else
 static int register_early_kprobe(struct kprobe *p) { return -ENOSYS; }
 static int ek_free_early_kprobe(struct early_kprobe_slot *slot) { return 0; }
 static void convert_early_kprobes(void) {};
+
+static int __init early_kprobe_setup(char *p)
+{
+	return 0;
+}
 #endif
+
+early_param("ekprobe", early_kprobe_setup);
-- 
1.8.4

