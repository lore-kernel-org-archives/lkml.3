Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933568Ab3CLVHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 17:07:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10495 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933487Ab3CLVHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 17:07:00 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=MN81rhAlocoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=Ba2CAyJkW-kA:10 a=VwQbUJbxAAAA:8 a=bxycdseGc05W_AZHOSYA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363122418.25967.8.camel@gandalf.local.home>
Subject: [PATCH][GIT PULL][3.9] tracing: Fix race in snapshot swapping
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Tue, 12 Mar 2013 17:06:58 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Some of the new work I've been doing has uncovered a long standing bug.
Luckily, it just happens that policy and other locks have prevented this
bug from happening.

The bug is that the swap of buffers has a race condition. It does the
standard CS101 swap:

	tmp = a;
	a = b;
	b = tmp;

The problem is that tmp = a is done outside the lock. If another swap
happened on another CPU we could get this:

	CPU0			 CPU1
	----			 ----
	tmp = a;
				tmp = a;
				a = b;
				b = tmp;

	a = b;
	b = tmp;

Now b and a are the same!

The reason this hasn't bitten us earlier is that all callers of this
code happen to take their own locks before calling it, preventing the
race to occur. It also happens that each caller has "policy" set that
they can't be called at the same time with another caller.

By shear luck this bug was kept from being triggered.

But now there's new code coming for 3.10 that changes the above "policy"
and opens up this race. This is a small and obvious fix, and I would
like it in 3.9 so that any backports done later wont trigger this bug.

I also marked it for stable for the same reasons (backports done by
distros might trigger it).

Thanks,

-- Steve


Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent

Head SHA1: 2721e72dd10f71a3ba90f59781becf02638aa0d9


Steven Rostedt (Red Hat) (1):
      tracing: Fix race in snapshot swapping

----
 kernel/trace/trace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)
---------------------------
commit 2721e72dd10f71a3ba90f59781becf02638aa0d9
Author: Steven Rostedt (Red Hat) <rostedt@goodmis.org>
Date:   Tue Mar 12 11:32:32 2013 -0400

    tracing: Fix race in snapshot swapping
    
    Although the swap is wrapped with a spin_lock, the assignment
    of the temp buffer used to swap is not within that lock.
    It needs to be moved into that lock, otherwise two swaps
    happening on two different CPUs, can end up using the wrong
    temp buffer to assign in the swap.
    
    Luckily, all current callers of the swap function appear to have
    their own locks. But in case something is added that allows two
    different callers to call the swap, then there's a chance that
    this race can trigger and corrupt the buffers.
    
    New code is coming soon that will allow for this race to trigger.
    
    I've Cc'd stable, so this bug will not show up if someone backports
    one of the changes that can trigger this bug.
    
    Cc: stable@vger.kernel.org
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 1f835a8..53df283 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -704,7 +704,7 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 void
 update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 {
-	struct ring_buffer *buf = tr->buffer;
+	struct ring_buffer *buf;
 
 	if (trace_stop_count)
 		return;
@@ -719,6 +719,7 @@ update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 
 	arch_spin_lock(&ftrace_max_lock);
 
+	buf = tr->buffer;
 	tr->buffer = max_tr.buffer;
 	max_tr.buffer = buf;
 


