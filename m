Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391Ab3IXIA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 04:00:57 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:44148 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab3IXIA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 04:00:56 -0400
Date: Tue, 24 Sep 2013 10:01:12 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, Imre Deak <imre.deak@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] drm/i915/tv: clear adjusted_mode.flags
Message-ID: <20130924080112.GC32145@phenom.ffwll.local>
Mail-Followup-To: Knut Petersen <Knut_Petersen@t-online.de>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Imre Deak <imre.deak@intel.com>,
	Chris Wilson <chris@chris-wilson.co.uk>
References: <522EDB3D.7040504@t-online.de>
 <1378806270-18132-1-git-send-email-daniel.vetter@ffwll.ch>
 <52412886.5070106@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52412886.5070106@t-online.de>
X-Operating-System: Linux phenom 3.10-2-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 07:52:06AM +0200, Knut Petersen wrote:
> Hi Daniel!
> 
> This patch is definitely needed for 3.12, but it is still missing in 3.12-rc2 ...

Oops, that one fell through the cracks. Applied to -fixes, thanks for
poking.
-Daniel

> 
> cu,
>  Knut
> 
> On 10.09.2013 11:44, Daniel Vetter wrote:
> >The native TV encoder has it's own flags to adjust sync modes and
> >enabled interlaced modes which are totally irrelevant for the adjusted
> >mode. This worked out nicely since the input modes used by both the
> >load detect code and reported in the ->get_modes callbacks all have no
> >flags set, and we also don't fill out any of them in the ->get_config
> >callback.
> >
> >This changed with the additional sanitation done with
> >
> >commit 2960bc9cceecb5d556ce1c07656a6609e2f7e8b0
> >Author: Imre Deak <imre.deak@intel.com>
> >Date:   Tue Jul 30 13:36:32 2013 +0300
> >
> >     drm/i915: make user mode sync polarity setting explicit
> >
> >sinc now the "no flags at all" state wouldn't fit through core code
> >any more. So fix this up again by explicitly clearing the flags in the
> >->compute_config callback.
> >
> >Aside: We have zero checking in place to make sure that the requested
> >mode is indeed the right input mode we want for the selected TV mode.
> >So we'll happily fall over if userspace tries to pull us.  But that's
> >definitely work for a different patch series. So just add a FIXME
> >comment for now.
> >
> >Reported-by: Knut Petersen <Knut_Petersen@t-online.de>
> >Cc: Knut Petersen <Knut_Petersen@t-online.de>
> >Cc: Imre Deak <imre.deak@intel.com>
> >Cc: Chris Wilson <chris@chris-wilson.co.uk>
> >Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> >---
> >  drivers/gpu/drm/i915/intel_tv.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> >diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_tv.c
> >index f2c6d79..dd6f84b 100644
> >--- a/drivers/gpu/drm/i915/intel_tv.c
> >+++ b/drivers/gpu/drm/i915/intel_tv.c
> >@@ -916,6 +916,14 @@ intel_tv_compute_config(struct intel_encoder *encoder,
> >  	DRM_DEBUG_KMS("forcing bpc to 8 for TV\n");
> >  	pipe_config->pipe_bpp = 8*3;
> >+	/* TV has it's own notion of sync and other mode flags, so clear them. */
> >+	pipe_config->adjusted_mode.flags = 0;
> >+
> >+	/*
> >+	 * FIXME: We don't check whether the input mode is actually what we want
> >+	 * or whether userspace is doing something stupid.
> >+	 */
> >+
> >  	return true;
> >  }
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
