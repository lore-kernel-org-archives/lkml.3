Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759805Ab3CGUds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 15:33:48 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:56035 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411Ab3CGUdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 15:33:47 -0500
MIME-Version: 1.0
In-Reply-To: <20130307193501.GA2802@redhat.com>
References: <20130307021645.GA10173@redhat.com>
	<20130307153052.GA18246@redhat.com>
	<CA+55aFyVZeDswi=M65ULQkGCvJq5vsASLqGCtufH3TcS--MC1Q@mail.gmail.com>
	<20130307193501.GA2802@redhat.com>
Date: Thu, 7 Mar 2013 12:33:46 -0800
X-Google-Sender-Auth: RrHZdjia3EuOQ5XwWFaATJ2X_CM
Message-ID: <CA+55aFwDYocNRjSCJk1PYw0MFy7dpKf1yMMEiePP--=ewQcX6A@mail.gmail.com>
Subject: Re: BUG_ON(nd->inode->i_op->follow_link);
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 11:35 AM, Dave Jones <davej@redhat.com> wrote:
> On Thu, Mar 07, 2013 at 09:30:56AM -0800, Linus Torvalds wrote:
>  >
>  > So I think we should change that BUG_ON() into a
>  >
>  >         if (WARN_ON_ONCE(nd->inode != parent->d_inode))
>  >                 return -ESTALE;
>
> Curiously, the machine wasn't dead after hitting that.
> Oh wait, it locks up that one CPU, leaving the others running right ?
> That would explain it, it's got a few cores..

No, it's simpler than that - we normally don't hold any extra locks
while walking pathnames.

The keyword being *normally*.

When we do things like renames etc, we often have other locks, and
then a BUG_ON() in that place is just deadly. But in your particular
case I think killing the process ends up just doing the right thing.

So a BUG_ON() can happen to do the right thing. In fact, back in the
BKL days it was pretty common, since the exit path could also undo the
BKL. It's just that these days it's not unlikely that we hold some
other lock or whatever, and then BUG_ON() can end up really screwing
things up.

>  > Hmm. Nothing looks all that odd in that trace. Do you have any idea
>  > what the path was? This being trinity, I'm assuming you're doing some
>  > kind of targeted testing. sysfs or proc, perhaps? Or some particular
>  > concurrency test with random system calls/pathnames? Not that I see
>  > how it could happen anyway, but maybe it could give some hint about
>  > what triggered this.
>
> Basically, see the summary of a bunch of bugs I reported to Greg last night
> in sysfs: https://lkml.org/lkml/2013/3/7/21
> It sounds like it's just trinity finding old bugs for the first time,
> though I've not actually tested yet on an older kernel.

If this is fairly repeatable, I really think it would be interesting
to see the names involved. Especially for sysfs, there are a *lot* of
random files that have odd semantics, and it depends on the file. Same
is (to a slightly lesser degree) true of /proc (which does have many
of the same issues, but tends to be more tested just for having been
around for longer - but then proc does have some issues all its own)

So for example, if you can re-create the one in nd_jump_link(), it
would be lovely if you replaced the BUG_ON() with just an if(), and
made it print out the old and the new path dentry names (ok, that
means saving the old path and doing the path_put on it afterwards).

Something like

+    const char *oldname = nd->path.dentry->d_name.name;   /* Yeah,
this remembers the name pointer over the put_path(), not strictly
right */
+    const char *newname = path->dentry->d_name.name;
      ...
-    BUG_ON(nd->inode->i_op->follow_link);
+    if (WARN_ON(nd->inode->i_op->follow_link)) {
+        printk("old=%s new=%d\n", oldname, newname);
+    }

or other..

> I suspect it's the addition of this..
> http://git.codemonkey.org.uk/?p=trinity.git;a=commitdiff;h=fd46c22e967a613de73d7e51a9715717d954ec45
> Which adds a bunch of negative dentry lookups when it hits a mangled pathname.

Yeah, it would have been nicer if we could bisect this to something,
or limit it to the changes in -rc1, but...

      Linus
