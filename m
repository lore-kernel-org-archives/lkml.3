Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbaESSlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 14:41:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbaESSly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 14:41:54 -0400
Date: Mon, 19 May 2014 20:40:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] uprobes: Shift ->readpage check from __copy_insn() to
	uprobe_register()
Message-ID: <20140519184054.GA6750@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for double-posting, but it seems that this patch didn't reach
lkml. Let me resend it just on case. Plus another patch in reply, on
top of this change.

-------------------------------------------------------------------------------
Subject: [PATCH] uprobes: Shift ->readpage check from __copy_insn() to uprobe_register()

copy_insn() fails with -EIO if ->readpage == NULL, but this error
is not propagated unless uprobe_register() path finds ->mm which
already mmaps this file. In this case (say) "perf record" does not
actually install the probe, but the user can't know about this.

Move this check into uprobe_register() so that this problem can be
detected earlier and reported to user.

Note: this is still not perfect,

	- copy_insn() and arch_uprobe_analyze_insn() should be called
	  by uprobe_register() but this is not simple, we need vm_file
	  for read_mapping_page() (although perhaps we can pass NULL),
	  and we need ->mm for is_64bit_mm() (although this logic is
	  broken anyway).

	- uprobe_register() should be called by create_trace_uprobe(),
	  not by probe_event_enable(), so that an error can be detected
	  at "perf probe -x" time. This also needs more changes in the
	  core uprobe code, uprobe register/unregister interface was
	  poorly designed from the very beginning.

Reported-by: Denys Vlasenko <dvlasenk@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 3b02c72..c56b13e 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -536,9 +536,6 @@ static int __copy_insn(struct address_space *mapping, struct file *filp,
 			void *insn, int nbytes, loff_t offset)
 {
 	struct page *page;
-
-	if (!mapping->a_ops->readpage)
-		return -EIO;
 	/*
 	 * Ensure that the page that has the original instruction is
 	 * populated and in page-cache.
@@ -879,6 +876,9 @@ int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *
 	if (!uc->handler && !uc->ret_handler)
 		return -EINVAL;
 
+	/* copy_insn()->read_mapping_page() needs ->readpage() */
+	if (!inode->i_mapping->a_ops->readpage)
+		return -EIO;
 	/* Racy, just to catch the obvious mistakes */
 	if (offset > i_size_read(inode))
 		return -EINVAL;
-- 
1.5.5.1


