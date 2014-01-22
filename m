Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbaAVSL7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 13:11:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbaAVSL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 13:11:56 -0500
Date: Wed, 22 Jan 2014 19:11:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alex Thorlton <athorlton@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 0/2] mm->def_flags cleanups (Was: Change khugepaged to
	respect MMF_THP_DISABLE flag)
Message-ID: <20140122181124.GA31090@redhat.com>
References: <1bc8f911363af956b37d8ea415d734f3191f1c78.1389905087.git.athorlton@sgi.com> <13c9d1b0213af7cee7afb54de368a0b189e98df8.1389905087.git.athorlton@sgi.com> <20140118234957.GB10970@node.dhcp.inet.fi> <20140120195812.GD18196@sgi.com> <20140120201525.GA31416@redhat.com> <20140120204108.GE18196@sgi.com> <20140122174553.GA29710@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140122174553.GA29710@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22, Oleg Nesterov wrote:
>
> Can't we simply add VM_NOHUGEPAGE into ->def_flags? See the (untested)
> patch below, on top of this series.

And perhaps the patch below makes sense as a separate change, I dunno.


------------------------------------------------------------------------------
Subject: [PATCH] mm: introduce VM_INIT_DEF_MASK

mm_init() always sets new_mm->def_flags = 0. We might want to
inherit some bits like we do with mm->flags.

Add the new VM_INIT_DEF_MASK (currently zero) which acts like
MMF_INIT_MASK for ->def_flags.
---
 include/linux/mm.h |    2 ++
 kernel/fork.c      |   11 ++++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1cedd00..0a340c9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -167,6 +167,8 @@ extern unsigned int kobjsize(const void *objp);
  */
 #define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_PFNMAP)
 
+#define VM_INIT_DEF_MASK	0
+
 /*
  * mapping from the currently active vm_flags protection bits (the
  * low four bits) to a page protection mask..
diff --git a/kernel/fork.c b/kernel/fork.c
index b84bef7..f6d020b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -529,8 +529,6 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
 	atomic_set(&mm->mm_count, 1);
 	init_rwsem(&mm->mmap_sem);
 	INIT_LIST_HEAD(&mm->mmlist);
-	mm->flags = (current->mm) ?
-		(current->mm->flags & MMF_INIT_MASK) : default_dump_filter;
 	mm->core_state = NULL;
 	atomic_long_set(&mm->nr_ptes, 0);
 	memset(&mm->rss_stat, 0, sizeof(mm->rss_stat));
@@ -538,8 +536,15 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
 	mm_init_aio(mm);
 	mm_init_owner(mm, p);
 
-	if (likely(!mm_alloc_pgd(mm))) {
+	if (current->mm) {
+		mm->flags = current->mm->flags & MMF_INIT_MASK;
+		mm->def_flags = current->mm->def_flags & VM_INIT_DEF_MASK;
+	} else {
+		mm->flags = default_dump_filter;
 		mm->def_flags = 0;
+	}
+
+	if (likely(!mm_alloc_pgd(mm))) {
 		mmu_notifier_mm_init(mm);
 		return mm;
 	}
-- 
1.5.5.1


