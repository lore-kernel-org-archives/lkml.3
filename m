Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbaA3XI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 18:08:28 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:60512 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbaA3XI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 18:08:27 -0500
Date: Thu, 30 Jan 2014 15:08:12 -0800
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Christoph Lameter <cl@linux.com>,
        Eric Dumazet <edumazet@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Anton Blanchard <anton@samba.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Jan Kara <jack@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, linux-mm@kvack.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Ben Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH] kthread: ensure locality of task_struct allocations
Message-ID: <20140130230812.GA874@linux.vnet.ibm.com>
References: <20140128183808.GB9315@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1401290012460.10268@chino.kir.corp.google.com>
 <alpine.DEB.2.10.1401290957350.23856@nuc>
 <alpine.DEB.2.02.1401291622550.22974@chino.kir.corp.google.com>
 <1391062491.28432.68.camel@edumazet-glaptop2.roam.corp.google.com>
 <alpine.DEB.2.02.1401301446320.12223@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401301446320.12223@chino.kir.corp.google.com>
X-Operating-System: Linux 3.11.0-15-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14013023-9332-0000-0000-000002F1DB8D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.01.2014 [14:47:05 -0800], David Rientjes wrote:
> On Wed, 29 Jan 2014, Eric Dumazet wrote:
> 
> > > Eric, did you try this when writing 207205a2ba26 ("kthread: NUMA aware 
> > > kthread_create_on_node()") or was it always numa_node_id() from the 
> > > beginning?
> > 
> > Hmm, I think I did not try this, its absolutely possible NUMA_NO_NODE
> > was better here.
> > 
> 
> Nishanth, could you change your patch to just return NUMA_NO_NODE for the 
> non-kthreadd case?

Something like the following?


In the presence of memoryless nodes, numa_node_id() will return the
current CPU's NUMA node, but that may not be where we expect to allocate
from memory from. Instead, we should rely on the fallback code in the
memory allocator itself, by using NUMA_NO_NODE. Also, when calling
kthread_create_on_node(), use the nearest node with memory to the cpu in
question, rather than the node it is running on.

Signed-off-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Cc: Anton Blanchard <anton@samba.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ben Herrenschmidt <benh@kernel.crashing.org>

---
Note that I haven't yet tested this change on the system that reproduce
the original problem yet.

diff --git a/kernel/kthread.c b/kernel/kthread.c
index b5ae3ee..9a130ec 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -217,7 +217,7 @@ int tsk_fork_get_node(struct task_struct *tsk)
 	if (tsk == kthreadd_task)
 		return tsk->pref_node_fork;
 #endif
-	return numa_node_id();
+	return NUMA_NO_NODE;
 }
 
 static void create_kthread(struct kthread_create_info *create)
@@ -369,7 +369,7 @@ struct task_struct *kthread_create_on_cpu(int (*threadfn)(void *data),
 {
 	struct task_struct *p;
 
-	p = kthread_create_on_node(threadfn, data, cpu_to_node(cpu), namefmt,
+	p = kthread_create_on_node(threadfn, data, cpu_to_mem(cpu), namefmt,
 				   cpu);
 	if (IS_ERR(p))
 		return p;

