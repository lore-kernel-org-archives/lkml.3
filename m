Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbaJ0S7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:59:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40373 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428AbaJ0S5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:57:45 -0400
Date: Mon, 27 Oct 2014 20:54:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Kirill Tkhai <ktkhai@parallels.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>, Christoph Lameter <cl@linux.com>
Subject: [PATCH 1/3] probe_kernel_address() can use __probe_kernel_read()
Message-ID: <20141027195405.GB11736@redhat.com>
References: <1413962231.19914.130.camel@tkhai> <20141027195339.GA11736@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141027195339.GA11736@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

probe_kernel_address() can just do __probe_kernel_read(sizeof(retval)),
no need to open-code its implementation.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/uaccess.h |   17 ++---------------
 1 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index ecd3319..effb637 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -66,22 +66,9 @@ static inline unsigned long __copy_from_user_nocache(void *to,
  * already holds mmap_sem, or other locks which nest inside mmap_sem.
  * This must be a macro because __get_user() needs to know the types of the
  * args.
- *
- * We don't include enough header files to be able to do the set_fs().  We
- * require that the probe_kernel_address() caller will do that.
  */
-#define probe_kernel_address(addr, retval)		\
-	({						\
-		long ret;				\
-		mm_segment_t old_fs = get_fs();		\
-							\
-		set_fs(KERNEL_DS);			\
-		pagefault_disable();			\
-		ret = __copy_from_user_inatomic(&(retval), (__force typeof(retval) __user *)(addr), sizeof(retval));		\
-		pagefault_enable();			\
-		set_fs(old_fs);				\
-		ret;					\
-	})
+#define probe_kernel_address(addr, retval)	\
+	__probe_kernel_read(&(retval), (__force void *)(addr), sizeof(retval))
 
 /*
  * probe_kernel_read(): safely attempt to read from a location
-- 
1.5.5.1


