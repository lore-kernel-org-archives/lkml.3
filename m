Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab3F1OCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 10:02:23 -0400
Received: from usindpps05.hds.com ([207.126.252.18]:50010 "EHLO
	usindpps05.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987Ab3F1OCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 10:02:21 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "hpa@zytor.com" <hpa@zytor.com>
CC: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: RE: [PATCH -tip] x86,trace: Add rcu_irq_enter/exit() in
 smp_trace_reschedule_interrupt()
Thread-Topic: [PATCH -tip] x86,trace: Add rcu_irq_enter/exit() in
 smp_trace_reschedule_interrupt()
Thread-Index: AQHOcRh6tLsjeasi80i72tgopT7X3plLLckg
Date: Fri, 28 Jun 2013 14:01:46 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D443E0FBE2@USINDEM103.corp.hds.com>
References: <51C8AA31.3070208@hds.com>
In-Reply-To: <51C8AA31.3070208@hds.com>
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
 definitions=2013-06-28_06:2013-06-28,2013-06-28,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1306280082
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5SE2U33021321

Any comments?

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Seiji Aguchi
> Sent: Monday, June 24, 2013 4:21 PM
> To: linux-kernel@vger.kernel.org; x86@kernel.org; rostedt@goodmis.org; hpa@zytor.com
> Cc: mingo@elte.hu; tglx@linutronix.de
> Subject: [PATCH -tip] x86,trace: Add rcu_irq_enter/exit() in smp_trace_reschedule_interrupt()
> 
> Reschedule vector tracepoints may be called in cpu idle state.
> This causes lockdep check warning below.
> So, add rcu_irq_enter/exit() to smp_trace_reschedule_interrupt().
> 
> [   50.720557] Testing event reschedule_exit:
> [   50.721349]
> [   50.721502] ===============================
> [   50.721835] [ INFO: suspicious RCU usage. ]
> [   50.722169] 3.10.0-rc6-00004-gcf910e8 #190 Not tainted
> [   50.722582] -------------------------------
> [   50.722915] /c/kernel-tests/src/linux/arch/x86/include/asm/trace/irq_vectors.h:50 suspicious rcu_dereference_check() usage!
> [   50.723770]
> [   50.723770] other info that might help us debug this:
> [   50.723770]
> [   50.724385]
> [   50.724385] RCU used illegally from idle CPU!
> [   50.724385] rcu_scheduler_active = 1, debug_locks = 0
> [   50.725232] RCU used illegally from extended quiescent state!
> [   50.725690] no locks held by swapper/0/0.
> [   50.726010]
> [   50.726010] stack backtrace:
> [   50.726359] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.10.0-rc6-00004-gcf910e8 #190
> [   50.726965] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> 
> [   50.727417]  00000001 00000001 79c53f04 798bd9f9 79c53f2c 79077a70 79b412c6 79b41fd1
> [   50.728159]  00000001 00000000 79c5ef8c 87147c58 00000000 79c55800 79c53f38 79010b65
> [   50.728849]  79c52000 79c53f7c 798c720e 79c52000 79c5ef8c 00000004 00000000 79c55800
> [   50.729532] Call Trace:
> [   50.729730]  [<798bd9f9>] dump_stack+0x16/0x18
> [   50.730072]  [<79077a70>] lockdep_rcu_suspicious+0xf2/0xfa
> [   50.730498]  [<79010b65>] smp_trace_reschedule_interrupt+0x1c8/0x1d0
> [   50.730979]  [<798c720e>] trace_reschedule_interrupt+0x36/0x3c
> [   50.731214]  [<7901875f>] ? native_safe_halt+0x5/0x7
> [   50.731214]  [<790085cc>] default_idle+0xb1/0x1e2
> [   50.731214]  [<79008d05>] arch_cpu_idle+0xe/0x10
> [   50.731214]  [<79069ddf>] cpu_startup_entry+0x1e4/0x2c3
> [   50.731214]  [<798adb34>] rest_init+0x12c/0x132
> [   50.731214]  [<798ada08>] ? __read_lock_failed+0x14/0x14
> [   50.731214]  [<79d309e4>] start_kernel+0x38d/0x393
> [   50.731214]  [<79d30489>] ? repair_env_string+0x51/0x51
> [   50.731214]  [<79d302c3>] i386_start_kernel+0x79/0x7d
> [   50.771947] OK
> [   50.772099] Testing event reschedule_entry: OK
> 
> Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
> ---
>  arch/x86/kernel/smp.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
> index f4fe0b8..b959056 100644
> --- a/arch/x86/kernel/smp.c
> +++ b/arch/x86/kernel/smp.c
> @@ -268,9 +268,11 @@ void smp_reschedule_interrupt(struct pt_regs *regs)
>  void smp_trace_reschedule_interrupt(struct pt_regs *regs)
>  {
>  	ack_APIC_irq();
> +	rcu_irq_enter();
>  	trace_reschedule_entry(RESCHEDULE_VECTOR);
>  	__smp_reschedule_interrupt();
>  	trace_reschedule_exit(RESCHEDULE_VECTOR);
> +	rcu_irq_exit();
>  	/*
>  	 * KVM uses this interrupt to force a cpu out of guest mode
>  	 */
> --
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
