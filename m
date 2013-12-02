Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759571Ab3LBVSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:18:17 -0500
Received: from relay.parallels.com ([195.214.232.42]:52334 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab3LBTMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:12:51 -0500
Message-ID: <529CDBAB.8060307@parallels.com>
Date: Mon, 2 Dec 2013 23:12:43 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130922 Icedove/17.0.9
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <devel@openvz.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Glauber Costa <glommer@gmail.com>
Subject: Re: [PATCH] memcg: remove KMEM_ACCOUNTED_ACTIVATED
References: <1385989693-28788-1-git-send-email-vdavydov@parallels.com> <20131202181501.GA5524@dhcp22.suse.cz>
In-Reply-To: <20131202181501.GA5524@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.24.25.12]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 10:15 PM, Michal Hocko wrote:
> [CCing Glauber - please do so in other posts for kmem related changes]
>
> On Mon 02-12-13 17:08:13, Vladimir Davydov wrote:
>> The KMEM_ACCOUNTED_ACTIVATED was introduced by commit a8964b9b ("memcg:
>> use static branches when code not in use") in order to guarantee that
>> static_key_slow_inc(&memcg_kmem_enabled_key) will be called only once
>> for each memory cgroup when its kmem limit is set. The point is that at
>> that time the memcg_update_kmem_limit() function's workflow looked like
>> this:
>>
>> 	bool must_inc_static_branch = false;
>>
>> 	cgroup_lock();
>> 	mutex_lock(&set_limit_mutex);
>> 	if (!memcg->kmem_account_flags && val != RESOURCE_MAX) {
>> 		/* The kmem limit is set for the first time */
>> 		ret = res_counter_set_limit(&memcg->kmem, val);
>>
>> 		memcg_kmem_set_activated(memcg);
>> 		must_inc_static_branch = true;
>> 	} else
>> 		ret = res_counter_set_limit(&memcg->kmem, val);
>> 	mutex_unlock(&set_limit_mutex);
>> 	cgroup_unlock();
>>
>> 	if (must_inc_static_branch) {
>> 		/* We can't do this under cgroup_lock */
>> 		static_key_slow_inc(&memcg_kmem_enabled_key);
>> 		memcg_kmem_set_active(memcg);
>> 	}
>>
>> Today, we don't use cgroup_lock in memcg_update_kmem_limit(), and
>> static_key_slow_inc() is called under the set_limit_mutex, but the
>> leftover from the above-mentioned commit is still here. Let's remove it.
> OK, so I have looked there again and 692e89abd154b (memcg: increment
> static branch right after limit set) which went in after cgroup_mutex
> has been removed. It came along with the following comment.
>                  /*
>                   * setting the active bit after the inc will guarantee no one
>                   * starts accounting before all call sites are patched
>                   */
>
> This suggests that the flag is needed after all because we have
> to be sure that _all_ the places have to be patched. AFAIU
> memcg_kmem_newpage_charge might see the static key already patched so
> it would do a charge but memcg_kmem_commit_charge would still see it
> unpatched and so the charge won't be committed.

Hmm, but we have the KMEM_ACCOUNTED_ACTIVE flag, which is set *after* 
static_key_slow_inc() in memcg_update_kmem_limit(), and 
__memcg_kmem_newpage_charge() checks it before charging 
(memcg_can_account_kmem()). So the situation you described is impossible?

>
> Or am I missing something?
>   
>> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Michal Hocko <mhocko@suse.cz>
>> Cc: Balbir Singh <bsingharora@gmail.com>
>> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> ---
>>   mm/memcontrol.c |   26 +-------------------------
>>   1 file changed, 1 insertion(+), 25 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index f1a0ae6..f78661f 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -344,14 +344,9 @@ static size_t memcg_size(void)
>>   /* internal only representation about the status of kmem accounting. */
>>   enum {
>>   	KMEM_ACCOUNTED_ACTIVE = 0, /* accounted by this cgroup itself */
>> -	KMEM_ACCOUNTED_ACTIVATED, /* static key enabled. */
>>   	KMEM_ACCOUNTED_DEAD, /* dead memcg with pending kmem charges */
>>   };
>>   
>> -/* We account when limit is on, but only after call sites are patched */
>> -#define KMEM_ACCOUNTED_MASK \
>> -		((1 << KMEM_ACCOUNTED_ACTIVE) | (1 << KMEM_ACCOUNTED_ACTIVATED))
>> -
>>   #ifdef CONFIG_MEMCG_KMEM
>>   static inline void memcg_kmem_set_active(struct mem_cgroup *memcg)
>>   {
>> @@ -363,16 +358,6 @@ static bool memcg_kmem_is_active(struct mem_cgroup *memcg)
>>   	return test_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_account_flags);
>>   }
>>   
>> -static void memcg_kmem_set_activated(struct mem_cgroup *memcg)
>> -{
>> -	set_bit(KMEM_ACCOUNTED_ACTIVATED, &memcg->kmem_account_flags);
>> -}
>> -
>> -static void memcg_kmem_clear_activated(struct mem_cgroup *memcg)
>> -{
>> -	clear_bit(KMEM_ACCOUNTED_ACTIVATED, &memcg->kmem_account_flags);
>> -}
>> -
>>   static void memcg_kmem_mark_dead(struct mem_cgroup *memcg)
>>   {
>>   	/*
>> @@ -2956,7 +2941,7 @@ static DEFINE_MUTEX(set_limit_mutex);
>>   static inline bool memcg_can_account_kmem(struct mem_cgroup *memcg)
>>   {
>>   	return !mem_cgroup_disabled() && !mem_cgroup_is_root(memcg) &&
>> -		(memcg->kmem_account_flags & KMEM_ACCOUNTED_MASK);
>> +		memcg_kmem_is_active(memcg);
>>   }
>>   
>>   /*
>> @@ -3091,19 +3076,10 @@ int memcg_update_cache_sizes(struct mem_cgroup *memcg)
>>   				0, MEMCG_CACHES_MAX_SIZE, GFP_KERNEL);
>>   	if (num < 0)
>>   		return num;
>> -	/*
>> -	 * After this point, kmem_accounted (that we test atomically in
>> -	 * the beginning of this conditional), is no longer 0. This
>> -	 * guarantees only one process will set the following boolean
>> -	 * to true. We don't need test_and_set because we're protected
>> -	 * by the set_limit_mutex anyway.
>> -	 */
>> -	memcg_kmem_set_activated(memcg);
>>   
>>   	ret = memcg_update_all_caches(num+1);
>>   	if (ret) {
>>   		ida_simple_remove(&kmem_limited_groups, num);
>> -		memcg_kmem_clear_activated(memcg);
>>   		return ret;
>>   	}
>>   
>> -- 
>> 1.7.10.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe cgroups" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

