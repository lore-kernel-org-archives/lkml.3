Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbaDUEf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 00:35:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58686 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbaDUEeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 00:34:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mohit Kumar <mohit.kumar@st.com>,
        Ajay Khandelwal <ajay.khandelwal@st.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 3.13 06/32] PCI: designware: Fix iATU programming for cfg1, io and mem viewport
Date: Sun, 20 Apr 2014 19:13:23 -0700
Message-Id: <20140421021134.738081122@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140421021133.865086647@linuxfoundation.org>
References: <20140421021133.865086647@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohit Kumar <mohit.kumar@st.com>

commit 017fcdc30cdae18c0946eef1ece1f14b4c7897ba upstream.

This patch corrects iATU programming for cfg1, io and mem viewport.  Enable
ATU only after configuring it.

Signed-off-by: Mohit Kumar <mohit.kumar@st.com>
Signed-off-by: Ajay Khandelwal <ajay.khandelwal@st.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/host/pcie-designware.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/pci/host/pcie-designware.c
+++ b/drivers/pci/host/pcie-designware.c
@@ -498,13 +498,13 @@ static void dw_pcie_prog_viewport_cfg1(s
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
@@ -513,7 +513,6 @@ static void dw_pcie_prog_viewport_mem_ou
 	dw_pcie_writel_rc(pp, PCIE_ATU_REGION_OUTBOUND | PCIE_ATU_REGION_INDEX0,
 			  PCIE_ATU_VIEWPORT);
 	dw_pcie_writel_rc(pp, PCIE_ATU_TYPE_MEM, PCIE_ATU_CR1);
-	dw_pcie_writel_rc(pp, PCIE_ATU_ENABLE, PCIE_ATU_CR2);
 	dw_pcie_writel_rc(pp, pp->mem_base, PCIE_ATU_LOWER_BASE);
 	dw_pcie_writel_rc(pp, (pp->mem_base >> 32), PCIE_ATU_UPPER_BASE);
 	dw_pcie_writel_rc(pp, pp->mem_base + pp->config.mem_size - 1,
@@ -521,6 +520,7 @@ static void dw_pcie_prog_viewport_mem_ou
 	dw_pcie_writel_rc(pp, pp->config.mem_bus_addr, PCIE_ATU_LOWER_TARGET);
 	dw_pcie_writel_rc(pp, upper_32_bits(pp->config.mem_bus_addr),
 			  PCIE_ATU_UPPER_TARGET);
+	dw_pcie_writel_rc(pp, PCIE_ATU_ENABLE, PCIE_ATU_CR2);
 }
 
 static void dw_pcie_prog_viewport_io_outbound(struct pcie_port *pp)
@@ -529,7 +529,6 @@ static void dw_pcie_prog_viewport_io_out
 	dw_pcie_writel_rc(pp, PCIE_ATU_REGION_OUTBOUND | PCIE_ATU_REGION_INDEX1,
 			  PCIE_ATU_VIEWPORT);
 	dw_pcie_writel_rc(pp, PCIE_ATU_TYPE_IO, PCIE_ATU_CR1);
-	dw_pcie_writel_rc(pp, PCIE_ATU_ENABLE, PCIE_ATU_CR2);
 	dw_pcie_writel_rc(pp, pp->io_base, PCIE_ATU_LOWER_BASE);
 	dw_pcie_writel_rc(pp, (pp->io_base >> 32), PCIE_ATU_UPPER_BASE);
 	dw_pcie_writel_rc(pp, pp->io_base + pp->config.io_size - 1,
@@ -537,6 +536,7 @@ static void dw_pcie_prog_viewport_io_out
 	dw_pcie_writel_rc(pp, pp->config.io_bus_addr, PCIE_ATU_LOWER_TARGET);
 	dw_pcie_writel_rc(pp, upper_32_bits(pp->config.io_bus_addr),
 			  PCIE_ATU_UPPER_TARGET);
+	dw_pcie_writel_rc(pp, PCIE_ATU_ENABLE, PCIE_ATU_CR2);
 }
 
 static int dw_pcie_rd_other_conf(struct pcie_port *pp, struct pci_bus *bus,


