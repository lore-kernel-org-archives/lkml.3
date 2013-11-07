Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab3KGTjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 14:39:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466Ab3KGTjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 14:39:11 -0500
Date: Thu, 7 Nov 2013 20:40:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] uprobes: Fix the memory out of bound overwrite in
	copy_insn()
Message-ID: <20131107194032.GB29154@redhat.com>
References: <20131106191913.GA18661@redhat.com> <20131107075151.GB31560@gmail.com> <20131107143432.GA6240@redhat.com> <20131107151601.GA5163@gmail.com> <20131107162736.GA31834@redhat.com> <20131107194010.GA29154@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131107194010.GA29154@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. copy_insn() doesn't look very nice, all calculations are
   confusing and it is not immediately clear why do we read
   the 2nd page first.

2. The usage of inode->i_size is wrong on 32-bit machines.

3. "Instruction at end of binary" logic is simply wrong, it
   doesn't handle the case when uprobe->offset > inode->i_size.

   In this case "bytes" overflows, and __copy_insn() writes to
   the memory outside of uprobe->arch.insn.

   Yes, uprobe_register() checks i_size_read(), but this file
   can be truncated after that. All i_size checks are racy, we
   do this only to catch the obvious mistakes.

Change copy_insn() to call __copy_insn() in a loop, simplify
and fix the bytes/nbytes calculations.

Note: we do not care if offset + size > i_size, the users of
arch_uprobe->insn can't know how many bytes were actually copied
anyway. But perhaps this needs more changes.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   47 +++++++++++++++++++++++------------------------
 1 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index e615b78..db2802b 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -503,9 +503,8 @@ static bool consumer_del(struct uprobe *uprobe, struct uprobe_consumer *uc)
 	return ret;
 }
 
-static int
-__copy_insn(struct address_space *mapping, struct file *filp, char *insn,
-			unsigned long nbytes, loff_t offset)
+static int __copy_insn(struct address_space *mapping, struct file *filp,
+			void *insn, int nbytes, loff_t offset)
 {
 	struct page *page;
 
@@ -527,28 +526,28 @@ __copy_insn(struct address_space *mapping, struct file *filp, char *insn,
 
 static int copy_insn(struct uprobe *uprobe, struct file *filp)
 {
-	struct address_space *mapping;
-	unsigned long nbytes;
-	int bytes;
-
-	nbytes = PAGE_SIZE - (uprobe->offset & ~PAGE_MASK);
-	mapping = uprobe->inode->i_mapping;
+	struct address_space *mapping = uprobe->inode->i_mapping;
+	loff_t offs = uprobe->offset;
+	void *insn = uprobe->arch.insn;
+	int size = MAX_UINSN_BYTES;
+	int len, err = -EIO;
 
-	/* Instruction at end of binary; copy only available bytes */
-	if (uprobe->offset + MAX_UINSN_BYTES > uprobe->inode->i_size)
-		bytes = uprobe->inode->i_size - uprobe->offset;
-	else
-		bytes = MAX_UINSN_BYTES;
+	do {
+		/* Copy only available bytes, but -EIO if nothing was read */
+		if (offs >= i_size_read(uprobe->inode))
+			break;
 
-	/* Instruction at the page-boundary; copy bytes in second page */
-	if (nbytes < bytes) {
-		int err = __copy_insn(mapping, filp, uprobe->arch.insn + nbytes,
-				bytes - nbytes, uprobe->offset + nbytes);
+		len = min_t(int, size, PAGE_SIZE - (offs & ~PAGE_MASK));
+		err = __copy_insn(mapping, filp, insn, len, offs);
 		if (err)
-			return err;
-		bytes = nbytes;
-	}
-	return __copy_insn(mapping, filp, uprobe->arch.insn, bytes, uprobe->offset);
+			break;
+
+		insn += len;
+		offs += len;
+		size -= len;
+	} while (size);
+
+	return err;
 }
 
 static int prepare_uprobe(struct uprobe *uprobe, struct file *file,
-- 
1.5.5.1


