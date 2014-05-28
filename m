Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948AbaE1Qve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 12:51:34 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:10228 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503AbaE1Qvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 12:51:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 28 May 2014 09:46:30 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: [PATCH 1/2] clk: tegra: Add debugfs infrastructure
Date: Wed, 28 May 2014 19:51:07 +0300
Message-ID: <1401295868-18697-2-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1401295868-18697-1-git-send-email-pdeschrijver@nvidia.com>
References: <1401295868-18697-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add debugfs infrastructure for tegra clocks. In this phase a file 'regs' will
be created which clocktypes can use to dump the register(s) associated with
the clocks.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk.c |   61 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/tegra/clk.h |    8 ++++++
 2 files changed, 69 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c
index c0a7d77..0fdd2d0 100644
--- a/drivers/clk/tegra/clk.c
+++ b/drivers/clk/tegra/clk.c
@@ -164,6 +164,65 @@ struct tegra_clk_periph_regs *get_reg_bank(int clkid)
 	}
 }
 
+#ifdef CONFIG_DEBUG_FS
+
+#include <linux/debugfs.h>
+static tegra_clk_debugfn **debug_show;
+
+static int tegra_clk_show(struct seq_file *s, void *data)
+{
+	int dt_id = (int)s->private;
+	struct clk_hw *hw = __clk_get_hw(clks[dt_id]);
+
+	if (debug_show && debug_show[dt_id])
+		return debug_show[dt_id](s, hw, clk_base);
+	else
+		return -EINVAL;
+}
+
+static int tegra_clk_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, tegra_clk_show, inode->i_private);
+}
+
+static const struct file_operations debug_fops = {
+	.open		= tegra_clk_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+int tegra_clk_debug_init(struct clk_hw *hw, struct dentry *parent_dir,
+			 tegra_clk_debugfn *show_debug)
+{
+	struct dentry *d;
+	int i;
+
+	for (i = 0; i < clk_num; i++)
+		if (clks[i] == hw->clk)
+			break;
+
+	if (i == clk_num)
+		return 0;
+
+	debug_show[i] = show_debug;
+
+	d = debugfs_create_file("regs", S_IRUGO, parent_dir, (void *)i,
+				&debug_fops);
+
+	return 0;
+}
+
+static void __init init_debug_show(int num)
+{
+	debug_show = kzalloc(num * sizeof(tegra_clk_debugfn *), GFP_KERNEL);
+}
+#else
+static void __init init_debug_show(int num)
+{
+}
+#endif
+
 struct clk ** __init tegra_clk_init(void __iomem *regs, int num, int banks)
 {
 	clk_base = regs;
@@ -184,6 +243,8 @@ struct clk ** __init tegra_clk_init(void __iomem *regs, int num, int banks)
 
 	clk_num = num;
 
+	init_debug_show(num);
+
 	return clks;
 }
 
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index 16ec8d6..facbd99 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -20,6 +20,14 @@
 #include <linux/clk-provider.h>
 #include <linux/clkdev.h>
 
+#ifdef CONFIG_DEBUG_FS
+typedef int tegra_clk_debugfn(struct seq_file *s, struct clk_hw *clk,
+			      void __iomem *clk_base);
+
+int tegra_clk_debug_init(struct clk_hw *hw, struct dentry *parent_dir,
+			 tegra_clk_debugfn *show_debug);
+#endif
+
 /**
  * struct tegra_clk_sync_source - external clock source from codec
  *
-- 
1.7.7.rc0.72.g4b5ea.dirty

