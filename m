Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510Ab3E1Wxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 18:53:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33666 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757444Ab3E1Wx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 18:53:28 -0400
Date: Tue, 28 May 2013 15:53:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Glauber Costa <glommer@parallels.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] memcg: don't initialize kmem-cache destroying work for
 root caches
Message-Id: <20130528155326.0a8b66a7711746e827d5fdea@linux-foundation.org>
In-Reply-To: <1368535118-27369-1-git-send-email-avagin@openvz.org>
References: <1368535118-27369-1-git-send-email-avagin@openvz.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 May 2013 16:38:38 +0400 Andrey Vagin <avagin@openvz.org> wrote:

> struct memcg_cache_params has a union. Different parts of this union are
> used for root and non-root caches. A part with destroying work is used only
> for non-root caches.

That union is a bit dangerous.  Perhaps it would be better to do
something like

--- a/include/linux/slab.h~a
+++ a/include/linux/slab.h
@@ -337,15 +337,17 @@ static __always_inline int kmalloc_size(
 struct memcg_cache_params {
 	bool is_root_cache;
 	union {
-		struct kmem_cache *memcg_caches[0];
-		struct {
+		struct memcg_root_cache {
+			struct kmem_cache *caches[0];
+		} memcg_root_cache;
+		struct memcg_child_cache {
 			struct mem_cgroup *memcg;
 			struct list_head list;
 			struct kmem_cache *root_cache;
 			bool dead;
 			atomic_t nr_pages;
 			struct work_struct destroy;
-		};
+		} memcg_child_cache;
 	};
 };

And then adopt the convention of selecting either memcg_root_cache or
memcg_child_cache at the highest level then passing the more strongly
typed pointer to callees.

