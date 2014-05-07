Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbaEGUx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 16:53:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57226 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbaEGUxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 16:53:53 -0400
Date: Wed, 7 May 2014 13:53:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>, <hannes@cmpxchg.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH -mm 1/2] memcg: get rid of memcg_create_cache_name
Message-Id: <20140507135352.3790c739ae331d1f6721f3de@linux-foundation.org>
In-Reply-To: <20140507104514.GC4757@esperanza>
References: <a4aa62026c10fc709e8bf13542b29cf771381394.1399450112.git.vdavydov@parallels.com>
	<20140507095127.GC9489@dhcp22.suse.cz>
	<20140507104514.GC4757@esperanza>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2014 14:45:16 +0400 Vladimir Davydov <vdavydov@parallels.com> wrote:

> @@ -3164,6 +3141,7 @@ void memcg_free_cache_params(struct kmem_cache *s)
>  static void memcg_kmem_create_cache(struct mem_cgroup *memcg,
>  				    struct kmem_cache *root_cache)
>  {
> +	static char *memcg_name_buf;	/* protected by memcg_slab_mutex */
>  	struct kmem_cache *cachep;
>  	int id;
>  
> @@ -3179,7 +3157,14 @@ static void memcg_kmem_create_cache(struct mem_cgroup *memcg,
>  	if (cache_from_memcg_idx(root_cache, id))
>  		return;
>  
> -	cachep = kmem_cache_create_memcg(memcg, root_cache);
> +	if (!memcg_name_buf) {
> +		memcg_name_buf = kmalloc(NAME_MAX + 1, GFP_KERNEL);
> +		if (!memcg_name_buf)
> +			return;
> +	}

Does this have any meaningful advantage over the simpler

	static char memcg_name_buf[NAME_MAX + 1];

?

I guess it saves a scrap of memory if the machine never uses memcg's.
