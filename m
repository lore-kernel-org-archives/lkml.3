Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947009Ab3BHTgI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 14:36:08 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:26044 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946971Ab3BHT24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 14:28:56 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xensource.com
Subject: [PATCH v2 15/26] xen, irq: call irq_realloc_desc_at() at first
Date: Fri,  8 Feb 2013 11:28:12 -0800
Message-Id: <1360351703-20571-16-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
References: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will pre-reserve irq for all gsi at first for x86, so we have to
use realloc with it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xensource.com
---
 drivers/xen/events.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 0be4df3..dda38db 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -482,8 +482,12 @@ static int __must_check xen_allocate_irq_gsi(unsigned gsi)
 	/* Legacy IRQ descriptors are already allocated by the arch. */
 	if (gsi < NR_IRQS_LEGACY)
 		irq = gsi;
-	else
-		irq = irq_alloc_desc_at(gsi, -1);
+	else {
+		/* for x86, irq already get reserved for gsi */
+		irq = irq_realloc_desc_at(gsi, -1);
+		if (irq < 0)
+			irq = irq_alloc_desc_at(gsi, -1);
+	}
 
 	xen_irq_init(irq);
 
-- 
1.7.10.4

