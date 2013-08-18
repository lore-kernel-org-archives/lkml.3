Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab3HRUjg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:39:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43734 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864Ab3HRUfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:35:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrey Vagin <avagin@openvz.org>, Glauber Costa <glommer@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 03/45] memcg: dont initialize kmem-cache destroying work for root caches
Date: Sun, 18 Aug 2013 13:35:52 -0700
Message-Id: <20130818203621.232791250@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203620.996166594@linuxfoundation.org>
References: <20130818203620.996166594@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Vagin <avagin@openvz.org>

commit 3e6b11df245180949938734bc192eaf32f3a06b3 upstream.

struct memcg_cache_params has a union.  Different parts of this union
are used for root and non-root caches.  A part with destroying work is
used only for non-root caches.

I fixed the same problem in another place v3.9-rc1-16204-gf101a94, but
didn't notice this one.

This patch fixes the kernel panic:

[   46.848187] BUG: unable to handle kernel paging request at 000000fffffffeb8
[   46.849026] IP: [<ffffffff811a484c>] kmem_cache_destroy_memcg_children+0x6c/0xc0
[   46.849092] PGD 0
[   46.849092] Oops: 0000 [#1] SMP
...

Signed-off-by: Andrey Vagin <avagin@openvz.org>
Cc: Glauber Costa <glommer@openvz.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3186,11 +3186,11 @@ int memcg_register_cache(struct mem_cgro
 	if (!s->memcg_params)
 		return -ENOMEM;
 
-	INIT_WORK(&s->memcg_params->destroy,
-			kmem_cache_destroy_work_func);
 	if (memcg) {
 		s->memcg_params->memcg = memcg;
 		s->memcg_params->root_cache = root_cache;
+		INIT_WORK(&s->memcg_params->destroy,
+				kmem_cache_destroy_work_func);
 	} else
 		s->memcg_params->is_root_cache = true;
 


