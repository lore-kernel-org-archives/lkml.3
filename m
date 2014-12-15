Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751039AbaLOKjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 05:39:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:38058 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaLOKja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 05:39:30 -0500
Date: Mon, 15 Dec 2014 11:39:15 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 10/12] sched: use {cpu|node}mask pr_cont and seq output
 functions
Message-ID: <20141215103915.GX29390@twins.programming.kicks-ass.net>
References: <1418226774-30215-1-git-send-email-tj@kernel.org>
 <1418226774-30215-11-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418226774-30215-11-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 10:52:52AM -0500, Tejun Heo wrote:
> Convert the existing user of cpu{mask|list}_scnprintf() and
> node{mask|list}_scnprintf() which use them just to printk or
> seq_printf() the resulting buffer to use the following functions
> instead respectively.
> 
> * For printk: cpu{mask|list}_pr_cont() and node{mask|list}_pr_cont().
> 
> * For seq_file: seq_cpumask[_list]() and seq_nodemask[_list]().
> 
> Because these conversions usually break up a single output function
> call into multiple, the reduction is LOC isn't too big but it removes
> unnecessary complexity and/or arbitrary limit on the length printed.
> 
> This patch is dependent on the previous patch ("bitmap, cpumask,
> nodemask: implement pr_cont variants of formatting functions") which
> is planned to go through -mm.  It'd be the easiest to route this
> together.  If this should go through the subsystem tree, please wait
> till the forementioned patch is merged to mainline.
> 

I would very much prefer something like the below instead..

I'm not a great fan of pr_cont, it makes a mess of things if there's
multiple cpus printing bits.

---
Subject: lib/vsprintf: Provide %pc to print cpumasks
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri May 11 00:35:15 CEST 2012


Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/mm/numa.c  |    6 ++----
 kernel/sched/core.c |    8 ++------
 lib/vsprintf.c      |    5 +++++
 3 files changed, 9 insertions(+), 10 deletions(-)

--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -737,7 +737,6 @@ int early_cpu_to_node(int cpu)
 void debug_cpumask_set_cpu(int cpu, int node, bool enable)
 {
 	struct cpumask *mask;
-	char buf[64];
 
 	if (node == NUMA_NO_NODE) {
 		/* early_cpu_to_node() already emits a warning and trace */
@@ -755,10 +754,9 @@ void debug_cpumask_set_cpu(int cpu, int
 	else
 		cpumask_clear_cpu(cpu, mask);
 
-	cpulist_scnprintf(buf, sizeof(buf), mask);
-	printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",
+	printk(KERN_DEBUG "%s cpu %d node %d: mask now %pc\n",
 		enable ? "numa_add_cpu" : "numa_remove_cpu",
-		cpu, node, buf);
+		cpu, node, mask);
 	return;
 }
 
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4944,9 +4944,7 @@ static int sched_domain_debug_one(struct
 				  struct cpumask *groupmask)
 {
 	struct sched_group *group = sd->groups;
-	char str[256];
 
-	cpulist_scnprintf(str, sizeof(str), sched_domain_span(sd));
 	cpumask_clear(groupmask);
 
 	printk(KERN_DEBUG "%*s domain %d: ", level, "", level);
@@ -4959,7 +4957,7 @@ static int sched_domain_debug_one(struct
 		return -1;
 	}
 
-	printk(KERN_CONT "span %s level %s\n", str, sd->name);
+	printk(KERN_CONT "span %pc level %s\n", sched_domain_span(sd), sd->name);
 
 	if (!cpumask_test_cpu(cpu, sched_domain_span(sd))) {
 		printk(KERN_ERR "ERROR: domain->span does not contain "
@@ -5005,9 +5003,7 @@ static int sched_domain_debug_one(struct
 
 		cpumask_or(groupmask, groupmask, sched_group_cpus(group));
 
-		cpulist_scnprintf(str, sizeof(str), sched_group_cpus(group));
-
-		printk(KERN_CONT " %s", str);
+		printk(KERN_CONT " %pc", sched_group_cpus(group));
 		if (group->sgp->power != SCHED_POWER_SCALE) {
 			printk(KERN_CONT " (cpu_power = %d)",
 				group->sgp->power);
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -27,6 +27,7 @@
 #include <linux/uaccess.h>
 #include <linux/ioport.h>
 #include <linux/dcache.h>
+#include <linux/cpumask.h>
 #include <net/addrconf.h>
 
 #include <asm/page.h>		/* for PAGE_SIZE */
@@ -1218,6 +1219,7 @@ int kptr_restrict __read_mostly;
  *            The maximum supported length is 64 bytes of the input. Consider
  *            to use print_hex_dump() for the larger input.
  * - 'a' For a phys_addr_t type and its derivative types (passed by reference)
+ * - 'c' For a cpumask list
  *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
@@ -1335,6 +1337,8 @@ char *pointer(const char *fmt, char *buf
 		return dentry_name(buf, end,
 				   ((const struct file *)ptr)->f_path.dentry,
 				   spec, fmt);
+	case 'c':
+		return buf + cpulist_scnprintf(buf, end - buf, ptr);
 	}
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {
@@ -1576,6 +1580,7 @@ int format_decode(const char *fmt, struc
  *   case.
  * %*ph[CDN] a variable-length hex string with a separator (supports up to 64
  *           bytes of the input)
+ * %pc print a cpumask as comma-separated list
  * %n is ignored
  *
  * ** Please update Documentation/printk-formats.txt when making changes **
