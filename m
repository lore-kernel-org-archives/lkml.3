Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab3AZHxY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 02:53:24 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:56576 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab3AZHxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 02:53:22 -0500
Date: Sat, 26 Jan 2013 15:53:57 +0800
From: Wang YanQing <udknight@gmail.com>
To: akpm@linux-foundation.org
Cc: peterz@infradead.org, tglx@linutronix.de, mina86@mina86.org,
        srivatsa.bhat@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Subject: [PATCH]smp: Fix send func call IPI to empty cpu mask
Message-ID: <20130126075357.GA3205@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	akpm@linux-foundation.org, peterz@infradead.org, tglx@linutronix.de,
	mina86@mina86.org, srivatsa.bhat@linux.vnet.ibm.com,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	stable@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get below warning every day with 3.7,
one or two times per day.

[ 2235.186027] WARNING: at /mnt/sda7/kernel/linux/arch/x86/kernel/apic/ipi.c:109 default_send_IPI_mask_logical+0x2f/0xb8()
[ 2235.186030] Hardware name: Aspire 4741
[ 2235.186032] empty IPI mask
[ 2235.186034] Modules linked in: vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) nvidia(PO) wl(O)
[ 2235.186046] Pid: 5542, comm: pool Tainted: P           O 3.7.2+ #41
[ 2235.186049] Call Trace:
[ 2235.186059]  [<c1020ec7>] warn_slowpath_common+0x65/0x7a
[ 2235.186064]  [<c1016bf0>] ? default_send_IPI_mask_logical+0x2f/0xb8
[ 2235.186069]  [<c1020f40>] warn_slowpath_fmt+0x26/0x2a
[ 2235.186074]  [<c1016bf0>] default_send_IPI_mask_logical+0x2f/0xb8
[ 2235.186079]  [<c1015cbc>] native_send_call_func_ipi+0x4f/0x57
[ 2235.186087]  [<c1053453>] smp_call_function_many+0x191/0x1a9
[ 2235.186092]  [<c101dffc>] ? do_flush_tlb_all+0x3f/0x3f
[ 2235.186097]  [<c101e074>] native_flush_tlb_others+0x21/0x24
[ 2235.186101]  [<c101e0da>] flush_tlb_page+0x63/0x89
[ 2235.186105]  [<c101d360>] ptep_set_access_flags+0x20/0x26
[ 2235.186111]  [<c108fadd>] do_wp_page+0x234/0x502
[ 2235.186117]  [<c1043f1a>] ? T.2009+0x31/0x35
[ 2235.186121]  [<c1090825>] handle_pte_fault+0x50d/0x54c
[ 2235.186128]  [<c1027150>] ? irq_exit+0x5f/0x61
[ 2235.186133]  [<c1015c47>] ? smp_call_function_interrupt+0x2c/0x2e
[ 2235.186143]  [<c12db06d>] ? call_function_interrupt+0x2d/0x34
[ 2235.186148]  [<c1090934>] handle_mm_fault+0xd0/0xe2
[ 2235.186153]  [<c12dd143>] __do_page_fault+0x411/0x42d
[ 2235.186158]  [<c1052523>] ? sys_futex+0xa9/0xee
[ 2235.186162]  [<c12dd15f>] ? __do_page_fault+0x42d/0x42d
[ 2235.186166]  [<c12dd167>] do_page_fault+0x8/0xa
[ 2235.186170]  [<c12db31a>] error_code+0x5a/0x60
[ 2235.186174]  [<c12dd15f>] ? __do_page_fault+0x42d/0x42d
[ 2235.186177] ---[ end trace 089b20858c3cb340 ]---

This patch fix it.

This patch also fix some system hang problem:
If the data->cpumask been cleared after pass

        if (WARN_ONCE(!mask, "empty IPI mask"))
                return;
then the problem 83d349f3 fix will happen again.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 kernel/smp.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 29dd40a..7c56aba 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -33,6 +33,7 @@ struct call_function_data {
 	struct call_single_data	csd;
 	atomic_t		refs;
 	cpumask_var_t		cpumask;
+	cpumask_var_t		cpumask_ipi;
 };
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_function_data, cfd_data);
@@ -526,6 +527,13 @@ void smp_call_function_many(const struct cpumask *mask,
 		return;
 	}
 
+	/*
+	 * After we put entry into list, data->cpumask
+	 * may be cleared when others cpu respone other
+	 * IPI for call function, then data->cpumask will
+	 * be zero.
+	 */
+	cpumask_copy(data->cpumask_ipi, data->cpumask);
 	raw_spin_lock_irqsave(&call_function.lock, flags);
 	/*
 	 * Place entry at the _HEAD_ of the list, so that any cpu still
@@ -549,7 +557,7 @@ void smp_call_function_many(const struct cpumask *mask,
 	smp_mb();
 
 	/* Send a message to all CPUs in the map */
-	arch_send_call_function_ipi_mask(data->cpumask);
+	arch_send_call_function_ipi_mask(data->cpumask_ipi);
 
 	/* Optionally wait for the CPUs to complete */
 	if (wait)
-- 
1.7.11.1.116.g8228a23
