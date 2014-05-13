Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933757AbaEMOHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:07:43 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:6372 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933120AbaEMOHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:07:39 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 13 May 2014 07:02:53 -0700
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
Subject: [RFC PATCH 1/3] clk: Implement cbus and shared clocks
Date: Tue, 13 May 2014 17:06:54 +0300
Message-ID: <1399990023-30318-2-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1399990023-30318-1-git-send-email-pdeschrijver@nvidia.com>
References: <1399990023-30318-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cbus clocks are virtual clocks which implement coordinated changes to
clock rates. These are needed because changing a PLLs rate cannot be
done with active child clocks. Therefore the child clocks are moved to
a backup pll during the PLL rate change.
shared clocks are virtual clocks which implement clock policies (eg min
or max rates).

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/Makefile          |    1 +
 drivers/clk/clk-shared-cbus.c |  448 +++++++++++++++++++++++++++++++++++++++++
 include/linux/clk-provider.h  |   56 +++++
 3 files changed, 505 insertions(+), 0 deletions(-)
 create mode 100644 drivers/clk/clk-shared-cbus.c

diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 5f8a287..8d9255b5 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_COMMON_CLK)	+= clk-fixed-rate.o
 obj-$(CONFIG_COMMON_CLK)	+= clk-gate.o
 obj-$(CONFIG_COMMON_CLK)	+= clk-mux.o
 obj-$(CONFIG_COMMON_CLK)	+= clk-composite.o
+obj-y				+= clk-shared-cbus.o
 
 # hardware specific clock types
 # please keep this section sorted lexicographically by file/directory path name
