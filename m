Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab3EHDsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 23:48:07 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:55347 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab3EHDsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 23:48:06 -0400
MIME-Version: 1.0
In-Reply-To: <20130508031758.GT28721@atomide.com>
References: <1367947574-2934383-1-git-send-email-arnd@arndb.de>
	<1367947574-2934383-5-git-send-email-arnd@arndb.de>
	<20130507231925.GR28721@atomide.com>
	<CA+55aFxHZSYV3UZMf+ezADX5z2psLm5a9Wpp6qcDQho7n2J6SA@mail.gmail.com>
	<20130508031758.GT28721@atomide.com>
Date: Tue, 7 May 2013 20:48:05 -0700
X-Google-Sender-Auth: TJ3f8b88__YYOEE4uytu_gaEznw
Message-ID: <CA+55aFxsQSrRxGDjvFW84ezYj4PZPX=hSpsyNG-AqewbJ7X4Bw@mail.gmail.com>
Subject: Re: [GIT PULL 4/5] ARM: arm-soc: late cleanups
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tony Lindgren <tony@atomide.com>
Cc: ARM SoC <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 7, 2013 at 8:17 PM, Tony Lindgren <tony@atomide.com> wrote:
>
> Yes then we patched it on Sunday, and Arnd merged it into his branch.
> But then hose lines disappeared again for the third time :)

Yes, but that's because it's entirely pointless to "fix" things in the
wrong branch, especially after a back-merge.

So what ended up happening is that when I then pulled the next time,
you had random back-merges in your ARM tree (well, not you personally,
but Arnd), and as a result the later merge didn't have just one merge
base, it actually had *five* separate merge bases: all independent
common ancestors of the two branches being merged (*).

And *some* of the common ancestors had the lines, some didn't. And my
mainline didn't. So git merge decides that "hey, those lines used to
exist in the common ancestor of this new merge, but they don't exist
in mainline, and they still exist in the thing getting merged"

What do you think happens? Think about it.

The only reasonable thing to do (and git always does reasonable
things) is to say "oh, mainline must have *removed* those lines".

Git goes "The branch I'm merging clearly didn't do anything at all to
the lines: they used to exist back in the shared history, and they
still exist in the exact same form in the branch I'm merging." So they
stay removed in mainline.

(Ok, so that's anthropomorphising git to a fairly extreme point, but
it's actually pretty close to being the technical truth. As far as the
merge was concerned, Arnd's branch didn't really add those lines at
all, because they already existed when his branch started. The fact
that they went away and came back again is totally immaterial).

And this, btw, is just one more reason why back-merges are not a good
idea. It makes it basically impossible to say "so did you add or
remove something"? When you have multiple independent points in
history that are common to both branches, it's fundamentally ambiguous
whether merging things adds something that went away and came back
again in that shared history.

Criss-crossing merges are a horrible horrible idea, and the only sane
way to not criss-cross is to say "avoid back-merging from upstream".

Side note: these kinds of issues are unusual. You really have to do
something special to trigger this, but this is not unique. We've had
similar things happen in the past, and you don't actually need a
mis-merge for it to happen. You do need criss-crossing merges, though,
because that's how you get "oh, we have N different commits that are
all shared points in history, but are not ancestors of each other" (ie
what git calls "merge bases").

And no, this kind of thing does not happen every time you have
multiple merge bases. But multiple merge bases, together with code
that has gone back and forth on some issue, really is a very very bad
idea. In this case, the mis-merge was just the thing that triggered
"code went back-and-forth", but similar things can happen when you
have code that gets reverted and then re-done, and you have multiple
merge bases (one of which has the revert, while one has the re-doing
of it..)

The good news is that this is very rarely a real problem. The bad news
is that it's such a rare problem that people aren't even aware of it
as a problem (and reasonably *shouldn't* be aware of it as a
problem!). So when it happens, people get confused, because they've
never seen it before, and they get even more confused when their
"solution" (back-merge from upstream, fix it there, ask upstream to
pull the fix) doesn't actually fix anything, because you just end up
in the same situation *again*..

                   Linus

(*) Why five merge bases? Look at what my merge of those late cleanups
actually had to contend with:

    git merge-base --all 1bf25e78af31^ 1bf25e78af31^2

and notice how you get five different commits. They are all commits
that are common to *both* parents of that merge. You can try do

    gitk 1bf25e78af31^...1bf25e78af31^2

and try to figure those kinds of things out by hand. You can't, unless
you're superhuman. Because the history is a f*cking mess due to all
the back-merges. Yeah, yeah, none of them are pulling from "me", but
all of them are pulling from random other branches that people had
asked me to pull earlier, so they were basically mixing up history.

The ARM history has gotten much much better, but it's full of these
kinds of incestuous merges. The pull requests I get are not truly
independent development, although especially the early pull requests
are much less tightly coupled than they used to be.
