Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbaHLPMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 11:12:49 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:21125 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbaHLPMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 11:12:46 -0400
X-AuditID: cbfee61a-f79e46d00000134f-b9-53ea2eec98c4
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sachin Kamat <sachin.kamat@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Olof Johansson <olof@lixom.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        b.zolnierkie@samsung.com
Subject: [PATCH v2 2/3] ARM: mm: Fix ifdef around cpu_*_do_[suspend,resume] ops
Date: Tue, 12 Aug 2014 17:11:56 +0200
Message-id: <1407856317-2457-3-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1407856317-2457-1-git-send-email-b.zolnierkie@samsung.com>
References: <1407856317-2457-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jAd03eq+CDVasMLfYOGM9q8W8z7IW
	r18YWvQuuMpmcbbpDbvFpsfXWC0u75rDZjHj/D4mi7VH7rJbnLr+mc1i84eXbBZXLp1is1g/
	4zWLA69HS3MPm8eda3vYPDYvqfe4cqKJ1aNvyypGj8+b5ALYorhsUlJzMstSi/TtErgyZp/o
	Yi/olK2Yta2buYHxtngXIyeHhICJxNqzh5ghbDGJC/fWs3UxcnEICSxilHja8I4Zwulikvg0
	q5EFpIpNwEpiYvsqRhBbREBNomfxVkaQImaBO8wSr/buBSsSFvCXWDnrGpjNIqAqce7jXdYu
	Rg4OXgF3idNPnSC2KUp0P5vABmJzCnhIvJ/8DuwKIaCSrn1HmScw8i5gZFjFKJpakFxQnJSe
	a6hXnJhbXJqXrpecn7uJERyWz6R2MK5ssDjEKMDBqMTDW8H7KliINbGsuDL3EKMEB7OSCK/g
	7ZfBQrwpiZVVqUX58UWlOanFhxilOViUxHkPtFoHCgmkJ5akZqemFqQWwWSZODilGhjbbn43
	n58hEXN5x301qTrbW2055SoTappfL1x9pvDJ+9lm0gcX6x7pr2WPzw3Zedcs7EYqX/CUL++u
	zmZjvWwk2MAp4bP5Tvv13AtdTdNZ9+TPnSuR9OV69fLzir4MDQkli838TnYUejYrzuK+6bPT
	TvHCVqXXahcNky7tPhN9Qy7uVN9RlplKLMUZiYZazEXFiQBfllCfRwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ifdef around cpu_\name\()_do_suspend and cpu_\name\()_do_resume
ops in proc-macros.S should check for CONFIG_ARM_CPU_SUSPEND and
not CONFIG_PM_SLEEP.  Fix it.

[ Please note that cpu_v7_do_[suspend,resume] code in proc-v7.S
  already correctly checks for CONFIG_ARM_CPU_SUSPEND, same is
  true for functions for other architectures. ]

This fix is needed for decoupling suspend/resume and advanced
cpuidle support on Exynos platform (next patch fixes build for
config with CONFIG_PM_SLEEP=n and CONFIG_ARM_EXYNOS_CPUIDLE=y).

If this fix is not present then the following OOPS happens on
the first attempt to go into advanced cpuidle mode (AFTR):

[   22.244143] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[   22.250759] pgd = c0004000
[   22.253445] [00000000] *pgd=00000000
[   22.257012] Internal error: Oops: 80000007 [#1] PREEMPT SMP ARM
[   22.262906] Modules linked in:
[   22.265949] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.16.0-next-20140811-dirty #730
[   22.273757] task: c05dce68 ti: c05d2000 task.ti: c05d2000
[   22.279139] PC is at 0x0
[   22.281661] LR is at __cpu_suspend_save+0x4c/0xa8
[   22.286344] pc : [<00000000>]    lr : [<c00125e0>]    psr: a0000093
[   22.286344] sp : c05d3ef4  ip : c05da414  fp : 00000001
[   22.297799] r10: c05da414  r9 : c0609cb0  r8 : 0000000f
[   22.303008] r7 : c05da444  r6 : 00000038  r5 : ea802c00  r4 : c05d3f14
[   22.309517] r3 : 00000000  r2 : c05d3f4c  r1 : 00000038  r0 : c05d3f20
[   22.316029] Flags: NzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[   22.323406] Control: 10c5387d  Table: 69d5404a  DAC: 00000015
[   22.329135] Process swapper/0 (pid: 0, stack limit = 0xc05d2240)
[   22.335124] Stack: (0xc05d3ef4 to 0xc05d4000)
[   22.339466] 3ee0:                                              ea802c00 00000038 c05d3f4c
[   22.347626] 3f00: 00000000 00000007 c00123bc 00000000 c001d468 6a888000 c05d3f4c 80000000
[   22.355785] 3f20: 00000007 c003d3a0 0000193d eaf9dde4 eaf9dde4 c02ef0c8 c000969c fffffffe
[   22.363944] 3f40: 00000000 c0037b54 eaf9dbb8 e9d1a380 00000000 c001d468 c0609cb0 00000000
[   22.372103] 3f60: c0609cb0 c061649e 00000001 c001250c eaf9dbb8 00000001 c0609cb0 c001d618
[   22.380262] 3f80: c001d5d0 c02ef56c 2d9d2e1e 00000005 eaf9dbb8 c02edcc4 2d9d2e1e 00000005
[   22.388421] 3fa0: c040446c c05da4ec c040446c eaf9dbb8 c05cfbb0 c004c580 c05dce68 c05b3ae8
[   22.396580] 3fc0: 00000000 c058bb24 ffffffff ffffffff c058b5e4 00000000 00000000 c05b3ae8
[   22.404740] 3fe0: c0616994 c05da47c c05b3ae4 c05ddeec 4000406a 40008074 00000000 00000000
[   22.412909] [<c00125e0>] (__cpu_suspend_save) from [<c00123bc>] (__cpu_suspend+0x5c/0x70)
[   22.421074] [<c00123bc>] (__cpu_suspend) from [<c05d3f4c>] (init_thread_union+0x1f4c/0x2000)
[   22.429479] Code: bad PC value
[   22.432518] ---[ end trace fb90ebf4217d0ad9 ]---
[   22.437116] Kernel panic - not syncing: Attempted to kill the idle task!
[   22.443800] Rebooting in 5 seconds..

This patch has been tested on Exynos4210 based Origen board.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mm/proc-macros.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mm/proc-macros.S b/arch/arm/mm/proc-macros.S
index ee1d805..ba1196c 100644
--- a/arch/arm/mm/proc-macros.S
+++ b/arch/arm/mm/proc-macros.S
@@ -279,7 +279,7 @@ ENTRY(\name\()_processor_functions)
 
 	.if \suspend
 	.word	cpu_\name\()_suspend_size
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_ARM_CPU_SUSPEND
 	.word	cpu_\name\()_do_suspend
 	.word	cpu_\name\()_do_resume
 #else
-- 
1.8.2.3

