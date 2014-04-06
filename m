Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbaDFRjs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 13:39:48 -0400
Received: from smtp1.ngi.it ([88.149.128.112]:34712 "EHLO smtp1.ngi.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754407AbaDFRjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 13:39:44 -0400
Message-ID: <53419174.7030004@katamail.com>
Date: Sun, 06 Apr 2014 19:40:04 +0200
From: Michele Ballabio <barra_cuda@katamail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>,
        linux-kernel@vger.kernel.org
CC: fweisbec@gmail.com, mingo@kernel.org, peterz@infradead.org
Subject: Re: Bisected KVM hang on x86-32 between v3.12 and v3.13
References: <5341707F.5000406@katamail.com> <5341784E.1020008@gmx.de>
In-Reply-To: <5341784E.1020008@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 17:52, Toralf Förster wrote:
>> > Reverting either one of them solves the problem reported with kvm,
>> > but revert is probably not the correct answer.
>> > 
>> > I wonder if the solution is as simple as this:
>> > 
>> > --->8---
>> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> > index 0af5250..f3b985d 100644
>> > --- a/arch/x86/Kconfig
>> > +++ b/arch/x86/Kconfig
>> > @@ -126,6 +126,7 @@ config X86
>> >  	select RTC_LIB
>> >  	select HAVE_DEBUG_STACKOVERFLOW
>> >  	select HAVE_IRQ_EXIT_ON_IRQ_STACK if X86_64
>> > +	select HAVE_IRQ_EXIT_ON_IRQ_STACK if X86_32
>> >  	select HAVE_CC_STACKPROTECTOR
>> > 
>> >  config INSTRUCTION_DECODER
>> > ---8<---
>> > 
> applied both to 3.13.9 and 3.14.0 - issue does not happened any longer
> 
> Thanks !

You're welcome, but I'm not sure it's bug-free, I've only glanced at the
code. Let's hear what other people think.

> P.S.. 'By rebasing the "sched/core" branch on "master" before the 
> merge and going on with the bisection'
> 
> Probably off-topic but I'm really interested what did you do in 
> detail ? I'm asking b/c using git for my own and to bisect a remote 
> tree, but I'm not too familiar in bisecting bugs of this kind.

Let's say bisection blames the merge commit 'M' as the first bad
commit:

R---S---T---P---X---Y---Z---M
             \             /
              A---B---C---'

First, let's search for the merge base P:
  git merge-base Z C

Now: we know there are at least 2 patches (one on both sides of the
merge) that are responsible for the regression.
One is either X, Y or Z; the other is either A, B or C.

To find the first one (between X, Y and Z), we can rebase Z on top of
C, either with

  git rebase C Z

or with
  git format-patch Z ^C
  git am 00*
(It's almost the same thing, sometimes you might want to do this to
edit out some patches without using git bisect --interactive).

The result should be:

 P---X---Y---Z---M
  \             /
   A---B---C---'
            \
             X'---Y'---Z'

At this point
  git diff M Y'
should show nothing.

Now we can further our bisection:
  git bisect start Z' C
... should give us the first patch to blame: let's say it's Y'.

Now we search for the other one: the sequence I used is

# We know the other guilty commit is A, B or C
  git bisect start C P
# We will be brought on commit B.
# We know the regression triggers only with Y, so we merge with it
  git merge --no-commit Y
# The result will be something like this:
 P---X---Y---Z---M
  \       \     /
   A---B---N   /
        \     /
         C---'
          \
           X'---Y'---Z'
# Where N is a merge, but it's not a commit.
# 1st compile, install, reboot, test
# We are about to search another commit to test, so let's remove the
# temporary changes of the previous test
  git reset --hard
# What is the result of the 1st test?
  git bisect good|bad
# Here is another iteration
  git merge --no-commit Y
# 2nd compile, install, reboot, test

... and so on. Of course, there are some variations: if Y does not
depend on X, instead of a merge we could do:
  git cherry-pick --no-commit Y

In this case I used a merge because it was easier, and actually I
didn't merge _exactly_ with the blamed commit, but with the last
commit before the merge M, i.e. Z (I assumed it would be better
this way).

> Furthermore probably worth an own section in one of the TODO's ?

I think this (a regression blamed on a merge) is quite unusual,
and as such it could be useful on the man page of git-bisect,
but it should be written better and shorter than what I did
here.
