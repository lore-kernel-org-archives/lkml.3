Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab3AYHa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 02:30:28 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:47540 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab3AYHaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 02:30:25 -0500
Message-ID: <51023454.6050501@huawei.com>
Date: Fri, 25 Jan 2013 15:29:24 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] cpuset: fix cpuset_print_task_mems_allowed() vs rename()
 race
References: <51022FBC.2020705@huawei.com> <20130125072633.GD4503@ZenIV.linux.org.uk>
In-Reply-To: <20130125072633.GD4503@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/1/25 15:26, Al Viro wrpte:
> On Fri, Jan 25, 2013 at 03:09:48PM +0800, Li Zefan wrote:
>> rename() will change dentry->d_name. The result of this race can
>> be worse than seeing partially rewritten name, but we might access
>> a stale pointer because rename() will re-allocate memory to hold
>> a longer name.
>>
>> It's safe in the protection of dentry->d_lock.
>>
>> Signed-off-by: Li Zefan <lizefan@huawei.com>
>> ---
>>  kernel/cpuset.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
>> index 16be7c9..b2476c2 100644
>> --- a/kernel/cpuset.c
>> +++ b/kernel/cpuset.c
>> @@ -2606,8 +2606,12 @@ void cpuset_print_task_mems_allowed(struct task_struct *tsk)
>>  
>>  	dentry = task_cs(tsk)->css.cgroup->dentry;
>>  	spin_lock(&cpuset_buffer_lock);
>> +
>> +	spin_lock(&dentry->d_lock);
>>  	snprintf(cpuset_name, CPUSET_NAME_LEN,
>>  		 dentry ? (const char *)dentry->d_name.name : "/");
> 
> Ahem...  Can dentry actually be NULL here?  If not, this conditional
> is bogus; otherwise, spin_lock(&dentry->d_lock) is going to blow up...

oops, my fault...It's NULL if cpuset is not mounted.

