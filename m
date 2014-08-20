Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbaHTMGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:06:09 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58927 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525AbaHTLoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:10 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Kirill Tkhai <tkhai@yandex.ru>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 044/104] sparc64: Make itc_sync_lock raw
Date: Wed, 20 Aug 2014 13:43:07 +0200
Message-Id: <47b752610108d84c8032b75877b94cdafff0a90e.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill Tkhai <tkhai@yandex.ru>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 49b6c01f4c1de3b5e5427ac5aba80f9f6d27837a ]

One more place where we must not be able
to be preempted or to be interrupted in RT.

Always actually disable interrupts during
synchronization cycle.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/sparc/kernel/smp_64.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index e142545244f2..643bf38ed619 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -150,7 +150,7 @@ void cpu_panic(void)
 #define NUM_ROUNDS	64	/* magic value */
 #define NUM_ITERS	5	/* likewise */
 
-static DEFINE_SPINLOCK(itc_sync_lock);
+static DEFINE_RAW_SPINLOCK(itc_sync_lock);
 static unsigned long go[SLAVE + 1];
 
 #define DEBUG_TICK_SYNC	0
@@ -258,7 +258,7 @@ static void smp_synchronize_one_tick(int cpu)
 	go[MASTER] = 0;
 	membar_safe("#StoreLoad");
 
-	spin_lock_irqsave(&itc_sync_lock, flags);
+	raw_spin_lock_irqsave(&itc_sync_lock, flags);
 	{
 		for (i = 0; i < NUM_ROUNDS*NUM_ITERS; i++) {
 			while (!go[MASTER])
@@ -269,7 +269,7 @@ static void smp_synchronize_one_tick(int cpu)
 			membar_safe("#StoreLoad");
 		}
 	}
-	spin_unlock_irqrestore(&itc_sync_lock, flags);
+	raw_spin_unlock_irqrestore(&itc_sync_lock, flags);
 }
 
 #if defined(CONFIG_SUN_LDOMS) && defined(CONFIG_HOTPLUG_CPU)
-- 
2.0.4

