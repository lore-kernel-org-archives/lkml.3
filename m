Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbaJ0S6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:58:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbaJ0S6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:58:06 -0400
Date: Mon, 27 Oct 2014 20:54:25 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Kirill Tkhai <ktkhai@parallels.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>, Christoph Lameter <cl@linux.com>
Subject: [PATCH 2/3] introduce probe_slab_address()
Message-ID: <20141027195425.GC11736@redhat.com>
References: <1413962231.19914.130.camel@tkhai> <20141027195339.GA11736@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141027195339.GA11736@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extract the ifdef(CONFIG_DEBUG_PAGEALLOC) code from get_freepointer_safe()
into the new generic helper, probe_slab_address(). The next patch will add
another user.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/uaccess.h |   15 +++++++++++++++
 mm/slub.c               |    6 +-----
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index effb637..3367396 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -71,6 +71,21 @@ static inline unsigned long __copy_from_user_nocache(void *to,
 	__probe_kernel_read(&(retval), (__force void *)(addr), sizeof(retval))
 
 /*
+ * Same as probe_kernel_address(), but @addr must be the valid pointer
+ * to a slab object, potentially freed/reused/unmapped.
+ */
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
 
-- 
1.5.5.1


