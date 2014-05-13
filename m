Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933790AbaEMOHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:07:53 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:6388 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933120AbaEMOHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:07:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 13 May 2014 07:03:04 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: [RFC PATCH 2/3] clk: tegra: Implement common shared clks
Date: Tue, 13 May 2014 17:06:55 +0300
Message-ID: <1399990023-30318-3-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1399990023-30318-1-git-send-email-pdeschrijver@nvidia.com>
References: <1399990023-30318-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement shared clks which are common between different Tegra SoCs

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/Makefile           |    1 +
 drivers/clk/tegra/clk-id.h           |   58 +++++++++++++++
 drivers/clk/tegra/clk-tegra-shared.c |  128 ++++++++++++++++++++++++++++++++++
 drivers/clk/tegra/clk.h              |    1 +
 4 files changed, 188 insertions(+), 0 deletions(-)
 create mode 100644 drivers/clk/tegra/clk-tegra-shared.c

diff --git a/drivers/clk/tegra/Makefile b/drivers/clk/tegra/Makefile
index f7dfb72..e2d11639 100644
--- a/drivers/clk/tegra/Makefile
+++ b/drivers/clk/tegra/Makefile
@@ -11,6 +11,7 @@ obj-y					+= clk-tegra-periph.o
 obj-y					+= clk-tegra-pmc.o
 obj-y					+= clk-tegra-fixed.o
 obj-y					+= clk-tegra-super-gen4.o
+obj-y					+= clk-tegra-shared.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += clk-tegra20.o
 obj-$(CONFIG_ARCH_TEGRA_3x_SOC)         += clk-tegra30.o
 obj-$(CONFIG_ARCH_TEGRA_114_SOC)	+= clk-tegra114.o
diff --git a/drivers/clk/tegra/clk-id.h b/drivers/clk/tegra/clk-id.h
index c39613c..26fea1e 100644
--- a/drivers/clk/tegra/clk-id.h
+++ b/drivers/clk/tegra/clk-id.h
@@ -233,6 +233,64 @@ enum clk_id {
 	tegra_clk_xusb_hs_src,
 	tegra_clk_xusb_ss,
 	tegra_clk_xusb_ss_src,
+	tegra_clk_avp_emc,
+	tegra_clk_avp_sclk,
+	tegra_clk_battery_c2bus,
+	tegra_clk_battery_c3bus,
+	tegra_clk_battery_emc,
+	tegra_clk_bsea_sclk,
+	tegra_clk_camera_emc,
+	tegra_clk_cap_c2bus,
+	tegra_clk_cap_c3bus,
+	tegra_clk_cap_emc,
+	tegra_clk_cap_profile_c2bus,
+	tegra_clk_cap_profile_c3bus,
+	tegra_clk_cap_sclk,
+	tegra_clk_cap_throttle_c2bus,
+	tegra_clk_cap_throttle_c3bus,
+	tegra_clk_cap_throttle_emc,
+	tegra_clk_cap_throttle_sclk,
+	tegra_clk_cpu_emc,
+	tegra_clk_disp1_emc,
+	tegra_clk_disp2_emc,
+	tegra_clk_edp_c2bus,
+	tegra_clk_edp_c3bus,
+	tegra_clk_edp_emc,
+	tegra_clk_floor_c2bus,
+	tegra_clk_floor_c3bus,
+	tegra_clk_floor_emc,
+	tegra_clk_floor_sclk,
+	tegra_clk_hdmi_emc,
+	tegra_clk_iso_emc,
+	tegra_clk_mon_avp,
+	tegra_clk_mon_emc,
+	tegra_clk_msenc_emc,
+	tegra_clk_override_c2bus,
+	tegra_clk_override_c3bus,
+	tegra_clk_override_emc,
+	tegra_clk_override_sclk,
+	tegra_clk_sbc1_sclk,
+	tegra_clk_sbc2_sclk,
+	tegra_clk_sbc3_sclk,
+	tegra_clk_sbc4_sclk,
+	tegra_clk_sbc5_sclk,
+	tegra_clk_sbc6_sclk,
+	tegra_clk_sdmmc4_emc,
+	tegra_clk_tsec_emc,
+	tegra_clk_usb1_emc,
+	tegra_clk_usb1_sclk,
+	tegra_clk_usb2_emc,
+	tegra_clk_usb2_sclk,
+	tegra_clk_usb3_emc,
+	tegra_clk_usb3_sclk,
+	tegra_clk_usbd_emc,
+	tegra_clk_usbd_sclk,
+	tegra_clk_wake_sclk,
+	tegra_clk_gk20a_emc,
+	tegra_clk_vic03_emc,
+	tegra_clk_ispa_emc,
+	tegra_clk_ispb_emc,
+	tegra_clk_xusb_emc,
 	tegra_clk_max,
 };
 
