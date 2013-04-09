Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936991Ab3DIHxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 03:53:10 -0400
Received: from mx2.parallels.com ([199.115.105.18]:35052 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240Ab3DIHxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 03:53:08 -0400
Message-ID: <5163C90E.8040602@parallels.com>
Date: Tue, 9 Apr 2013 11:53:50 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: Re: [PATCH 13/12] memcg: don't need memcg->memcg_name
References: <5162648B.9070802@huawei.com> <51626584.7050405@huawei.com> <5163868B.3020905@jp.fujitsu.com> <5163887D.1040809@huawei.com>
In-Reply-To: <5163887D.1040809@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 07:18 AM, Li Zefan wrote:
>>> @@ -5188,12 +5154,28 @@ static int mem_cgroup_dangling_read(struct cgroup *cont, struct cftype *cft,
>>>   					struct seq_file *m)
>>>   {
>>>   	struct mem_cgroup *memcg;
>>> +	char *memcg_name;
>>> +	int ret;
>>> +
>>> +	/*
>>> +	 * cgroup.c will do page-sized allocations most of the time,
>>> +	 * so we'll just follow the pattern. Also, __get_free_pages
>>> +	 * is a better interface than kmalloc for us here, because
>>> +	 * we'd like this memory to be always billed to the root cgroup,
>>> +	 * not to the process removing the memcg. While kmalloc would
>>> +	 * require us to wrap it into memcg_stop/resume_kmem_account,
>>> +	 * with __get_free_pages we just don't pass the memcg flag.
>>> +	 */
>>> +	memcg_name = (char *)__get_free_pages(GFP_KERNEL, 0);
>>> +	if (!memcg_name)
>>> +		return -ENOMEM;
>>>   
>>>   	mutex_lock(&dangling_memcgs_mutex);
>>>   
>>>   	list_for_each_entry(memcg, &dangling_memcgs, dead) {
>>> -		if (memcg->memcg_name)
>>> -			seq_printf(m, "%s:\n", memcg->memcg_name);
>>> +		ret = cgroup_path(memcg->css.cgroup, memcg_name, PAGE_SIZE);
>>> +		if (!ret)
>>> +			seq_printf(m, "%s:\n", memcg_name);
>>>   		else
>>>   			seq_printf(m, "%p (name lost):\n", memcg);
>>>   
>>
>> I'm sorry for dawm question ...when this error happens ?
>> We may get ENAMETOOLONG even with PAGE_SIZE(>=4096bytes) buffer ?
>>
> 
> It does no harm to check the return value, and we don't have to
> worry about if cgroup_path() will be changed to return some other
> errno like ENOMEM in the future.
> 
I feel more comfortable with the check as well. This is a debugging
interface after all. People tend to resort to this when things go wrong.
So at this point the less assumptions we make, the better.

