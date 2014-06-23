Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbaFWNDl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:03:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36714 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926AbaFWNDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:03:39 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 13/93] drm/radeon: handle non-VGA class pci devices with ATRM
Date: Mon, 23 Jun 2014 14:01:52 +0100
Message-Id: <1403528592-2163-14-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit d8ade3526b2aa0505132c404c05a38b73ea15490 upstream.

Newer PX systems have non-VGA pci class dGPUs.  Update
the ATRM fetch method to handle those cases.

bug:
https://bugzilla.kernel.org/show_bug.cgi?id=75401

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.9.1

