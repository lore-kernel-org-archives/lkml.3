Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbaJLPur (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 11:50:47 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:52111 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbaJLPum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 11:50:42 -0400
MIME-Version: 1.0
In-Reply-To: <18599898.QtEUVscf6i@sifl>
References: <alpine.LRH.2.11.1410101913460.13164@namei.org>
	<CA+55aFwGpnBgSeyjKQuwKwSpccTHvQwPJGEXfw2wx9LJ-kafTg@mail.gmail.com>
	<18599898.QtEUVscf6i@sifl>
Date: Sun, 12 Oct 2014 11:50:41 -0400
X-Google-Sender-Auth: IouBJE7GKEP-xY9aQ21foGBMqTE
Message-ID: <CA+55aFwwB1uUnUKdQq28T-3AgVcwPSJR27HnTDnrCyD4xowUOQ@mail.gmail.com>
Subject: Re: [GIT] Security subsystem upate for 3.18
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul Moore <pmoore@redhat.com>
Cc: James Morris <jmorris@namei.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2014 at 11:04 AM, Paul Moore <pmoore@redhat.com> wrote:
>
> Nothing other than that a merge was done.  To be honest I wasn't sure any
> additional comment was needed since it was a clean merge without any conflict;
> my process has only been to add commentary when there were conflicts that
> needed to be resolved by hand.

So in general, any merge should always have a reason for the merge, or
a summary of what the merge does.

Now, some reasons are pretty much "implicit" in the merge - when a
maintainer merges a downstream maintainer tree, the "reason" for the
merge is pretty obvious - the maintainer is obviously merging code.
Then, the merge doesn't need an explicit reason, but a summary of the
code being merged, so that the history shows at a glance what is going
on.

Now, "back-merges" - ie a submaintainer merging a tree from a
top-level maintainer - causes various problems. The most obvious is
that there is now no longer a single starting point for the
development branch - there's both the original point you started
developing, and there's the newly merged point. And because there is
no clear-cut starting point, you can't get a sane "diff" of the
developer tree.

(Well, you can, but it involves more than diffing two points - you
basically have to do another merge, and then looking at the result of
*that* merge, because "git merge" understands multiple base trees and
does some clever recursive merging to make it all DTRT automatically).

The end result of that is that the basic assumption should always be
that merges only go one way: a maintainer merges the submaintainer
tree. Anything else causes problems.

Now, that said, there *are* valid reasons for a submaintainer doing a
back merge and merging upstream.  But they should be seen as being
exceptional events, and they really should be explained in the merge
commit message. If you don't have a good explanation for it, you
shouldn't do it. It's really that simple.

Examples of *good* reasons to do a back-merge:

 - the code was developed on a really ancient tree, and is *so*
out-of-date that not only are there conflicts, they are complicated
and might be more than simple data conflicts - semantic changes etc
that you as a submaintainer might be better off handlng the merge of,
since you presumably know the code you are merging intimately.

   Note: you may know your code intimately, but maybe you don't know
the other changes intimately, and maybe the top-level maintainer is
actually better at merging (possibly because that maintainer does 10+
merges a day at times). So "a few conflicts" is not necessarily a good
reason in itself, but there are certainly cases where things just get
so ugly that "break the rules" is a very valid approach.

 - you actively need infrastructure from newer versions, so you need
to merge an upstream kernel for further development.

   Even this is often questionable, but it's one of the best reasons
to do back-merges. However, if so, that back-merge should very much
spell out the exact reason why the merge was needed (not just "needed
upstream features" in general, but what particular features were
needed etc).

 - and hey, as with so many (all) kernel development rules, I don't
actually want people to think that the rules are completely hard.
Mistakes happen, shit happens, things go wrong, whatever.

So the reason I spoke out was that there were not only two unnecessary
merges in there, they actually did cause problems. Not *huge*
problems, but the diffstat that James had doesn't match what I get
after the merge, and it's annoying when I cannot do the full
verification of "I got what the maintainer clearly meant to send" by
comparing diffstats etc.

And as mentioned, the fact that a plain "git diff" doesn't work can be
worked around - some submaintainers do a full test-merge,. generate
the diff from that (and tell me about any conflicts they encountered)
and then just ask me to pull (and do the merge again). And I certainly
don't mind it at all when submaintainers do that, but with clean
workflows that simply isn't even *needed*.

So it's not a disaster, and pulled and pushed out already, and
occasional back-merges are fine. But I definitely would want to
minimize them, and just on principle, I think all merges should have
descriptive commit messages, the same way regular code changes should
have them (in fact, it can arguably be *more* important for a merge
commit, because if bisection ends up pointing to a merge, you don't
have the same kind of obvious "this is the code that changed" that you
have for a regular commit - so I think having good merge explanations
just makes life less frustrating when things go wrong).

                     Linus
