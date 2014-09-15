Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbaIOJgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 05:36:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60895 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610AbaIOJgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 05:36:11 -0400
Date: Mon, 15 Sep 2014 11:36:08 +0200
From: Michal Hocko <mhocko@suse.cz>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Tejun Heo <tj@kernel.org>, Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Message-ID: <20140915093608.GA19976@dhcp22.suse.cz>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com>
 <1527959.PBej7RR7ig@vostro.rjw.lan>
 <20140915005657.GA11267@mtj.dyndns.org>
 <4489261.oHB60C5hao@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4489261.oHB60C5hao@vostro.rjw.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 15-09-14 05:34:36, Rafael J. Wysocki wrote:
> On Monday, September 15, 2014 09:56:57 AM Tejun Heo wrote:
> > On Sun, Sep 14, 2014 at 06:43:31PM +0200, Rafael J. Wysocki wrote:
> > > On Saturday, September 13, 2014 08:59:35 AM Tejun Heo wrote:
> > > > Doesn't this mean that if PM freezing and OOM killing race each other,
> > > > the system may hang?  Driver PM operation may try to allocate memory
> > > > -> triggers OOM -> OOM killer selects an already frozen task ->
> > > > nothing happens.  I wonder whether OOM killing and PM operations
> > > > should be mutually exclusive at a higher level.  e.g. make OOM killing
> > > > always override freezing but let hibernation abort operation before
> > > > taking snapshot if OOM killing has happened since the beginning of the
> > > > PM operation.
> > > 
> > > As Michal noted, we do oom_killer_disable() in freeze_processes(), so the
> > > scenario above cannot actually happen to my eyes.  Or am I missing anything?
> > 
> > Ah, okay, that's better but it doesn't seem enough.  It does prevent
> > new invocations of the oom killer but doesn't do anything if oom
> > killing is already in progress.  If we do block out oom killing
> > properly across PM freeze/thaw, it shoud be fine.
> 
> OK, so my assumption was that oom_killer_disable() would wait for the OOM
> killing in progress to complete.  Alternatively, it can return an error code
> if OOM killing is in progress and we can simply fail the freezing in that
> case.

You will need to check all the tasks again after oom_killer_disable.
Something like the following should work. I am not familiar with PM much
so I might have missed something. I didn't like direct do_each_thread loop
but there doesn't seem to be any helper and other callers are doing
something slightly different in the loop.

This patch builds on top of Cong Wang's. What do you think?
---
>From cdf97a20b107ee584352f07274a88d7c3f014ab2 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Mon, 15 Sep 2014 10:52:30 +0200
Subject: [PATCH] OOM, PM: OOM killed task cannot escape PM suspend

PM freezer relies on having all tasks frozen by the time devices are
getting frozen so that no task will touch them while they are getting
frozen. But OOM killer is allowed to kill an already frozen task in
order to handle OOM situtation. In order to protect from late wake ups
OOM killer is disabled after all tasks are frozen. This, however, still
keeps an window open when a killed task didn't manage to die by the time
freeze_processes finishes. Fix this by checking all tasks after OOM
killer has been disabled. To prevent from useless check also introduce
and check oom_kills count which gets incremented when a task is killed
by OOM killer. All the tasks have to be checked only if the counter
changes.

Frozen tasks might get killed by OOM killer.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 include/linux/oom.h    |  2 ++
 kernel/power/process.c | 31 ++++++++++++++++++++++++++++++-
 mm/oom_kill.c          | 14 ++++++++++++++
 3 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/include/linux/oom.h b/include/linux/oom.h
index 647395a1a550..8927b6e443b5 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -50,6 +50,8 @@ static inline bool oom_task_origin(const struct task_struct *p)
 extern unsigned long oom_badness(struct task_struct *p,
 		struct mem_cgroup *memcg, const nodemask_t *nodemask,
 		unsigned long totalpages);
+
+extern int oom_kills_count(void);
 extern void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 			     unsigned int points, unsigned long totalpages,
 			     struct mem_cgroup *memcg, nodemask_t *nodemask,
diff --git a/kernel/power/process.c b/kernel/power/process.c
index 4ee194eb524b..6ccc2e10724d 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -118,6 +118,7 @@ static int try_to_freeze_tasks(bool user_only)
 int freeze_processes(void)
 {
 	int error;
+	int oom_kills_saved;
 
 	error = __usermodehelper_disable(UMH_FREEZING);
 	if (error)
@@ -131,12 +132,40 @@ int freeze_processes(void)
 
 	printk("Freezing user space processes ... ");
 	pm_freezing = true;
+	oom_kills_saved = oom_kills_count();
 	error = try_to_freeze_tasks(true);
 	if (!error) {
-		printk("done.");
 		__usermodehelper_set_disable_depth(UMH_DISABLED);
 		oom_killer_disable();
+
+		/*
+		 * There was a OOM kill while we were freezing tasks
+		 * and the killed task might be still on the way out
+		 * so we have to double check for race.
+		 */
+		if (oom_kills_count() != oom_kills_saved) {
+			struct task_struct *g, *p;
+
+			read_lock(&tasklist_lock);
+			do_each_thread(g, p) {
+				if (p == current || freezer_should_skip(p) ||
+				    frozen(p))
+					continue;
+				error = -EBUSY;
+				break;
+			} while_each_thread(g, p);
+			read_unlock(&tasklist_lock);
+
+			if (error) {
+				__usermodehelper_set_disable_depth(UMH_ENABLED);
+				oom_killer_enable();
+				printk("OOM in progress. ");
+				goto done;
+			}
+		}
+		printk("done.");
 	}
+done:
 	printk("\n");
 	BUG_ON(in_atomic());
 
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index bbf405a3a18f..57dddd7d1f12 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -404,6 +404,18 @@ static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
 		dump_tasks(memcg, nodemask);
 }
 
+/*
+ * Number of OOM killer invocations (including memcg OOM killer).
+ * Primarily used by PM freezer to check for potential races with
+ * OOM killed frozen task.
+ */
+static atomic_t oom_kills = ATOMIC_INIT(0);
+
+int oom_kills_count(void)
+{
+	return atomic_read(&oom_kills);
+}
+
 #define K(x) ((x) << (PAGE_SHIFT-10))
 /*
  * Must be called while holding a reference to p, which will be released upon
@@ -506,11 +518,13 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 			pr_err("Kill process %d (%s) sharing same memory\n",
 				task_pid_nr(p), p->comm);
 			task_unlock(p);
+			atomic_inc(&oom_kills);
 			do_send_sig_info(SIGKILL, SEND_SIG_FORCED, p, true);
 		}
 	rcu_read_unlock();
 
 	set_tsk_thread_flag(victim, TIF_MEMDIE);
+	atomic_inc(&oom_kills);
 	do_send_sig_info(SIGKILL, SEND_SIG_FORCED, victim, true);
 	put_task_struct(victim);
 }
-- 
2.1.0


-- 
Michal Hocko
SUSE Labs