diff --git a/drivers/clk/clk-shared-cbus.c b/drivers/clk/clk-shared-cbus.c
new file mode 100644
index 0000000..402b4c3
--- /dev/null
+++ b/drivers/clk/clk-shared-cbus.c
@@ -0,0 +1,448 @@
+/*
+ * Copyright (c) 2012 - 2014, NVIDIA CORPORATION.  All rights reserved.
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
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/clk-provider.h>
+#include <linux/clk.h>
+
+static unsigned long _clk_cap_shared_bus(struct clk *c, unsigned long rate,
+						unsigned long ceiling)
+{
+	ceiling = clk_round_rate(c, ceiling);
+
+	rate = min(rate, ceiling);
+
+	return rate;
+}
+
+static int _clk_shared_bus_update(struct clk *bus)
+{
+	struct clk_cbus_shared *cbus =
+			to_clk_cbus_shared(__clk_get_hw(bus));
+	struct clk_cbus_shared *c;
+	unsigned long override_rate = 0;
+	unsigned long top_rate = 0;
+	unsigned long rate = cbus->min_rate;
+	unsigned long bw = 0;
+	unsigned long ceiling = cbus->max_rate;
+
+	list_for_each_entry(c, &cbus->shared_bus_list,
+			u.shared_bus_user.node) {
+		/*
+		 * Ignore requests from disabled floor, bw users, and
+		 * auto-users riding the bus. Always check the ceiling users
+		 * so we don't need to enable it for capping the bus rate.
+		 */
+		if (c->u.shared_bus_user.enabled ||
+		    (c->u.shared_bus_user.mode == SHARED_CEILING)) {
+			unsigned long request_rate = c->u.shared_bus_user.rate;
+
+			switch (c->u.shared_bus_user.mode) {
+			case SHARED_BW:
+				bw += request_rate;
+				if (bw > cbus->max_rate)
+					bw = cbus->max_rate;
+				break;
+			case SHARED_CEILING:
+				if (request_rate)
+					ceiling = min(request_rate, ceiling);
+				break;
+			case SHARED_OVERRIDE:
+				if (override_rate == 0)
+					override_rate = request_rate;
+				break;
+			case SHARED_AUTO:
+				break;
+			case SHARED_FLOOR:
+			default:
+				top_rate = max(request_rate, top_rate);
+				rate = max(top_rate, rate);
+			}
+		}
+	}
+	/*
+	 * Keep the bus rate as its default rate when there is no SHARED_FLOOR
+	 * users enabled so we won't underrun the bus.
+	 */
+	if (!top_rate)
+		rate = clk_get_rate(bus);
+	rate = override_rate ? : max(rate, bw);
+	ceiling = override_rate ? cbus->max_rate : ceiling;
+
+	rate = _clk_cap_shared_bus(bus, rate, ceiling);
+
+	return clk_set_rate(bus, rate);
+}
+
+static int clk_shared_prepare(struct clk_hw *hw)
+{
+	int err = 0;
+	struct clk_cbus_shared *shared = to_clk_cbus_shared(hw);
+
+	shared->u.shared_bus_user.enabled = true;
+	err = _clk_shared_bus_update(clk_get_parent(hw->clk));
+	if (!err && shared->u.shared_bus_user.client)
+		err = clk_prepare_enable(shared->u.shared_bus_user.client);
+
+	return err;
+}
+
+static void clk_shared_unprepare(struct clk_hw *hw)
+{
+	struct clk_cbus_shared *shared = to_clk_cbus_shared(hw);
+
+	if (shared->u.shared_bus_user.client)
+		clk_disable_unprepare(shared->u.shared_bus_user.client);
+
+	shared->u.shared_bus_user.enabled = false;
+	_clk_shared_bus_update(clk_get_parent(hw->clk));
+}
+
+static bool shared_clk_set_rate;
+
+static int clk_shared_set_rate(struct clk_hw *hw, unsigned long rate,
+				unsigned long parent_rate)
+{
+	struct clk_cbus_shared *shared = to_clk_cbus_shared(hw);
+	int err;
+
+	if (shared_clk_set_rate)
+		return 0;
+
+	shared_clk_set_rate = true;
+	shared->u.shared_bus_user.rate = rate;
+	err = _clk_shared_bus_update(clk_get_parent(hw->clk));
+	shared_clk_set_rate = false;
+
+	return err;
+}
+
+static long clk_shared_round_rate(struct clk_hw *hw, unsigned long rate,
+				unsigned long *parent_rate)
+{
+	struct clk_cbus_shared *shared = to_clk_cbus_shared(hw);
+	struct clk_cbus_shared *parent_cbus;
+	struct clk *parent;
+	int ret;
+
+	parent = clk_get_parent(hw->clk);
+	parent_cbus = to_clk_cbus_shared(__clk_get_hw(parent));
+
+	/*
+	 * Defer rounding requests until aggregated. BW users must not be
+	 * rounded at all, others just clipped to bus range (some clients
+	 * may use round api to find limits)
+	 */
+	if (shared->u.shared_bus_user.mode != SHARED_BW) {
+		if (!parent_cbus->max_rate) {
+			ret = clk_round_rate(parent, ULONG_MAX);
+			if (!IS_ERR_VALUE(ret))
+				parent_cbus->max_rate = ret;
+		}
+
+		if (rate > parent_cbus->max_rate)
+			rate = parent_cbus->max_rate;
+		else if (rate < parent_cbus->min_rate)
+			rate = parent_cbus->min_rate;
+	}
+	return rate;
+}
+
+static unsigned long clk_shared_recalc_rate(struct clk_hw *hw,
+				unsigned long parent_rate)
+{
+	struct clk_cbus_shared *shared = to_clk_cbus_shared(hw);
+
+	return shared->u.shared_bus_user.rate;
+}
+
+static int cbus_switch_one(struct clk *client, struct clk *p)
+{
+	int ret = 0;
+	unsigned long old_parent_rate, new_parent_rate, current_rate;
+
+	current_rate = clk_get_rate(client);
+	old_parent_rate = clk_get_rate(clk_get_parent(client));
+	new_parent_rate = clk_get_rate(p);
+
+	if (new_parent_rate > old_parent_rate) {
+		u64 temp_rate;
+
+		/*
+		 * In order to not overclocking the IP block when changing the
+		 * parent, we set the divider to a value which will give us an
+		 * allowed rate when the new parent is selected.
+		 */
+		temp_rate = DIV_ROUND_UP_ULL((u64)clk_get_rate(client) *
+			(u64)old_parent_rate, new_parent_rate);
+		ret = clk_set_rate(client, temp_rate);
+		if (ret) {
+			pr_err("failed to set %s rate to %llu: %d\n",
+				__clk_get_name(client), temp_rate, ret);
+			return ret;
+		}
+	}
+
+	ret = clk_set_parent(client, p);
+	if (ret) {
+		pr_err("failed to set %s parent to %s: %d\n",
+			__clk_get_name(client),
+			__clk_get_name(p), ret);
+		return ret;
+	}
+
+	clk_set_rate(client, current_rate);
+
+	return ret;
+}
+
+static int cbus_backup(struct clk_hw *hw)
+{
+	int ret = 0;
+	struct clk_cbus_shared *cbus = to_clk_cbus_shared(hw);
+	struct clk_cbus_shared *user;
+
+	list_for_each_entry(user, &cbus->shared_bus_list,
+				 u.shared_bus_user.node) {
+		struct clk *client = user->u.shared_bus_user.client;
+
+		if (client && __clk_is_enabled(client) &&
+		 (clk_get_parent(client) == clk_get_parent(hw->clk))) {
+			ret = cbus_switch_one(client, cbus->shared_bus_backup);
+			if (ret)
+				break;
+		}
+	}
+
+	return ret;
+}
+
+static void cbus_restore(struct clk_hw *hw)
+{
+	struct clk_cbus_shared *user;
+	struct clk_cbus_shared *cbus = to_clk_cbus_shared(hw);
+
+	list_for_each_entry(user, &cbus->shared_bus_list,
+				 u.shared_bus_user.node) {
+		struct clk *client = user->u.shared_bus_user.client;
+
+		if (client) {
+			cbus_switch_one(client, clk_get_parent(hw->clk));
+			clk_set_rate(client, user->u.shared_bus_user.rate);
+		}
+	}
+}
+
+static int clk_cbus_set_rate(struct clk_hw *hw, unsigned long rate,
+			unsigned long parent_rate)
+{
+	int ret;
+	struct clk *parent;
+	struct clk_cbus_shared *cbus = to_clk_cbus_shared(hw);
+
+	if (cbus->rate_updating)
+		return 0;
+
+	if (rate == 0)
+		return 0;
+
+	cbus->rate_updating = true;
+
+	parent = clk_get_parent(hw->clk);
+	if (!parent) {
+		cbus->rate_updating = false;
+		return -EINVAL;
+	}
+
+	ret = clk_prepare_enable(parent);
+	if (ret) {
+		cbus->rate_updating = false;
+		pr_err("%s: failed to enable %s clock: %d\n",
+		       __func__, __clk_get_name(hw->clk), ret);
+		return ret;
+	}
+
+	ret = cbus_backup(hw);
+	if (ret)
+		goto out;
+
+	ret = clk_set_rate(parent, rate);
+	if (ret) {
+		pr_err("%s: failed to set %s clock rate %lu: %d\n",
+		       __func__, __clk_get_name(hw->clk), rate, ret);
+		goto out;
+	}
+
+	cbus_restore(hw);
+
+out:
+	cbus->rate_updating = false;
+	clk_disable_unprepare(parent);
+	return ret;
+}
+
+static long clk_cbus_round_rate(struct clk_hw *hw, unsigned long rate,
+			unsigned long *parent_rate)
+{
+	struct clk *parent;
+	long new_rate;
+
+	parent = clk_get_parent(hw->clk);
+	if (IS_ERR(parent)) {
+		pr_err("no parent for %s\n", __clk_get_name(hw->clk));
+		return *parent_rate;
+	} else {
+		new_rate = clk_round_rate(parent, rate);
+		if (new_rate < 0)
+			return *parent_rate;
+		else
+			return new_rate;
+	}
+}
+
+static unsigned long clk_cbus_recalc_rate(struct clk_hw *hw,
+				unsigned long parent_rate)
+{
+	return clk_get_rate(clk_get_parent(hw->clk));
+}
+
+static const struct clk_ops clk_shared_ops = {
+	.prepare = clk_shared_prepare,
+	.unprepare = clk_shared_unprepare,
+	.set_rate = clk_shared_set_rate,
+	.round_rate = clk_shared_round_rate,
+	.recalc_rate = clk_shared_recalc_rate,
+};
+
+static const struct clk_ops tegra_clk_cbus_ops = {
+	.recalc_rate = clk_cbus_recalc_rate,
+	.round_rate = clk_cbus_round_rate,
+	.set_rate = clk_cbus_set_rate,
+};
+
+struct clk *clk_register_shared(const char *name,
+		const char **parent, u8 num_parents, unsigned long flags,
+		enum shared_bus_users_mode mode, const char *client)
+{
+	struct clk_cbus_shared *shared;
+	struct clk_init_data init;
+	struct clk_cbus_shared *parent_cbus;
+	struct clk *client_clk, *parent_clk;
+
+pr_err("%s:%d name: %s\n", __FILE__, __LINE__, name);
+
+	if (num_parents > 2)
+		return ERR_PTR(-EINVAL);
+
+	parent_clk = __clk_lookup(parent[0]);
+	if (IS_ERR(parent_clk))
+		return parent_clk;
+
+	parent_cbus = to_clk_cbus_shared(__clk_get_hw(parent_clk));
+
+	shared = kzalloc(sizeof(*shared), GFP_KERNEL);
+	if (!shared)
+		return ERR_PTR(-ENOMEM);
+
+	if (client) {
+		client_clk = __clk_lookup(client);
+		if (IS_ERR(client_clk)) {
+			kfree(shared);
+			return client_clk;
+		}
+		shared->u.shared_bus_user.client = client_clk;
+		shared->magic = CLK_SHARED_MAGIC;
+	}
+
+	shared->u.shared_bus_user.mode = mode;
+	if (mode == SHARED_CEILING)
+		shared->u.shared_bus_user.rate = parent_cbus->max_rate;
+	else
+		shared->u.shared_bus_user.rate = clk_get_rate(parent_clk);
+
+	shared->flags = flags;
+
+	if (num_parents > 1) {
+		struct clk *c = __clk_lookup(parent[1]);
+
+		if (!IS_ERR(c)) {
+			shared->u.shared_bus_user.inputs[0] = parent_clk;
+			shared->u.shared_bus_user.inputs[1] = c;
+		}
+	}
+	shared->max_rate = parent_cbus->max_rate;
+
+	INIT_LIST_HEAD(&shared->u.shared_bus_user.node);
+
+	list_add_tail(&shared->u.shared_bus_user.node,
+			&parent_cbus->shared_bus_list);
+
+	flags |= CLK_GET_RATE_NOCACHE;
+
+	init.name = name;
+	init.ops = &clk_shared_ops;
+	init.flags = flags;
+	init.parent_names = parent;
+	init.num_parents = 1;
+
+	/* Data in .init is copied by clk_register(), so stack variable OK */
+	shared->hw.init = &init;
+
+	return clk_register(NULL, &shared->hw);
+}
+
+struct clk *clk_register_cbus(const char *name,
+		const char *parent, unsigned long flags,
+		const char *backup, unsigned long min_rate,
+		unsigned long max_rate)
+{
+	struct clk_cbus_shared *cbus;
+	struct clk_init_data init;
+	struct clk *backup_clk;
+
+	cbus = kzalloc(sizeof(*cbus), GFP_KERNEL);
+	if (!cbus)
+		return ERR_PTR(-ENOMEM);
+
+	backup_clk = __clk_lookup(backup);
+	if (IS_ERR(backup_clk)) {
+		kfree(cbus);
+		return backup_clk;
+	}
+
+	cbus->shared_bus_backup = backup_clk;
+	cbus->min_rate = min_rate;
+	cbus->max_rate = max_rate;
+
+	INIT_LIST_HEAD(&cbus->shared_bus_list);
+
+	flags |= CLK_GET_RATE_NOCACHE;
+
+	init.name = name;
+	init.ops = &tegra_clk_cbus_ops;
+	init.flags = flags;
+	init.parent_names = &parent;
+	init.num_parents = 1;
+
+	/* Data in .init is copied by clk_register(), so stack variable OK */
+	cbus->hw.init = &init;
+
+	return clk_register(NULL, &cbus->hw);
+}
+
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 5119174..0fd195d 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -444,6 +444,62 @@ struct clk *clk_register_composite(struct device *dev, const char *name,
 		struct clk_hw *gate_hw, const struct clk_ops *gate_ops,
 		unsigned long flags);
 
