Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322Ab3AYSSI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 13:18:08 -0500
Received: from mail.negativezero.co.uk ([94.102.149.130]:36878 "EHLO
	smtp.negativezero.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405Ab3AYSSG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 13:18:06 -0500
X-Greylist: delayed 473 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jan 2013 13:18:06 EST
Authentication-Results: smtp.negativezero.co.uk; domainkeys=pass header.from=chris@yourdreamnet.co.uk
Authentication-Results: smtp.negativezero.co.uk (amavisd-new); domainkeys=pass
	header.from=chris@yourdreamnet.co.uk
Authentication-Results: smtp.negativezero.co.uk (amavisd-new); dkim=pass
	header.i=@yourdreamnet.co.uk
DomainKey-Signature: a=rsa-sha1; s=default; d=yourdreamnet.co.uk; c=simple; q=dns;
	b=quVhBMsfAC9EqzSoGFv8YuH4uADynHktDvf+VYJQYXqXl/HFHThExckZ9YehMCCUo
	7bFzSWisEmzqHMisC/ksPr8zYrb1HCpYX8yqusqo7487Os1qxiOrjBv3mXxHuztX5yl
	vtIi+W28cFfqohwZpHMBy2iu37DMK11k6rNzHd4=
From: Chris Staite <chris@yourdreamnet.co.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] drm: fix to radeon driver for HD 6450
Date: Fri, 25 Jan 2013 18:10:09 +0000
Message-Id: <A2530357-B6DA-418D-8193-2955CEC17F1E@yourdreamnet.co.uk>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
To: David Airlie <airlied@linux.ie>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
X-Mailer: Apple Mail (2.1499)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christopher Staite <chris@yourdreamnet.co.uk>

Fix commit 62444b7462a2b98bc78d68736c03a7c4e66ba7e2 for HD 6450.  The stop and resume causes the screen to glitch and the X server to reboot constantly.  Re-instating the UPDATE_LOCK fixes the issue in tests on the v3.6.11 stable, and the code has not been altered to fix this since.

Signed-off-by: Christopher Staite <chris@yourdreamnet.co.uk>



--- drivers/gpu/drm/radeon/evergreen.c.org	2013-01-25 17:45:06.000000000 +0000
+++ drivers/gpu/drm/radeon/evergreen.c	2013-01-25 17:48:14.000000000 +0000
@@ -1320,7 +1320,9 @@ void evergreen_mc_stop(struct radeon_dev
 				if (!(tmp & EVERGREEN_CRTC_DISP_READ_REQUEST_DISABLE)) {
 					radeon_wait_for_vblank(rdev, i);
 					tmp |= EVERGREEN_CRTC_DISP_READ_REQUEST_DISABLE;
+					WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 1);
 					WREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[i], tmp);
+					WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 0);
 				}
 			}
 			/* wait for the next frame */
@@ -1382,7 +1384,9 @@ void evergreen_mc_resume(struct radeon_d
 			} else {
 				tmp = RREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[i]);
 				tmp &= ~EVERGREEN_CRTC_DISP_READ_REQUEST_DISABLE;
+				WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 1);
 				WREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[i], tmp);
+				WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 0);
 			}
 			/* wait for the next frame */
 			frame_count = radeon_get_vblank_counter(rdev, i);