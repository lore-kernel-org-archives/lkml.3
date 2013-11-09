Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503Ab3KIGvV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 01:51:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33088 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300Ab3KIGvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:51:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Ghennadi Procopciuc <unix140@gmail.com>,
        Daniel Baluta <dbaluta@ixiacom.com>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Anatoly Muliarski <x86ever@gmail.com>
Subject: [PATCH 3.10 64/74] mm/vmalloc.c: fix an overflow bug in alloc_vmap_area()
Date: Fri,  8 Nov 2013 22:52:09 -0800
Message-Id: <20131109065117.964902801@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065113.502217951@linuxfoundation.org>
References: <20131109065113.502217951@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yanfei <zhangyanfei.yes@gmail.com>

commit bcb615a81b1765864c71c50afb56631e7a1e5283 upstream.

When searching a vmap area in the vmalloc space, we use (addr + size -
1) to check if the value is less than addr, which is an overflow.  But
we assign (addr + size) to vmap_area->va_end.

So if we come across the below case:

  (addr + size - 1) : not overflow
  (addr + size)     : overflow

we will assign an overflow value (e.g 0) to vmap_area->va_end, And this
will trigger BUG in __insert_vmap_area, causing system panic.

So using (addr + size) to check the overflow should be the correct
behaviour, not (addr + size - 1).

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Reported-by: Ghennadi Procopciuc <unix140@gmail.com>
Tested-by: Daniel Baluta <dbaluta@ixiacom.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Anatoly Muliarski <x86ever@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmalloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -388,12 +388,12 @@ nocache:
 		addr = ALIGN(first->va_end, align);
 		if (addr < vstart)
 			goto nocache;
-		if (addr + size - 1 < addr)
+		if (addr + size < addr)
 			goto overflow;
 
 	} else {
 		addr = ALIGN(vstart, align);
-		if (addr + size - 1 < addr)
+		if (addr + size < addr)
 			goto overflow;
 
 		n = vmap_area_root.rb_node;
@@ -420,7 +420,7 @@ nocache:
 		if (addr + cached_hole_size < first->va_start)
 			cached_hole_size = first->va_start - addr;
 		addr = ALIGN(first->va_end, align);
-		if (addr + size - 1 < addr)
+		if (addr + size < addr)
 			goto overflow;
 
 		if (list_is_last(&first->list, &vmap_area_list))


