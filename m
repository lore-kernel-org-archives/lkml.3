Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbaAMRNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:13:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52780 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbaAMQA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:00:58 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Roger Quadros <rogerq@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 002/208] ARM: OMAP2+: hwmod: Fix SOFTRESET logic
Date: Mon, 13 Jan 2014 15:57:23 +0000
Message-Id: <1389628849-1614-3-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Quadros <rogerq@ti.com>

commit 313a76ee11cda6700548afe68499ef174a240688 upstream.

In _ocp_softreset(), after _set_softreset() + write_sysconfig(),
the hwmod's sysc_cache will always contain SOFTRESET bit set
so all further writes to sysconfig using this cache will initiate
a repeated SOFTRESET e.g. enable_sysc(). This is true for OMAP3 like
platforms that have RESET_DONE status in the SYSSTATUS register and
so the the SOFTRESET bit in SYSCONFIG is not automatically cleared.
It is not a problem for OMAP4 like platforms that indicate RESET
completion by clearing the SOFTRESET bit in the SYSCONFIG register.

This repeated SOFTRESET is undesired and was the root cause of
USB host issues on OMAP3 platforms when hwmod was allowed to do the
SOFTRESET for the USB Host module.

To fix this we clear the SOFTRESET bit and update the sysconfig
register + sysc_cache using write_sysconfig().

Signed-off-by: Roger Quadros <rogerq@ti.com>
Tested-by: Tomi Valkeinen <tomi.valkeinen@ti.com> # Panda, BeagleXM
[paul@pwsan.com: renamed _clr_softreset() to _clear_softreset()]
Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-omap2/omap_hwmod.c | 43 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
index 7f4db12..b3a8106 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -399,7 +399,7 @@ static int _set_clockactivity(struct omap_hwmod *oh, u8 clockact, u32 *v)
 }
 
 /**
- * _set_softreset: set OCP_SYSCONFIG.CLOCKACTIVITY bits in @v
+ * _set_softreset: set OCP_SYSCONFIG.SOFTRESET bit in @v
  * @oh: struct omap_hwmod *
  * @v: pointer to register contents to modify
  *
@@ -427,6 +427,36 @@ static int _set_softreset(struct omap_hwmod *oh, u32 *v)
 }
 
 /**
+ * _clear_softreset: clear OCP_SYSCONFIG.SOFTRESET bit in @v
+ * @oh: struct omap_hwmod *
+ * @v: pointer to register contents to modify
+ *
+ * Clear the SOFTRESET bit in @v for hwmod @oh.  Returns -EINVAL upon
+ * error or 0 upon success.
+ */
+static int _clear_softreset(struct omap_hwmod *oh, u32 *v)
+{
+	u32 softrst_mask;
+
+	if (!oh->class->sysc ||
+	    !(oh->class->sysc->sysc_flags & SYSC_HAS_SOFTRESET))
+		return -EINVAL;
+
+	if (!oh->class->sysc->sysc_fields) {
+		WARN(1,
+		     "omap_hwmod: %s: sysc_fields absent for sysconfig class\n",
+		     oh->name);
+		return -EINVAL;
+	}
+
+	softrst_mask = (0x1 << oh->class->sysc->sysc_fields->srst_shift);
+
+	*v &= ~softrst_mask;
+
+	return 0;
+}
+
+/**
  * _wait_softreset_complete - wait for an OCP softreset to complete
  * @oh: struct omap_hwmod * to wait on
  *
@@ -1909,6 +1939,12 @@ static int _ocp_softreset(struct omap_hwmod *oh)
 	ret = _set_softreset(oh, &v);
 	if (ret)
 		goto dis_opt_clks;
+
+	_write_sysconfig(v, oh);
+	ret = _clear_softreset(oh, &v);
+	if (ret)
+		goto dis_opt_clks;
+
 	_write_sysconfig(v, oh);
 
 	if (oh->class->sysc->srst_udelay)
@@ -3148,6 +3184,11 @@ int omap_hwmod_softreset(struct omap_hwmod *oh)
 		goto error;
 	_write_sysconfig(v, oh);
 
+	ret = _clear_softreset(oh, &v);
+	if (ret)
+		goto error;
+	_write_sysconfig(v, oh);
+
 error:
 	return ret;
 }
-- 
1.8.3.2

