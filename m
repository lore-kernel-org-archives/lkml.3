Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab3KNXjE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 18:39:04 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47222 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab3KNXjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 18:39:00 -0500
Date: Fri, 15 Nov 2013 00:39:32 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Rodrigo Vivi <rodrigo.vivi@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx@lists.freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Duncan Laurie <dlaurie@chromium.org>
Subject: Re: [PATCH] i915: Use 120MHz LVDS SSC clock for gen5/gen6/gen7
Message-ID: <20131114233932.GK22741@phenom.ffwll.local>
Mail-Followup-To: Rodrigo Vivi <rodrigo.vivi@gmail.com>,
	Olof Johansson <olof@lixom.net>, intel-gfx@lists.freedesktop.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Duncan Laurie <dlaurie@chromium.org>
References: <1384394383-8582-1-git-send-email-olof@lixom.net>
 <20131114165142.GA11645@bratislava.fso.intel.com>
 <CAOesGMjbwV=kJUHPnr5Nk7sYTXjM4Z3kxqDUDNJEbda8HWNFTA@mail.gmail.com>
 <20131114194036.GA3220@bratislava.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131114194036.GA3220@bratislava.amr.corp.intel.com>
X-Operating-System: Linux phenom 3.12.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 05:40:36PM -0200, Rodrigo Vivi wrote:
> On Thu, Nov 14, 2013 at 09:36:10AM -0800, Olof Johansson wrote:
> > On Thu, Nov 14, 2013 at 8:53 AM, Rodrigo Vivi <rodrigo.vivi@gmail.com> wrote:
> > > On Wed, Nov 13, 2013 at 05:59:43PM -0800, Olof Johansson wrote:
> > >> From: Duncan Laurie <dlaurie@chromium.org>
> > >>
> > >> We had been using a DMI table workaround to select the right
> > >> frequency for devices, but this is fragile and must be updated
> > >> with every new platform.
> > >>
> > >> Instead the default case when VBT is missing is changed to use
> > >> 120MHz clock for LVDS SSC for these generations.
> > >>
> > >> The docs for 2010-Core, SandyBridge, and IvyBridge all indicate
> > >> that the reference frequency for LVDS is 120MHz:
> > >>
> > >> "2010 Core"
> > >> http://intellinuxgraphics.org/IHD_OS_Vol3_Part3r2.pdf
> > >> page 38
> > >> Reference Frequency: 120MHz for CRT and LVDS.  100MHz for the FDI.
> > >>
> > >> "2011 SandyBridge"
> > >> http://intellinuxgraphics.org/documentation/SNB/IHD_OS_Vol3_Part3.pdf
> > >> page 33
> > >> Reference Frequency: 120MHz for CRT, HDMI, LVDS.  100MHz for the FDI.
> > >>
> > >> "2012 IvyBridge"
> > >> http://intellinuxgraphics.org/documentation/IVB/IHD_OS_Vol3_Part4.pdf
> > >> page 27
> > >> Reference Frequency: 120 MHz for CRT, HDMI, LVDS, 100MHz for the FDI.
> > >
> > > Checked. You are right.
> > > And actually true even for HSW and BDW. 120 is the default and 100 is for test mode.
> > 
> > Yeah, the patch predates HSW/BDW, so it was not mentioned.
> > 
> > >> Signed-off-by: Duncan Laurie <dlaurie@chromium.org>
> > >> [olof: Fixup for recent base, switched from if/else to single call]
> > >> Signed-off-by: Olof Johansson <olof@lixom.net>
> > >> ---
> > >>
> > >> Daniel,
> > >>
> > >> This applies on top of -next, which I'm presuming is close to your
> > >> for-3.13 base right now. It'd be good to see this go in since it's needed
> > >> to boot on Chromebooks (with developer mode off), and is thus blocking
> > >> testing next/mainline on a regular basis here.
> > >>
> > >> Thanks!
> > >>
> > >> -Olof
> > >>
> > >>  drivers/gpu/drm/i915/intel_bios.c | 7 ++++++-
> > >>  1 file changed, 6 insertions(+), 1 deletion(-)
> > >>
> > >> diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios.c
> > >> index 6dd622d733b9..e4fba39631a5 100644
> > >> --- a/drivers/gpu/drm/i915/intel_bios.c
> > >> +++ b/drivers/gpu/drm/i915/intel_bios.c
> > >> @@ -790,7 +790,12 @@ init_vbt_defaults(struct drm_i915_private *dev_priv)
> > >>
> > >>       /* Default to using SSC */
> > >>       dev_priv->vbt.lvds_use_ssc = 1;
> > >> -     dev_priv->vbt.lvds_ssc_freq = intel_bios_ssc_frequency(dev, 1);
> > >> +     /*
> > >> +      * Core/SandyBridge/IvyBridge use alternative (120MHz) reference
> > >> +      * clock for LVDS.
> > >> +      */
> > >> +     dev_priv->vbt.lvds_ssc_freq = intel_bios_ssc_frequency(dev,
> > >> +                     !HAS_PCH_SPLIT(dev));
> > >
> > > I'm just not convinced this is the right way to fix this here.
> > > Mainly because for most of platforms the alternate is 100 and default is 120.
> > > The ideal in my opinion should be to invert the alternate inside ssc_freqeuncy function and use the exception, that is probably IS_PINEVIEW(dev)...
> > >
> > > Not sure though... just a guess since this alternate was implemented for pineview...
> > 
> > Seeing the history of some of this code (changes, followed by reverts,
> > etc), I wanted to stay conservative with what we know works from a few
> > years in the field by now.
> 
> Stay conservative is good, but what I don't like is just the inverted logic... or maybe just the "alternate" name.
> 
> > The vbt defaults are only used by
> > Chromebooks, as far as I know, so it's not a code path shared with
> > other platforms today.
> 
> Are you sure? I don't know who is really setting vbt or going to defaults, but it is possible to have any one using it right now... anyway another reason to stay conservative...
> 
> > Also, the ssc_freq bit from the vbios table is
> > passed into this function, so I don't think there's much point in
> > reversing the logic in there just for one of the two code paths.
> 
> yeah, maybe just the name alternate is killing me here...
> 
> > 
> > Finally, from elsewhere in the same file:
> > 
> > /*
> >  * The genX designation typically refers to the render engine, so render
> >  * capability related checks should use IS_GEN, while display and other checks
> >  * have their own (e.g. HAS_PCH_SPLIT for ILK+ display, IS_foo for
> > particular
> >  * chips, etc.).
> >  */
> 
> with this I agree..
> 
> > 
> > Since this is display and not rendering related, that seems like the
> > right thing to base it on instead of generation tests.
> > 
> > I'm open for suggestions on improvements though, of course.
> 
> I don't have a real suggestion here... only bikesheds... maybe on the alternate name ;)
> 
> But either way, it seems to work and right since default is 120 for those platforms... So, feel free to use:
> Reviewed-by: Rodrigo Vivi <rodrigo.vivi@gmail.com>

Queued for -next, thanks for the patch.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
