Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161205AbaJ3Rm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 13:42:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48847 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934023AbaJ3Rmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 13:42:43 -0400
Date: Thu, 30 Oct 2014 18:42:41 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, riel@redhat.com, peterz@infradead.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: initialize variable for mem_cgroup_end_page_stat
Message-ID: <20141030174241.GD3639@dhcp22.suse.cz>
References: <1414633464-19419-1-git-send-email-sasha.levin@oracle.com>
 <20141030082712.GB4664@dhcp22.suse.cz>
 <54523DDE.9000904@oracle.com>
 <20141030141401.GA24520@phnom.home.cmpxchg.org>
 <54524A2F.5050907@oracle.com>
 <20141030153159.GA3639@dhcp22.suse.cz>
 <20141030172632.GA25217@phnom.home.cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141030172632.GA25217@phnom.home.cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 30-10-14 13:26:32, Johannes Weiner wrote:
> On Thu, Oct 30, 2014 at 04:31:59PM +0100, Michal Hocko wrote:
> > On Thu 30-10-14 10:24:47, Sasha Levin wrote:
> > > On 10/30/2014 10:14 AM, Johannes Weiner wrote:
> > > >> The problem is that you are attempting to read 'locked' when you call
> > > >> > mem_cgroup_end_page_stat(), so it gets used even before you enter the
> > > >> > function - and using uninitialized variables is undefined.
> > > > We are not using that value anywhere if !memcg.  What path are you
> > > > referring to?
> > > 
> > > You're using that value as soon as you are passing it to a function, it
> > > doesn't matter what happens inside that function.
> > 
> > I have discussed that with our gcc guys and you are right. Strictly
> > speaking the compiler is free to do
> > if (!memcg) abort();
> > mem_cgroup_end_page_stat(...);
> > 
> > but it is highly unlikely that this will ever happen. Anyway better be
> > safe than sorry. I guess the following should be sufficient and even
> > more symmetric:
> 
> The functional aspect of this is a terrible motivation for this
> change.  Sure the compiler could, but it doesn't, and it won't.
> 
> But there is some merit in keeping the checker's output meaningful as
> long as it doesn't obfuscate the interface too much.
> 
> > From 6c3e748af7ee24984477e850bb93d65f83914903 Mon Sep 17 00:00:00 2001
> > From: Michal Hocko <mhocko@suse.cz>
> > Date: Thu, 30 Oct 2014 16:18:23 +0100
> > Subject: [PATCH] mm, memcg: fix potential undefined when for page stat
> >  accounting
> > 
> > since d7365e783edb (mm: memcontrol: fix missed end-writeback page
> > accounting) mem_cgroup_end_page_stat consumes locked and flags variables
> > directly rather than via pointers which might trigger C undefined
> > behavior as those variables are initialized only in the slow path of
> > mem_cgroup_begin_page_stat.
> > Although mem_cgroup_end_page_stat handles parameters correctly and
> > touches them only when they hold a sensible value it is caller which
> > loads a potentially uninitialized value which then might allow compiler
> > to do crazy things.
> 
> I'm not opposed to passing pointers into end_page_stat(), but please
> mention the checker in the changelog.

Done.
 
> > Fix this by using pointer parameters for both locked and flags. This is
> > even better from the API point of view because it is symmetrical to
> > mem_cgroup_begin_page_stat.
> 
> Uhm, locked and flags are return values in begin_page_stat() but input
> arguments in end_page_stat().  Symmetry obfuscates that, so that's not
> an upside at all.  It's a cost that we can pay to keep the checker

Well, I would use a typedef to obfuscate those values because nobody
except for mem_cgroup_{begin,end}_page_stat should touch them. But we
are not doing typedefs in kernel...

> benefits, but the underlying nastiness remains.  It comes from the
> fact that we use conditional locking to avoid the read-side spinlock,
> rather than using a reader-friendly lock to begin with.
 
