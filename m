Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbaBKMAE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:00:04 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:59271 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbaBKL76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 06:59:58 -0500
Date: Tue, 11 Feb 2014 12:59:52 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Sagar Arun Kamble <sagar.a.kamble@intel.com>
Cc: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
	<ville.syrjala@linux.intel.com>,
        intel-gfx@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH v5 11/11] drm/i915: Calling rotate and
 inverse rotate transformations after clipping
Message-ID: <20140211115952.GJ17001@phenom.ffwll.local>
Mail-Followup-To: Sagar Arun Kamble <sagar.a.kamble@intel.com>,
	Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>,
	intel-gfx@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <1392017478-4945-1-git-send-email-sagar.a.kamble@intel.com>
 <1392017478-4945-12-git-send-email-sagar.a.kamble@intel.com>
 <20140210133257.GK3891@intel.com>
 <1392118351.28501.21.camel@sagar-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392118351.28501.21.camel@sagar-desktop>
X-Operating-System: Linux phenom 3.12.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 05:02:31PM +0530, Sagar Arun Kamble wrote:
> On Mon, 2014-02-10 at 15:32 +0200, Ville Syrjälä wrote:
> > On Mon, Feb 10, 2014 at 01:01:18PM +0530, sagar.a.kamble@intel.com wrote:
> > > From: Sagar Kamble <sagar.a.kamble@intel.com>
> > > 
> > > With clipped sprites these transformations are not working. these
> > > functions transform complete sprite irrespective of clipping present.
> > > This leads to invisible portion of sprite show up when rotate 180 if
> > > it was out of visible area before.
> > > 
> > > v4: Moved rotate transform for source rectangle after clipping.
> > > Added rotate and inverse rotate transform for destination rect.
> > 
> > Still NAK.
> > 
> > I just pushed rotation support to my glplane test app [1], and with
> > with that my rotated clipping code works exactly as intended.
> > 
> > [1] git://gitorious.org/vsyrjala/glplane.git
> I tried this app. I think I am considering 180 degree rotation of
> clipped sprite plane differently. I have captured output with these
> rotate transforms moved before(clip-rotated) and after(rotate-clipped)
> clipping code.
> 
> Which is valid? Rotating entire sprite and then clipping or Rotating
> clipped portion?
> 
> Reference and Rotated output is attached FYI.
> 
> If rotating entire sprite is correct then this patch 11/11 is not needed
> and can be abandoned.

I think doing the clipping first (as a viewport) and then rotating the
viewport makes more sense to me. Dunno what other people think, but I
guess we should document that somewhere.
-Daniel

> 
> thanks,
> Sagar
> > > 
> > > Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> > > Cc: Jani Nikula <jani.nikula@linux.intel.com>
> > > Cc: David Airlie <airlied@linux.ie>
> > > Cc: dri-devel@lists.freedesktop.org
> > > Cc: linux-kernel@vger.kernel.org
> > > Cc: vijay.a.purushothaman@intel.com
> > > Signed-off-by: Sagar Kamble <sagar.a.kamble@intel.com>
> > > ---
> > >  drivers/gpu/drm/i915/intel_sprite.c | 16 ++++++++++++----
> > >  1 file changed, 12 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/gpu/drm/i915/intel_sprite.c b/drivers/gpu/drm/i915/intel_sprite.c
> > > index 62b9f84..799f6a9 100644
> > > --- a/drivers/gpu/drm/i915/intel_sprite.c
> > > +++ b/drivers/gpu/drm/i915/intel_sprite.c
> > > @@ -769,9 +769,6 @@ intel_update_plane(struct drm_plane *plane, struct drm_crtc *crtc,
> > >  	max_scale = intel_plane->max_downscale << 16;
> > >  	min_scale = intel_plane->can_scale ? 1 : (1 << 16);
> > >  
> > > -	drm_rect_rotate(&src, fb->width << 16, fb->height << 16,
> > > -			intel_plane->rotation);
> > > -
> > >  	hscale = drm_rect_calc_hscale_relaxed(&src, &dst, min_scale, max_scale);
> > >  	BUG_ON(hscale < 0);
> > >  
> > > @@ -785,6 +782,13 @@ intel_update_plane(struct drm_plane *plane, struct drm_crtc *crtc,
> > >  	crtc_w = drm_rect_width(&dst);
> > >  	crtc_h = drm_rect_height(&dst);
> > >  
> > > +	drm_rect_rotate(&src, fb->width << 16, fb->height << 16,
> > > +				intel_plane->rotation);
> > > +
> > > +	drm_rect_rotate(&dst, intel_crtc->config.pipe_src_w,
> > > +				intel_crtc->config.pipe_src_h,
> > > +				intel_plane->rotation);
> > > +
> > >  	if (visible) {
> > >  		/* check again in case clipping clamped the results */
> > >  		hscale = drm_rect_calc_hscale(&src, &dst, min_scale, max_scale);
> > > @@ -811,7 +815,11 @@ intel_update_plane(struct drm_plane *plane, struct drm_crtc *crtc,
> > >  				     drm_rect_height(&dst) * vscale - drm_rect_height(&src));
> > >  
> > >  		drm_rect_rotate_inv(&src, fb->width << 16, fb->height << 16,
> > > -				    intel_plane->rotation);
> > > +					intel_plane->rotation);
> > > +
> > > +		drm_rect_rotate_inv(&dst, intel_crtc->config.pipe_src_w,
> > > +					intel_crtc->config.pipe_src_h,
> > > +					intel_plane->rotation);
> > >  
> > >  		/* sanity check to make sure the src viewport wasn't enlarged */
> > >  		WARN_ON(src.x1 < (int) src_x ||
> > > -- 
> > > 1.8.5
> > > 
> > > _______________________________________________
> > > Intel-gfx mailing list
> > > Intel-gfx@lists.freedesktop.org
> > > http://lists.freedesktop.org/mailman/listinfo/intel-gfx
> > 
> 






-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
