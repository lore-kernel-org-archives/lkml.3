Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbaGHBLF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 21:11:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55237 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbaGGXxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:53:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 3.15 043/122] drm/i915: set backlight duty cycle after backlight enable for gen4
Date: Mon,  7 Jul 2014 16:56:45 -0700
Message-Id: <20140707235735.540523221@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 2e7eeeb59a92d09144fdb7d2dc1af77a10a7945b upstream.

For reasons I can't claim to fully understand gen4 seems to require
backlight duty cycle setting after the backlight has been enabled, or
else black screen follows. I don't have documentation for the correct
sequence on gen4 either. Confirmed on Dell Latitude D630 and MacBook4,1.

This fixes a regression introduced by
commit b35684b8fa94e04f55fd38bf672b737741d2f9e2
Author: Jani Nikula <jani.nikula@intel.com>
Date:   Thu Nov 14 12:13:41 2013 +0200

    drm/i915: do full backlight setup at enable time

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=75791
Reported-and-tested-by: mcy@lm7.fr
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=79423
Reported-and-tested-by: Marc Milgram <mmilgram@redhat.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_panel.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -723,9 +723,6 @@ static void i965_enable_backlight(struct
 	ctl = freq << 16;
 	I915_WRITE(BLC_PWM_CTL, ctl);
 
-	/* XXX: combine this into above write? */
-	intel_panel_actually_set_backlight(connector, panel->backlight.level);
-
 	ctl2 = BLM_PIPE(pipe);
 	if (panel->backlight.combination_mode)
 		ctl2 |= BLM_COMBINATION_MODE;
@@ -734,6 +731,8 @@ static void i965_enable_backlight(struct
 	I915_WRITE(BLC_PWM_CTL2, ctl2);
 	POSTING_READ(BLC_PWM_CTL2);
 	I915_WRITE(BLC_PWM_CTL2, ctl2 | BLM_PWM_ENABLE);
+
+	intel_panel_actually_set_backlight(connector, panel->backlight.level);
 }
 
 static void vlv_enable_backlight(struct intel_connector *connector)


