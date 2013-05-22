Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab3EVM6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 08:58:43 -0400
Received: from ip4-83-240-18-99.cust.nbox.cz ([83.240.18.99]:50077 "EHLO
	anemoi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754052Ab3EVM6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 08:58:38 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Jeff Mahoney <jeffm@suse.com>, Jiri Slaby <jslaby@suse.cz>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH -resend 6/6] nouveau: Make vga_switcheroo code depend on VGA_SWITCHEROO
Date: Wed, 22 May 2013 14:59:12 +0200
Message-Id: <1369227552-11743-6-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <1369227552-11743-1-git-send-email-jslaby@suse.cz>
References: <1369227552-11743-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Mahoney <jeffm@suse.com>

Commit 8116188fdef5946bcbb2d73e41d7412a57ffb034 (nouveau/acpi: hook up
to the MXM method for mux switching.) broke the build on non-x86
architectures due to the new dependency on MXM and MXM being an x86
platform driver.

It built previously since the vga switcheroo registration routines
were zereod out on !X86. The code was built in but unused.

This patch makes all of the DSM code depend on CONFIG_VGA_SWITCHEROO,
allowing it to build on non-x86 and shrinking the module size as well.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
---
 drivers/gpu/drm/nouveau/nouveau_acpi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_acpi.c b/drivers/gpu/drm/nouveau/nouveau_acpi.c
index d97f200..4d70fb7 100644
--- a/drivers/gpu/drm/nouveau/nouveau_acpi.c
+++ b/drivers/gpu/drm/nouveau/nouveau_acpi.c
@@ -46,6 +46,7 @@ bool nouveau_is_v1_dsm(void) {
 #define NOUVEAU_DSM_HAS_MUX 0x1
 #define NOUVEAU_DSM_HAS_OPT 0x2
 
+#ifdef CONFIG_VGA_SWITCHEROO
 static const char nouveau_dsm_muid[] = {
 	0xA0, 0xA0, 0x95, 0x9D, 0x60, 0x00, 0x48, 0x4D,
 	0xB3, 0x4D, 0x7E, 0x5F, 0xEA, 0x12, 0x9F, 0xD4,
@@ -337,6 +338,10 @@ void nouveau_unregister_dsm_handler(void)
 	if (nouveau_dsm_priv.optimus_detected || nouveau_dsm_priv.dsm_detected)
 		vga_switcheroo_unregister_handler();
 }
+#else
+void nouveau_register_dsm_handler(void) {}
+void nouveau_unregister_dsm_handler(void) {}
+#endif
 
 /* retrieve the ROM in 4k blocks */
 static int nouveau_rom_call(acpi_handle rom_handle, uint8_t *bios,
-- 
1.8.2.3

