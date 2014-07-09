Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373AbaGILKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:10:32 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:61610 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbaGILKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:10:25 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-ae-53bd231de4a7
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [RFC/PATCH -next 20/21] fs: dcache: manually unpoison dname after
 allocation to shut up kasan's reports
Date: Wed, 09 Jul 2014 15:01:17 +0400
Message-id: <1404903678-8257-21-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
References: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLJMWRmVeSWpSXmKPExsVy+t/xy7qyynuDDR69MbHY9usRm8XlXXPY
	HJg8+rasYvT4vEkugCmKyyYlNSezLLVI3y6BK+PDs1esBbvYK771trA3MHawdTFyckgImEh0
	71oFZYtJXLi3Hsjm4hASWMooMe3jPnYIp49JYuPG3awgVWwCehL/Zm0H6xARUJDY3PsMLM4s
	oCOx8VorE4gtLFAk8fn6MeYuRg4OFgFViRcLy0DCvAJuEqf//WKBWKYgsWz5TLBWTqB4T88C
	sFYhAVeJ1Z+3MU5g5F3AyLCKUTS1NLmgOCk911CvODG3uDQvXS85P3cTIyQIvuxgXHzM6hCj
	AAejEg+vRu3uYCHWxLLiytxDjBIczEoivLaie4OFeFMSK6tSi/Lji0pzUosPMTJxcEo1MIpl
	x/8qU3n77WF0254H76J3KMcv8/6Tbt+vHZXzLP8H32FHxuUfZTzjrVLf8li81v33w73S6PHV
	Jy0vHz+yesxXekpl4U2FvZLtn6WOF+zMfH6OLSqidO7nipAao7XV8yd3nduj8H3ru79SGc8N
	Nj+cduP8msnywX31KSnrt617JBF7LHCK8lolluKMREMt5qLiRABG69924AEAAA==
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

