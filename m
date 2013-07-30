Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215Ab3G3IgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 04:36:06 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:17142 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758090Ab3G3IgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 04:36:03 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 30 Jul 2013 01:34:40 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <thierry.reding@gmail.com>
CC: <tbergstrom@nvidia.com>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH] host1x: hdmi: Make sure clock is enabled before dumping registers
Date: Tue, 30 Jul 2013 11:35:03 +0300
Message-ID: <1375173303-4275-1-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The debugfs register dumping function did not enable the HDMI clock.
This led to a possible system hang when reading the debugfs entry
while no HDMI cable was connected to the system. This patch makes
sure that the clock is enabled during the read.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
 drivers/gpu/host1x/drm/hdmi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/host1x/drm/hdmi.c b/drivers/gpu/host1x/drm/hdmi.c
index 01097da..bf7f027 100644
--- a/drivers/gpu/host1x/drm/hdmi.c
+++ b/drivers/gpu/host1x/drm/hdmi.c
@@ -904,6 +904,11 @@ static int tegra_hdmi_show_regs(struct seq_file *s, void *data)
 {
 	struct drm_info_node *node = s->private;
 	struct tegra_hdmi *hdmi = node->info_ent->data;
+	int err;
+
+	err = clk_enable(hdmi->clk);
+	if (err)
+		return err;
 
 #define DUMP_REG(name)						\
 	seq_printf(s, "%-56s %#05x %08lx\n", #name, name,	\
@@ -1069,6 +1074,8 @@ static int tegra_hdmi_show_regs(struct seq_file *s, void *data)
 
 #undef DUMP_REG
 
+	clk_disable(hdmi->clk);
+
 	return 0;
 }
 
-- 
1.8.1.5

