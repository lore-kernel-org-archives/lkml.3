Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbaA1TmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 14:42:21 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:39244 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779AbaA1TmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 14:42:19 -0500
Date: Tue, 28 Jan 2014 20:42:14 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-gfx] Excessive WARN()s in Intel 915 driver
Message-ID: <20140128194214.GH7444@phenom.ffwll.local>
Mail-Followup-To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	Kernel development list <linux-kernel@vger.kernel.org>
References: <CAKMK7uFEzOKYjojVop1ouRsJWyeK-rnKH-udBxZcc9fwKCOV6w@mail.gmail.com>
 <Pine.LNX.4.44L0.1401081102040.1659-100000@iolanthe.rowland.org>
 <20140108161713.GT4770@phenom.ffwll.local>
 <20140108184323.GL4800@intel.com>
 <CAKMK7uEZysj9NPiHOaRy5XTEt0yQ8Dew_gEYsiZMayZ98r6W3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKMK7uEZysj9NPiHOaRy5XTEt0yQ8Dew_gEYsiZMayZ98r6W3A@mail.gmail.com>
X-Operating-System: Linux phenom 3.12.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 06:17:00PM +0100, Daniel Vetter wrote:
> On Wed, Jan 8, 2014 at 7:43 PM, Ville Syrjälä
> <ville.syrjala@linux.intel.com> wrote:
> >
> > The log looks fairly clear to me:
> >
> > 1. initially panel fitter is enabled on pipe B, and pipe B is outputting
> >    to LVDS and VGA. Border is enabled.
> > 2. pipe A gets enabled outputting to LVDS. This will overwrite the
> >    LVDS border bits
> > 3. pipe B is still active so we do the state check, but as the LVDS
> >    border bits have been clobbered earlier, the state checker gets
> >    angry
> 
> Meh, I've been fairly dense the entire time. This is indeed the
> root-cause, with the twist that we're allowing the impossible:
> Essentially we take away the panel fitter from pipe B to pipe A while
> it is strictly still in use by pipe B for VGA. Currently no idea how
> to properly fix this in a not too intrusive way.
> 
> The other issue is that the encoders connected to pipe B change in the
> first modeset, but that's not reflected in the pipe masks.

I think I need a bit more debug output first. Can you please apply the
below patch to drm-intel-nightly and then grab a drm.debug=0xe dmesg from
boot?

Thanks, Daniel
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 122f87155b8e..554c30e89308 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -9144,6 +9144,11 @@ intel_modeset_affected_pipes(struct drm_crtc *crtc, unsigned *modeset_pipes,
 		if (connector->new_encoder)
 			*prepare_pipes |=
 				1 << connector->new_encoder->new_crtc->pipe;
+
+		DRM_DEBUG_KMS("[CONNECTOR:%d:%s]: prepare_pipes %u\n",
+			connector->base.base.id,
+			drm_get_connector_name(&connector->base),
+			*prepare_pipes);
 	}
 
 	list_for_each_entry(encoder, &dev->mode_config.encoder_list,
@@ -9159,6 +9164,11 @@ intel_modeset_affected_pipes(struct drm_crtc *crtc, unsigned *modeset_pipes,
 
 		if (encoder->new_crtc)
 			*prepare_pipes |= 1 << encoder->new_crtc->pipe;
+
+		DRM_DEBUG_KMS("[ENCODER:%d:%s]: prepare_pipes %u\n",
+			encoder->base.base.id,
+			drm_get_encoder_name(&encoder->base),
+			*prepare_pipes);
 	}
 
 	/* Check for pipes that will be enabled/disabled ... */
@@ -9171,6 +9181,11 @@ intel_modeset_affected_pipes(struct drm_crtc *crtc, unsigned *modeset_pipes,
 			*disable_pipes |= 1 << intel_crtc->pipe;
 		else
 			*prepare_pipes |= 1 << intel_crtc->pipe;
+
+		DRM_DEBUG_KMS("[CRTC:%d:%s]: prepare_pipes %u\n",
+			intel_crtc->base.base.id,
+			pipe_name(intel_crtc->pipe),
+			*prepare_pipes);
 	}
 
 
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
