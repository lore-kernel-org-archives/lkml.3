Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbaFWJB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:01:26 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55482 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752466AbaFWIc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexdeucher@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 026/111] drm/radeon: handle non-VGA class pci devices with ATRM
Date: Mon, 23 Jun 2014 10:31:01 +0200
Message-Id: <7d683054e1c985904faf7b9faa027f239bb9cdcb.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexdeucher@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d8ade3526b2aa0505132c404c05a38b73ea15490 upstream.

Newer PX systems have non-VGA pci class dGPUs.  Update
the ATRM fetch method to handle those cases.

bug:
https://bugzilla.kernel.org/show_bug.cgi?id=75401

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/radeon_bios.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_bios.c b/drivers/gpu/drm/radeon/radeon_bios.c
index 061b227dae0c..b131520521e4 100644
--- a/drivers/gpu/drm/radeon/radeon_bios.c
+++ b/drivers/gpu/drm/radeon/radeon_bios.c
@@ -196,6 +196,20 @@ static bool radeon_atrm_get_bios(struct radeon_device *rdev)
 		}
 	}
 
+	if (!found) {
+		while ((pdev = pci_get_class(PCI_CLASS_DISPLAY_OTHER << 8, pdev)) != NULL) {
+			dhandle = ACPI_HANDLE(&pdev->dev);
+			if (!dhandle)
+				continue;
+
+			status = acpi_get_handle(dhandle, "ATRM", &atrm_handle);
+			if (!ACPI_FAILURE(status)) {
+				found = true;
+				break;
+			}
+		}
+	}
+
 	if (!found)
 		return false;
 
-- 
2.0.0

