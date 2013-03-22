Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab3CVKYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 06:24:48 -0400
Received: from mx2.parallels.com ([199.115.105.18]:33057 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab3CVKYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 06:24:46 -0400
Message-ID: <514C3193.9010609@parallels.com>
Date: Fri, 22 Mar 2013 14:25:23 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] memcg: fix memcg_cache_name() to use cgroup_name()
References: <20130321090849.GF6094@dhcp22.suse.cz> <20130321102257.GH6094@dhcp22.suse.cz> <514BB23E.70908@huawei.com> <20130322080749.GB31457@dhcp22.suse.cz> <514C1388.6090909@huawei.com> <514C14BF.3050009@parallels.com> <20130322093141.GE31457@dhcp22.suse.cz> <514C2754.4080701@parallels.com> <20130322094832.GG31457@dhcp22.suse.cz> <514C2C72.5090402@parallels.com> <20130322100609.GI31457@dhcp22.suse.cz>
In-Reply-To: <20130322100609.GI31457@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2013 02:06 PM, Michal Hocko wrote:
> On Fri 22-03-13 14:03:30, Glauber Costa wrote:
>> On 03/22/2013 01:48 PM, Michal Hocko wrote:
>>> On Fri 22-03-13 13:41:40, Glauber Costa wrote:
>>>> On 03/22/2013 01:31 PM, Michal Hocko wrote:
>>>>> On Fri 22-03-13 12:22:23, Glauber Costa wrote:
>>>>>> On 03/22/2013 12:17 PM, Li Zefan wrote:
>>>>>>>> GFP_TEMPORARY groups short lived allocations but the mem cache is not
>>>>>>>>> an ideal candidate of this type of allocations..
>>>>>>>>>
>>>>>>> I'm not sure I'm following you...
>>>>>>>
>>>>>>> char *memcg_cache_name()
>>>>>>> {
>>>>>>> 	char *name = alloc();
>>>>>>> 	return name;
>>>>>>> }
>>>>>>>
>>>>>>> kmem_cache_dup()
>>>>>>> {
>>>>>>> 	name = memcg_cache_name();
>>>>>>> 	kmem_cache_create_memcg(name);
>>>>>>> 	free(name);
>>>>>>> }
>>>>>>>
>>>>>>> Isn't this a short lived allocation?
>>>>>>>
>>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> Thanks for identifying and fixing this.
>>>>>>
>>>>>> Li is right. The cache name will live long, but this is because the
>>>>>> slab/slub caches will strdup it internally. So the actual memcg
>>>>>> allocation is short lived.
>>>>>
>>>>> OK, I have totally missed that. Sorry about the confusion. Then all the
>>>>> churn around the allocation is pointless, no?
>>>>> What about:
>>>>
>>>> If we're really not concerned about stack, then yes. Even if always
>>>> running from workqueues, a PAGE_SIZEd stack variable seems risky to me.
>>>
>>> This is not on stack. It is static
>>>
>> Ah, right, I totally missed that. And then you're taking the mutex.
>>
>> But actually, you don't need to take the mutex. All calls to
>> kmem_cache_dup are protected by the memcg_cache_mutex.
> 
> Yes and I am not taking that mutex. I've just added lockdep assert to
> make sure that this still holds true.
> 
It is impressive what a busy week does to our brains...

I read the code as lockdep_assert(memcg_cache_mutex), and then later on
mutex_lock(&memcg_mutex). But reading again, that was a just an
rcu_read_lock(). Good thing it is Friday

You guys can add my Acked-by, and thanks again

