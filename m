Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab3IENSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 09:18:21 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:59850 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab3IENST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 09:18:19 -0400
Date: Thu, 5 Sep 2013 15:18:14 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] lockref: remove cpu_relax() again
Message-ID: <20130905131814.GA24274@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090513-1948-0000-0000-000006347784
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

d472d9d9 "lockref: Relax in cmpxchg loop" added a cpu_relax() call to the
CMPXCHG_LOOP() macro. However to me it seems to be wrong since it is very
likely that the next round will succeed (or the loop will be left).
Even worse: cpu_relax() is very expensive on s390, since it means yield
"my virtual cpu to the hypervisor". So we are talking of several 1000 cycles.

In fact some measurements show the bad impact of the cpu_relax() call on
s390 using Linus' test case that "stats()" like mad:

Without converting s390 to lockref:
Total loops: 81236173

After converting s390 to lockref:
Total loops: 31896802

After converting s390 to lockref but with removed cpu_relax() call:
Total loops: 86242190

So the cpu_relax() call completely contradicts the intention of
CONFIG_CMPXCHG_LOCKREF at least on s390.

*If* however the cpu_relax() makes sense on other platforms maybe we could
add something like we have already with "arch_mutex_cpu_relax()":

include/linux/mutex.h:
 #ifndef CONFIG_HAVE_ARCH_MUTEX_CPU_RELAX
 #define arch_mutex_cpu_relax()  cpu_relax()
 #endif

arch/s390/include/asm/mutex.h:
 #define arch_mutex_cpu_relax()  barrier()

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 lib/lockref.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/lockref.c b/lib/lockref.c
index 9d76f40..7819c2d 100644
--- a/lib/lockref.c
+++ b/lib/lockref.c
@@ -19,7 +19,6 @@
 		if (likely(old.lock_count == prev.lock_count)) {		\
 			SUCCESS;						\
 		}								\
-		cpu_relax();							\
 	}									\
 } while (0)
 
-- 
1.8.3.4

