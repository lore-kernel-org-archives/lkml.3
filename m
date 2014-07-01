Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbaGATXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 15:23:54 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44279 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561AbaGATXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 15:23:50 -0400
From: Borislav Petkov <bp@alien8.de>
To: linux-edac <linux-edac@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -v3 1/4] x86, MCE: Make the mce_ring explicit
Date: Tue,  1 Jul 2014 21:23:40 +0200
Message-Id: <1404242623-10094-2-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404242623-10094-1-git-send-email-bp@alien8.de>
References: <1404242623-10094-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

We would want to hand down a ring on which to operate so make it an
argument.

Use the obvious mce_ring_empty() in mce_ring_get() for better
readability.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 4fc57975acc1..4c0167070e2e 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -476,23 +476,21 @@ struct mce_ring {
 static DEFINE_PER_CPU(struct mce_ring, mce_ring);
 
 /* Runs with CPU affinity in workqueue */
-static int mce_ring_empty(void)
+static inline int mce_ring_empty(struct mce_ring *r)
 {
-	struct mce_ring *r = &__get_cpu_var(mce_ring);
-
 	return r->start == r->end;
 }
 
-static int mce_ring_get(unsigned long *pfn)
+static int mce_ring_get(struct mce_ring *r, unsigned long *pfn)
 {
-	struct mce_ring *r;
 	int ret = 0;
 
 	*pfn = 0;
 	get_cpu();
-	r = &__get_cpu_var(mce_ring);
-	if (r->start == r->end)
+
+	if (mce_ring_empty(r))
 		goto out;
+
 	*pfn = r->ring[r->start];
 	r->start = (r->start + 1) % MCE_RING_SIZE;
 	ret = 1;
@@ -502,9 +500,8 @@ out:
 }
 
 /* Always runs in MCE context with preempt off */
-static int mce_ring_add(unsigned long pfn)
+static int mce_ring_add(struct mce_ring *r, unsigned long pfn)
 {
-	struct mce_ring *r = &__get_cpu_var(mce_ring);
 	unsigned next;
 
 	next = (r->end + 1) % MCE_RING_SIZE;
@@ -525,7 +522,7 @@ int mce_available(struct cpuinfo_x86 *c)
 
 static void mce_schedule_work(void)
 {
-	if (!mce_ring_empty())
+	if (!mce_ring_empty(&__get_cpu_var(mce_ring)))
 		schedule_work(&__get_cpu_var(mce_work));
 }
 
@@ -1122,7 +1119,8 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		 * RED-PEN don't ignore overflow for mca_cfg.tolerant == 0
 		 */
 		if (severity == MCE_AO_SEVERITY && mce_usable_address(&m))
-			mce_ring_add(m.addr >> PAGE_SHIFT);
+			mce_ring_add(&__get_cpu_var(mce_ring),
+				     m.addr >> PAGE_SHIFT);
 
 		mce_log(&m);
 
@@ -1229,7 +1227,7 @@ static void mce_process_work(struct work_struct *dummy)
 {
 	unsigned long pfn;
 
-	while (mce_ring_get(&pfn))
+	while (mce_ring_get(&__get_cpu_var(mce_ring), &pfn))
 		memory_failure(pfn, MCE_VECTOR, 0);
 }
 
-- 
2.0.0

