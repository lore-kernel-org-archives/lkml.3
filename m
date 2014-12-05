Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbaLEXBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:01:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54457 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbaLEW4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:56:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.14 67/73] gpu/radeon: Set flag to indicate broken 64-bit MSI
Date: Fri,  5 Dec 2014 14:45:13 -0800
Message-Id: <20141205224435.936073139@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205224433.921659956@linuxfoundation.org>
References: <20141205224433.921659956@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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

Adding Alex's review tag. Patch to the driver is identical to the
reviewed one, I dropped the arch/powerpc hunk rewrote the subject
and cset comment.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_irq_kms.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_irq_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_irq_kms.c
@@ -202,6 +202,16 @@ static bool radeon_msi_ok(struct radeon_
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


