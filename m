Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbaKZXKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:10:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58290 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761AbaKZXKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:10:05 -0500
Date: Wed, 26 Nov 2014 15:09:16 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-786964a35e95596bbade35eab393fd9b01bd2cad@git.kernel.org>
Cc: tglx@linutronix.de, gregkh@linuxfoundation.org, jiang.liu@linux.intel.com,
        bhelgaas@google.com, bp@alien8.de, rjw@rjwysocki.net, joro@8bytes.org,
        yinghai@kernel.org, benh@kernel.crashing.org, rdunlap@infradead.org,
        linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        tony.luck@intel.com, hpa@zytor.com, mingo@kernel.org
Reply-To: tglx@linutronix.de, gregkh@linuxfoundation.org,
        jiang.liu@linux.intel.com, bhelgaas@google.com, rjw@rjwysocki.net,
        bp@alien8.de, joro@8bytes.org, yinghai@kernel.org,
        rdunlap@infradead.org, benh@kernel.crashing.org, tony.luck@intel.com,
        konrad.wilk@oracle.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org
In-Reply-To: <1416894816-23245-15-git-send-email-jiang.liu@linux.intel.com>
References: <1416894816-23245-15-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq: Directly call native_compose_msi_msg()
  for DMAR IRQ
Git-Commit-ID: 786964a35e95596bbade35eab393fd9b01bd2cad
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

Commit-ID:  786964a35e95596bbade35eab393fd9b01bd2cad
Gitweb:     http://git.kernel.org/tip/786964a35e95596bbade35eab393fd9b01bd2cad
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 13:53:23 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 18:59:25 +0100

x86, irq: Directly call native_compose_msi_msg() for DMAR IRQ

DMAR interrupt won't be remapped by interrupt remapping hardware,
so directly call native_compose_msi_msg() for DMAR IRQ to compose MSI
message data. This will help to simplify MSI code later.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1416894816-23245-15-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/msi.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index e82ab79..fa2dd6e 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -259,12 +259,10 @@ static struct irq_chip dmar_msi_type = {
 
 int arch_setup_dmar_msi(unsigned int irq)
 {
-	int ret;
 	struct msi_msg msg;
+	struct irq_cfg *cfg = irq_cfg(irq);
 
-	ret = msi_compose_msg(NULL, irq, &msg, -1);
-	if (ret < 0)
-		return ret;
+	native_compose_msi_msg(NULL, irq, cfg->dest_apicid, &msg, -1);
 	dmar_msi_write(irq, &msg);
 	irq_set_chip_and_handler_name(irq, &dmar_msi_type, handle_edge_irq,
 				      "edge");
