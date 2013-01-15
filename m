Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226Ab3AOWaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:30:05 -0500
Received: from mail.kernel.org ([198.145.19.201]:41936 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758197Ab3AOWaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:30:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Rodrigo Vivi <rodrigo.vivi@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 083/221] drm/i915: dont disable disconnected outputs
Date: Tue, 15 Jan 2013 10:50:10 -0800
Message-Id: <20130115185004.039297472@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit b0a2658acb5bf9ca86b4aab011b7106de3af0add upstream.

This piece of neat lore has been ported painstakingly and bug-for-bug
compatible from the old crtc helper code.

Imo it's utter nonsense.

If you disconnected a cable and before you reconnect it, userspace (or
the kernel) does an set_crtc call, this will result in that connector
getting disabled. Which will result in a nice black screen when
plugging in the cable again.

There's absolutely no reason the kernel does such policy enforcements
- if userspace tries to set up a mode on something disconnected we
might fail loudly (since the dp link training fails), but silently
adjusting the output configuration behind userspace's back is a recipe
for disaster. Specifically I think that this could explain some of our
MI_WAIT hangs around suspend, where userspace issues a scanline wait
on a disable pipe. This mechanisims here could explain how that pipe
got disabled without userspace noticing.

Note that this fixes a NULL deref at BIOS takeover when the firmware
sets up a disconnected output in a clone configuration with a
connected output on the 2nd pipe: When doing the full modeset we don't
have a mode for the 2nd pipe and OOPS. On the first pipe this doesn't
matter, since at boot-up the fbdev helpers will set up the choosen
configuration on that on first. Since this is now the umptenth bug
around handling this imo brain-dead semantics correctly, I think it's
time to kill it and see whether there's any userspace out there which
relies on this.

It also nicely demonstrates that we have a tiny window where DP
hotplug can still kill the driver.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=58396
Tested-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@gmail.com>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7298,10 +7298,6 @@ intel_modeset_stage_output_state(struct
 			DRM_DEBUG_KMS("encoder changed, full mode switch\n");
 			config->mode_changed = true;
 		}
-
-		/* Disable all disconnected encoders. */
-		if (connector->base.status == connector_status_disconnected)
-			connector->new_encoder = NULL;
 	}
 	/* connector->new_encoder is now updated for all connectors. */
 


