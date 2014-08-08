Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457AbaHHWOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:14:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60327 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758577AbaHHVf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:35:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kirill Tkhai <tkhai@yandex.ru>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.4 12/23] sparc64: Make itc_sync_lock raw
Date: Fri,  8 Aug 2014 14:34:57 -0700
Message-Id: <20140808213316.281786636@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140808213315.769217722@linuxfoundation.org>
References: <20140808213315.769217722@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kirill Tkhai <tkhai@yandex.ru>

[ Upstream commit 49b6c01f4c1de3b5e5427ac5aba80f9f6d27837a ]

One more place where we must not be able
to be preempted or to be interrupted in RT.

Always actually disable interrupts during
synchronization cycle.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/kernel/smp_64.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -151,7 +151,7 @@ void cpu_panic(void)
 #define NUM_ROUNDS	64	/* magic value */
 #define NUM_ITERS	5	/* likewise */
 
-static DEFINE_SPINLOCK(itc_sync_lock);
+static DEFINE_RAW_SPINLOCK(itc_sync_lock);
 static unsigned long go[SLAVE + 1];
 
 #define DEBUG_TICK_SYNC	0
@@ -259,7 +259,7 @@ static void smp_synchronize_one_tick(int
 	go[MASTER] = 0;
 	membar_safe("#StoreLoad");
 
-	spin_lock_irqsave(&itc_sync_lock, flags);
+	raw_spin_lock_irqsave(&itc_sync_lock, flags);
 	{
 		for (i = 0; i < NUM_ROUNDS*NUM_ITERS; i++) {
 			while (!go[MASTER])
@@ -270,7 +270,7 @@ static void smp_synchronize_one_tick(int
 			membar_safe("#StoreLoad");
 		}
 	}
-	spin_unlock_irqrestore(&itc_sync_lock, flags);
+	raw_spin_unlock_irqrestore(&itc_sync_lock, flags);
 }
 
 #if defined(CONFIG_SUN_LDOMS) && defined(CONFIG_HOTPLUG_CPU)


