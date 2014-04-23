Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbaDWB2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 21:28:07 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46797 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755880AbaDWB17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 21:27:59 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>, Rob Herring <rob.herring@calxeda.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Joel Fernandes <joelf@ti.com>
Subject: [PATCH 1/8] ARM: OMAP2+: timer: Add a powerup function
Date: Tue, 22 Apr 2014 20:27:02 -0500
Message-ID: <1398216429-4681-2-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398216429-4681-1-git-send-email-joelf@ti.com>
References: <1398216429-4681-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In an effort to isolate the time power initialization for future purposes, add
a function to do the same. This primarily involves a hwmod lookup, setup and
enable.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/mach-omap2/timer.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index dfb19df..ec427e6 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -210,6 +210,31 @@ static void __init omap_dmtimer_init(void)
 	}
 }
 
+int __init omap_dmtimer_powerup(struct device_node *np)
+{
+	struct omap_hwmod *oh;
+	const char *oh_name = NULL;
+	int ret;
+
+	of_property_read_string_index(np, "ti,hwmods", 0, &oh_name);
+	if (!oh_name)
+		return -ENODEV;
+
+	oh = omap_hwmod_lookup(oh_name);
+	if (!oh)
+		return -ENODEV;
+
+	ret = omap_hwmod_setup_one(oh_name);
+	if (ret)
+		return ret;
+
+	ret = omap_hwmod_enable(oh);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 /**
  * omap_dm_timer_get_errata - get errata flags for a timer
  *
-- 
1.7.9.5

