Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab3LLIAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 03:00:09 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:15503 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab3LLH6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:58:37 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 12 Dec 2013 00:00:16 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>, <swarren@nvidia.com>,
        <will.deacon@arm.com>, <grant.likely@linaro.org>,
        <thierry.reding@gmail.com>, <robherring2@gmail.com>, <joro@8bytes.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, <lorenzo.pieralisi@arm.com>,
        <linux-kernel@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
        <galak@codeaurora.org>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCHv7 09/12] iommu/tegra: smmu: get swgroups from DT "iommus="
Date: Thu, 12 Dec 2013 09:57:10 +0200
Message-ID: <1386835033-4701-10-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1386835033-4701-1-git-send-email-hdoyu@nvidia.com>
References: <1386835033-4701-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides the info about which swgroups a device belongs to. This
info is passed from DT. This is necessary for the unified SMMU driver
among Tegra SoCs since each has different H/W accelerators.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
v6:
- Explained "#iommu-cells" in the binding document.
- Fixed old "nvidia,memory-clients" with 'iommus" in the binding
  document.
- Move smmu_of_get_swgroups() here from the previous patch not to break
  git bisecting.

v5:
"iommu=" in a device DT is used instead of "mmu-masters" in an iommu
DT. This is "iommu=" version of:

  [PATCHv4 5/7] iommu/tegra: smmu: Support "mmu-masters" binding

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 .../bindings/iommu/nvidia,tegra30-smmu.txt         |  30 ++++-
 drivers/iommu/tegra-smmu.c                         | 135 ++++++++++++++++++---
 2 files changed, 145 insertions(+), 20 deletions(-)

diff --git a/Documentation/devicetree/bindings/iommu/nvidia,tegra30-smmu.txt b/Documentation/devicetree/bindings/iommu/nvidia,tegra30-smmu.txt
index 89fb543..fd53f54 100644
--- a/Documentation/devicetree/bindings/iommu/nvidia,tegra30-smmu.txt
+++ b/Documentation/devicetree/bindings/iommu/nvidia,tegra30-smmu.txt
@@ -1,6 +1,6 @@
 NVIDIA Tegra 30 IOMMU H/W, SMMU (System Memory Management Unit)
 
-Required properties:
+Required properties in the IOMMU node:
 - compatible : "nvidia,tegra30-smmu"
 - reg : Should contain 3 register banks(address and length) for each
   of the SMMU register blocks.
@@ -8,9 +8,23 @@ Required properties:
 - nvidia,#asids : # of ASIDs
 - dma-window : IOVA start address and length.
 - nvidia,ahb : phandle to the ahb bus connected to SMMU.
+- iommus: phandle to an iommu device which a device is
+  attached to and indicates which swgroups a device belongs to(SWGROUP ID).
+  SWGROUP ID is from 0 to 63, and a device can belong to multiple SWGROUPS.
+- #iommu-cells. Should be 2. In client IOMMU specifiers, the two cells
+  represent a 64-bit bitmask of SWGROUP IDs under which the device
+  initiates transactions. The least significant word is first. See
+  <dt-bindings/memory/tegra-swgroup.h> for a list of valid values.
+
+Required properties in device nodes affected by the IOMMU:
+- iommus: A list of phandle plus specifier pairs for each IOMMU that
+  affects master transactions initiated by the device. The number of
+  cells in each specifier is defined by the #iommu-cells property in
+  the IOMMU node referred to by the phandle. The meaning of the
+  specifier cells is defined by the referenced IOMMU's binding.
 
 Example:
