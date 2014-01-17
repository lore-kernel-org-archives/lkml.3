Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbaAQP0O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:26:14 -0500
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:39157
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752615AbaAQPSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 10:18:40 -0500
Message-Id: <20140117151835.090700113@linux.com>
Date: Fri, 17 Jan 2014 09:18:19 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Robert Richter <rric@kernel.org>,
        oprofile-list@lists.sf.net
Subject: [PATCH 07/41] drivers/oprofile: Replace __get_cpu_var uses for address calculation
References: <20140117151812.770437629@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=this_drivers_oprofile
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the uses of __get_cpu_var for address calculation with this_cpu_ptr.

Cc: Robert Richter <rric@kernel.org>
Cc: oprofile-list@lists.sf.net
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/drivers/oprofile/cpu_buffer.c
===================================================================
--- linux.orig/drivers/oprofile/cpu_buffer.c	2013-12-02 16:07:48.614666335 -0600
+++ linux/drivers/oprofile/cpu_buffer.c	2013-12-02 16:07:48.614666335 -0600
@@ -45,7 +45,7 @@ unsigned long oprofile_get_cpu_buffer_si
 
 void oprofile_cpu_buffer_inc_smpl_lost(void)
 {
-	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(op_cpu_buffer);
+	struct oprofile_cpu_buffer *cpu_buf = this_cpu_ptr(&op_cpu_buffer);
 
 	cpu_buf->sample_lost_overflow++;
 }
@@ -297,7 +297,7 @@ __oprofile_add_ext_sample(unsigned long
 			  unsigned long event, int is_kernel,
 			  struct task_struct *task)
 {
-	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(op_cpu_buffer);
+	struct oprofile_cpu_buffer *cpu_buf = this_cpu_ptr(&op_cpu_buffer);
 	unsigned long backtrace = oprofile_backtrace_depth;
 
 	/*
@@ -357,7 +357,7 @@ oprofile_write_reserve(struct op_entry *
 {
 	struct op_sample *sample;
 	int is_kernel = !user_mode(regs);
-	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(op_cpu_buffer);
+	struct oprofile_cpu_buffer *cpu_buf = this_cpu_ptr(&op_cpu_buffer);
 
 	cpu_buf->sample_received++;
 
@@ -412,13 +412,13 @@ int oprofile_write_commit(struct op_entr
 
 void oprofile_add_pc(unsigned long pc, int is_kernel, unsigned long event)
 {
-	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(op_cpu_buffer);
+	struct oprofile_cpu_buffer *cpu_buf = this_cpu_ptr(&op_cpu_buffer);
 	log_sample(cpu_buf, pc, 0, is_kernel, event, NULL);
 }
 
 void oprofile_add_trace(unsigned long pc)
 {
-	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(op_cpu_buffer);
+	struct oprofile_cpu_buffer *cpu_buf = this_cpu_ptr(&op_cpu_buffer);
 
 	if (!cpu_buf->tracing)
 		return;
Index: linux/drivers/oprofile/timer_int.c
===================================================================
--- linux.orig/drivers/oprofile/timer_int.c	2013-12-02 16:07:48.614666335 -0600
+++ linux/drivers/oprofile/timer_int.c	2013-12-02 16:07:48.614666335 -0600
@@ -32,7 +32,7 @@ static enum hrtimer_restart oprofile_hrt
 
 static void __oprofile_hrtimer_start(void *unused)
 {
-	struct hrtimer *hrtimer = &__get_cpu_var(oprofile_hrtimer);
+	struct hrtimer *hrtimer = this_cpu_ptr(&oprofile_hrtimer);
 
 	if (!ctr_running)
 		return;

