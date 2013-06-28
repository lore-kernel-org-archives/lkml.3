Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab3F1POM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 11:14:12 -0400
Received: from usindpps04.hds.com ([207.126.252.17]:57640 "EHLO
	usindpps04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab3F1POK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 11:14:10 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: RE: [PATCH -tip] x86,trace: Add rcu_irq_enter/exit() in
 smp_trace_reschedule_interrupt()
Thread-Topic: [PATCH -tip] x86,trace: Add rcu_irq_enter/exit() in
 smp_trace_reschedule_interrupt()
Thread-Index: AQHOcRh6tLsjeasi80i72tgopT7X3plLdn2A///IhNA=
Date: Fri, 28 Jun 2013 15:13:14 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D443E0FE25@USINDEM103.corp.hds.com>
References: <51C8AA31.3070208@hds.com>
 <1372429303.18733.325.camel@gandalf.local.home>
In-Reply-To: <1372429303.18733.325.camel@gandalf.local.home>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-06-28_07:2013-06-28,2013-06-28,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1306280099
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5SFELev021667

> > diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
> > index f4fe0b8..b959056 100644
> > --- a/arch/x86/kernel/smp.c
> > +++ b/arch/x86/kernel/smp.c
> > @@ -268,9 +268,11 @@ void smp_reschedule_interrupt(struct pt_regs *regs)
> >  void smp_trace_reschedule_interrupt(struct pt_regs *regs)
> >  {
> >  	ack_APIC_irq();
> > +	rcu_irq_enter();
> >  	trace_reschedule_entry(RESCHEDULE_VECTOR);
> >  	__smp_reschedule_interrupt();
> >  	trace_reschedule_exit(RESCHEDULE_VECTOR);
> > +	rcu_irq_exit();
> 
> The question is, should we add normal irq_enter/exit here? As that
> should be OK to nest. There's a comment in scheduler_ipi():

> Either way, the tracepoint requires rcu but for accuracy it also
> requires irq_enter() (tracepoints record the irq context), thus, the
> tracepoint interrupt handler should be calling irq_enter() and not
> rcu_irq_enter() (irq_enter() calls rcu_irq_enter())

OK.
So,  ack_APIC_irq() and irq_enter() are needed.
It can be shared with smp_call_function() and smp_call_function_single() like this.
I will update the patch.

arch/x86/kernel/smp.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index f4fe0b8..732b618 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -265,23 +265,24 @@ void smp_reschedule_interrupt(struct pt_regs *regs)
 	 */
 }
 
-void smp_trace_reschedule_interrupt(struct pt_regs *regs)
+static inline void smp_entering_irq(void)
 {
 	ack_APIC_irq();
+	irq_enter();
+}
+
+void smp_trace_reschedule_interrupt(struct pt_regs *regs)
+{
+	smp_entering_irq();
 	trace_reschedule_entry(RESCHEDULE_VECTOR);
 	__smp_reschedule_interrupt();
 	trace_reschedule_exit(RESCHEDULE_VECTOR);
+	exiting_irq();
 	/*
 	 * KVM uses this interrupt to force a cpu out of guest mode
 	 */
 }
 
-static inline void call_function_entering_irq(void)
-{
-	ack_APIC_irq();
-	irq_enter();
-}
-
 static inline void __smp_call_function_interrupt(void)
 {
 	generic_smp_call_function_interrupt();
@@ -290,14 +291,14 @@ static inline void __smp_call_function_interrupt(void)
 
 void smp_call_function_interrupt(struct pt_regs *regs)
 {
-	call_function_entering_irq();
+	smp_entering_irq();
 	__smp_call_function_interrupt();
 	exiting_irq();
 }
 
 void smp_trace_call_function_interrupt(struct pt_regs *regs)
 {
-	call_function_entering_irq();
+	smp_entering_irq();
 	trace_call_function_entry(CALL_FUNCTION_VECTOR);
 	__smp_call_function_interrupt();
 	trace_call_function_exit(CALL_FUNCTION_VECTOR);
@@ -312,14 +313,14 @@ static inline void __smp_call_function_single_interrupt(void)
 
 void smp_call_function_single_interrupt(struct pt_regs *regs)
 {
-	call_function_entering_irq();
+	smp_entering_irq();
 	__smp_call_function_single_interrupt();
 	exiting_irq();
 }
 
 void smp_trace_call_function_single_interrupt(struct pt_regs *regs)
 {
-	call_function_entering_irq();
+	smp_entering_irq();
 	trace_call_function_single_entry(CALL_FUNCTION_SINGLE_VECTOR);
 	__smp_call_function_single_interrupt();
 	trace_call_function_single_exit(CALL_FUNCTION_SINGLE_VECTOR);
-- 
1.7.1






ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
