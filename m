Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054Ab3ETOuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:50:24 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:35483 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122Ab3ETOuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:50:22 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/1] kthread: Add kworker kthreads to OS-jitter documentation
Date: Mon, 20 May 2013 07:50:02 -0700
Message-Id: <1369061402-31334-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1369061402-31334-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130520144934.GA29947@linux.vnet.ibm.com>
 <1369061402-31334-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052014-5518-0000-0000-00000ED06EA7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The kworker workqueue kthreads can also contribute to OS jitter.
The amount of jitter depends on their use, so this commit adds
documentation on avoiding OS jitter due to workqueue use.

Reported-by: Jonathan Clairembault <jonathan.clairembault@novasparks.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/kernel-per-CPU-kthreads.txt | 47 +++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/Documentation/kernel-per-CPU-kthreads.txt b/Documentation/kernel-per-CPU-kthreads.txt
index cbf7ae4..5f39ef5 100644
--- a/Documentation/kernel-per-CPU-kthreads.txt
+++ b/Documentation/kernel-per-CPU-kthreads.txt
@@ -157,6 +157,53 @@ RCU_SOFTIRQ:  Do at least one of the following:
 		calls and by forcing both kernel threads and interrupts
 		to execute elsewhere.
 
+Name: kworker/%u:%d%s (cpu, id, priority)
+Purpose: Execute workqueue requests
+To reduce its OS jitter, do any of the following:
+1.	Run your workload at a real-time priority, which will allow
+	preempting the kworker daemons.
+2.	Do any of the following needed to avoid jitter that your
+	application cannot tolerate:
+	a.	Build your kernel with CONFIG_SLUB=y rather than
+		CONFIG_SLAB=y, thus avoiding the slab allocator's periodic
+		use of each CPU's workqueues to run its cache_reap()
+		function.
+	b.	Avoid using oprofile, thus avoiding OS jitter from
+		wq_sync_buffer().
+	c.	Limit your CPU frequency so that a CPU-frequency
+		governor is not required, possibly enlisting the aid of
+		special heatsinks or other cooling technologies.  If done
+		correctly, and if you CPU architecture permits, you should
+		be able to build your kernel with CONFIG_CPU_FREQ=n to
+		avoid the CPU-frequency governor periodically running
+		on each CPU, including cs_dbs_timer() and od_dbs_timer().
+		WARNING:  Please check your CPU specifications to
+		make sure that this is safe on your particular system.
+	d.	It is not possible to entirely get rid of OS jitter
+		from vmstat_update() on CONFIG_SMP=y systems, but you
+		can decrease its frequency by writing a large value to
+		/proc/sys/vm/stat_interval.  The default value is HZ,
+		for an interval of one second.  Of course, larger values
+		will make your virtual-memory statistics update more
+		slowly.  Of course, you can also run your workload at
+		a real-time priority, thus preempting vmstat_update().
+	e.	If running on high-end powerpc servers, build with
+		CONFIG_PPC_RTAS_DAEMON=n.  This prevents the RTAS
+		daemon from running on each CPU every second or so.
+		(This will require editing Kconfig files and will defeat
+		this platform's RAS functionality.)  This avoids jitter
+		due to the rtas_event_scan() function.
+		WARNING:  Please check your CPU specifications to
+		make sure that this is safe on your particular system.
+	f.	If running on Cell Processor, build your kernel with
+		CBE_CPUFREQ_SPU_GOVERNOR=n to avoid OS jitter from
+		spu_gov_work().
+		WARNING:  Please check your CPU specifications to
+		make sure that this is safe on your particular system.
+	g.	If running on PowerMAC, build your kernel with
+		CONFIG_PMAC_RACKMETER=n to disable the CPU-meter,
+		avoiding OS jitter from rackmeter_do_timer().
+
 Name: rcuc/%u
 Purpose: Execute RCU callbacks in CONFIG_RCU_BOOST=y kernels.
 To reduce its OS jitter, do at least one of the following:
-- 
1.8.1.5

