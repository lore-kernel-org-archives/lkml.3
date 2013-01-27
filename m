Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab3A0OgO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 09:36:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60229 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965Ab3A0OgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 09:36:11 -0500
Date: Sun, 27 Jan 2013 06:35:50 -0800
From: tip-bot for Wang YanQing <udknight@gmail.com>
Message-ID: <tip-c7b798525b50256c8084215a139fa40b0114bfcc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, udknight@gmail.com,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        stable@kernel.org, tglx@linutronix.de
Reply-To: paulmck@linux.vnet.ibm.com, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@kernel.org, tglx@linutronix.de,
        udknight@gmail.com
In-Reply-To: <20130126075357.GA3205@udknight>
References: <20130126075357.GA3205@udknight>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] smp: Fix SMP function call empty cpu mask race
Git-Commit-ID: c7b798525b50256c8084215a139fa40b0114bfcc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 27 Jan 2013 06:35:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c7b798525b50256c8084215a139fa40b0114bfcc
Gitweb:     http://git.kernel.org/tip/c7b798525b50256c8084215a139fa40b0114bfcc
Author:     Wang YanQing <udknight@gmail.com>
AuthorDate: Sat, 26 Jan 2013 15:53:57 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 27 Jan 2013 13:29:14 +0100

smp: Fix SMP function call empty cpu mask race

I get the following warning every day with v3.7, once or
twice a day:

  [ 2235.186027] WARNING: at /mnt/sda7/kernel/linux/arch/x86/kernel/apic/ipi.c:109 default_send_IPI_mask_logical+0x2f/0xb8()

As explained by Linus as well:

 |
 | Once we've done the "list_add_rcu()" to add it to the
 | queue, we can have (another) IPI to the target CPU that can
 | now see it and clear the mask.
 |
 | So by the time we get to actually send the IPI, the mask might
 | have been cleared by another IPI.
 |

This patch also fixes a system hang problem, if the data->cpumask
gets cleared after passing this point:

        if (WARN_ONCE(!mask, "empty IPI mask"))
                return;

then the problem in commit 83d349f35e1a ("x86: don't send an IPI to
the empty set of CPU's") will happen again.

Signed-off-by: Wang YanQing <udknight@gmail.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: peterz@infradead.org
Cc: mina86@mina86.org
Cc: srivatsa.bhat@linux.vnet.ibm.com
Cc: <stable@kernel.org>
Link: http://lkml.kernel.org/r/20130126075357.GA3205@udknight
[ Tidied up the changelog and the comment in the code. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/smp.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 29dd40a..93e576e 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -33,6 +33,7 @@ struct call_function_data {
 	struct call_single_data	csd;
 	atomic_t		refs;
 	cpumask_var_t		cpumask;
+	cpumask_var_t		cpumask_ipi;
 };
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_function_data, cfd_data);
@@ -526,6 +527,12 @@ void smp_call_function_many(const struct cpumask *mask,
 		return;
 	}
 
+	/*
+	 * After we put an entry into the list, data->cpumask
+	 * may be cleared again when another CPU sends another IPI for
+	 * a SMP function call, so data->cpumask will be zero.
+	 */
+	cpumask_copy(data->cpumask_ipi, data->cpumask);
 	raw_spin_lock_irqsave(&call_function.lock, flags);
 	/*
 	 * Place entry at the _HEAD_ of the list, so that any cpu still
@@ -549,7 +556,7 @@ void smp_call_function_many(const struct cpumask *mask,
 	smp_mb();
 
 	/* Send a message to all CPUs in the map */
-	arch_send_call_function_ipi_mask(data->cpumask);
+	arch_send_call_function_ipi_mask(data->cpumask_ipi);
 
 	/* Optionally wait for the CPUs to complete */
 	if (wait)
