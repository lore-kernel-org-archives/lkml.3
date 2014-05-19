Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965043AbaESQ3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 12:29:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:34448 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878AbaESQV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 12:21:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,868,1392192000"; 
   d="scan'208";a="534294956"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch Part1 V2 05/29] x86, PCI, ACPI: use kmalloc_node() to optimize for performance
Date: Tue, 20 May 2014 00:22:49 +0800
Message-Id: <1400516594-11544-6-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400516594-11544-1-git-send-email-jiang.liu@linux.intel.com>
References: <1400516594-11544-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kmalloc_node() instead of kmalloc() when possible to optimize
for performance on NUMA platforms.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/pci/acpi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 01edac6c5e18..91bef49df228 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -448,7 +448,7 @@ static void probe_pci_root_info(struct pci_root_info *info,
 		return;
 
 	size = sizeof(*info->res) * info->res_num;
-	info->res = kzalloc(size, GFP_KERNEL);
+	info->res = kzalloc_node(size, GFP_KERNEL, info->sd.node);
 	if (!info->res) {
 		info->res_num = 0;
 		return;
@@ -456,7 +456,7 @@ static void probe_pci_root_info(struct pci_root_info *info,
 
 	size = sizeof(*info->res_offset) * info->res_num;
 	info->res_num = 0;
-	info->res_offset = kzalloc(size, GFP_KERNEL);
+	info->res_offset = kzalloc_node(size, GFP_KERNEL, info->sd.node);
 	if (!info->res_offset) {
 		kfree(info->res);
 		info->res = NULL;
@@ -495,7 +495,7 @@ struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
 	if (node != NUMA_NO_NODE && !node_online(node))
 		node = NUMA_NO_NODE;
 
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	info = kzalloc_node(sizeof(*info), GFP_KERNEL, node);
 	if (!info) {
 		printk(KERN_WARNING "pci_bus %04x:%02x: "
 		       "ignored (out of memory)\n", domain, busnum);
-- 
1.7.10.4