+enum shared_bus_users_mode {
+	SHARED_FLOOR = 0,
+	SHARED_BW,
+	SHARED_CEILING,
+	SHARED_AUTO,
+	SHARED_OVERRIDE,
+};
+
+#define CLK_SHARED_MAGIC	0x18ce213d
+
+struct clk_cbus_shared {
+	u32			magic;
+	struct clk_hw		hw;
+	struct list_head	shared_bus_list;
+	struct clk		*shared_bus_backup;
+	u32			flags;
+	unsigned long		min_rate;
+	unsigned long		max_rate;
+	bool			rate_updating;
+	bool			prepared;
+	union {
+		struct {
+			struct clk_hw	*top_user;
+			struct clk_hw	*slow_user;
+		} cbus;
+		struct {
+			struct clk_hw	*pclk;
+			struct clk_hw	*hclk;
+			struct clk_hw	*sclk_low;
+			struct clk_hw	*sclk_high;
+			unsigned long	threshold;
+		} system;
+		struct {
+			struct list_head	node;
+			bool			enabled;
+			unsigned long		rate;
+			struct clk		*client;
+			u32			client_div;
+			enum shared_bus_users_mode mode;
+			struct clk		*inputs[2];
+		} shared_bus_user;
+	} u;
+};
+
+#define to_clk_cbus_shared(_hw) \
+			container_of(_hw, struct clk_cbus_shared, hw)
+
+struct clk *clk_register_shared(const char *name,
+		const char **parent, u8 num_parents, unsigned long flags,
+		enum shared_bus_users_mode mode, const char *client);
+
+struct clk *clk_register_cbus(const char *name,
+		const char *parent, unsigned long flags,
+		const char *backup, unsigned long min_rate,
+		unsigned long max_rate);
+
 /**
  * clk_register - allocate a new clock, register it and return an opaque cookie
  * @dev: device that is registering this clock
-- 
1.7.7.rc0.72.g4b5ea.dirty

