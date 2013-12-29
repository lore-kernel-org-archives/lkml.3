Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab3L2TO2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 14:14:28 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:46645 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab3L2TO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 14:14:26 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+8W/lqUZU3l3S8NmSSQ8vvf4EwU0+SS64=
X-DKIM: OpenDKIM Filter v2.0.1 titan A9E974FDD5B
Date: Sun, 29 Dec 2013 14:14:23 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Gene Heskett <gheskett@wdtv.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG BISECTED FAILED] Phenom microcode revision mis-identified
Message-ID: <20131229191423.GQ19878@titan.lakedaemon.net>
References: <201312291224.03854.gheskett@wdtv.com>
 <201312291247.02384.gheskett@wdtv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201312291247.02384.gheskett@wdtv.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 29, 2013 at 12:47:02PM -0500, Gene Heskett wrote:
> On Sunday 29 December 2013, Gene Heskett wrote:
> >Resend, incorrect subject line
> >
> >Here is the copy/paste of the final git bisect bad report:
> >
> >First, the reason for the bisect:
> >gene@coyote:~/linux-stable$ dmesg | grep -A2 microcode
> >[    0.518304] microcode: CPU0: patch_level=0x01000065
> >[    0.518396] microcode: CPU1: patch_level=0x01000065
> >[    0.518498] microcode: CPU2: patch_level=0x01000065
> >[    0.518593] microcode: CPU3: patch_level=0x01000065
> >[    0.518745] microcode: Microcode Update Driver: v2.00
> ><tigran@aivazian.fsnet.co.uk>, Peter Oruba
> >
> >The output above should have in each cpu case, a second, or final line
> >showing a patch level 0x0100083 in all cases.
> >This failure is on an AMD phenom 9550 equipt machine.
> >
> >I can and have built from the tarball pull, a 3.8.2 which does work
> >correctly.  The tarball build of 3.8.3 fails as above, and a tarball
> >build of 3.12.6 still fails.
> >
> >gene@coyote:~/linux-stable$ git bisect bad
> >908e88f285b909011dc7dbce5abaacf123f2f68d is the first bad commit
> >commit 908e88f285b909011dc7dbce5abaacf123f2f68d
> >Author: Russell King <rmk+kernel@arm.linux.org.uk>
> >Date:   Mon Feb 25 16:09:12 2013 +0000
> >
> >I'll next do a "git checkout v3.8.2" to double check that it works.

Please re-read the manpage for git bisect, particularly the section
"Basic bisect commands".  You need to keep repeating building and
booting the kernel, execute 'git bisect [good|bad]', as git bisect
checks out different commits to try.  Depending on the number of
commits, it can take 7 to 10 iterations before it nails it down to the
bad commit.

$ git log --oneline v3.8.2..v3.8.3 | wc -l
103

So you started at v3.8.3, said v3.8.2 is good.  git bisect will then
checkout a commit in the middle (of the 103 commits to choose from).  You
need to build that kernel, boot it, and see if the error occurs.  Then,
type 'git bisect [bad|good]' depending on what happened.  When that
command returns, it has checked out a different commit between v3.8.2
and v3.8.3.  Build, boot, and run 'git bisect [good|bad]' depending on
if the patch_level was reported properly.  Repeat until it reports
nothing left to test.

> FWIW, a git checkout v3.8.2  also fails, so next I'll move my working 
> tarball build .configs into that tree & see if it works.

If the config you started with worked for v3.8.2 and didn't for v3.8.3,
keep using it.

> This is getting stranger, a checkout v3.8.2 is supposed to match the
> tarball I got from kernel.org isn't it?

Yes, see above.  As soon as you started the bisection process, you were
no longer on version 3.8.2 or 3.8.3, but somewhere in between.  That's
what's supposed to happen.

Once you run enough iterations to get nothing left to test, record the
commit it identified, and run 'git bisect reset'.

hth,

Jason.
