Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab3AVQxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 11:53:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35005 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499Ab3AVQxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 11:53:36 -0500
Date: Tue, 22 Jan 2013 08:52:08 -0800
From: tip-bot for Daniel J Blueman <daniel@numascale-asia.com>
Message-ID: <tip-e2c0bffea2574c088d86a9f1f661a84bc8fea2fd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, bp@alien8.de, daniel@numascale-asia.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@alien8.de, daniel@numascale-asia.com
In-Reply-To: <1354265060-22956-1-git-send-email-daniel@numascale-asia.com>
References: <1354265060-22956-1-git-send-email-daniel@numascale-asia.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] amd64_edac: Fix PCI function lookup
Git-Commit-ID: e2c0bffea2574c088d86a9f1f661a84bc8fea2fd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 22 Jan 2013 08:52:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e2c0bffea2574c088d86a9f1f661a84bc8fea2fd
Gitweb:     http://git.kernel.org/tip/e2c0bffea2574c088d86a9f1f661a84bc8fea2fd
Author:     Daniel J Blueman <daniel@numascale-asia.com>
AuthorDate: Fri, 30 Nov 2012 16:44:19 +0800
Committer:  Borislav Petkov <bp@suse.de>
CommitDate: Thu, 10 Jan 2013 16:17:59 +0100

amd64_edac: Fix PCI function lookup

Fix locating sibling memory controller PCI functions by using the
correct PCI domain and use a northbridge descriptor only if found. We
need to at least warn if it wasn't found so that it gets fixed and we
don't go off with wrong results.

Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
Link: http://lkml.kernel.org/r/1354265060-22956-1-git-send-email-daniel@numascale-asia.com
[Boris: remove wrong comment, sanitize code and warn if NB desc lookup fails]
Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 drivers/edac/amd64_edac.c | 72 +++++++++++++++++++++++++----------------------
 1 file changed, 38 insertions(+), 34 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 29be39d..da76912 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -980,10 +980,29 @@ static u64 get_error_address(struct mce *m)
 	return addr;
 }
 
+static struct pci_dev *pci_get_related_function(unsigned int vendor,
+						unsigned int device,
+						struct pci_dev *related)
+{
+	struct pci_dev *dev = NULL;
+
+	while ((dev = pci_get_device(vendor, device, dev))) {
+		if (pci_domain_nr(dev->bus) == pci_domain_nr(related->bus) &&
+		    (dev->bus->number == related->bus->number) &&
+		    (PCI_SLOT(dev->devfn) == PCI_SLOT(related->devfn)))
+			break;
+	}
+
+	return dev;
+}
+
 static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
 {
+	struct amd_northbridge *nb;
+	struct pci_dev *misc, *f1 = NULL;
 	struct cpuinfo_x86 *c = &boot_cpu_data;
 	int off = range << 3;
+	u32 llim;
 
 	amd64_read_pci_cfg(pvt->F1, DRAM_BASE_LO + off,  &pvt->ranges[range].base.lo);
 	amd64_read_pci_cfg(pvt->F1, DRAM_LIMIT_LO + off, &pvt->ranges[range].lim.lo);
@@ -997,30 +1016,32 @@ static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
 	amd64_read_pci_cfg(pvt->F1, DRAM_BASE_HI + off,  &pvt->ranges[range].base.hi);
 	amd64_read_pci_cfg(pvt->F1, DRAM_LIMIT_HI + off, &pvt->ranges[range].lim.hi);
 
-	/* Factor in CC6 save area by reading dst node's limit reg */
-	if (c->x86 == 0x15) {
-		struct pci_dev *f1 = NULL;
-		u8 nid = dram_dst_node(pvt, range);
-		u32 llim;
+	/* F15h: factor in CC6 save area by reading dst node's limit reg */
+	if (c->x86 != 0x15)
+		return;
 
-		f1 = pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(0x18 + nid, 1));
-		if (WARN_ON(!f1))
-			return;
+	nb = node_to_amd_nb(dram_dst_node(pvt, range));
+	if (WARN_ON(!nb))
+		return;
 
-		amd64_read_pci_cfg(f1, DRAM_LOCAL_NODE_LIM, &llim);
+	misc = nb->misc;
+	f1 = pci_get_related_function(misc->vendor, PCI_DEVICE_ID_AMD_15H_NB_F1, misc);
+	if (WARN_ON(!f1))
+		return;
 
-		pvt->ranges[range].lim.lo &= GENMASK(0, 15);
+	amd64_read_pci_cfg(f1, DRAM_LOCAL_NODE_LIM, &llim);
 
-					    /* {[39:27],111b} */
-		pvt->ranges[range].lim.lo |= ((llim & 0x1fff) << 3 | 0x7) << 16;
+	pvt->ranges[range].lim.lo &= GENMASK(0, 15);
 
-		pvt->ranges[range].lim.hi &= GENMASK(0, 7);
+				    /* {[39:27],111b} */
+	pvt->ranges[range].lim.lo |= ((llim & 0x1fff) << 3 | 0x7) << 16;
 
-					    /* [47:40] */
-		pvt->ranges[range].lim.hi |= llim >> 13;
+	pvt->ranges[range].lim.hi &= GENMASK(0, 7);
 
-		pci_dev_put(f1);
-	}
+				    /* [47:40] */
+	pvt->ranges[range].lim.hi |= llim >> 13;
+
+	pci_dev_put(f1);
 }
 
 static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
@@ -1673,23 +1694,6 @@ static struct amd64_family_type amd64_family_types[] = {
 	},
 };
 
-static struct pci_dev *pci_get_related_function(unsigned int vendor,
-						unsigned int device,
-						struct pci_dev *related)
-{
-	struct pci_dev *dev = NULL;
-
-	dev = pci_get_device(vendor, device, dev);
-	while (dev) {
-		if ((dev->bus->number == related->bus->number) &&
-		    (PCI_SLOT(dev->devfn) == PCI_SLOT(related->devfn)))
-			break;
-		dev = pci_get_device(vendor, device, dev);
-	}
-
-	return dev;
-}
-
 /*
  * These are tables of eigenvectors (one per line) which can be used for the
  * construction of the syndrome tables. The modified syndrome search algorithm
