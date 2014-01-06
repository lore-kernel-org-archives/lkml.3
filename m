Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbaAGABn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:01:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47541 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932205AbaAFWiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:38:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.12 064/144] drm/radeon: Fix sideport problems on certain RS690 boards
Date: Mon,  6 Jan 2014 14:37:05 -0800
Message-Id: <20140106223747.183236267@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 8333f0fe133be420ce3fcddfd568c3a559ab274e upstream.

Some RS690 boards with 64MB of sideport memory show up as
having 128MB sideport + 256MB of UMA.  In this case,
just skip the sideport memory and use UMA.  This fixes
rendering corruption and should improve performance.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=35457

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/rs690.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/gpu/drm/radeon/rs690.c
+++ b/drivers/gpu/drm/radeon/rs690.c
@@ -162,6 +162,16 @@ static void rs690_mc_init(struct radeon_
 	base = RREG32_MC(R_000100_MCCFG_FB_LOCATION);
 	base = G_000100_MC_FB_START(base) << 16;
 	rdev->mc.igp_sideport_enabled = radeon_atombios_sideport_present(rdev);
+	/* Some boards seem to be configured for 128MB of sideport memory,
+	 * but really only have 64MB.  Just skip the sideport and use
+	 * UMA memory.
+	 */
+	if (rdev->mc.igp_sideport_enabled &&
+	    (rdev->mc.real_vram_size == (384 * 1024 * 1024))) {
+		base += 128 * 1024 * 1024;
+		rdev->mc.real_vram_size -= 128 * 1024 * 1024;
+		rdev->mc.mc_vram_size = rdev->mc.real_vram_size;
+	}
 
 	/* Use K8 direct mapping for fast fb access. */ 
 	rdev->fastfb_working = false;


