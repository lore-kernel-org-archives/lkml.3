Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbaIZJuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:50:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33029 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755219AbaIZJqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:54 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>,
        Dave Airlie <airlied@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 120/142] drm/tilcdc: panel: fix dangling sysfs connector node
Date: Fri, 26 Sep 2014 11:45:31 +0200
Message-Id: <ecb97789fc0fb7f6d9083dd4892c281cce0f65ad.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guido Martínez <guido@vanguardiasur.com.ar>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e396900e649b0af31161634d87fe37076f46c12b upstream.

Add a drm_sysfs_connector_remove call when we destroy the panel to make
sure the connector node in sysfs gets deleted.

This is required for proper unload and re-load of this driver as a
module. Without this, we would get a warning at re-load time like so:

   ------------[ cut here ]------------
   WARNING: CPU: 0 PID: 824 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x54/0x74()
   sysfs: cannot create duplicate filename '/class/drm/card0-LVDS-1'
   Modules linked in: [...]
   CPU: 0 PID: 824 Comm: modprobe Not tainted 3.15.0-rc4-00027-g6484f96-dirty #81
   [<c0013bb8>] (unwind_backtrace) from [<c0011824>] (show_stack+0x10/0x14)
   [<c0011824>] (show_stack) from [<c0034e8c>] (warn_slowpath_common+0x68/0x88)
   [<c0034e8c>] (warn_slowpath_common) from [<c0034edc>] (warn_slowpath_fmt+0x30/0x40)
   [<c0034edc>] (warn_slowpath_fmt) from [<c01243f4>] (sysfs_warn_dup+0x54/0x74)
   [<c01243f4>] (sysfs_warn_dup) from [<c0124708>] (sysfs_do_create_link_sd.isra.2+0xb0/0xb8)
   [<c0124708>] (sysfs_do_create_link_sd.isra.2) from [<c02ae37c>] (device_add+0x338/0x520)
   [<c02ae37c>] (device_add) from [<c02ae6e8>] (device_create_groups_vargs+0xa0/0xc4)
   [<c02ae6e8>] (device_create_groups_vargs) from [<c02ae758>] (device_create+0x24/0x2c)
   [<c02ae758>] (device_create) from [<c029b4ec>] (drm_sysfs_connector_add+0x64/0x204)
   [<c029b4ec>] (drm_sysfs_connector_add) from [<bf0b1fec>] (panel_modeset_init+0xb8/0x134 [tilcdc])
   [<bf0b1fec>] (panel_modeset_init [tilcdc]) from [<bf0b2bf0>] (tilcdc_load+0x214/0x4c0 [tilcdc])
   [<bf0b2bf0>] (tilcdc_load [tilcdc]) from [<c029955c>] (drm_dev_register+0xa4/0x104)
      [ .. snip .. ]
   ---[ end trace b2d09cd9578b0497 ]---
   [drm:drm_sysfs_connector_add] *ERROR* failed to register connector device: -17

Signed-off-by: Guido Martínez <guido@vanguardiasur.com.ar>
Tested-by: Darren Etheridge <detheridge@ti.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/tilcdc/tilcdc_panel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/tilcdc/tilcdc_panel.c b/drivers/gpu/drm/tilcdc/tilcdc_panel.c
index 86c67329b605..1943b2f50ca0 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_panel.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_panel.c
@@ -151,6 +151,7 @@ struct panel_connector {
 static void panel_connector_destroy(struct drm_connector *connector)
 {
 	struct panel_connector *panel_connector = to_panel_connector(connector);
+	drm_sysfs_connector_remove(connector);
 	drm_connector_cleanup(connector);
 	kfree(panel_connector);
 }
-- 
2.1.0

