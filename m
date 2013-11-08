Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216Ab3KHUwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 15:52:10 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:36381 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757629Ab3KHUwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 15:52:07 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Andy Lutomirski <luto@amacapital.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthias Schniedermeyer <ms@citd.de>,
        Linux Containers <containers@lists.linux-foundation.org>
References: <CALCETrWw=htmgxqq=RQztdJQ-a8c3860vmJh9Ni=Hhs0TkO3YA@mail.gmail.com>
	<20131008161135.GK14242@tucsk.piliscsaba.szeredi.hu>
	<87li23trll.fsf@tw-ebiederman.twitter.com>
	<CAJfpegv+h7xh_2e-X7is9dq1Fp06A0eKwsyWFMPX=azbbDCX5Q@mail.gmail.com>
	<87vc15mjuw.fsf@xmission.com>
	<CAJfpegvF89LzAvNB0h0otv7sKoS3rewZzQKAauQx3P+rCkCcSg@mail.gmail.com>
	<87iox38fkv.fsf@xmission.com> <87d2nb8dxy.fsf@xmission.com>
	<87iowyxpci.fsf_-_@xmission.com> <87d2n6xpan.fsf_-_@xmission.com>
	<20131103035406.GA8537@ZenIV.linux.org.uk>
Date: Fri, 08 Nov 2013 12:51:52 -0800
In-Reply-To: <20131103035406.GA8537@ZenIV.linux.org.uk> (Al Viro's message of
	"Sun, 3 Nov 2013 03:54:06 +0000")
Message-ID: <87bo1u8vmf.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18i92B0ye0mT6dvYjXsCvb04WsaDTnVtN0=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  3.0 XMDrug1234561 Drug references
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0523]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
Subject: Re: [REVIEW][PATCH 1/4] vfs: Don't allow overwriting mounts in the current mount namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Tue, Oct 15, 2013 at 01:16:48PM -0700, Eric W. Biederman wrote:
>
>>  int vfs_rmdir(struct inode *dir, struct dentry *dentry)
>>  {
>>  	int error = may_delete(dir, dentry, 1);
>> @@ -3622,6 +3636,9 @@ retry:
>>  		error = -ENOENT;
>>  		goto exit3;
>>  	}
>> +	error = -EBUSY;
>> +	if (covered(nd.path.mnt, dentry))
>> +		goto exit3;
>
> Ugh...  And it's not racy because of...?  IOW, what's to keep the return
> value of covered() from getting obsolete just as it's being calculated,
> let alone returned?

The return value of d_mountpoint can be obsolete as soon as it returns
as well, so I don't see this as being significantly different.

I would like to say that any changes introduced here do not matter
because all of this is just to keep a semblance of the old semantics.
Unfortunately for me part of keeping that semblance is as much as is
reasonable preserving the existing race guarantees.

In 3.12 we create a mount with:
- The dentry->d_inode mutex held.
- The namespace_sem held.

In 3.12 we remove a mount with just the namespace_sem held.

I call covered in: do_rmdir, do_unlinkat, and renameat.

In 3.12 vfs_rmdir checks d_mountpoint with the
dentry->d_inode->i_mutex and
dentry->d_parent->d_inode->i_mutex held.

In 3.12 vfs_unlink checks d_mountpoint with the
dentry->d_inode->i_mutex and
dentry->d_parent->d_inode->i_mutex hel.d

In 3.12 vfs_rename_dir and vfs_rename_other checks d_mountpint with the
target->i_mutex, new_dir->i_mutex, and old_dir->i_mutex held.


Therefore the guarantees in 3.12 are:
- unlink versus mount races are prevented by the
  dentry->d_inode->i_mutex of the dentry being removed.
- unlink versus umount races are uninteresting.
- mount versus rename races in testing of d_mountpoint are ignored.
- umount versus rename races in testing of d_mountpoint are ignored.

So comparing this to how I have implemented covered the test is at a
slightly different location in the call path so there may be a slightly
larger race in rename.

For unlink there is a race where the mount could happen after testing
covered.  Then the unlink happens.  Then we remove the mount with
detach_mounts.


In the context of the symlink attacks against umounting of fuse I don't
see a difference.

In the only case where there is a new race (unlink versus mount) I see
a narrow window where new behavior will happen the unlink will win and
we unmount the filesystem.  So there is a vary narrow window in which
we might have a stale entry in /etc/mtab.

So after all of that analysis I don't think we care.  If we do care with
a little more work we can pass the mountpoint down and test covered with
dentry->d_inode->i_mutex held, where we test d_mountpoint in 3.12 today.

Eric

