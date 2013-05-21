Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536Ab3EUA5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 20:57:18 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53212 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655Ab3EUA5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 20:57:16 -0400
X-IronPort-AV: E=Sophos;i="4.87,711,1363158000"; 
   d="scan'208";a="49119113"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kevin Hilman <khilman@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] ARM: smp: Drop RCU_NONIDLE usage in cpu_die()
Date: Mon, 20 May 2013 17:57:16 -0700
Message-Id: <1369097836-19756-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.rc2.10.g0c2b1cf.dirty
In-Reply-To: <20130501005523.GN3780@linux.vnet.ibm.com>
References: <20130501005523.GN3780@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before f7b861b (arm: Use generic idle loop, 2013-03-21) ARM would
kill the CPU within the rcu idle section. Now that the
rcu_idle_enter()/exit() pair have been pushed lower down in the
idle loop this is no longer true and so using RCU_NONIDLE here is
no longer necessary and also harmful because RCU is not actually
idle at this point.

Cc: Russell King <linux@arm.linux.org.uk>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/kernel/smp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 4619177..78f1eb5 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -233,7 +233,7 @@ void __ref cpu_die(void)
 	mb();
 
 	/* Tell __cpu_die() that this CPU is now safe to dispose of */
-	RCU_NONIDLE(complete(&cpu_died));
+	complete(&cpu_died);
 
 	/*
 	 * actual CPU shutdown procedure is at least platform (if not
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

