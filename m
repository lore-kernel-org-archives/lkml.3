Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759443Ab3E2CrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 22:47:15 -0400
Received: from mx2.parallels.com ([199.115.105.18]:56908 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759366Ab3E2CrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 22:47:13 -0400
Message-ID: <51A56C60.9030306@parallels.com>
Date: Wed, 29 May 2013 08:18:00 +0530
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andrey Vagin <avagin@openvz.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] memcg: don't initialize kmem-cache destroying work for
 root caches
References: <1368535118-27369-1-git-send-email-avagin@openvz.org> <20130528155326.0a8b66a7711746e827d5fdea@linux-foundation.org>
In-Reply-To: <20130528155326.0a8b66a7711746e827d5fdea@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [175.100.147.64]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2013 04:23 AM, Andrew Morton wrote:
> On Tue, 14 May 2013 16:38:38 +0400 Andrey Vagin <avagin@openvz.org> wrote:
> 
>> struct memcg_cache_params has a union. Different parts of this union are
>> used for root and non-root caches. A part with destroying work is used only
>> for non-root caches.
> 
> That union is a bit dangerous.  Perhaps it would be better to do
> something like
> 
> --- a/include/linux/slab.h~a
> +++ a/include/linux/slab.h
> @@ -337,15 +337,17 @@ static __always_inline int kmalloc_size(
>  struct memcg_cache_params {
>  	bool is_root_cache;
>  	union {
> -		struct kmem_cache *memcg_caches[0];
> -		struct {
> +		struct memcg_root_cache {
> +			struct kmem_cache *caches[0];
> +		} memcg_root_cache;
> +		struct memcg_child_cache {
>  			struct mem_cgroup *memcg;
>  			struct list_head list;
>  			struct kmem_cache *root_cache;
>  			bool dead;
>  			atomic_t nr_pages;
>  			struct work_struct destroy;
> -		};
> +		} memcg_child_cache;
>  	};
>  };
> 
> And then adopt the convention of selecting either memcg_root_cache or
> memcg_child_cache at the highest level then passing the more strongly
> typed pointer to callees.
> 

Since it is already creating problems, yes, I agree.

I will try to cook up something soon.

