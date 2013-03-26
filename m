Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab3CZV01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 17:26:27 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51418 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab3CZV00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 17:26:26 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: airlied@gmail.com
Cc: alexander.deucher@amd.com, skeggsb@gmail.com, linux-kernel@vger.kernel.org,
        seth.forshee@canonical.com, bhelgaas@google.com, grawity@gmail.com,
        torvalds@linux-foundation.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 2/3] nouveau: Attempt to use platform-provided ROM image
Date: Tue, 26 Mar 2013 17:25:55 -0400
Message-Id: <1364333156-4530-2-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364333156-4530-1-git-send-email-matthew.garrett@nebula.com>
References: <CAPM=9tyYMSsK_2eCNRTx5EsgAQtnvmHxhgPHP3GHPxKUn+wo5w@mail.gmail.com>
 <1364333156-4530-1-git-send-email-matthew.garrett@nebula.com>
X-cavan-blacklisted-at: zen.spamhaus.org
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 208.54.36.151
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platforms only provide their PCI ROM via a platform-specific interface.
Fall back to attempting that if all other sources fail.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 drivers/gpu/drm/nouveau/core/subdev/bios/base.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/bios/base.c b/drivers/gpu/drm/nouveau/core/subdev/bios/base.c
index e816f06..0e2c1a4 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/bios/base.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/bios/base.c
@@ -248,6 +248,22 @@ nouveau_bios_shadow_pci(struct nouveau_bios *bios)
 	}
 }
 
+static void
+nouveau_bios_shadow_platform(struct nouveau_bios *bios)
+{
+	struct pci_dev *pdev = nv_device(bios)->pdev;
+	size_t size;
+
+	void __iomem *rom = pci_platform_rom(pdev, &size);
+	if (rom && size) {
+		bios->data = kmalloc(size, GFP_KERNEL);
+		if (bios->data) {
+			memcpy_fromio(bios->data, rom, size);
+			bios->size = size;
+		}
+	}
+}
+
 static int
 nouveau_bios_score(struct nouveau_bios *bios, const bool writeable)
 {
@@ -288,6 +304,7 @@ nouveau_bios_shadow(struct nouveau_bios *bios)
 		{ "PROM", nouveau_bios_shadow_prom, false, 0, 0, NULL },
 		{ "ACPI", nouveau_bios_shadow_acpi, true, 0, 0, NULL },
 		{ "PCIROM", nouveau_bios_shadow_pci, true, 0, 0, NULL },
+		{ "PLATFORM", nouveau_bios_shadow_platform, true, 0, 0, NULL },
 		{}
 	};
 	struct methods *mthd, *best;
-- 
1.8.1.2