diff --git a/drivers/clk/tegra/clk-tegra-shared.c b/drivers/clk/tegra/clk-tegra-shared.c
new file mode 100644
index 0000000..c84080e
--- /dev/null
+++ b/drivers/clk/tegra/clk-tegra-shared.c
@@ -0,0 +1,128 @@
+/*
+ * Copyright (c) 2012, 2013, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
+
+#include "clk.h"
+#include "clk-id.h"
+
+struct tegra_shared_clk {
+	char *name;
+	char *client;
+	union {
+		const char **parents;
+		const char *parent;
+	} p;
+	int num_parents;
+	enum shared_bus_users_mode mode;
+	int flags;
+	int clk_id;
+};
+
+#define SHARED_CLK(_name, _parent, _mode, _flags, _client, _id)\
+	{\
+		.name = _name,\
+		.p.parent = _parent,\
+		.num_parents = 1,\
+		.mode = _mode, \
+		.flags = _flags, \
+		.client = _client,\
+		.clk_id = _id,\
+	}
+
+static struct tegra_shared_clk shared_clks[] = {
+	SHARED_CLK("cap.c2bus", "c2bus", SHARED_CEILING, 0, NULL, tegra_clk_cap_c2bus),
+	SHARED_CLK("cap.throttle.c2bus", "c2bus", SHARED_CEILING, 0, NULL, tegra_clk_cap_throttle_c2bus),
+	SHARED_CLK("floor.c2bus", "c2bus", 0, 0, NULL, tegra_clk_floor_c2bus),
+	SHARED_CLK("override.c2bus", "c2bus", SHARED_OVERRIDE, 0, NULL, tegra_clk_override_c2bus),
+	SHARED_CLK("edp.c2bus", "c2bus", SHARED_CEILING, 0, NULL, tegra_clk_edp_c2bus),
+	SHARED_CLK("battery.c2bus", "c2bus", SHARED_CEILING, 0, NULL, tegra_clk_battery_c2bus),
+	SHARED_CLK("cap.profile.c2bus", "c2bus", SHARED_CEILING, 0, NULL, tegra_clk_cap_profile_c2bus),
+	SHARED_CLK("cap.c3bus", "c3bus", SHARED_CEILING, 0, NULL, tegra_clk_cap_c3bus),
+	SHARED_CLK("cap.throttle.c3bus", "c3bus", SHARED_CEILING, 0, NULL, tegra_clk_cap_throttle_c3bus),
+	SHARED_CLK("override.c3bus", "c3bus", SHARED_OVERRIDE, 0, NULL, tegra_clk_override_c3bus),
+	SHARED_CLK("cap.sclk", "sbus", SHARED_CEILING, 0, NULL, tegra_clk_cap_sclk),
+	SHARED_CLK("cap.throttle.sclk", "sbus", SHARED_CEILING, 0, NULL, tegra_clk_cap_throttle_sclk),
+	SHARED_CLK("floor.sclk", "sbus", 0, 0, NULL, tegra_clk_floor_sclk),
+	SHARED_CLK("override.sclk", "sbus", SHARED_OVERRIDE, 0, NULL, tegra_clk_override_sclk),
+	SHARED_CLK("avp.sclk", "sbus", 0, 0, NULL, tegra_clk_avp_sclk),
+	SHARED_CLK("bsea.sclk", "sbus", 0, 0, NULL, tegra_clk_bsea_sclk),
+	SHARED_CLK("usbd.sclk", "sbus", 0, 0, NULL, tegra_clk_usbd_sclk),
+	SHARED_CLK("usb1.sclk", "sbus", 0, 0, NULL, tegra_clk_usb1_sclk),
+	SHARED_CLK("usb2.sclk", "sbus", 0, 0, NULL, tegra_clk_usb2_sclk),
+	SHARED_CLK("usb3.sclk", "sbus", 0, 0, NULL, tegra_clk_usb3_sclk),
+	SHARED_CLK("wake.sclk", "sbus", 0, 0, NULL, tegra_clk_wake_sclk),
+	SHARED_CLK("sbc1.sclk", "sbus", 0, 0, NULL, tegra_clk_sbc1_sclk),
+	SHARED_CLK("sbc2.sclk", "sbus", 0, 0, NULL, tegra_clk_sbc2_sclk),
+	SHARED_CLK("sbc3.sclk", "sbus", 0, 0, NULL, tegra_clk_sbc3_sclk),
+	SHARED_CLK("sbc4.sclk", "sbus", 0, 0, NULL, tegra_clk_sbc4_sclk),
+	SHARED_CLK("sbc5.sclk", "sbus", 0, 0, NULL, tegra_clk_sbc5_sclk),
+	SHARED_CLK("sbc6.sclk", "sbus", 0, 0, NULL, tegra_clk_sbc6_sclk),
+	SHARED_CLK("mon.avp", "sbus", 0, 0, NULL, tegra_clk_mon_avp),
+	SHARED_CLK("avp.emc", "emc_master", 0, 0, NULL, tegra_clk_avp_emc),
+	SHARED_CLK("cpu.emc", "emc_master", 0, 0, NULL, tegra_clk_cpu_emc),
+	SHARED_CLK("disp1.emc", "emc_master", SHARED_BW, 0, NULL, tegra_clk_disp1_emc),
+	SHARED_CLK("disp2.emc", "emc_master", SHARED_BW, 0, NULL, tegra_clk_disp2_emc),
+	SHARED_CLK("hdmi.emc", "emc_master", 0, 0, NULL, tegra_clk_hdmi_emc),
+	SHARED_CLK("usbd.emc", "emc_master", 0, 0, NULL, tegra_clk_usbd_emc),
+	SHARED_CLK("usb1.emc", "emc_master", 0, 0, NULL, tegra_clk_usb1_emc),
+	SHARED_CLK("usb2.emc", "emc_master", 0, 0, NULL, tegra_clk_usb2_emc),
+	SHARED_CLK("usb3.emc", "emc_master", 0, 0, NULL, tegra_clk_usb3_emc),
+	SHARED_CLK("mon.emc", "emc_master", 0, 0, NULL, tegra_clk_mon_emc),
+	SHARED_CLK("msenc.emc", "emc_master", SHARED_BW, 0, NULL, tegra_clk_msenc_emc),
+	SHARED_CLK("tsec.emc", "emc_master", 0, 0, NULL, tegra_clk_tsec_emc),
+	SHARED_CLK("sdmmc4.emc", "emc_master", 0, 0, NULL, tegra_clk_sdmmc4_emc),
+	SHARED_CLK("camera.emc", "emc_master", SHARED_BW, 0, NULL, tegra_clk_camera_emc),
+	SHARED_CLK("iso.emc", "emc_master", SHARED_BW, 0, NULL, tegra_clk_iso_emc),
+	SHARED_CLK("cap.emc", "emc_master", SHARED_CEILING, 0, NULL, tegra_clk_cap_emc),
+	SHARED_CLK("cap.throttle.emc", "emc_master", SHARED_CEILING, 0, NULL, tegra_clk_cap_throttle_emc),
+	SHARED_CLK("floor.emc", "emc_master", 0, 0, NULL, tegra_clk_floor_emc),
+	SHARED_CLK("override.emc", "emc_master", SHARED_OVERRIDE, 0, NULL, tegra_clk_override_emc),
+	SHARED_CLK("edp.emc", "emc_master", SHARED_CEILING, 0, NULL, tegra_clk_edp_emc),
+	SHARED_CLK("battery.emc", "emc_master", SHARED_CEILING, 0, NULL, tegra_clk_battery_emc),
+	SHARED_CLK("gk20a.emc", "emc_master", 0, 0, NULL, tegra_clk_gk20a_emc),
+	SHARED_CLK("vic03.emc", "emc_master", 0, 0, NULL, tegra_clk_vic03_emc),
+	SHARED_CLK("ispa.emc", "emc_master", 0, 0, NULL, tegra_clk_ispa_emc),
+	SHARED_CLK("ispb.emc", "emc_master", 0, 0, NULL, tegra_clk_ispb_emc),
+	SHARED_CLK("xusb.emc", "emc_master", 0, 0, NULL, tegra_clk_xusb_emc),
+};
+
+void __init tegra_shared_clk_init(struct tegra_clk *tegra_clks)
+{
+	int i;
+	const char **parents;
+	struct tegra_shared_clk *data;
+	struct clk *clk;
+	struct clk **dt_clk;
+
+	for (i = 0; i < ARRAY_SIZE(shared_clks); i++) {
+		data = &shared_clks[i];
+		if (data->num_parents == 1)
+			parents = &data->p.parent;
+		else
+			parents = data->p.parents;
+
+		dt_clk = tegra_lookup_dt_id(data->clk_id, tegra_clks);
+		if (!dt_clk)
+			continue;
+
+		clk = clk_register_shared(data->name, parents,
+				data->num_parents, data->flags, data->mode,
+				data->client);
+		*dt_clk = clk;
+	}
+}
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index 16ec8d6..e0fd180 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -620,6 +620,7 @@ int tegra_osc_clk_init(void __iomem *clk_base, struct tegra_clk *tegra_clks,
 void tegra_super_clk_gen4_init(void __iomem *clk_base,
 			void __iomem *pmc_base, struct tegra_clk *tegra_clks,
 			struct tegra_clk_pll_params *pll_params);
+void tegra_shared_clk_init(struct tegra_clk *tegra_clks);
 
 void tegra114_clock_tune_cpu_trimmers_high(void);
 void tegra114_clock_tune_cpu_trimmers_low(void);
-- 
1.7.7.rc0.72.g4b5ea.dirty

