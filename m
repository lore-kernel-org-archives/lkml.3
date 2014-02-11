Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbaBKUp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:45:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39726 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbaBKTFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:05:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.13 083/120] drm/radeon: set si_notify_smc_display_change properly
Date: Tue, 11 Feb 2014 11:05:24 -0800
Message-Id: <20140211184825.981528989@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184823.492407127@linuxfoundation.org>
References: <20140211184823.492407127@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit ffcda352b569dcf5be5c8a5f57545794acf4adb9 upstream.

This is effectively a revert of 4573388c92ee60b4ed72b8d95b73df861189988c.

Forcing a display active when there is none causes problems with
dpm on some SI boards which results in improperly initialized
dpm state and boot failures on some boards.  As for the bug commit
4573388c92ee tried to address, one can manually force the state to
high for better performance when using the card as a headless compute
node until a better fix is developed.

bugs:
https://bugs.freedesktop.org/show_bug.cgi?id=73788
https://bugs.freedesktop.org/show_bug.cgi?id=69395

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/si_dpm.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/si_dpm.c
+++ b/drivers/gpu/drm/radeon/si_dpm.c
@@ -3591,10 +3591,9 @@ static void si_program_display_gap(struc
 
 	/* Setting this to false forces the performance state to low if the crtcs are disabled.
 	 * This can be a problem on PowerXpress systems or if you want to use the card
-	 * for offscreen rendering or compute if there are no crtcs enabled.  Set it to
-	 * true for now so that performance scales even if the displays are off.
+	 * for offscreen rendering or compute if there are no crtcs enabled.
 	 */
-	si_notify_smc_display_change(rdev, true /*rdev->pm.dpm.new_active_crtc_count > 0*/);
+	si_notify_smc_display_change(rdev, rdev->pm.dpm.new_active_crtc_count > 0);
 }
 
 static void si_enable_spread_spectrum(struct radeon_device *rdev, bool enable)


