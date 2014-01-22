Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbaAVG6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 01:58:11 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:56902 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaAVG6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 01:58:07 -0500
From: Bob Liu <lliubbo@gmail.com>
To: konrad.wilk@oracle.com
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        james.dingwall@zynstra.com, Bob Liu <bob.liu@oracle.com>
Subject: [PATCH] drivers: xen: deaggressive selfballoon driver
Date: Wed, 22 Jan 2014 14:57:44 +0800
Message-Id: <1390373864-10525-1-git-send-email-bob.liu@oracle.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current xen-selfballoon driver is too aggressive which may cause OOM be
triggered more often. Eg. this bug reported by James:
https://lkml.org/lkml/2013/11/21/158

There are two mainly reasons:
1) The original goal_page didn't consider some pages used by kernel space, like
slab pages and pages used by device drivers.

2) The balloon driver may not give back memory to guest OS fast enough when the
workload suddenly aquries a lot of physical memory.

In both cases, the guest OS will suffer from memory pressure and OOM may
be triggered.

The fix is make xen-selfballoon driver not that aggressive by adding extra 10%
of total ram pages to goal_page.
It's more valuable to keep the guest system reliable and response faster than
balloon out these 10% pages to XEN.

Signed-off-by: Bob Liu <bob.liu@oracle.com>
---
 drivers/xen/xen-selfballoon.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/xen/xen-selfballoon.c b/drivers/xen/xen-selfballoon.c
index 21e18c1..745ad79 100644
--- a/drivers/xen/xen-selfballoon.c
+++ b/drivers/xen/xen-selfballoon.c
@@ -175,6 +175,7 @@ static void frontswap_selfshrink(void)
 #endif /* CONFIG_FRONTSWAP */
 
 #define MB2PAGES(mb)	((mb) << (20 - PAGE_SHIFT))
+#define PAGES2MB(pages) ((pages) >> (20 - PAGE_SHIFT))
 
 /*
  * Use current balloon size, the goal (vm_committed_as), and hysteresis
@@ -525,6 +526,7 @@ EXPORT_SYMBOL(register_xen_selfballooning);
 int xen_selfballoon_init(bool use_selfballooning, bool use_frontswap_selfshrink)
 {
 	bool enable = false;
+	unsigned long reserve_pages;
 
 	if (!xen_domain())
 		return -ENODEV;
@@ -549,6 +551,26 @@ int xen_selfballoon_init(bool use_selfballooning, bool use_frontswap_selfshrink)
 	if (!enable)
 		return -ENODEV;
 
+	/*
+	 * Give selfballoon_reserved_mb a default value(10% of total ram pages)
+	 * to make selfballoon not so aggressive.
+	 *
+	 * There are mainly two reasons:
+	 * 1) The original goal_page didn't consider some pages used by kernel
+	 *    space, like slab pages and memory used by device drivers.
+	 *
+	 * 2) The balloon driver may not give back memory to guest OS fast
+	 *    enough when the workload suddenly aquries a lot of physical memory.
+	 *
+	 * In both cases, the guest OS will suffer from memory pressure and
+	 * OOM killer may be triggered.
+	 * By reserving extra 10% of total ram pages, we can keep the system
+	 * much more reliably and response faster in some cases.
+	 */
+	if (!selfballoon_reserved_mb) {
+		reserve_pages = totalram_pages / 10;
+		selfballoon_reserved_mb = PAGES2MB(reserve_pages);
+	}
 	schedule_delayed_work(&selfballoon_worker, selfballoon_interval * HZ);
 
 	return 0;
-- 
1.7.10.4

