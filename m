Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760AbaGILg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:36:58 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:26912 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755716AbaGILgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:36:55 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-1b-53bd29506087
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Vyukov <dvyukov@google.com>, Konstantin Serebryany <kcc@google.com>,
        Alexey Preobrazhensky <preobr@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        x86@kernel.org, linux-mm@kvack.org,
        Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [RFC/PATCH RESEND -next 20/21] fs: dcache: manually unpoison dname
 after allocation to shut up kasan's reports
Date: Wed, 09 Jul 2014 15:30:14 +0400
Message-id: <1404905415-9046-21-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t/xy7oBmnuDDa5dV7fY9usRm8XvvTNZ
	LeasX8Nmcf3bG0aLCQ/b2C1WdjezWWx/9pbJYmXnA1aLTY+vsVr82bWDyeLyrjlsFvfW/Ge1
	uH2Z1+LSgQVMFi37LjBZtH3+x2qxb+V5IGvJRiaLxUduM1u8ezaZ2WLzpqnMFj82PGZ1EPNo
	ae5h89g56y67x4JNpR6bVnWyeWz6NIndo+vtFSaPd+fOsXucmPGbxePJlelMHpuX1Ht8fHqL
	xeP9vqtsHn1bVjF6nFlwhN3j8ya5AP4oLpuU1JzMstQifbsErowPz16xFuxir/jW28LewNjB
	1sXIySEhYCJxd+Z2ZghbTOLCvfVAcS4OIYGljBIT1p1nh3D6mCRePn/GClLFJqAn8W/WdrBu
	EQEFic29IHEuDmaBZjaJ9o4PYEXCApUSr2bsAbNZBFQl+pZDNPMKuEksnHGDEWKdgsSy5TPB
	4pxA8QnTrwGdwQG0zVViwgq1CYy8CxgZVjGKppYmFxQnpeca6hUn5haX5qXrJefnbmKExNKX
	HYyLj1kdYhTgYFTi4dWo3R0sxJpYVlyZe4hRgoNZSYTXVnRvsBBvSmJlVWpRfnxRaU5q8SFG
	Jg5OqQbGgGN8k71mr/p0wLConzU94so2Y62ZjM3XHyVoxbFt+HIxgOG467oUtY25tRKZHG87
	FA+837xDKGvt7zezA93Zee2r2z7Nsjt0dYmu21fDr+Fiuew6x74Wvt230FT8v/PeO0Wh2xOf
	Ppza0sAQsnWD6hoFhXeTTib1GD3nMDK7a/jdTN30FYuoEktxRqKhFnNRcSIAdJFb9YMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to manually unpoison rounded up allocation size for dname
to avoid kasan's reports in __d_lookup_rcu.
__d_lookup_rcu may validly read a little beyound allocated size.

Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 fs/dcache.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/dcache.c b/fs/dcache.c
index b7e8b20..dff64f2 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -38,6 +38,7 @@
 #include <linux/prefetch.h>
 #include <linux/ratelimit.h>
 #include <linux/list_lru.h>
+#include <linux/kasan.h>
 #include "internal.h"
 #include "mount.h"
 
@@ -1412,6 +1413,8 @@ struct dentry *__d_alloc(struct super_block *sb, const struct qstr *name)
 			kmem_cache_free(dentry_cache, dentry); 
 			return NULL;
 		}
+		unpoison_shadow(dname,
+				roundup(name->len + 1, sizeof(unsigned long)));
 	} else  {
 		dname = dentry->d_iname;
 	}	
-- 
1.8.5.5

