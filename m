Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab3JGWZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 18:25:34 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:32867 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3JGWZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 18:25:28 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Miklos Szeredi <miklos@szeredi.hu>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
	<87a9kkax0j.fsf@xmission.com>
	<CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
	<8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	<87li281wx6.fsf_-_@xmission.com> <87a9ioo37a.fsf_-_@xmission.com>
	<20131007043919.GB10284@mail.hallyn.com> <87vc191sf2.fsf@xmission.com>
	<CALCETrUaubASZyeoNZcYxn5-GJO68=Ng=GYmas7K_OBsjM7f0Q@mail.gmail.com>
Date: Mon, 07 Oct 2013 15:25:17 -0700
In-Reply-To: <CALCETrUaubASZyeoNZcYxn5-GJO68=Ng=GYmas7K_OBsjM7f0Q@mail.gmail.com>
	(Andy Lutomirski's message of "Mon, 7 Oct 2013 17:53:13 +0100")
Message-ID: <87d2ngyb02.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+u3fvQPXbVUQOudS+qJO2R53yuiHLy54w=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1096]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
Subject: Re: [RFC][PATCH 4/3] vfs: Allow rmdir to remove mounts in all but the current mount namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> On Mon, Oct 7, 2013 at 7:55 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> "Serge E. Hallyn" <serge@hallyn.com> writes:
>>
>>> Quoting Eric W. Biederman (ebiederm@xmission.com):
>>>>
>>>> Programs have been known to test for empty directories by attempting
>>>> to remove them.  To keep from violating the principle of least
>>>> surprise don't let directories the caller can see with someting
>>>> mounted on them be deleted.
>>>
>>> Do you think we should do the same thing for over-mounted file at
>>> vfs_unlink()?
>>
>> We easily could.
>>
>> The point of the patch is to just preserve the directory is empty don't
>> allow rmdir to succeed semantics, and as typically we can see something
>> in the directory because of the mount it doesn't make sense for rmdir to
>> succeed.
>>
>> unlink doesn't have any occassions when the permissions are sufficient
>> to remove a directory where it will fail.  So I don't see the point of
>> doing this for anything except directories.
>>
>> Except for possibly the oddball rmdir semantics mentioned I don't think
>> this patch should be part of anyone's correctness analysis.
>>
>>
>>
>> It is easiest to see that this series of changes is semantically safe if
>> we are safe to run unprivileged code in a mount namespace where root has
>> locally unmounted every mount point.
>>
>> We do have the restriction that in a user namespace we can't unmount
>> anything root was mounted outside the user namespace.  Which combined
>> with the above patch would be roughly equivalent to todays mount
>> restrictions for the common case.  Unfortunately being only roughly
>> equivalent the analysis gets very complicated, and complicated reasoning
>> usually means invalid reasoning.
>>
>>
>> So if we can feel safe just depending on the parent directory
>> permissions (which are not hidden by a mount) protecting our mount
>> points, I feel much better about this patchset.
>>
>
> I feel safe about this (in the safe-against-attack sense, not
> necessary the safe-against-confused-users sense) because the whole
> point of preventing unmount of things that were mounted by root is to
> prevent untrusted users from seeing what's under the mount.  But rmdir
> and unlink don't let you see what was under the mount because they
> remove it.

My premise is that the directory permissions of the directory that
contains the mountpoint are already restrictive enough that it safe to
rely on them for permission to unlink and thus unmount.

I believe my premise is correct however I am human and make mistakes.

As far as I can tell a world writable / or /dev has a lot of other potential
issues and similarly with other directories where we put mount points,
so people just won't create those directories with bad permissions.

I am reitterating just so that what I depend upon is clear and if anyone
knows a counter example they can tell me.

I think by preventing rmdir (when the mount is in the same mount
namespace) and allowing rename and unlink (that do not unlink a
directory) we present a minimal surprise to users.

> (Hmm.  I wonder if rename on a mountpoint could work.  I've wanted
> this on occasion.)

With this set of patches rename on a mountpoint is supported.  That will
break /etc/mtab but in the cases where it really matters renaming a
mount point will break other things.  Which makes in most cases renaming 
a mount point a case of don't do that then, while still being well
defined for the cases where it is not a problem.

Eric

