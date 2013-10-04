Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab3JDXUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 19:20:13 -0400
Received: from mail-vb0-f45.google.com ([209.85.212.45]:47306 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab3JDXUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 19:20:11 -0400
MIME-Version: 1.0
In-Reply-To: <87li281wx6.fsf_-_@xmission.com>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
	<87a9kkax0j.fsf@xmission.com>
	<CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
	<8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	<87li281wx6.fsf_-_@xmission.com>
Date: Fri, 4 Oct 2013 16:20:10 -0700
X-Google-Sender-Auth: HBglA1DIS-4N6SLhGFYV1zHfnPI
Message-ID: <CA+55aFyCDyGqqbueJtZSUh5JeMcGONy+nW=RXiiouneXuxQ9aA@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/3] vfs: Detach mounts on unlink.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Serge E. Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 4, 2013 at 3:41 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> After thinking about it removing the restrictions on mount points
> appears safe, because it is just plain dumb to have a mount point
> in a directory that is not restricted to root only modifications.
>
> This is a change in user visible semantics, so I want to be very careful
> about this.  Are there any reasons to not make this change?

At least one worry: people are very used to 'rmdir()' not removing
empty directories, and I've written code myself that just does an
'rmdir()' without worrying about it. I think git has code like "remove
file, then try to remove directory file is in, and recurse until it
fails or you hit the top of tree". And it all depends on knowing that
rmdir() is harmless, and returns the appropriate error when the
directory isn't empty.

And you're now changing that. If it's a mount-point, the rmdir just
succeeds, afaik.

Does anybody care? I dunno. But it looks like a _big_ semantic change.

That said, I like the _concept_ of being able to remove a mount-point
and the mount just goes away. But I do think that for sanity sake, it
should have something like "if one of the mounts is in the current
namespace, return -EBUSY". IOW, the patch-series would make the VFS
layer _able_ to remove mount-points, but a normal rmdir() when
something is mounted in that namespace would fail in order to give
legacy behavior.

Hmm?

                Linus
