Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761075AbaJDAMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:12:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048AbaJCVxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:53:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.14 021/238] drm/radeon: enable bapm by default on desktop TN/RL boards
Date: Fri,  3 Oct 2014 14:28:56 -0700
Message-Id: <20141003212914.338692309@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 0c78a44964db3d483b0c09a8236e0fe123aa9cfc upstream.

bapm enabled the GPU and CPU to share TDP headroom.  It was
disabled by default since some laptops hung when it was enabled
in conjunction with dpm.  It seems to be stable on desktop
boards and fixes hangs on boot with dpm enabled on certain
boards, so enable it by default on desktop boards.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=72921

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/trinity_dpm.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/trinity_dpm.c
+++ b/drivers/gpu/drm/radeon/trinity_dpm.c
@@ -1877,7 +1877,15 @@ int trinity_dpm_init(struct radeon_devic
 	for (i = 0; i < SUMO_MAX_HARDWARE_POWERLEVELS; i++)
 		pi->at[i] = TRINITY_AT_DFLT;
 
-	pi->enable_bapm = false;
+	/* There are stability issues reported on latops with
+	 * bapm installed when switching between AC and battery
+	 * power.  At the same time, some desktop boards hang
+	 * if it's not enabled and dpm is enabled.
+	 */
+	if (rdev->flags & RADEON_IS_MOBILITY)
+		pi->enable_bapm = false;
+	else
+		pi->enable_bapm = true;
 	pi->enable_nbps_policy = true;
 	pi->enable_sclk_ds = true;
 	pi->enable_gfx_power_gating = true;


