Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab3EGRHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 13:07:33 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:40329
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750747Ab3EGRHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 13:07:31 -0400
X-Forefront-Antispam-Report: CIP:132.245.1.197;KIP:(null);UIP:(null);IPV:NLI;H:BLUPRD0712HT002.namprd07.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: PS-4(zzbb2dI98dI9371I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzzz2dh2a8h668h839h942hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h19ceh1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
Message-ID: <518934CC.8050600@caviumnetworks.com>
Date: Tue, 7 May 2013 10:07:24 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: <eunb.song@samsung.com>
CC: "david.daney@cavium.com" <david.daney@cavium.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "jogo@openwrt.org" <jogo@openwrt.org>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>, <manuel.lauss@gmail.com>
Subject: Re: MIPS: Test reault for  enable interrupts before WAIT instruction
 patch
References: <15709790.301941367908253064.JavaMail.weblogic@epml12>
In-Reply-To: <15709790.301941367908253064.JavaMail.weblogic@epml12>
Content-Type: text/plain; charset="EUC-KR"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 11:30 PM, EUNBONG SONG wrote:
> 
> Hello. I  tested with two patches.
> The first one is thomas gleixner's patch. The patch is as follow.
> This patch works well without any problem.

You don't need them both.  When we fix it, it will be one or the other,
not both.


> 
> Index: linux-2.6/arch/mips/kernel/process.c
> ===================================================================
> --- linux-2.6.orig/arch/mips/kernel/process.c
> +++ linux-2.6/arch/mips/kernel/process.c
> @@ -50,13 +50,18 @@ void arch_cpu_idle_dead(void)
>   }
>   #endif
> 
> -void arch_cpu_idle(void)
> +static void smtc_idle_hook(void)
>   {
>   #ifdef CONFIG_MIPS_MT_SMTC
>          extern void smtc_idle_loop_hook(void);
> -
>          smtc_idle_loop_hook();
>   #endif
> +}
> +
> +void arch_cpu_idle(void)
> +{
> +       local_irq_enable();
> +       smtc_idle_hook();
>          if (cpu_wait)
>                  (*cpu_wait)();
>          else

Although I wrote the other patch, I now think that Thomas Gleixner's
patch (above), is the best option.

There are many cpu_wait() implementations.  Fixing a bunch of different
assembly implementations, most of which I cannot test, is a recipe for
disaster.


> --
> 
> The second one is david daney's patch.  The patch is as follow.
> arch/mips/kernel/genex.S | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/mips/kernel/genex.S b/arch/mips/kernel/genex.S
> index ecb347c..57cda9a 100644
> --- a/arch/mips/kernel/genex.S
> +++ b/arch/mips/kernel/genex.S
> @@ -132,12 +132,13 @@ LEAF(r4k_wait)
>          .set    noreorder
>          /* start of rollback region */
>          LONG_L  t0, TI_FLAGS($28)
> -       nop
>          andi    t0, _TIF_NEED_RESCHED
>          bnez    t0, 1f
>           nop
> -       nop
> -       nop
> +       /* Enable interrupts so WAIT will complete */
> +       mfc0    t0, CP0_STATUS
> +       ori     t0, ST0_IE
> +       mtc0    t0, CP0_STATUS
>          .set    mips3
>          wait
>          /* end of rollback region (the region size must be power of two) */
> 
> After apply this patch. I got two error message.
> The first one is as follow
> [  124.661211] Checking for the daddi bug... no.
> [  124.665737] ------------[ cut here ]------------
> [  124.670187] WARNING: at kernel/cpu/idle.c:96 cpu_startup_entry+0x150/0x178()
> [  124.677209] Modules linked in:
> [  124.680251] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.9.0+ #40
> [  124.686237] Stack : 0000000000000004 0000000000000034 ffffffff80fa0000 ffffffff80292558
>            0000000000000000 ffffffff80fa0000 0000000000000001 ffffffff80293810
>            0000000000000000 0000000000000000 ffffffff81080000 ffffffff81080000
>            ffffffff80e2acf0 ffffffff80f8f977 ffffffff80f8fa80 ffffffff80e31730
>            0000000000000001 0000000000000004 ffffffff00000000 0000000000000004
>            ffffffffc05633f0 ffffffff806ef728 ffffffff80f57d08 ffffffff80290a74
>            ffffffffc05633f0 ffffffff80293c40 000000000000003e ffffffff80e2acf0
>            0000000000000000 ffffffff80f57c30 00ffffff80f8fdc0 ffffffff802908c0
>            0000000000000000 0000000000000000 0000000000000000 0000000000000000
>            0000000000000000 ffffffff80272498 0000000000000000 0000000000000000
>            ...
> [  124.751163] Call Trace:
> [  124.753599] [<ffffffff80272498>] show_stack+0x68/0x80
> [  124.758634] [<ffffffff802908c0>] warn_slowpath_common+0x78/0xa8
> [  124.764533] [<ffffffff802d4448>] cpu_startup_entry+0x150/0x178
> [  124.770351] [<ffffffff80fd6b04>] start_kernel+0x440/0x45c
> [  124.775728]
> [  124.777219] ---[ end trace 9179e654e5693e72 ]---
> 
> After boot process is done the follow error message is printed periodically.
> 
> [  284.751007] INFO: rcu_preempt detected stalls on CPUs/tasks: { 6} (detected by 1, t=14712 jiffies, g=18446744073709551344, c=18446744073709551343, q=2437)
> [  284.764878] Task dump for CPU 6:
> [  284.768105] swapper/6       R  running task        0     0      1 0x00100000
> [  284.775174] Stack : 0000005311112000 ffffffff80f60000 ffffffff80f60000 a800000001d2d950
>            0000000000000018 ffffffff81080000 ffffffff81080000 0000000000000000
>            ffffffff81010000 ffffffff8030893c 4256e5715da6083d 800000040f800000
>            0000000000000018 ffffffff81080000 ffffffff81080000 ffffffff80264f3c
>            ffffffff80e31730 0000000000000000 ffffffff80e31730 ffffffff80f90000
>            ffffffff80fd0000 ffffffff8026c760 0000000000000000 0000000010008ce1
>            0000000000100000 a8000000414e4010 ffffffff80f8bb18 0000000000000000
>            0000005311112000 0000000000000001 0000000000000001 0000000000000000
>            ffffffff80f8bc58 a800000001d32c60 a8000000414e7fe0 0000000000008c00
>            a80000003f7d8000 0000000000000000 ffffffff80fd0000 ffffffff80e31730
>            ...
> [  284.840704] Call Trace:
> [  284.843153] [<ffffffff806f1a48>] __schedule+0x3b0/0x938
> [  284.848377]
> 
> 
> Thanks
> 


