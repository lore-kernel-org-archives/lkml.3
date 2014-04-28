Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbaD1K0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:26:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42830 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117AbaD1K0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:26:15 -0400
Date: Mon, 28 Apr 2014 03:25:46 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-62a08ae2a5763aabeee98264605236b001503e0c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, heikki.krogerus@intel.com,
        torvalds@linux-foundation.org, rafael.j.wysocki@intel.com,
        andriy.shevchenko@linux.intel.com, yao.jin@linux.intel.com,
        mika.westerberg@linux.intel.com, mathias.nyman@linux.intel.com,
        tglx@linutronix.de, linus.walleij@linaro.org, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, heikki.krogerus@intel.com,
        torvalds@linux-foundation.org, rafael.j.wysocki@intel.com,
        andriy.shevchenko@linux.intel.com, mathias.nyman@linux.intel.com,
        mika.westerberg@linux.intel.com, yao.jin@linux.intel.com,
        tglx@linutronix.de, hpa@linux.intel.com, linus.walleij@linaro.org
In-Reply-To: <alpine.DEB.2.02.1404241617360.28206@ionos.tec.linutronix.de>
References: <alpine.DEB.2.02.1404241617360.28206@ionos.tec.linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] genirq: x86:
  Ensure that dynamic irq allocation does not conflict
Git-Commit-ID: 62a08ae2a5763aabeee98264605236b001503e0c
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

Commit-ID:  62a08ae2a5763aabeee98264605236b001503e0c
Gitweb:     http://git.kernel.org/tip/62a08ae2a5763aabeee98264605236b001503e0c
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 24 Apr 2014 09:50:53 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 28 Apr 2014 12:20:00 +0200

genirq: x86: Ensure that dynamic irq allocation does not conflict

On x86 the allocation of irq descriptors may allocate interrupts which
are in the range of the GSI interrupts. That's wrong as those
interrupts are hardwired and we don't have the irq domain translation
like PPC. So one of these interrupts can be hooked up later to one of
the devices which are hard wired to it and the io_apic init code for
that particular interrupt line happily reuses that descriptor with a
completely different configuration so hell breaks lose.

Inside x86 we allocate dynamic interrupts from above nr_gsi_irqs,
except for a few usage sites which have not yet blown up in our face
for whatever reason. But for drivers which need an irq range, like the
GPIO drivers, we have no limit in place and we don't want to expose
such a detail to a driver.

To cure this introduce a function which an architecture can implement
to impose a lower bound on the dynamic interrupt allocations.

Implement it for x86 and set the lower bound to nr_gsi_irqs, which is
the end of the hardwired interrupt space, so all dynamic allocations
happen above.

That not only allows the GPIO driver to work sanely, it also protects
the bogus callsites of create_irq_nr() in hpet, uv, irq_remapping and
htirq code. They need to be cleaned up as well, but that's a separate
issue.

Reported-by: Jin Yao <yao.jin@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Krogerus Heikki <heikki.krogerus@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1404241617360.28206@ionos.tec.linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/io_apic.c | 5 +++++
 include/linux/irq.h            | 2 ++
 kernel/irq/irqdesc.c           | 7 +++++++
 kernel/softirq.c               | 5 +++++
 4 files changed, 19 insertions(+)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 6ad4658..d23aa82 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3425,6 +3425,11 @@ int get_nr_irqs_gsi(void)
 	return nr_irqs_gsi;
 }
 
+unsigned int arch_dynirq_lower_bound(unsigned int from)
+{
+	return from < nr_irqs_gsi ? nr_irqs_gsi : from;
+}
+
 int __init arch_probe_nr_irqs(void)
 {
 	int nr;
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 10a0b1a..5c57efb 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -603,6 +603,8 @@ static inline u32 irq_get_trigger_type(unsigned int irq)
 	return d ? irqd_get_trigger_type(d) : 0;
 }
 
+unsigned int arch_dynirq_lower_bound(unsigned int from);
+
 int __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
 		struct module *owner);
 
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index a7174617..bb07f29 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -363,6 +363,13 @@ __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
 		if (from > irq)
 			return -EINVAL;
 		from = irq;
+	} else {
+		/*
+		 * For interrupts which are freely allocated the
+		 * architecture can force a lower bound to the @from
+		 * argument. x86 uses this to exclude the GSI space.
+		 */
+		from = arch_dynirq_lower_bound(from);
 	}
 
 	mutex_lock(&sparse_irq_lock);
diff --git a/kernel/softirq.c b/kernel/softirq.c
index b50990a..33e4648 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -779,3 +779,8 @@ int __init __weak arch_early_irq_init(void)
 {
 	return 0;
 }
+
+unsigned int __weak arch_dynirq_lower_bound(unsigned int from)
+{
+	return from;
+}
