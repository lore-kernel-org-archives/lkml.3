Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab3B1EBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 23:01:21 -0500
Received: from mail-ia0-f169.google.com ([209.85.210.169]:33785 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab3B1EBU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 23:01:20 -0500
Date: Wed, 27 Feb 2013 22:01:14 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH 0/3] build linux-next without perl
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Cyrill Gorcunov <gorcunov@openvz.org>,
        Dave Jones <davej@redhat.com>, David Howells <dhowell@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Josh Boyer <jwboyer@redhat.com>, Michal Marek <mmarek@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rusty Russell <rusty@rustcorp.com.au>, Sam Ravnborg <sam@ravnborg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>, x86@kernel.org,
        Zheng Yan <zheng.z.yan@intel.com>,
        David Anders <dave123_aml@yahoo.com>
In-Reply-To: <20130227135155.c04453db.akpm@linux-foundation.org> (from
	akpm@linux-foundation.org on Wed Feb 27 15:51:55 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1362024074.15531.1@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2013 03:51:55 PM, Andrew Morton wrote:
> On Tue, 26 Feb 2013 21:57:52 -0800 (PST)
> Rob Landley <rob@landley.net> wrote:
> 
> > Before 2.6.25 building Linux never required perl. This patch series  
> removes
> > the requirement from basic kernel builds (tested on i686, x86_64,  
> arm, mips,
> > powerpc, sparc, sh4, and m68k). Now updated to 3.8-rc1.
> >
> > Note, this removes perl from the _build_ environment, not from the  
> _development_
> > environment. This is approximately the same logic behind "make  
> menuconfig"
> > requiring curses but "make oldconfig" not requiring curses.  
> Including
> > zconf.lex.c_shipped in kconfig and then requiring perl makes no  
> sense.
> >
> > ...
> >
> > Mostly people just copy the patches into their local projects (ala
> > https://github.com/rofl0r/sabotage/tree/master/KEEP ) but I'm  
> reposting
> > them to linux-kernel after Gentoo considered using these patches,  
> but didn't
> > because they weren't upstream:
> >   https://bugs.gentoo.org/show_bug.cgi?id=421483
> 
> Sitting here scratching head wondering why you-need-perl is a problem
> for anyone.

I'm scratching my head that people basically keep doing the "you go  
girl!" thing at me about this patch series _off_ the list (even people  
I'd expect to see here, like  
https://twitter.com/jonmasters/status/301166688852901888 ) but this is  
something like the dozenth time I've posted it and nobody seems to  
notice. Oh well.

Can we start with the fact it's a completely gratuitous build  
environment dependency, and the kernel has a history of removing those?  
(I mentioned two in the message you're replying to, ncurses and lex in  
oldconfig.)

This isn't even a "workaround", this is an alternate implementation  
that is as simple or simpler. (Sam Ravnborg acked one of the scripts  
not because he cared about perl, but because it simplified the kernel  
build.)

> That gentoo bug report provides some explanation: "perl was removed
> from @system".  But I expect other people have different reasons.

Actually, removing perl from the build environment is common in cross  
compiling situations. Removing everything you _can_ from the build  
environment is normal when cross compiling. This is because cross  
compiling sucks:

   http://landley.net/writing/docs/cross-compiling.html

Cross compiling has inherent combinatorial complexity. Native compiling  
build complexity is "number of packages times number of package  
versions", with an addendum that things like the compiler and libc  
count as packages with different versions.

When cross compiling, you basically multiply the number of targets  
you're supporting times the number of package versions you're building  
times the number of hosts you're building from. I've installed distros  
I'd never even _heard_ of under kvm because some bug only happened  
there, but of course all the big ones break too:

   http://landley.net/hg/aboriginal/rev/1532
   http://landley.net/hg/aboriginal/rev/1518
   http://landley.net/hg/aboriginal/rev/1318
   http://landley.net/hg/aboriginal/rev/1160

It's not just the combinatorial complexity, it's also less testing in  
general (most people natively compile), plus the entire configure step  
is wrong at the design level for cross compiling: it asks questions  
about the machine you're building on and applies those answers to the  
program you're building. When host and target aren't the same, this is  
at _best_ useless.

So if you're cross compiling in any remotely portable way, you need an  
"airlock step", as described on pages 98-100 the slides for the old  
talk I gave at Ohio LinuxFest, Flourish, and Celf, which is apparently  
making the rounds again:

   https://twitter.com/solardiz/status/306575964064866305

It's the same general idea as Linux From Scratch chapter 5 (you  
populate a directory with just the binaries you need, and restrict the  
$PATH to that) but with a minimalist twist: everything you add is a  
sharp edge some package can catch on. If not now, then after the next  
version upgrade.

And perl is a GIANT HAIRBALL of sharp edges in this regard. There is no  
perl standard, just a single perl implementation that may or may not  
have the whole of CPAN installed. (In fact the "canned values" logic in  
kernel/timeconst.pl uses a giant array of precomputed values because  
the installed perl may or may not have Math::BigInt might not be  
available on the target. Way back in 2008 I thought this meant we had  
to be able to run without that and the Math::BigInt stuff was just for  
regenerating the table, but Peter said  
https://lkml.org/lkml/2008/2/15/548 and didn't mind letting the user  
figure out what the dependencies were when the build broke. Now apply  
that to lots of other packages and guess why letting ./configure not  
find perl is appealing to cross compile environments.)

I'm surprised perl doesn't get dinged more for the single  
implementation. All the shell scripts in the kernel are supposed to  
work with #!/bin/sh pointing to dash instead of bash, people freak when  
Microsoft Word or Excel are whatever some random program parses rather  
than an actual file format. But perl? Everybody remember when perl was  
going to be reimplemented on top of the "parrot" engine?  
(http://www.perlmonks.org/?node_id=272641) You know why that didn't  
happen? Because after several years of effort they couldn't quite make  
it work reliably. Getting a fresh from-scratch engine implementation to  
run the existing corpus of perl code turned out to be _really_hard_.  
Python's got http://wiki.python.org/moin/PythonImplementations and  
there's even an embedded implementation of php (http://ph7.symisc.net/)  
but perl is this one _specific_ giant hairball. If you have trouble  
getting that hairball to work on a new target? Tough. (When I did  
bootstrap work on Hexagon back in 2010, and built linux from scratch  
natively on the result, "will perl work" was one of the big unknowns.  
Luckily it only took about a week of poking and prodding to get it to  
build. Didn't particularly stress it to see how _well_ it worked,  
mostly because I'd carefully arranged the build to need it as little as  
possible. One of x11's dependencies needed it though, off in Beyond  
Linux From Scratch, and wouldn't ./configure it out the way libiconv  
and such did. Don't remember which one.)

By the way, I'm not saying restricting the $PATH by itself is a  
_sufficient_ airlock step. When Wolfgang Denk (the u-boot maintainer)  
tried my cross compiling build environment it immediately broke in 3  
different and strangely fascinating ways for him, one of which  
(http://landley.net/hg/aboriginal/rev/997) evolved into an entire  
environment variable whitelisting step  
(http://landley.net/hg/aboriginal/rev/1175) because once it works well  
enough more people try it and break it in new ways...

And no, my build system isn't special, I just use it as an example  
because it's what I'm most familiar with. What an awful lot of distros  
do is set up a chroot and then "env -i chroot" into it (I.E. the  
Linux From Scratch approach). My build system goes to extra effort so  
that no part of it requires root access on the host (which is why I  
don't chroot, I run the target system under qemu instead, hence the  
title of the above giant slide deck from 2008).

> IOW, please better describe the motivation for this patchset.

You want more? Ok. (You asked.)

In addition to all the above, last week I gave a talk at the Linux  
Foundation Embedded Linux Conference (used to be called CELF before  
they ate it) on turning Android into a real build environment. I didn't  
do slides this time but the outline's here:

   http://landley.net/talks/celf-2013.txt

It would be really convenient if the video of that talk was up so I  
could just point you at it, but you'll have to ask the Linux Foundation  
when that'll be. The outline was just "notes to self" for me, lemme see  
if I can summarize an hour talk in a couple paragraphs.

What I'm doing there is trying to expand Android into a full  
self-hosting development environment so it can get on with being a  
disruptive technology and kicking the PC up into the server space like  
the minicomputer and mainframe before it. I would _very_ much like  
Android to do this before iPhone does because when the S-curve of  
adoptions flattens out (somewhere between 1 and 3.5 billion unit  
installed base I'd guess) and the positive feedback loop of network  
effects kick in, being locked out of _another_ generation of technology  
by an actually COMPETENT monopolist would really suck.

The hardware to use a smartphone as a workstation is just a USB hub  
with keyboard, mouse, and video adapter plugged into it; that's here  
today (although USB3 makes it easier). The rest is software. But  
there's a LOT of software.

This software has 4 basic parts: kernel (which works now because they  
just added stuff to linux without removing anything), a command line  
(I'm writing a new BSD-licensed posix command line; same general reason  
I did years of work in busybox only this time it's old hat), a C  
library (musl-libc.org is the leading contender), and a toolchain  
(looks like llvm at the moment, I'd like to do http://landley.net/qcc  
but my plate's full and there's no time. Why no time? Who is sponsoring  
llvm? Who did "airplay" to put a phone display on an HDTV? You think  
Steve Jobs didn't _notice_ that 8->16->32->64 bits is sustaining  
technologies but mainframe->minicomputer->microcomputer->smartphone is  
disruptive yet _inevitable_?)

This 4-package thing is even more simplified than my Aboriginal Linux  
build (which got it down to 7 packages, but the licensing of those is  
wrong -- no GPL in userspace -- so preinstalling any of it is a  
violation of the Android licensing guidelines and the trademark grows  
teeth so your ads have to be really horribly phrased.)

The reason you _want_ to simplify it is that Google is shipping a  
billion unadministered unix systems with broadband access, which is  
TERRIFYING from a security standpoint. The reason bionic and toolbox  
are stubs even though uClibc and busybox both predate android isn't  
_just_ licensing issues, it's that Google intentionally shipped the  
minimum environment necessary to boot dalvik and get into the java  
sandbox, and is minimizing the attack surface if you can manage to  
escape that.

But Dalvik is this generation's version of ROM Basic: it's something  
the platform has to outgrow in order to wean itself off of the previous  
generation it's cross-compiled from. Once the PC became a self-hosting  
development environment there was an explosion of software for it,  
because you no longer needed a PDP-10 to develop for the PC, having a  
PC was enough to be a developer. This is not currently the case for  
phones, but it should _become_ the case.

If you then say "and to be a self-hosting system, you must add perl".  
And to preinstall perl, you must audit perl for security concerns...  
Can we please, please, please just remove the need for perl as part of  
a self-hosting development environment instead?

P.S. These are just _my_ reasons. Dave Anders is the one who first  
complained to _me_ that perl had been added as a build requirement back  
in 2.6.25. I finally met him in person at the BeagleBone tutorial at  
CELF last week after knowing him for years on freenode (prplague), but  
like all the embedded guys he doesn't hang out here. (I just cc'd him.)  
Nor do the 3 of the 4 other people who congratulated me on getting this  
posted on freenode today (I convinced _one_ of them to come here and  
ack the darn patch).

> It'll need to be reasonably good motivation, too.  Because not only do
> we need to patch the kernel, we also need to *maintain* its
> perl-freeness and fix up perlisms as they later get added by others.

I've already been maintaining it (and submitting it here) for 5 years  
now:

   https://lkml.org/lkml/2008/2/15/541

Sam Ravnborg acked the headers_install change not because of perl but  
because the replacement was simpler than what it replaced. It would be  
difficult to make the timeconst thing with the giant blob of  
pregenerated values _worse_.

As for fixing up existing perlisms, people who use my scripts already  
send you patches to remove perl dependencies in things that I don't  
enable in my builds:

   http://lkml.indiana.edu/hypermail/linux/kernel/0910.0/01896.html

Honestly, not the only one who does this. Sing along:

   http://barb.velvet.com/humor/lurkers.html

(Which is really, really annoying. But that's embedded linux for you.  
They've all written upstream off as ignoring them. You think I'm typing  
an epic tl;dr at _you_ guys, it's _harder_ to get through the other  
way...)

> (Perhaps one way of doing this would be to disable perl in regular
> builds, so even if a developer has perl installed on his machine, his
> build will still fail when he invokes it.  Add "PERL=/dev/null" to  
> some
> build targets in some manner.)

   http://landley.net/aboriginal/about.html

(And yes, I need to get a release out that uses 3.8 but they screwed up  
interrupt routing on QEMU's arm versatile board emulation again and I  
haven't had time to track it down because I've been trying to get  
_this_ pushed upstream this merge window. Again. Plus I need to figure  
out what I broke in powerpc userspace, and run the automated Linux From  
Scratch build under qemu on all targets to make sure I haven't missed  
anything else...)

Rob