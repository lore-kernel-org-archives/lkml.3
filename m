Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab3EBG0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 02:26:00 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56709 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807Ab3EBGZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 02:25:57 -0400
From: Ambresh K <ambresh@ti.com>
To: Mike Turquette <mturquette@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Tero Kristo <t-kristo@ti.com>,
        Rajendra <rnayak@ti.com>, Ambresh K <ambresh@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [Patch 0/3] Fix to clk framework while handling orphan clks 
Date: Thu, 2 May 2013 11:55:26 +0530
Message-ID: <1367475929-32166-1-git-send-email-ambresh@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ambresh K <ambresh@ti.com>

On a possible HW bug or in-correct configuration of clk_sel bits in bootloaders, there 
are high probablity of returning a value greater than available parent clocks for a 
MUX clk.     
Sensing invalid parent index, clk_mux_get_parent returns -EINVALID. 
Due to function's "u8" return type it will get converted into signed value,
thus causing following pointer dereference on test platform.

Patch series fixes the bug and also minor optimzation while re-parenting orphan clk.
 
M[    0.000000] dra7xx_clk_init: clk init (gpu_core_gclk_mux)^M
^M[    0.000000] Unable to handle kernel NULL pointer dereference at virtual address 00000000^M
^M[    0.000000] pgd = c0004000^M
^M[    0.000000] [00000000] *pgd=00000000^M
^M[    0.000000] Internal error: Oops: 5 [#1] SMP ARM^M
^M[    0.000000] Modules linked in:^M
^M[    0.000000] CPU: 0    Not tainted  (3.8.4-gb746a7c-dirty #59)^M
^M[    0.000000] PC is at strcmp+0x8/0x34^M
^M[    0.000000] LR is at __clk_init+0x16c/0x3cc^M
^M[    0.000000] pc : [<c033af7c>]    lr : [<c04ca314>]    psr: 600001d3^M
^M[    0.000000] sp : c09d1f70  ip : c0a12b3c  fp : 00000000^M
^M[    0.000000] r10: 00000000  r9 : c0a0f8b4  r8 : 8000406a^M
^M[    0.000000] r7 : c09d1fe4  r6 : c0a0ff40  r5 : c102888c  r4 : c0a0ff40^M
^M[    0.000000] r3 : 00000000  r2 : 00000067  r1 : 00000000  r0 : c0731c14^M
^M[    0.000000] Flags: nZCv  IRQs off  FIQs off  Mode SVC_32  ISA ARM  Segment kernel^M
^M[    0.000000] Control: 10c53c7d  Table: 8000406a  DAC: 00000017^M
^M[    0.000000] Process swapper (pid: 0, stack limit = 0xc09d0240)^M
^M[    0.000000] Stack: (0xc09d1f70 to 0xc09d2000)^M
^M[    0.000000] 1f60:                                     00000000 c05c0518 c0731dd4 c0a0c9f8^M
^M[    0.000000] 1f80: c0a0d340 c0838f58 c09d1fe4 8000406a 412fc0f2 00000000 00000000 c0814370^M
^M[    0.000000] 1fa0: 00000005 c0837140 c0a92b78 c0806124 00000000 c09d1fc4 c100d780 c09d0000^M
^M[    0.000000] 1fc0: 00000001 00000000 c09dd6c4 c0802728 00000000 00000000 00000000 00000000^M
^M[    0.000000] 1fe0: 00000000 c0838f58 10c53c7d c09d894c c0838f54 80008078 00000000 00000000^M
^M[    0.000000] [<c033af7c>] (strcmp+0x8/0x34) from [<c04ca314>] (__clk_init+0x16c/0x3cc)^M
^M[    0.000000] [<c04ca314>] (__clk_init+0x16c/0x3cc) from [<c0814370>] (dra7xx_clk_init+0x5c/0xa8)^M
^M[    0.000000] [<c0814370>] (dra7xx_clk_init+0x5c/0xa8) from [<c0806124>] (setup_arch+0x148/0x194)^M
^M[    0.000000] [<c0806124>] (setup_arch+0x148/0x194) from [<c0802728>] (start_kernel+0x80/0x2b8)^M
^M[    0.000000] [<c0802728>] (start_kernel+0x80/0x2b8) from [<80008078>] (0x80008078)^M
^M[    0.000000] Code: e8bd0070 e12fff1e e3a03000 e7d02003 (e7d1c003) ^M
^M[    0.000000] ---[ end trace 1b75b31a2719ed1c ]---^M
^M[    0.000000] Kernel panic - not syncing: Fatal exception^M 

Note:
1) With omap2plus_defconfig following warning are generated with the patches applied, will fix it on
reviewing the patches series. 
2) Other platforms too might have similar warnings.    

