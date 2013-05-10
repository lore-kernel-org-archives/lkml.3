Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab3EJO1H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:27:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57287 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756008Ab3EJOWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:22:02 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alex Deucher" <alexander.deucher@amd.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.684373037@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [031/118] drm/radeon: cleanup properly if mmio mapping fails
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 0cd9cb76ae26a19df21abc6f94f5fff141e689c7 upstream.

If we fail to map the mmio BAR, skip driver tear down
that requires mmio.

Should fix:
https://bugzilla.kernel.org/show_bug.cgi?id=56541

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_kms.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -39,8 +39,12 @@ int radeon_driver_unload_kms(struct drm_
 
 	if (rdev == NULL)
 		return 0;
+	if (rdev->rmmio == NULL)
+		goto done_free;
 	radeon_modeset_fini(rdev);
 	radeon_device_fini(rdev);
+
+done_free:
 	kfree(rdev);
 	dev->dev_private = NULL;
 	return 0;

