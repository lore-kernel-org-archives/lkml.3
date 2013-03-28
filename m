Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab3C1MGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 08:06:12 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:53001 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662Ab3C1MEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 08:04:50 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: FlorianSchandinat@gmx.de
Cc: linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        jbarnes@virtuousgeek.org, backports@vger.kernel.org,
        cocci@systeme.lip6.fr, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr, rodrigo.vivi@gmail.com, daniel.vetter@ffwll.ch,
        rafael.j.wysocki@intel.com,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 2/4] compat: backport fb_info->skip_vt_switch using a static inline
Date: Thu, 28 Mar 2013 05:04:28 -0700
Message-Id: <1364472270-9297-3-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364472270-9297-1-git-send-email-mcgrof@do-not-panic.com>
References: <1364472270-9297-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Commit 3cf2667 as of next-20130301 extended the struct fb_info
with a skip_vt_switch to allow drivers to skip the VT switch
at suspend/resume time. For older kernels we can skip this
as all this switch does is call pm_vt_switch_required() with true
or false depending on this new flag and later
pm_vt_switch_unregister() would not have been made.

compat-drivers was backporting this using #ifdef's but by
integrating a static inline we'd reduce the number of lines
to backport to just 1 line replacement. This would be something
like:

  -       info->skip_vt_switch = true;
  +       fb_enable_skip_vt_switch(info);

For kernels >= 3.10 we'd set the attribute as we do upstream,
for older kernels this would be a no-op.

If this static inline would have been added upstream it would
have meant this collateral evolution would require just adding
a no-op static inline to backport, and no changes as the above
example hunk for every driver that requires the change.

If this static inline ends up upstream *now* it means we do *not*
require the type of hunk above for every driver that requires
the change.

All the code would be left intact !

This is a linux-next 'data structure element collateral evolution'.

Cc: cocci@systeme.lip6.fr
Cc: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: Rodrigo Vivi <rodrigo.vivi@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 include/linux/compat-3.10.h |   41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/include/linux/compat-3.10.h b/include/linux/compat-3.10.h
index 69ddc11..9abfc4b 100644
--- a/include/linux/compat-3.10.h
+++ b/include/linux/compat-3.10.h
@@ -7,6 +7,7 @@
 
 #include <linux/scatterlist.h>
 #include <linux/mm.h>
+#include <linux/fb.h>
 
 #define sg_page_iter_page LINUX_BACKPORT(sg_page_iter_page)
 /**
@@ -29,6 +30,46 @@ static inline dma_addr_t sg_page_iter_dma_address(struct sg_page_iter *piter)
 	return sg_dma_address(piter->sg) + (piter->sg_pgoffset << PAGE_SHIFT);
 }
 
+/*
+ * This is a linux-next data structure element collateral evolution,
+ * we use a wrapper to avoid #ifdef hell to backport it. This allows
+ * us to use a simple fb_info_skip_vt_switch() replacement for when
+ * the new data structure element is used. If coccinelle SmPL grammar
+ * could be used to express the transformation for us on compat-drivers
+ * it means we'd need to express it only once. If the structure element
+ * collateral evolution were to be used *at development* time and we'd
+ * have a way to express the inverse through SmPL we'd be able to
+ * backport this collateral evolution automatically for any new driver
+ * that used it. We'd use coccinelle to look for it and do the
+ * transformations for us based on the original commit (maybe SmPL
+ * would be listed on the commit log.
+ *
+ * We may need the LINUX_BACKPORT() call that adds the backport_
+ * prefix for older kernels than 3.10 if distros decide to
+ * add this same static inline themselves (although unlikely).
+ */
+#define fb_enable_skip_vt_switch LINUX_BACKPORT(fb_enable_skip_vt_switch)
+static inline void fb_enable_skip_vt_switch(struct fb_info *info)
+{
+}
+
+#else /* kernel is >= 3.10 */
+/*
+ * We'd delete this upstream ever got this, we use our
+ * backport_ prefix with LINUX_BACKPORT() so that if this
+ * does get upstream we would not have to add another ifdef
+ * here for the kernels in between v3.10.. up to the point
+ * the routine would have gotten added, we'd just delete this
+ * #else condition completely. If we didn't have this and
+ * say 3.12 added the static inline upstream, we'd have a
+ * clash on the backport for 3.12 as the routine would
+ * already be defined *but* we'd need it for 3.11.
+ */
+#define fb_enable_skip_vt_switch LINUX_BACKPORT(fb_enable_skip_vt_switch)
+static inline void fb_enable_skip_vt_switch(struct fb_info *info)
+{
+	info->skip_vt_switch = true;
+}
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,10,0)) */
 
 #endif /* LINUX_3_10_COMPAT_H */
-- 
1.7.10.4

