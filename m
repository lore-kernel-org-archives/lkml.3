Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbaJVSRy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 14:17:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240AbaJVSRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 14:17:52 -0400
Date: Wed, 22 Oct 2014 20:14:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>
Cc: Kirill Tkhai <tkhai@yandex.ru>, Kirill Tkhai <ktkhai@parallels.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>, cl@linux.com
Subject: introduce probe_slab_address? (Was: sched/numa: fix unsafe
	get_task_struct() in task_numa_assign())
Message-ID: <20141022181412.GA8159@redhat.com>
References: <20141020144757.GA10939@redhat.com> <20141020165614.GA16373@redhat.com> <20141020182748.GA20424@redhat.com> <54456E26.2000103@yandex.ru> <20141020205006.GA2500@redhat.com> <20141021094558.GQ23531@worktop.programming.kicks-ass.net> <20141021190335.GA12851@redhat.com> <20141022090954.GF12706@worktop.programming.kicks-ass.net> <20141022161450.GA27607@redhat.com> <20141022163743.GI21513@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022163743.GI21513@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add cc's.

On 10/22, Peter Zijlstra wrote:
>
> On Wed, Oct 22, 2014 at 06:14:50PM +0200, Oleg Nesterov wrote:
> > Hmm. so perhaps I misunderstood your concern...
> >
> > Do you mean that on !x86 a plain LOAD can "corrupt" the memory as it seen
> > from another vaddr?
>
> I'm not sure. Stores for sure, loads I'm not sure about.
>
> I suspect loads are OK, the aliasing cacheline will be !modified and
> therefore later eviction should discard (not write back). But like said,
> I'm not at all sure.
>
> I would hesitate to put such assumptions into generic code -- although
> it appears we already have.

So perhaps something like this makes sense?

If some arch has problems with D-cache aliasing (because the freed page
can be already mapped by user-space or vmalloc'ed), it can redefine this
helper.

Do you think we can use it to access rq->curr? (although let me repeat
that I won't really argue with SLAB_DESTROY_BY_RCU).

Oleg.


diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index ecd3319..eb8494c 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -84,6 +84,22 @@ static inline unsigned long __copy_from_user_nocache(void *to,
 	})
 
 /*
+ * @addr is the valid kernel pointer but this memory can be freed.
+ */
+#ifndef probe_slab_address
+#ifdef CONFIG_DEBUG_PAGEALLOC
+#define probe_slab_address(addr, retval)	\
+	probe_kernel_address(addr, retval)
+#else
+#define probe_slab_address(addr, retval)	\
+	({							\
+		(retval) = *(typeof(retval) *)(addr);		\
+		0;						\
+	})
+#endif
+#endif
+
+/*
  * probe_kernel_read(): safely attempt to read from a location
  * @dst: pointer to the buffer that shall take the data
  * @src: address to read from
diff --git a/mm/slub.c b/mm/slub.c
index 3e8afcc..0467d22 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -265,11 +265,7 @@ static inline void *get_freepointer_safe(struct kmem_cache *s, void *object)
 {
 	void *p;
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
-	probe_kernel_read(&p, (void **)(object + s->offset), sizeof(p));
-#else
-	p = get_freepointer(s, object);
-#endif
+	probe_slab_address(object + s->offset, p);
 	return p;
 }
 

