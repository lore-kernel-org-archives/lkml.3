Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933497AbaD2Aav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:30:51 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:48578 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933077AbaD2AZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:25:50 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu, Iulia Manda <iulia.manda21@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 31/45] torture: Notice if an all-zero cpumask is passed inside a critical section
Date: Mon, 28 Apr 2014 17:25:19 -0700
Message-Id: <1398731133-18925-31-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-1542-0000-0000-00000169D319
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Iulia Manda <iulia.manda21@gmail.com>

In torture_shuffle_tasks function, the check if an all-zero mask can
be passed to set_cpus_allowed_ptr() is redundant after clearing the
shuffle_idle_cpu bit. If the mask had more than one bit set, after
clearing a bit it has at least one bit set. If the mask had only
one bit set, a check is made at the beginning, where the function
returns, as there is no need to shuffle only one cpu.

Also, this code is executed inside a critical section, delimited by
get_online_cpus(), and put_online_cpus(), preventing CPUs from leaving between
the check of num_online_cpus and the calls to set_cpus_allowed_ptr() function.

Signed-off-by: Iulia Manda <iulia.manda21@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/torture.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/kernel/torture.c b/kernel/torture.c
index bd768effba9a..c1d57e83e8fe 100644
--- a/kernel/torture.c
+++ b/kernel/torture.c
@@ -335,13 +335,8 @@ static void torture_shuffle_tasks(void)
 	shuffle_idle_cpu = cpumask_next(shuffle_idle_cpu, shuffle_tmp_mask);
 	if (shuffle_idle_cpu >= nr_cpu_ids)
 		shuffle_idle_cpu = -1;
-	if (shuffle_idle_cpu != -1) {
+	else
 		cpumask_clear_cpu(shuffle_idle_cpu, shuffle_tmp_mask);
-		if (cpumask_empty(shuffle_tmp_mask)) {
-			put_online_cpus();
-			return;
-		}
-	}
 
 	mutex_lock(&shuffle_task_mutex);
 	list_for_each_entry(stp, &shuffle_task_list, st_l)
-- 
1.8.1.5

