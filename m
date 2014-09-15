Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759897AbaIOXB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:01:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50812 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649AbaIOWN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:13:59 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>,
        Dave Airlie <airlied@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 063/187] drm/tilcdc: slave: fix dangling sysfs connector node
Date: Mon, 15 Sep 2014 15:07:53 -0700
Message-Id: <1410818997-9432-64-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>

commit daa15b4cd1eee58eb1322062a3320b1dbe5dc96e upstream.

Add a drm_sysfs_connector_remove call when we destroy the panel to make
sure the connector node in sysfs gets deleted.

This is required for proper unload and re-load of this driver as a
module. Without this, we would get a warning at re-load time like so:

   tda998x 0-0070: found TDA19988
   ------------[ cut here ]------------
   WARNING: CPU: 0 PID: 825 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x54/0x74()
   sysfs: cannot create duplicate filename '/class/drm/card0-HDMI-A-1'
   Modules linked in: [..]
   CPU: 0 PID: 825 Comm: modprobe Not tainted 3.15.0-rc4-00027-g9dcdef4 #82
   [<c0013bb8>] (unwind_backtrace) from [<c0011824>] (show_stack+0x10/0x14)
   [<c0011824>] (show_stack) from [<c0034e8c>] (warn_slowpath_common+0x68/0x88)
   [<c0034e8c>] (warn_slowpath_common) from [<c0034edc>] (warn_slowpath_fmt+0x30/0x40)
   [<c0034edc>] (warn_slowpath_fmt) from [<c01243f4>] (sysfs_warn_dup+0x54/0x74)
   [<c01243f4>] (sysfs_warn_dup) from [<c0124708>] (sysfs_do_create_link_sd.isra.2+0xb0/0xb8)
   [<c0124708>] (sysfs_do_create_link_sd.isra.2) from [<c02ae37c>] (device_add+0x338/0x520)
   [<c02ae37c>] (device_add) from [<c02ae6e8>] (device_create_groups_vargs+0xa0/0xc4)
   [<c02ae6e8>] (device_create_groups_vargs) from [<c02ae758>] (device_create+0x24/0x2c)
   [<c02ae758>] (device_create) from [<c029b4ec>] (drm_sysfs_connector_add+0x64/0x204)
   [<c029b4ec>] (drm_sysfs_connector_add) from [<bf0b1b40>] (slave_modeset_init+0x120/0x1bc [tilcdc])
   [<bf0b1b40>] (slave_modeset_init [tilcdc]) from [<bf0b2be8>] (tilcdc_load+0x214/0x4c0 [tilcdc])
   [<bf0b2be8>] (tilcdc_load [tilcdc]) from [<c029955c>] (drm_dev_register+0xa4/0x104)
      [..snip..]
   ---[ end trace 4df8d614936ebdee ]---
   [drm:drm_sysfs_connector_add] *ERROR* failed to register connector device: -17

Signed-off-by: Guido Martínez <guido@vanguardiasur.com.ar>
Tested-by: Darren Etheridge <detheridge@ti.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/tilcdc/tilcdc_slave.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/tilcdc/tilcdc_slave.c b/drivers/gpu/drm/tilcdc/tilcdc_slave.c
index 595068b..2f83ffb 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_slave.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_slave.c
@@ -166,6 +166,7 @@ struct slave_connector {
 static void slave_connector_destroy(struct drm_connector *connector)
 {
 	struct slave_connector *slave_connector = to_slave_connector(connector);
+	drm_sysfs_connector_remove(connector);
 	drm_connector_cleanup(connector);
 	kfree(slave_connector);
 }
-- 
1.9.1

