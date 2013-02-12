Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683Ab3BLXCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 18:02:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51923 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616Ab3BLXCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 18:02:51 -0500
Date: Tue, 12 Feb 2013 21:02:45 -0200
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [ 109/173] drm/i915: Close race between processing unpin task
 and queueing the flip
Message-ID: <20130212230244.GA3111@herton-Z68MA-D2H-B3>
References: <20121228190330.025298996@decadent.org.uk>
 <20121228190353.093271782@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121228190353.093271782@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 08:05:19PM +0100, Ben Hutchings wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Chris Wilson <chris@chris-wilson.co.uk>
> 
> commit e7d841ca03b7ab668620045cd7b428eda9f41601 upstream.
> 
[...]
> @@ -7157,6 +7176,10 @@ static int intel_gen4_queue_flip(struct
>  	pf = 0;
>  	pipesrc = I915_READ(PIPESRC(intel_crtc->pipe)) & 0x0fff0fff;
>  	OUT_RING(pf | pipesrc);
> +
> +	intel_mark_page_flip_active(intel_crtc);
> +
> +	intel_mark_page_flip_active(intel_crtc);
>  	ADVANCE_LP_RING();
>  	return 0;
>  

There is a problem with this patch on 3.2. First we have
intel_mark_page_flip_active duplicated on intel_gen4_queue_flip here
(harmless), but one missing call for it in intel_gen6_queue_flip

Reached to this after reproducing which is probably the same
problem people are reporting here: http://bugs.launchpad.net/bugs/1119809
A bisect pointed to this change, and the following diff fixed the issue
on the i915 based machine I used to reproduce:

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 4da3c7e..ce23961 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7155,8 +7155,6 @@ static int intel_gen4_queue_flip(struct drm_device *dev,
 	OUT_RING(pf | pipesrc);
 
 	intel_mark_page_flip_active(intel_crtc);
-
-	intel_mark_page_flip_active(intel_crtc);
 	ADVANCE_LP_RING();
 	return 0;
 
@@ -7192,6 +7190,8 @@ static int intel_gen6_queue_flip(struct drm_device *dev,
 	pf = I915_READ(PF_CTL(intel_crtc->pipe)) & PF_ENABLE;
 	pipesrc = I915_READ(PIPESRC(intel_crtc->pipe)) & 0x0fff0fff;
 	OUT_RING(pf | pipesrc);
+
+	intel_mark_page_flip_active(intel_crtc);
 	ADVANCE_LP_RING();
 	return 0;
 

-- 
[]'s
Herton
