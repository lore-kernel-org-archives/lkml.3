Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbaACAWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:22:39 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23184 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbaACAGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:06:03 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xensource.com
Subject: [PATCH v5 16/33] xen, irq: Call irq_alloc_reserved_desc_at() at first
Date: Thu,  2 Jan 2014 16:05:48 -0800
Message-Id: <1388707565-16535-17-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1388707565-16535-1-git-send-email-yinghai@kernel.org>
References: <1388707565-16535-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To make x86 irq allocation to be same with booting path and ioapic
hot add path, We will pre-reserve irq for all gsi at first.
We have to use alloc_reserved here, otherwise irq_alloc_desc_at will fail
because bit is already get marked for pre-reserved in irq bitmaps.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xensource.com
---
 drivers/xen/events.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 4035e83..020cd77 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -508,8 +508,12 @@ static int __must_check xen_allocate_irq_gsi(unsigned gsi)
 	/* Legacy IRQ descriptors are already allocated by the arch. */
 	if (gsi < NR_IRQS_LEGACY)
 		irq = gsi;
-	else
-		irq = irq_alloc_desc_at(gsi, -1);
+	else {
+		/* for x86, irq already get reserved for gsi */
+		irq = irq_alloc_reserved_desc_at(gsi, -1);
+		if (irq < 0)
+			irq = irq_alloc_desc_at(gsi, -1);
+	}
 
 	xen_irq_init(irq);
 
-- 
1.8.4

