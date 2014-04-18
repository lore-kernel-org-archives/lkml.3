Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566AbaDRMkO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 08:40:14 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41196 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbaDRMkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 08:40:09 -0400
Date: Fri, 18 Apr 2014 14:40:04 +0200
From: Borislav Petkov <bp@alien8.de>
To: Matthias Graf <matthias.graf@st.ovgu.de>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        alexander.deucher@amd.com
Cc: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>
Subject: Re: PROBLEM: Fatal Machine Check >= 3.13.5-101.fc19.x86_64
Message-ID: <20140418124004.GF4385@pd.tnic>
References: <532C97DF.9010201@st.ovgu.de>
 <20140321201352.GC1338@pd.tnic>
 <533069E4.10002@st.ovgu.de>
 <533C1B47.8080709@st.ovgu.de>
 <20140416142232.GF16741@pd.tnic>
 <534F73F6.7050804@st.ovgu.de>
 <20140417130207.GB4321@pd.tnic>
 <5350EDAE.8020101@st.ovgu.de>
 <20140418094523.GB4385@pd.tnic>
 <53511066.70005@st.ovgu.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53511066.70005@st.ovgu.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 01:45:42PM +0200, Matthias Graf wrote:
> I applied your patch to linus' current master (3.15.0-rc1+) and indeed
> it does solve the issue for me!
> 
> Thanks for your help.
> 
> I would appreciated if you keep me posted on updates.

Ok, goodie, so this one really causes problems.

Btw, please try not to top-post:

A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

Thanks.

Btw, you could check whether your BIOS has an update, who knows, it
could be addressing this issue too. Simply look at the first couple of
lines of dmidecode output to check your current BIOS version and then go
and check, I think your board is Gigabyte, their site for updates.

Alex, Christian, guys, it looks like this commit below is causing some
sort of a core stall/livelock on Matthias' machine:

Hardware event. This is not a software error.
CPU 0 BANK 0
MCG status:RIPV MCIP
MCi status:
Uncorrected error
Error enabled
Processor context corrupt
MCA: BUS Level-0 Local-CPU-originated-request Generic Memory-access Request-did-not-timeout Error
BQ_DCU_READ_TYPE BQ_ERR_HARD_TYPE BQ_ERR_HARD_TYPE
timeout BINIT (ROB timeout). No micro-instruction retired for some time
STATUS b200004000000800 MCGSTATUS 5

Reverting it fixes the issue so it must be something DPM-related on
RV770 in conjunction with his platform. I'm leaving in the rest for
reference, if you need more info, the thread starts here:

http://lkml.kernel.org/r/532C727F.1080803@st.ovgu.de

Thanks.

