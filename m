Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715AbaEPNhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:37:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54338 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757441AbaEPNhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:37:50 -0400
Date: Fri, 16 May 2014 06:36:54 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-be4034016c11f8913d38fccf692007fab1c50be1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, schwidefsky@de.ibm.com, peterz@infradead.org,
        tony.luck@intel.com, heiko.carstens@de.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        schwidefsky@de.ibm.com, tony.luck@intel.com, heiko.carstens@de.ibm.com,
        tglx@linutronix.de
In-Reply-To: <20140507154339.811205235@linutronix.de>
References: <20140507154339.811205235@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] s390: Avoid call to irq_reserve_irqs()
Git-Commit-ID: be4034016c11f8913d38fccf692007fab1c50be1
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

Commit-ID:  be4034016c11f8913d38fccf692007fab1c50be1
Gitweb:     http://git.kernel.org/tip/be4034016c11f8913d38fccf692007fab1c50be1
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 7 May 2014 15:44:20 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 16 May 2014 14:05:22 +0200

s390: Avoid call to irq_reserve_irqs()

There is no need to mark the lower interrupts as reserved in order to
exclude them from dynamic allocation.

Provide arch_dynirq_lower_bound() to exclude the lower space.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Link: http://lkml.kernel.org/r/20140507154339.811205235@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/s390/kernel/irq.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/irq.c b/arch/s390/kernel/irq.c
index 2fb0998..99b0b09 100644
--- a/arch/s390/kernel/irq.c
+++ b/arch/s390/kernel/irq.c
@@ -92,7 +92,6 @@ static const struct irq_class irqclass_sub_desc[NR_ARCH_IRQS] = {
 
 void __init init_IRQ(void)
 {
-	irq_reserve_irqs(0, THIN_INTERRUPT);
 	init_cio_interrupts();
 	init_airq_interrupts();
 	init_ext_interrupts();
@@ -151,6 +150,11 @@ out:
 	return 0;
 }
 
+unsigned int arch_dynirq_lower_bound(unsigned int from)
+{
+	return from < THIN_INTERRUPT ? THIN_INTERRUPT : from;
+}
+
 /*
  * Switch to the asynchronous interrupt stack for softirq execution.
  */
