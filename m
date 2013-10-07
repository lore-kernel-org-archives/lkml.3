Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab3JGGzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 02:55:42 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:53326 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab3JGGzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 02:55:38 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
	<87a9kkax0j.fsf@xmission.com>
	<CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
	<8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	<87li281wx6.fsf_-_@xmission.com> <87a9ioo37a.fsf_-_@xmission.com>
	<20131007043919.GB10284@mail.hallyn.com>
Date: Sun, 06 Oct 2013 23:55:29 -0700
In-Reply-To: <20131007043919.GB10284@mail.hallyn.com> (Serge E. Hallyn's
	message of "Mon, 7 Oct 2013 04:39:19 +0000")
Message-ID: <87vc191sf2.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19ewuSGo/ZOAQ1H+gw6QMRFDoCHS2I3uiU=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2309]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC][PATCH 4/3] vfs: Allow rmdir to remove mounts in all but the current mount namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> 
>> Programs have been known to test for empty directories by attempting
>> to remove them.  To keep from violating the principle of least
>> surprise don't let directories the caller can see with someting
>> mounted on them be deleted.
>
> Do you think we should do the same thing for over-mounted file at
> vfs_unlink()?

We easily could.

The point of the patch is to just preserve the directory is empty don't
allow rmdir to succeed semantics, and as typically we can see something
in the directory because of the mount it doesn't make sense for rmdir to
succeed.

unlink doesn't have any occassions when the permissions are sufficient
to remove a directory where it will fail.  So I don't see the point of
doing this for anything except directories.

Except for possibly the oddball rmdir semantics mentioned I don't think
this patch should be part of anyone's correctness analysis.



It is easiest to see that this series of changes is semantically safe if
we are safe to run unprivileged code in a mount namespace where root has
locally unmounted every mount point.

We do have the restriction that in a user namespace we can't unmount
anything root was mounted outside the user namespace.  Which combined
with the above patch would be roughly equivalent to todays mount
restrictions for the common case.  Unfortunately being only roughly
equivalent the analysis gets very complicated, and complicated reasoning
usually means invalid reasoning.


So if we can feel safe just depending on the parent directory
permissions (which are not hidden by a mount) protecting our mount
points, I feel much better about this patchset.



But if you can articulate some reasons why it would be better and less
surprising for unlink to fail I am willing to listen.



>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> ---
>>  fs/namei.c |   21 +++++++++++++++++++++
>>  1 files changed, 21 insertions(+), 0 deletions(-)
>> 
>> diff --git a/fs/namei.c b/fs/namei.c
>> index b18b017c946b..b9cae480ac27 100644
>> --- a/fs/namei.c
>> +++ b/fs/namei.c
>> @@ -3547,6 +3547,20 @@ void dentry_unhash(struct dentry *dentry)
>>  	spin_unlock(&dentry->d_lock);
>>  }
>>  
>> +static bool covered(struct vfsmount *mnt, struct dentry *dentry)
>> +{
>> +	/* test to see if a dentry is covered with a mount in
>> +	 * the current mount namespace.
>> +	 */
>> +	bool is_covered;
>> +
>> +	rcu_read_lock();
>> +	is_covered = d_mountpoint(dentry) && __lookup_mnt(mnt, dentry, 1);
>> +	rcu_read_unlock();
>> +
>> +	return is_covered;
>> +}
>> +
>>  int vfs_rmdir(struct inode *dir, struct dentry *dentry)
>>  {
>>  	int error = may_delete(dir, dentry, 1);
>> @@ -3619,6 +3633,9 @@ retry:
>>  		error = -ENOENT;
>>  		goto exit3;
>>  	}
>> +	error = -EBUSY;
>> +	if (covered(nd.path.mnt, dentry))
>> +		goto exit3;
>>  	error = security_path_rmdir(&nd.path, dentry);
>>  	if (error)
>>  		goto exit3;
>> @@ -4155,6 +4172,10 @@ retry:
>>  	error = -ENOTEMPTY;
>>  	if (new_dentry == trap)
>>  		goto exit5;
>> +	error = -EBUSY;
>> +	if (new_dentry->d_inode && S_ISDIR(new_dentry->d_inode->i_mode) &&
>> +	    covered(newnd.path.mnt, new_dentry))
>> +		goto exit5;
>>  
>>  	error = security_path_rename(&oldnd.path, old_dentry,
>>  				     &newnd.path, new_dentry);
>> -- 
>> 1.7.5.4
