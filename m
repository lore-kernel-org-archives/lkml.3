Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832Ab3K0BfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:35:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39274 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758534Ab3K0A60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:58:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Suman Anna <s-anna@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Nishanth Menon <nm@ti.com>, Tony Lindgren <tony@atomide.com>,
        Paul Walmsley <paul@pwsan.com>
Subject: [PATCH 3.12 018/116] ARM: OMAP2+: hwmod: check for module address space during init
Date: Tue, 26 Nov 2013 16:56:31 -0800
Message-Id: <20131127005738.209469099@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suman Anna <s-anna@ti.com>

commit 6423d6df1440a8acfc2f375d7cbc4cd66c2e6910 upstream.

The hwmod init sequence involves initializing and idling all the
hwmods during bootup. If a module class has sysconfig, the init
sequence utilizes the module register base for performing any
sysc configuration.

The module address space is being removed from hwmod database and
retrieved from the <reg> property of the corresponding DT node.
If a hwmod does not have its corresponding DT node defined and the
memory address space is not defined in the corresponding
omap_hwmod_ocp_if, then the module register target address space
would be NULL and any sysc programming would result in a NULL
pointer dereference and a kernel boot hang.

Handle this scenario by checking for a valid module address space
during the _init of each hwmod, and leaving it in the registered
state if no module register address base is defined in either of
the hwmod data or the DT data.

Signed-off-by: Suman Anna <s-anna@ti.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Tested-by: Nishanth Menon <nm@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
[paul@pwsan.com: use -ENXIO rather than -ENOMEM to indicate a missing address
 space error; fixed checkpatch.pl problem]
Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap2/omap_hwmod.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -2361,21 +2361,23 @@ static struct device_node *of_dev_hwmod_
  * Cache the virtual address used by the MPU to access this IP block's
  * registers.  This address is needed early so the OCP registers that
  * are part of the device's address space can be ioremapped properly.
- * No return value.
+ *
+ * Returns 0 on success, -EINVAL if an invalid hwmod is passed, and
+ * -ENXIO on absent or invalid register target address space.
  */
-static void __init _init_mpu_rt_base(struct omap_hwmod *oh, void *data)
+static int __init _init_mpu_rt_base(struct omap_hwmod *oh, void *data)
 {
 	struct omap_hwmod_addr_space *mem;
 	void __iomem *va_start = NULL;
 	struct device_node *np;
 
 	if (!oh)
-		return;
+		return -EINVAL;
 
 	_save_mpu_port_index(oh);
 
 	if (oh->_int_flags & _HWMOD_NO_MPU_PORT)
-		return;
+		return -ENXIO;
 
 	mem = _find_mpu_rt_addr_space(oh);
 	if (!mem) {
@@ -2384,7 +2386,7 @@ static void __init _init_mpu_rt_base(str
 
 		/* Extract the IO space from device tree blob */
 		if (!of_have_populated_dt())
-			return;
+			return -ENXIO;
 
 		np = of_dev_hwmod_lookup(of_find_node_by_name(NULL, "ocp"), oh);
 		if (np)
@@ -2395,13 +2397,14 @@ static void __init _init_mpu_rt_base(str
 
 	if (!va_start) {
 		pr_err("omap_hwmod: %s: Could not ioremap\n", oh->name);
-		return;
+		return -ENXIO;
 	}
 
 	pr_debug("omap_hwmod: %s: MPU register target at va %p\n",
 		 oh->name, va_start);
 
 	oh->_mpu_rt_va = va_start;
+	return 0;
 }
 
 /**
@@ -2414,8 +2417,8 @@ static void __init _init_mpu_rt_base(str
  * registered at this point.  This is the first of two phases for
  * hwmod initialization.  Code called here does not touch any hardware
  * registers, it simply prepares internal data structures.  Returns 0
- * upon success or if the hwmod isn't registered, or -EINVAL upon
- * failure.
+ * upon success or if the hwmod isn't registered or if the hwmod's
+ * address space is not defined, or -EINVAL upon failure.
  */
 static int __init _init(struct omap_hwmod *oh, void *data)
 {
@@ -2424,8 +2427,14 @@ static int __init _init(struct omap_hwmo
 	if (oh->_state != _HWMOD_STATE_REGISTERED)
 		return 0;
 
-	if (oh->class->sysc)
-		_init_mpu_rt_base(oh, NULL);
+	if (oh->class->sysc) {
+		r = _init_mpu_rt_base(oh, NULL);
+		if (r < 0) {
+			WARN(1, "omap_hwmod: %s: doesn't have mpu register target base\n",
+			     oh->name);
+			return 0;
+		}
+	}
 
 	r = _init_clocks(oh, NULL);
 	if (r < 0) {


