Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146AbaDBUO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:14:56 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:42887 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758948AbaDBUNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:13:31 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
        Jiri Slaby <jslaby@suse.cz>, David Airlie <airlied@linux.ie>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 3.12 06/40] drm/nouveau: make vga_switcheroo code depend on VGA_SWITCHEROO
Date: Wed,  2 Apr 2014 22:12:52 +0200
Message-Id: <5b408662abeee148112626bccf498fc5f11e8a23.1396469191.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
References: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
In-Reply-To: <cover.1396469191.git.jslaby@suse.cz>
References: <cover.1396469191.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Mahoney <jeffm@suse.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d0ce7b8567ae76b8a6c0eb8361d121deb98c1b3f upstream.

Commit 8116188fdef594 ("nouveau/acpi: hook up to the MXM method for mux
switching.") broke the build on non-x86 architectures due to the new
dependency on MXM and MXM being an x86 platform driver.

It built previously since the vga switcheroo registration routines were
zereod out on !X86.  The code was built in but unused.

This patch makes all of the DSM code depend on CONFIG_VGA_SWITCHEROO,
allowing it to build on non-x86 and shrinking the module size as well.

[rdunlap@infradead.org: fix build eror when VGA_SWITCHEROO is not enabled]
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Dave Airlie <airlied@redhat.com>

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/nouveau/nouveau_acpi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_acpi.c b/drivers/gpu/drm/nouveau/nouveau_acpi.c
index 8160fbddbcfe..200e8564c59d 100644
--- a/drivers/gpu/drm/nouveau/nouveau_acpi.c
+++ b/drivers/gpu/drm/nouveau/nouveau_acpi.c
@@ -66,6 +66,7 @@ bool nouveau_is_v1_dsm(void) {
 #define NOUVEAU_DSM_HAS_MUX 0x1
 #define NOUVEAU_DSM_HAS_OPT 0x2
 
+#ifdef CONFIG_VGA_SWITCHEROO
 static const char nouveau_dsm_muid[] = {
 	0xA0, 0xA0, 0x95, 0x9D, 0x60, 0x00, 0x48, 0x4D,
 	0xB3, 0x4D, 0x7E, 0x5F, 0xEA, 0x12, 0x9F, 0xD4,
@@ -378,6 +379,11 @@ void nouveau_unregister_dsm_handler(void)
 	if (nouveau_dsm_priv.optimus_detected || nouveau_dsm_priv.dsm_detected)
 		vga_switcheroo_unregister_handler();
 }
+#else
+void nouveau_register_dsm_handler(void) {}
+void nouveau_unregister_dsm_handler(void) {}
+void nouveau_switcheroo_optimus_dsm(void) {}
+#endif
 
 /* retrieve the ROM in 4k blocks */
 static int nouveau_rom_call(acpi_handle rom_handle, uint8_t *bios,
-- 
1.9.1

