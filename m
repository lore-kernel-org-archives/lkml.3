Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905Ab3EIRIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 13:08:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14572 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab3EIRIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 13:08:34 -0400
X-Authority-Analysis: v=2.0 cv=UO1f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=DN1rENdJRV0A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=CpQRuSp1N3wA:10 a=mabBo3miAAAA:8 a=nItFZe5pFLJow9BBb_EA:9 a=QEXdDO2ut3YA:10 a=glz1YkNdB40A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1368119312.7373.123.camel@gandalf.local.home>
Subject: Re: [PATCH 02/11] [BUGFIX] ftrace, kprobes: Fix a deadlock on
 ftrace_regex_lock
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>
Date: Thu, 09 May 2013 13:08:32 -0400
In-Reply-To: <1368117277.7373.119.camel@gandalf.local.home>
References: <20130509054405.30398.73831.stgit@mhiramat-M0-7522>
	 <20130509054417.30398.84254.stgit@mhiramat-M0-7522>
	 <1368116860.7373.118.camel@gandalf.local.home>
	 <1368117277.7373.119.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-09 at 12:34 -0400, Steven Rostedt wrote:
> On Thu, 2013-05-09 at 12:27 -0400, Steven Rostedt wrote:
> 
> > We probably should have a better way to initialize this. As there are 26
> > ftrace_ops currently in the kernel (and this patch doesn't cover all of
> > them). Maybe have the first time its registered to initialize it.
> 
> Crap, but it can be used before that. Hmm, I guess all ftrace functions
> will need to check that flag first. We do something similar for rt_mutex
> in -rt.

I added this on top of your patch. I kept the INIT_REGEX_LOCK as it's
only local to ftrace.c and wont spread further. Also, the
ftrace_list_end ftrace_ops is just a place holder (needed for race
conditions that can have function tracers call its stub), so it does not
need to be initialized. If anything tries to grab its mutex, that's a
bug anyway.

What do you think?

-- Steve

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 4ba3a6e..99d0fbc 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -90,6 +90,8 @@ typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip,
  *            not set this, then the ftrace infrastructure will add recursion
  *            protection for the caller.
  * STUB   - The ftrace_ops is just a place holder.
