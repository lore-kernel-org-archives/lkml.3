Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab3JCJEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 05:04:06 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40383 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab3JCJEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 05:04:04 -0400
Date: Thu, 3 Oct 2013 11:03:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] perf: mmap2 not covering VM_CLONE regions
Message-ID: <20131003090347.GB3081@twins.programming.kicks-ass.net>
References: <20131002133759.GH28601@twins.programming.kicks-ass.net>
 <CAGXu5jLd3yw+RasWgMg_JJPhsfiM+hVhMru4gfkXmAcn7asEdw@mail.gmail.com>
 <CABPqkBTeJarBCkVBMGex+g32ak8vzH__x1V0aq4c22dyWJKhGA@mail.gmail.com>
 <CAGXu5jJPtfXd47fG2OR5MW1tZ_MMrv5s5NR9nMvnhnFvcuNWtA@mail.gmail.com>
 <CABPqkBR428rdck2Q6_HZAKHeWg3qc5W3nXZchnew1V7oDq+Z2Q@mail.gmail.com>
 <CAGXu5jLPJRCX2G31khiMyn5eRuAMchF=k3j0qH0MdL7mXUCCrg@mail.gmail.com>
 <20131002190001.GX3081@twins.programming.kicks-ass.net>
 <CAGXu5jKK+BJnbzJy0pZxVG2BdgxdJ5vNChMRUAJdKrGaHCOsNg@mail.gmail.com>
 <20131002203107.GY3081@twins.programming.kicks-ass.net>
 <CABPqkBRbqnwRpigACZwnV4rSK2wZekZqXi-vfB2+YbSWgfTUKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBRbqnwRpigACZwnV4rSK2wZekZqXi-vfB2+YbSWgfTUKA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 10:55:28AM +0200, Stephane Eranian wrote:
> I don't know the MM code but I assume that that vm_mm struct is
> allocated dynamically
> and maybe you already grabbing a lock while doing this. Could we
> leverage that lock
> to increment a global generation number?

Sure; something like so.. I just don't like global state nor adding to
mm_struct for just this.

---
 include/linux/mm_types.h | 1 +
 kernel/fork.c            | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index d9851eeb6e1d..3877b1e72a5b 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -436,6 +436,7 @@ struct mm_struct {
 	int first_nid;
 #endif
 	struct uprobes_state uprobes_state;
+	u64 mm_id;
 };
 
 /* first nid will either be a valid NID or one of these values */
diff --git a/kernel/fork.c b/kernel/fork.c
index 086fe73ad6bd..b315f6227629 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -523,6 +523,8 @@ static void mm_init_aio(struct mm_struct *mm)
 #endif
 }
 
+static u64 global_mm_id;
+
 static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
 {
 	atomic_set(&mm->mm_users, 1);
@@ -537,6 +539,7 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
 	spin_lock_init(&mm->page_table_lock);
 	mm_init_aio(mm);
 	mm_init_owner(mm, p);
+	mm->mm_id = 0;
 
 	if (likely(!mm_alloc_pgd(mm))) {
 		mm->def_flags = 0;
@@ -1422,6 +1425,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	 */
 	write_lock_irq(&tasklist_lock);
 
+	if (p->mm && !p->mm->mm_id)
+		p->mm->mm_id = ++global_mm_id;
+
 	/* CLONE_PARENT re-uses the old parent */
 	if (clone_flags & (CLONE_PARENT|CLONE_THREAD)) {
 		p->real_parent = current->real_parent;
