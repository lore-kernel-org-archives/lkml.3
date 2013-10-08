Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab3JHVr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 17:47:28 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:43726 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632Ab3JHVrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 17:47:23 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
	<87a9kkax0j.fsf@xmission.com>
	<CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
	<8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	<87li281wx6.fsf_-_@xmission.com> <874n8w1wsz.fsf_-_@xmission.com>
	<20131008155041.GI14242@tucsk.piliscsaba.szeredi.hu>
Date: Tue, 08 Oct 2013 14:47:12 -0700
In-Reply-To: <20131008155041.GI14242@tucsk.piliscsaba.szeredi.hu> (Miklos
	Szeredi's message of "Tue, 8 Oct 2013 17:50:41 +0200")
Message-ID: <877gdne8pr.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/YaxVDKSBwfsYdKSWG6dLZON8XVBvzBd4=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0410]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Miklos Szeredi <miklos@szeredi.hu>
X-Spam-Relay-Country: 
Subject: Re: [RFC][PATCH 3/3] vfs: Lazily remove mounts on unlinked files and directories.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> On Fri, Oct 04, 2013 at 03:43:56PM -0700, Eric W. Biederman wrote:
>> +/**
>> + * shrink_submounts_and_drop - detach submounts, prune dcache, and drop
>> + *
>> + * All done as a single atomic operation reletaive to d_set_mounted().
>> + *
>> + * @dentry: dentry to detach, prune and drop
>> + */
>> +void shrink_submounts_and_drop(struct dentry *dentry)
>> +{
>> +	d_drop(dentry);
>> +	detach_submounts(dentry);
>
> And here, between detach_submounts() and shrink_dcache_parent() a new mount can
> be added.

Actually it is not possible to add a new mount betwee detach_submounts
and shrink_dcache_parent d_set_mountpoint will see the unhashed
dentry as an unhashed parent and refuse to add any new mount points.

> It's not accidental that check_submounts_and_drop() did the check and the drop
> together, protected by rename_lock and d_lock.

When I looked the locking of detach_mount prevented me from using the
same technique as check_submounts_and_drop.   But happily
d_set_mountpoint now checks for unhashed parents and prevents carnage at
that point.

>> +	shrink_dcache_parent(dentry);
>>  }
>> -EXPORT_SYMBOL(check_submounts_and_drop);
>> +EXPORT_SYMBOL(shrink_submounts_and_drop);
>>  

>> @@ -3988,10 +3983,6 @@ static int vfs_rename_dir(struct inode *old_dir, struct dentry *old_dentry,
>>  	if (target)
>>  		mutex_lock(&target->i_mutex);
>>  
>> -	error = -EBUSY;
>> -	if (d_mountpoint(old_dentry) || d_mountpoint(new_dentry))
>> -		goto out;
>> -
>
> I know of at least one app that relied at some point on a mountpoint (directory
> or non-directory) not being movable: fusermount uses this to ensure that
> unprivileged userspace didn't try replacing a fuse mount with a symlink to trick
> fusermount into umounting an arbitrary path.  The code that relied on this was
> replaced by UMOUNT_NOFOLLOW on kernels where it is supported.  But in theory
> there may exist a running binary without UMOUNT_NOFOLLOW and relying on EBUSY.
>
> And there may be other such horrid hacks out there.

That is certainly worth thinking about.

In practice if I rename a parent directory I can rename mount points
today.  So I don't know that it was ever fully safe to rely on rename
prevention.

We may be able to keep this rule just for the local mount namespace if
that would help.

If we are going to remove lying to the VFS removing the d_mountpoint
restriction of rename is necessary.


It gets scary to rely on the checks only applying locally, because of
things like mount --bind /some/path /some/other/path, and because of
cases like sysfs and nfs where the mutation path is not through the
local vfs and simply bypasses all of these changes.

So I will think about this case some more but I don't think I can make
this change and remain hack compatile with old kernels.

I hope we don't find any horrible hacks that we absolutely must support
because at best that puts everything back to the drawing board.

But I will go through and read the old fusermount code before I get too
much farther just so I understand what I am potentially breaking.

>>  	error = -EMLINK;
>>  	if (max_links && !target && new_dir != old_dir &&
>>  	    new_dir->i_nlink >= max_links)
>> @@ -4006,6 +3997,7 @@ static int vfs_rename_dir(struct inode *old_dir, struct dentry *old_dentry,
>>  	if (target) {
>>  		target->i_flags |= S_DEAD;
>>  		dont_mount(new_dentry);
>> +		detach_mounts(new_dentry);
>>  	}
>>  out:
>>  	if (target)
>> @@ -4031,16 +4023,15 @@ static int vfs_rename_other(struct inode *old_dir, struct dentry *old_dentry,
>>  	if (target)
>>  		mutex_lock(&target->i_mutex);
>>  
>> -	error = -EBUSY;
>> -	if (d_mountpoint(old_dentry)||d_mountpoint(new_dentry))
>> -		goto out;
>> -
>>  	error = old_dir->i_op->rename(old_dir, old_dentry, new_dir, new_dentry);
>>  	if (error)
>>  		goto out;
>>  
>> -	if (target)
>> +	if (target) {
>>  		dont_mount(new_dentry);
>> +		detach_mounts(new_dentry);
>> +	}
>> +	detach_mounts(old_dentry);
>
> Why exactly?  "Moved file changes contents" is not the least surprising result,
> IMO.  And why the difference between rename-dir and rename-other in
> this regard?

Because detach_mounts(old_dentry) is a bug.

detach_mounts(new_dentry) is needed so that it is safe to put new_dentry
a few lines

Eric
