Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbaJLJuu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 05:50:50 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:44590 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaJLJus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 05:50:48 -0400
From: Mikael Pettersson <mikpelinux@gmail.com>
X-Google-Original-From: "Mikael Pettersson" <mikpe@cascade>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21562.20211.290021.157469@gargle.gargle.HOWL>
Date: Sun, 12 Oct 2014 11:50:43 +0200
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Mikael Pettersson <mikpelinux@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH] arm: Blacklist gcc 4.8.[012] and 4.9.0 with CONFIG_FRAME_POINTER
In-Reply-To: <5439713F.1050007@hurleysoftware.com>
References: <1412958374-16090-1-git-send-email-peter@hurleysoftware.com>
	<20141010163613.GO5182@n2100.arm.linux.org.uk>
	<54380F86.10005@hurleysoftware.com>
	<21561.23527.405747.338285@gargle.gargle.HOWL>
	<5439713F.1050007@hurleysoftware.com>
X-Mailer: VM 8.1.2 under 24.3.1 (x86_64-redhat-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Hurley writes:
 > On 10/11/2014 12:33 PM, Mikael Pettersson wrote:
 > > Peter Hurley writes:
 > >  > On 10/10/2014 12:36 PM, Russell King - ARM Linux wrote:
 > >  > > On Fri, Oct 10, 2014 at 12:26:14PM -0400, Peter Hurley wrote:
 > >  > >> gcc versions 4.8.[012] and 4.9.0 generates code that prematurely
 > >  > >> adjusts the stack pointer such that still-to-be-referenced locals
 > >  > >> are below the stack pointer, which allows them to be overwritten
 > >  > >> by interrupts.
 > >  > > 
 > >  > > I would much rather do this in asm-offsets.c, along side the other ARM
 > >  > > specific buggy compiler test(s).  I'm presently putting together such
 > >  > > a patch.
 > >  > > 
 > >  > > The information in the thread on linux-omap says only GCC 4.8.1 and
 > >  > > GCC 4.8.2.  Where do you get the other versions from?
 > >  > 
 > >  > The gcc PR linked in the commit message; see the "Known to fail" field.
 > > 
 > > The 4.8.0 release is broken, but the 4.9.0 one is not.  It's unfortunate,
 > > but "4.9.0" may refer to "the 4.9.0 release" or to "some point after trunk
 > > forked 4.8 branch up to and including the 4.9.0 release point".  In this
 > > case, it's the latter -- this can be inferred from the fact that the
 > > fix went into trunk in October 2013 while 4.9.0 was branched and released
 > > during the first half of 2014.
 > 
 > Is there a reasonably quick way to determine if a particular commit is
 > in a particular release of gcc?

If you want the process to be fully automatic and the answer to be
absolutely precise, then "no".

If you're willing to manually map GCC PR fixes to release versions,
and to have some false negatives (some GCCs having a certain fix
will be flagged as not having it), then "yes".

For this ARM bug, PR58854, we know that 4.8.[0-2] have the bug, but
4.7 and older, 4.8.3 and newer, and 4.9 and newer are Ok.

A problem is that a GCC that identifies itself as 4.8.3 may be
(a) a 4.8.3 pre-release (i.e., close to 4.8.2),
(b) a 4.8.3 release, or
(c) a 4.8.4 pre-release that's been patched to say 4.8.3 (Red Hat does this).

Case (a) may or may not have the fix (we can't easily(*) tell), but
cases (b) and (c) are Ok.  If you're willing to classify all three
as not having the fix (false negatives), then you want to test

#if (__GNUC__ == 4 && __GNUC_MINOR__ == 8 && __GNUC_PATCHLEVEL__ < 4)

for possibly broken versions.

A complication is that a bug has both starting and ending commits.
It's not uncommon for distros and others to backport changes, so a
compiler that claims to be e.g. 4.7.4 may include a backport of the
4.8 change that caused the bug you're trying to avoid.  There is no
easy way to detect this, unless you have a runtime test case for the
bug.  I'd ignore this case as "unfixable".

So I'd write the tests for vanilla upstream GCC only, and tell distro
users to complain to their distros if their kernels get miscompiled.

(*) __VERSION__ is defined like "4.8.3 20140515 (prerelease)" in
pre-releases but like "4.8.3" in ordinary releases, but this is not
something you can test for in the C preprocessor.  A configure-time
check could extract the date and compare that with the date the fix
went into that particular branch, but case (c) above make detecting
pre-releases a bit more complicated.

 > Starting from the mainline viewcvs revision page for this fix here,
 > https://gcc.gnu.org/viewcvs/gcc?view=revision&revision=204203
 > (which is the link from the PR for the fix), navigation to anywhere
 > else in the gcc tree is impossible. I can't even look at the Changelog.

https://gcc.gnu.org/viewcvs/gcc/
then descend trunk or branches as needed.

/Mikael
