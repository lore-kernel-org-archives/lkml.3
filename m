Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab3BDTEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 14:04:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755184Ab3BDTEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 14:04:09 -0500
Date: Mon, 4 Feb 2013 20:02:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] uprobes: Introduce uprobe_apply()
Message-ID: <20130204190250.GA10868@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130204190225.GA10840@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently it is not possible to change the filtering constraints after
uprobe_register(), so a consumer can not, say, start to trace a task/mm
which was previously filtered out, or remove the no longer needed bp's.

Introduce uprobe_apply() which simply does register_for_each_vma() again
to consult uprobe_consumer->filter() and install/remove the breakpoints.
The only complication is that register_for_each_vma() can no longer
assume that uprobe->consumers should be consulter if is_register == T,
so we change it to accept "struct uprobe_consumer *new" instead.

Unlike uprobe_register(), uprobe_apply(true) doesn't do "unregister" if
register_for_each_vma() fails, it is up to caller to handle the error.

Note: we probably need to cleanup the current interface, it is strange
that uprobe_apply/unregister need inode/offset. We should either change
uprobe_register() to return "struct uprobe *", or add a private ->uprobe
member in uprobe_consumer. And in the long term uprobe_apply() should
take a single argument, uprobe or consumer, even "bool add" should go
away.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/uprobes.h |    6 ++++++
 kernel/events/uprobes.c |   39 +++++++++++++++++++++++++++++++++++----
 2 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 95d0002..02b83db 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -101,6 +101,7 @@ extern int __weak set_swbp(struct arch_uprobe *aup, struct mm_struct *mm, unsign
 extern int __weak set_orig_insn(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long vaddr);
 extern bool __weak is_swbp_insn(uprobe_opcode_t *insn);
 extern int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *uc);
+extern int uprobe_apply(struct inode *inode, loff_t offset, struct uprobe_consumer *uc, bool);
 extern void uprobe_unregister(struct inode *inode, loff_t offset, struct uprobe_consumer *uc);
 extern int uprobe_mmap(struct vm_area_struct *vma);
 extern void uprobe_munmap(struct vm_area_struct *vma, unsigned long start, unsigned long end);
@@ -124,6 +125,11 @@ uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *uc)
 {
 	return -ENOSYS;
 }
+static inline int
+uprobe_apply(struct inode *inode, loff_t offset, struct uprobe_consumer *uc, bool add)
+{
+	return -ENOSYS;
+}
 static inline void
 uprobe_unregister(struct inode *inode, loff_t offset, struct uprobe_consumer *uc)
 {
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 23340a7..2bcd08e 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -733,8 +733,10 @@ build_map_info(struct address_space *mapping, loff_t offset, bool is_register)
 	return curr;
 }
 
-static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
+static int
+register_for_each_vma(struct uprobe *uprobe, struct uprobe_consumer *new)
 {
+	bool is_register = !!new;
 	struct map_info *info;
 	int err = 0;
 
@@ -765,7 +767,7 @@ static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
 
 		if (is_register) {
 			/* consult only the "caller", new consumer. */
-			if (consumer_filter(uprobe->consumers,
+			if (consumer_filter(new,
 					UPROBE_FILTER_REGISTER, mm))
 				err = install_breakpoint(uprobe, mm, vma, info->vaddr);
 		} else if (test_bit(MMF_HAS_UPROBES, &mm->flags)) {
@@ -788,7 +790,7 @@ static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
 static int __uprobe_register(struct uprobe *uprobe, struct uprobe_consumer *uc)
 {
 	consumer_add(uprobe, uc);
-	return register_for_each_vma(uprobe, true);
+	return register_for_each_vma(uprobe, uc);
 }
 
 static void __uprobe_unregister(struct uprobe *uprobe, struct uprobe_consumer *uc)
@@ -798,7 +800,7 @@ static void __uprobe_unregister(struct uprobe *uprobe, struct uprobe_consumer *u
 	if (!consumer_del(uprobe, uc))	/* WARN? */
 		return;
 
-	err = register_for_each_vma(uprobe, false);
+	err = register_for_each_vma(uprobe, NULL);
 	/* TODO : cant unregister? schedule a worker thread */
 	if (!uprobe->consumers && !err)
 		delete_uprobe(uprobe);
@@ -855,6 +857,35 @@ int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *
 EXPORT_SYMBOL_GPL(uprobe_register);
 
 /*
+ * uprobe_apply - unregister a already registered probe.
+ * @inode: the file in which the probe has to be removed.
+ * @offset: offset from the start of the file.
+ * @uc: consumer which wants to add more or remove some breakpoints
+ * @add: add or remove the breakpoints
+ */
+int uprobe_apply(struct inode *inode, loff_t offset,
+			struct uprobe_consumer *uc, bool add)
+{
+	struct uprobe *uprobe;
+	struct uprobe_consumer *con;
+	int ret = -ENOENT;
+
+	uprobe = find_uprobe(inode, offset);
+	if (!uprobe)
+		return ret;
+
+	down_write(&uprobe->register_rwsem);
+	for (con = uprobe->consumers; con && con != uc ; con = con->next)
+		;
+	if (con)
+		ret = register_for_each_vma(uprobe, add ? uc : NULL);
+	up_write(&uprobe->register_rwsem);
+	put_uprobe(uprobe);
+
+	return ret;
+}
+
+/*
  * uprobe_unregister - unregister a already registered probe.
  * @inode: the file in which the probe has to be removed.
  * @offset: offset from the start of the file.
-- 
1.5.5.1

