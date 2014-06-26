Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbaFZPA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 11:00:59 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:5933 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbaFZPA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 11:00:57 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 26 Jun 2014 07:54:45 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] clk: define and export clk_debugs_add_file
Date: Thu, 26 Jun 2014 18:00:53 +0300
Message-ID: <1403794853-16928-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define and export a new function clk_debugs_add_file which adds a file
to a existing clock's debugfs directory. This can be used by clock
providers to add debugfs entries which are not related to a specific clock
type. Examples include the ability to measure the rate of a clock. It can
also be used by modules to create new debugfs entries. This is useful if you
want to expose features for testing which can potentially cause system
instability such as allowing to change a clock's rate from userspace.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

---
Changes in v3:
 * export a function to create a new file in a clock's debugfs directory
   instead of exposing the clock's debugfs dentry pointer

Changes in v2:
 * fix function name in description
 * export function in header file
---
 drivers/clk/clk.c            |   12 ++++++++++++
 include/linux/clk-provider.h |    5 +++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 8b73ede..c1e2fab 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -403,6 +403,18 @@ static void clk_debug_reparent(struct clk *clk, struct clk *new_parent)
 				__func__, clk->name);
 }
 
+struct dentry *clk_debugfs_add_file(struct clk *clk, char *name, umode_t mode,
+				void *data, const struct file_operations *fops)
+{
+	struct dentry *d = NULL;
+
+	if (clk->dentry)
+		d = debugfs_create_file(name, mode, clk->dentry, data, fops);
+
+	return d;
+}
+EXPORT_SYMBOL_GPL(clk_debugfs_add_file);
+
 /**
  * clk_debug_init - lazily create the debugfs clk tree visualization
  *
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 0c287db..411dd7e 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -619,5 +619,10 @@ static inline void clk_writel(u32 val, u32 __iomem *reg)
 
 #endif	/* platform dependent I/O accessors */
 
+#ifdef CONFIG_DEBUG_FS
+struct dentry *clk_debugfs_add_file(struct clk *clk, char *name, umode_t mode,
+				void *data, const struct file_operations *fops);
+#endif
+
 #endif /* CONFIG_COMMON_CLK */
 #endif /* CLK_PROVIDER_H */
-- 
1.7.7.rc0.72.g4b5ea.dirty

