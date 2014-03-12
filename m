Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbaCLMQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 08:16:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50316 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaCLMQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 08:16:10 -0400
Date: Wed, 12 Mar 2014 05:15:37 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-421d1563c6620423d23e394711e3f209e585c161@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ralf@linux-mips.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20140304203100.744800502@linutronix.de>
References: <20140304203100.744800502@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] mips: Validate online cpus in irq_set_affinity()
  callbacks
Git-Commit-ID: 421d1563c6620423d23e394711e3f209e585c161
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  421d1563c6620423d23e394711e3f209e585c161
Gitweb:     http://git.kernel.org/tip/421d1563c6620423d23e394711e3f209e585c161
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 4 Mar 2014 20:43:39 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 12 Mar 2014 13:07:40 +0100

mips: Validate online cpus in irq_set_affinity() callbacks

The [user space] interface does not filter out offline cpus. It merily
guarantees that the mask contains at least one online cpu.

So the selector in the irq chip implementation needs to make sure to
pick only an online cpu because otherwise:

     Offline Core 1
     Set affinity to 0xe (is valid due to online mask 0xd)
     cpumask_first will pick core 1, which is offline

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
Link: http://lkml.kernel.org/r/20140304203100.744800502@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/mips/sibyte/bcm1480/irq.c | 2 +-
 arch/mips/sibyte/sb1250/irq.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/sibyte/bcm1480/irq.c b/arch/mips/sibyte/bcm1480/irq.c
index 09d6e16..59cfe26 100644
--- a/arch/mips/sibyte/bcm1480/irq.c
+++ b/arch/mips/sibyte/bcm1480/irq.c
@@ -95,7 +95,7 @@ static int bcm1480_set_affinity(struct irq_data *d, const struct cpumask *mask,
 	u64 cur_ints;
 	unsigned long flags;
 
-	i = cpumask_first(mask);
+	i = cpumask_first_and(mask, cpu_online_mask);
 
 	/* Convert logical CPU to physical CPU */
 	cpu = cpu_logical_map(i);
diff --git a/arch/mips/sibyte/sb1250/irq.c b/arch/mips/sibyte/sb1250/irq.c
index fca0cdb..6d8dba5 100644
--- a/arch/mips/sibyte/sb1250/irq.c
+++ b/arch/mips/sibyte/sb1250/irq.c
@@ -88,7 +88,7 @@ static int sb1250_set_affinity(struct irq_data *d, const struct cpumask *mask,
 	u64 cur_ints;
 	unsigned long flags;
 
-	i = cpumask_first(mask);
+	i = cpumask_first_and(mask, cpu_online_mask);
 
 	/* Convert logical CPU to physical CPU */
 	cpu = cpu_logical_map(i);
