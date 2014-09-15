Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbaIOWNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:13:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50768 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327AbaIOWNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:13:42 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>,
        Dave Airlie <airlied@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 067/187] drm/tilcdc: fix double kfree
Date: Mon, 15 Sep 2014 15:07:57 -0700
Message-Id: <1410818997-9432-68-git-send-email-kamal@canonical.com>
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

commit c9a3ad25eddfdb898114a9d73cdb4c3472d9dfca upstream.

display_timings_release calls kfree on the display_timings object passed
to it. Calling kfree after it is wrong. SLUB debug showed the following
warning:

    =============================================================================
    BUG kmalloc-64 (Tainted: G        W    ): Object already free
    -----------------------------------------------------------------------------

    Disabling lock debugging due to kernel taint
    INFO: Allocated in of_get_display_timings+0x2c/0x214 age=601 cpu=0
    pid=884
     __slab_alloc.constprop.79+0x2e0/0x33c
     kmem_cache_alloc+0xac/0xdc
     of_get_display_timings+0x2c/0x214
     panel_probe+0x7c/0x314 [tilcdc]
     platform_drv_probe+0x18/0x48
     [..snip..]
    INFO: Freed in panel_destroy+0x18/0x3c [tilcdc] age=0 cpu=0 pid=907
     __slab_free+0x34/0x330
     panel_destroy+0x18/0x3c [tilcdc]
     tilcdc_unload+0xd0/0x118 [tilcdc]
     drm_dev_unregister+0x24/0x98
     [..snip..]

Signed-off-by: Guido Martínez <guido@vanguardiasur.com.ar>
Tested-by: Darren Etheridge <detheridge@ti.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/tilcdc/tilcdc_panel.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/tilcdc/tilcdc_panel.c b/drivers/gpu/drm/tilcdc/tilcdc_panel.c
index 1943b2f..b085dcc 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_panel.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_panel.c
@@ -286,10 +286,8 @@ static void panel_destroy(struct tilcdc_module *mod)
 {
 	struct panel_module *panel_mod = to_panel_module(mod);
 
-	if (panel_mod->timings) {
+	if (panel_mod->timings)
 		display_timings_release(panel_mod->timings);
-		kfree(panel_mod->timings);
-	}
 
 	tilcdc_module_cleanup(mod);
 	kfree(panel_mod->info);
-- 
1.9.1

