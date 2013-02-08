Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947001Ab3BHUCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 15:02:10 -0500
Received: from mail.tpi.com ([70.99.223.143]:3367 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946915Ab3BHUCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 15:02:08 -0500
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: [PATCH linux-next] perf/x86: x86_schedule_events(): avoid 512 byte stack variable
Date: Fri,  8 Feb 2013 13:01:56 -0700
Message-Id: <1360353716-51368-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_schedule_events() creates a 512 byte automatic variable
when compiled for 64 bit. Dynamically allocate this array
to avoid possible stack corruption. Smatch analysis:

arch/x86/kernel/cpu/perf_event.c:727 x86_schedule_events() warn:
 'constraints' puts 512 bytes on stack

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: <stable@vger.kernel.org> # 2.6.34.y and higher
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---

This large stack variable was introduced with 63b146490befc027a7e0923e333269e68b20d380
in 2.6.34. Since it has been around for awhile I don't know if its really a
problem on this code path, but it does consume a good size chunk of the kernel stack.

Applies cleanly to 3.3.y and higher. Needs backport for older kernels.

 arch/x86/kernel/cpu/perf_event.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index bf0f01a..1f2005e 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -718,11 +718,15 @@ int perf_assign_events(struct event_constraint **constraints, int n,
 
 int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 {
-	struct event_constraint *c, *constraints[X86_PMC_IDX_MAX];
+	struct event_constraint *c, **constraints;
 	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	int i, wmin, wmax, num = 0;
 	struct hw_perf_event *hwc;
 
+	constraints = kmalloc(X86_PMC_IDX_MAX*sizeof(*constraints), GFP_ATOMIC);
+	if (!constraints)
+		return -ENOMEM;
+
 	bitmap_zero(used_mask, X86_PMC_IDX_MAX);
 
 	for (i = 0, wmin = X86_PMC_IDX_MAX, wmax = 0; i < n; i++) {
@@ -770,6 +774,9 @@ int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 				x86_pmu.put_event_constraints(cpuc, cpuc->event_list[i]);
 		}
 	}
+
+	kfree(constraints);
+
 	return num ? -EINVAL : 0;
 }
 
-- 
1.7.9.5

