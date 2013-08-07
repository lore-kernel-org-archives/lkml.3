Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784Ab3HGK12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:27:28 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:56437 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932662Ab3HGK1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:27:25 -0400
Date: Wed, 7 Aug 2013 12:20:48 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: rubini@gnudd.com, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Subject: [PATCH 19/26] x86 STA2X11 platform: create sta2x11-clock-regs
 device
Message-ID: <a018fe226244e4dec7eaa64911a957089d499edc.1375867291.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1375867291.git.rubini@gnudd.com>
In-Reply-To: <cover.1375867291.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates a virtual platform device each time the apb-soc-regs
and sctl devices have been probed for a given sta2x11 instance.
This will trigger clock registration for such instance.

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 arch/x86/include/asm/sta2x11.h      |    1 +
 arch/x86/platform/sta2x11/sta2x11.c |   21 +++++++++++++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/sta2x11.h b/arch/x86/include/asm/sta2x11.h
index 31fc648..3c5dee4 100644
--- a/arch/x86/include/asm/sta2x11.h
+++ b/arch/x86/include/asm/sta2x11.h
@@ -78,6 +78,7 @@ struct sta2x11_instance_data *sta2x11_dev_to_instance(struct device *dev)
 #define STA2X11_APBREG_NAME		"sta2x11-apbreg"
 #define STA2X11_APB_SOC_REGS_NAME	"sta2x11-apb-soc-regs"
 #define STA2X11_VIC_NAME		"sta2x11-vic"
+#define STA2X11_CLOCK_REGS_NAME		"sta2x11-clock-regs"
 
 /* CAN and MLB */
 #define APBREG_BSR	0x00	/* Bridge Status Reg */
diff --git a/arch/x86/platform/sta2x11/sta2x11.c b/arch/x86/platform/sta2x11/sta2x11.c
index 1f1d1af..57ed10d 100644
--- a/arch/x86/platform/sta2x11/sta2x11.c
+++ b/arch/x86/platform/sta2x11/sta2x11.c
@@ -243,6 +243,20 @@ struct sta2x11_instance_data *sta2x11_node_to_instance(struct device_node *n)
 }
 EXPORT_SYMBOL(sta2x11_node_to_instance);
 
+static int create_clk_dev(struct sta2x11_instance_data *instance)
+{
+	int stat;
+	struct platform_device *cpd =
+		platform_device_alloc(STA2X11_CLOCK_REGS_NAME, instance->id);
+	if (!cpd)
+		return -ENOMEM;
+
+	cpd->dev.platform_data = instance;
+	stat = platform_device_add(cpd);
+	if (stat < 0)
+		platform_device_put(cpd);
+	return stat;
+}
 
 /* Common probe for the four platform devices */
 static int sta2x11_platform_probe(struct platform_device *dev,
@@ -312,6 +326,13 @@ static int sta2x11_platform_probe(struct platform_device *dev,
 	}
 	*dst = platform_drv_data;
 
+	/*
+	 * When both sctl and apb_soc_regs have been probed, we're ready for
+	 * creating the "sta2x11-clock-regs" platform device
+	 */
+	if (instance->sctl && instance->apb_soc_regs)
+		create_clk_dev(instance);
+
 	platform_set_drvdata(dev, platform_drv_data);
 	return 0;
 }
-- 
1.7.7.2
