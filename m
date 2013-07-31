Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648Ab3GaAv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 20:51:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6935 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab3GaAv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 20:51:27 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=_6S4gJz81GoA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=UirpL7NoV14A:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=4K-K1uyHAAAA:8 a=20KFwNOVAAAA:8 a=WTJdmG3rAAAA:8 a=3qBUXO16q3ar-7tKHNgA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=wATGTE7Z8MQA:10 a=jEp0ucaQiEUA:10 a=nsF78Xlgl7EA:10 a=1Cao2RoLVkUd0ckq:21 a=dgra2IiH0YCM9Doo:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375231885.25784.2.camel@gandalf.local.home>
Subject: Re: __ftrace_hash_rec_update FTRACE_WARN_ON.
From: Steven Rostedt <rostedt@goodmis.org>
To: Steve Hodgson <steve@purestorage.com>
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
        Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
Date: Tue, 30 Jul 2013 20:51:25 -0400
In-Reply-To: <CADHUQJ5=cgWsAvUb29EVnnP2gKeeoNnp=4gLuJqq+wQh+iBYzw@mail.gmail.com>
References: <20130705142629.GA325@redhat.com>
	 <1373036034.22688.155.camel@gandalf.local.home>
	 <20130724160422.GA3641@logfs.org>
	 <1374715444.3356.163.camel@gandalf.local.home>
	 <CADHUQJ4yweA4zNKqtsq=iQkX+o6UmA-dwWV1d-0SdJbpGtZR5A@mail.gmail.com>
	 <1374778741.3356.181.camel@gandalf.local.home>
	 <1374808998.6580.12.camel@gandalf.local.home>
	 <CADHUQJ5=cgWsAvUb29EVnnP2gKeeoNnp=4gLuJqq+wQh+iBYzw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-07-27 at 12:16 -0700, Steve Hodgson wrote:

> This patch fixes ftrace across module removal/reinsertion on our 3.6.11 kernel.

I found a few corner cases that this patch doesn't work with, and the
solution is just getting uglier and uglier.

I found a new solution that seems to handle all the corner cases
(including this one). Can you test this as well. I want to add your
tested-by tag for this too.

Thanks!

-- Steve

>From 4c647dde26cf8c47ccaaed6f2e2fffee5dab5871 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Date: Tue, 30 Jul 2013 00:04:32 -0400
Subject: [PATCH] ftrace: Check module functions being traced on reload
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

There's been a nasty bug that would show up and not give much info.
The bug displayed the following warning:

 WARNING: at kernel/trace/ftrace.c:1529 __ftrace_hash_rec_update+0x1e3/0x230()
 Pid: 20903, comm: bash Tainted: G           O 3.6.11+ #38405.trunk
 Call Trace:
  [<ffffffff8103e5ff>] warn_slowpath_common+0x7f/0xc0
  [<ffffffff8103e65a>] warn_slowpath_null+0x1a/0x20
  [<ffffffff810c2ee3>] __ftrace_hash_rec_update+0x1e3/0x230
  [<ffffffff810c4f28>] ftrace_hash_move+0x28/0x1d0
  [<ffffffff811401cc>] ? kfree+0x2c/0x110
  [<ffffffff810c68ee>] ftrace_regex_release+0x8e/0x150
  [<ffffffff81149f1e>] __fput+0xae/0x220
  [<ffffffff8114a09e>] ____fput+0xe/0x10
  [<ffffffff8105fa22>] task_work_run+0x72/0x90
  [<ffffffff810028ec>] do_notify_resume+0x6c/0xc0
  [<ffffffff8126596e>] ? trace_hardirqs_on_thunk+0x3a/0x3c
  [<ffffffff815c0f88>] int_signal+0x12/0x17
 ---[ end trace 793179526ee09b2c ]---

It was finally narrowed down to unloading a module that was being traced.

It was actually more than that. When functions are being traced, there's
a table of all functions that have a ref count of the number of active
tracers attached to that function. When a function trace callback is
registered to a function, the function's record ref count is incremented.
When it is unregistered, the function's record ref count is decremented.
If an inconsistency is detected (ref count goes below zero) the above
warning is shown and the function tracing is permanently disabled until
reboot.

The ftrace callback ops holds a hash of functions that it filters on
(and/or filters off). If the hash is empty, the default means to filter
all functions (for the filter_hash) or to disable no functions (for the
notrace_hash).

When a module is unloaded, it frees the function records that represent
the module functions. These records exist on their own pages, that is
function records for one module will not exist on the same page as
function records for other modules or even the core kernel.

Now when a module unloads, the records that represents its functions are
freed. When the module is loaded again, the records are recreated with
a default ref count of zero (unless there's a callback that traces all
functions, then they will also be traced, and the ref count will be
incremented).

The problem is that if an ftrace callback hash includes functions of the
module being unloaded, those hash entries will not be removed. If the
module is reloaded in the same location, the hash entries still point
to the functions of the module but the module's ref counts do not reflect
that.

With the help of Steve and Joern, we found a reproducer:

 Using uinput module and uinput_release function.

 cd /sys/kernel/debug/tracing
 modprobe uinput
 echo uinput_release > set_ftrace_filter
 echo function > current_tracer
 rmmod uinput
 modprobe uinput
 # check /proc/modules to see if loaded in same addr, otherwise try again
 echo nop > current_tracer

 [BOOM]

The above loads the uinput module, which creates a table of functions that
can be traced within the module.

We add uinput_release to the filter_hash to trace just that function.

Enable function tracincg, which increments the ref count of the record
associated to uinput_release.