> So let's change it to pointers, but at the same time be clear that
> this doesn't make the code better.  It just fixes the checker.

No it is not about the checker which is correct here actually. A simple
load to setup parameter from an uninitialized variable is an undefined
behavior (that load happens unconditionally). This has nothing to do
with the way how we use locked and flags inside the function.

New version with an updated changelog
---
>From b2762f30d3896172c5666066e72938b3f5f9158a Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Thu, 30 Oct 2014 18:35:19 +0100
Subject: [PATCH] mm, memcg: fix potential undefined when for page stat
 accounting

since d7365e783edb (mm: memcontrol: fix missed end-writeback page
accounting) mem_cgroup_end_page_stat consumes locked and flags variables
directly rather than via pointers which might trigger C undefined
behavior as those variables are initialized only in the slow path of
mem_cgroup_begin_page_stat.
Although mem_cgroup_end_page_stat handles parameters correctly and
touches them only when they hold a sensible value it is caller which
loads a potentially uninitialized value which then might allow compiler
to do crazy things.

I haven't seen any warning from gcc and it seems that the current
version (4.9) doesn't exploit this type undefined behavior but Sasha has
reported the following:
[   26.868116] ================================================================================
[   26.870376] UBSan: Undefined behaviour in mm/rmap.c:1084:2
[   26.871792] load of value 255 is not a valid value for type '_Bool'
[   26.873256] CPU: 4 PID: 8304 Comm: rngd Not tainted 3.18.0-rc2-next-20141029-sasha-00039-g77ed13d-dirty #1427
[   26.875636]  ffff8800cac17ff0 0000000000000000 0000000000000000 ffff880069ffbb28
[   26.877611]  ffffffffaf010c16 0000000000000037 ffffffffb1c0d050 ffff880069ffbb38
[   26.879140]  ffffffffa6e97899 ffff880069ffbbb8 ffffffffa6e97cc7 ffff880069ffbbb8
[   26.880765] Call Trace:
[   26.881185] dump_stack (lib/dump_stack.c:52)
[   26.882755] ubsan_epilogue (lib/ubsan.c:159)
[   26.883555] __ubsan_handle_load_invalid_value (lib/ubsan.c:482)
[   26.884492] ? mem_cgroup_begin_page_stat (mm/memcontrol.c:1962)
[   26.885441] ? unmap_page_range (./arch/x86/include/asm/paravirt.h:694 mm/memory.c:1091 mm/memory.c:1258 mm/memory.c:1279 mm/memory.c:1303)
[   26.886242] page_remove_rmap (mm/rmap.c:1084 mm/rmap.c:1096)
[   26.886922] unmap_page_range (./arch/x86/include/asm/atomic.h:27 include/linux/mm.h:463 mm/memory.c:1146 mm/memory.c:1258 mm/memory.c:1279 mm/memory.c:1303)
[   26.887824] unmap_single_vma (mm/memory.c:1348)
[   26.888582] unmap_vmas (mm/memory.c:1377 (discriminator 3))
[   26.889430] exit_mmap (mm/mmap.c:2837)
[   26.890060] mmput (kernel/fork.c:659)
[   26.890656] do_exit (./arch/x86/include/asm/thread_info.h:168 kernel/exit.c:462 kernel/exit.c:747)
[   26.891359] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
[   26.892287] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2559 kernel/locking/lockdep.c:2601)
[   26.893107] ? syscall_trace_enter_phase2 (arch/x86/kernel/ptrace.c:1598 (discriminator 2))
[   26.893974] do_group_exit (include/linux/sched.h:775 kernel/exit.c:873)
[   26.894695] SyS_exit_group (kernel/exit.c:901)
[   26.895433] tracesys_phase2 (arch/x86/kernel/entry_64.S:529)
[   26.896134] ================================================================================

