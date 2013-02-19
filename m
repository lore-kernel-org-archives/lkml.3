Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987Ab3BSBpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 20:45:16 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:8652 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798Ab3BSBpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 20:45:14 -0500
Message-ID: <5122D8F1.8000101@huawei.com>
Date: Tue, 19 Feb 2013 09:44:17 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Sasha Levin <levinsasha928@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] cgroup: fix cgroup_path() vs rename() race, take
 2
References: <51218100.5020007@huawei.com> <20130218173023.GG17414@htj.dyndns.org>
In-Reply-To: <20130218173023.GG17414@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/2/19 1:30, Tejun Heo wrote:
> Hello, Li.
> 
> On Mon, Feb 18, 2013 at 09:16:48AM +0800, Li Zefan wrote:
>> @@ -171,6 +171,7 @@ struct cgroup {
>>  
>>  	struct cgroup *parent;		/* my parent */
>>  	struct dentry *dentry;		/* cgroup fs entry, RCU protected */
>> +	char __rcu *name;		/* a copy of dentry->d_name */
> 
> A brief explanation of why this is necessary and how rcu is used would
> be nice.
> 

The comments in cgroup_path() explains why we can't use dentry->d_name,
which suggests why cgrp->name is needed. I'll revise the comments there,
and add comments on the rcu thing.

>> +static char *cgroup_alloc_name(struct dentry *dentry)
>> +{
>> +	char *name;
>> +
>> +	name = kmalloc(dentry->d_name.len + 1, GFP_KERNEL);
>> +	if (!name)
>> +		return NULL;
>> +	memcpy(name, dentry->d_name.name, dentry->d_name.len);
>> +	name[dentry->d_name.len] = '\0';
>> +	return name;
>> +}
> 
> While d_name has length field, it's always properly NULL terminated,
> so kstrdup() should suffice here.  Right, Al?
> 

Oh you're right. We pass dentry->d_name.name to printk %s in other places.

>> @@ -1613,13 +1626,19 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
> ...
>> -		inode = sb->s_root->d_inode;
>> +		dentry = sb->s_root;
>> +		inode = dentry->d_inode;
>> +
>> +		root_cgrp->name = cgroup_alloc_name(dentry);
>> +		if (!root_cgrp->name)
>> +			goto drop_new_super;
> 
> Don't we need an RCU assignment?  Is it safe because it isn't online
> yet?  But wouldn't this still trigger sparse warning?
> 

Yeah, it's safe.

To be frank, I haven't used sparse for years. Will check.

>> @@ -1751,6 +1770,8 @@ static void cgroup_kill_sb(struct super_block *sb) {
>>  	mutex_unlock(&cgroup_root_mutex);
>>  	mutex_unlock(&cgroup_mutex);
>>  
>> +	synchronize_rcu();
> 
> An explanation on what we're synchronizing would be nice.  Barriers
> without explanation sucks because there's nothing directly linking the
> barriers to the things which are being protected.
> 
>> @@ -2539,13 +2558,41 @@ static int cgroup_file_release(struct inode *inode, struct file *file)
>>  static int cgroup_rename(struct inode *old_dir, struct dentry *old_dentry,
>>  			    struct inode *new_dir, struct dentry *new_dentry)
>>  {
> ...
>> +	old_name = cgrp->name;
>> +	rcu_assign_pointer(cgrp->name, name);
>> +
>> +	synchronize_rcu();
> 
> Please don't call synchronize_rcu() from interface which is directly
> visible to userland.  It leads to sporadic difficult-to-reproduce
> latencies which hurt enough in corner cases and this is kmalloc
> memory.  It's not like kfree_rcu() is difficult to use or anything.
> 

ok

>> +	kfree(old_name);
>> +	return 0;
>>  }
>>  
>>  static struct simple_xattrs *__d_xattrs(struct dentry *dentry)
>> @@ -4144,9 +4191,13 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
>>  	if (!cgrp)
>>  		return -ENOMEM;
>>  
>> +	cgrp->name = cgroup_alloc_name(dentry);
>> +	if (!cgrp->name)
>> +		goto err_free_cgrp;
> 
> Ditto with assignment.
> 
> Thanks.
> 

