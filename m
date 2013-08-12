Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab3HLW2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 18:28:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57499 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab3HLW2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 18:28:14 -0400
Date: Mon, 12 Aug 2013 15:28:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-mm@kvack.org, Glauber Costa <glommer@parallels.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] [RFC] kmemcg: remove union from memcg_params
Message-Id: <20130812152812.915d5e8ebe5467586a457eb0@linux-foundation.org>
In-Reply-To: <1375995086-15456-1-git-send-email-avagin@openvz.org>
References: <1375995086-15456-1-git-send-email-avagin@openvz.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 Aug 2013 00:51:26 +0400 Andrey Vagin <avagin@openvz.org> wrote:

> struct memcg_cache_params {
>         bool is_root_cache;
>         union {
>                 struct kmem_cache *memcg_caches[0];
>                 struct {
>                         struct mem_cgroup *memcg;
>                         struct list_head list;
>                         struct kmem_cache *root_cache;
>                         bool dead;
>                         atomic_t nr_pages;
>                         struct work_struct destroy;
>                 };
>         };
> };
> 
> This union is a bit dangerous. //Andrew Morton
> 
> The first problem was fixed in v3.10-rc5-67-gf101a94.
> The second problem is that the size of memory for root
> caches is calculated incorrectly:
> 
> 	ssize_t size = memcg_caches_array_size(num_groups);
> 
> 	size *= sizeof(void *);
> 	size += sizeof(struct memcg_cache_params);
> 
> The last line should be fixed like this:
> 	size += offsetof(struct memcg_cache_params, memcg_caches)
> 
> Andrew suggested to rework this code without union and
> this patch tries to do that.

hm, did I?

> This patch removes is_root_cache and union. The size of the
> memcg_cache_params structure is not changed.
> 

It's a bit sad to consume more space because we're sucky programmers. 
It would be better to retain the union and to stop writing buggy code
to handle it!

Maybe there are things we can do to reduce the likelihood of people
mishandling the union - don't use anonymous fields, name each member,
access it via helper functions, etc.