+ * INITIALIZED - The ftrace_ops has already been initialized (first use time
+ *            register_ftrace_function() is called, it will initialized the ops)
  */
 enum {
 	FTRACE_OPS_FL_ENABLED			= 1 << 0,
@@ -100,6 +102,7 @@ enum {
 	FTRACE_OPS_FL_SAVE_REGS_IF_SUPPORTED	= 1 << 5,
 	FTRACE_OPS_FL_RECURSION_SAFE		= 1 << 6,
 	FTRACE_OPS_FL_STUB			= 1 << 7,
+	FTRACE_OPS_FL_INITIALIZED		= 1 << 8,
 };
 
 struct ftrace_ops {
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 7f307e8..3fed7f0 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -934,7 +934,6 @@ static __kprobes struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
 static struct ftrace_ops kprobe_ftrace_ops __read_mostly = {
 	.func = kprobe_ftrace_handler,
 	.flags = FTRACE_OPS_FL_SAVE_REGS,
-	.regex_lock = __MUTEX_INITIALIZER(kprobe_ftrace_ops.regex_lock),
 };
 static int kprobe_ftrace_enabled;
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index ec83928..827f2fe 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -74,7 +74,6 @@
 static struct ftrace_ops ftrace_list_end __read_mostly = {
 	.func		= ftrace_stub,
 	.flags		= FTRACE_OPS_FL_RECURSION_SAFE | FTRACE_OPS_FL_STUB,
-	INIT_REGEX_LOCK(ftrace_list_end)
 };
 
 /* ftrace_enabled is a method to turn ftrace on or off */
@@ -139,6 +138,16 @@ static void ftrace_ops_no_ops(unsigned long ip, unsigned long parent_ip);
 	while (likely(op = rcu_dereference_raw((op)->next)) &&	\
 	       unlikely((op) != &ftrace_list_end))
 
+static inline void ftrace_ops_init(struct ftrace_ops *ops)
+{
+#ifdef CONFIG_DYNAMIC_FTRACE
+	if (!(ops->flags & FTRACE_OPS_FL_INITIALIZED)) {
+		mutex_init(&ops->regex_lock);
+		ops->flags |= FTRACE_OPS_FL_INITIALIZED;
+	}
+#endif
+}
+
 /**
  * ftrace_nr_registered_ops - return number of ops registered
  *
@@ -915,7 +924,7 @@ static void unregister_ftrace_profiler(void)
 #else
 static struct ftrace_ops ftrace_profile_ops __read_mostly = {
 	.func		= function_profile_call,
-	.flags		= FTRACE_OPS_FL_RECURSION_SAFE,
+	.flags		= FTRACE_OPS_FL_RECURSION_SAFE | FTRACE_OPS_FL_INITIALIZED,
 	INIT_REGEX_LOCK(ftrace_profile_ops)
 };
 
@@ -1112,7 +1121,7 @@ static struct ftrace_ops global_ops = {
 	.func			= ftrace_stub,
 	.notrace_hash		= EMPTY_HASH,
 	.filter_hash		= EMPTY_HASH,
-	.flags			= FTRACE_OPS_FL_RECURSION_SAFE,
+	.flags			= FTRACE_OPS_FL_RECURSION_SAFE | FTRACE_OPS_FL_INITIALIZED,
 	INIT_REGEX_LOCK(global_ops)
 };
 
@@ -1255,6 +1264,7 @@ static void free_ftrace_hash_rcu(struct ftrace_hash *hash)
 
 void ftrace_free_filter(struct ftrace_ops *ops)
 {
+	ftrace_ops_init(ops);
 	free_ftrace_hash(ops->filter_hash);
 	free_ftrace_hash(ops->notrace_hash);
 }
@@ -2632,6 +2642,8 @@ ftrace_regex_open(struct ftrace_ops *ops, int flag,
 	struct ftrace_hash *hash;
 	int ret = 0;
 
+	ftrace_ops_init(ops);
+
 	if (unlikely(ftrace_disabled))
 		return -ENODEV;
 
@@ -2918,6 +2930,7 @@ static void function_trace_probe_call(unsigned long ip, unsigned long parent_ip,
 static struct ftrace_ops trace_probe_ops __read_mostly =
 {
 	.func		= function_trace_probe_call,
+	.flags		= FTRACE_OPS_FL_INITIALIZED,
 	INIT_REGEX_LOCK(trace_probe_ops)
 };
 
@@ -3401,6 +3414,7 @@ ftrace_set_addr(struct ftrace_ops *ops, unsigned long ip, int remove,
 int ftrace_set_filter_ip(struct ftrace_ops *ops, unsigned long ip,
 			 int remove, int reset)
 {
+	ftrace_ops_init(ops);
 	return ftrace_set_addr(ops, ip, remove, reset, 1);
 }
 EXPORT_SYMBOL_GPL(ftrace_set_filter_ip);
@@ -3425,6 +3439,7 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
 int ftrace_set_filter(struct ftrace_ops *ops, unsigned char *buf,
 		       int len, int reset)
 {
+	ftrace_ops_init(ops);
 	return ftrace_set_regex(ops, buf, len, reset, 1);
 }
 EXPORT_SYMBOL_GPL(ftrace_set_filter);
@@ -3443,6 +3458,7 @@ EXPORT_SYMBOL_GPL(ftrace_set_filter);
 int ftrace_set_notrace(struct ftrace_ops *ops, unsigned char *buf,
 			int len, int reset)
 {
+	ftrace_ops_init(ops);
 	return ftrace_set_regex(ops, buf, len, reset, 0);
 }
 EXPORT_SYMBOL_GPL(ftrace_set_notrace);
@@ -3533,6 +3549,8 @@ ftrace_set_early_filter(struct ftrace_ops *ops, char *buf, int enable)
 {
 	char *func;
 
+	ftrace_ops_init(ops);
+
 	while (buf) {
 		func = strsep(&buf, ",");
 		ftrace_set_regex(ops, func, strlen(func), 0, enable);
@@ -4135,7 +4153,7 @@ void __init ftrace_init(void)
 
 static struct ftrace_ops global_ops = {
 	.func			= ftrace_stub,
-	.flags			= FTRACE_OPS_FL_RECURSION_SAFE,
+	.flags			= FTRACE_OPS_FL_RECURSION_SAFE | FTRACE_OPS_FL_INITIALIZED,
 	INIT_REGEX_LOCK(global_ops)
 };
 
@@ -4190,8 +4208,8 @@ ftrace_ops_control_func(unsigned long ip, unsigned long parent_ip,
 }
 
 static struct ftrace_ops control_ops = {
-	.func = ftrace_ops_control_func,
-	.flags = FTRACE_OPS_FL_RECURSION_SAFE,
+	.func	= ftrace_ops_control_func,
+	.flags	= FTRACE_OPS_FL_RECURSION_SAFE | FTRACE_OPS_FL_INITIALIZED,
 	INIT_REGEX_LOCK(control_ops)
 };
 
@@ -4550,6 +4568,8 @@ int register_ftrace_function(struct ftrace_ops *ops)
 {
 	int ret = -1;
 
+	ftrace_ops_init(ops);
+
 	mutex_lock(&ftrace_lock);
 
 	ret = __register_ftrace_function(ops);


