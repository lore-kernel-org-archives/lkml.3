Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934466Ab3BMQO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:14:57 -0500
Received: from www.linutronix.de ([62.245.132.108]:59788 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934455Ab3BMQOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:14:10 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Carsten Emde <C.Emde@osadl.org>, Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 07/12] net: Use local_bh_disable in netif_rx_ni()
Date: Wed, 13 Feb 2013 17:13:46 +0100
Message-Id: <1360772031-27186-8-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360772031-27186-1-git-send-email-bigeasy@linutronix.de>
References: <1360772031-27186-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

This code triggers the new WARN in __raise_softirq_irqsoff() though it
actually looks at the softirq pending bit and calls into the softirq
code, but that fits not well with the context related softirq model of
RT. It's correct on mainline though, but going through
local_bh_disable/enable here is not going to hurt badly.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/core/dev.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 5a40075..c0a6400 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2965,11 +2965,9 @@ int netif_rx_ni(struct sk_buff *skb)
 {
 	int err;
 
-	migrate_disable();
+	local_bh_disable();
 	err = netif_rx(skb);
-	if (local_softirq_pending())
-		thread_do_softirq();
-	migrate_enable();
+	local_bh_enable();
 
 	return err;
 }
-- 
1.7.10.4

