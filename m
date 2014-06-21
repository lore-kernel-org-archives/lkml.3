Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178AbaFUVLP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 17:11:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35544 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756895AbaFUVLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 17:11:12 -0400
Date: Sat, 21 Jun 2014 14:10:15 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-965cd0e4a5e5d704934fa6d476b1a4faa0417e1b@git.kernel.org>
Cc: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        rientjes@google.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        jiang.liu@linux.intel.com, grant.likely@linaro.org, yinghai@kernel.org,
        joro@8bytes.org, bhelgaas@google.com, benh@kernel.crashing.org,
        rjw@rjwysocki.net, paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        rientjes@google.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        jiang.liu@linux.intel.com, grant.likely@linaro.org, yinghai@kernel.org,
        joro@8bytes.org, bhelgaas@google.com, benh@kernel.crashing.org,
        rjw@rjwysocki.net, paul.gortmaker@windriver.com
In-Reply-To: <1402302011-23642-6-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-6-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, PCI, ACPI: Use kmalloc_node()
  to optimize for performance
Git-Commit-ID: 965cd0e4a5e5d704934fa6d476b1a4faa0417e1b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  965cd0e4a5e5d704934fa6d476b1a4faa0417e1b
Gitweb:     http://git.kernel.org/tip/965cd0e4a5e5d704934fa6d476b1a4faa0417e1b
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 9 Jun 2014 16:19:34 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 21 Jun 2014 23:05:40 +0200

x86, PCI, ACPI: Use kmalloc_node() to optimize for performance

Use kmalloc_node() instead of kmalloc() when possible to optimize
for performance on NUMA platforms.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1402302011-23642-6-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/pci/acpi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 5075371..cfd1b13 100644
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
@@ -499,7 +499,7 @@ struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
 	if (node != NUMA_NO_NODE && !node_online(node))
 		node = NUMA_NO_NODE;
 
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	info = kzalloc_node(sizeof(*info), GFP_KERNEL, node);
 	if (!info) {
 		printk(KERN_WARNING "pci_bus %04x:%02x: "
 		       "ignored (out of memory)\n", domain, busnum);
