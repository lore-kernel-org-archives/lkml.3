Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab3HKCqP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 22:46:15 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:25516 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab3HKCqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 22:46:09 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 03/28] genirq: Do not free unallocated irq descriptors
Date: Sat, 10 Aug 2013 19:45:13 -0700
Message-Id: <1376189139-31856-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376189139-31856-1-git-send-email-yinghai@kernel.org>
References: <1376189139-31856-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hot-added interrupt controllers can reserve a range of interrupt
numbers, but only allocate some of them. To simplify the release on
hot-remove allow them to iterate over the reserved range, let the
free_desc() code return early when the descriptor does not exist

-v2: changelog from tglx

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 kernel/irq/irqdesc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 1166545..bbf0601 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -165,6 +165,9 @@ static void free_desc(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
+	if (!desc)
+		return;
+
 	unregister_irq_proc(irq, desc);
 
 	mutex_lock(&sparse_irq_lock);
-- 
1.8.1.4

