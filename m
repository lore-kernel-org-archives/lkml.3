Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab3JJLoG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 07:44:06 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:44952 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab3JJLoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 07:44:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Andy Lutomirski <luto@amacapital.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	<87li281wx6.fsf_-_@xmission.com> <87a9ioo37a.fsf_-_@xmission.com>
	<20131007043919.GB10284@mail.hallyn.com> <87vc191sf2.fsf@xmission.com>
	<CALCETrUaubASZyeoNZcYxn5-GJO68=Ng=GYmas7K_OBsjM7f0Q@mail.gmail.com>
	<87d2ngyb02.fsf@xmission.com>
	<20131008160601.GJ14242@tucsk.piliscsaba.szeredi.hu>
	<CALCETrWw=htmgxqq=RQztdJQ-a8c3860vmJh9Ni=Hhs0TkO3YA@mail.gmail.com>
	<20131008161135.GK14242@tucsk.piliscsaba.szeredi.hu>
	<87li23trll.fsf@tw-ebiederman.twitter.com>
	<CAJfpegv+h7xh_2e-X7is9dq1Fp06A0eKwsyWFMPX=azbbDCX5Q@mail.gmail.com>
Date: Thu, 10 Oct 2013 04:43:51 -0700
In-Reply-To: <CAJfpegv+h7xh_2e-X7is9dq1Fp06A0eKwsyWFMPX=azbbDCX5Q@mail.gmail.com>
	(Miklos Szeredi's message of "Thu, 10 Oct 2013 12:02:24 +0200")
Message-ID: <87vc15mjuw.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/2gdYHs5kv3NJP2ni6Zucg9YyRJryr+sw=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0083]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Miklos Szeredi <miklos@szeredi.hu>
X-Spam-Relay-Country: 
Subject: Re: [RFC][PATCH 4/3] vfs: Allow rmdir to remove mounts in all but the current mount namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> On Tue, Oct 8, 2013 at 10:50 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>
>> If we are going to fix the VFS deficiency we have to let these changes
>> happen in other mount namespaces.  To make that safe it has to be
>> sufficient to rely on the directory permissions and the conditions that
>> ensure that the directory permissions are sufficient.
>
> Yes.
>
>> So I find it far safer to allow as much as possible even in the local
>> mount namespace so we can actually see if there are problems with
>> relying on the directory permissions.
>
> But it's not safer in terms of breaking legacy environments, which are
> single namespace, usually.
>
> I see it this way: the current behavior (blocking unlink/rename if
> mounted) may not be nice, but it's expected.  But once we have
> multiple namespaces it becomes problematic.   Just like  network
> filesystems where we cannot prevent unlink on another host just
> because it's mounted on this.  So we have to have some way of dealing
> with this.
>
> Is it worth changing behavor in the "current namespace" case too?  It
> has advantages, but it's not absolutely necessary and there are
> unknown dangers.  But if we disable it for rmdir() then what's the
> point in enabling it for unlink()?  Directory mounts far outnumber
> non-directory ones, so the additional testing is minimal, but the
> holes left are probably just as real.
>
> And there's rename().  We have a real security hole in fusermount by
> allowing it in the local namespace.  I don't think changing the
> behavior of rename() in the local namespace is  important enough to
> risk such problems.  And as Andy pointed out, we can just have an
> option to turn it on and that's that.

I have been weighing the pros and the cons of this.

At this point the most practical path I can see is to block unlink,
rename, and rmdir if there is a mount in the local namespace.

At the very least that makes very limited additions to what applications
can depend on from the vfs, and even more importantly that can be ready
by 3.13.

Furthermore it removes the nasty need for filesystems to lie to the vfs,
and removes the nasty DOS that non-local mountpoints are.

Miklos if you as the fuse maintainer aren't worried about network
filesystems, and multiple namespaces I won't worry either.  Especially
since modern versions of fuse aren't affected.

I have a implementable looking plan B if we really need it of creating
ghost dentries for mounts to ride on if their underlying dentry gets
renamed or unlinked.  And I don't see this removing the possibility of
implementing that plan B.  But ick.  I think deciding we need plan B
would just enough more work that it would kill getting any change made
in a timely fashion.  So I will take my little blue pill and ignore the
possible slings and arrows of outrageous fortune, and see what happens.

Eric
