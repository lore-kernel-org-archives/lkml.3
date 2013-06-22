Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab3FVRnJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 13:43:09 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:34823 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab3FVRnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 13:43:07 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: RE: [PATCH][GIT PULL] trace,x86: Move creation of irq tracepoints
 from apic.c to irq.c
Thread-Topic: [PATCH][GIT PULL] trace,x86: Move creation of irq tracepoints
 from apic.c to irq.c
Thread-Index: AQHObqUzA/RFHOSk7kKPCkjH3eaeTplA7QgAgAAEnYCAARpyAP//8/Ew
Date: Sat, 22 Jun 2013 17:42:43 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D443E06842@USINDEM103.corp.hds.com>
References: <1371835898.18733.122.camel@gandalf.local.home>
	 <1371848976.18733.130.camel@gandalf.local.home>
	 <1371849967.18733.134.camel@gandalf.local.home>
 <1371910622.18733.154.camel@gandalf.local.home>
In-Reply-To: <1371910622.18733.154.camel@gandalf.local.home>
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
 definitions=2013-06-22_06:2013-06-21,2013-06-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0
 kscore.is_bulkscore=1.47996059851607e-11 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.997215366458519
 urlsuspect_oldscore=0.997215366458519 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=0 rbsscore=0.997215366458519
 spamscore=0 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1305240000 definitions=main-1306220188
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5MHhKeS013710

> +static inline void load_current_idt(void)
> +{
> +       unsigned long flags;
> +
> +       local_irq_save(flags);
> +       if (is_debug_idt_enabled())
> +               load_debug_idt();
> +       else
> +               load_idt((const struct desc_ptr *)&idt_descr);
> +       local_irq_restore(flags);
> +}
> 
> It's not safe to call local_irq_save() here. From entry_64.S:
> 
> .macro TRACE_IRQS_OFF_DEBUG
> 	call debug_stack_set_zero
> 	TRACE_IRQS_OFF
> 	call debug_stack_reset
> .endm
> 
> We must change the idt before we can trace irqs being disabled. The
> local_irq_save() here is going to be traced by lockdep. Why do we need
> to disable interrupts? It's pretty pointless since this same code can be
> called by NMIs.

OK, I agree to remove the local_irq_save().

I thought it is safe to disable interrupt to avoid potential races, 
because the load_current_id() is a common function and someone else may use it near future.

Per Intel's Software Developer's manual, there is a case which we should disable interrupts
to switch IDT in IA-32e Mode.
But I think it is corner case.

<snip>
9.8.5.2 IA-32e Mode Interrupts and Exceptions
Software must not allow exceptions or interrupts to occur between the time IA-32e mode is activated and the
update of the interrupt-descriptor-table register (IDTR) that establishes references to a 64-bit interrupt-descriptor
table (IDT). This is because the IDT remains in legacy form immediately after IA-32e mode is activated.
If an interrupt or exception occurs prior to updating the IDTR, a legacy 32-bit interrupt gate will be referenced and
interpreted as a 64-bit interrupt gate with unpredictable results. External interrupts can be disabled by using the
CLI instruction.
Non-maskable interrupts (NMI) must be disabled using external hardware.
<snip>

Seiji



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
