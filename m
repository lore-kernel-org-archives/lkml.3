Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbbAFCEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 21:04:48 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:55734 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101AbbAFCEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 21:04:46 -0500
Date: Tue, 6 Jan 2015 02:04:45 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Lokesh Vutla <lokeshvutla@ti.com>, Roger Quadros <rogerq@ti.com>
cc: tony@atomide.com, santosh.shilimkar@oracle.com, t-kristo@ti.com, nm@ti.com,
        nsekhar@ti.com, bcousson@baylibre.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        s-anna@ti.com
Subject: Re: [PATCH] ARM: OMAP2+: hwmod: Fix _wait_target_ready() for hwmods
 without sysc
In-Reply-To: <54AA4CD4.40105@ti.com>
Message-ID: <alpine.DEB.2.02.1501060202540.28771@utopia.booyaka.com>
References: <1418917790-1791-1-git-send-email-rogerq@ti.com> <5492F84E.7020706@ti.com> <alpine.DEB.2.02.1501020654050.27058@utopia.booyaka.com> <54AA4CD4.40105@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Roger, Lokesh, could you try this one instead?

It passes all the basic tests here except it does not boot on the 4460 
VAR-SOM-OM - unclear why at this point - but it would be good to see if it 
works on your AM4372 boards, since I don't have that one.

Test logs are here:

http://www.pwsan.com/omap/testlogs/hwmod_skip_only_remap_v3.19-rc/20150105171744/


- Paul


>From 4f2e13bd2181e0ebede3aabc484aa2339830748a Mon Sep 17 00:00:00 2001
From: Paul Walmsley <paul@pwsan.com>
Date: Mon, 5 Jan 2015 15:49:57 -0700
Subject: [PATCH] Only skip ioremap() if IP block does not have OCP header
 registers. Experimental.

---
 arch/arm/mach-omap2/omap_hwmod.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
index cbb908dc5cf0..03df8833d399 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -1938,6 +1938,8 @@ static int _reset(struct omap_hwmod *oh)
 	pr_debug("omap_hwmod: %s: resetting\n", oh->name);
 
 	if (oh->class->reset) {
+		WARN(!oh->_mpu_rt_va, "Attempt to call custom reset with no MPU register target ioremapped: %s",
+		     oh->name);
 		r = oh->class->reset(oh);
 	} else {
 		if (oh->rst_lines_cnt > 0) {
@@ -2358,15 +2360,19 @@ static int of_dev_hwmod_lookup(struct device_node *np,
 }
 
 /**
- * _init_mpu_rt_base - populate the virtual address for a hwmod
+ * _init_mpu_rt_base - populate the MPU port and virtual address
  * @oh: struct omap_hwmod * to locate the virtual address
  * @data: (unused, caller should pass NULL)
  * @index: index of the reg entry iospace in device tree
  * @np: struct device_node * of the IP block's device node in the DT data
  *
- * Cache the virtual address used by the MPU to access this IP block's
- * registers.  This address is needed early so the OCP registers that
- * are part of the device's address space can be ioremapped properly.
+ * Cache the interconnect target port and the virtual address used by
+ * the MPU to access this IP block's registers.  The address is needed
+ * early so the OCP registers that are part of the device's address
+ * space can be ioremapped properly.  The presence or absence of the
+ * interconnect target port also indicates whether the hwmod code
+ * should wait for the IP block to indicate readiness after it is
+ * enabled.
  *
  * Returns 0 on success, -EINVAL if an invalid hwmod is passed, and
  * -ENXIO on absent or invalid register target address space.
@@ -2385,6 +2391,13 @@ static int __init _init_mpu_rt_base(struct omap_hwmod *oh, void *data,
 	if (oh->_int_flags & _HWMOD_NO_MPU_PORT)
 		return -ENXIO;
 
+	/*
+	 * If there's no need for the hwmod code to read or write to
+	 * the IP block registers, bail out early before the ioremap()
+	 */
+	if (!oh->class->sysc)
+		return 0;
+
 	mem = _find_mpu_rt_addr_space(oh);
 	if (!mem) {
 		pr_debug("omap_hwmod: %s: no MPU register target found\n",
@@ -2451,14 +2464,10 @@ static int __init _init(struct omap_hwmod *oh, void *data)
 				oh->name, np->name);
 	}
 
-	if (oh->class->sysc) {
-		r = _init_mpu_rt_base(oh, NULL, index, np);
-		if (r < 0) {
-			WARN(1, "omap_hwmod: %s: doesn't have mpu register target base\n",
-			     oh->name);
-			return 0;
-		}
-	}
+	r = _init_mpu_rt_base(oh, NULL, index, np);
+	if (r < 0)
+		pr_debug("omap_hwmod: %s: doesn't have mpu register target base\n",
+			 oh->name);
 
 	r = _init_clocks(oh, NULL);
 	if (r < 0) {
-- 
2.1.4

