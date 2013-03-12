Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902Ab3CLRNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 13:13:24 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:39150 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab3CLRNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 13:13:22 -0400
MIME-Version: 1.0
In-Reply-To: <20130312041641.GE18595@thunk.org>
References: <20130312100950.e45ef0e721492ff0d5fd7c8d@canb.auug.org.au>
	<alpine.LRH.2.02.1303121510270.25612@tundra.namei.org>
	<20130312041641.GE18595@thunk.org>
Date: Tue, 12 Mar 2013 10:13:21 -0700
X-Google-Sender-Auth: J2NAV1Qi3LqJNrnDGhTe-I98UyY
Message-ID: <CA+55aFzFLDcN-1GKae6Xqrns59K1xOD_HPzuv2Lv1__fZpqFMw@mail.gmail.com>
Subject: Re: linux-next: unneeded merge in the security tree
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Theodore Ts'o" <tytso@mit.edu>, James Morris <jmorris@namei.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Git Mailing List <git@vger.kernel.org>,
        Junio C Hamano <gitster@pobox.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added Junio and git to the recipients, and leaving a lot of stuff
quoted due to that... ]

On Mon, Mar 11, 2013 at 9:16 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Mar 12, 2013 at 03:10:53PM +1100, James Morris wrote:
>> On Tue, 12 Mar 2013, Stephen Rothwell wrote:
>> > The top commit in the security tree today is a merge of v3.9-rc2.  This
>> > is a completely unnecessary merge as the tree before the merge was a
>> > subset of v3.9-rc1 and so if the merge had been done using anything but
>> > the tag, it would have just been a fast forward.  I know that this is now
>> > deliberate behaviour on git's behalf, but isn't there some way we can
>> > make this easier on maintainers who are just really just trying to pick a
>> > new starting point for their trees after a release?  (at least I assume
>> > that is what James was trying to do)
>>
>> Yes, and I was merging to a tag as required by Linus.

Now, quite frankly, I'd prefer people not merge -rc tags either, just
real releases. -rc tags are certainly *much* better than merging
random daily stuff, but the basic rule should be "don't back-merge AT
ALL" rather than "back-merge tags".

That said, you didn't really want a merge at all, you just wanted to
sync up and start development. Which is different (but should still
prefer real releases, and only use rc tags if it's fixing stuff that
happened in the merge window - which may be the case here).

> Why not just force the head of the security tree to be v3.9-rc2?  Then
> you don't end up creating a completely unnecessary merge commit, and
> users who were at the previous head of the security tree will
> experience a fast forward when they pull your new head.

So I think that may *technically* be the right solution, but it's a
rather annoying UI issue, partly because you can't just do it in a
single operation (you can't do a pull of the tag to both fetch and
fast-forward it), but partly because "git reset --hard" is also an
operation that can lose history, so it's something that people should
be nervous about, and shouldn't use as some kind of standard "let's
just fast-forward to Linus' tree" thing.

At the same time, it's absolutely true that when *I* pull a signed tag
from a downstream developer, I don't want a fast-forward, because then
I'd lose the signature. So when a maintainer pulls a submaintainer
tree, you want the signature to come upstream, but when a
submaintainer wants to just sync up with upstream, you don't want to
generate the pointless signed merge commit, because the signature is
already upstream because it's a public tag. So gthe behavior of "git
pull" is fundamentally ambiguous.

But git doesn't know the difference between "official public upstream
tag" and "signed tag used to verify the pull request".

I'm adding the git list just to get this issue out there and see if
people have any ideas. I've got a couple of workarounds, but they
aren't wonderful..

One is simple:

    git config alias.sync="pull --ff-only"

which works fine, but forces submaintainers to be careful when doing
things like this, and using a special command to do back-merges.

And maybe that's the right thing to do? Back-merges *are* special,
after all. But the above alias is particularly fragile, in that
there's both "pull" and "merge" that people want to use this for, and
it doesn't really handle both. And --ff-only will obviously fail if
you actually have some work in your tree, and want to do a real merge,
so then you have to do that differently. So I'm mentioning this as a
better model than "git reset", but not really a *solution*.

That said, the fact that "--ff-only" errors out if you have local
development may actually be a big bonus - because you really shouldn't
do merges at all if you have local development, but syncing up to my
tree if you don't have it (and are going to start it) may be something
reasonable.

Now, the other approach - and perhaps preferable, but requiring actual
changes to git itself - is to do the non-fast-forward merge *only* for
FETCH_HEAD, which already has magic semantics in other ways. So if
somebody does

    git fetch linus
    git merge v3.8

to sync with me, they would *not* get a merge commit with a signature,
just a fast-forward. But if you do

    git pull linus v3.8

or a

    git fetch linus v3.8
    git merge FETCH_HEAD

it would look like a "maintainer merge" and stash the signature in the
merge commit rather than fast-forward. It would probably work in
practice.

The final approach might be to make it like the "merge summary" and
simply make it configurable _and_ have a command line flag for it,
defaulting to our current behavior or to the above suggested "default
on for FETCH_HEAD, off for anything else".

Hmm?

            Linus
