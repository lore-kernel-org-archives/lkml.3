Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaEVGxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 02:53:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:33556 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbaEVGxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 02:53:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,885,1392192000"; 
   d="scan'208";a="515855000"
Message-ID: <537D9EBE.7030806@intel.com>
Date: Thu, 22 May 2014 09:52:46 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ye olde task_ctx_sched_out trace.
References: <20140521150613.GA28702@redhat.com> <20140521151655.GG2485@laptop.programming.kicks-ass.net> <20140521153013.GG5226@laptop.programming.kicks-ass.net> <20140521153219.GH5226@laptop.programming.kicks-ass.net>
In-Reply-To: <20140521153219.GH5226@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2014 06:32 PM, Peter Zijlstra wrote:
> On Wed, May 21, 2014 at 05:30:13PM +0200, Peter Zijlstra wrote:
>> A little something like so I suppose.
>>
>> ---
> 
>> +void perf_event_exec(void)
>> +{
>> +	struct perf_event_context *ctx;
>> +	int ctxn;
>> +
>> +	rcu_read_lock();
>> +	for_each_task_context_nr(ctxn) {
>> +		ctx = task->perf_event_ctxp[ctxn];
> 
> s/task/current/
> 
>> +		if (!ctx)
>> +			continue;
>> +
>> +		perf_event_enable_on_exec(ctx);
>> +	}
>> +	rcu_read_unlock();
>> +}
> 
> 
> It would help if I pasted the one that actually compiles I suppose..
> 
> ---
>  fs/exec.c                  |  1 +
>  include/linux/perf_event.h |  1 +
>  kernel/events/core.c       | 28 ++++++++++++++++------------
>  3 files changed, 18 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index 476f3ebf437e..8d51d7ce3dcf 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1111,6 +1111,7 @@ void setup_new_exec(struct linux_binprm * bprm)
>  		set_dumpable(current->mm, suid_dumpable);
>  
>  	set_task_comm(current, kbasename(bprm->filename));
> +	perf_event_exec();

Shouldn't that be the other way around i.e.

+	perf_event_exec();
	set_task_comm(current, kbasename(bprm->filename));

Also what about flagging the comm event that corresponds to an exec e.g.

diff --git a/fs/exec.c b/fs/exec.c
index 476f3eb..28d69a1 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1046,13 +1046,13 @@ EXPORT_SYMBOL_GPL(get_task_comm);
  * so that a new one can be started
  */
 
-void set_task_comm(struct task_struct *tsk, const char *buf)
+void __set_task_comm(struct task_struct *tsk, const char *buf, bool exec)
 {
 	task_lock(tsk);
 	trace_task_rename(tsk, buf);
 	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
 	task_unlock(tsk);
-	perf_event_comm(tsk);
+	perf_event_comm(tsk, exec);
 }
 
 int flush_old_exec(struct linux_binprm * bprm)
@@ -1110,7 +1110,7 @@ void setup_new_exec(struct linux_binprm * bprm)
 	else
 		set_dumpable(current->mm, suid_dumpable);
 
-	set_task_comm(current, kbasename(bprm->filename));
+	__set_task_comm(current, kbasename(bprm->filename), true);
 
 	/* Set the new mm task size. We have to do that late because it may
 	 * depend on TIF_32BIT which is only updated in flush_thread() on
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index af6dcf1..26614312 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -694,7 +694,7 @@ extern struct perf_guest_info_callbacks *perf_guest_cbs;
 extern int perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
 extern int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
 
-extern void perf_event_comm(struct task_struct *tsk);
+extern void perf_event_comm(struct task_struct *tsk, bool exec);
 extern void perf_event_fork(struct task_struct *tsk);
 
 /* Callchains */
@@ -801,7 +801,7 @@ static inline int perf_unregister_guest_info_callbacks
 (struct perf_guest_info_callbacks *callbacks)				{ return 0; }
 
 static inline void perf_event_mmap(struct vm_area_struct *vma)		{ }
-static inline void perf_event_comm(struct task_struct *tsk)		{ }
+static inline void perf_event_comm(struct task_struct *tsk, bool exec)	{ }
 static inline void perf_event_fork(struct task_struct *tsk)		{ }
 static inline void perf_event_init(void)				{ }
 static inline int  perf_swevent_get_recursion_context(void)		{ return -1; }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 25f54c7..cadcf38 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2376,7 +2376,11 @@ extern long do_fork(unsigned long, unsigned long, unsigned long, int __user *, i
 struct task_struct *fork_idle(int);
 extern pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
 
-extern void set_task_comm(struct task_struct *tsk, const char *from);
+extern void __set_task_comm(struct task_struct *tsk, const char *from, bool exec);
+static inline void set_task_comm(struct task_struct *tsk, const char *from)
+{
+	__set_task_comm(tsk, from, false);
+}
 extern char *get_task_comm(char *to, struct task_struct *tsk);
 
 #ifdef CONFIG_SMP
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index e3fc8f0..8ae875a 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -501,7 +501,12 @@ struct perf_event_mmap_page {
 #define PERF_RECORD_MISC_GUEST_KERNEL		(4 << 0)
 #define PERF_RECORD_MISC_GUEST_USER		(5 << 0)
 
+/*
+ * PERF_RECORD_MISC_MMAP_DATA and PERF_RECORD_MISC_COMM_EXEC are used on
+ * different events so can reuse the same bit position.
+ */
 #define PERF_RECORD_MISC_MMAP_DATA		(1 << 13)
+#define PERF_RECORD_MISC_COMM_EXEC		(1 << 13)
 /*
  * Indicates that the content of PERF_SAMPLE_IP points to
  * the actual instruction that triggered the event. See also
diff --git a/kernel/events/core.c b/kernel/events/core.c
index ed50b09..760abd0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5067,7 +5067,7 @@ static void perf_event_comm_event(struct perf_comm_event *comm_event)
 		       NULL);
 }
 
-void perf_event_comm(struct task_struct *task)
+void perf_event_comm(struct task_struct *task, bool exec)
 {
 	struct perf_comm_event comm_event;
 	struct perf_event_context *ctx;
@@ -5093,7 +5093,7 @@ void perf_event_comm(struct task_struct *task)
 		.event_id  = {
 			.header = {
 				.type = PERF_RECORD_COMM,
-				.misc = 0,
+				.misc = exec ? PERF_RECORD_MISC_COMM_EXEC : 0,
 				/* .size */
 			},
 			/* .pid */

