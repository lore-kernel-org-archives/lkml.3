Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbaFGBoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:44:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35960 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752546AbaFGBXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:36 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Christian =?UTF-8?Q?K=C3=B6nig?=" <christian.koenig@amd.com>,
        "Alex Deucher" <alexdeucher@gmail.com>,
        "Alex Deucher" <alexander.deucher@amd.com>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.670994932@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 79/92] drm/radeon: handle non-VGA class pci devices
 with ATRM
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit d8ade3526b2aa0505132c404c05a38b73ea15490 upstream.

Newer PX systems have non-VGA pci class dGPUs.  Update
the ATRM fetch method to handle those cases.

bug:
https://bugzilla.kernel.org/show_bug.cgi?id=75401

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
[bwh: Backported to 3.2: s/ACPI_HANDLE()/DEVICE_ACPI_HANDLE()/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_bios.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_bios.c
+++ b/drivers/gpu/drm/radeon/radeon_bios.c
@@ -173,6 +173,20 @@ static bool radeon_atrm_get_bios(struct
 		}
 	}
 
+	if (!found) {
+		while ((pdev = pci_get_class(PCI_CLASS_DISPLAY_OTHER << 8, pdev)) != NULL) {
+			dhandle = DEVICE_ACPI_HANDLE(&pdev->dev);
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
 