Remove uinput, which frees the records including the one that represents
uinput_release.

Load the uinput module again (and make sure it's at the same address).
This recreates the function records all with a ref count of zero,
including uinput_release.

Disable function tracing, which will decrement the ref count for uinput_release
which is now zero because of the module removal and reload, and we have
a mismatch (below zero ref count).

The solution is to check all currently tracing ftrace callbacks to see if any
are tracing any of the module's functions when a module is loaded (it already does
that with callbacks that trace all functions). If a callback happens to have
a module function being traced, it increments that records ref count and starts
tracing that function.

There may be a strange side effect with this, where tracing module functions
on unload and then reloading a new module may have that new module's functions
being traced. This may be something that confuses the user, but it's not
a big deal. Another approach is to disable all callback hashes on module unload,
but this leaves some ftrace callbacks that may not be registered, but can
still have hashes tracing the module's function where ftrace doesn't know about
it. That situation can cause the same bug. This solution solves that case too.
Another benefit of this solution, is it is possible to trace a module's
function on unload and load.

Link: http://lkml.kernel.org/r/CADHUQJ58icP+d3QTXheiCnZwu6hrAqG2heMhhcuQvghXavHRFw@mail.gmail.com

Reported-by: Jörn Engel <joern@logfs.org>
Reported-by: Dave Jones <davej@redhat.com>
Reported-by: Steve Hodgson <steve@purestorage.com>
Soon-to-be-tested-by: Steve Hodgson <steve@purestorage.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 71 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 62 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 92d3334..a6d098c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2169,12 +2169,57 @@ static cycle_t		ftrace_update_time;
 static unsigned long	ftrace_update_cnt;
 unsigned long		ftrace_update_tot_cnt;
 
-static int ops_traces_mod(struct ftrace_ops *ops)
+static inline int ops_traces_mod(struct ftrace_ops *ops)
 {
-	struct ftrace_hash *hash;
+	/*
+	 * Filter_hash being empty will default to trace module.
+	 * But notrace hash requires a test of individual module functions.
+	 */
+	return ftrace_hash_empty(ops->filter_hash) &&
+		ftrace_hash_empty(ops->notrace_hash);
+}
+
+/*
+ * Check if the current ops references the record.
+ *
+ * If the ops traces all functions, then it was already accounted for.
+ * If the ops does not trace the current record function, skip it.
+ * If the ops ignores the function via notrace filter, skip it.
+ */
+static inline bool
+ops_references_rec(struct ftrace_ops *ops, struct dyn_ftrace *rec)
+{
+	/* If ops isn't enabled, ignore it */
+	if (!(ops->flags & FTRACE_OPS_FL_ENABLED))
+		return 0;
+
+	/* If ops traces all mods, we already accounted for it */
+	if (ops_traces_mod(ops))
+		return 0;
+
+	/* The function must be in the filter */
+	if (!ftrace_hash_empty(ops->filter_hash) &&
+	    !ftrace_lookup_ip(ops->filter_hash, rec->ip))
+		return 0;
 
-	hash = ops->filter_hash;
-	return ftrace_hash_empty(hash);
+	/* If in notrace hash, we ignore it too */
+	if (ftrace_lookup_ip(ops->notrace_hash, rec->ip))
+		return 0;
+
+	return 1;
+}
+
+static int referenced_filters(struct dyn_ftrace *rec)
+{
+	struct ftrace_ops *ops;
+	int cnt = 0;
+
+	for (ops = ftrace_ops_list; ops != &ftrace_list_end; ops = ops->next) {
+		if (ops_references_rec(ops, rec))
+		    cnt++;
+	}
+
+	return cnt;
 }
 
 static int ftrace_update_code(struct module *mod)
@@ -2183,6 +2228,7 @@ static int ftrace_update_code(struct module *mod)
 	struct dyn_ftrace *p;
 	cycle_t start, stop;
 	unsigned long ref = 0;
+	bool test = false;
 	int i;
 
 	/*
@@ -2196,9 +2242,12 @@ static int ftrace_update_code(struct module *mod)
 
 		for (ops = ftrace_ops_list;
 		     ops != &ftrace_list_end; ops = ops->next) {
-			if (ops->flags & FTRACE_OPS_FL_ENABLED &&
-			    ops_traces_mod(ops))
-				ref++;
+			if (ops->flags & FTRACE_OPS_FL_ENABLED) {
+				if (ops_traces_mod(ops))
+					ref++;
+				else
+					test = true;
+			}
 		}
 	}
 
@@ -2208,12 +2257,16 @@ static int ftrace_update_code(struct module *mod)
 	for (pg = ftrace_new_pgs; pg; pg = pg->next) {
 
 		for (i = 0; i < pg->index; i++) {
+			int cnt = ref;
+
 			/* If something went wrong, bail without enabling anything */
 			if (unlikely(ftrace_disabled))
 				return -1;
 
 			p = &pg->records[i];
-			p->flags = ref;
+			if (test)
+				cnt += referenced_filters(p);
+			p->flags = cnt;
 
 			/*
 			 * Do the initial record conversion from mcount jump
@@ -2233,7 +2286,7 @@ static int ftrace_update_code(struct module *mod)
 			 * conversion puts the module to the correct state, thus
 			 * passing the ftrace_make_call check.
 			 */
-			if (ftrace_start_up && ref) {
+			if (ftrace_start_up && cnt) {
 				int failed = __ftrace_replace_code(p, 1);
 				if (failed)
 					ftrace_bug(failed, p->ip);
-- 
1.8.1.4



