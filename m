Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346Ab3BMASS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 19:18:18 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37545 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753814Ab3BMASQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 19:18:16 -0500
Date: Wed, 13 Feb 2013 00:18:12 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Message-ID: <20130213001812.GV13292@decadent.org.uk>
References: <20121228190330.025298996@decadent.org.uk>
 <20121228190353.093271782@decadent.org.uk>
 <20130212230244.GA3111@herton-Z68MA-D2H-B3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130212230244.GA3111@herton-Z68MA-D2H-B3>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [ 109/173] drm/i915: Close race between processing unpin task
 and queueing the flip
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 09:02:45PM -0200, Herton Ronaldo Krzesinski wrote:
> On Fri, Dec 28, 2012 at 08:05:19PM +0100, Ben Hutchings wrote:
> > 3.2-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Chris Wilson <chris@chris-wilson.co.uk>
> > 
> > commit e7d841ca03b7ab668620045cd7b428eda9f41601 upstream.
> > 
> [...]
> > @@ -7157,6 +7176,10 @@ static int intel_gen4_queue_flip(struct
> >  	pf = 0;
> >  	pipesrc = I915_READ(PIPESRC(intel_crtc->pipe)) & 0x0fff0fff;
> >  	OUT_RING(pf | pipesrc);
> > +
> > +	intel_mark_page_flip_active(intel_crtc);
> > +
> > +	intel_mark_page_flip_active(intel_crtc);
> >  	ADVANCE_LP_RING();
> >  	return 0;
> >  
> 
> There is a problem with this patch on 3.2. First we have
> intel_mark_page_flip_active duplicated on intel_gen4_queue_flip here
> (harmless), but one missing call for it in intel_gen6_queue_flip

Yes, Julien Cristau also pointed this out.  I'm not sure how this
happened.

It does seem that quilt (presumably calling GNU patch?) can sometimes
apply two hunks that overlap, and maybe that's part of the explanation
for this.  In 3.2.38 there was one patch where a blank line was the
last line of context in one hunk and also the first line of context
for the next hunk.  (Upstream, there was an extra statement in
between, but this was not present in 3.2.y.)  quilt applied the patch
without complaint (with --fuzz=0) but git am rejected it.

> Reached to this after reproducing which is probably the same
> problem people are reporting here: http://bugs.launchpad.net/bugs/1119809
> A bisect pointed to this change, and the following diff fixed the issue
> on the i915 based machine I used to reproduce:
> 
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index 4da3c7e..ce23961 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -7155,8 +7155,6 @@ static int intel_gen4_queue_flip(struct drm_device *dev,
>  	OUT_RING(pf | pipesrc);
>  
>  	intel_mark_page_flip_active(intel_crtc);
> -
> -	intel_mark_page_flip_active(intel_crtc);
>  	ADVANCE_LP_RING();
>  	return 0;
>  
> @@ -7192,6 +7190,8 @@ static int intel_gen6_queue_flip(struct drm_device *dev,
>  	pf = I915_READ(PF_CTL(intel_crtc->pipe)) & PF_ENABLE;
>  	pipesrc = I915_READ(PIPESRC(intel_crtc->pipe)) & 0x0fff0fff;
>  	OUT_RING(pf | pipesrc);
> +
> +	intel_mark_page_flip_active(intel_crtc);
>  	ADVANCE_LP_RING();
>  	return 0;
>  
 
Thanks, but I have the same fix in the patch queue already.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
