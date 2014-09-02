Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751054AbaIBFTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 01:19:21 -0400
Received: from mail1.windriver.com ([147.11.146.13]:44952 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaIBFTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 01:19:20 -0400
Date: Tue, 2 Sep 2014 01:17:37 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Chen Gang <gang.chen.5i5j@gmail.com>
CC: <eparis@redhat.com>, <paulmck@linux.vnet.ibm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>, <zhenglong.cai@cs2c.com.cn>,
        <khilman@linaro.org>, <ak@linux.intel.com>, <mcgrof@suse.com>,
        <fabf@skynet.be>, "dhowells@redhat.com" <dhowells@redhat.com>,
        <pefoley2@pefoley.com>, <mgorman@suse.de>, <biederm@xmission.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH] init/Kconfig: Add ENDIAN attributes for all
 architectures using
Message-ID: <20140902051737.GK26632@windriver.com>
References: <540494D6.40701@gmail.com>
 <20140901160828.GJ26632@windriver.com>
 <5404A66E.509@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5404A66E.509@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [PATCH] init/Kconfig: Add ENDIAN attributes for all architectures using] On 01/09/2014 (Mon 10:01) H. Peter Anvin wrote:

> On 09/01/2014 09:08 AM, Paul Gortmaker wrote:
> >>>
> >> diff --git a/init/Kconfig b/init/Kconfig
> >> index ac033c3..f301cc8 100644
> >> --- a/init/Kconfig
> >> +++ b/init/Kconfig
> >> @@ -23,6 +23,12 @@ config CONSTRUCTORS
> >>  config IRQ_WORK
> >>  	bool
> >>  
> >> +config CPU_LITTLE_ENDIAN
> >> +	bool
> >> +
> >> +config CPU_BIG_ENDIAN
> >> +	bool
> > 
> > Perhaps you should take a cursory look at what already exists in tree
> > before blindly trying to add more to it?
> > 
> > $ git grep CPU_BIG_ENDIAN | wc -l
> > 88
> > 
> 
> The whole point of this patchset is to make these already widely-used
> options universal across the tree.

OK, but that was not at _all_ what I thought when looking at this...

Instead I saw a well intentioned, but perhaps not fully thought out
attempt at fixing a largely irrelevant randconfig/allmodconfig of a
1990's vintage ISDN driver coming from that x86-only era, built against
an architecture that will never use or support it (microblaze).

In today's world, we'd probably not accept a new ethernet driver or
filesystem if it was incapable of handling both BE and LE (exception
being SoC ethernet physically bound to one specific CPU, of course.)
So the justification given in the commit log for expanding the scope to
better deal with the stuff found in ISDN and the like was questionable.

Secondly, I don't think it is well known that Kbuild will tolerate
multiply defined symbols of the exact same name, and since that isn't
mentioned in the commit log (as documented and/or tested), I envisioned
this breaking powerpc and other arch who already define one (or both)
of these two.  I found multi-define _is_ documented as supported in
Documentation/kbuild but I still wonder how much it is used and how
well it handles things like in powerpc, where one of them (LE?) also
lists a "select ... " line and help text under the bool.

So if we want to do this, I'd suggest a commit log that really gets
to the intended point; something along the lines of:

  --------------

  Currently we have some architectures defining their own bool for
  CPU_LITTLE_ENDIAN and/or CPU_BIG_ENDIAN.  As of 3.17-rc3 we have:

    CPU_BIG_ENDIAN: arc, arm, arm64, c6x, mips, powerpc, sh
    CPU_LITTLE_ENDIAN: m32r, mips, powerpc, sh

  Note that the scope does not cover all arch, which reduces the utility
  value of these items in generic and/or arch independent code, as
  neither may be defined, making tests on their values inconclusive.

  To fix the above, the goal is to make both items present in an arch
  independent Kconfig.  We can do this immediately without having to
  simultaneously touch the existing arch bool definitions because...

  This change was tested on a powerpc LE config since it has help text
  and a select line, and the behaviour of both before and after the
  change was found to be ...

  --------------

Also, having the suggested change Cc'd to linux-arch would be sensible,
I think.  And one might want to make it a series, showing the follow on
arch specific commits you have planned that "select" an endian, since
the maintainers may want evidence it will be carried to completion and
they also may have something additional to say (as in the case of arch/arm
where there is already CPU_ENDIAN_BE8 and CPU_ENDIAN_BE32 Kconfig items).

Paul.
--

> 
> 	-hpa
> 
> 
