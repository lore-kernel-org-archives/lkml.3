Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613Ab3CVNJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 09:09:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932344Ab3CVNJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 09:09:33 -0400
From: Anton Arapov <anton@redhat.com>
To: Anton Arapov <anton@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: [PATCH 1/7] uretprobes: preparation patch
Date: Fri, 22 Mar 2013 14:08:58 +0100
Message-Id: <1363957745-6657-2-git-send-email-anton@redhat.com>
In-Reply-To: <1363957745-6657-1-git-send-email-anton@redhat.com>
References: <1363957745-6657-1-git-send-email-anton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Enclose return probes implementation, introduce ->rp_handler() and update
existing code to rely on ->handler() *and* ->rp_handler() for uprobe and
uretprobe respectively.

RFCv5 changes:
  - don't remove uprobe in case there are no uprobe consumer(handler),
    see handler_chain() changes.

RFCv3 changes: (the patch is introduced in v3)
  - check whether at least one of the consumer's handlers were set.
  - a 'TODO' cap that will be removed once return probes be implemented.
  - introduce ->rp_handler().

Signed-off-by: Anton Arapov <anton@redhat.com>
---
 include/linux/uprobes.h |  1 +
 kernel/events/uprobes.c | 14 +++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

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
index 26bc2e2..3205a2e 100644
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
@@ -1488,10 +1496,14 @@ static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
 {
 	struct uprobe_consumer *uc;
 	int remove = UPROBE_HANDLER_REMOVE;
+	int rc = 0;
 
 	down_read(&uprobe->register_rwsem);
 	for (uc = uprobe->consumers; uc; uc = uc->next) {
-		int rc = uc->handler(uc, regs);
+		if (uc->handler)
+			rc = uc->handler(uc, regs);
+		else
+			remove = 0;
 
 		WARN(rc & ~UPROBE_HANDLER_MASK,
 			"bad rc=0x%x from %pf()\n", rc, uc->handler);
-- 
1.8.1.4

