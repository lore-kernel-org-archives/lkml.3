Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbaDOOZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:25:01 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39448 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbaDOOY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:24:59 -0400
Date: Tue, 15 Apr 2014 16:24:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Alex Deucher <alexdeucher@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>
Subject: Re: 15-rc1: radeon modesetting fails
Message-ID: <20140415142454.GA4826@pd.tnic>
References: <20140415070204.GA4806@pd.tnic>
 <534CFBD7.3070604@amd.com>
 <20140415120740.GA8306@nazgul.tnic>
 <CADnq5_PpPa_fbm=1KH__q-W2OuvfoHr2wquimQ8TCq=xwwYq_Q@mail.gmail.com>
 <534D2F6E.1020608@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <534D2F6E.1020608@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 03:09:02PM +0200, Christian König wrote:
> >Does reverting:
> >http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=32167016076f714f0e35e287fbead7de0f1fb179
> >fix the issue?  We may need to tweak the pll parameters for older asics.
> 
> Yeah, indeed the most likely cause. Please provide dmesg outputs created
> with drm.ebug=0xe for the old and the new kernel.

Hey, I finally haz 15-rc1+ running here. And I can even see something!

:-)

Ok, so I reverted 32167016076f ontop of Christian's drm-fixes-3.15-wip
branch which didn't apply cleanly. So I ended up fixing the conflicts
and got the revert below.

With it, the machine booted fine, so it looks like the revert worked.

Christian, I'm sending dmesg outputs in another private mail to you
guys.

Thanks.

---
From: Borislav Petkov <bp@suse.de>
Date: Tue, 15 Apr 2014 16:00:58 +0200
Subject: [PATCH] Revert "drm/radeon: rework finding display PLL numbers v2"

This reverts commit 32167016076f714f0e35e287fbead7de0f1fb179.

Conflicts:
	drivers/gpu/drm/radeon/radeon_display.c
---
 drivers/gpu/drm/radeon/radeon_display.c | 246 ++++++++++++--------------------
 1 file changed, 90 insertions(+), 156 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
index 2f42912031ac..83891923ac2d 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -34,8 +34,6 @@
 #include <drm/drm_crtc_helper.h>
 #include <drm/drm_edid.h>
 
-#include <linux/gcd.h>
-
 static void avivo_crtc_load_lut(struct drm_crtc *crtc)
 {
 	struct radeon_crtc *radeon_crtc = to_radeon_crtc(crtc);
@@ -802,57 +800,66 @@ int radeon_ddc_get_modes(struct radeon_connector *radeon_connector)
 }
 
 /* avivo */
