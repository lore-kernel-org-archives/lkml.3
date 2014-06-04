Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbaFDXW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:22:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40103 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbaFDXWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nico Schottelius <nico-bugzilla.kernel.org@schottelius.org>,
        Chris Wilson <chris@chris-wilson.co.uk>, Aaron Lu <aaron.lu@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 3.14 117/228] drm/i915: restore backlight precision when converting from ACPI
Date: Wed,  4 Jun 2014 16:22:26 -0700
Message-Id: <20140604232351.796608456@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Lu <aaron.lu@intel.com>

commit 721e82c08c1afd6b47367b0e0c4a62140b0667f3 upstream.

When we set backlight on behalf of ACPI opregion, we will convert the
backlight value in the 0-255 range defined in opregion to the actual
hardware level. Commit 22505b82a2 (drm/i915: avoid brightness overflow
when doing scale) is meant to fix the overflow problem when doing the
conversion, but it also caused a problem that the converted hardware
level doesn't quite represent the intended value: say user wants maximum
backlight level(255 in opregion's range), then we will calculate the
actual hardware level to be: level = freq / max * level, where freq is
the hardware's max backlight level(937 on an user's box), and max and
level are all 255. The converted value should be 937 but the above
calculation will yield 765.

To fix this issue, just use 64 bits to do the calculation to keep the
precision and avoid overflow at the same time.

Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=72491
Reported-by: Nico Schottelius <nico-bugzilla.kernel.org@schottelius.org>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_panel.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -501,6 +501,7 @@ void intel_panel_set_backlight(struct in
 	enum pipe pipe = intel_get_pipe_from_connector(connector);
 	u32 freq;
 	unsigned long flags;
+	u64 n;
 
 	if (!panel->backlight.present || pipe == INVALID_PIPE)
 		return;
@@ -511,10 +512,9 @@ void intel_panel_set_backlight(struct in
 
 	/* scale to hardware max, but be careful to not overflow */
 	freq = panel->backlight.max;
-	if (freq < max)
-		level = level * freq / max;
-	else
-		level = freq / max * level;
+	n = (u64)level * freq;
+	do_div(n, max);
+	level = n;
 
 	panel->backlight.level = level;
 	if (panel->backlight.device)


