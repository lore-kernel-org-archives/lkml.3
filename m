Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478AbaHVODF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:03:05 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43958 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756522AbaHVOC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:02:59 -0400
From: Nishanth Menon <nm@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Keerthy <j-keerthy@ti.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 02/10] ARM: OMAP5 / DRA7: PM: Set MPUSS-EMIF clock-domain static dependency
Date: Fri, 22 Aug 2014 09:02:26 -0500
Message-ID: <1408716154-26101-3-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408716154-26101-1-git-send-email-nm@ti.com>
References: <1408716154-26101-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santosh Shilimkar <santosh.shilimkar@ti.com>

With EMIF clock-domain put under hardware supervised control, memory
corruption and untraceable crashes are observed on OMAP5. Further
investigation revealed that there is a weakness in the PRCM on this
specific dynamic depedency.

The recommendation is to set MPUSS static dependency towards EMIF
clock-domain to avoid issues. This recommendation holds good for DRA7
family of devices as well.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
[rnayak@ti.com: DRA7]
Signed-off-by: Rajendra Nayak <rnayak@ti.com>
[nm@ti.com: conflict resolution, dra7]
Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/mach-omap2/pm44xx.c |   36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-omap2/pm44xx.c b/arch/arm/mach-omap2/pm44xx.c
index 0dda6cf..b6f243d 100644
--- a/arch/arm/mach-omap2/pm44xx.c
+++ b/arch/arm/mach-omap2/pm44xx.c
@@ -203,6 +203,32 @@ static inline int omap4_init_static_deps(void)
 }
 
 /**
+ * omap5_dra7_init_static_deps - Init static clkdm dependencies on OMAP5 and
+ *				 DRA7
+ *
+ * The dynamic dependency between MPUSS -> EMIF is broken and has
+ * not worked as expected. The hardware recommendation is to
+ * enable static dependencies for these to avoid system
+ * lock ups or random crashes.
+ */
+static inline int omap5_dra7_init_static_deps(void)
+{
+	struct clockdomain *mpuss_clkdm, *emif_clkdm;
+	int ret;
+
+	mpuss_clkdm = clkdm_lookup("mpu_clkdm");
+	emif_clkdm = clkdm_lookup("emif_clkdm");
+	if (!mpuss_clkdm || !emif_clkdm)
+		return -EINVAL;
+
+	ret = clkdm_add_wkdep(mpuss_clkdm, emif_clkdm);
+	if (ret)
+		pr_err("Failed to add MPUSS -> EMIF wakeup dependency\n");
+
+	return ret;
+}
+
+/**
  * omap4_pm_init_early - Does early initialization necessary for OMAP4+ devices
  *
  * Initializes basic stuff for power management functionality.
@@ -239,10 +265,14 @@ int __init omap4_pm_init(void)
 		goto err2;
 	}
 
-	if (cpu_is_omap44xx()) {
+	if (cpu_is_omap44xx())
 		ret = omap4_init_static_deps();
-		if (ret)
-			goto err2;
+	else if (soc_is_omap54xx() || soc_is_dra7xx())
+		ret = omap5_dra7_init_static_deps();
+
+	if (ret) {
+		pr_err("Failed to initialise static dependencies.\n");
+		goto err2;
 	}
 
 	ret = omap4_mpuss_init();
-- 
1.7.9.5

