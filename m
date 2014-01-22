Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbaAVRqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 12:46:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbaAVRqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 12:46:20 -0500
Date: Wed, 22 Jan 2014 18:45:53 +0100
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
Subject: [PATCH 0/2] mm->def_flags cleanups (Was: Change khugepaged to
	respect MMF_THP_DISABLE flag)
Message-ID: <20140122174553.GA29710@redhat.com>
References: <1bc8f911363af956b37d8ea415d734f3191f1c78.1389905087.git.athorlton@sgi.com> <13c9d1b0213af7cee7afb54de368a0b189e98df8.1389905087.git.athorlton@sgi.com> <20140118234957.GB10970@node.dhcp.inet.fi> <20140120195812.GD18196@sgi.com> <20140120201525.GA31416@redhat.com> <20140120204108.GE18196@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120204108.GE18196@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex, Andrew, I think this simple series makes sense in any case,
but _perhaps_ it can also help THP_DISABLE.

On 01/20, Alex Thorlton wrote:
>
> On Mon, Jan 20, 2014 at 09:15:25PM +0100, Oleg Nesterov wrote:
> >
> > Although I got lost a bit, and probably misunderstood... but it
> > seems to me that whatever you do this patch should not touch
> > khugepaged_scan_mm_slot.
>
> Maybe I've gotten myself confused as well :)  After looking through the
> code some more, my understanding is that khugepaged_test_exit is used to
> make sure that __khugepaged_exit isn't running from underneath at certain
> times, so to have khugepaged_test_exit return true when __khugepaged_exit
> is not necessarily running, seems incorrect to me.

Still can't understand... probably I need to see v3.

But you know, I have another idea. Not sure you will like it, and probably
I missed something.

Can't we simply add VM_NOHUGEPAGE into ->def_flags? See the (untested)
patch below, on top of this series.

What do you think?

Oleg.


diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1cedd00..bc1dd9e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -167,6 +167,8 @@ extern unsigned int kobjsize(const void *objp);
  */
 #define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_PFNMAP)
 
+#define VM_INIT_DEF_MASK	VM_NOHUGEPAGE
+
 /*
  * mapping from the currently active vm_flags protection bits (the
  * low four bits) to a page protection mask..
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 289760f..58afc04 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -149,4 +149,7 @@
 
 #define PR_GET_TID_ADDRESS	40
 
+#define PR_SET_THP_DISABLE	41
+#define PR_GET_THP_DISABLE	42
+
 #endif /* _LINUX_PRCTL_H */
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
diff --git a/kernel/sys.c b/kernel/sys.c
index ac1842e..eb8b0fc 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2029,6 +2029,19 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		if (arg2 || arg3 || arg4 || arg5)
 			return -EINVAL;
 		return current->no_new_privs ? 1 : 0;
+	case PR_SET_THP_DISABLE:
+	case PR_GET_THP_DISABLE:
+		down_write(&me->mm->mmap_sem);
+		if (option == PR_SET_THP_DISABLE) {
+			if (arg2)
+				me->mm->def_flags |= VM_NOHUGEPAGE;
+			else
+				me->mm->def_flags &= ~VM_NOHUGEPAGE;
+		} else {
+			error = !!(me->mm->flags && VM_NOHUGEPAGE);
+		}
+		up_write(&me->mm->mmap_sem);
+		break;
 	default:
 		error = -EINVAL;
 		break;

