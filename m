Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab3JCENW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:13:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46927 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab3JCENS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:13:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Knut Petersen <Knut_Petersen@t-online.de>,
        Imre Deak <imre.deak@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 25/52] drm/i915/tv: clear adjusted_mode.flags
Date: Wed,  2 Oct 2013 21:05:43 -0700
Message-Id: <20131003040523.897577703@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040522.190209641@linuxfoundation.org>
References: <20131003040522.190209641@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 1062b81598bc00e2f6620e6f3788f8f8df2f01e7 upstream.

The native TV encoder has it's own flags to adjust sync modes and
enabled interlaced modes which are totally irrelevant for the adjusted
mode. This worked out nicely since the input modes used by both the
load detect code and reported in the ->get_modes callbacks all have no
flags set, and we also don't fill out any of them in the ->get_config
callback.

This changed with the additional sanitation done with

commit 2960bc9cceecb5d556ce1c07656a6609e2f7e8b0
Author: Imre Deak <imre.deak@intel.com>
Date:   Tue Jul 30 13:36:32 2013 +0300

    drm/i915: make user mode sync polarity setting explicit

sinc now the "no flags at all" state wouldn't fit through core code
any more. So fix this up again by explicitly clearing the flags in the
->compute_config callback.

Aside: We have zero checking in place to make sure that the requested
mode is indeed the right input mode we want for the selected TV mode.
So we'll happily fall over if userspace tries to pull us.  But that's
definitely work for a different patch series. So just add a FIXME
comment for now.

Reported-by: Knut Petersen <Knut_Petersen@t-online.de>
Cc: Knut Petersen <Knut_Petersen@t-online.de>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Tested-by: Knut Petersen <Knut_Petersen@t-online.de>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_tv.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -921,6 +921,14 @@ intel_tv_compute_config(struct intel_enc
 	DRM_DEBUG_KMS("forcing bpc to 8 for TV\n");
 	pipe_config->pipe_bpp = 8*3;
 
+	/* TV has it's own notion of sync and other mode flags, so clear them. */
+	pipe_config->adjusted_mode.flags = 0;
+
+	/*
+	 * FIXME: We don't check whether the input mode is actually what we want
+	 * or whether userspace is doing something stupid.
+	 */
+
 	return true;
 }
 


