Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab3JJKCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 06:02:30 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:38438 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299Ab3JJKCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 06:02:25 -0400
MIME-Version: 1.0
X-Originating-IP: [86.59.245.170]
In-Reply-To: <87li23trll.fsf@tw-ebiederman.twitter.com>
References: <8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	<87li281wx6.fsf_-_@xmission.com>
	<87a9ioo37a.fsf_-_@xmission.com>
	<20131007043919.GB10284@mail.hallyn.com>
	<87vc191sf2.fsf@xmission.com>
	<CALCETrUaubASZyeoNZcYxn5-GJO68=Ng=GYmas7K_OBsjM7f0Q@mail.gmail.com>
	<87d2ngyb02.fsf@xmission.com>
	<20131008160601.GJ14242@tucsk.piliscsaba.szeredi.hu>
	<CALCETrWw=htmgxqq=RQztdJQ-a8c3860vmJh9Ni=Hhs0TkO3YA@mail.gmail.com>
	<20131008161135.GK14242@tucsk.piliscsaba.szeredi.hu>
	<87li23trll.fsf@tw-ebiederman.twitter.com>
Date: Thu, 10 Oct 2013 12:02:24 +0200
Message-ID: <CAJfpegv+h7xh_2e-X7is9dq1Fp06A0eKwsyWFMPX=azbbDCX5Q@mail.gmail.com>
Subject: Re: [RFC][PATCH 4/3] vfs: Allow rmdir to remove mounts in all but the
 current mount namespace
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 8, 2013 at 10:50 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:

> If we are going to fix the VFS deficiency we have to let these changes
> happen in other mount namespaces.  To make that safe it has to be
> sufficient to rely on the directory permissions and the conditions that
> ensure that the directory permissions are sufficient.

Yes.

> So I find it far safer to allow as much as possible even in the local
> mount namespace so we can actually see if there are problems with
> relying on the directory permissions.

But it's not safer in terms of breaking legacy environments, which are
single namespace, usually.

I see it this way: the current behavior (blocking unlink/rename if
mounted) may not be nice, but it's expected.  But once we have
multiple namespaces it becomes problematic.   Just like  network
filesystems where we cannot prevent unlink on another host just
because it's mounted on this.  So we have to have some way of dealing
with this.

Is it worth changing behavor in the "current namespace" case too?  It
has advantages, but it's not absolutely necessary and there are
unknown dangers.  But if we disable it for rmdir() then what's the
point in enabling it for unlink()?  Directory mounts far outnumber
non-directory ones, so the additional testing is minimal, but the
holes left are probably just as real.

And there's rename().  We have a real security hole in fusermount by
allowing it in the local namespace.  I don't think changing the
behavior of rename() in the local namespace is  important enough to
risk such problems.  And as Andy pointed out, we can just have an
option to turn it on and that's that.

Thanks,
Miklos
