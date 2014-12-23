Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbaLWKmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 05:42:49 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:18001 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755808AbaLWKkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 05:40:12 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 23 Dec 2014 02:38:29 -0800
From: Vince Hsu <vinceh@nvidia.com>
To: thierry.reding@gmail.com, swarren@wwwdotorg.org, gnurou@gmail.com,
        bskeggs@redhat.com, martin.peres@free.fr, seven@nimrod-online.com,
        samuel.pitoiset@gmail.com
CC: nouveau@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vince Hsu <vinceh@nvidia.com>
Subject: [PATCH 2/11] memory: tegra: add mc flush support
Date: Tue, 23 Dec 2014 18:39:55 +0800
Message-ID: <1419331204-26679-3-git-send-email-vinceh@nvidia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The flush operation of memory clients is needed for various IP blocks in
the Tegra SoCs to perform a clean reset.

Signed-off-by: Vince Hsu <vinceh@nvidia.com>
---
 drivers/memory/tegra/mc.c | 21 +++++++++++++++++++++
 include/soc/tegra/mc.h    | 23 ++++++++++++++++++++++-
 2 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/memory/tegra/mc.c b/drivers/memory/tegra/mc.c
index fe3c44e7e1d1..a2928b4b26fe 100644
--- a/drivers/memory/tegra/mc.c
+++ b/drivers/memory/tegra/mc.c
@@ -62,6 +62,27 @@ static const struct of_device_id tegra_mc_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, tegra_mc_of_match);
 
+int tegra_mc_flush(struct tegra_mc *mc, unsigned int swgroup, bool enable)
+{
+	int i;
+	const struct tegra_mc_hr *client;
+
+	if (!mc || !mc->soc->hr_clients ||
+			!mc->soc->ops || !mc->soc->ops->flush)
+		return -EINVAL;;
+
+	client = mc->soc->hr_clients;
+
+	for (i = 0; i < mc->soc->num_hr_clients; i++, client++) {
+		if (swgroup == client->swgroup) {
+			return mc->soc->ops->flush(mc, client, enable);
+		}
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL(tegra_mc_flush);
+
 static int tegra_mc_setup_latency_allowance(struct tegra_mc *mc)
 {
 	unsigned long long tick;
diff --git a/include/soc/tegra/mc.h b/include/soc/tegra/mc.h
index 63deb8d9f82a..4894aec7d2a0 100644
--- a/include/soc/tegra/mc.h
+++ b/include/soc/tegra/mc.h
@@ -39,6 +39,21 @@ struct tegra_mc_client {
 	struct tegra_mc_la la;
 };
 
+/* hot reset */
+struct tegra_mc_hr {
+	unsigned int swgroup;
+	unsigned int ctrl;
+	unsigned int status;
+	unsigned int bit;
+};
+
+struct tegra_mc;
+
+struct tegra_mc_ops {
+	int (*flush)(struct tegra_mc *mc, const struct tegra_mc_hr *hr_client,
+				bool enable);
+};
+
 struct tegra_smmu_swgroup {
 	unsigned int swgroup;
 	unsigned int reg;
@@ -64,7 +79,6 @@ struct tegra_smmu_soc {
 	const struct tegra_smmu_ops *ops;
 };
 
-struct tegra_mc;
 struct tegra_smmu;
 
 #ifdef CONFIG_TEGRA_IOMMU_SMMU
@@ -84,6 +98,11 @@ struct tegra_mc_soc {
 	const struct tegra_mc_client *clients;
 	unsigned int num_clients;
 
+	const struct tegra_mc_hr *hr_clients;
+	unsigned int num_hr_clients;
+
+	const struct tegra_mc_ops *ops;
+
 	const unsigned int *emem_regs;
 	unsigned int num_emem_regs;
 
@@ -104,4 +123,6 @@ struct tegra_mc {
 	unsigned long tick;
 };
 
+int tegra_mc_flush(struct tegra_mc *mc, unsigned int swgroup, bool enable);
+
 #endif /* __SOC_TEGRA_MC_H__ */
-- 
1.9.1

