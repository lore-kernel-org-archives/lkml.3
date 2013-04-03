Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761634Ab3DCQGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 12:06:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757722Ab3DCQGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 12:06:18 -0400
From: Anton Arapov <anton@redhat.com>
To: Anton Arapov <anton@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: [PATCH v1 1/9] uretprobes: Introduce uprobe_consumer->ret_handler()
Date: Wed,  3 Apr 2013 18:00:31 +0200
Message-Id: <1365004839-21982-2-git-send-email-anton@redhat.com>
In-Reply-To: <1365004839-21982-1-git-send-email-anton@redhat.com>
References: <1365004839-21982-1-git-send-email-anton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enclose return probes implementation, introduce ->ret_handler() and update
existing code to rely on ->handler() *and* ->ret_handler() for uprobe and
uretprobe respectively.

v1 changes:
* add bp_vaddr argument to ->ret_handler()

RFCv5 changes:
* don't remove uprobe in case there are no uprobe consumer(handler),
  see handler_chain() changes.

RFCv3 changes: (the patch is introduced in v3)
* check whether at least one of the consumer's handlers were set.
* a 'TODO' cap that will be removed once return probes be implemented.
* introduce ->ret_handler().

Signed-off-by: Anton Arapov <anton@redhat.com>
---
 include/linux/uprobes.h |  3 +++
 kernel/events/uprobes.c | 17 ++++++++++++++---
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 02b83db..4042cad 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -46,6 +46,9 @@ enum uprobe_filter_ctx {
 
 struct uprobe_consumer {
 	int (*handler)(struct uprobe_consumer *self, struct pt_regs *regs);
+	int (*ret_handler)(struct uprobe_consumer *self,
+				unsigned long func,
+				struct pt_regs *regs);
 	bool (*filter)(struct uprobe_consumer *self,
 				enum uprobe_filter_ctx ctx,
 				struct mm_struct *mm);
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 21d8a65..27c964b 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -815,6 +815,14 @@ int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *
 	struct uprobe *uprobe;
 	int ret;
 
+	/* Uprobe must have at least one set consumer */
+	if (!uc->handler && !uc->ret_handler)
+		return -EINVAL;
+
+	/* TODO: Implement return probes */
+	if (uc->ret_handler)
+		return -ENOSYS;
+
 	/* Racy, just to catch the obvious mistakes */
 	if (offset > i_size_read(inode))
 		return -EINVAL;
@@ -1473,10 +1481,13 @@ static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
 
 	down_read(&uprobe->register_rwsem);
 	for (uc = uprobe->consumers; uc; uc = uc->next) {
-		int rc = uc->handler(uc, regs);
+		int rc = 0;
 
-		WARN(rc & ~UPROBE_HANDLER_MASK,
-			"bad rc=0x%x from %pf()\n", rc, uc->handler);
+		if (uc->handler) {
+			rc = uc->handler(uc, regs);
+			WARN(rc & ~UPROBE_HANDLER_MASK,
+				"bad rc=0x%x from %pf()\n", rc, uc->handler);
+		}
 		remove &= rc;
 	}
 
-- 
1.8.1.4

