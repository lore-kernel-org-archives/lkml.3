Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab3JGQxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 12:53:42 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:54391 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244Ab3JGQxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 12:53:34 -0400
MIME-Version: 1.0
In-Reply-To: <87vc191sf2.fsf@xmission.com>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
 <87a9kkax0j.fsf@xmission.com> <CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
 <8761v7h2pt.fsf@tw-ebiederman.twitter.com> <CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
 <87li281wx6.fsf_-_@xmission.com> <87a9ioo37a.fsf_-_@xmission.com>
 <20131007043919.GB10284@mail.hallyn.com> <87vc191sf2.fsf@xmission.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 7 Oct 2013 17:53:13 +0100
Message-ID: <CALCETrUaubASZyeoNZcYxn5-GJO68=Ng=GYmas7K_OBsjM7f0Q@mail.gmail.com>
Subject: Re: [RFC][PATCH 4/3] vfs: Allow rmdir to remove mounts in all but the
 current mount namespace
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Miklos Szeredi <miklos@szeredi.hu>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 7, 2013 at 7:55 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> "Serge E. Hallyn" <serge@hallyn.com> writes:
>
>> Quoting Eric W. Biederman (ebiederm@xmission.com):
>>>
>>> Programs have been known to test for empty directories by attempting
>>> to remove them.  To keep from violating the principle of least
>>> surprise don't let directories the caller can see with someting
>>> mounted on them be deleted.
>>
>> Do you think we should do the same thing for over-mounted file at
>> vfs_unlink()?
>
> We easily could.
>
> The point of the patch is to just preserve the directory is empty don't
> allow rmdir to succeed semantics, and as typically we can see something
> in the directory because of the mount it doesn't make sense for rmdir to
> succeed.
>
> unlink doesn't have any occassions when the permissions are sufficient
> to remove a directory where it will fail.  So I don't see the point of
> doing this for anything except directories.
>
> Except for possibly the oddball rmdir semantics mentioned I don't think
> this patch should be part of anyone's correctness analysis.
>
>
>
> It is easiest to see that this series of changes is semantically safe if
> we are safe to run unprivileged code in a mount namespace where root has
> locally unmounted every mount point.
>
> We do have the restriction that in a user namespace we can't unmount
> anything root was mounted outside the user namespace.  Which combined
> with the above patch would be roughly equivalent to todays mount
> restrictions for the common case.  Unfortunately being only roughly
> equivalent the analysis gets very complicated, and complicated reasoning
> usually means invalid reasoning.
>
>
> So if we can feel safe just depending on the parent directory
> permissions (which are not hidden by a mount) protecting our mount
> points, I feel much better about this patchset.
>

I feel safe about this (in the safe-against-attack sense, not
necessary the safe-against-confused-users sense) because the whole
point of preventing unmount of things that were mounted by root is to
prevent untrusted users from seeing what's under the mount.  But rmdir
and unlink don't let you see what was under the mount because they
remove it.

(Hmm.  I wonder if rename on a mountpoint could work.  I've wanted
this on occasion.)

--Andy
