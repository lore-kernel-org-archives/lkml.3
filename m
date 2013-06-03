Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab3FCT37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 15:29:59 -0400
Received: from usindpps04.hds.com ([207.126.252.17]:42032 "EHLO
	usindpps04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757622Ab3FCT3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 15:29:54 -0400
Message-ID: <51ACEE88.6080200@hds.com>
Date: Mon, 03 Jun 2013 15:29:12 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, x86@kernel.org, rostedt@goodmis.org,
        hpa@zytor.com
CC: tglx@linutronix.de, mingo@elte.hu, bp@alien8.de,
        linux-edac@vger.kernel.org, tony.luck@intel.com,
        dle-develop@lists.sourceforge.net, tomoki.sekiyama@hds.com
Subject: [PATCH v13 2/3] trace,x86: Introduce entering/exiting_irq()
References: <51ACEDBB.6040706@hds.com>
In-Reply-To: <51ACEDBB.6040706@hds.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8626,1.0.431,0.0.0000
 definitions=2013-06-03_05:2013-06-03,2013-06-03,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 ipscore=0
 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1306030167
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When implementing tracepoints in interrupt handers, if the tracepoints are
simply added in the performance sensitive path of interrupt handers,
it may cause potential performance problem due to the time penalty.

To solve the problem, an idea is to prepare non-trace/trace irq handers and 
switch their IDTs at the enabling/disabling time.

To do this, this patch introduces entering_irq()/exiting_irq() for pre/post-
processing of each irq handler.

A way to use them is as follows.

Non-trace irq handler:
smp_irq_handler()
{
	entering_irq(); /* pre-processing of this handler */
	__smp_irq_handler(); /*
                          * common logic between non-trace and trace handlers
                          * in a vector.
                          */
	exiting_irq(); /* post-processing of this handler */

}

Trace irq_handler:
smp_trace_irq_handler()
{
	entering_irq(); /* pre-processing of this handler */
	trace_irq_entry(); /* tracepoint for irq entry */
	__smp_irq_handler(); /*
                          * common logic between non-trace and trace handlers
                          * in a vector.
                          */
	trace_irq_exit(); /* tracepoint for irq exit */
	exiting_irq(); /* post-processing of this handler */

}

If tracepoints can place outside entering_irq()/exiting_irq() as follows, 
it looks cleaner.

smp_trace_irq_handler()
{
	trace_irq_entry();
	smp_irq_handler();
	trace_irq_exit();
}

But it doesn't work.
The problem is with irq_enter/exit() being called. They must be called before
trace_irq_enter/exit(),  because of the rcu_irq_enter() must be called before 
any tracepoints are used, as tracepoints use  rcu to synchronize.

As a possible alternative, we may be able to call irq_enter() first as follows
if irq_enter() can nest.

smp_trace_irq_hander()
{
	irq_entry();
	trace_irq_entry();
	smp_irq_handler();
	trace_irq_exit();
	irq_exit();
}

But it doesn't work, either.
If irq_enter() is nested, it may have a time penalty because it has to check if it
was already called or not. The time penalty is not desired in performance sensitive
paths even if it is tiny.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
---
 arch/x86/include/asm/apic.h |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 3388034..f8119b5 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -12,6 +12,7 @@
 #include <asm/fixmap.h>
 #include <asm/mpspec.h>
 #include <asm/msr.h>
+#include <asm/idle.h>
 
 #define ARCH_APICTIMER_STOPS_ON_C3	1
 
@@ -687,5 +688,31 @@ extern int default_check_phys_apicid_present(int phys_apicid);
 #endif
 
 #endif /* CONFIG_X86_LOCAL_APIC */
+extern void irq_enter(void);
+extern void irq_exit(void);
+
+static inline void entering_irq(void)
+{
+	irq_enter();
+	exit_idle();
+}
+
+static inline void entering_ack_irq(void)
+{
+	ack_APIC_irq();
+	entering_irq();
+}
+
+static inline void exiting_irq(void)
+{
+	irq_exit();
+}
+
+static inline void exiting_ack_irq(void)
+{
+	irq_exit();
+	/* Ack only at the end to avoid potential reentry */
+	ack_APIC_irq();
+}
 
 #endif /* _ASM_X86_APIC_H */
-- 1.7.1

