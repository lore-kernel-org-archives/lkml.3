Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab3ASEqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 23:46:25 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:33340 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab3ASEqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 23:46:24 -0500
Date: Fri, 18 Jan 2013 23:46:02 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Matt Sealey <matt@genesi-usa.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        devel <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: Re: Compilation problem with drivers/staging/zsmalloc when !SMP on
 ARM
Message-ID: <20130119044602.GC5391@phenom.dumpdata.com>
References: <CAKGA1b=ACTQHo9=B7EAG5nrFCO9u-J+sy7dXtYk3Rk6OUcW3cQ@mail.gmail.com>
 <20130118210859.GH23505@n2100.arm.linux.org.uk>
 <CAKGA1bmJ6c4LC=NAD4MU_rBZ2hZjf6qH=C+dqMCf0eP+2vSFdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKGA1bmJ6c4LC=NAD4MU_rBZ2hZjf6qH=C+dqMCf0eP+2vSFdA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 07:11:32PM -0600, Matt Sealey wrote:
> On Fri, Jan 18, 2013 at 3:08 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Fri, Jan 18, 2013 at 02:24:15PM -0600, Matt Sealey wrote:
> >> Hello all,
> >>
> >> I wonder if anyone can shed some light on this linking problem I have
> >> right now. If I configure my kernel without SMP support (it is a very
> >> lean config for i.MX51 with device tree support only) I hit this error
> >> on linking:
> >
> > Yes, I looked at this, and I've decided that I will _not_ fix this export,
> > neither will I accept a patch to add an export.
> 
> Understood..
> 
> > As far as I can see, this code is buggy in a SMP environment.  There's
> > apparantly no guarantee that:
> >
> > 1. the mapping will be created on a particular CPU.
> > 2. the mapping will then be used only on this specific CPU.
> > 3. no guarantee that another CPU won't speculatively prefetch from this
> >    region.
> > 4. when the mapping is torn down, no guarantee that it's the same CPU that
> >    used the happing.
> >
> > So, the use of the local TLB flush leaves all the other CPUs potentially
> > containing TLB entries for this mapping.
> 
> I'm gonna put this out to the maintainers (Konrad, and Seth since he
> committed it) that if this code is buggy it gets taken back out, even
> if it makes zsmalloc "slow" on ARM, for the following reasons:

Just to make sure I understand, you mean don't use page table
mapping but instead use copying?

> 
> * It's buggy on SMP as Russell describes above
> * It might not be buggy on UP (opposite to Russell's description above
> as the restrictions he states do not exist), but that would imply an
> export for a really core internal MM function nobody should be using
> anyway
> * By that assessment, using that core internal MM function on SMP is
> also bad voodoo that zsmalloc should not be doing

 'local_tlb_flush' is bad voodoo?

> 
> It also either smacks of a lack of comprehensive testing or defiance
> of logic that nobody ever built the code without CONFIG_SMP, which
> means it was only tested on a bunch of SMP ARM systems (I'm guessing..
> Pandaboard? :) or UP systems with SMP/SMP_ON_UP enabled (to expand on
> that guess, maybe Beagleboard in some multiplatform Beagle/Panda
> hybrid kernel). I am sure I was reading the mailing lists when that
> patch was discussed, coded and committed and my guess is correct. In
> this case, what we have here anyway is code which when PROPERLY
> configured as so..

The initial patch were done on x86. Then Seth did the work to make sure
it worked on PPC. Munchin looked on ARM and that is it.

If you have an ARM server that you would be willing to part with I would
be thrilled to look at it.

> 
> diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c
> b/drivers/staging/zsmalloc/zsmalloc-main.c
> index 09a9d35..ecf75fb 100644
	> --- a/drivers/staging/zsmalloc/zsmalloc-main.c
> +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
> @@ -228,7 +228,7 @@ struct zs_pool {
>   * mapping rather than copying
>   * for object mapping.
>  */
> -#if defined(CONFIG_ARM)
> +#if defined(CONFIG_ARM) && defined(CONFIG_SMP)
>  #define USE_PGTABLE_MAPPING
>  #endif
> 
> .. such that it even compiles in both "guess" configurations, the
> slower Cortex-A8 600MHz single core system gets to use the slow copy
> path and the dual-core 1GHz+ Cortex-A9 (with twice the RAM..) gets to
> use the fast mapping path. Essentially all the patch does is "improve
> performance" on the fastest, best-configured, large-amounts-of-RAM,
> lots-of-CPU-performance ARM systems (OMAP4+, Snapdragon, Exynos4+,
> marvell armada, i.MX6..) while introducing the problems Russell
> describes, and leave performance exactly the same and potentially far
> more stable on the slower, memory-limited ARM machines.

Any ideas on how to detect that?
> 
> Given the purpose of zsmalloc, zram, zcache etc. this somewhat defies
> logic. If it's not making the memory-limited, slow ARM systems run
> better, what's the point?
> 
> So in summary I suggest "we" (Greg? or is it Seth's responsibility?)
> should just back out that whole USE_PGTABLE_MAPPING chunk of code
> introduced with f553646. Then Russell can carry on randconfiging and I
> can build for SMP and UP and get the same code.. with less bugs.

I get that you want to have this fixed right now. I think having it
fixed the right way is a better choice. Lets discuss that first
before we start tossing patches to disable parts of it.

