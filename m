Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab3LCO0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:26:53 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53175 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab3LCO0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:26:50 -0500
From: Roger Quadros <rogerq@ti.com>
To: <bcousson@baylibre.com>, <paul@pwsan.com>, <tony@atomide.com>
CC: <tomi.valkeinen@ti.com>, <balbi@ti.com>, <sr@denx.de>,
        <David.Laight@ACULAB.COM>, <michael@amarulasolutions.com>,
        <bigeasy@linutronix.de>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 2/3] ARM: OMAP2+: hwmod: Fix RESET logic
Date: Tue, 3 Dec 2013 16:25:47 +0200
Message-ID: <1386080748-17005-3-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386080748-17005-1-git-send-email-rogerq@ti.com>
References: <1386080748-17005-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 arch/arm/mach-omap2/omap_hwmod.c | 43 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
index e3f0eca..615acec 100644
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
+ * _clr_softreset: clear OCP_SYSCONFIG.SOFTRESET bit in @v
+ * @oh: struct omap_hwmod *
+ * @v: pointer to register contents to modify
+ *
+ * Clear the SOFTRESET bit in @v for hwmod @oh.  Returns -EINVAL upon
+ * error or 0 upon success.
+ */
+static int _clr_softreset(struct omap_hwmod *oh, u32 *v)
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
@@ -1911,6 +1941,12 @@ static int _ocp_softreset(struct omap_hwmod *oh)
 	ret = _set_softreset(oh, &v);
 	if (ret)
 		goto dis_opt_clks;
+
+	_write_sysconfig(v, oh);
+	ret = _clr_softreset(oh, &v);
+	if (ret)
+		goto dis_opt_clks;
+
 	_write_sysconfig(v, oh);
 
 	if (oh->class->sysc->srst_udelay)
@@ -3169,6 +3205,11 @@ int omap_hwmod_softreset(struct omap_hwmod *oh)
 		goto error;
 	_write_sysconfig(v, oh);
 
+	ret = _clr_softreset(oh, &v);
+	if (ret)
+		goto error;
+	_write_sysconfig(v, oh);
+
 error:
 	return ret;
 }
-- 
1.8.3.2

