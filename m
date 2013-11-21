Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab3KUUt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 15:49:56 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:34295 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab3KUUty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 15:49:54 -0500
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
Date: Thu, 21 Nov 2013 12:49:47 -0800
In-Reply-To: <20131103035406.GA8537@ZenIV.linux.org.uk> (Al Viro's message of
	"Sun, 3 Nov 2013 03:54:06 +0000")
Message-ID: <87vbzl8opg.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/j2iYbm0Udfgqolb6XAV9mQkGIP5KViFI=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  3.0 XMDrug1234561 Drug references
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1920]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
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

I have been fighting a cold off and on so I have been taking much longer
to dig through all of these issues than I would like.

Aftering having thought through all of the issues I completely agree
that this is a racy bug that needs to be fixed.

The fix needs to be holding i_mutex of the parent directory in do_mount,
and pivot_root.

We need to hold i_mutex in do_mount and pivot_root not because of this
issue but to prevent mount points being renamed before we mount on them.

With todays kernel because of races between when we lookup a mount point
and when we take locks, and which locks we take.  When mount(2) returns
the mount point can be located anywhere.  Which completely defeats
returning -EBUSY mount points from a userspace semantics perspective.

I was really hoping I could think through this and say that this was a
trivial issue that would allow my patches to be good for 3.13.  But that
is clearly not the case.  kern_path_locked(...,LOOKUP_FOLLOW,...) is
non-trivial to implement, and there are issues like having to move
get_fs_type before we take any locks to prevent deadlocks.

I almost have the issues worked through, so hopefully I can send a
rebased set of patches in a few days.

Eric
