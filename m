Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab3GALl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 07:41:26 -0400
Received: from usindpps05.hds.com ([207.126.252.18]:42088 "EHLO
	usindpps05.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602Ab3GALlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 07:41:24 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: RE: [PATCH -tip] x86,trace: Add irq_enter/exit() in
 smp_trace_reschedule_interrupt()
Thread-Topic: [PATCH -tip] x86,trace: Add irq_enter/exit() in
 smp_trace_reschedule_interrupt()
Thread-Index: AQHOdCm79DFuVj80FUO+kjU7fkcBDplLsdOAgAQFKMA=
Date: Mon, 1 Jul 2013 11:40:54 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D443E12CE6@USINDEM103.corp.hds.com>
References: <51CDCFA3.9080101@hds.com>
 <1372443363.18733.340.camel@gandalf.local.home>
In-Reply-To: <1372443363.18733.340.camel@gandalf.local.home>
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
 definitions=2013-07-01_02:2013-06-28,2013-07-01,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0
 kscore.is_bulkscore=1.66533453693773e-16 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.997215366458519
 urlsuspect_oldscore=0.997215366458519 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=0 rbsscore=0.997215366458519
 spamscore=0 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1305240000 definitions=main-1307010068
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r61BfVqa032297

Ingo,

Please merge this patch to your tree.
It is a bug fix of irq_vector tracepoints patch.

Seiji

> -----Original Message-----
> From: Steven Rostedt [mailto:rostedt@goodmis.org]
> Sent: Friday, June 28, 2013 2:16 PM
> To: Seiji Aguchi
> Cc: linux-kernel@vger.kernel.org; x86@kernel.org; hpa@zytor.com; mingo@elte.hu; tglx@linutronix.de
> Subject: Re: [PATCH -tip] x86,trace: Add irq_enter/exit() in smp_trace_reschedule_interrupt()
> 
> On Fri, 2013-06-28 at 14:02 -0400, Seiji Aguchi wrote:
> > Reschedule vector tracepoints may be called in cpu idle state.
> > This causes lockdep check warning below.
> >
> > The tracepoint requires rcu but for accuracy it also
> > requires irq_enter() (tracepoints record the irq context), thus, the
> > tracepoint interrupt handler should be calling irq_enter() and not
> > rcu_irq_enter() (irq_enter() calls rcu_irq_enter()).
> >
> > So, add irq_enter/exit() to smp_trace_reschedule_interrupt()
> > with common pre/post processing functions, smp_entering_irq()
> > and exiting_irq() (exiting_irq() calls just irq_exit()
> >  in arch/x86/include/asm/apic.h),
> > because these can be shared among reschedule, call_function,
> > and call_function_single vectors.
> >
> > [   50.720557] Testing event reschedule_exit:
> > [   50.721349]
> > [   50.721502] ===============================
> > [   50.721835] [ INFO: suspicious RCU usage. ]
> > [   50.722169] 3.10.0-rc6-00004-gcf910e8 #190 Not tainted
> > [   50.722582] -------------------------------
> > [   50.722915] /c/kernel-tests/src/linux/arch/x86/include/asm/trace/irq_vectors.h:50 suspicious rcu_dereference_check() usage!
> > [   50.723770]
> > [   50.723770] other info that might help us debug this:
> > [   50.723770]
> > [   50.724385]
> > [   50.724385] RCU used illegally from idle CPU!
> > [   50.724385] rcu_scheduler_active = 1, debug_locks = 0
> > [   50.725232] RCU used illegally from extended quiescent state!
> > [   50.725690] no locks held by swapper/0/0.
> > [   50.726010]
> > [   50.726010] stack backtrace:
> > [   50.726359] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.10.0-rc6-00004-gcf910e8 #190
> > [   50.726965] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> >
> > [   50.727417]  00000001 00000001 79c53f04 798bd9f9 79c53f2c 79077a70 79b412c6 79b41fd1
> > [   50.728159]  00000001 00000000 79c5ef8c 87147c58 00000000 79c55800 79c53f38 79010b65
> > [   50.728849]  79c52000 79c53f7c 798c720e 79c52000 79c5ef8c 00000004 00000000 79c55800
> > [   50.729532] Call Trace:
> > [   50.729730]  [<798bd9f9>] dump_stack+0x16/0x18
> > [   50.730072]  [<79077a70>] lockdep_rcu_suspicious+0xf2/0xfa
> > [   50.730498]  [<79010b65>] smp_trace_reschedule_interrupt+0x1c8/0x1d0
> > [   50.730979]  [<798c720e>] trace_reschedule_interrupt+0x36/0x3c
> > [   50.731214]  [<7901875f>] ? native_safe_halt+0x5/0x7
> > [   50.731214]  [<790085cc>] default_idle+0xb1/0x1e2
> > [   50.731214]  [<79008d05>] arch_cpu_idle+0xe/0x10
> > [   50.731214]  [<79069ddf>] cpu_startup_entry+0x1e4/0x2c3
> > [   50.731214]  [<798adb34>] rest_init+0x12c/0x132
> > [   50.731214]  [<798ada08>] ? __read_lock_failed+0x14/0x14
> > [   50.731214]  [<79d309e4>] start_kernel+0x38d/0x393
> > [   50.731214]  [<79d30489>] ? repair_env_string+0x51/0x51
> > [   50.731214]  [<79d302c3>] i386_start_kernel+0x79/0x7d
> > [   50.771947] OK
> > [   50.772099] Testing event reschedule_entry: OK
> >
> > Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
> 
> Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
> 
> -- Steve
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
