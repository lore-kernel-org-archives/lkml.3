Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbaEEPNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 11:13:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbaEEPNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 11:13:51 -0400
Date: Mon, 5 May 2014 17:13:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>, Hugh Dickins <hughd@google.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH] uprobes: Add mem_cgroup_charge_anon() into
	uprobe_write_opcode()
Message-ID: <20140505151320.GA25611@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh says:

    The one I noticed was that it forgets all about memcg (because
    it was copied from KSM, and there the replacement page has already
    been charged to a memcg). See how mm/memory.c do_anonymous_page()
    does a mem_cgroup_charge_anon().

Hopefully not a big problem, uprobes is a system-wide thing and only
root can insert the probes. But I agree, should be fixed anyway.

Add mem_cgroup_{un,}charge_anon() into uprobe_write_opcode(). To simplify
the error handling (and avoid the new "uncharge" label) the patch also
moves anon_vma_prepare() up before we alloc/charge the new page.

While at it fix the comment about ->mmap_sem, it is held for write.

Suggested-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 7716c40..a13251e 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -279,18 +279,13 @@ static int verify_opcode(struct page *page, unsigned long vaddr, uprobe_opcode_t
  * supported by that architecture then we need to modify is_trap_at_addr and
  * uprobe_write_opcode accordingly. This would never be a problem for archs
  * that have fixed length instructions.
- */
-
-/*
+ *
  * uprobe_write_opcode - write the opcode at a given virtual address.
  * @mm: the probed process address space.
  * @vaddr: the virtual address to store the opcode.
  * @opcode: opcode to be written at @vaddr.
  *
- * Called with mm->mmap_sem held (for read and with a reference to
- * mm).
- *
- * For mm @mm, write the opcode at @vaddr.
+ * Called with mm->mmap_sem held for write.
  * Return 0 (success) or a negative errno.
  */
 int uprobe_write_opcode(struct mm_struct *mm, unsigned long vaddr,
@@ -310,21 +305,25 @@ retry:
 	if (ret <= 0)
 		goto put_old;
 
+	ret = anon_vma_prepare(vma);
+	if (ret)
+		goto put_old;
+
 	ret = -ENOMEM;
 	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, vaddr);
 	if (!new_page)
 		goto put_old;
 
-	__SetPageUptodate(new_page);
+	if (mem_cgroup_charge_anon(new_page, mm, GFP_KERNEL))
+		goto put_new;
 
+	__SetPageUptodate(new_page);
 	copy_highpage(new_page, old_page);
 	copy_to_page(new_page, vaddr, &opcode, UPROBE_SWBP_INSN_SIZE);
 
-	ret = anon_vma_prepare(vma);
-	if (ret)
-		goto put_new;
-
 	ret = __replace_page(vma, vaddr, old_page, new_page);
+	if (ret)
+		mem_cgroup_uncharge_page(new_page);
 
 put_new:
 	page_cache_release(new_page);
-- 
1.5.5.1


