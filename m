Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab3GCFTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 01:19:50 -0400
Received: from mail1.windriver.com ([147.11.146.13]:40864 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab3GCFTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 01:19:48 -0400
Date: Wed, 3 Jul 2013 01:19:07 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Stephen Boyd <sboyd@codeaurora.org>, Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, <linux-kernel@vger.kernel.org>,
        Joseph Lo <josephl@nvidia.com>, <linux-tegra@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: move body of head-common.S back to text section
Message-ID: <20130703051907.GA22702@windriver.com>
References: <1372805629-18382-1-git-send-email-swarren@wwwdotorg.org>
 <20130702232259.GH11625@codeaurora.org>
 <51D39004.9000907@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <51D39004.9000907@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [PATCH] ARM: move body of head-common.S back to text section] On 02/07/2013 (Tue 20:44) Stephen Warren wrote:

> On 07/02/2013 05:22 PM, Stephen Boyd wrote:
> > On 07/02, Stephen Warren wrote:
> >> From: Stephen Warren <swarren@nvidia.com>
> >>
> >> Commit 281ecb7 "arm: delete __cpuinit/__CPUINIT usage from all ARM

We shouldn't reference this commit since (a) the SHA is from linux-next
and hence is transient, and (b) this commit really isn't the one that
triggers the breakage.  It is the commit where we dummy out the macros
that will reveal the missing __FINIT.

So, assuming Linus takes my pull request here...

https://lkml.org/lkml/2013/7/2/405

...for phase one of the __cpuinit purge, then the SHA you want to
blame for triggering this hidden bug into life is:

22f0a2736 "init.h: remove __cpuinit sections from the kernel" at:

http://git.kernel.org/cgit/linux/kernel/git/paulg/linux.git/log/?h=cpuinit-delete

After you update the commit log (and make the change below), it probably
makes sense for this to go in via one of the ARM trees, since if I take
it, it will go in at the very end of the merge window with the phase two
commits.  If it goes in via an arm tree, the regression window within
3.10 --> 3.11-rc1 will be minimized. (That and it is a pre-existing bug).

> >> users" removed a __CPUINIT from head-common.S. However, the code
> >> immediately before the removed tag was marked __INIT, and was missing
> >> a match __FINIT. This caused code after the removed __CPUINIT to end
> >> up in the init section rather than the main text section as desired.
> >> This caused issues such as secondary CPU boot failures or crashes.
> >> Add the missing __FINIT to solve this.
> >>
> >> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> >> ---
> >>  arch/arm/kernel/head-common.S | 2 ++
> >>  1 file changed, 2 insertions(+)
> >>
> >> diff --git a/arch/arm/kernel/head-common.S b/arch/arm/kernel/head-common.S
> >> index 529ce99..a9dc804 100644
> >> --- a/arch/arm/kernel/head-common.S
> >> +++ b/arch/arm/kernel/head-common.S
> >> @@ -122,6 +122,8 @@ __mmap_switched_data:
> >>  	.long	init_thread_union + THREAD_START_SP @ sp
> >>  	.size	__mmap_switched_data, . - __mmap_switched_data
> >>  
> >> +	__FINIT
> >> +
> >>  /*
> >>   * This provides a C-API version of __lookup_processor_type
> >>   */
> > 
> > Shouldn't this come after lookup_processor_type()? Otherwise you
> > just removed that function from the init section?
> 
> I think this is correct. Prior to "arm: delete __cpuinit/__CPUINIT usage
> from all ARM users", lookup_processor_type() was in the cpuinit section.

No, it was __lookup_processor_type that was in the cpuinit section.
The non-underscore (C-API) version was __INIT, and if you look at the
one and only calling function in C, it too is tagged __init.  So it
appears to me that was a thought out and deliberate choice.

> After that commit, it moved to the init section and hence got dumped
> soon after boot. The change above moves lookup_processor_type() back
> into the regular text section, which I believe was the intent of the
> __cpuinit removal patch.

Given the above, actually I think StephenB is right here.  The __FINIT
can go exactly where the removed __CPUINIT was (plus or minus a blank
line...)

Thanks for testing, reporting and then tracking down where it was once
you knew what it was that you were looking for (and to Russell for the
quick and accurate diagnosis.)  You can add an Acked-by from me to the
updated patch if you want.

As an aside, I'm now thinking any __INIT that implicitly rely on EOF for
closure are nasty traps waiting to happen and it might be worthwhile to
audit and explicitly __FINIT them before someone appends to the file...

Paul.
--
