Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab3GIOSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 10:18:44 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10016 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab3GIOSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 10:18:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 09 Jul 2013 07:19:30 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <tglx@linutronix.de>
CC: <linux-kernel@vger.kernel.org>, sreenivasulu velpula <svelpula@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] kernel: irq: Call irq_chip->irq_mask in irq_disable
Date: Tue, 9 Jul 2013 19:56:47 +0530
Message-ID: <1373380007-6019-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: sreenivasulu velpula <svelpula@nvidia.com>

If interrupt driver has implemented the irq_mask/irq_unmask
callbacks for disable/enable interrupt then call these APIs
from irq_disable/irq_enable.

Currently, on irq_disable(), it just look for the callback
irq_disable() implemented by chip interrupt driver not the
irq_mask().

Add check for the valid callback of irq_mask() and if it is
there then call it from irq_disable.

This is based on change done by:
	sreenivasulu velpula <svelpula@nvidia.com>

Signed-off-by: sreenivasulu velpula <svelpula@nvidia.com>
Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 kernel/irq/chip.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index a3bb14f..b6efb92 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -232,6 +232,9 @@ void irq_disable(struct irq_desc *desc)
 	if (desc->irq_data.chip->irq_disable) {
 		desc->irq_data.chip->irq_disable(&desc->irq_data);
 		irq_state_set_masked(desc);
+	} else if (desc->irq_data.chip->irq_mask) {
+		desc->irq_data.chip->irq_mask(&desc->irq_data);
+		irq_state_set_masked(desc);
 	}
 }
 
-- 
1.7.1.1

