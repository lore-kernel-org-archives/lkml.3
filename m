Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525Ab3JKP7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 11:59:23 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:58665 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327Ab3JKP7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 11:59:22 -0400
Date: Fri, 11 Oct 2013 08:59:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo.kernel.org@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] sched/wait: Collapse __wait_event macros -v5
Message-ID: <20131011155917.GX5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131009032843.GA12970@linux.vnet.ibm.com>
 <20131009033502.GA14017@linux.vnet.ibm.com>
 <20131009060806.GC7664@gmail.com>
 <20131009142123.GT5790@linux.vnet.ibm.com>
 <20131010025904.GA4891@linux.vnet.ibm.com>
 <20131010080501.GA18481@gmail.com>
 <20131010171135.GL5790@linux.vnet.ibm.com>
 <20131010173937.GD26430@gmail.com>
 <20131010185819.GP5790@linux.vnet.ibm.com>
 <20131011072627.GA9514@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131011072627.GA9514@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101115-7164-0000-0000-0000025F5DE4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 09:26:27AM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > > So, I think this code lives within kernel/params.c. Might be fixable?
> > 
> > But of course!  I was just trying to be lazy. ;-)
> > 
> > I could imagine adding a filename field to struct kernel_param that was 
> > initialized with __FILE__, then making something like parameq() that did 
> > the appropriate comparison allowing any match starting after a "/" and 
> > ignoring the trailing ".h" or ".c", and then calling that from 
> > parse_one() along with current parameq().  There doesn't seem to be any 
> > point for doing the same to do_early_param().
> > 
> > There would be a few surprises with this approach, for example, 
> > rcu_idle_gp_delay and rcu_idle_lazy_gp_delay, which are defined in 
> > kernel/rcu/tree_plugin.h, would be:
> > 
> > 	tree_plugin.rcu_idle_gp_delay=4
> > 	tree_plugin.rcu_idle_lazy_gp_delay=6000
> > 
> > or:
> > 
> > 	rcu/tree_plugin.rcu_idle_gp_delay=4
> > 	rcu/tree_plugin.rcu_idle_lazy_gp_delay=6000
> > 
> > or:
> > 
> > 	kernel/rcu/tree_plugin.rcu_idle_gp_delay=4
> > 	kernel/rcu/tree_plugin.rcu_idle_lazy_gp_delay=6000
> > 
> > or I suppose even:
> > 
> > 	linux-rcu/kernel/rcu/tree_plugin.rcu_idle_gp_delay=4
> > 	linux-rcu/kernel/rcu/tree_plugin.rcu_idle_lazy_gp_delay=6000
> > 
> > instead of (say):
> > 
> > 	kernel/rcu/tree.rcu_idle_gp_delay=4
> > 	kernel/rcu/tree.rcu_idle_lazy_gp_delay=6000
> > 
> > This could of course also be fixed by comparing the filename up to the 
> > last "/" followed by the current parameter name.  Or, as Peter Zijlstra 
> > suggested, by manually expanding kernel/rcu/tree_plugin.h into 
> > kernel/rcu/tree.c.
> > 
> > Or I could use the non-standard __BASE_FILE__ instead of __FILE__, which 
> > expands to .../kernel/rcu/tree.c.  LLVM seems to define this as well, so 
> > should be OK to use.
> > 
> > So it doesn't look too horrible.  (Famous last words...)
> 
> Hm, I'm not so sure about the long names, for the following reasons: 
> strings like 'kernel/rcu/tree_plugin.' might mean a lot to us kernel 
> developers - less to sysadmins and users who would want to utilize them.

Good point!

Plus some people building kernels might not be so happy to have the
full path names to their build trees hard-coded into the kernel.  And
the people wanting tiny kernels wouldn't be happy about that much useless
text appearing in the kernel that many times.

> There's also a typo danger with overly long parameters and the parameter 
> parser is not very intelligent about seeing the intent of the user.
> 
> So I think while rcu/tree.val would be useful syntax, going above that, 
> especially with auto-generated file names (and file names can change) 
> would be overdoing it a bit :-/

Keeping rcutree.val is useful because there are systems that already use
some of those boot parameters.  I could use backslash as a wildcard that
matches "/", "_", or nothingness, thus matching rcutree.val, rcu/tree.val,
and rcu_tree.val, with something like the patch below, but I am not sure
that it is really worthwhile.

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/kernel/params.c b/kernel/params.c
index 81c4e78..2711c39 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -70,10 +70,25 @@ static char dash2underscore(char c)
 bool parameqn(const char *a, const char *b, size_t n)
 {
 	size_t i;
+	size_t j = 0;
 
 	for (i = 0; i < n; i++) {
-		if (dash2underscore(a[i]) != dash2underscore(b[i]))
-			return false;
+		if (b[j] == '\\') {
+			j++;
+			if (a[i] == '/' || a[i] == '_')
+				continue;
+			/*
+			 * A backslash is permitted to match nothingness, so
+			 * skip it and try the input character against the next
+			 * pattern character.
+			 */
+			i--;
+			continue;
+		} else if (dash2underscore(a[i]) == dash2underscore(b[j])) {
+			j++;
+			continue;
+		}
+		return false;
 	}
 	return true;
 }
diff --git a/kernel/rcu/torture.c b/kernel/rcu/torture.c
index 69a4ec8..b3ed1e0 100644
--- a/kernel/rcu/torture.c
+++ b/kernel/rcu/torture.c
@@ -56,7 +56,7 @@ MODULE_ALIAS("rcutorture");
 #ifdef MODULE_PARAM_PREFIX
 #undef MODULE_PARAM_PREFIX
 #endif
-#define MODULE_PARAM_PREFIX "rcutorture."
+#define MODULE_PARAM_PREFIX "rcu\\torture."
 
 static int fqs_duration;
 module_param(fqs_duration, int, 0444);
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 875f2a0..3dc63ee 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -66,7 +66,7 @@ MODULE_ALIAS("rcutree");
 #ifdef MODULE_PARAM_PREFIX
 #undef MODULE_PARAM_PREFIX
 #endif
-#define MODULE_PARAM_PREFIX "rcutree."
+#define MODULE_PARAM_PREFIX "rcu\\tree."
 
 /* Data structures. */
 
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index 6cb3dff..2439516 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -57,7 +57,7 @@ MODULE_ALIAS("rcupdate");
 #ifdef MODULE_PARAM_PREFIX
 #undef MODULE_PARAM_PREFIX
 #endif
-#define MODULE_PARAM_PREFIX "rcupdate."
+#define MODULE_PARAM_PREFIX "rcu\\pdate."
 
 module_param(rcu_expedited, int, 0);
 

