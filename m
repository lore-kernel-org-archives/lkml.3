Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760199AbbA1B2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:28:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41026 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759762AbbA1B2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.18 15/61] drm/radeon: add a dpm quirk list
Date: Tue, 27 Jan 2015 17:26:27 -0800
Message-Id: <20150128012638.743056287@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012636.936333725@linuxfoundation.org>
References: <20150128012636.936333725@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 4369a69ec6ab86821352bd753c68af5880f87956 upstream.

Disable dpm on certain problematic boards rather than
disabling dpm for the entire chip family since most
boards work fine.

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1386534
https://bugzilla.kernel.org/show_bug.cgi?id=83731

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_pm.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -1287,8 +1287,39 @@ dpm_failed:
 	return ret;
 }
 
+struct radeon_dpm_quirk {
+	u32 chip_vendor;
+	u32 chip_device;
+	u32 subsys_vendor;
+	u32 subsys_device;
+};
+
+/* cards with dpm stability problems */
+static struct radeon_dpm_quirk radeon_dpm_quirk_list[] = {
+	/* TURKS - https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1386534 */
+	{ PCI_VENDOR_ID_ATI, 0x6759, 0x1682, 0x3195 },
+	/* TURKS - https://bugzilla.kernel.org/show_bug.cgi?id=83731 */
+	{ PCI_VENDOR_ID_ATI, 0x6840, 0x1179, 0xfb81 },
+	{ 0, 0, 0, 0 },
+};
+
 int radeon_pm_init(struct radeon_device *rdev)
 {
+	struct radeon_dpm_quirk *p = radeon_dpm_quirk_list;
+	bool disable_dpm = false;
+
+	/* Apply dpm quirks */
+	while (p && p->chip_device != 0) {
+		if (rdev->pdev->vendor == p->chip_vendor &&
+		    rdev->pdev->device == p->chip_device &&
+		    rdev->pdev->subsystem_vendor == p->subsys_vendor &&
+		    rdev->pdev->subsystem_device == p->subsys_device) {
+			disable_dpm = true;
+			break;
+		}
+		++p;
+	}
+
 	/* enable dpm on rv6xx+ */
 	switch (rdev->family) {
 	case CHIP_RV610:
@@ -1344,6 +1375,8 @@ int radeon_pm_init(struct radeon_device
 			 (!(rdev->flags & RADEON_IS_IGP)) &&
 			 (!rdev->smc_fw))
 			rdev->pm.pm_method = PM_METHOD_PROFILE;
+		else if (disable_dpm && (radeon_dpm == -1))
+			rdev->pm.pm_method = PM_METHOD_PROFILE;
 		else if (radeon_dpm == 0)
 			rdev->pm.pm_method = PM_METHOD_PROFILE;
 		else


