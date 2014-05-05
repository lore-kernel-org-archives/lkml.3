Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616AbaEEMr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:47:27 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41052 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932328AbaEEMnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:35 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mohit Kumar <mohit.kumar@st.com>,
        Ajay Khandelwal <ajay.khandelwal@st.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 29/50] PCI: designware: Fix iATU programming for cfg1, io and mem viewport
Date: Mon,  5 May 2014 14:43:11 +0200
Message-Id: <7cdf9eb02fea22b615156f5e35ca8974047ee224.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mohit Kumar <mohit.kumar@st.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 017fcdc30cdae18c0946eef1ece1f14b4c7897ba upstream.

This patch corrects iATU programming for cfg1, io and mem viewport.  Enable
ATU only after configuring it.

Signed-off-by: Mohit Kumar <mohit.kumar@st.com>
Signed-off-by: Ajay Khandelwal <ajay.khandelwal@st.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/pci/host/pcie-designware.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
index 09eba9f338fe..510994a7eca0 100644
--- a/drivers/pci/host/pcie-designware.c
+++ b/drivers/pci/host/pcie-designware.c
@@ -268,13 +268,13 @@ static void dw_pcie_prog_viewport_cfg1(struct pcie_port *pp, u32 busdev)
 	dw_pcie_writel_rc(pp, PCIE_ATU_REGION_OUTBOUND | PCIE_ATU_REGION_INDEX1,
 			  PCIE_ATU_VIEWPORT);
 	dw_pcie_writel_rc(pp, PCIE_ATU_TYPE_CFG1, PCIE_ATU_CR1);
-	dw_pcie_writel_rc(pp, PCIE_ATU_ENABLE, PCIE_ATU_CR2);
 	dw_pcie_writel_rc(pp, pp->cfg1_base, PCIE_ATU_LOWER_BASE);
 	dw_pcie_writel_rc(pp, (pp->cfg1_base >> 32), PCIE_ATU_UPPER_BASE);
 	dw_pcie_writel_rc(pp, pp->cfg1_base + pp->config.cfg1_size - 1,
 			  PCIE_ATU_LIMIT);
 	dw_pcie_writel_rc(pp, busdev, PCIE_ATU_LOWER_TARGET);
 	dw_pcie_writel_rc(pp, 0, PCIE_ATU_UPPER_TARGET);
+	dw_pcie_writel_rc(pp, PCIE_ATU_ENABLE, PCIE_ATU_CR2);
 }
 
 static void dw_pcie_prog_viewport_mem_outbound(struct pcie_port *pp)
@@ -283,7 +283,6 @@ static void dw_pcie_prog_viewport_mem_outbound(struct pcie_port *pp)
 	dw_pcie_writel_rc(pp, PCIE_ATU_REGION_OUTBOUND | PCIE_ATU_REGION_INDEX0,
 			  PCIE_ATU_VIEWPORT);
 	dw_pcie_writel_rc(pp, PCIE_ATU_TYPE_MEM, PCIE_ATU_CR1);
-	dw_pcie_writel_rc(pp, PCIE_ATU_ENABLE, PCIE_ATU_CR2);
 	dw_pcie_writel_rc(pp, pp->mem_base, PCIE_ATU_LOWER_BASE);
 	dw_pcie_writel_rc(pp, (pp->mem_base >> 32), PCIE_ATU_UPPER_BASE);
 	dw_pcie_writel_rc(pp, pp->mem_base + pp->config.mem_size - 1,
@@ -291,6 +290,7 @@ static void dw_pcie_prog_viewport_mem_outbound(struct pcie_port *pp)
 	dw_pcie_writel_rc(pp, pp->config.mem_bus_addr, PCIE_ATU_LOWER_TARGET);
 	dw_pcie_writel_rc(pp, upper_32_bits(pp->config.mem_bus_addr),
 			  PCIE_ATU_UPPER_TARGET);
+	dw_pcie_writel_rc(pp, PCIE_ATU_ENABLE, PCIE_ATU_CR2);
 }
 
 static void dw_pcie_prog_viewport_io_outbound(struct pcie_port *pp)
@@ -299,7 +299,6 @@ static void dw_pcie_prog_viewport_io_outbound(struct pcie_port *pp)
 	dw_pcie_writel_rc(pp, PCIE_ATU_REGION_OUTBOUND | PCIE_ATU_REGION_INDEX1,
 			  PCIE_ATU_VIEWPORT);
 	dw_pcie_writel_rc(pp, PCIE_ATU_TYPE_IO, PCIE_ATU_CR1);
-	dw_pcie_writel_rc(pp, PCIE_ATU_ENABLE, PCIE_ATU_CR2);
 	dw_pcie_writel_rc(pp, pp->io_base, PCIE_ATU_LOWER_BASE);
 	dw_pcie_writel_rc(pp, (pp->io_base >> 32), PCIE_ATU_UPPER_BASE);
 	dw_pcie_writel_rc(pp, pp->io_base + pp->config.io_size - 1,
@@ -307,6 +306,7 @@ static void dw_pcie_prog_viewport_io_outbound(struct pcie_port *pp)
 	dw_pcie_writel_rc(pp, pp->config.io_bus_addr, PCIE_ATU_LOWER_TARGET);
 	dw_pcie_writel_rc(pp, upper_32_bits(pp->config.io_bus_addr),
 			  PCIE_ATU_UPPER_TARGET);
+	dw_pcie_writel_rc(pp, PCIE_ATU_ENABLE, PCIE_ATU_CR2);
 }
 
 static int dw_pcie_rd_other_conf(struct pcie_port *pp, struct pci_bus *bus,
-- 
1.9.2

