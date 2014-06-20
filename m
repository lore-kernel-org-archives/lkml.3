Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934460AbaFTAL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 20:11:27 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:52843 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125AbaFTALZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 20:11:25 -0400
Message-ID: <53A37C2A.70204@gmail.com>
Date: Thu, 19 Jun 2014 20:11:22 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: paulmck@linux.vnet.ibm.com, LKML <linux-kernel@vger.kernel.org>,
        romanov.arya@gmail.com, Josh Triplett <josh@joshtriplett.org>
Subject: Re: [RFC PATCH] use snprintf instead of sprintf in rcu_torture_printk
References: <1402419340.30479.18.camel@joe-AO725>	 <20140611074704.GS5015@mwanda> <1402502500.6169.5.camel@joe-AO725>	 <alpine.DEB.2.02.1406140937370.2003@localhost6.localdomain6>	 <alpine.DEB.2.02.1406141151170.2045@localhost6.localdomain6>	 <20140618193345.GR4669@linux.vnet.ibm.com>	 <1403120982.3839.25.camel@joe-AO725>	 <20140619210031.GN4904@linux.vnet.ibm.com> <53A37140.3020003@gmail.com> <1403220789.2753.32.camel@joe-AO725>
In-Reply-To: <1403220789.2753.32.camel@joe-AO725>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2014 07:33 PM, Joe Perches wrote:

>>
>> Here is a first run of the change. Please let me know if I am totally off. RFC. :)
>>
>> Three things on Todo list:
>>
>> * We need to check that we are using less than the allocated size of the buffer (used > size). (we are allocating a big buffer, so not sure if necessary)
>> * Need to check with the scripts if they are working.
>> * I used a loop for pr_alert(). I am not sure this is right, there should be a better way for printing large buffers
>>
>> If the overall structure is ok I will go ahead and check how the scripts are handling these changes. 
> []
>> diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
> []
>> @@ -1130,17 +1134,23 @@ rcu_torture_printk(char *page)
>>  static void
>>  rcu_torture_stats_print(void)
>>  {
> []
>> +	/* printk can print only print LOG_LINE_MAX chars at a time */
>> +	while (used > 0) {
>> +		size_pr = pr_alert("%s", buf);
>> +		used -= size_pr;
>> +		buf  += size_pr;
>> +	}
>> +	vfree(buf);
>>  }
> 
> You can't increment buf then vfree it.
> 
> Try a char *tmpbuf = buf, and increment it.
> 
> I suggest you check by strcspn(tmpbuf, "\n")
> save the byte after, replace it with 0,
> print, replace the 0 with saved byte, and
> loop until end of buffer.
> 

Please find v2 which I changed according to your comments:

v2:

* use tmpbuf to increment
* print each line (search for "\n" as suggested and mark with '\0')
* minor fix while calling cur_ops->stats

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 include/linux/torture.h |  2 +-
 kernel/rcu/rcutorture.c | 86 ++++++++++++++++++++++++++++++-------------------
 kernel/torture.c        |  7 ++--
 3 files changed, 57 insertions(+), 38 deletions(-)

diff --git a/include/linux/torture.h b/include/linux/torture.h
index 5ca58fc..1e47ec7 100644
--- a/include/linux/torture.h
+++ b/include/linux/torture.h
@@ -51,7 +51,7 @@
 
 /* Definitions for online/offline exerciser. */
 int torture_onoff_init(long ooholdoff, long oointerval);
-char *torture_onoff_stats(char *page);
+int torture_onoff_stats(char *page, int size);
 bool torture_onoff_failures(void);
 
 /* Low-rider random number generator. */
diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 7fa34f8..b149c5f 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -242,7 +242,7 @@ struct rcu_torture_ops {
 	void (*call)(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
 	void (*cb_barrier)(void);
 	void (*fqs)(void);
-	void (*stats)(char *page);
+	int (*stats)(char *page, int size);
 	int irq_capable;
 	int can_boost;
 	const char *name;
@@ -525,21 +525,22 @@ static void srcu_torture_barrier(void)
 	srcu_barrier(&srcu_ctl);
 }
 
-static void srcu_torture_stats(char *page)
+static int srcu_torture_stats(char *page, int size)
 {
-	int cpu;
+	int cpu, used = 0;
 	int idx = srcu_ctl.completed & 0x1;
 
-	page += sprintf(page, "%s%s per-CPU(idx=%d):",
+	used = snprintf(page, size, "%s%s per-CPU(idx=%d):",
 		       torture_type, TORTURE_FLAG, idx);
 	for_each_possible_cpu(cpu) {
 		long c0, c1;
 
 		c0 = (long)per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[!idx];
 		c1 = (long)per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[idx];
-		page += sprintf(page, " %d(%ld,%ld)", cpu, c0, c1);
+		used += snprintf(page + used, size - used, " %d(%ld,%ld)", cpu, c0, c1);
 	}
-	sprintf(page, "\n");
+	used += snprintf(page + used, size - used, "\n");
+	return used;
 }
 
 static void srcu_torture_synchronize_expedited(void)
@@ -1033,10 +1034,10 @@ rcu_torture_reader(void *arg)
 /*
  * Create an RCU-torture statistics message in the specified buffer.
  */
-static void
-rcu_torture_printk(char *page)
+static int
+rcu_torture_printk(char *page, int size)
 {
-	int cpu;
+	int cpu, used = 0;
 	int i;
 	long pipesummary[RCU_TORTURE_PIPE_LEN + 1] = { 0 };
 	long batchsummary[RCU_TORTURE_PIPE_LEN + 1] = { 0 };
@@ -1052,8 +1053,8 @@ rcu_torture_printk(char *page)
 		if (pipesummary[i] != 0)
 			break;
 	}
-	page += sprintf(page, "%s%s ", torture_type, TORTURE_FLAG);
-	page += sprintf(page,
+	used += snprintf(page + used, size - used, "%s%s ", torture_type, TORTURE_FLAG);
+	used += snprintf(page + used, size - used,
 		       "rtc: %p ver: %lu tfle: %d rta: %d rtaf: %d rtf: %d ",
 		       rcu_torture_current,
 		       rcu_torture_current_version,
@@ -1061,46 +1062,47 @@ rcu_torture_printk(char *page)
 		       atomic_read(&n_rcu_torture_alloc),
 		       atomic_read(&n_rcu_torture_alloc_fail),
 		       atomic_read(&n_rcu_torture_free));
-	page += sprintf(page, "rtmbe: %d rtbke: %ld rtbre: %ld ",
+	used += snprintf(page + used, size - used, "rtmbe: %d rtbke: %ld rtbre: %ld ",
 		       atomic_read(&n_rcu_torture_mberror),
 		       n_rcu_torture_boost_ktrerror,
 		       n_rcu_torture_boost_rterror);
-	page += sprintf(page, "rtbf: %ld rtb: %ld nt: %ld ",
+	used += snprintf(page + used, size - used, "rtbf: %ld rtb: %ld nt: %ld ",
 		       n_rcu_torture_boost_failure,
 		       n_rcu_torture_boosts,
 		       n_rcu_torture_timers);
-	page = torture_onoff_stats(page);
-	page += sprintf(page, "barrier: %ld/%ld:%ld",
+	used += torture_onoff_stats(page + used, size - used);
+	used += snprintf(page + used, size - used, 
+			   "barrier: %ld/%ld:%ld",
 		       n_barrier_successes,
 		       n_barrier_attempts,
 		       n_rcu_torture_barrier_error);
-	page += sprintf(page, "\n%s%s ", torture_type, TORTURE_FLAG);
+	used += snprintf(page + used, size - used, "\n%s%s ", torture_type, TORTURE_FLAG);
 	if (atomic_read(&n_rcu_torture_mberror) != 0 ||
 	    n_rcu_torture_barrier_error != 0 ||
 	    n_rcu_torture_boost_ktrerror != 0 ||
 	    n_rcu_torture_boost_rterror != 0 ||
 	    n_rcu_torture_boost_failure != 0 ||
 	    i > 1) {
-		page += sprintf(page, "!!! ");
+		used += snprintf(page + used, size - used, "!!! ");
 		atomic_inc(&n_rcu_torture_error);
 		WARN_ON_ONCE(1);
 	}
-	page += sprintf(page, "Reader Pipe: ");
+	used += snprintf(page + used, size - used, "Reader Pipe: ");
 	for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++)
-		page += sprintf(page, " %ld", pipesummary[i]);
-	page += sprintf(page, "\n%s%s ", torture_type, TORTURE_FLAG);
-	page += sprintf(page, "Reader Batch: ");
+		used += snprintf(page + used, size - used, " %ld", pipesummary[i]);
+	used += snprintf(page + used, size - used, "\n%s%s ", torture_type, TORTURE_FLAG);
+	used += snprintf(page + used, size - used, "Reader Batch: ");
 	for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++)
-		page += sprintf(page, " %ld", batchsummary[i]);
-	page += sprintf(page, "\n%s%s ", torture_type, TORTURE_FLAG);
-	page += sprintf(page, "Free-Block Circulation: ");
+		used += snprintf(page + used, size - used, " %ld", batchsummary[i]);
+	used += snprintf(page + used, size - used, "\n%s%s ", torture_type, TORTURE_FLAG);
+	used += snprintf(page + used, size - used, "Free-Block Circulation: ");
 	for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++) {
-		page += sprintf(page, " %d",
+		used += snprintf(page + used, size - used, " %d",
 			       atomic_read(&rcu_torture_wcount[i]));
 	}
-	page += sprintf(page, "\n");
+	used += snprintf(page + used, size - used, "\n");
 	if (cur_ops->stats)
-		cur_ops->stats(page);
+		used += cur_ops->stats(page + used, size - used);
 	if (rtcv_snap == rcu_torture_current_version &&
 	    rcu_torture_current != NULL) {
 		int __maybe_unused flags;
@@ -1109,7 +1111,7 @@ rcu_torture_printk(char *page)
 
 		rcutorture_get_gp_data(cur_ops->ttype,
 				       &flags, &gpnum, &completed);
-		page += sprintf(page,
+		used += snprintf(page + used, size - used,
 				"??? Writer stall state %d g%lu c%lu f%#x\n",
 				rcu_torture_writer_state,
 				gpnum, completed, flags);
@@ -1117,6 +1119,8 @@ rcu_torture_printk(char *page)
 		rcutorture_trace_dump();
 	}
 	rtcv_snap = rcu_torture_current_version;
+
+	return used;
 }
 
 /*
@@ -1130,17 +1134,31 @@ rcu_torture_printk(char *page)
 static void
 rcu_torture_stats_print(void)
 {
-	int size = nr_cpu_ids * 200 + 8192;
-	char *buf;
+	int size = nr_cpu_ids * 200 + 8192, used = 0, size_pr;
+	char *buf, *tmpbuf, c;
 
-	buf = kmalloc(size, GFP_KERNEL);
+	buf = vmalloc(size);
 	if (!buf) {
 		pr_err("rcu-torture: Out of memory, need: %d", size);
 		return;
 	}
-	rcu_torture_printk(buf);
-	pr_alert("%s", buf);
-	kfree(buf);
+	used = rcu_torture_printk(buf, size);
+
+	tmpbuf = buf;
+
+	/* printk can print only LOG_LINE_MAX chars at a time
+	 * so print the buffer in a loop, one line at a time
+	 */
+	while (used > 0) {
+		size_pr = strcspn(tmpbuf, "\n");
+		c = tmpbuf[size_pr + 1];
+		tmpbuf[size_pr + 1] = '\0';
+		size_pr = pr_alert("%s", tmpbuf);
+		tmpbuf[size_pr] = c;
+		used -= size_pr;
+		tmpbuf  += size_pr;
+	}
+	vfree(buf);
 }
 
 /*
diff --git a/kernel/torture.c b/kernel/torture.c
index 40bb511..da95335 100644
--- a/kernel/torture.c
+++ b/kernel/torture.c
@@ -211,10 +211,11 @@ EXPORT_SYMBOL_GPL(torture_onoff_cleanup);
 /*
  * Print online/offline testing statistics.
  */
-char *torture_onoff_stats(char *page)
+int torture_onoff_stats(char *page, int size)
 {
+	int used = 0;
 #ifdef CONFIG_HOTPLUG_CPU
-	page += sprintf(page,
+	used = snprintf(page, size,
 		       "onoff: %ld/%ld:%ld/%ld %d,%d:%d,%d %lu:%lu (HZ=%d) ",
 		       n_online_successes, n_online_attempts,
 		       n_offline_successes, n_offline_attempts,
@@ -222,7 +223,7 @@ char *torture_onoff_stats(char *page)
 		       min_offline, max_offline,
 		       sum_online, sum_offline, HZ);
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
-	return page;
+	return used;
 }
 EXPORT_SYMBOL_GPL(torture_onoff_stats);
 
-- 
1.9.1


 