+static void avivo_get_fb_div(struct radeon_pll *pll,
+			     u32 target_clock,
+			     u32 post_div,
+			     u32 ref_div,
+			     u32 *fb_div,
+			     u32 *frac_fb_div)
+{
+	u32 tmp = post_div * ref_div;
 
-/**
- * avivo_reduce_ratio - fractional number reduction
- *
- * @nom: nominator
- * @den: denominator
- * @nom_min: minimum value for nominator
- * @den_min: minimum value for denominator
- *
- * Find the greatest common divisor and apply it on both nominator and
- * denominator, but make nominator and denominator are at least as large
- * as their minimum values.
- */
-static void avivo_reduce_ratio(unsigned *nom, unsigned *den,
-			       unsigned nom_min, unsigned den_min)
+	tmp *= target_clock;
+	*fb_div = tmp / pll->reference_freq;
+	*frac_fb_div = tmp % pll->reference_freq;
+
+        if (*fb_div > pll->max_feedback_div)
+		*fb_div = pll->max_feedback_div;
+        else if (*fb_div < pll->min_feedback_div)
+                *fb_div = pll->min_feedback_div;
+}
+
+static u32 avivo_get_post_div(struct radeon_pll *pll,
+			      u32 target_clock)
 {
-	unsigned tmp;
-
-	/* reduce the numbers to a simpler ratio */
-	tmp = gcd(*nom, *den);
-	*nom /= tmp;
-	*den /= tmp;
-
-	/* make sure nominator is large enough */
-        if (*nom < nom_min) {
-		tmp = (nom_min + *nom - 1) / *nom;
-		*nom *= tmp;
-		*den *= tmp;
+	u32 vco, post_div, tmp;
+
+	if (pll->flags & RADEON_PLL_USE_POST_DIV)
+		return pll->post_div;
+
+	if (pll->flags & RADEON_PLL_PREFER_MINM_OVER_MAXP) {
+		if (pll->flags & RADEON_PLL_IS_LCD)
+			vco = pll->lcd_pll_out_min;
+		else
+			vco = pll->pll_out_min;
+	} else {
+		if (pll->flags & RADEON_PLL_IS_LCD)
+			vco = pll->lcd_pll_out_max;
+		else
+			vco = pll->pll_out_max;
 	}
 
-	/* make sure the denominator is large enough */
-	if (*den < den_min) {
-		tmp = (den_min + *den - 1) / *den;
-		*nom *= tmp;
-		*den *= tmp;
+	post_div = vco / target_clock;
+	tmp = vco % target_clock;
+
+	if (pll->flags & RADEON_PLL_PREFER_MINM_OVER_MAXP) {
+		if (tmp)
+			post_div++;
+	} else {
+		if (!tmp)
+			post_div--;
 	}
+
+	if (post_div > pll->max_post_div)
+		post_div = pll->max_post_div;
+	else if (post_div < pll->min_post_div)
+		post_div = pll->min_post_div;
+
+	return post_div;
 }
 
-/**
- * radeon_compute_pll_avivo - compute PLL paramaters
- *
- * @pll: information about the PLL
- * @dot_clock_p: resulting pixel clock
- * fb_div_p: resulting feedback divider
- * frac_fb_div_p: fractional part of the feedback divider
- * ref_div_p: resulting reference divider
- * post_div_p: resulting reference divider
- *
- * Try to calculate the PLL parameters to generate the given frequency:
- * dot_clock = (ref_freq * feedback_div) / (ref_div * post_div)
- */
+#define MAX_TOLERANCE 10
+
 void radeon_compute_pll_avivo(struct radeon_pll *pll,
 			      u32 freq,
 			      u32 *dot_clock_p,
@@ -861,126 +868,53 @@ void radeon_compute_pll_avivo(struct radeon_pll *pll,
 			      u32 *ref_div_p,
 			      u32 *post_div_p)
 {
-	unsigned fb_div_min, fb_div_max, fb_div;
-	unsigned post_div_min, post_div_max, post_div;
-	unsigned ref_div_min, ref_div_max, ref_div;
-	unsigned post_div_best, diff_best;
-	unsigned nom, den, tmp;
-
-	/* determine allowed feedback divider range */
-	fb_div_min = pll->min_feedback_div;
-	fb_div_max = pll->max_feedback_div;
+	u32 target_clock = freq / 10;
+	u32 post_div = avivo_get_post_div(pll, target_clock);
+	u32 ref_div = pll->min_ref_div;
+	u32 fb_div = 0, frac_fb_div = 0, tmp;
 
-	if (pll->flags & RADEON_PLL_USE_FRAC_FB_DIV) {
-		fb_div_min *= 10;
-		fb_div_max *= 10;
-	}
-
-	/* determine allowed ref divider range */
 	if (pll->flags & RADEON_PLL_USE_REF_DIV)
-		ref_div_min = pll->reference_div;
-	else
-		ref_div_min = pll->min_ref_div;
-	ref_div_max = pll->max_ref_div;
+		ref_div = pll->reference_div;
 
-	/* determine allowed post divider range */
-	if (pll->flags & RADEON_PLL_USE_POST_DIV) {
-		post_div_min = pll->post_div;
-		post_div_max = pll->post_div;
-	} else {
-		unsigned target_clock = freq / 10;
-		unsigned vco_min, vco_max;
-
-		if (pll->flags & RADEON_PLL_IS_LCD) {
-			vco_min = pll->lcd_pll_out_min;
-			vco_max = pll->lcd_pll_out_max;
-		} else {
-			vco_min = pll->pll_out_min;
-			vco_max = pll->pll_out_max;
+	if (pll->flags & RADEON_PLL_USE_FRAC_FB_DIV) {
+		avivo_get_fb_div(pll, target_clock, post_div, ref_div, &fb_div, &frac_fb_div);
+		frac_fb_div = (100 * frac_fb_div) / pll->reference_freq;
+		if (frac_fb_div >= 5) {
+			frac_fb_div -= 5;
+			frac_fb_div = frac_fb_div / 10;
+			frac_fb_div++;
 		}
-
-		post_div_min = vco_min / target_clock;
-		if ((target_clock * post_div_min) < vco_min)
-			++post_div_min;
-		if (post_div_min < pll->min_post_div)
-			post_div_min = pll->min_post_div;
-
-		post_div_max = vco_max / target_clock;
-		if ((target_clock * post_div_max) > vco_max)
-			--post_div_max;
-		if (post_div_max > pll->max_post_div)
-			post_div_max = pll->max_post_div;
-	}
-
-	/* represent the searched ratio as fractional number */
-	nom = pll->flags & RADEON_PLL_USE_FRAC_FB_DIV ? freq : freq / 10;
-	den = pll->reference_freq;
-
-	/* reduce the numbers to a simpler ratio */
-	avivo_reduce_ratio(&nom, &den, fb_div_min, post_div_min);
-
-	/* now search for a post divider */
-	if (pll->flags & RADEON_PLL_PREFER_MINM_OVER_MAXP)
-		post_div_best = post_div_min;
-	else
-		post_div_best = post_div_max;
-	diff_best = ~0;
-
-	for (post_div = post_div_min; post_div <= post_div_max; ++post_div) {
-		unsigned diff = abs(den - den / post_div * post_div);
-		if (diff < diff_best || (diff == diff_best &&
-		    !(pll->flags & RADEON_PLL_PREFER_MINM_OVER_MAXP))) {
-
-			post_div_best = post_div;
-			diff_best = diff;
+		if (frac_fb_div >= 10) {
+			fb_div++;
+			frac_fb_div = 0;
 		}
-	}
-	post_div = post_div_best;
-
-	/* limit reference * post divider to a maximum */
-	ref_div_max = min(210 / post_div, ref_div_max);
-
-	/* get matching reference and feedback divider */
-	ref_div = max(den / post_div, 1u);
-	fb_div = nom;
-
-	/* we're almost done, but reference and feedback
-	   divider might be to large now */
-
-	tmp = ref_div;
-
-        if (fb_div > fb_div_max) {
-		ref_div = ref_div * fb_div_max / fb_div;
-		fb_div = fb_div_max;
-	}
-
-	if (ref_div > ref_div_max) {
-		ref_div = ref_div_max;
-		fb_div = nom * ref_div_max / tmp;
-	}
-
-	/* reduce the numbers to a simpler ratio once more */
-	/* this also makes sure that the reference divider is large enough */
-	avivo_reduce_ratio(&fb_div, &ref_div, fb_div_min, ref_div_min);
-
-	/* and finally save the result */
-	if (pll->flags & RADEON_PLL_USE_FRAC_FB_DIV) {
-		*fb_div_p = fb_div / 10;
-		*frac_fb_div_p = fb_div % 10;
 	} else {
-		*fb_div_p = fb_div;
-		*frac_fb_div_p = 0;
+		while (ref_div <= pll->max_ref_div) {
+			avivo_get_fb_div(pll, target_clock, post_div, ref_div,
+					 &fb_div, &frac_fb_div);
+			if (frac_fb_div >= (pll->reference_freq / 2))
+				fb_div++;
+			frac_fb_div = 0;
+			tmp = (pll->reference_freq * fb_div) / (post_div * ref_div);
+			tmp = (tmp * 10000) / target_clock;
+
+			if (tmp > (10000 + MAX_TOLERANCE))
+				ref_div++;
+			else if (tmp >= (10000 - MAX_TOLERANCE))
+				break;
+			else
+				ref_div++;
+		}
 	}
 
-	*dot_clock_p = ((pll->reference_freq * *fb_div_p * 10) +
-			(pll->reference_freq * *frac_fb_div_p)) /
-		       (ref_div * post_div * 10);
+	*dot_clock_p = ((pll->reference_freq * fb_div * 10) + (pll->reference_freq * frac_fb_div)) /
+		(ref_div * post_div * 10);
+	*fb_div_p = fb_div;
+	*frac_fb_div_p = frac_fb_div;
 	*ref_div_p = ref_div;
 	*post_div_p = post_div;
-
-	DRM_DEBUG_KMS("%d - %d, pll dividers - fb: %d.%d ref: %d, post %d\n",
-		      freq, *dot_clock_p, *fb_div_p, *frac_fb_div_p,
-		      ref_div, post_div);
+	DRM_DEBUG_KMS("%d, pll dividers - fb: %d.%d ref: %d, post %d\n",
+		      *dot_clock_p, fb_div, frac_fb_div, ref_div, post_div);
 }
 
 /* pre-avivo */
-- 
1.9.0


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
