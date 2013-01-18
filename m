Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab3ARPJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 10:09:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10940 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab3ARPJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 10:09:53 -0500
X-Authority-Analysis: v=2.0 cv=C91rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=ELXGAcv7mCcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=nf3OURjn1SIA:10 a=vtFsbD2Is7vtDg1gE9sA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358521791.7383.11.camel@gandalf.local.home>
Subject: [RFC][PATCH v3] slub: Keep page and object in sync in
 slab_alloc_node()
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@linux.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        RT <linux-rt-users@vger.kernel.org>, Clark Williams <clark@redhat.com>,
        John Kacur <jkacur@gmail.com>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Date: Fri, 18 Jan 2013 10:09:51 -0500
In-Reply-To: <1358468924.23211.69.camel@gandalf.local.home>
References: <1358446258.23211.32.camel@gandalf.local.home>
	 <1358447864.23211.34.camel@gandalf.local.home>
	 <0000013c4a69a2cf-1a19a6f6-e6a3-4f06-99a4-10fdd4b9aca2-000000@email.amazonses.com>
	 <1358458996.23211.46.camel@gandalf.local.home>
	 <0000013c4a7e7fbf-c51fd42a-2455-4fec-bb37-915035956f05-000000@email.amazonses.com>
	 <1358462763.23211.57.camel@gandalf.local.home>
	 <1358464245.23211.62.camel@gandalf.local.home>
	 <1358464837.23211.66.camel@gandalf.local.home>
	 <1358468598.23211.67.camel@gandalf.local.home>
	 <1358468924.23211.69.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In slab_alloc_node(), after the cpu_slab is assigned, if the task is
preempted and moves to another CPU, there's nothing keeping the page and
object in sync. The -rt kernel crashed because page was NULL and object
was not, and the node_match() dereferences page. Even though the crash
happened on -rt, there's nothing that's keeping this from happening on
mainline.

The easiest fix is to disable preemption for the entire time from
acquiring the current CPU cpu_slab and assigning the object and page.
After that, it's fine to allow preemption.

Also add a check if page is NULL in node_match().

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/mm/slub.c b/mm/slub.c
index ba2ca53..10714ee 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2041,7 +2041,7 @@ static void flush_all(struct kmem_cache *s)
 static inline int node_match(struct page *page, int node)
 {
 #ifdef CONFIG_NUMA
-	if (node != NUMA_NO_NODE && page_to_nid(page) != node)
+	if (!page || (node != NUMA_NO_NODE && page_to_nid(page) != node))
 		return 0;
 #endif
 	return 1;
@@ -2337,7 +2337,10 @@ redo:
 	 * enabled. We may switch back and forth between cpus while
 	 * reading from one cpu area. That does not matter as long
 	 * as we end up on the original cpu again when doing the cmpxchg.
+	 *
+	 * But we need to sync the setting of page and object.
 	 */
+	preempt_disable();
 	c = __this_cpu_ptr(s->cpu_slab);
 
 	/*
@@ -2347,10 +2350,14 @@ redo:
 	 * linked list in between.
 	 */
 	tid = c->tid;
+
+	/* Must have tid first in case an interrupt comes in */
 	barrier();
 
 	object = c->freelist;
 	page = c->page;
+	preempt_enable();
+
 	if (unlikely(!object || !node_match(page, node)))
 		object = __slab_alloc(s, gfpflags, node, addr, c);
 


