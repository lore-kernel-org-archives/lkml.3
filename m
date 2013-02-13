Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965060Ab3BMWWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 17:22:00 -0500
Received: from mail.windriver.com ([147.11.1.11]:48398 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964934Ab3BMWV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 17:21:59 -0500
Date: Wed, 13 Feb 2013 17:22:22 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Ondrej Zary <linux@rainbow-software.org>
CC: Jens Axboe <axboe@kernel.dk>, <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [GIT PULL] removal of 1980s PC-XT MFM 8bit ISA disk driver
Message-ID: <20130213222221.GA11235@windriver.com>
References: <20130213200432.GA11018@windriver.com>
 <201302132154.38477.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201302132154.38477.linux@rainbow-software.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [GIT PULL] removal of 1980s PC-XT MFM 8bit ISA disk driver] On 13/02/2013 (Wed 21:54) Ondrej Zary wrote:

> On Wednesday 13 February 2013 21:04:32 Paul Gortmaker wrote:
> > Jens,
> >
> > Please pull the following to get the removal of the original IBM PC-XT
> > hard disk driver from the block layer (drivers/block/xd.c).
> >
> > As near as I can tell, it hasn't seen a run time fix in over a dozen
> > years, and with drive sizes of 10-20MB, and performance of about 128kB/s
> > maximum, it is no surprise that it has been completely unused for well
> > over a decade.
> 
> It was fixed just yesterday by Linus Walleij: 
> http://lkml.org/lkml/2013/2/12/541

Ondrej,

Since you consistently try to interject into these cleanups and never
address the logical points of reason given, let me repeat them once
more, in the hope that you will read and consider their merit.

But before doing that though, lets look at this rather contrived "fix"
that coincidentally happened to appear after the deletion was suggested.

1) it claims the following: "...the fact that it was in the kernel tree
SAVED MY DATA." [caps exactly as in original].  This is patently false,
as any kernel from 2.0, 2.2, 2.4, 2.6, 3.x would have done the job.  In
fact, using an older kernel would have better odds of success, based on
simple bitrot rules and the bathtub curve.  The above hype tries to FUD
people into thinking drivers permanently "disappear" just because they
get removed from master on mainline - totally untrue.

2) it "works" but only after you are required to physically pry parts
off of the hardware, and yet this is considered reasonable?

3) we are asked to believe that it is completely reasonable to require
this to be in the bleeding edge tree, yet at the same time, the platform
needed to achieve is is chosen as a Pentium-MMX -- i.e. a system from 1996
running at ~200MHz -- as far from bleeding edge as physically possible.

4) the "fix" adds a udelay after each outb (vs simply redefining outb,
I might add) -- which only proves that this has been unused for a long
time -- i.e. since the whole SLOW_DOWN_IO/outb/0x80 cleanup.

But in the end, those points are not as important as what is below.
These general justification points you can find in the pending 3.9
commit 930d52c012b8e69ea87efd7562ded977ee9c9df9 (via the net-next tree).
I hope you can consider these points with an open mind.

Thanks,
Paul.

 -------
    Allow me a preemptive justification against the inevitable comments from
    well meaning bystanders who suggest "why not just leave all this alone?".
    Dead drivers cost us all if they are left in tree.  If you think that
    is false, then please first consider:
    
    -every time you type "git status", you are checking to see if modifications
     have been made by you to all that dead code.
    
    -every time you type "git grep <regex>" you are searching through files
     which contain that dead code that simply does not interest you.
    
    -every time you build a "allyesconfig" and an "allmodconfig" (don't tell
     me you skip this step before submitting your changes to a maintainer),
     you waste CPU cycles building this dead code.
    
    -every time there is a tree wide API change, or cleanup, or file relocation,
     we pay the cost of updating dead code, or moving dead code.
    
    -daily regression tests (take linux-next as the most transparent
     example) spend time building (and possibly running) this dead code.
    
    -hard working people who regularly run auditing tools looking for lurking
     bugs (sparse/coverity/smatch/coccinelle) are wasting time checking for,
     and fixing bugs in this dead code.
    
    This last one is key.  Please take a look at the git history for the
    files that are proposed for removal here.  Look at the git history for
    any one of them ("git whatchanged --follow drivers/net/.../driver.c")
    Mentally sort the changes into two bins -- (1) the robotic tree-wide
    changes, and (2) the "look I found a real run-time bug while using this"
    category.  You will see that category #2 is essentially empty.
    
    Further to that, realize that drivers don't simply disappear.  We are
    not operating in the binary-only distribution space like other OS.  All
    these drivers remain in the git history forever.  If a person is an
    enthusiast for extreme legacy hardware, they are probably already
    customizing their kernel source and building it themselves to support
    such systems.  Also keep in mind that they could still build the 3.8
    kernel exactly as-is, and run it (or a 3.8.x stable variant of it) for
    several more years if they were really determined to cling to these old
    experimental ISA drivers for some reason.
    
    In summary, I hope that folks can be pragmatic about this, and not
    get swept up in nostalgia.  Ask yourself whether it is realistic to
    expect a person would have a genuine use case where they would
    need to build a 3.9+ modern kernel and install it on some legacy hardware
    that has no option but to absolutely _require_ one of the drivers
    that are deleted here.
 -------

> 
> -- 
> Ondrej Zary
