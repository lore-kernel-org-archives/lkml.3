Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbaLCEO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 23:14:59 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:58994 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaLCEOx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 23:14:53 -0500
MIME-Version: 1.0
In-Reply-To: <547e81ce.a1628c0a.4985.ffffb12a@mx.google.com>
References: <20141201191431.GA17385@linux.vnet.ibm.com>
	<547ccf74.a5198c0a.25de.26d9@mx.google.com>
	<20141201230813.GE25340@linux.vnet.ibm.com>
	<547dec29.c71f8c0a.33d1.11d9@mx.google.com>
	<20141202170407.GK25340@linux.vnet.ibm.com>
	<547df364.236a8c0a.7b2d.ffffac67@mx.google.com>
	<20141202184202.GM25340@linux.vnet.ibm.com>
	<547e0947.c332e00a.23bf.ffffa8bd@mx.google.com>
	<20141202191143.GN25340@linux.vnet.ibm.com>
	<547e11fa.8778e00a.3439.ffffa88c@mx.google.com>
	<20141202205636.GQ25340@linux.vnet.ibm.com>
	<547e36d1.c54ae00a.2571.fffffd13@mx.google.com>
	<CA+55aFxdZjJprk8t9NxcZmewAAQ5Gf1XQWV=5i+Vfc5uTSfWFg@mail.gmail.com>
	<547e81ce.a1628c0a.4985.ffffb12a@mx.google.com>
Date: Tue, 2 Dec 2014 20:14:52 -0800
X-Google-Sender-Auth: iSH2e8oJnaCXDMQpnflxrfc3ndQ
Message-ID: <CA+55aFxumSXif01LigHBgZeXFTWT-7knX=a8LJZeaZZDPoHCBg@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Tejun Heo <tj@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2014 at 7:21 PM, Dâniel Fraga <fragabr@gmail.com> wrote:
>
>         Ok Linus and Paul, it took me almost 5 hours to bisect it and
> the result is:

Much faster than I expected. However:

> c9b88e9581828bb8bba06c5e7ee8ed1761172b6e is the first bad commit

Hgghnn.. A merge commit can certainly be the thing that introduces
bugs, but it *usually* isn't. Especially not one that is fairly small
and has no actual conflcts in it. Sure, there could be semantics
conflicts etc, but that's where "fairly small" comes in - that is just
not a complicated or subtle merge. And there are other reasons to
believe your bisection weered off into the weeds earlier. Read on.

So:

>         I hope I didn't get any false positive/negative during
> bisect.

Well, the "bad" ones should be pretty safe, since there is no question
at all about any case where things locked up. So unless you actually
mis-typed or did something other silly, I'll trust the ones you marked
bad.

It's the ones marked "good" that are more questionable, and might be
wrong, because you didn't run for long enough, and didn't happen to
hit the right condition.

Your bisection log also kind of points to a mistake: it ends with a
long run of "all good". That usually means that you're not actually
getting closer to the bug: if you were, you'd - pretty much by
definition - also get closer to the "edge" of the bug, and you should
generally see a mix of good/bad as you narrow in on it. Of course,
it's all statistical, so I'm not saying that a run of "good"
bisections is a sure-fire sign of anything, but it's just another
sign: you may have marked something "good" that wasn't, and that
actually took you *away* from the bug, so now everything that followed
that false positive was good.

>         And here's the complete bisect log (just in case):

So this part I'll believe in:

> git bisect start
> # good: [19583ca584d6f574384e17fe7613dfaeadcdc4a6] Linux 3.16
> git bisect good 19583ca584d6f574384e17fe7613dfaeadcdc4a6
> # bad: [bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9] Linux 3.17
> git bisect bad bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9
> # bad: [f2d7e4d4398092d14fb039cb4d38e502d3f019ee] checkpatch: add fix_insert_line and fix_delete_line helpers
> git bisect bad f2d7e4d4398092d14fb039cb4d38e502d3f019ee
> # bad: [79eb238c76782a59d51adf8a3dd7f6444245b475] Merge tag 'tty-3.17-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
> git bisect bad 79eb238c76782a59d51adf8a3dd7f6444245b475
> # good: [3d582487beb83d650fbd25cb65688b0fbedc97f1] staging: vt6656: struct vnt_private pInterruptURB rename to interrupt_urb
> git bisect good 3d582487beb83d650fbd25cb65688b0fbedc97f1
> # bad: [e9c9eecabaa898ff3fedd98813ee4ac1a00d006a] Merge branch 'x86-cpufeature-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect bad e9c9eecabaa898ff3fedd98813ee4ac1a00d006a
> # bad: [c9b88e9581828bb8bba06c5e7ee8ed1761172b6e] Merge tag 'trace-3.17-2' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace
> git bisect bad c9b88e9581828bb8bba06c5e7ee8ed1761172b6e

because anything marked "bad" clearly must be bad, and anything you
marked "good" before that was probably correct too - because you saw
"bad" cases after it, the good marking clearly hadn't made us ignore
the bug.

Put another way: "bad" is generally more trustworthy (because you
actively saw the bug), while a "good" _before_ a subsequent bad is
also trustworthy (because if the "good" kernel contained the bug and
you should have marked it bad, we'd then go on to test all the commits
that were *not* the bug, so we'd never see a "bad" kernel again).

Of course, the above rule-of-thumb is a simplification of reality. In
reality, there might be multiple bugs that come together and make the
whole good-vs-bad a much less black-and-white thing, but *generally* I
trust "git bisect bad" more than "git bisect good", and "git bisect
good" that is followed by "bad".

What is *really* suspicious is a series of "git bisect good" with no
"bad"s anywhere. Which is exactly what we see at the end of the
bisect.

So might I ask you to try starting from this point again (this is why
the bisect log is so useful - no need to retest the above part, you
can just mindlessly do that sequence by hand without testing), and
starting with this commit:

> # good: [47dfe4037e37b2843055ea3feccf1c335ea23a9c] Merge branch 'for-3.17' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup
> git bisect good 47dfe4037e37b2843055ea3feccf1c335ea23a9c

Double-check whether that commit is really good. Run that "good"
kernel for a longer time, and under heavier load. Just to verify.

Because looking at the part of the bisect that seems trust-worthy, and
looking at what remains (hint: do "gitk --bisect" while bisecting to
see what is going on), these are the merges in that set (in my
"mergelog" format):

    Bjorn Helgaas (1):
      PCI updates

    Borislav Petkov (1):
      EDAC changes

    Herbert Xu (1):
      crypto update

    Jeff Layton (1):
      file locking related changes

    Mike Turquette (1):
      clock framework updates

    Steven Rostedt (3):
      config-bisect changes
      tracing updates
      tracing filter cleanups

    Tejun Heo (4):
      workqueue updates
      percpu updates
      cgroup changes
      libata changes

and quite frankly, for some core bug like this, I'd suspsect the
workqueue or percpu updates from Tejun (possibly cgroup), *not* the
tracing pull.

Of course, bugs can come in from anywhere, so it *could* be the
tracing one, and it *could* be the merge commit, but my gut just
screams that you probably missed one bad kernel, and marked it good.
And it's really that very first one (ie commit
47dfe4037e37b2843055ea3feccf1c335ea23a9c) that contains most of the
actually suspect code, so I'd really like you to re-test that one a
lot before you call it "good" again.

Humor me.

I added Tejun to the Cc, just because I wanted to give him a heads-up
that I am tentatively starting to blame him in my dark little mind..

                 Linus
