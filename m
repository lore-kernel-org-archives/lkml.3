Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704Ab3KHCcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:32:55 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:65412 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932648Ab3KHCcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:32:48 -0500
X-IronPort-AV: E=Sophos;i="4.93,656,1378828800"; 
   d="scan'208";a="8976353"
Message-ID: <527C4D88.10907@cn.fujitsu.com>
Date: Fri, 08 Nov 2013 10:33:44 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: Re: [REVIEW][PATCH 1/2] userns: Better restrictions on when proc
 and sysfs can be mounted
References: <878uzmhkqg.fsf@xmission.com> <52749663.2000701@cn.fujitsu.com>
In-Reply-To: <52749663.2000701@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/08 10:30:42,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/08 10:30:45,
	Serialize complete at 2013/11/08 10:30:45
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2013 02:06 PM, Gao feng wrote:
> Hi Eric,
> 
> On 08/28/2013 05:44 AM, Eric W. Biederman wrote:
>>
>> Rely on the fact that another flavor of the filesystem is already
>> mounted and do not rely on state in the user namespace.
>>
>> Verify that the mounted filesystem is not covered in any significant
>> way.  I would love to verify that the previously mounted filesystem
>> has no mounts on top but there are at least the directories
>> /proc/sys/fs/binfmt_misc and /sys/fs/cgroup/ that exist explicitly
>> for other filesystems to mount on top of.
>>
>> Refactor the test into a function named fs_fully_visible and call that
>> function from the mount routines of proc and sysfs.  This makes this
>> test local to the filesystems involved and the results current of when
>> the mounts take place, removing a weird threading of the user
>> namespace, the mount namespace and the filesystems themselves.
>>
>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> ---
>>  fs/namespace.c                 |   37 +++++++++++++++++++++++++------------
>>  fs/proc/root.c                 |    7 +++++--
>>  fs/sysfs/mount.c               |    3 ++-
>>  include/linux/fs.h             |    1 +
>>  include/linux/user_namespace.h |    4 ----
>>  kernel/user.c                  |    2 --
>>  kernel/user_namespace.c        |    2 --
>>  7 files changed, 33 insertions(+), 23 deletions(-)
>>
>> diff --git a/fs/namespace.c b/fs/namespace.c
>> index 64627f8..877e427 100644
>> --- a/fs/namespace.c
>> +++ b/fs/namespace.c
>> @@ -2867,25 +2867,38 @@ bool current_chrooted(void)
>>  	return chrooted;
>>  }
>>  
>> -void update_mnt_policy(struct user_namespace *userns)
>> +bool fs_fully_visible(struct file_system_type *type)
>>  {
>>  	struct mnt_namespace *ns = current->nsproxy->mnt_ns;
>>  	struct mount *mnt;
>> +	bool visible = false;
>>  
>> -	down_read(&namespace_sem);
>> +	if (unlikely(!ns))
>> +		return false;
>> +
>> +	namespace_lock();
>>  	list_for_each_entry(mnt, &ns->list, mnt_list) {
>> -		switch (mnt->mnt.mnt_sb->s_magic) {
>> -		case SYSFS_MAGIC:
>> -			userns->may_mount_sysfs = true;
>> -			break;
>> -		case PROC_SUPER_MAGIC:
>> -			userns->may_mount_proc = true;
>> -			break;
>> +		struct mount *child;
>> +		if (mnt->mnt.mnt_sb->s_type != type)
>> +			continue;
>> +
>> +		/* This mount is not fully visible if there are any child mounts
>> +		 * that cover anything except for empty directories.
>> +		 */
>> +		list_for_each_entry(child, &mnt->mnt_mounts, mnt_child) {
>> +			struct inode *inode = child->mnt_mountpoint->d_inode;
>> +			if (!S_ISDIR(inode->i_mode))
>> +				goto next;
>> +			if (inode->i_nlink != 2)
>> +				goto next;
> 
> 
> I met a problem that proc filesystem failed to mount in user namespace,
> The problem is the i_nlink of sysctl entries under proc filesystem is not
> 2. it always is 1 even it's a directory, see proc_sys_make_inode. and for
> btrfs, the i_nlink for an empty dir is 2 too. it seems like depends on the
> filesystem itself,not depends on vfs. In my system binfmt_misc is mounted
> on /proc/sys/fs/binfmt_misc, and the i_nlink of this directory's inode is
> 1.
> 
> btw, I'm not quite understand what's the inode->i_nlink != 2 here means?
> is this directory empty? as I know, when we create a file(not dir) under
> a dir, the i_nlink of this dir will not increase.
> 
> And another question, it looks like if we don't have proc/sys fs mounted,
> then proc/sys will be failed to be mounted?
> 

Any Idea?? or should we need to revert this patch??