arch/arm/mach-omap2/cclock2420_data.c:116: warning: initialization from incompatible pointer type
arch/arm/mach-omap2/cclock2420_data.c:369: warning: initialization from incompatible pointer type
arch/arm/mach-omap2/cclock2420_data.c:417: warning: initialization from incompatible pointer type
arch/arm/mach-omap2/cclock2420_data.c:745: warning: initialization from incompatible pointer type
arch/arm/mach-omap2/cclock2430_data.c:116: warning: initialization from incompatible pointer type
arch/arm/mach-omap2/cclock2430_data.c:349: warning: initialization from incompatible pointer type
arch/arm/mach-omap2/cclock2430_data.c:397: warning: initialization from incompatible pointer type
arch/arm/mach-omap2/cclock2430_data.c:724: warning: initialization from incompatible pointer type
arch/arm/mach-omap2/cclock3xxx_data.c:118: warning: initialization from incompatible pointer type
arch/arm/mach-omap2/cclock3xxx_data.c:257: warning: initialization from incompatible pointer type
arch/arm/mach-omap2/cclock3xxx_data.c:367: warning: initialization from incompatible pointer type
arch/arm/mach-omap2/cclock3xxx_data.c:585: warning: initialization from incompatible pointer type
arch/arm/mach-omap2/cclock3xxx_data.c:619: warning: initialization from incompatible pointer type
arch/arm/mach-omap2/cclock3xxx_data.c:1176: warning: initialization from incompatible pointer type
arch/arm/mach-omap2/cclock3xxx_data.c:2600: warning: initialization from incompatible pointer type
arch/arm/mach-omap2/cclock3xxx_data.c:3091: warning: initialization from incompatible pointer type
arch/arm/mach-omap2/cclock44xx_data.c:159: warning: initialization from incompatible pointer type
arch/arm/mach-omap2/cclock44xx_data.c:257: warning: initialization from incompatible pointer type
arch/arm/mach-omap2/cclock44xx_data.c:327: warning: initialization from incompatible pointer type
arch/arm/mach-omap2/cclock44xx_data.c:334: warning: initialization from incompatible pointer type
arch/arm/mach-omap2/cclock44xx_data.c:398: warning: initialization from incompatible pointer type
arch/arm/mach-omap2/cclock44xx_data.c:614: warning: initialization from incompatible pointer type
arch/arm/mach-omap2/cclock44xx_data.c:1329: warning: initialization from incompatible pointer type
arch/arm/mach-omap2/cclock33xx_data.c:105: warning: initialization from incompatible pointer type
arch/arm/mach-omap2/cclock33xx_data.c:182: warning: initialization from incompatible pointer type
arch/arm/mach-omap2/cclock33xx_data.c:225: warning: initialization from incompatible pointer type
arch/arm/mach-omap2/cclock33xx_data.c:481: warning: initialization from incompatible pointer type
arch/arm/mach-omap2/cclock33xx_data.c:601: warning: initialization from incompatible pointer type
arch/arm/mach-omap2/cclock33xx_data.c:644: warning: initialization from incompatible pointer type


Ambresh K (3):
  clk: fix clk_mux_get_parent return's signed value
  clk: skip re-parenting orphan clk
  clk: Avoid re-parenting orphan clk's having invalid parent index.

 drivers/clk/clk-mux.c        |    2 +-
 drivers/clk/clk.c            |   37 ++++++++++++++++++++++++++++++++++---
 include/linux/clk-provider.h |    4 ++--
 3 files changed, 37 insertions(+), 6 deletions(-)

-- 
1.7.4.1

