Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbaIKNQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:16:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51512 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755375AbaIKMeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Kirill Tkhai" <tkhai@yandex.ru>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.828546106@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 109/131] sparc64: Make itc_sync_lock raw
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Kirill Tkhai <tkhai@yandex.ru>

[ Upstream commit 49b6c01f4c1de3b5e5427ac5aba80f9f6d27837a ]

One more place where we must not be able
to be preempted or to be interrupted in RT.

Always actually disable interrupts during
synchronization cycle.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/sparc/kernel/smp_64.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index e21d3c0d..ffd1245 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -151,7 +151,7 @@ void cpu_panic(void)
 #define NUM_ROUNDS	64	/* magic value */
 #define NUM_ITERS	5	/* likewise */
 
-static DEFINE_SPINLOCK(itc_sync_lock);
+static DEFINE_RAW_SPINLOCK(itc_sync_lock);
 static unsigned long go[SLAVE + 1];
 
 #define DEBUG_TICK_SYNC	0
@@ -259,7 +259,7 @@ static void smp_synchronize_one_tick(int cpu)
 	go[MASTER] = 0;
 	membar_safe("#StoreLoad");
 
-	spin_lock_irqsave(&itc_sync_lock, flags);
+	raw_spin_lock_irqsave(&itc_sync_lock, flags);
 	{
 		for (i = 0; i < NUM_ROUNDS*NUM_ITERS; i++) {
 			while (!go[MASTER])
@@ -270,7 +270,7 @@ static void smp_synchronize_one_tick(int cpu)
 			membar_safe("#StoreLoad");
 		}
 	}
-	spin_unlock_irqrestore(&itc_sync_lock, flags);
+	raw_spin_unlock_irqrestore(&itc_sync_lock, flags);
 }
 
 #if defined(CONFIG_SUN_LDOMS) && defined(CONFIG_HOTPLUG_CPU)

