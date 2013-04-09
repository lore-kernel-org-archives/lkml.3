Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935460Ab3DIDrO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 23:47:14 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34863 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757254Ab3DIDrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 23:47:13 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <51638F2B.3000800@jp.fujitsu.com>
Date: Tue, 09 Apr 2013 12:46:51 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH 13/12] memcg: don't need memcg->memcg_name
References: <5162648B.9070802@huawei.com> <51626584.7050405@huawei.com> <5163868B.3020905@jp.fujitsu.com> <5163887D.1040809@huawei.com>
In-Reply-To: <5163887D.1040809@huawei.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/09 12:18), Li Zefan wrote:
>>> @@ -5188,12 +5154,28 @@ static int mem_cgroup_dangling_read(struct cgroup *cont, struct cftype *cft,
>>>    					struct seq_file *m)
>>>    {
>>>    	struct mem_cgroup *memcg;
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
>>>    	mutex_lock(&dangling_memcgs_mutex);
>>>    
>>>    	list_for_each_entry(memcg, &dangling_memcgs, dead) {
>>> -		if (memcg->memcg_name)
>>> -			seq_printf(m, "%s:\n", memcg->memcg_name);
>>> +		ret = cgroup_path(memcg->css.cgroup, memcg_name, PAGE_SIZE);
>>> +		if (!ret)
>>> +			seq_printf(m, "%s:\n", memcg_name);
>>>    		else
>>>    			seq_printf(m, "%p (name lost):\n", memcg);
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
Hmm. but the name is not lost, right ?
How about returning error rather than making a mixture of lines in different formats ?

Thanks,
-Kame

