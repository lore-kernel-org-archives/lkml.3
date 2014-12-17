Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbaLQKgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 05:36:23 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:33970 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751165AbaLQKgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 05:36:20 -0500
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>, Mohit Kumar <mohit.kumar@st.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Arnd Bergmann <arnd@arndb.de>, Viresh Kumar <viresh.kumar@linaro.org>,
        Thierry Reding <treding@nvidia.com>,
        Minghuan Lian <Minghuan.Lian@freescale.com>,
        Magnus Damm <damm@opensource.se>, Will Deacon <will.deacon@arm.com>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Sachin Kamat <sachin.kamat@samsung.com>, Andrew Lunn <andrew@lunn.ch>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Srikanth Thokala <sthokal@xilinx.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        linux-pci@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5/5] PCI: st: disable IO support
Date: Wed, 17 Dec 2014 11:34:46 +0100
Message-Id: <1418812486-12394-6-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418812486-12394-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1418812486-12394-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-17_03:2014-12-17,2014-12-17,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sti SoCs PCIe IPs are built around DesignWare IP Core.
But in these SoCs, PCIe IP doesn't support IO.
By default, when no IO space is provided, a default one is assigned.

Add an empty IO resource to the bus, and disable IO by default.

Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
---
 drivers/pci/host/pci-st.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/pci/host/pci-st.c b/drivers/pci/host/pci-st.c
index bd3d32d..c0d3895 100644
--- a/drivers/pci/host/pci-st.c
+++ b/drivers/pci/host/pci-st.c
@@ -357,9 +357,15 @@ static void st_pcie_board_reset(struct pcie_port *pp)
 static void st_pcie_hw_setup(struct pcie_port *pp)
 {
 	struct st_pcie *pcie = to_st_pcie(pp);
+	u32 val;
 
 	dw_pcie_setup_rc(pp);
 
+	/* Disable IO support */
+	val = readl_relaxed(pp->dbi_base + PCI_COMMAND);
+	val &= ~PCI_COMMAND_IO;
+	writel_relaxed(val, pp->dbi_base + PCI_COMMAND);
+
 	/* Set up the config window to the top of the PCI address space */
 	writel_relaxed(pcie->config_window_start,
 		       pp->dbi_base + CFG_BASE_ADDRESS);
@@ -445,11 +451,28 @@ static void st_pcie_host_init(struct pcie_port *pp)
 		st_msi_init_one(pp);
 }
 
+static void st_pcie_setup_bus(struct pcie_port *pp, struct pci_sys_data *sys)
+{
+	struct resource *res;
+
+	/* This PCIe controller does not support IO, set an empty one. */
+	res = devm_kzalloc(pp->dev, sizeof(*res), GFP_KERNEL);
+	if (!res)
+		return;
+
+	res->start = 0;
+	res->end = 0;
+	res->name = "PCIe empty IO space";
+	res->flags = IORESOURCE_IO;
+	pci_add_resource(&sys->resources, res);
+}
+
 static struct pcie_host_ops st_pcie_host_ops = {
 	.rd_other_conf = st_pcie_rd_other_conf,
 	.wr_other_conf = st_pcie_wr_other_conf,
 	.link_up = st_pcie_link_up,
 	.host_init = st_pcie_host_init,
+	.setup_bus = st_pcie_setup_bus,
 };
 
 static int st_pcie_init(struct pcie_port *pp)
-- 
1.9.1

