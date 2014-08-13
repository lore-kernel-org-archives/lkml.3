Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbaHMTqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 15:46:14 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46644 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaHMTqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 15:46:12 -0400
Date: Wed, 13 Aug 2014 12:46:11 -0700 (PDT)
Message-Id: <20140813.124611.767426770013677.davem@davemloft.net>
To: mroos@linux.ee
Cc: aaro.koskinen@iki.fi, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, hughd@google.com,
        cat.schulze@alice-dsl.net
Subject: Re: sparc64 WARNING: at mm/mmap.c:2757 exit_mmap+0x13c/0x160()
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.SOC.1.00.1408131327250.18696@math.ut.ee>
References: <alpine.SOC.1.00.1407310101550.2065@math.ut.ee>
	<20140730.150722.861254999466992321.davem@davemloft.net>
	<alpine.SOC.1.00.1408131327250.18696@math.ut.ee>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 13 Aug 2014 12:46:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Meelis Roos <mroos@linux.ee>
Date: Wed, 13 Aug 2014 14:44:42 +0300 (EEST)

> Did not test current git more.

Current git fails to boot without this fix which I posted the other
day:

====================
[PATCH 1/2] sparc64: Do not disable interrupts in nmi_cpu_busy()

nmi_cpu_busy() is a SMP function call that just makes sure that all of the
cpus are spinning using cpu cycles while the NMI test runs.

It does not need to disable IRQs because we just care about NMIs executing
which will even with 'normal' IRQs disabled.

It is not legal to enable hard IRQs in a SMP cross call, in fact this bug
triggers the BUG check in irq_work_run_list():

	BUG_ON(!irqs_disabled());

Because now irq_work_run() is invoked from the tail of
generic_smp_call_function_single_interrupt().

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/kernel/nmi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/sparc/kernel/nmi.c b/arch/sparc/kernel/nmi.c
index 3370945..5b1151d 100644
--- a/arch/sparc/kernel/nmi.c
+++ b/arch/sparc/kernel/nmi.c
@@ -130,7 +130,6 @@ static inline unsigned int get_nmi_count(int cpu)
 
 static __init void nmi_cpu_busy(void *data)
 {
-	local_irq_enable_in_hardirq();
 	while (endflag == 0)
 		mb();
 }
-- 
1.7.11.7

