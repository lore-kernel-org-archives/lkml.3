Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab3KHWRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 17:17:50 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:48294 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758474Ab3KHWRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 17:17:47 -0500
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
References: <87li23trll.fsf@tw-ebiederman.twitter.com>
	<CAJfpegv+h7xh_2e-X7is9dq1Fp06A0eKwsyWFMPX=azbbDCX5Q@mail.gmail.com>
	<87vc15mjuw.fsf@xmission.com>
	<CAJfpegvF89LzAvNB0h0otv7sKoS3rewZzQKAauQx3P+rCkCcSg@mail.gmail.com>
	<87iox38fkv.fsf@xmission.com> <87d2nb8dxy.fsf@xmission.com>
	<87iowyxpci.fsf_-_@xmission.com> <87d2n6xpan.fsf_-_@xmission.com>
	<20131103035406.GA8537@ZenIV.linux.org.uk>
	<87bo1u8vmf.fsf@xmission.com>
	<20131108213551.GR13318@ZenIV.linux.org.uk>
Date: Fri, 08 Nov 2013 14:17:31 -0800
In-Reply-To: <20131108213551.GR13318@ZenIV.linux.org.uk> (Al Viro's message of
	"Fri, 8 Nov 2013 21:35:51 +0000")
Message-ID: <87fvr61qtg.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19QPhN8RXNbRzSM4MYVfy+/CCVr6/8aOiA=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  3.0 XMDrug1234561 Drug references
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0190]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
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

> On Fri, Nov 08, 2013 at 12:51:52PM -0800, Eric W. Biederman wrote:
>
>> The return value of d_mountpoint can be obsolete as soon as it returns
>> as well, so I don't see this as being significantly different.
>
> Not if the ->i_mutex of that sucker is held.  And it *is* held in
> vfs_unlink/vfs_rmdir/vfs_rename.  Note that we only care about a mountpoint
> being falsely assumed to be a non-mountpoint - in the other direction we
> can just shrug and say that we'd won the race and got EBUSY for that.

I wasn't certain of your question.  My point here was that covered() as
a mechanism is as good as d_mountpoint.  So the only potential issue
with covered() as a mechanism is where covered() is called.

Also please note old_dentry->d_inode->i_mutex is not held in rename.

>> In 3.12 vfs_rmdir checks d_mountpoint with the
>> dentry->d_inode->i_mutex and
>> dentry->d_parent->d_inode->i_mutex held.
>> 
>> In 3.12 vfs_unlink checks d_mountpoint with the
>> dentry->d_inode->i_mutex and
>> dentry->d_parent->d_inode->i_mutex hel.d
>> 
>> In 3.12 vfs_rename_dir and vfs_rename_other checks d_mountpint with the
>> target->i_mutex, new_dir->i_mutex, and old_dir->i_mutex held.
>> 
>> 
>> Therefore the guarantees in 3.12 are:
>> - unlink versus mount races are prevented by the
>>   dentry->d_inode->i_mutex of the dentry being removed.
>> - unlink versus umount races are uninteresting.
>> - mount versus rename races in testing of d_mountpoint are ignored.
>
> Read what you've written a few lines above.  The part about target->i_mutex
> being held.

That works for the rename as unlink case but we don't hold
old_dentry->d_inode->i_mutex which is what is needed to prevent a mount
on the dentry we are renaming.

>> So comparing this to how I have implemented covered the test is at a
>> slightly different location in the call path so there may be a slightly
>> larger race in rename.
>
> You've got a race in unlink.  You've got a race in rename.  You've got a race
> in rmdir.  And none of those had that race in 3.12 (including rename()).

Rename absolutely has a race in 3.12.  With very lucky timing it is
possible to mount something on directory a, simultaneously rename
a to b, and have the mount show up on b.

> BTW, could you describe the races with umount in a bit more details?  Races
> with mount are simple - rmdir() sees that victim isn't a mountpoint and
> proceeds, mount() sees that victim is still alive and proceeds, despite
> the fact that victim is irretrievably on the way to removal.  And that's
> what ->i_mutex on victim prevents, making "check for d_mountpoint / remove /
> call dont_mount()" atomic wrt mount().  What is the problem you are seeing
> with umount()?  rmdir() getting EBUSY because it hasn't noticed umount()
> happening in parallel with it?  Legitimate behaviour, as far I can see...
> Or is it about something different?

I did not say it was a problem only that it was a race.  The only case I
can see is getting a state EBUSY, and I see no problem with a that.

Eric
