Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab3FYUGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 16:06:17 -0400
Received: from oproxy14-pub.unifiedlayer.com ([67.222.51.224]:54818 "HELO
	oproxy14-pub.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751721Ab3FYUGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 16:06:16 -0400
Date: Tue, 25 Jun 2013 13:08:16 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Dave Airlie <airlied@redhat.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: Linux 3.10-rc7
Message-ID: <20130625130816.55e6cb80@jbarnes-desktop>
In-Reply-To: <B8EFE96D1287C24090BAD9D858E15E617305B4@sisaex02sj>
References: <CA+55aFz1yMZ1q5daHdTA91pW5QtQ1Yids1dLD9b2JC-ruicNQw@mail.gmail.com>
	<B8EFE96D1287C24090BAD9D858E15E6172FFB9@sisaex02sj>
	<CA+55aFxuB_nx8fZ_kN8U=fMFOq43cKZC_HJbj=6vKo7-fDqNuw@mail.gmail.com>
	<CAKMK7uH0q1vSaVRigtZD2pf5ZeVLEv1sn+tsiO7ZWjJdt=DwBA@mail.gmail.com>
	<20130625125437.6e7bb2d4@jbarnes-desktop>
	<B8EFE96D1287C24090BAD9D858E15E617305B4@sisaex02sj>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jun 2013 19:59:28 +0000
Shuah Khan <shuah.kh@samsung.com> wrote:

> On 06/25/2013 01:52 PM, Jesse Barnes wrote:
> > On Tue, 25 Jun 2013 21:37:37 +0200
> > Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> >
> 
> >>
> >> Adding more lists to cc + Jesse since he's the guilty one for the
> >> vt-switchless state restore stuff.
> >
> > Yeah, looks like we don't fetch the PLL state on resume from hibernate,
> > leading to this warning.  The refcount is nonzero, indicating the pll
> > is in use, but the active field is clear, which means we're missing an
> > update somewhere.
> >
> > Shuah, just to confirm, does your resume actually work ok aside from
> > the warning?  I *think* it's harmless in this case, but does indicate a
> > real bug in our state tracking... trying to come up with a patch now.
> >
> > Thanks,
> >
> 
> Resume works just fine. I see it take longer for it to suspend compared 
> to 3.9.7 and then resumes just fine. Suspend taking longer very well 
> could be because of this warn_on. Other than this warn_on I haven't 
> noticed any other problems.

Here's the patch I'm testing now, can you give it a try?

-- 
Jesse Barnes, Intel Open Source Technology Center

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 56746dc..df0caf0 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -9289,6 +9289,49 @@ void i915_redisable_vga(struct drm_device *dev)
 	}
 }
 
+static void ironlake_crtc_pll_get(struct intel_crtc *crtc)
+{
+	struct drm_device *dev = crtc->base.dev;
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	u32 dpll_sel;
+
+	if (HAS_PCH_IBX(dev_priv->dev))
+		crtc->pch_pll = &dev_priv->pch_plls[crtc->pipe];
+
+	if (HAS_PCH_CPT(dev_priv->dev)) {
+		dpll_sel = I915_READ(PCH_DPLL_SEL);
+
+		switch (crtc->pipe) {
+		case PIPE_A:
+			if ((dpll_sel & TRANSA_DPLL_ENABLE) &&
+			    (dpll_sel & TRANSA_DPLLB_SEL))
+				crtc->pch_pll = &dev_priv->pch_plls[1];
+			else if (dpll_sel & TRANSA_DPLL_ENABLE)
+				crtc->pch_pll = &dev_priv->pch_plls[0];
+			break;
+		case PIPE_B:
+			if ((dpll_sel & TRANSB_DPLL_ENABLE) &&
+			    (dpll_sel & TRANSB_DPLLB_SEL))
+				crtc->pch_pll = &dev_priv->pch_plls[1];
+			else if (dpll_sel & TRANSB_DPLL_ENABLE)
+				crtc->pch_pll = &dev_priv->pch_plls[0];
+			break;
+		case PIPE_C:
+			if ((dpll_sel & TRANSC_DPLL_ENABLE) &&
+			    (dpll_sel & TRANSC_DPLLB_SEL))
+				crtc->pch_pll = &dev_priv->pch_plls[1];
+			else if (dpll_sel & TRANSC_DPLL_ENABLE)
+				crtc->pch_pll = &dev_priv->pch_plls[0];
+			break;
+		default:
+			BUG();
+		}
+	}
+
+	crtc->pch_pll->refcount++;
+	crtc->pch_pll->active = 1;
+}
+
 /* Scan out the current hw modeset state, sanitizes it and maps it into the drm
  * and i915 state tracking structures. */
 void intel_modeset_setup_hw_state(struct drm_device *dev,
@@ -9346,6 +9389,9 @@ setup_pipes:
 
 		crtc->base.enabled = crtc->active;
 
+		if (crtc->active && HAS_PCH_SPLIT(dev))
+			ironlake_crtc_pll_get(crtc);
+
 		DRM_DEBUG_KMS("[CRTC:%d] hw state readout: %s\n",
 			      crtc->base.base.id,
 			      crtc->active ? "enabled" : "disabled");