> >> Fine-grained bisection result:
> >>
> >> ab70b1dde73ff4525c3cd51090c233482c50f217 is the first bad commit
> >> commit ab70b1dde73ff4525c3cd51090c233482c50f217
> >> Author: Alex Deucher <alexander.deucher@amd.com>
> >> Date:   Fri Nov 1 15:16:02 2013 -0400
> >>
> >>     drm/radeon: enable DPM by default on r7xx asics
> >>
> >>     Seems to be stable on them.
> >>
> >>     Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> >>
> >> :040000 040000 f3262029b868df4d882f64b4deba6b9230e307ea
> >> 1f1dfca42763703a56e3cc82bb103608a24be94e M	drivers
> >>
> >>
> >> Result is reasonable: I have a RV770 chip.
> > 
> > Yes it is.
> > 
> >> (Additional) Bug Report for Reference:
> >> https://bugzilla.redhat.com/show_bug.cgi?id=1085785
> >>
> >> Thanks for the instructions Borislav! At first, I was not completely
> >> sure what you expected me to do (this is my first kernel bug report :)).
> > 
> > And you're doing good so far! :-)
> > 
> >> If there is anymore more I can help you with, let me know.
> > 
> > Ok, now we want to confirm that this patch is *actually* the culprit by
> > reverting it. Simply pull Linus' master branch to have the latest tree,
> > and then do:
> > 
> > $ git checkout -b radeon-revert master
> > 
> > so that you land on a throwaway branch where we can play. Then normally you
> > would do
> > 
> > $ git revert ab70b1dde73ff4525c3cd51090c233482c50f217
> > 
> > but that causes conflicts so I did it for you, see below. Simply apply
> > this patch ontop *without* doing the revert with git. Then build, boot
> > and test. We want to see whether it still generates those ROB timeout
> > machine checks. If all looks ok, then we're pretty sure we need to talk
> > about DPM with your GPU on your platform with Alex. :-)
> > 
> > Feel free to ask any questions should something be not clear.
> > 
> > Thanks.
> > 
> > ---
> > From 0790e872f6d3c986d9ed36b850fd9d799dc422f9 Mon Sep 17 00:00:00 2001
> > From: Borislav Petkov <bp@suse.de>
> > Date: Fri, 18 Apr 2014 11:43:12 +0200
> > Subject: [PATCH] Revert "drm/radeon: enable DPM by default on r7xx asics"
> > 
> > This reverts commit ab70b1dde73ff4525c3cd51090c233482c50f217.
> > 
> > Conflicts:
> > 	drivers/gpu/drm/radeon/radeon_pm.c
> > ---
> >  drivers/gpu/drm/radeon/radeon_pm.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/radeon/radeon_pm.c b/drivers/gpu/drm/radeon/radeon_pm.c
> > index ee738a524639..af693c4746da 100644
> > --- a/drivers/gpu/drm/radeon/radeon_pm.c
> > +++ b/drivers/gpu/drm/radeon/radeon_pm.c
> > @@ -1257,6 +1257,10 @@ int radeon_pm_init(struct radeon_device *rdev)
> >  	case CHIP_RV670:
> >  	case CHIP_RS780:
> >  	case CHIP_RS880:
> > +	case CHIP_RV770:
> > +	case CHIP_RV730:
> > +	case CHIP_RV710:
> > +	case CHIP_RV740:
> >  	case CHIP_BARTS:
> >  	case CHIP_TURKS:
> >  	case CHIP_CAICOS:
> > @@ -1273,10 +1277,6 @@ int radeon_pm_init(struct radeon_device *rdev)
> >  		else
> >  			rdev->pm.pm_method = PM_METHOD_PROFILE;
> >  		break;
> > -	case CHIP_RV770:
> > -	case CHIP_RV730:
> > -	case CHIP_RV710:
> > -	case CHIP_RV740:
> >  	case CHIP_CEDAR:
> >  	case CHIP_REDWOOD:
> >  	case CHIP_JUNIPER:
> > 

> diff --git a/drivers/gpu/drm/radeon/radeon_pm.c b/drivers/gpu/drm/radeon/radeon_pm.c
> index ee738a524639..af693c4746da 100644
> --- a/drivers/gpu/drm/radeon/radeon_pm.c
> +++ b/drivers/gpu/drm/radeon/radeon_pm.c
> @@ -1257,6 +1257,10 @@ int radeon_pm_init(struct radeon_device *rdev)
>  	case CHIP_RV670:
>  	case CHIP_RS780:
>  	case CHIP_RS880:
> +	case CHIP_RV770:
> +	case CHIP_RV730:
> +	case CHIP_RV710:
> +	case CHIP_RV740:
>  	case CHIP_BARTS:
>  	case CHIP_TURKS:
>  	case CHIP_CAICOS:
> @@ -1273,10 +1277,6 @@ int radeon_pm_init(struct radeon_device *rdev)
>  		else
>  			rdev->pm.pm_method = PM_METHOD_PROFILE;
>  		break;
> -	case CHIP_RV770:
> -	case CHIP_RV730:
> -	case CHIP_RV710:
> -	case CHIP_RV740:
>  	case CHIP_CEDAR:
>  	case CHIP_REDWOOD:
>  	case CHIP_JUNIPER:




-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
