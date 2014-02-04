Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaBDG11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 01:27:27 -0500
Received: from relay.parallels.com ([195.214.232.42]:57468 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbaBDG1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 01:27:20 -0500
Message-ID: <52F08842.8050906@parallels.com>
Date: Tue, 4 Feb 2014 10:27:14 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <mhocko@suse.cz>, <rientjes@google.com>, <penberg@kernel.org>,
        <cl@linux.com>, <glommer@gmail.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <devel@openvz.org>
Subject: Re: [PATCH v2 2/7] memcg, slab: cleanup memcg cache name creation
References: <cover.1391441746.git.vdavydov@parallels.com> <ec86147b3dfd5bf7da5b34e12b7a4e4881f49690.1391441746.git.vdavydov@parallels.com> <20140203140835.c414b6222abfd9c349648e2a@linux-foundation.org>
In-Reply-To: <20140203140835.c414b6222abfd9c349648e2a@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2014 02:08 AM, Andrew Morton wrote:
> On Mon, 3 Feb 2014 19:54:37 +0400 Vladimir Davydov <vdavydov@parallels.com> wrote:
>
>> The way memcg_create_kmem_cache() creates the name for a memcg cache
>> looks rather strange: it first formats the name in the static buffer
>> tmp_name protected by a mutex, then passes the pointer to the buffer to
>> kmem_cache_create_memcg(), which finally duplicates it to the cache
>> name.
>>
>> Let's clean this up by moving memcg cache name creation to a separate
>> function to be called by kmem_cache_create_memcg(), and estimating the
>> length of the name string before copying anything to it so that we won't
>> need a temporary buffer.
>>
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -3193,6 +3193,37 @@ int memcg_update_cache_size(struct kmem_cache *s, int num_groups)
>>  	return 0;
>>  }
>>  
>> +static int memcg_print_cache_name(char *buf, size_t size,
>> +		struct mem_cgroup *memcg, struct kmem_cache *root_cache)
>> +{
>> +	int ret;
>> +
>> +	rcu_read_lock();
>> +	ret = snprintf(buf, size, "%s(%d:%s)", root_cache->name,
>> +		       memcg_cache_id(memcg), cgroup_name(memcg->css.cgroup));
>> +	rcu_read_unlock();
>> +	return ret;
>> +}
>> +
>> +char *memcg_create_cache_name(struct mem_cgroup *memcg,
>> +			      struct kmem_cache *root_cache)
>> +{
>> +	int len;
>> +	char *name;
>> +
>> +	/*
>> +	 * We cannot use kasprintf() here, because cgroup_name() must be called
>> +	 * under RCU protection.
>> +	 */
>> +	len = memcg_print_cache_name(NULL, 0, memcg, root_cache);
>> +
>> +	name = kmalloc(len + 1, GFP_KERNEL);
>> +	if (name)
>> +		memcg_print_cache_name(name, len + 1, memcg, root_cache);
> but but but this assumes that cgroup_name(memcg->css.cgroup) did not
> change between the two calls to memcg_print_cache_name().  If that is
> the case then the locking was unneeded anyway.

Oops, I missed that. Thank you for pointing me out. It seems the usage
of the temporary buffer is inevitable. However, a dedicated mutex
protecting it can be removed, because we already hold the slab_mutex
while calling this function. Will rework.

Thanks.

>
>> +	return name;
>> +}
>> +
>>  int memcg_alloc_cache_params(struct mem_cgroup *memcg, struct kmem_cache *s,
>>  			     struct kmem_cache *root_cache)
>>  {
>> @@ -3397,44 +3428,6 @@ void mem_cgroup_destroy_cache(struct kmem_cache *cachep)
>>  	schedule_work(&cachep->memcg_params->destroy);
>>  }
>>  

