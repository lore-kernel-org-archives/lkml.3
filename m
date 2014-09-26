Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbaIZJrD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:47:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32893 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755216AbaIZJqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:54 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>,
        Dave Airlie <airlied@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 125/142] drm/tilcdc: fix double kfree
Date: Fri, 26 Sep 2014 11:45:36 +0200
Message-Id: <a84cc78e2adc8e099cd3ef8b0da555df11f25a26.1411724724.git.jslaby@suse.cz>
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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/tilcdc/tilcdc_panel.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/tilcdc/tilcdc_panel.c b/drivers/gpu/drm/tilcdc/tilcdc_panel.c
index 1943b2f50ca0..b085dcc54fb5 100644
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
2.1.0

