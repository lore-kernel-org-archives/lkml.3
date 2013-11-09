Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714Ab3KIFmu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 00:42:50 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:37719 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab3KIFms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 00:42:48 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
References: <878uzmhkqg.fsf@xmission.com> <52749663.2000701@cn.fujitsu.com>
	<527C4D88.10907@cn.fujitsu.com>
Date: Fri, 08 Nov 2013 21:42:36 -0800
In-Reply-To: <527C4D88.10907@cn.fujitsu.com> (Gao feng's message of "Fri, 08
	Nov 2013 10:33:44 +0800")
Message-ID: <87k3gigmgj.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19OUY3UeAdJqGz3Y5j2T/zBh+Hrd8Rnpik=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3437]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Gao feng <gaofeng@cn.fujitsu.com>
X-Spam-Relay-Country: 
Subject: Re: [REVIEW][PATCH 1/2] userns: Better restrictions on when proc and sysfs can be mounted
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gao feng <gaofeng@cn.fujitsu.com> writes:

> On 11/02/2013 02:06 PM, Gao feng wrote:
>> Hi Eric,
>> 
>> On 08/28/2013 05:44 AM, Eric W. Biederman wrote:
>>>
>>> Rely on the fact that another flavor of the filesystem is already
>>> mounted and do not rely on state in the user namespace.
>>>
>>> Verify that the mounted filesystem is not covered in any significant
>>> way.  I would love to verify that the previously mounted filesystem
>>> has no mounts on top but there are at least the directories
>>> /proc/sys/fs/binfmt_misc and /sys/fs/cgroup/ that exist explicitly
>>> for other filesystems to mount on top of.
>>>
>>> Refactor the test into a function named fs_fully_visible and call that
>>> function from the mount routines of proc and sysfs.  This makes this
>>> test local to the filesystems involved and the results current of when
>>> the mounts take place, removing a weird threading of the user
>>> namespace, the mount namespace and the filesystems themselves.
>>>
>>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>>> ---
>>>  fs/namespace.c                 |   37 +++++++++++++++++++++++++------------
>>>  fs/proc/root.c                 |    7 +++++--
>>>  fs/sysfs/mount.c               |    3 ++-
>>>  include/linux/fs.h             |    1 +
>>>  include/linux/user_namespace.h |    4 ----
>>>  kernel/user.c                  |    2 --
>>>  kernel/user_namespace.c        |    2 --
>>>  7 files changed, 33 insertions(+), 23 deletions(-)
>>>
>>> diff --git a/fs/namespace.c b/fs/namespace.c
>>> index 64627f8..877e427 100644
>>> --- a/fs/namespace.c
>>> +++ b/fs/namespace.c
>>> @@ -2867,25 +2867,38 @@ bool current_chrooted(void)
>>>  	return chrooted;
>>>  }
>>>  
>>> -void update_mnt_policy(struct user_namespace *userns)
>>> +bool fs_fully_visible(struct file_system_type *type)
>>>  {
>>>  	struct mnt_namespace *ns = current->nsproxy->mnt_ns;
>>>  	struct mount *mnt;
>>> +	bool visible = false;
>>>  
>>> -	down_read(&namespace_sem);
>>> +	if (unlikely(!ns))
>>> +		return false;
>>> +
>>> +	namespace_lock();
>>>  	list_for_each_entry(mnt, &ns->list, mnt_list) {
>>> -		switch (mnt->mnt.mnt_sb->s_magic) {
>>> -		case SYSFS_MAGIC:
>>> -			userns->may_mount_sysfs = true;
>>> -			break;
>>> -		case PROC_SUPER_MAGIC:
>>> -			userns->may_mount_proc = true;
>>> -			break;
>>> +		struct mount *child;
>>> +		if (mnt->mnt.mnt_sb->s_type != type)
>>> +			continue;
>>> +
>>> +		/* This mount is not fully visible if there are any child mounts
>>> +		 * that cover anything except for empty directories.
>>> +		 */
>>> +		list_for_each_entry(child, &mnt->mnt_mounts, mnt_child) {
>>> +			struct inode *inode = child->mnt_mountpoint->d_inode;
>>> +			if (!S_ISDIR(inode->i_mode))
>>> +				goto next;
>>> +			if (inode->i_nlink != 2)
>>> +				goto next;
>> 
>> 
>> I met a problem that proc filesystem failed to mount in user namespace,
>> The problem is the i_nlink of sysctl entries under proc filesystem is not
>> 2. it always is 1 even it's a directory, see proc_sys_make_inode. and for
>> btrfs, the i_nlink for an empty dir is 2 too. it seems like depends on the
>> filesystem itself,not depends on vfs. In my system binfmt_misc is mounted
>> on /proc/sys/fs/binfmt_misc, and the i_nlink of this directory's inode is
>> 1.

Yes. 1 is what filesystems that are too lazy to count the number of
links to a directory return, and /proc/sys is currently such a
filesystem.

Ordinarily nlink == 2 means a directory does not have any subdirectories.

>> btw, I'm not quite understand what's the inode->i_nlink != 2 here means?
>> is this directory empty? as I know, when we create a file(not dir) under
>> a dir, the i_nlink of this dir will not increase.
>> 
>> And another question, it looks like if we don't have proc/sys fs mounted,
>> then proc/sys will be failed to be mounted?
>> 
>
> Any Idea?? or should we need to revert this patch??

The patch is mostly doing what it is supposed to be doing.

Now the code is slightly buggy.  inode->i_nlink will test to see if a
directory has subdirectories but it won't test to see if a directory is
empty.  Where did my brain go when I was writing that test?

Right now I would rather not have the empty directory exception than
remove this code.

The test is a little trickier to write than it might otherwise be
because /proc and /sys tend to be slightly imperfect filesystems.

I think the only way to really test that is to call readdir on the
directory itself :(  I don't like that thought.

I don't know what I was thinking when I wrote that test but I definitely
goofed up.  Grr!

I can certainly filter out any directory with nlink > 2.  That would be
an easy partial step forward.

The real question though is how do I detect directories it is safe to
mount on where there will not be files in them.  I can't call iterate
with the namespace_lock held so things are a bit tricky.

Eric

