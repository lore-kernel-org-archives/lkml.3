Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbaLFPLv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:11:51 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47769 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752303AbaLFPIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:12 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 63/66] gpu/radeon: Set flag to indicate broken 64-bit MSI
Date: Sat,  6 Dec 2014 16:07:55 +0100
Message-Id: <021e15481284fe72834def5cb456dcfd8b7d9529.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 91ed6fd2c383bb8f02d66e98b4a4d2f7207249dc upstream.

Some radeon ASICs don't support all 64 address bits of MSIs despite
advertising support for 64-bit MSIs in their configuration space.

This breaks on systems such as IBM POWER7/8, where 64-bit MSIs can
be assigned with some of the high address bits set.

This makes use of the newly introduced "no_64bit_msi" flag in structure
pci_dev to allow the MSI allocation code to fallback to 32-bit MSIs
on those adapters.

Adding Alex's review tag. Patch to the driver is identical to the
reviewed one, I dropped the arch/powerpc hunk rewrote the subject
and cset comment.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/radeon_irq_kms.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_irq_kms.c b/drivers/gpu/drm/radeon/radeon_irq_kms.c
index cc9e8482cf30..a1a843058369 100644
--- a/drivers/gpu/drm/radeon/radeon_irq_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_irq_kms.c
@@ -196,6 +196,16 @@ static bool radeon_msi_ok(struct radeon_device *rdev)
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

