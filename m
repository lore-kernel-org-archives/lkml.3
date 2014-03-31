Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbaCaHQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 03:16:15 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:14590
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752572AbaCaHQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 03:16:13 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zze0eahzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>
CC: <linux@roeck-us.net>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] regmap: mmio: Fix the bug of 'offset' value parsing.
Date: Mon, 31 Mar 2014 14:33:31 +0800
Message-ID: <1396247611-22289-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'offset = *(u32 *)reg;', this will be okey for 32/64-bit register, but
for 8/16-bit register, the 'offset' value will overflow.

++++++++++++
XX_mmio_YY_write: ctx->regs = 0x888c0000, offset1 = *(u32 *)reg = 0x77310000
XX_mmio_YY_write: ctx->regs = 0x888c0000, offset2 = *(u16 *)reg = 0x0
XX_mmio_YY_write: ctx->regs + offset1 = 0xffbd0000 --> but should be 0x888c0000
-----------
The core trace:
===============
Unable to handle kernel paging request at virtual address ffbd0000
pgd = 871e8000
[ffbd0000] *pgd=00000000
Internal error: Oops: 805 [#1] ARM
Modules linked in:
CPU: 0 PID: 1004 Comm: sh Not tainted 3.14.0-rc6+ #990
task: 871baa40 ti: 87090000 task.ti: 87090000
PC is at regmap_mmio_gather_write.part.4+0xd0/0x16c
LR is at regmap_mmio_gather_write.part.4+0xc4/0x16c
pc : [<8049ecac>]    lr : [<8049eca0>]    psr: a0000093
sp : 87091c10  ip : 87091c10  fp : 87091c3c
r10: 87ac43c0  r9 : 00000001  r8 : 8075801c
r7 : 87ac43c2  r6 : 00000002  r5 : 77310000  r4 : 87ac4340
r3 : ffbd0000  r2 : 00007731  r1 : 00000000  r0 : 00000042
Flags: NzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 10c53c7d  Table: 871e8059  DAC: 00000015
Process sh (pid: 1004, stack limit = 0x87090238)
Stack: (0x87091c10 to 0x87092000)
1c00:                                     00000000 87091c20 87ac4340 87ac43c2
1c20: 87ac43c0 00000002 00000000 fffffdf4 87091c5c 87091c40 802992d0 8049ebe8
...
1fc0: 000af2ac 00000001 00000000 00000005 000af2ac 00000000 ffffffff 00000000
1fe0: 000ac7ac 7ec1a570 000421a4 76ef1c10 60000010 000af2ac 00000000 00000000
Backtrace:
[<8049ebdc>] (regmap_mmio_gather_write.part.4) from [<802992d0>] (regmap_mmio_gather_write+0x60/0x64)
 r10:fffffdf4 r8:00000000 r7:00000002 r6:87ac43c0 r5:87ac43c2 r4:87ac4340
[<80299270>] (regmap_mmio_gather_write) from [<8029930c>] (regmap_mmio_write+0x38/0x44)
 r6:87ac43c2 r5:00000000 r4:87ac0c00 r3:87ac43c2
[<802992d4>] (regmap_mmio_write) from [<802959f4>] (_regmap_raw_write+0x5ac/0x5d8)
[<80295448>] (_regmap_raw_write) from [<80295bc0>] (_regmap_bus_raw_write+0x74/0x9c)
 r10:8076ff88 r9:804c8954 r8:8076b04c r7:87ac0c00 r6:00007731 r5:00000000
 r4:87ac0c00
[<80295b4c>] (_regmap_bus_raw_write) from [<80294a80>] (_regmap_write+0x60/0x9c)
 r5:00000000 r4:87ac0c00
[<80294a20>] (_regmap_write) from [<80295fd4>] (regmap_write+0x4c/0x64)
 r7:871be988 r6:00007731 r5:00000000 r4:87ac0c00
[<80295f88>] (regmap_write) from [<8030616c>] (imx2_wdt_start+0x88/0xf4)
 r6:87b7f540 r5:87813400 r4:807f9e68 r3:00000031
[<803060e4>] (imx2_wdt_start) from [<80306214>] (imx2_wdt_open+0x3c/0x58)
 r5:871be988 r4:87b7f540
[<803061d8>] (imx2_wdt_open) from [<80288b48>] (misc_open+0xc0/0x160)
 r5:00000082 r4:803061d8
[<80288a88>] (misc_open) from [<80096d88>] (chrdev_open+0xa4/0x144)
 r10:871bea38 r9:00000000 r8:804c0dd4 r7:00000000 r6:8789b240 r5:87b7f540
 r4:871be988 r3:80288a88
[<80096ce4>] (chrdev_open) from [<800916f4>] (do_dentry_open.isra.17+0x1b0/0x270)
 r8:00000000 r7:80096ce4 r6:87b7f548 r5:871be988 r4:87b7f540
[<80091544>] (do_dentry_open.isra.17) from [<800917dc>] (finish_open+0x28/0x40)
 r10:00000000 r8:00000000 r7:87091e80 r6:00020241 r5:87091f5c r4:87091e94
[<800917b4>] (finish_open) from [<800a0044>] (do_last.isra.68+0x3ac/0x5a8)
 r4:87091ed0 r3:87091e94
[<8009fc98>] (do_last.isra.68) from [<800a02fc>] (path_openat+0xbc/0x448)
 r10:87091e80 r9:87090000 r8:00000000 r7:00000000 r6:87091f5c r5:87b7f540
 r4:87091ed0
[<800a0240>] (path_openat) from [<800a09c0>] (do_filp_open+0x34/0x88)
 r10:00000000 r9:87090000 r8:8000e5c4 r7:87219000 r6:ffffff9c r5:00000001
 r4:87091f5c
[<800a098c>] (do_filp_open) from [<80092998>] (do_sys_open+0x128/0x1d8)
 r7:00000005 r6:ffffff9c r5:87219000 r4:00000003
[<80092870>] (do_sys_open) from [<80092a6c>] (SyS_open+0x24/0x28)
 r10:00000000 r8:8000e5c4 r7:00000005 r6:00000000 r5:00000001 r4:000af2ac
[<80092a48>] (SyS_open) from [<8000e440>] (ret_fast_syscall+0x0/0x30)

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/base/regmap/regmap-mmio.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/base/regmap/regmap-mmio.c b/drivers/base/regmap/regmap-mmio.c
index 5c36851..83532b7 100644
--- a/drivers/base/regmap/regmap-mmio.c
+++ b/drivers/base/regmap/regmap-mmio.c
@@ -61,17 +61,37 @@ static inline int regmap_mmio_reg_bits_check(size_t reg_bits)
 		return -EINVAL;
 	}
 }
