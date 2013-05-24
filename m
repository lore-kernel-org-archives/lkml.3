Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab3EXTXo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 15:23:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15191 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025Ab3EXTXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 15:23:42 -0400
X-Authority-Analysis: v=2.0 cv=MNbiabll c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=s9b0WtSLZS4A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=_vU5-hpMSx0A:10 a=vTr9H3xdAAAA:8 a=3GGo4NZLzqwFqJpmK_EA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1369423420.6828.226.camel@gandalf.local.home>
Subject: Re: rcu_read_lock() used illegally while idle!
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: paulmck@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
        fweisbec@gmail.com
Date: Fri, 24 May 2013 15:23:40 -0400
In-Reply-To: <20130524142338.GB3106@redhat.com>
References: <20130521173100.GA2076@redhat.com>
	 <20130522093624.GZ3578@linux.vnet.ibm.com>
	 <1369226958.6828.175.camel@gandalf.local.home>
	 <20130523164004.GJ16419@redhat.com>
	 <1369403180.6828.223.camel@gandalf.local.home>
	 <20130524142338.GB3106@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-24 at 10:23 -0400, Dave Jones wrote:

> .config: http://paste.fedoraproject.org/14281/94052971/raw/
> 
> trace shows the problem process was 'cc1', so I was likely building a kernel
> at the time.  There was also a trinity run going on in the background.
> 
> cmdline: nothing special..
> 
> BOOT_IMAGE=/vmlinuz-3.10.0-rc2+ root=UUID=bee21cd9-1852-4d1d-9e9d-2e44332b8df1 ro rd.md=0 rd.lvm=0 rd.dm=0 vconsole.keymap=us rd.luks=0 vconsole.font=latarcyrheb-sun16 consoleblank=0 console=ttyUSB0,115200 console=tty0 pause_on_oops=30 audit=0
> 

OK, I'm able to reproduce this. Looks like the same issue happens from
other ways from userspace into the kernel (the next way was tracing
system calls).

Forget the other patch. Here's a new patch that is more specific to
tracing and context tracking.

Can you try this one out, please.

-- Steve

diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index 87a03c7..f5d4723 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -33,9 +33,25 @@ do { \
 		preempt_schedule(); \
 } while (0)
 
+#ifdef CONFIG_CONTEXT_TRACKING
+
+void preempt_schedule_context(void);
+
+#define preempt_check_resched_context() \
+do { \
+	if (unlikely(test_thread_flag(TIF_NEED_RESCHED))) \
+		preempt_schedule_context(); \
+} while (0)
+#else
+
+#define preempt_check_resched_context() preempt_check_resched()
+
+#endif /* CONFIG_CONTEXT_TRACKING */
+
 #else /* !CONFIG_PREEMPT */
 
 #define preempt_check_resched()		do { } while (0)
+#define preempt_check_resched_context()	do { } while (0)
 
 #endif /* CONFIG_PREEMPT */
 
@@ -88,7 +104,7 @@ do { \
 do { \
 	preempt_enable_no_resched_notrace(); \
 	barrier(); \
-	preempt_check_resched(); \
+	preempt_check_resched_context(); \
 } while (0)
 
 #else /* !CONFIG_PREEMPT_COUNT */
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index 65349f0..ac3a312 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -71,6 +71,46 @@ void user_enter(void)
 	local_irq_restore(flags);
 }
 
+/**
+ * preempt_schedule_context - preempt_schedule called by tracing
+ *
+ * The tracing infrastructure uses preempt_enable_notrace to prevent
+ * recursion and tracing preempt enabling caused by the tracing
+ * infrastructure itself. But as tracing can happen in areas coming
+ * from userspace or just about to enter userspace, a preempt enable
+ * can occur before user_exit() is called. This will cause the scheduler
+ * to be called when the system is still in usermode.
+ *
+ * To prevent this, the preempt_enable_notrace will use this function
+ * instead of preempt_schedule() to exit user context if needed before
+ * calling the scheduler.
+ */
+void __sched notrace preempt_schedule_context(void)
+{
+	struct thread_info *ti = current_thread_info();
+	enum ctx_state prev_ctx;
+
+	if (likely(ti->preempt_count || irqs_disabled()))
+		return;
+
+	/*
+	 * Need to disable preemption in case user_exit() is traced
+	 * and the tracer calls preempt_enable_notrace() causing
+	 * an infinite recursion.
+	 */
+	preempt_disable_notrace();
+	prev_ctx = this_cpu_read(context_tracking.state);
+	user_exit();
+	preempt_enable_no_resched_notrace();
+
+	preempt_schedule();
+
+	preempt_disable_notrace();
+	if (prev_ctx == IN_USER)
+		user_enter();
+	preempt_enable_notrace();
+}
+EXPORT_SYMBOL(preempt_schedule_context);
 
 /**
  * user_exit - Inform the context tracking that the CPU is


