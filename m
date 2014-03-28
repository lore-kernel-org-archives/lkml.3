Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbaC1Hln (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 03:41:43 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:41000
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751061AbaC1Hll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 03:41:41 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz8275ch1de098h8275bh8275dh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh1155h)
From: Dongsheng Wang <dongsheng.wang@freescale.com>
To: <fweisbec@gmail.com>
CC: <scottwood@freescale.com>, <leoli@freescale.com>,
        <jason.jin@freescale.com>, <tie-fei.zang@freescale.com>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        Wang Dongsheng <dongsheng.wang@freescale.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Paul Mackerras <paulus@au1.ibm.com>,
        James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] powerpc/irq: Remove HAVE_IRQ_EXIT_ON_IRQ_STACK feature at powerpc platform
Date: Fri, 28 Mar 2014 15:38:32 +0800
Message-ID: <1395992312-23035-1-git-send-email-dongsheng.wang@freescale.com>
X-Mailer: git-send-email 1.8.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang Dongsheng <dongsheng.wang@freescale.com>

If softirq use hardirq stack, we will get kernel painc when a hard irq coming again
during __do_softirq enable local irq to deal with softirq action. So we need to switch
satck into softirq stack when invoke soft irq.

 Task--->
	| Task stack
	|
	Interrput->EXCEPTION->do_IRQ->
	^			     | Hard irq stack
	|			     |
	|			     irq_exit->__do_softirq->local_irq_enable--   -->local_irq_disable
	|									| Hard irq stack
	|									|
	|									Interrupt coming again
	|		There will get a Interrupt nesting			|
	------------------------------------------------------------------------

Trace 1: Trap 900

Kernel stack overflow in process e8152f40, r1=e8e05ec0
CPU: 0 PID: 2399 Comm: image_compress/ Not tainted 3.13.0-rc3-03475-g2e3f85b #432
task: e8152f40 ti: c080a000 task.ti: ef176000
NIP: c05bec04 LR: c0305590 CTR: 00000010
REGS: e8e05e10 TRAP: 0901   Not tainted  (3.13.0-rc3-03475-g2e3f85b)
MSR: 00029000 <CE,EE,ME>  CR: 22f22722  XER: 20000000

GPR00: c0305590 e8e05ec0 e8152f40 c07e1e2c 00029000 000000ec fffffffc 00000010
GPR08: 0000007f 00000000 00000000 b02539f3 a00ae278
NIP [c05bec04] _raw_spin_unlock_irqrestore+0x10/0x14
LR [c0305590] add_timer_randomness+0x60/0xfc
Call Trace:
[e8e05ec0] [c0305590] add_timer_randomness+0x60/0xfc (unreliable)
[e8e05ee0] [c026c9a8] blk_update_bidi_request+0x64/0x94
[e8e05f00] [c026cd00] blk_end_bidi_request+0x20/0x7c
[e8e05f20] [c032f21c] scsi_io_completion+0xe0/0x5e8
[e8e05f70] [c0272b84] blk_done_softirq+0x98/0xb8
[e8e05f90] [c004893c] __do_softirq+0xf8/0x1f8
[e8e05fe0] [c0048dbc] irq_exit+0xa4/0xc8
[e8e05ff0] [c000d5f4] call_do_irq+0x24/0x3c
[ef177d50] [c00046ec] do_IRQ+0x8c/0xf8
[ef177d70] [c000f6dc] ret_from_except+0x0/0x18
--- Exception: 501 at lzo1x_1_do_compress+0x248/0x40c
    LR = lzo1x_1_compress+0x98/0x268
[ef177e30] [c07c7440] runqueues+0x0/0x540 (unreliable)
[ef177e60] [00000000]   (null)
[ef177ea0] [c0085a9c] lzo_compress_threadfn+0x6c/0x138
[ef177ef0] [c0062a00] kthread+0xc4/0xd8
[ef177f40] [c000f158] ret_from_kernel_thread+0x5c/0x64
Instruction dump:
40a2fff0 4c00012c 2f890000 419e000c 38600000 4e800020 38600001 4e800020
7c0004ac 39200000 91230000 7c800106 <4e800020> 7d201828 35290001 40810010
Kernel panic - not syncing: kernel stack overflow
CPU: 0 PID: 2399 Comm: image_compress/ Not tainted 3.13.0-rc3-03475-g2e3f85b #432
Call Trace:
Rebooting in 180 seconds..

Trace 2: Trap 500

VFS: Mounted root (ext2 filesystem) on device 1:0.
devtmpfs: mounted
Freeing unused kernel memory: 268K (c079a000 - c07dd000)
INIT: version 2.88 booting
Starting udev
udevd[1423]: starting version 182
random: nonblocking pool is initialized
Kernel stack overflow in process e829ca80, r1=e8badf90
CPU: 0 PID: 1553 Comm: mount.sh Not tainted 3.13.0-rc1-148228-gea7ca7c #21
task: e829ca80 ti: c081c000 task.ti: e9d28000
NIP: c00434bc LR: c0043444 CTR: c0018cec
REGS: e8badee0 TRAP: 0501   Not tainted  (3.13.0-rc1-148228-gea7ca7c)
MSR: 00029000 <CE,EE,ME>  CR: 48222422  XER: 20000000

GPR00: c00439a0 e8badf90 e829ca80 00000001 e80cc780 00000001 b92f44af 00000000
GPR08: 00000001 010ba000 010ba000 ddd3e6d1 48222422
NIP [c00434bc] __do_softirq+0x94/0x1f8
LR [c0043444] __do_softirq+0x1c/0x1f8
Call Trace:
[e8badf90] [100f0000] 0x100f0000 (unreliable)
[e8badfe0] [c00439a0] irq_exit+0xa4/0xc8
[e8badff0] [c000ccd8] call_do_irq+0x24/0x3c
[e9d29f20] [c000479c] do_IRQ+0x8c/0xf8
[e9d29f40] [c000eb54] ret_from_except+0x0/0x18
--- Exception: 501 at 0x1003d540
    LR = 0x10041974
Instruction dump:
3e80c082 3f40c07e 3b60000a 3a941040 3aa00000 3b5a9388 7f16c378 812f0008
5529103a 7d3c482e 7eb8492e 7c008146 <3ba00000> 7e9ea378 48000014 57fff87f
Kernel panic - not syncing: kernel stack overflow
CPU: 0 PID: 1553 Comm: mount.sh Not tainted 3.13.0-rc1-148228-gea7ca7c #21
Call Trace:
Rebooting in 180 seconds..

Signed-off-by: Wang Dongsheng <dongsheng.wang@freescale.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Paul Mackerras <paulus@au1.ibm.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: James E.J. Bottomley <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 957bf34..ffde3fb 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -139,7 +139,6 @@ config PPC
 	select OLD_SIGSUSPEND
 	select OLD_SIGACTION if PPC32
 	select HAVE_DEBUG_STACKOVERFLOW
-	select HAVE_IRQ_EXIT_ON_IRQ_STACK
 	select ARCH_USE_CMPXCHG_LOCKREF if PPC64
 
 config GENERIC_CSUM
-- 
1.8.5