+
 static inline void regmap_mmio_count_check(size_t count)
 {
 	BUG_ON(count % 2 != 0);
 }
 
+static inline unsigned int regmap_mmio_get_offset(const void *reg,
+						  size_t reg_size)
+{
+	switch (reg_size) {
+	case 1:
+		return *(u8 *)reg;
+	case 2:
+		return *(u16 *)reg;
+	case 4:
+		return *(u32 *)reg;
+#ifdef CONFIG_64BIT
+	case 8:
+		return *(u64 *)reg;
+#endif
+	default:
+		BUG();
+	}
+}
+
 static int regmap_mmio_gather_write(void *context,
 				    const void *reg, size_t reg_size,
 				    const void *val, size_t val_size)
 {
 	struct regmap_mmio_context *ctx = context;
-	u32 offset;
+	unsigned int offset;
 	int ret;
 
 	regmap_mmio_reg_size_check(reg_size);
@@ -82,7 +102,7 @@ static int regmap_mmio_gather_write(void *context,
 			return ret;
 	}
 
-	offset = *(u32 *)reg;
+	offset = regmap_mmio_get_offset(reg, reg_size);
 
 	while (val_size) {
 		switch (ctx->val_bytes) {
@@ -131,7 +151,7 @@ static int regmap_mmio_read(void *context,
 			    void *val, size_t val_size)
 {
 	struct regmap_mmio_context *ctx = context;
-	u32 offset;
+	unsigned int offset;
 	int ret;
 
 	regmap_mmio_reg_size_check(reg_size);
@@ -142,7 +162,7 @@ static int regmap_mmio_read(void *context,
 			return ret;
 	}
 
-	offset = *(u32 *)reg;
+	offset = regmap_mmio_get_offset(reg, reg_size);
 
 	while (val_size) {
 		switch (ctx->val_bytes) {
-- 
1.8.4


