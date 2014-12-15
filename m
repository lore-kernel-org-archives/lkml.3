Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbaLOOsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:48:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38712 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbaLOO2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:28:31 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 103/168] gpu/radeon: Set flag to indicate broken 64-bit MSI
Date: Mon, 15 Dec 2014 14:25:57 +0000
Message-Id: <1418653622-21105-104-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 91ed6fd2c383bb8f02d66e98b4a4d2f7207249dc upstream.

Some radeon ASICs don't support all 64 address bits of MSIs despite
advertising support for 64-bit MSIs in their configuration space.

This breaks on systems such as IBM POWER7/8, where 64-bit MSIs can
be assigned with some of the high address bits set.

This makes use of the newly introduced "no_64bit_msi" flag in structure
pci_dev to allow the MSI allocation code to fallback to 32-bit MSIs
on those adapters.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_irq_kms.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_irq_kms.c b/drivers/gpu/drm/radeon/radeon_irq_kms.c
index 16807afab362..c74f12d125f7 100644
--- a/drivers/gpu/drm/radeon/radeon_irq_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_irq_kms.c
@@ -202,6 +202,16 @@ static bool radeon_msi_ok(struct radeon_device *rdev)
 	if (rdev->flags & RADEON_IS_AGP)
 		return false;
 
+	/*
+	 * Older chips have a HW limitation, they can only generate 40 bits
+	 * of address for "64-bit" MSIs which breaks on some platforms, notably
+	 * IBM POWER servers, so we limit them
+	 */
+	if (rdev->family < CHIP_BONAIRE) {
+		dev_info(rdev->dev, "radeon: MSI limited to 32-bit\n");
+		rdev->pdev->no_64bit_msi = 1;
+	}
+
 	/* force MSI on */
 	if (radeon_msi == 1)
 		return true;
-- 
2.1.3

