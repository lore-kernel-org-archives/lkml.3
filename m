Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab3CBQ27 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 11:28:59 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:56331 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab3CBQ26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 11:28:58 -0500
MIME-Version: 1.0
In-Reply-To: <5131D2F0.2010705@imgtec.com>
References: <5130DD94.2060408@imgtec.com>
	<CA+55aFw9qvUdrtEk_83-gEjZMTceONk=AuVsHuTtqOj=jpVPQg@mail.gmail.com>
	<5130F978.9040604@imgtec.com>
	<5131D2F0.2010705@imgtec.com>
Date: Sat, 2 Mar 2013 08:28:56 -0800
X-Google-Sender-Auth: m0sUW406RpZS0M9LQiPJ443Ds40
Message-ID: <CA+55aFx1wKChQmAWgQR0iOdKr0bhLn7RLsZHj5ZuVVOtk8FXMw@mail.gmail.com>
Subject: Re: [GIT PULL] late arch/metag fixes for v3.9-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: Arnd <arnd@arndb.de>, linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 2, 2013 at 2:22 AM, James Hogan <james.hogan@imgtec.com> wrote:
>
> Okay, I've rebased the arch/metag tree onto mainline to make all the
> back-merges unnecessary and applied those simple fixes into "Build
> infrastructure" and "Various other headers" commits (additionally
> trivially removing ARCH_NO_VIRT_TO_BUS which is also now unnecessary).

No, this is *exactly* the wrong thing to do.

You have now based all the new metag stuff on some random potentially
completely broken commit in the middle of a merge window. Which is
exactly what I don't ever want to see, and which is one (of several)
reasons I also absolutely do not want to see back-merges - not to
"next" trees, and not to my "random commit of the day" tree.

Basically, I do not want peoples development trees to worry about some
random crazy merge-window tree of the day. You should always pick a
good starting point that makes sense (where "makes sense" is very much
about "it's stable and well known" and just do  your own thing. What
other people do should simply not concern you over-much. You are the
architecture maintainer, and your job is not integration, it's to make
sure that *your* work is as stable and unsurprising as possible.

Then, when you ask me to pull something that is stable, works, and has
been tested, THEN AND ONLY THEN do we start worrying about merge
issues. And in particular, you do not handle those merge issues
yourself, although it can be very helpful if you look into them and
describe the issues to me, and maybe you can even do an *example*
merge (which I won't actually use).

Why do I not want you making merges? Let me count the ways:

 - I'm usually a day or two behind in my merge queue anyway, partly
because I get tons of pull requests in a short while and I just want
to get a feel for what's going on, and partly because I tend to do
pulls in waves of "ok, I'm going filesystems now, then I'll look at
drivers".

 - I do a *lot* of merges. I try to make them look good, and have
*explanations* in them. And if a merge conflict happens, I want to
know about them.

 - I want to have a gut feel about what goes into the tree when. I
know, for example, that "oops, we had a bug in ext4 that got
discovered only after the merge, and for a while there it didn't work
well with larger disks". When people complain, my job is often to have
that high-level view of "ok, you're hitting this known bug". If people
do back-merges, that basically pulls in my tree at some random point
that I'm not even aware of, and now you mixed up *other* peoples bugs
into your tree.

 - and somewhat most importantly (for me personally): backmerges make
history messy, and it can be a huge pain for me when I do merge
conflict resolution, or when other people do bisects etc. It's *much*
nicer in many ways (visually, and for bisect reasons) to try to have
as much independent development as possible.

Now, rebasing fixes some of this. It fixes the *visual* messiness of
the history, and it does keep the commits together. That helps at one
level. But bisection on top of random points doesn't solve the other
problems: you've now messed up your history with random development
history of other people, and your new commits - instead of being on
top of some stable version that we hopefully know the bugs for - will
now be somewhere in the middle of the whole development mess, so if
people start bisecting something completely independent, it's all
right there in the middle.

Rebasing has other deeper problems too, like the fact that your tree
is no longer something that other people can depend on. That's not a
big issue for a new architecture, but it's a big issue going forward.
Which is why rebasing is generally even *worse* than back-merges (but
both are basically big "just don't do that").

So the rule for both rebasing and back-merging should be:

 - you should have damn good reasons for it, and you should document them

 - you should basically *never* rebase or back-merge random commits in
the merge window. That's *NEVER* a good idea. If you have a conflict,
ignore it. Explain it to me when you ask me to pull, but it is *my*
job to know "ok, I've pulled fiftynine different trees, and trees X
and Y end up conflicting, and this is how it got resolved". Seriously.

 - if you have some really long-lived development tree, and you want
to back-merge just to not be *too* far away, back-merge to actual
releases. Don't pull my master branch. Say "git merge v3.8" or
something like that, and then you write a good merge message that
talks about *why* you wanted to update to a new release.

See why I hate rebasing and back-merges so much?

Right now, I think your best option is to rebase just your own commits
on top of v3.8, and then ask me to pull the result, with explanations
of what the conflicts will be. And while I much prefer explanations
(and also a general over-view, just so that I can put it in the commit
message), I actually even prefer unexplained merge conflicts that I
have to resolve over the "I did a back-merge at some random point
because I was trying to be helpful, or because I wanted to use a new
and untested feature that isn't even in a release kernel yet".

And yes, there are always exceptions. I do end up taking back-merges,
and rebasing does happen, and I dislike it, but I try to not have
black-and-white rules either. Sometimes it needs to be done.

But I do *not* take new trees that do bad things. If I take a new
architecture, I want to feel like I'm not just getting the
architecture, but I'm also getting a maintainer that knows about
keeping his history clean and not mixing with the independent work
other people did, or messing up other people by rebasing public
commits etc.

               Linus
