Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbaE2XVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 19:21:20 -0400
Received: from know-smtprelay-omc-10.server.virginmedia.net ([80.0.253.74]:51018
	"EHLO know-smtprelay-omc-10.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbaE2XVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 19:21:18 -0400
X-Originating-IP: [81.106.150.188]
X-Spam: 0
X-Authority: v=2.1 cv=FZq5xfO6 c=1 sm=1 tr=0 a=DGj713NdaxKrsjjgQne7PA==:117
 a=DGj713NdaxKrsjjgQne7PA==:17 a=J0QyKEt1u0cA:10 a=9WyvZRSfSd8A:10
 a=uObrxnre4hsA:10 a=IkcTkHD0fZMA:10 a=NLZqzBF-AAAA:8 a=pGLkceISAAAA:8
 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=D19gQVrFAAAA:8 a=-owk2n_wi5d71GDPA7AA:9
 a=QEXdDO2ut3YA:10 a=MSl-tDqOz04A:10 a=7DSvI1NPTFQA:10 a=_dQi-Dcv4p4A:10
Date: Fri, 30 May 2014 00:21:15 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Alex Deucher <alexdeucher@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Dave Airlie <airlied@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Resume from suspend broken in 3.15. (bisected)
Message-ID: <20140529232115.GA15301@milliways>
References: <20140528172521.GA9945@milliways>
 <20140528234927.GA18638@milliways>
 <CADnq5_PWigm5e4CwnfW+3TaohbFo82uDpiCMftL=OmRvCkJQzQ@mail.gmail.com>
 <20140529060311.GU17724@mwanda>
 <CADnq5_NxXDfGEquFZX_CnhNEAKEomijQCX+Hn3kQhAFBZOge1g@mail.gmail.com>
 <20140529205720.GD19050@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140529205720.GD19050@phenom.ffwll.local>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 10:57:20PM +0200, Daniel Vetter wrote:
> On Thu, May 29, 2014 at 10:47 PM, Alex Deucher <alexdeucher@gmail.com> wrote:
> > On Thu, May 29, 2014 at 2:03 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> >> On Wed, May 28, 2014 at 08:26:53PM -0400, Alex Deucher wrote:
> >>> On Wed, May 28, 2014 at 7:49 PM, Ken Moffat <zarniwhoop@ntlworld.com> wrote:
> >>> > On Wed, May 28, 2014 at 06:25:21PM +0100, Ken Moffat wrote:
> >>> >> Hi Daniel,
> >>> >>
> >>> >
> >>> >  [ correcting details, confirming that reverting this does fix the
> >>> > problem, adding Cc:s ]
> >>> >
> >>> >>  I've only started full testing of 3.15 on one of my machines now
> >>> >> that -rc7 has been released (this one had two issues in the radeon
> >>> >> code, second was fixed in rc7).  Unfortunately, suspend to RAM
> >>> >> (pm-suspend), or rather the wake-up, is broken on this box [ my
> >>> >> other two boxes are fine in rc7 ].
> >>> >>
> >>> >> Bisection identified one of your commits -
> >>> >>
> >>> >> commit 25f397a429dfa43f22c278d0119a60a343aa568f
> >>> >> Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> >>> >> Date:   Fri Jul 19 18:57:11 2013 +0200
> >>> >>
> >>> >>     drm/crtc-helper: explicit DPMS on after modeset
> >>> >>
> >>> >>     Atm the crtc helper implementation of set_config has really
> >>> >>     inconsisten semantics: If just an fb update is good enough, dpms state
> >>> >>     will be left as-is, but if we do a full modeset we force everything to
> >>> >>     dpms on.
> >>> >>
> >>> >>     This change has already been applied to the i915 modeset code in
> >>> >>
> >>> >> ('git show' stops at that point)
> >>> >
> >>> >  update : I've no idea what was going on there, nor for the problem
> >>> > with attempting to revert it.  I've now gone back into git,
> >>> > extracted the full commit to a file with 'git show', and then used
> >>> > git apply -R to revert it from 3.15-rc7.  That version wakes up from
> >>> > suspend to RAM, 3.15-rc7 itself did not.
> >>> >
> >>> >  Maybe I was still in git log when I thought I was on the command
> >>> > line.  Anyway, snipping git's view of my failed attempt to revert
> >>> > it, and adding Dan and Alex who were CC'd on the commit.
> >>> >
> >>>
> >>> Duplicate of:
> >>> https://bugzilla.kernel.org/show_bug.cgi?id=74751
> >>> and also reported here:
> >>> https://lkml.org/lkml/2014/5/2/388
> >>> Unless there is a good reason to keep the commit, I'd say let's just revert it.
> >>>
> >>
> >> Yes.  Let's revert it.
> >
> > The actual bad commit is 177cf92de4aa97ec1435987e91696ed8b5023130, but
> > for some reason git bisect always comes up with
> > 25f397a429dfa43f22c278d0119a60a343aa568f which has been in the tree
> > for almost a year now.  I don't know why.
> 
> Quick patch which is worth a shot before we revert 177cf.
> -Daniel
> 
> diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
> index c2edb2d14030..cf5d299cc623 100644
> --- a/drivers/gpu/drm/radeon/radeon_device.c
> +++ b/drivers/gpu/drm/radeon/radeon_device.c
> @@ -1534,11 +1534,6 @@ int radeon_resume_kms(struct drm_device *dev, bool resume, bool fbcon)
>  
>  	radeon_restore_bios_scratch_regs(rdev);
>  
> -	if (fbcon) {
> -		radeon_fbdev_set_suspend(rdev, 0);
> -		console_unlock();
> -	}
> -
>  	/* init dig PHYs, disp eng pll */
>  	if (rdev->is_atom_bios) {
>  		radeon_atom_encoder_init(rdev);
> @@ -1563,6 +1558,12 @@ int radeon_resume_kms(struct drm_device *dev, bool resume, bool fbcon)
>  	}
>  
>  	drm_kms_helper_poll_enable(dev);
> +
> +	if (fbcon) {
> +		radeon_fbdev_set_suspend(rdev, 0);
> +		console_unlock();
> +	}
> +
>  	return 0;
>  }
>  
 Thanks, Daniel.

 That works for me (with -rc7) on my A4 Trinity (Radeon HD7480D).  I
also tested it on my other radeon (RS780L - Radeon 3000) and saw no
problems in suspend-resume.  If useful, you can add my tested-by.

ĸen
-- 
Nanny Ogg usually went to bed early. After all, she was an old lady.
Sometimes she went to bed as early as 6 a.m.