Fix this by using pointer parameters for both locked and flags and be
more robust for future compiler changes even though the current code is
implemented correctly.

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 include/linux/memcontrol.h | 6 +++---
 mm/memcontrol.c            | 8 ++++----
 mm/page-writeback.c        | 4 ++--
 mm/rmap.c                  | 4 ++--
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index d4575a1d6e99..de018766be45 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -141,8 +141,8 @@ static inline bool mem_cgroup_disabled(void)
 
 struct mem_cgroup *mem_cgroup_begin_page_stat(struct page *page, bool *locked,
 					      unsigned long *flags);
-void mem_cgroup_end_page_stat(struct mem_cgroup *memcg, bool locked,
-			      unsigned long flags);
+void mem_cgroup_end_page_stat(struct mem_cgroup *memcg, bool *locked,
+			      unsigned long *flags);
 void mem_cgroup_update_page_stat(struct mem_cgroup *memcg,
 				 enum mem_cgroup_stat_index idx, int val);
 
@@ -297,7 +297,7 @@ static inline struct mem_cgroup *mem_cgroup_begin_page_stat(struct page *page,
 }
 
 static inline void mem_cgroup_end_page_stat(struct mem_cgroup *memcg,
-					bool locked, unsigned long flags)
+					bool *locked, unsigned long *flags)
 {
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b841bf430179..031ca345677b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2053,11 +2053,11 @@ again:
  * @locked: value received from mem_cgroup_begin_page_stat()
  * @flags: value received from mem_cgroup_begin_page_stat()
  */
-void mem_cgroup_end_page_stat(struct mem_cgroup *memcg, bool locked,
-			      unsigned long flags)
+void mem_cgroup_end_page_stat(struct mem_cgroup *memcg, bool *locked,
+			      unsigned long *flags)
 {
-	if (memcg && locked)
-		spin_unlock_irqrestore(&memcg->move_lock, flags);
+	if (memcg && *locked)
+		spin_unlock_irqrestore(&memcg->move_lock, *flags);
 
 	rcu_read_unlock();
 }
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 19ceae87522d..d5d81f5384d1 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2357,7 +2357,7 @@ int test_clear_page_writeback(struct page *page)
 		dec_zone_page_state(page, NR_WRITEBACK);
 		inc_zone_page_state(page, NR_WRITTEN);
 	}
-	mem_cgroup_end_page_stat(memcg, locked, memcg_flags);
+	mem_cgroup_end_page_stat(memcg, &locked, &memcg_flags);
 	return ret;
 }
 
@@ -2399,7 +2399,7 @@ int __test_set_page_writeback(struct page *page, bool keep_write)
 		mem_cgroup_inc_page_stat(memcg, MEM_CGROUP_STAT_WRITEBACK);
 		inc_zone_page_state(page, NR_WRITEBACK);
 	}
-	mem_cgroup_end_page_stat(memcg, locked, memcg_flags);
+	mem_cgroup_end_page_stat(memcg, &locked, &memcg_flags);
 	return ret;
 
 }
diff --git a/mm/rmap.c b/mm/rmap.c
index 740dd7d15806..f782b6c2ae48 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1051,7 +1051,7 @@ void page_add_file_rmap(struct page *page)
 		__inc_zone_page_state(page, NR_FILE_MAPPED);
 		mem_cgroup_inc_page_stat(memcg, MEM_CGROUP_STAT_FILE_MAPPED);
 	}
-	mem_cgroup_end_page_stat(memcg, locked, flags);
+	mem_cgroup_end_page_stat(memcg, &locked, &flags);
 }
 
 static void page_remove_file_rmap(struct page *page)
@@ -1081,7 +1081,7 @@ static void page_remove_file_rmap(struct page *page)
 	if (unlikely(PageMlocked(page)))
 		clear_page_mlock(page);
 out:
-	mem_cgroup_end_page_stat(memcg, locked, flags);
+	mem_cgroup_end_page_stat(memcg, &locked, &flags);
 }
 
 /**
-- 
2.1.1

-- 
Michal Hocko
SUSE Labs
