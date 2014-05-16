Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbaEPNhd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:37:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54318 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756570AbaEPNha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:37:30 -0400
Date: Fri, 16 May 2014 06:36:29 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-0a0a94219074d79370b1cd1b533ead63d51c3730@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, schwidefsky@de.ibm.com, peterz@infradead.org,
        tony.luck@intel.com, heiko.carstens@de.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        schwidefsky@de.ibm.com, tony.luck@intel.com, heiko.carstens@de.ibm.com,
        tglx@linutronix.de
In-Reply-To: <20140507154339.409085048@linutronix.de>
References: <20140507154339.409085048@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] s390: pci: Check return value of alloc_irq_desc()
  proper
Git-Commit-ID: 0a0a94219074d79370b1cd1b533ead63d51c3730
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

Commit-ID:  0a0a94219074d79370b1cd1b533ead63d51c3730
Gitweb:     http://git.kernel.org/tip/0a0a94219074d79370b1cd1b533ead63d51c3730
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 7 May 2014 15:44:19 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 16 May 2014 14:05:21 +0200

s390: pci: Check return value of alloc_irq_desc() proper

alloc_irq_desc() returns an integer and as documented either a valid
irq number or a negative error code. Checking for NO_IRQ is definitely
not the proper error handling.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Link: http://lkml.kernel.org/r/20140507154339.409085048@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/s390/pci/pci.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index 1df1d29..2c0076d4 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -401,11 +401,11 @@ static void zpci_irq_handler(struct airq_struct *airq)
 int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 {
 	struct zpci_dev *zdev = get_zdev(pdev);
-	unsigned int hwirq, irq, msi_vecs;
+	unsigned int hwirq, msi_vecs;
 	unsigned long aisb;
 	struct msi_desc *msi;
 	struct msi_msg msg;
-	int rc;
+	int rc, irq;
 
 	if (type == PCI_CAP_ID_MSI && nvec > 1)
 		return 1;
@@ -433,7 +433,7 @@ int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 	list_for_each_entry(msi, &pdev->msi_list, list) {
 		rc = -EIO;
 		irq = irq_alloc_desc(0);	/* Alloc irq on node 0 */
-		if (irq == NO_IRQ)
+		if (irq < 0)
 			goto out_msi;
 		rc = irq_set_msi_desc(irq, msi);
 		if (rc)
