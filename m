Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab3AVQvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 11:51:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34975 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab3AVQvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 11:51:09 -0500
Date: Tue, 22 Jan 2013 08:49:48 -0800
From: tip-bot for Daniel J Blueman <daniel@numascale-asia.com>
Message-ID: <tip-772c3ff385eda0d0b4744596f87b79a17f8c9282@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, bp@alien8.de, daniel@numascale-asia.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@alien8.de, daniel@numascale-asia.com
In-Reply-To: <1353997932-8475-1-git-send-email-daniel@numascale-asia.com>
References: <1353997932-8475-1-git-send-email-daniel@numascale-asia.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86, AMD, NB: Add multi-domain support
Git-Commit-ID: 772c3ff385eda0d0b4744596f87b79a17f8c9282
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 22 Jan 2013 08:49:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  772c3ff385eda0d0b4744596f87b79a17f8c9282
Gitweb:     http://git.kernel.org/tip/772c3ff385eda0d0b4744596f87b79a17f8c9282
Author:     Daniel J Blueman <daniel@numascale-asia.com>
AuthorDate: Tue, 27 Nov 2012 14:32:09 +0800
Committer:  Borislav Petkov <bp@suse.de>
CommitDate: Thu, 10 Jan 2013 16:17:58 +0100

x86, AMD, NB: Add multi-domain support

Fix get_node_id to match northbridge IDs from the array of detected
ones, allowing multi-server support such as with Numascale's
NumaConnect, renaming to 'amd_get_node_id' for consistency.

Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
Link: http://lkml.kernel.org/r/1353997932-8475-1-git-send-email-daniel@numascale-asia.com
[Boris: shorten lines to fit 80 cols]
Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 arch/x86/include/asm/amd_nb.h | 17 +++++++++++++++++
 drivers/edac/amd64_edac.c     |  6 +++---
 drivers/edac/amd64_edac.h     |  6 ------
 3 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index b3341e9..a54ee1d 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -81,6 +81,23 @@ static inline struct amd_northbridge *node_to_amd_nb(int node)
 	return (node < amd_northbridges.num) ? &amd_northbridges.nb[node] : NULL;
 }
 
+static inline u16 amd_get_node_id(struct pci_dev *pdev)
+{
+	struct pci_dev *misc;
+	int i;
+
+	for (i = 0; i != amd_nb_num(); i++) {
+		misc = node_to_amd_nb(i)->misc;
+
+		if (pci_domain_nr(misc->bus) == pci_domain_nr(pdev->bus) &&
+		    PCI_SLOT(misc->devfn) == PCI_SLOT(pdev->devfn))
+			return i;
+	}
+
+	WARN(1, "Unable to find AMD Northbridge id for %s\n", pci_name(pdev));
+	return 0;
+}
+
 #else
 
 #define amd_nb_num(x)		0
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index ad8bf2a..a3fe39b 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2474,7 +2474,7 @@ static int amd64_init_one_instance(struct pci_dev *F2)
 	struct mem_ctl_info *mci = NULL;
 	struct edac_mc_layer layers[2];
 	int err = 0, ret;
-	u8 nid = get_node_id(F2);
+	u16 nid = amd_get_node_id(F2);
 
 	ret = -ENOMEM;
 	pvt = kzalloc(sizeof(struct amd64_pvt), GFP_KERNEL);
@@ -2566,7 +2566,7 @@ err_ret:
 static int amd64_probe_one_instance(struct pci_dev *pdev,
 				    const struct pci_device_id *mc_type)
 {
-	u8 nid = get_node_id(pdev);
+	u16 nid = amd_get_node_id(pdev);
 	struct pci_dev *F3 = node_to_amd_nb(nid)->misc;
 	struct ecc_settings *s;
 	int ret = 0;
@@ -2616,7 +2616,7 @@ static void amd64_remove_one_instance(struct pci_dev *pdev)
 {
 	struct mem_ctl_info *mci;
 	struct amd64_pvt *pvt;
-	u8 nid = get_node_id(pdev);
+	u16 nid = amd_get_node_id(pdev);
 	struct pci_dev *F3 = node_to_amd_nb(nid)->misc;
 	struct ecc_settings *s = ecc_stngs[nid];
 
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index e864f40..cd7845f 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -292,12 +292,6 @@
 /* MSRs */
 #define MSR_MCGCTL_NBE			BIT(4)
 
-/* AMD sets the first MC device at device ID 0x18. */
-static inline u8 get_node_id(struct pci_dev *pdev)
-{
-	return PCI_SLOT(pdev->devfn) - 0x18;
-}
-
 enum amd_families {
 	K8_CPUS = 0,
 	F10_CPUS,