-	smmu {
+	smmu: iommu {
 		compatible = "nvidia,tegra30-smmu";
 		reg = <0x7000f010 0x02c
 		       0x7000f1f0 0x010
@@ -18,4 +32,16 @@ Example:
 		nvidia,#asids = <4>;		/* # of ASIDs */
 		dma-window = <0 0x40000000>;	/* IOVA start & length */
 		nvidia,ahb = <&ahb>;
+		#iommu-cells = <2>;
 	};
+
+	host1x {
+		compatible = "nvidia,tegra30-host1x", "simple-bus";
+		iommus = <&smmu TEGRA_SWGROUP_CELLS(HC)>;
+		....
+		gr3d {
+			compatible = "nvidia,tegra30-gr3d";
+			iommus = <&smmu TEGRA_SWGROUP_CELLS(NV)
+					TEGRA_SWGROUP_CELLS(NV2)>;
+			....
+		};
diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index 6ab977a..fd4479a 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -190,6 +190,8 @@ enum {
  * Per client for address space
  */
 struct smmu_client {
+	struct device_node	*of_node;
+	struct rb_node		node;
 	struct device		*dev;
 	struct list_head	list;
 	struct smmu_as		*as;
@@ -233,6 +235,7 @@ struct smmu_device {
 	spinlock_t	lock;
 	char		*name;
 	struct device	*dev;
+	struct rb_root	clients;
 	struct page *avp_vector_page;	/* dummy page shared by all AS's */
 
 	/*
@@ -310,6 +313,96 @@ static inline void smmu_write(struct smmu_device *smmu, u32 val, size_t offs)
  */
 #define FLUSH_SMMU_REGS(smmu)	smmu_read(smmu, SMMU_CONFIG)
 
+static struct smmu_client *find_smmu_client(struct smmu_device *smmu,
+					    struct device_node *dev_node)
+{
+	struct rb_node *node = smmu->clients.rb_node;
+
+	while (node) {
+		struct smmu_client *client;
+
+		client = container_of(node, struct smmu_client, node);
+		if (dev_node < client->of_node)
+			node = node->rb_left;
+		else if (dev_node > client->of_node)
+			node = node->rb_right;
+		else
+			return client;
+	}
+
+	return NULL;
+}
+
+static int insert_smmu_client(struct smmu_device *smmu,
+			      struct smmu_client *client)
+{
+	struct rb_node **new, *parent;
+
+	new = &smmu->clients.rb_node;
+	parent = NULL;
+	while (*new) {
+		struct smmu_client *this;
+		this = container_of(*new, struct smmu_client, node);
+
+		parent = *new;
+		if (client->of_node < this->of_node)
+			new = &((*new)->rb_left);
+		else if (client->of_node > this->of_node)
+			new = &((*new)->rb_right);
+		else
+			return -EEXIST;
+	}
+
+	rb_link_node(&client->node, parent, new);
+	rb_insert_color(&client->node, &smmu->clients);
+	return 0;
+}
+
+static int register_smmu_client(struct smmu_device *smmu,
+				struct device *dev, unsigned long *swgroups)
+{
+	struct smmu_client *client;
+
+	client = find_smmu_client(smmu, dev->of_node);
+	if (client) {
+		dev_err(dev,
+			"rejecting multiple registrations for client device %s\n",
+			dev->of_node->full_name);
+		return -EBUSY;
+	}
+
+	client = devm_kzalloc(smmu->dev, sizeof(*client), GFP_KERNEL);
+	if (!client)
+		return -ENOMEM;
+
+	client->dev = dev;
+	client->of_node = dev->of_node;
+	memcpy(client->hwgrp, swgroups, sizeof(u64));
+	return insert_smmu_client(smmu, client);
+}
+
+static int smmu_of_get_swgroups(struct device *dev, unsigned long *swgroups)
+{
+	struct of_phandle_args args;
+	const __be32 *cur, *end;
+
+	of_property_for_each_phandle_with_args(dev->of_node, "iommus",
+					       "#iommu-cells", 0, args, cur, end) {
+		if (args.np != smmu_handle->dev->of_node)
+			continue;
+
+		BUG_ON(args.args_count != 2);
+
+		memcpy(swgroups, args.args, sizeof(u64));
+		pr_debug("swgroups=%08lx %08lx ops=%p %s\n",
+			 swgroups[0], swgroups[1],
+			 dev->bus->iommu_ops, dev_name(dev));
+		return 0;
+	}
+
+	return -ENODEV;
+}
+
 static int __smmu_client_set_hwgrp(struct smmu_client *c,
 				   unsigned long *map, int on)
 {
@@ -719,21 +812,16 @@ static int smmu_iommu_attach_dev(struct iommu_domain *domain,
 	struct smmu_as *as = domain->priv;
 	struct smmu_device *smmu = as->smmu;
 	struct smmu_client *client, *c;
-	unsigned long *map;
 	int err;
 
-	client = devm_kzalloc(smmu->dev, sizeof(*c), GFP_KERNEL);
+	client = find_smmu_client(smmu, dev->of_node);
 	if (!client)
 		return -ENOMEM;
-	client->dev = dev;
-	client->as = as;
-	map = (unsigned long *)dev->platform_data;
-	if (!map)
-		return -EINVAL;
 
-	err = smmu_client_enable_hwgrp(client, map);
+	client->as = as;
+	err = smmu_client_enable_hwgrp(client, client->hwgrp);
 	if (err)
-		goto err_hwgrp;
+		return -EINVAL;
 
 	spin_lock(&as->client_lock);
 	list_for_each_entry(c, &as->client, list) {
@@ -751,7 +839,7 @@ static int smmu_iommu_attach_dev(struct iommu_domain *domain,
 	 * Reserve "page zero" for AVP vectors using a common dummy
 	 * page.
 	 */
-	if (test_bit(TEGRA_SWGROUP_AVPC, map)) {
+	if (test_bit(TEGRA_SWGROUP_AVPC, client->hwgrp)) {
 		struct page *page;
 
 		page = as->smmu->avp_vector_page;
@@ -766,8 +854,6 @@ static int smmu_iommu_attach_dev(struct iommu_domain *domain,
 err_client:
 	smmu_client_disable_hwgrp(client);
 	spin_unlock(&as->client_lock);
-err_hwgrp:
-	devm_kfree(smmu->dev, client);
 	return err;
 }
 
@@ -784,7 +870,6 @@ static void smmu_iommu_detach_dev(struct iommu_domain *domain,
 		if (c->dev == dev) {
 			smmu_client_disable_hwgrp(c);
 			list_del(&c->list);
-			devm_kfree(smmu->dev, c);
 			c->as = NULL;
 			dev_dbg(smmu->dev,
 				"%s is detached\n", dev_name(c->dev));
@@ -888,10 +973,23 @@ enum {
 
 static int smmu_iommu_bound_driver(struct device *dev)
 {
-	int err = -EPROBE_DEFER;
-	u32 swgroups = dev->platform_data;
+	int err;
+	unsigned long swgroups[2];
 	struct dma_iommu_mapping *map = NULL;
 
+	err = smmu_of_get_swgroups(dev, swgroups);
+	if (err)
+		return -ENODEV;
+
+	if (!find_smmu_client(smmu_handle, dev->of_node)) {
+		err = register_smmu_client(smmu_handle, dev, swgroups);
+		if (err) {
+			dev_err(dev, "failed to add client %s\n",
+				dev_name(dev));
+			return -EINVAL;
+		}
+	}
+
 	if (test_bit(TEGRA_SWGROUP_PPCS, swgroups))
 		map = smmu_handle->map[SYSTEM_PROTECTED];
 	else
@@ -900,10 +998,10 @@ static int smmu_iommu_bound_driver(struct device *dev)
 	if (map)
 		err = arm_iommu_attach_device(dev, map);
 	else
-		return -EPROBE_DEFER;
+		return -ENODEV;
 
-	pr_debug("swgroups=%08lx map=%p err=%d %s\n",
-		 swgroups, map, err, dev_name(dev));
+	pr_debug("swgroups=%08lx %08lx map=%p err=%d %s\n",
+		 swgroups[0], swgroups[1], map, err, dev_name(dev));
 	return err;
 }
 
@@ -1156,6 +1254,7 @@ static int tegra_smmu_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	smmu->clients = RB_ROOT;
 	smmu->map = (struct dma_iommu_mapping **)(smmu->as + asids);
 	smmu->nregs = pdev->num_resources;
 	smmu->regs = devm_kzalloc(dev, 2 * smmu->nregs * sizeof(*smmu->regs),
-- 
1.8.1.5

