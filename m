Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933315Ab3GLPwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 11:52:16 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:44035 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933072Ab3GLPwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 11:52:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAFkjPTm6_FCMpMOCgD+n=72y2xzfTPFKXE+ikBsy6CpDAK58jA@mail.gmail.com>
References: <CAFkjPTnWcVCrDYiNAwWMOa=8yLzpdZKUi+v7oSQqt3DinYp4xA@mail.gmail.com>
	<87fvvktjzg.fsf@linux.vnet.ibm.com>
	<CAFkjPTm6_FCMpMOCgD+n=72y2xzfTPFKXE+ikBsy6CpDAK58jA@mail.gmail.com>
Date: Fri, 12 Jul 2013 08:52:13 -0700
X-Google-Sender-Auth: d9g-XDefAh3mkVHaehjH9KZndlk
Message-ID: <CA+55aFy-S44CR1amnUosVg99sgFk+ekueO=gt04Tbd92VpzXLQ@mail.gmail.com>
Subject: Re: [V9fs-developer] [GIT PULL] 9p changes for 3.11 merge window
 (part 2)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        V9FS Developers <v9fs-developer@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 6:48 AM, Eric Van Hensbergen <ericvh@gmail.com> wrote:
> It's likely my fault.

This is not a "fault".

Duplicate commits happen. It's fine. It's normal, and even expected.
In fact, it's very much something that sometimes happen for *good*
reasons.

Sometimes it's just because the same patch came in two different ways.
And sometimes it's the only sane way to handle certain issues (ie you
have a fix that you want to send to me for 3.10, but you _also_ need
that fix in your development tree, and so you want to apply the fix to
the branch that you are *not* ready to send to me yet).

So occasional duplicate commits is something I *expect* to happen
during any normal development. They aren't necessarily intentional,
but as pointed out above they _can_ be intentional and have perfectly
good reasons.

Now, the important part there is the "occasional". There are very much
occasional reasons why duplicate commits happen, and trying very hard
to not make them happen is counter-productive and bad, and often leads
to much worse problems.

The case when duplicates are a problem is when they aren't
"occasional", and are instead "workflow". At that point, there is
something seriously wrong. If they happen consistently, and happen for
series of commits, that is indicative of something really bad going
on. It might be people rebasing their public trees, for example, and
then you can find both the old and the new version of a rebased
series. THAT kind of thing is a problem, because now the duplicates
aren't occasional patches that happened for natural reasons any more,
now the duplicates are because somebody is doing something that is
actively bad. But even then, it's not the "duplicate" part that is the
problem, the duplicates are really more of a symptom than the deeper
issue.

Similarly, if there is confusion about maintainership, duplicate
patches can happen because two or more people end up taking the same
patch because the feel it's "their" job. And again, when that happens
_occasionally_, that's fine too - there are quite valid gray areas
without clear black-and-white rules about which way a patch should
come in. So again, the occasional duplicate commit with the same patch
is normal, expected, and fine. But again, very obviously, if it isn't
some "occasional" thing, but happens often, that is clearly a huge
problem, and implies that two or more people are fighting over
control.

So don't worry about the occasional duplicates. Yes, they can cause
merge conflicts and be annoying (git will trivially merge true
duplicate patches, but if you then have *other* changes on top of the
duplicates, the two branches won't necessarily merge cleanly), but
again, as long as that is something occasional and rare,. that is not
a problem at all. A certain amount of merge conflict is to be
expected, and I resolve several conflicts each day during the merge
window without ever even mentioning them. Again, it's a problem only
when it happens more than just occasionally.

So worry about other things. Worry about good git maintenance
practices (no rebasing of public trees etc), worry about keeping code
clean and modular so that you don't find cross-maintainership issues
with gray areas of who should handle them very often, and worry about
things like that. But don't worry about the occasional duplicate patch
getting into the tree through two different branches. That really is
perfectly normal.

You can do statistics with "git patch-id", like this:

    git log -M --no-merges -p v3.10.. | git patch-id > patch-id-list
    cut -d' ' -f1 < patch-id-list | sort | uniq -d > duplicates
    cat duplicates | while read id
    do
        echo "Patch ID $id:"
        grep $id patch-id-list | while read x commit
        do
            git log --oneline --no-walk $commit
        done
    done

because duplicate commits is such a normal and expected thing that git
actually has tools to find them.

NOTE! The above example script finds just the duplicates that all
happened after v3.10. So the above does *not* find the case here,
where one copy was merged before v3.10, and another was merged after.
But you can play with the above script, it's efficient enough that you
can reasonably run it on bigger histories (you'll want a reasonably
powerful machine, though - it's obviously generating the patch for all
non-merge commits you want to check).

                        Linus
