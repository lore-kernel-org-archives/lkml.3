Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230Ab3CDOkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 09:40:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758135Ab3CDOkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 09:40:16 -0500
From: Anton Arapov <anton@redhat.com>
To: Anton Arapov <anton@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: [RFC PATCH v4 1/6] uretprobes: preparation patch
Date: Mon,  4 Mar 2013 15:38:08 +0100
Message-Id: <1362407893-32505-2-git-send-email-anton@redhat.com>
In-Reply-To: <1362407893-32505-1-git-send-email-anton@redhat.com>
References: <1362407893-32505-1-git-send-email-anton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  1/6 and 6/6 patches are here to enclose return probes implementation as well
as prohibit uprobe_register() routine with no consumer set.

v3 changes: (the patch is introduced in v3)
  - check whether at least one of the consumer's handlers were set
  - a 'TODO' cap that will be removed once return probes be implemented

Signed-off-by: Anton Arapov <anton@redhat.com>
---
 include/linux/uprobes.h | 1 +
 kernel/events/uprobes.c | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 02b83db..a28bdee 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -46,6 +46,7 @@ enum uprobe_filter_ctx {
 
 struct uprobe_consumer {
 	int (*handler)(struct uprobe_consumer *self, struct pt_regs *regs);
+	int (*rp_handler)(struct uprobe_consumer *self, struct pt_regs *regs);
 	bool (*filter)(struct uprobe_consumer *self,
 				enum uprobe_filter_ctx ctx,
 				struct mm_struct *mm);
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index a567c8c..d904164 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -828,6 +828,14 @@ int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *
 	struct uprobe *uprobe;
 	int ret;
 
+	/* Uprobe must have at least one set consumer */
+	if (!uc->handler && !uc->rp_handler)
+		return -EINVAL;
+
+	/* TODO: Implement return probes */
+	if (uc->rp_handler)
+		return -ENOSYS;
+
 	/* Racy, just to catch the obvious mistakes */
 	if (offset > i_size_read(inode))
 		return -EINVAL;
-- 
1.8.1.2

