Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab3A1E7E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 23:59:04 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:47735 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab3A1E7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 23:59:00 -0500
Date: Mon, 28 Jan 2013 12:59:28 +0800
From: Wang YanQing <udknight@gmail.com>
To: mingo@kernel.org
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-tip-commits@vger.kernel.org, akpm@linux-foundation.org,
        hpa@zytor.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de
Subject: [PATCH Resend Resend] smp:Fix use un-initialized cpumask_ipi
Message-ID: <20130128045928.GA3829@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, mingo@kernel.org,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-tip-commits@vger.kernel.org, akpm@linux-foundation.org,
	hpa@zytor.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

c7b798525b50256c8084215a139fa40b0114bfcc
[smp: Fix SMP function call empty cpu mask race]
use the un-initialized variable cpumask_ipi when
enable CONFIG_CPUMASK_OFFSTACK.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 I am sorry for miss it first.

 kernel/smp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/smp.c b/kernel/smp.c
index 7c56aba..af86f5e 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -57,6 +57,9 @@ hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		if (!zalloc_cpumask_var_node(&cfd->cpumask, GFP_KERNEL,
 				cpu_to_node(cpu)))
 			return notifier_from_errno(-ENOMEM);
+		if (!zalloc_cpumask_var_node(&cfd->cpumask_ipi, GFP_KERNEL,
+				cpu_to_node(cpu)))
+			return notifier_from_errno(-ENOMEM);
 		break;
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -66,6 +69,7 @@ hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		free_cpumask_var(cfd->cpumask);
+		free_cpumask_var(cfd->cpumask_ipi);
 		break;
 #endif
 	};
-- 
1.7.11.1.116.g8228a23
