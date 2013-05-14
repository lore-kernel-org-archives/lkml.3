Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981Ab3ENSU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 14:20:56 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:54718 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757834Ab3ENSUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 14:20:54 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: bob.liu@oracle.com, dan.magenheimer@oracle.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-mm@kvack.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 8/9] xen/tmem: Remove the usage of '[no|]selfballoon' and use 'tmem.selfballooning' bool instead.
Date: Tue, 14 May 2013 14:09:25 -0400
Message-Id: <1368554966-30469-9-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1368554966-30469-1-git-send-email-konrad.wilk@oracle.com>
References: <1368554966-30469-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the 'tmem' driver is the one that actually sets whether
it will use it (or not) so might as well make tmem responsible
for this knob.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/Kconfig           |    5 ++---
 drivers/xen/xen-selfballoon.c |   25 ++-----------------------
 2 files changed, 4 insertions(+), 26 deletions(-)

diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index 98e9744..9e02d60 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -19,11 +19,10 @@ config XEN_SELFBALLOONING
 	  by the current usage of anonymous memory ("committed AS") and
 	  controlled by various sysfs-settable parameters.  Configuring
 	  FRONTSWAP is highly recommended; if it is not configured, self-
-	  ballooning is disabled by default but can be enabled with the
-	  'selfballooning' kernel boot parameter.  If FRONTSWAP is configured,
+	  ballooning is disabled by default. If FRONTSWAP is configured,
 	  frontswap-selfshrinking is enabled by default but can be disabled
 	  with the 'tmem.selfshrink=0' kernel boot parameter; and self-ballooning
-	  is enabled by default but can be disabled with the 'noselfballooning'
+	  is enabled by default but can be disabled with the 'tmem.selfballooning=0'
 	  kernel boot parameter.  Note that systems without a sufficiently
 	  large swap device should not enable self-ballooning.
 
diff --git a/drivers/xen/xen-selfballoon.c b/drivers/xen/xen-selfballoon.c
index 012f9d9..5d637e2 100644
--- a/drivers/xen/xen-selfballoon.c
+++ b/drivers/xen/xen-selfballoon.c
@@ -57,9 +57,9 @@
  * configured, it is highly recommended that frontswap also be configured
  * and enabled when selfballooning is running.  So, selfballooning
  * is disabled by default if frontswap is not configured and can only
- * be enabled with the "selfballooning" kernel boot option; similarly
+ * be enabled with the "tmem.selfballooning=1" kernel boot option; similarly
  * selfballooning is enabled by default if frontswap is configured and
- * can be disabled with the "noselfballooning" kernel boot option.  Finally,
+ * can be disabled with the "tmem.selfballooning=0" kernel boot option.  Finally,
  * when frontswap is configured,frontswap-selfshrinking can be disabled
  * with the "tmem.selfshrink=0" kernel boot option.
  *
@@ -173,27 +173,6 @@ static void frontswap_selfshrink(void)
 	frontswap_shrink(tgt_frontswap_pages);
 }
 
-/* Disable with kernel boot option. */
-static bool use_selfballooning = true;
-
-static int __init xen_noselfballooning_setup(char *s)
-{
-	use_selfballooning = false;
-	return 1;
-}
-
-__setup("noselfballooning", xen_noselfballooning_setup);
-#else /* !CONFIG_FRONTSWAP */
-/* Enable with kernel boot option. */
-static bool use_selfballooning;
-
-static int __init xen_selfballooning_setup(char *s)
-{
-	use_selfballooning = true;
-	return 1;
-}
-
-__setup("selfballooning", xen_selfballooning_setup);
 #endif /* CONFIG_FRONTSWAP */
 
 #define MB2PAGES(mb)	((mb) << (20 - PAGE_SHIFT))
-- 
1.7.7.6

