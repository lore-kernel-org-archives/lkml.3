Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbaAEQsI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 11:48:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57656 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbaAEQrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 11:47:55 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: Re: [3.5.y.z extended stable] Linux 3.5.7.28
Date: Sun,  5 Jan 2014 16:47:42 +0000
Message-Id: <1388940462-4545-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388940462-4545-1-git-send-email-luis.henriques@canonical.com>
References: <1388940462-4545-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Documentation/i2c/busses/i2c-i801 b/Documentation/i2c/busses/i2c-i801
index 99d4e44..8bb57d7 100644
--- a/Documentation/i2c/busses/i2c-i801
+++ b/Documentation/i2c/busses/i2c-i801
@@ -22,6 +22,7 @@ Supported adapters:
   * Intel Panther Point (PCH)
   * Intel Lynx Point (PCH)
   * Intel Lynx Point-LP (PCH)
+  * Intel Avoton (SOC)
    Datasheets: Publicly available at the Intel website
 
 On Intel Patsburg and later chipsets, both the normal host SMBus controller
diff --git a/Makefile b/Makefile
index ab9a201..6b37b43 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 5
 SUBLEVEL = 7
-EXTRAVERSION = .27
+EXTRAVERSION = .28
 NAME = Saber-toothed Squirrel
 
 # *DOCUMENTATION*
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 693b744..e5bacab 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -483,6 +483,7 @@ EXPORT_SYMBOL(kernel_thread);
 unsigned long get_wchan(struct task_struct *p)
 {
 	struct stackframe frame;
+	unsigned long stack_page;
 	int count = 0;
 	if (!p || p == current || p->state == TASK_RUNNING)
 		return 0;
@@ -491,9 +492,11 @@ unsigned long get_wchan(struct task_struct *p)
 	frame.sp = thread_saved_sp(p);
 	frame.lr = 0;			/* recovered from the stack */
 	frame.pc = thread_saved_pc(p);
+	stack_page = (unsigned long)task_stack_page(p);
 	do {
-		int ret = unwind_frame(&frame);
-		if (ret < 0)
+		if (frame.sp < stack_page ||
+		    frame.sp >= stack_page + THREAD_SIZE ||
+		    unwind_frame(&frame) < 0)
 			return 0;
 		if (!in_sched_functions(frame.pc))
 			return frame.pc;
diff --git a/arch/arm/kernel/stacktrace.c b/arch/arm/kernel/stacktrace.c
index 00f79e5..af4e8c8 100644
--- a/arch/arm/kernel/stacktrace.c
+++ b/arch/arm/kernel/stacktrace.c
@@ -31,7 +31,7 @@ int notrace unwind_frame(struct stackframe *frame)
 	high = ALIGN(low, THREAD_SIZE);
 
 	/* check current frame pointer is within bounds */
-	if (fp < (low + 12) || fp + 4 >= high)
+	if (fp < low + 12 || fp > high - 4)
 		return -EINVAL;
 
 	/* restore the registers from the stack frame */
diff --git a/arch/arm/mach-footbridge/common.c b/arch/arm/mach-footbridge/common.c
index 3e6aaa6..e8cf2a1 100644
--- a/arch/arm/mach-footbridge/common.c
+++ b/arch/arm/mach-footbridge/common.c
@@ -15,7 +15,8 @@
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/spinlock.h>
- 
+#include <video/vga.h>
+
 #include <asm/pgtable.h>
 #include <asm/page.h>
 #include <asm/irq.h>
@@ -198,6 +199,8 @@ void __init footbridge_map_io(void)
 	 */
 	if (footbridge_cfn_mode())
 		iotable_init(ebsa285_host_io_desc, ARRAY_SIZE(ebsa285_host_io_desc));
+
+	vga_base = PCIMEM_BASE;
 }
 
 void footbridge_restart(char mode, const char *cmd)
diff --git a/arch/arm/mach-footbridge/dc21285.c b/arch/arm/mach-footbridge/dc21285.c
index 9d62e33..405d22b 100644
--- a/arch/arm/mach-footbridge/dc21285.c
+++ b/arch/arm/mach-footbridge/dc21285.c
@@ -18,7 +18,6 @@
 #include <linux/irq.h>
 #include <linux/io.h>
 #include <linux/spinlock.h>
-#include <video/vga.h>
 
 #include <asm/irq.h>
 #include <asm/mach/pci.h>
@@ -293,7 +292,6 @@ void __init dc21285_preinit(void)
 	int cfn_mode;
 
 	pcibios_min_mem = 0x81000000;
-	vga_base = PCIMEM_BASE;
 
 	mem_size = (unsigned int)high_memory - PAGE_OFFSET;
 	for (mem_mask = 0x00100000; mem_mask < 0x10000000; mem_mask <<= 1)
diff --git a/arch/arm/mach-pxa/tosa.c b/arch/arm/mach-pxa/tosa.c
index 4d4eb60..aeb7c10 100644
--- a/arch/arm/mach-pxa/tosa.c
+++ b/arch/arm/mach-pxa/tosa.c
@@ -424,57 +424,57 @@ static struct platform_device tosa_power_device = {
  * Tosa Keyboard
  */
 static const uint32_t tosakbd_keymap[] = {
-	KEY(0, 2, KEY_W),
-	KEY(0, 6, KEY_K),
-	KEY(0, 7, KEY_BACKSPACE),
-	KEY(0, 8, KEY_P),
-	KEY(1, 1, KEY_Q),
-	KEY(1, 2, KEY_E),
-	KEY(1, 3, KEY_T),
-	KEY(1, 4, KEY_Y),
-	KEY(1, 6, KEY_O),
-	KEY(1, 7, KEY_I),
-	KEY(1, 8, KEY_COMMA),
-	KEY(2, 1, KEY_A),
-	KEY(2, 2, KEY_D),
-	KEY(2, 3, KEY_G),
-	KEY(2, 4, KEY_U),
-	KEY(2, 6, KEY_L),
-	KEY(2, 7, KEY_ENTER),
-	KEY(2, 8, KEY_DOT),
-	KEY(3, 1, KEY_Z),
-	KEY(3, 2, KEY_C),
-	KEY(3, 3, KEY_V),
-	KEY(3, 4, KEY_J),
-	KEY(3, 5, TOSA_KEY_ADDRESSBOOK),
-	KEY(3, 6, TOSA_KEY_CANCEL),
-	KEY(3, 7, TOSA_KEY_CENTER),
-	KEY(3, 8, TOSA_KEY_OK),
-	KEY(3, 9, KEY_LEFTSHIFT),
-	KEY(4, 1, KEY_S),
-	KEY(4, 2, KEY_R),
-	KEY(4, 3, KEY_B),
-	KEY(4, 4, KEY_N),
-	KEY(4, 5, TOSA_KEY_CALENDAR),
-	KEY(4, 6, TOSA_KEY_HOMEPAGE),
-	KEY(4, 7, KEY_LEFTCTRL),
-	KEY(4, 8, TOSA_KEY_LIGHT),
-	KEY(4, 10, KEY_RIGHTSHIFT),
-	KEY(5, 1, KEY_TAB),
-	KEY(5, 2, KEY_SLASH),
-	KEY(5, 3, KEY_H),
-	KEY(5, 4, KEY_M),
-	KEY(5, 5, TOSA_KEY_MENU),
-	KEY(5, 7, KEY_UP),
-	KEY(5, 11, TOSA_KEY_FN),
-	KEY(6, 1, KEY_X),
-	KEY(6, 2, KEY_F),
-	KEY(6, 3, KEY_SPACE),
-	KEY(6, 4, KEY_APOSTROPHE),
-	KEY(6, 5, TOSA_KEY_MAIL),
-	KEY(6, 6, KEY_LEFT),
-	KEY(6, 7, KEY_DOWN),
-	KEY(6, 8, KEY_RIGHT),
+	KEY(0, 1, KEY_W),
+	KEY(0, 5, KEY_K),
+	KEY(0, 6, KEY_BACKSPACE),
+	KEY(0, 7, KEY_P),
+	KEY(1, 0, KEY_Q),
+	KEY(1, 1, KEY_E),
+	KEY(1, 2, KEY_T),
+	KEY(1, 3, KEY_Y),
+	KEY(1, 5, KEY_O),
+	KEY(1, 6, KEY_I),
+	KEY(1, 7, KEY_COMMA),
+	KEY(2, 0, KEY_A),
+	KEY(2, 1, KEY_D),
+	KEY(2, 2, KEY_G),
+	KEY(2, 3, KEY_U),
+	KEY(2, 5, KEY_L),
+	KEY(2, 6, KEY_ENTER),
+	KEY(2, 7, KEY_DOT),
+	KEY(3, 0, KEY_Z),
+	KEY(3, 1, KEY_C),
+	KEY(3, 2, KEY_V),
+	KEY(3, 3, KEY_J),
+	KEY(3, 4, TOSA_KEY_ADDRESSBOOK),
+	KEY(3, 5, TOSA_KEY_CANCEL),
+	KEY(3, 6, TOSA_KEY_CENTER),
+	KEY(3, 7, TOSA_KEY_OK),
+	KEY(3, 8, KEY_LEFTSHIFT),
+	KEY(4, 0, KEY_S),
+	KEY(4, 1, KEY_R),
+	KEY(4, 2, KEY_B),
+	KEY(4, 3, KEY_N),
+	KEY(4, 4, TOSA_KEY_CALENDAR),
+	KEY(4, 5, TOSA_KEY_HOMEPAGE),
+	KEY(4, 6, KEY_LEFTCTRL),
+	KEY(4, 7, TOSA_KEY_LIGHT),
+	KEY(4, 9, KEY_RIGHTSHIFT),
+	KEY(5, 0, KEY_TAB),
+	KEY(5, 1, KEY_SLASH),
+	KEY(5, 2, KEY_H),
+	KEY(5, 3, KEY_M),
+	KEY(5, 4, TOSA_KEY_MENU),
+	KEY(5, 6, KEY_UP),
+	KEY(5, 10, TOSA_KEY_FN),
+	KEY(6, 0, KEY_X),
+	KEY(6, 1, KEY_F),
+	KEY(6, 2, KEY_SPACE),
+	KEY(6, 3, KEY_APOSTROPHE),
+	KEY(6, 4, TOSA_KEY_MAIL),
+	KEY(6, 5, KEY_LEFT),
+	KEY(6, 6, KEY_DOWN),
+	KEY(6, 7, KEY_RIGHT),
 };
 
 static struct matrix_keymap_data tosakbd_keymap_data = {
diff --git a/arch/mips/mm/dma-default.c b/arch/mips/mm/dma-default.c
index 3fab204..0eea2d2 100644
--- a/arch/mips/mm/dma-default.c
+++ b/arch/mips/mm/dma-default.c
@@ -30,16 +30,20 @@ static inline struct page *dma_addr_to_page(struct device *dev,
 }
 
 /*
+ * The affected CPUs below in 'cpu_needs_post_dma_flush()' can
+ * speculatively fill random cachelines with stale data at any time,
+ * requiring an extra flush post-DMA.
+ *
  * Warning on the terminology - Linux calls an uncached area coherent;
  * MIPS terminology calls memory areas with hardware maintained coherency
  * coherent.
  */
-
-static inline int cpu_is_noncoherent_r10000(struct device *dev)
+static inline int cpu_needs_post_dma_flush(struct device *dev)
 {
 	return !plat_device_is_coherent(dev) &&
 	       (current_cpu_type() == CPU_R10000 ||
-	       current_cpu_type() == CPU_R12000);
+		current_cpu_type() == CPU_R12000 ||
+		current_cpu_type() == CPU_BMIPS5000);
 }
 
 static gfp_t massage_gfp_flags(const struct device *dev, gfp_t gfp)
@@ -209,7 +213,7 @@ static inline void __dma_sync(struct page *page,
 static void mips_dma_unmap_page(struct device *dev, dma_addr_t dma_addr,
 	size_t size, enum dma_data_direction direction, struct dma_attrs *attrs)
 {
-	if (cpu_is_noncoherent_r10000(dev))
+	if (cpu_needs_post_dma_flush(dev))
 		__dma_sync(dma_addr_to_page(dev, dma_addr),
 			   dma_addr & ~PAGE_MASK, size, direction);
 
@@ -260,7 +264,7 @@ static void mips_dma_unmap_sg(struct device *dev, struct scatterlist *sg,
 static void mips_dma_sync_single_for_cpu(struct device *dev,
 	dma_addr_t dma_handle, size_t size, enum dma_data_direction direction)
 {
-	if (cpu_is_noncoherent_r10000(dev))
+	if (cpu_needs_post_dma_flush(dev))
 		__dma_sync(dma_addr_to_page(dev, dma_handle),
 			   dma_handle & ~PAGE_MASK, size, direction);
 }
@@ -281,7 +285,7 @@ static void mips_dma_sync_sg_for_cpu(struct device *dev,
 
 	/* Make sure that gcc doesn't leave the empty loop body.  */
 	for (i = 0; i < nelems; i++, sg++) {
-		if (cpu_is_noncoherent_r10000(dev))
+		if (cpu_needs_post_dma_flush(dev))
 			__dma_sync(sg_page(sg), sg->offset, sg->length,
 				   direction);
 	}
diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 6522bb7..f3000a4 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -55,8 +55,7 @@ struct pcc_param {
 
 struct s390_xts_ctx {
 	u8 key[32];
-	u8 xts_param[16];
-	struct pcc_param pcc;
+	u8 pcc_key[32];
 	long enc;
 	long dec;
 	int key_len;
@@ -325,7 +324,8 @@ static int ecb_aes_crypt(struct blkcipher_desc *desc, long func, void *param,
 		u8 *in = walk->src.virt.addr;
 
 		ret = crypt_s390_km(func, param, out, in, n);
-		BUG_ON((ret < 0) || (ret != n));
+		if (ret < 0 || ret != n)
+			return -EIO;
 
 		nbytes &= AES_BLOCK_SIZE - 1;
 		ret = blkcipher_walk_done(desc, walk, nbytes);
@@ -464,7 +464,8 @@ static int cbc_aes_crypt(struct blkcipher_desc *desc, long func,
 		u8 *in = walk->src.virt.addr;
 
 		ret = crypt_s390_kmc(func, &param, out, in, n);
-		BUG_ON((ret < 0) || (ret != n));
+		if (ret < 0 || ret != n)
+			return -EIO;
 
 		nbytes &= AES_BLOCK_SIZE - 1;
 		ret = blkcipher_walk_done(desc, walk, nbytes);
@@ -592,7 +593,7 @@ static int xts_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 		xts_ctx->enc = KM_XTS_128_ENCRYPT;
 		xts_ctx->dec = KM_XTS_128_DECRYPT;
 		memcpy(xts_ctx->key + 16, in_key, 16);
-		memcpy(xts_ctx->pcc.key + 16, in_key + 16, 16);
+		memcpy(xts_ctx->pcc_key + 16, in_key + 16, 16);
 		break;
 	case 48:
 		xts_ctx->enc = 0;
@@ -603,7 +604,7 @@ static int xts_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 		xts_ctx->enc = KM_XTS_256_ENCRYPT;
 		xts_ctx->dec = KM_XTS_256_DECRYPT;
 		memcpy(xts_ctx->key, in_key, 32);
-		memcpy(xts_ctx->pcc.key, in_key + 32, 32);
+		memcpy(xts_ctx->pcc_key, in_key + 32, 32);
 		break;
 	default:
 		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
@@ -622,29 +623,35 @@ static int xts_aes_crypt(struct blkcipher_desc *desc, long func,
 	unsigned int nbytes = walk->nbytes;
 	unsigned int n;
 	u8 *in, *out;
-	void *param;
+	struct pcc_param pcc_param;
+	struct {
+		u8 key[32];
+		u8 init[16];
+	} xts_param;
 
 	if (!nbytes)
 		goto out;
 
-	memset(xts_ctx->pcc.block, 0, sizeof(xts_ctx->pcc.block));
-	memset(xts_ctx->pcc.bit, 0, sizeof(xts_ctx->pcc.bit));
-	memset(xts_ctx->pcc.xts, 0, sizeof(xts_ctx->pcc.xts));
-	memcpy(xts_ctx->pcc.tweak, walk->iv, sizeof(xts_ctx->pcc.tweak));
-	param = xts_ctx->pcc.key + offset;
-	ret = crypt_s390_pcc(func, param);
-	BUG_ON(ret < 0);
-
-	memcpy(xts_ctx->xts_param, xts_ctx->pcc.xts, 16);
-	param = xts_ctx->key + offset;
+	memset(pcc_param.block, 0, sizeof(pcc_param.block));
+	memset(pcc_param.bit, 0, sizeof(pcc_param.bit));
+	memset(pcc_param.xts, 0, sizeof(pcc_param.xts));
+	memcpy(pcc_param.tweak, walk->iv, sizeof(pcc_param.tweak));
+	memcpy(pcc_param.key, xts_ctx->pcc_key, 32);
+	ret = crypt_s390_pcc(func, &pcc_param.key[offset]);
+	if (ret < 0)
+		return -EIO;
+
+	memcpy(xts_param.key, xts_ctx->key, 32);
+	memcpy(xts_param.init, pcc_param.xts, 16);
 	do {
 		/* only use complete blocks */
 		n = nbytes & ~(AES_BLOCK_SIZE - 1);
 		out = walk->dst.virt.addr;
 		in = walk->src.virt.addr;
 
-		ret = crypt_s390_km(func, param, out, in, n);
-		BUG_ON(ret < 0 || ret != n);
+		ret = crypt_s390_km(func, &xts_param.key[offset], out, in, n);
+		if (ret < 0 || ret != n)
+			return -EIO;
 
 		nbytes &= AES_BLOCK_SIZE - 1;
 		ret = blkcipher_walk_done(desc, walk, nbytes);
@@ -778,7 +785,8 @@ static int ctr_aes_crypt(struct blkcipher_desc *desc, long func,
 				crypto_inc(ctrblk + i, AES_BLOCK_SIZE);
 			}
 			ret = crypt_s390_kmctr(func, sctx->key, out, in, n, ctrblk);
-			BUG_ON(ret < 0 || ret != n);
+			if (ret < 0 || ret != n)
+				return -EIO;
 			if (n > AES_BLOCK_SIZE)
 				memcpy(ctrblk, ctrblk + n - AES_BLOCK_SIZE,
 				       AES_BLOCK_SIZE);
@@ -797,7 +805,8 @@ static int ctr_aes_crypt(struct blkcipher_desc *desc, long func,
 		in = walk->src.virt.addr;
 		ret = crypt_s390_kmctr(func, sctx->key, buf, in,
 				       AES_BLOCK_SIZE, ctrblk);
-		BUG_ON(ret < 0 || ret != AES_BLOCK_SIZE);
+		if (ret < 0 || ret != AES_BLOCK_SIZE)
+			return -EIO;
 		memcpy(out, buf, nbytes);
 		crypto_inc(ctrblk, AES_BLOCK_SIZE);
 		ret = blkcipher_walk_done(desc, walk, 0);
diff --git a/arch/s390/crypto/des_s390.c b/arch/s390/crypto/des_s390.c
index a52bfd1..00d649c 100644
--- a/arch/s390/crypto/des_s390.c
+++ b/arch/s390/crypto/des_s390.c
@@ -95,7 +95,8 @@ static int ecb_desall_crypt(struct blkcipher_desc *desc, long func,
 		u8 *in = walk->src.virt.addr;
 
 		ret = crypt_s390_km(func, key, out, in, n);
-		BUG_ON((ret < 0) || (ret != n));
+		if (ret < 0 || ret != n)
+			return -EIO;
 
 		nbytes &= DES_BLOCK_SIZE - 1;
 		ret = blkcipher_walk_done(desc, walk, nbytes);
@@ -121,7 +122,8 @@ static int cbc_desall_crypt(struct blkcipher_desc *desc, long func,
 		u8 *in = walk->src.virt.addr;
 
 		ret = crypt_s390_kmc(func, iv, out, in, n);
-		BUG_ON((ret < 0) || (ret != n));
+		if (ret < 0 || ret != n)
+			return -EIO;
 
 		nbytes &= DES_BLOCK_SIZE - 1;
 		ret = blkcipher_walk_done(desc, walk, nbytes);
@@ -394,7 +396,8 @@ static int ctr_desall_crypt(struct blkcipher_desc *desc, long func,
 				crypto_inc(ctrblk + i, DES_BLOCK_SIZE);
 			}
 			ret = crypt_s390_kmctr(func, ctx->key, out, in, n, ctrblk);
-			BUG_ON((ret < 0) || (ret != n));
+			if (ret < 0 || ret != n)
+				return -EIO;
 			if (n > DES_BLOCK_SIZE)
 				memcpy(ctrblk, ctrblk + n - DES_BLOCK_SIZE,
 				       DES_BLOCK_SIZE);
@@ -412,7 +415,8 @@ static int ctr_desall_crypt(struct blkcipher_desc *desc, long func,
 		in = walk->src.virt.addr;
 		ret = crypt_s390_kmctr(func, ctx->key, buf, in,
 				       DES_BLOCK_SIZE, ctrblk);
-		BUG_ON(ret < 0 || ret != DES_BLOCK_SIZE);
+		if (ret < 0 || ret != DES_BLOCK_SIZE)
+			return -EIO;
 		memcpy(out, buf, nbytes);
 		crypto_inc(ctrblk, DES_BLOCK_SIZE);
 		ret = blkcipher_walk_done(desc, walk, 0);
diff --git a/arch/s390/crypto/ghash_s390.c b/arch/s390/crypto/ghash_s390.c
index b1bd170..f6373f0 100644
--- a/arch/s390/crypto/ghash_s390.c
+++ b/arch/s390/crypto/ghash_s390.c
@@ -72,14 +72,16 @@ static int ghash_update(struct shash_desc *desc,
 		if (!dctx->bytes) {
 			ret = crypt_s390_kimd(KIMD_GHASH, ctx, buf,
 					      GHASH_BLOCK_SIZE);
-			BUG_ON(ret != GHASH_BLOCK_SIZE);
+			if (ret != GHASH_BLOCK_SIZE)
+				return -EIO;
 		}
 	}
 
 	n = srclen & ~(GHASH_BLOCK_SIZE - 1);
 	if (n) {
 		ret = crypt_s390_kimd(KIMD_GHASH, ctx, src, n);
-		BUG_ON(ret != n);
+		if (ret != n)
+			return -EIO;
 		src += n;
 		srclen -= n;
 	}
@@ -92,7 +94,7 @@ static int ghash_update(struct shash_desc *desc,
 	return 0;
 }
 
-static void ghash_flush(struct ghash_ctx *ctx, struct ghash_desc_ctx *dctx)
+static int ghash_flush(struct ghash_ctx *ctx, struct ghash_desc_ctx *dctx)
 {
 	u8 *buf = dctx->buffer;
 	int ret;
@@ -103,21 +105,24 @@ static void ghash_flush(struct ghash_ctx *ctx, struct ghash_desc_ctx *dctx)
 		memset(pos, 0, dctx->bytes);
 
 		ret = crypt_s390_kimd(KIMD_GHASH, ctx, buf, GHASH_BLOCK_SIZE);
-		BUG_ON(ret != GHASH_BLOCK_SIZE);
+		if (ret != GHASH_BLOCK_SIZE)
+			return -EIO;
 	}
 
 	dctx->bytes = 0;
+	return 0;
 }
 
 static int ghash_final(struct shash_desc *desc, u8 *dst)
 {
 	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
 	struct ghash_ctx *ctx = crypto_shash_ctx(desc->tfm);
+	int ret;
 
-	ghash_flush(ctx, dctx);
-	memcpy(dst, ctx->icv, GHASH_BLOCK_SIZE);
-
-	return 0;
+	ret = ghash_flush(ctx, dctx);
+	if (!ret)
+		memcpy(dst, ctx->icv, GHASH_BLOCK_SIZE);
+	return ret;
 }
 
 static struct shash_alg ghash_alg = {
diff --git a/arch/s390/crypto/sha_common.c b/arch/s390/crypto/sha_common.c
index bd37d09..8620b0e 100644
--- a/arch/s390/crypto/sha_common.c
+++ b/arch/s390/crypto/sha_common.c
@@ -36,7 +36,8 @@ int s390_sha_update(struct shash_desc *desc, const u8 *data, unsigned int len)
 	if (index) {
 		memcpy(ctx->buf + index, data, bsize - index);
 		ret = crypt_s390_kimd(ctx->func, ctx->state, ctx->buf, bsize);
-		BUG_ON(ret != bsize);
+		if (ret != bsize)
+			return -EIO;
 		data += bsize - index;
 		len -= bsize - index;
 		index = 0;
@@ -46,7 +47,8 @@ int s390_sha_update(struct shash_desc *desc, const u8 *data, unsigned int len)
 	if (len >= bsize) {
 		ret = crypt_s390_kimd(ctx->func, ctx->state, data,
 				      len & ~(bsize - 1));
-		BUG_ON(ret != (len & ~(bsize - 1)));
+		if (ret != (len & ~(bsize - 1)))
+			return -EIO;
 		data += ret;
 		len -= ret;
 	}
@@ -88,7 +90,8 @@ int s390_sha_final(struct shash_desc *desc, u8 *out)
 	memcpy(ctx->buf + end - 8, &bits, sizeof(bits));
 
 	ret = crypt_s390_kimd(ctx->func, ctx->state, ctx->buf, end);
-	BUG_ON(ret != end);
+	if (ret != end)
+		return -EIO;
 
 	/* copy digest to out */
 	memcpy(out, ctx->state, crypto_shash_digestsize(desc->tfm));
diff --git a/arch/um/os-Linux/start_up.c b/arch/um/os-Linux/start_up.c
index 425162e..2f53b89 100644
--- a/arch/um/os-Linux/start_up.c
+++ b/arch/um/os-Linux/start_up.c
@@ -15,6 +15,8 @@
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <sys/wait.h>
+#include <sys/time.h>
+#include <sys/resource.h>
 #include <asm/unistd.h>
 #include "init.h"
 #include "os.h"
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 93c1574..94e0d9d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -545,7 +545,8 @@ static u32 apic_get_tmcct(struct kvm_lapic *apic)
 	ASSERT(apic != NULL);
 
 	/* if initial count is 0, current count should also be 0 */
-	if (apic_get_reg(apic, APIC_TMICT) == 0)
+	if (apic_get_reg(apic, APIC_TMICT) == 0 ||
+		apic->lapic_timer.period == 0)
 		return 0;
 
 	remaining = hrtimer_get_remaining(&apic->lapic_timer.timer);
@@ -1286,14 +1287,12 @@ void __kvm_migrate_apic_timer(struct kvm_vcpu *vcpu)
 void kvm_lapic_sync_from_vapic(struct kvm_vcpu *vcpu)
 {
 	u32 data;
-	void *vapic;
 
 	if (!test_bit(KVM_APIC_CHECK_VAPIC, &vcpu->arch.apic_attention))
 		return;
 
-	vapic = kmap_atomic(vcpu->arch.apic->vapic_page);
-	data = *(u32 *)(vapic + offset_in_page(vcpu->arch.apic->vapic_addr));
-	kunmap_atomic(vapic);
+	kvm_read_guest_cached(vcpu->kvm, &vcpu->arch.apic->vapic_cache, &data,
+				sizeof(u32));
 
 	apic_set_tpr(vcpu->arch.apic, data & 0xff);
 }
@@ -1303,7 +1302,6 @@ void kvm_lapic_sync_to_vapic(struct kvm_vcpu *vcpu)
 	u32 data, tpr;
 	int max_irr, max_isr;
 	struct kvm_lapic *apic;
-	void *vapic;
 
 	if (!test_bit(KVM_APIC_CHECK_VAPIC, &vcpu->arch.apic_attention))
 		return;
@@ -1318,18 +1316,24 @@ void kvm_lapic_sync_to_vapic(struct kvm_vcpu *vcpu)
 		max_isr = 0;
 	data = (tpr & 0xff) | ((max_isr & 0xf0) << 8) | (max_irr << 24);
 
-	vapic = kmap_atomic(vcpu->arch.apic->vapic_page);
-	*(u32 *)(vapic + offset_in_page(vcpu->arch.apic->vapic_addr)) = data;
-	kunmap_atomic(vapic);
+	kvm_write_guest_cached(vcpu->kvm, &vcpu->arch.apic->vapic_cache, &data,
+				sizeof(u32));
 }
 
-void kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr)
+int kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr)
 {
-	vcpu->arch.apic->vapic_addr = vapic_addr;
-	if (vapic_addr)
+	if (vapic_addr) {
+		if (kvm_gfn_to_hva_cache_init(vcpu->kvm,
+					&vcpu->arch.apic->vapic_cache,
+					vapic_addr, sizeof(u32)))
+			return -EINVAL;
 		__set_bit(KVM_APIC_CHECK_VAPIC, &vcpu->arch.apic_attention);
-	else
+	} else {
 		__clear_bit(KVM_APIC_CHECK_VAPIC, &vcpu->arch.apic_attention);
+	}
+
+	vcpu->arch.apic->vapic_addr = vapic_addr;
+	return 0;
 }
 
 int kvm_x2apic_msr_write(struct kvm_vcpu *vcpu, u32 msr, u64 data)
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 6f4ce25..6aec071 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -15,7 +15,7 @@ struct kvm_lapic {
 	bool irr_pending;
 	void *regs;
 	gpa_t vapic_addr;
-	struct page *vapic_page;
+	struct gfn_to_hva_cache vapic_cache;
 };
 int kvm_create_lapic(struct kvm_vcpu *vcpu);
 void kvm_free_lapic(struct kvm_vcpu *vcpu);
@@ -46,7 +46,7 @@ int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu);
 u64 kvm_get_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu);
 void kvm_set_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu, u64 data);
 
-void kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr);
+int kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr);
 void kvm_lapic_sync_from_vapic(struct kvm_vcpu *vcpu);
 void kvm_lapic_sync_to_vapic(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 671e5df..494817e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2751,8 +2751,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r = -EFAULT;
 		if (copy_from_user(&va, argp, sizeof va))
 			goto out;
-		r = 0;
-		kvm_lapic_set_vapic_addr(vcpu, va.vapic_addr);
+		r = kvm_lapic_set_vapic_addr(vcpu, va.vapic_addr);
 		break;
 	}
 	case KVM_X86_SETUP_MCE: {
@@ -5096,33 +5095,6 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu)
 			!kvm_event_needs_reinjection(vcpu);
 }
 
-static void vapic_enter(struct kvm_vcpu *vcpu)
-{
-	struct kvm_lapic *apic = vcpu->arch.apic;
-	struct page *page;
-
-	if (!apic || !apic->vapic_addr)
-		return;
-
-	page = gfn_to_page(vcpu->kvm, apic->vapic_addr >> PAGE_SHIFT);
-
-	vcpu->arch.apic->vapic_page = page;
-}
-
-static void vapic_exit(struct kvm_vcpu *vcpu)
-{
-	struct kvm_lapic *apic = vcpu->arch.apic;
-	int idx;
-
-	if (!apic || !apic->vapic_addr)
-		return;
-
-	idx = srcu_read_lock(&vcpu->kvm->srcu);
-	kvm_release_page_dirty(apic->vapic_page);
-	mark_page_dirty(vcpu->kvm, apic->vapic_addr >> PAGE_SHIFT);
-	srcu_read_unlock(&vcpu->kvm->srcu, idx);
-}
-
 static void update_cr8_intercept(struct kvm_vcpu *vcpu)
 {
 	int max_irr, tpr;
@@ -5408,7 +5380,6 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 	}
 
 	vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
-	vapic_enter(vcpu);
 
 	r = 1;
 	while (r > 0) {
@@ -5465,8 +5436,6 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 
 	srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
 
-	vapic_exit(vcpu);
-
 	return r;
 }
 
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index cfe8b9c..46e5387 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -760,13 +760,6 @@ void __init efi_init(void)
 
 	set_bit(EFI_MEMMAP, &x86_efi_facility);
 
-#ifdef CONFIG_X86_32
-	if (efi_is_native()) {
-		x86_platform.get_wallclock = efi_get_time;
-		x86_platform.set_wallclock = efi_set_rtc_mmss;
-	}
-#endif
-
 #if EFI_DEBUG
 	print_efi_memmap();
 #endif
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 8ac457c..b8521f4 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -261,9 +261,9 @@ static inline uint64_t blkg_stat_read(struct blkg_stat *stat)
 	uint64_t v;
 
 	do {
-		start = u64_stats_fetch_begin(&stat->syncp);
+		start = u64_stats_fetch_begin_bh(&stat->syncp);
 		v = stat->cnt;
-	} while (u64_stats_fetch_retry(&stat->syncp, start));
+	} while (u64_stats_fetch_retry_bh(&stat->syncp, start));
 
 	return v;
 }
@@ -317,9 +317,9 @@ static inline struct blkg_rwstat blkg_rwstat_read(struct blkg_rwstat *rwstat)
 	struct blkg_rwstat tmp;
 
 	do {
-		start = u64_stats_fetch_begin(&rwstat->syncp);
+		start = u64_stats_fetch_begin_bh(&rwstat->syncp);
 		tmp = *rwstat;
-	} while (u64_stats_fetch_retry(&rwstat->syncp, start));
+	} while (u64_stats_fetch_retry_bh(&rwstat->syncp, start));
 
 	return tmp;
 }
diff --git a/block/elevator.c b/block/elevator.c
index 6a55d41..f69363e 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -936,7 +936,7 @@ fail_init:
 /*
  * Switch this queue to the given IO scheduler.
  */
-int elevator_change(struct request_queue *q, const char *name)
+static int __elevator_change(struct request_queue *q, const char *name)
 {
 	char elevator_name[ELV_NAME_MAX];
 	struct elevator_type *e;
@@ -958,6 +958,18 @@ int elevator_change(struct request_queue *q, const char *name)
 
 	return elevator_switch(q, e);
 }
+
+int elevator_change(struct request_queue *q, const char *name)
+{
+	int ret;
+
+	/* Protect q->elevator from elevator_init() */
+	mutex_lock(&q->sysfs_lock);
+	ret = __elevator_change(q, name);
+	mutex_unlock(&q->sysfs_lock);
+
+	return ret;
+}
 EXPORT_SYMBOL(elevator_change);
 
 ssize_t elv_iosched_store(struct request_queue *q, const char *name,
@@ -968,7 +980,7 @@ ssize_t elv_iosched_store(struct request_queue *q, const char *name,
 	if (!q->elevator)
 		return count;
 
-	ret = elevator_change(q, name);
+	ret = __elevator_change(q, name);
 	if (!ret)
 		return count;
 
diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index 0262210..8502462 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -114,6 +114,9 @@ static ssize_t hash_sendpage(struct socket *sock, struct page *page,
 	struct hash_ctx *ctx = ask->private;
 	int err;
 
+	if (flags & MSG_SENDPAGE_NOTLAST)
+		flags |= MSG_MORE;
+
 	lock_sock(sk);
 	sg_init_table(ctx->sgl.sg, 1);
 	sg_set_page(ctx->sgl.sg, page, size, offset);
@@ -161,8 +164,6 @@ static int hash_recvmsg(struct kiocb *unused, struct socket *sock,
 	else if (len < ds)
 		msg->msg_flags |= MSG_TRUNC;
 
-	msg->msg_namelen = 0;
-
 	lock_sock(sk);
 	if (ctx->more) {
 		ctx->more = 0;
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index a1c4f0a..a19c027 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -378,6 +378,9 @@ static ssize_t skcipher_sendpage(struct socket *sock, struct page *page,
 	struct skcipher_sg_list *sgl;
 	int err = -EINVAL;
 
+	if (flags & MSG_SENDPAGE_NOTLAST)
+		flags |= MSG_MORE;
+
 	lock_sock(sk);
 	if (!ctx->more && ctx->used)
 		goto unlock;
@@ -432,7 +435,6 @@ static int skcipher_recvmsg(struct kiocb *unused, struct socket *sock,
 	long copied = 0;
 
 	lock_sock(sk);
-	msg->msg_namelen = 0;
 	for (iov = msg->msg_iov, iovlen = msg->msg_iovlen; iovlen > 0;
 	     iovlen--, iov++) {
 		unsigned long seglen = iov->iov_len;
diff --git a/crypto/authenc.c b/crypto/authenc.c
index 5ef7ba6..d21da2f 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -368,9 +368,10 @@ static void crypto_authenc_encrypt_done(struct crypto_async_request *req,
 	if (!err) {
 		struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
 		struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
-		struct ablkcipher_request *abreq = aead_request_ctx(areq);
-		u8 *iv = (u8 *)(abreq + 1) +
-			 crypto_ablkcipher_reqsize(ctx->enc);
+		struct authenc_request_ctx *areq_ctx = aead_request_ctx(areq);
+		struct ablkcipher_request *abreq = (void *)(areq_ctx->tail
+							    + ctx->reqoff);
+		u8 *iv = (u8 *)abreq - crypto_ablkcipher_ivsize(ctx->enc);
 
 		err = crypto_authenc_genicv(areq, iv, 0);
 	}
diff --git a/crypto/ccm.c b/crypto/ccm.c
index 32fe1bb..18d64ad 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -271,7 +271,8 @@ static int crypto_ccm_auth(struct aead_request *req, struct scatterlist *plain,
 	}
 
 	/* compute plaintext into mac */
-	get_data_to_compute(cipher, pctx, plain, cryptlen);
+	if (cryptlen)
+		get_data_to_compute(cipher, pctx, plain, cryptlen);
 
 out:
 	return err;
diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index 8974bd2..81845fa 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -3513,7 +3513,7 @@ init_card(struct atm_dev *dev)
 	tmp = dev_get_by_name(&init_net, tname);	/* jhs: was "tmp = dev_get(tname);" */
 	if (tmp) {
 		memcpy(card->atmdev->esi, tmp->dev_addr, 6);
-
+		dev_put(tmp);
 		printk("%s: ESI %pM\n", card->name, card->atmdev->esi);
 	}
 	/*
diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 40cc0cf2..e6939e1 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -664,6 +664,13 @@ static struct dmi_system_id __initdata i8k_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro"),
 		},
 	},
+	{
+		.ident = "Dell XPS421",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "XPS L421X"),
+		},
+	},
         { }
 };
 
diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index 7ab4b1d..2bd0cd6 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -31,11 +31,23 @@
 #include <linux/ptrace.h>
 #include <linux/atomic.h>
 
-#include <asm/unaligned.h>
-
 #include <linux/cn_proc.h>
 
-#define CN_PROC_MSG_SIZE (sizeof(struct cn_msg) + sizeof(struct proc_event))
+/*
+ * Size of a cn_msg followed by a proc_event structure.  Since the
+ * sizeof struct cn_msg is a multiple of 4 bytes, but not 8 bytes, we
+ * add one 4-byte word to the size here, and then start the actual
+ * cn_msg structure 4 bytes into the stack buffer.  The result is that
+ * the immediately following proc_event structure is aligned to 8 bytes.
+ */
+#define CN_PROC_MSG_SIZE (sizeof(struct cn_msg) + sizeof(struct proc_event) + 4)
+
+/* See comment above; we test our assumption about sizeof struct cn_msg here. */
+static inline struct cn_msg *buffer_to_cn_msg(__u8 *buffer)
+{
+	BUILD_BUG_ON(sizeof(struct cn_msg) != 20);
+	return (struct cn_msg *)(buffer + 4);
+}
 
 static atomic_t proc_event_num_listeners = ATOMIC_INIT(0);
 static struct cb_id cn_proc_event_id = { CN_IDX_PROC, CN_VAL_PROC };
@@ -55,19 +67,19 @@ void proc_fork_connector(struct task_struct *task)
 {
 	struct cn_msg *msg;
 	struct proc_event *ev;
-	__u8 buffer[CN_PROC_MSG_SIZE];
+	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
 	struct timespec ts;
 	struct task_struct *parent;
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
 
-	msg = (struct cn_msg*)buffer;
+	msg = buffer_to_cn_msg(buffer);
 	ev = (struct proc_event*)msg->data;
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
+	ev->timestamp_ns = timespec_to_ns(&ts);
 	ev->what = PROC_EVENT_FORK;
 	rcu_read_lock();
 	parent = rcu_dereference(task->real_parent);
@@ -90,17 +102,17 @@ void proc_exec_connector(struct task_struct *task)
 	struct cn_msg *msg;
 	struct proc_event *ev;
 	struct timespec ts;
-	__u8 buffer[CN_PROC_MSG_SIZE];
+	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
 
-	msg = (struct cn_msg*)buffer;
+	msg = buffer_to_cn_msg(buffer);
 	ev = (struct proc_event*)msg->data;
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
+	ev->timestamp_ns = timespec_to_ns(&ts);
 	ev->what = PROC_EVENT_EXEC;
 	ev->event_data.exec.process_pid = task->pid;
 	ev->event_data.exec.process_tgid = task->tgid;
@@ -116,14 +128,14 @@ void proc_id_connector(struct task_struct *task, int which_id)
 {
 	struct cn_msg *msg;
 	struct proc_event *ev;
-	__u8 buffer[CN_PROC_MSG_SIZE];
+	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
 	struct timespec ts;
 	const struct cred *cred;
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
 
-	msg = (struct cn_msg*)buffer;
+	msg = buffer_to_cn_msg(buffer);
 	ev = (struct proc_event*)msg->data;
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	ev->what = which_id;
@@ -144,7 +156,7 @@ void proc_id_connector(struct task_struct *task, int which_id)
 	rcu_read_unlock();
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
+	ev->timestamp_ns = timespec_to_ns(&ts);
 
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
@@ -158,17 +170,17 @@ void proc_sid_connector(struct task_struct *task)
 	struct cn_msg *msg;
 	struct proc_event *ev;
 	struct timespec ts;
-	__u8 buffer[CN_PROC_MSG_SIZE];
+	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
 
-	msg = (struct cn_msg *)buffer;
+	msg = buffer_to_cn_msg(buffer);
 	ev = (struct proc_event *)msg->data;
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
+	ev->timestamp_ns = timespec_to_ns(&ts);
 	ev->what = PROC_EVENT_SID;
 	ev->event_data.sid.process_pid = task->pid;
 	ev->event_data.sid.process_tgid = task->tgid;
@@ -185,17 +197,17 @@ void proc_ptrace_connector(struct task_struct *task, int ptrace_id)
 	struct cn_msg *msg;
 	struct proc_event *ev;
 	struct timespec ts;
-	__u8 buffer[CN_PROC_MSG_SIZE];
+	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
 
-	msg = (struct cn_msg *)buffer;
+	msg = buffer_to_cn_msg(buffer);
 	ev = (struct proc_event *)msg->data;
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
+	ev->timestamp_ns = timespec_to_ns(&ts);
 	ev->what = PROC_EVENT_PTRACE;
 	ev->event_data.ptrace.process_pid  = task->pid;
 	ev->event_data.ptrace.process_tgid = task->tgid;
@@ -220,17 +232,17 @@ void proc_comm_connector(struct task_struct *task)
 	struct cn_msg *msg;
 	struct proc_event *ev;
 	struct timespec ts;
-	__u8 buffer[CN_PROC_MSG_SIZE];
+	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
 
-	msg = (struct cn_msg *)buffer;
+	msg = buffer_to_cn_msg(buffer);
 	ev = (struct proc_event *)msg->data;
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
+	ev->timestamp_ns = timespec_to_ns(&ts);
 	ev->what = PROC_EVENT_COMM;
 	ev->event_data.comm.process_pid  = task->pid;
 	ev->event_data.comm.process_tgid = task->tgid;
@@ -247,18 +259,18 @@ void proc_exit_connector(struct task_struct *task)
 {
 	struct cn_msg *msg;
 	struct proc_event *ev;
-	__u8 buffer[CN_PROC_MSG_SIZE];
+	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
 	struct timespec ts;
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
 
-	msg = (struct cn_msg*)buffer;
+	msg = buffer_to_cn_msg(buffer);
 	ev = (struct proc_event*)msg->data;
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
+	ev->timestamp_ns = timespec_to_ns(&ts);
 	ev->what = PROC_EVENT_EXIT;
 	ev->event_data.exit.process_pid = task->pid;
 	ev->event_data.exit.process_tgid = task->tgid;
@@ -284,18 +296,18 @@ static void cn_proc_ack(int err, int rcvd_seq, int rcvd_ack)
 {
 	struct cn_msg *msg;
 	struct proc_event *ev;
-	__u8 buffer[CN_PROC_MSG_SIZE];
+	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
 	struct timespec ts;
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
 
-	msg = (struct cn_msg*)buffer;
+	msg = buffer_to_cn_msg(buffer);
 	ev = (struct proc_event*)msg->data;
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	msg->seq = rcvd_seq;
 	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
+	ev->timestamp_ns = timespec_to_ns(&ts);
 	ev->cpu = -1;
 	ev->what = PROC_EVENT_NONE;
 	ev->event_data.ack.err = err;
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index d90519c..31bb083 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -420,7 +420,7 @@ void cpuidle_unregister_device(struct cpuidle_device *dev)
 	struct device *cpu_dev = get_cpu_device((unsigned long)dev->cpu);
 	struct cpuidle_driver *cpuidle_driver = cpuidle_get_driver();
 
-	if (dev->registered == 0)
+	if (!dev || dev->registered == 0)
 		return;
 
 	cpuidle_pause_and_lock();
diff --git a/drivers/gpio/gpio-mpc8xxx.c b/drivers/gpio/gpio-mpc8xxx.c
index 5a1817e..c81b8da 100644
--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -69,10 +69,14 @@ static int mpc8572_gpio_get(struct gpio_chip *gc, unsigned int gpio)
 	u32 val;
 	struct of_mm_gpio_chip *mm = to_of_mm_gpio_chip(gc);
 	struct mpc8xxx_gpio_chip *mpc8xxx_gc = to_mpc8xxx_gpio_chip(mm);
+	u32 out_mask, out_shadow;
 
-	val = in_be32(mm->regs + GPIO_DAT) & ~in_be32(mm->regs + GPIO_DIR);
+	out_mask = in_be32(mm->regs + GPIO_DIR);
 
-	return (val | mpc8xxx_gc->data) & mpc8xxx_gpio2mask(gpio);
+	val = in_be32(mm->regs + GPIO_DAT) & ~out_mask;
+	out_shadow = mpc8xxx_gc->data & out_mask;
+
+	return (val | out_shadow) & mpc8xxx_gpio2mask(gpio);
 }
 
 static int mpc8xxx_gpio_get(struct gpio_chip *gc, unsigned int gpio)
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index 9987345..b7be000 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -2325,8 +2325,15 @@ static int si_mc_init(struct radeon_device *rdev)
 	rdev->mc.aper_base = pci_resource_start(rdev->pdev, 0);
 	rdev->mc.aper_size = pci_resource_len(rdev->pdev, 0);
 	/* size in MB on si */
-	rdev->mc.mc_vram_size = RREG32(CONFIG_MEMSIZE) * 1024ULL * 1024ULL;
-	rdev->mc.real_vram_size = RREG32(CONFIG_MEMSIZE) * 1024ULL * 1024ULL;
+	tmp = RREG32(CONFIG_MEMSIZE);
+	/* some boards may have garbage in the upper 16 bits */
+	if (tmp & 0xffff0000) {
+		DRM_INFO("Probable bad vram size: 0x%08x\n", tmp);
+		if (tmp & 0xffff)
+			tmp &= 0xffff;
+	}
+	rdev->mc.mc_vram_size = tmp * 1024ULL * 1024ULL;
+	rdev->mc.real_vram_size = rdev->mc.mc_vram_size;
 	rdev->mc.visible_vram_size = rdev->mc.aper_size;
 	si_vram_gtt_location(rdev, &rdev->mc);
 	radeon_update_bandwidth_info(rdev);
diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 3fda8c8..78935b8 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -381,6 +381,7 @@ config HID_MULTITOUCH
 	  - Pixcir dual touch panels
 	  - Quanta panels
 	  - eGalax dual-touch panels, including the Joojoo and Wetab tablets
+	  - SiS multitouch panels
 	  - Stantum multitouch panels
 	  - Touch International Panels
 	  - Unitec Panels
diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 585344b..5a7087e 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -48,6 +48,12 @@ module_param(iso_layout, uint, 0644);
 MODULE_PARM_DESC(iso_layout, "Enable/Disable hardcoded ISO-layout of the keyboard. "
 		"(0 = disabled, [1] = enabled)");
 
+static unsigned int swap_opt_cmd = 0;
+module_param(swap_opt_cmd, uint, 0644);
+MODULE_PARM_DESC(swap_opt_cmd, "Swap the Option (\"Alt\") and Command (\"Flag\") keys. "
+		"(For people who want to keep Windows PC keyboard muscle memory. "
+		"[0] = as-is, Mac layout. 1 = swapped, Windows layout.)");
+
 struct apple_sc {
 	unsigned long quirks;
 	unsigned int fn_on;
@@ -152,6 +158,14 @@ static const struct apple_key_translation apple_iso_keyboard[] = {
 	{ }
 };
 
+static const struct apple_key_translation swapped_option_cmd_keys[] = {
+	{ KEY_LEFTALT,	KEY_LEFTMETA },
+	{ KEY_LEFTMETA,	KEY_LEFTALT },
+	{ KEY_RIGHTALT,	KEY_RIGHTMETA },
+	{ KEY_RIGHTMETA,KEY_RIGHTALT },
+	{ }
+};
+
 static const struct apple_key_translation *apple_find_translation(
 		const struct apple_key_translation *table, u16 from)
 {
@@ -244,6 +258,14 @@ static int hidinput_apple_event(struct hid_device *hid, struct input_dev *input,
 		}
 	}
 
+	if (swap_opt_cmd) {
+		trans = apple_find_translation(swapped_option_cmd_keys, usage->code);
+		if (trans) {
+			input_event(input, usage->type, trans->to, value);
+			return 1;
+		}
+	}
+
 	return 0;
 }
 
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index adca1b0..509d119 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1709,6 +1709,8 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_PS1000) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_IR_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_WIRELESS_KBD_MOUSE) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SIS2_TOUCH, USB_DEVICE_ID_SIS9200_TOUCH) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SIS2_TOUCH, USB_DEVICE_ID_SIS817_TOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SKYCABLE, USB_DEVICE_ID_SKYCABLE_WIRELESS_PRESENTER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS3_CONTROLLER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_NAVIGATION_CONTROLLER) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 16641fd..84f9695 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -686,6 +686,13 @@
 #define USB_VENDOR_ID_SIGMA_MICRO	0x1c4f
 #define USB_DEVICE_ID_SIGMA_MICRO_KEYBOARD	0x0002
 
+#define USB_VENDOR_ID_SIGMATEL		0x066F
+#define USB_DEVICE_ID_SIGMATEL_STMP3780	0x3780
+
+#define USB_VENDOR_ID_SIS2_TOUCH	0x0457
+#define USB_DEVICE_ID_SIS9200_TOUCH	0x9200
+#define USB_DEVICE_ID_SIS817_TOUCH	0x0817
+
 #define USB_VENDOR_ID_SKYCABLE			0x1223
 #define	USB_DEVICE_ID_SKYCABLE_WIRELESS_PRESENTER	0x3F07
 
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index fa3c904..e3c3e52 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1004,6 +1004,14 @@ static const struct hid_device_id mt_devices[] = {
 		MT_USB_DEVICE(USB_VENDOR_ID_QUANTA,
 			USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH_3008) },
 
+	/* SiS panels */
+	{ .driver_data = MT_CLS_DEFAULT,
+		HID_USB_DEVICE(USB_VENDOR_ID_SIS2_TOUCH,
+		USB_DEVICE_ID_SIS9200_TOUCH) },
+	{ .driver_data = MT_CLS_DEFAULT,
+		HID_USB_DEVICE(USB_VENDOR_ID_SIS2_TOUCH,
+		USB_DEVICE_ID_SIS817_TOUCH) },
+
 	/* Stantum panels */
 	{ .driver_data = MT_CLS_CONFIDENCE,
 		MT_USB_DEVICE(USB_VENDOR_ID_STANTUM,
diff --git a/drivers/hid/hid-roccat-kovaplus.c b/drivers/hid/hid-roccat-kovaplus.c
index 112d934..1973cff 100644
--- a/drivers/hid/hid-roccat-kovaplus.c
+++ b/drivers/hid/hid-roccat-kovaplus.c
@@ -623,9 +623,13 @@ static void kovaplus_keep_values_up_to_date(struct kovaplus_device *kovaplus,
 		break;
 	case KOVAPLUS_MOUSE_REPORT_BUTTON_TYPE_CPI:
 		kovaplus->actual_cpi = kovaplus_convert_event_cpi(button_report->data1);
+		break;
 	case KOVAPLUS_MOUSE_REPORT_BUTTON_TYPE_SENSITIVITY:
 		kovaplus->actual_x_sensitivity = button_report->data1;
 		kovaplus->actual_y_sensitivity = button_report->data2;
+		break;
+	default:
+		break;
 	}
 }
 
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 4c37560..d577fa8 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -82,6 +82,9 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH_3008, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_REALTEK, USB_DEVICE_ID_REALTEK_READER, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_SENNHEISER, USB_DEVICE_ID_SENNHEISER_BTD500USB, HID_QUIRK_NOGET },
+	{ USB_VENDOR_ID_SIGMATEL, USB_DEVICE_ID_SIGMATEL_STMP3780, HID_QUIRK_NOGET },
+	{ USB_VENDOR_ID_SIS2_TOUCH, USB_DEVICE_ID_SIS9200_TOUCH, HID_QUIRK_NOGET },
+	{ USB_VENDOR_ID_SIS2_TOUCH, USB_DEVICE_ID_SIS817_TOUCH, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_SUN, USB_DEVICE_ID_RARITAN_KVM_DONGLE, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_SYMBOL, USB_DEVICE_ID_SYMBOL_SCANNER_1, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_SYMBOL, USB_DEVICE_ID_SYMBOL_SCANNER_2, HID_QUIRK_NOGET },
diff --git a/drivers/hwmon/lm78.c b/drivers/hwmon/lm78.c
index f6bc414..8d6a133 100644
--- a/drivers/hwmon/lm78.c
+++ b/drivers/hwmon/lm78.c
@@ -94,6 +94,8 @@ static inline u8 FAN_TO_REG(long rpm, int div)
 {
 	if (rpm <= 0)
 		return 255;
+	if (rpm > 1350000)
+		return 1;
 	return SENSORS_LIMIT((1350000 + rpm * div / 2) / (rpm * div), 1, 254);
 }
 
diff --git a/drivers/hwmon/sis5595.c b/drivers/hwmon/sis5595.c
index 6c4d8eb..098489c 100644
--- a/drivers/hwmon/sis5595.c
+++ b/drivers/hwmon/sis5595.c
@@ -141,6 +141,8 @@ static inline u8 FAN_TO_REG(long rpm, int div)
 {
 	if (rpm <= 0)
 		return 255;
+	if (rpm > 1350000)
+		return 1;
 	return SENSORS_LIMIT((1350000 + rpm * div / 2) / (rpm * div), 1, 254);
 }
 
diff --git a/drivers/hwmon/vt8231.c b/drivers/hwmon/vt8231.c
index 386a845..0a287e0 100644
--- a/drivers/hwmon/vt8231.c
+++ b/drivers/hwmon/vt8231.c
@@ -145,7 +145,7 @@ static const u8 regtempmin[] = { 0x3a, 0x3e, 0x2c, 0x2e, 0x30, 0x32 };
  */
 static inline u8 FAN_TO_REG(long rpm, int div)
 {
-	if (rpm == 0)
+	if (rpm <= 0 || rpm > 1310720)
 		return 0;
 	return SENSORS_LIMIT(1310720 / (rpm * div), 1, 255);
 }
diff --git a/drivers/hwmon/w83l786ng.c b/drivers/hwmon/w83l786ng.c
index 5850b77..284d469 100644
--- a/drivers/hwmon/w83l786ng.c
+++ b/drivers/hwmon/w83l786ng.c
@@ -481,9 +481,11 @@ store_pwm(struct device *dev, struct device_attribute *attr,
 	if (err)
 		return err;
 	val = SENSORS_LIMIT(val, 0, 255);
+	val = DIV_ROUND_CLOSEST(val, 0x11);
 
 	mutex_lock(&data->update_lock);
-	data->pwm[nr] = val;
+	data->pwm[nr] = val * 0x11;
+	val |= w83l786ng_read_value(client, W83L786NG_REG_PWM[nr]) & 0xf0;
 	w83l786ng_write_value(client, W83L786NG_REG_PWM[nr], val);
 	mutex_unlock(&data->update_lock);
 	return count;
@@ -510,7 +512,7 @@ store_pwm_enable(struct device *dev, struct device_attribute *attr,
 	mutex_lock(&data->update_lock);
 	reg = w83l786ng_read_value(client, W83L786NG_REG_FAN_CFG);
 	data->pwm_enable[nr] = val;
-	reg &= ~(0x02 << W83L786NG_PWM_ENABLE_SHIFT[nr]);
+	reg &= ~(0x03 << W83L786NG_PWM_ENABLE_SHIFT[nr]);
 	reg |= (val - 1) << W83L786NG_PWM_ENABLE_SHIFT[nr];
 	w83l786ng_write_value(client, W83L786NG_REG_FAN_CFG, reg);
 	mutex_unlock(&data->update_lock);
@@ -781,9 +783,10 @@ static struct w83l786ng_data *w83l786ng_update_device(struct device *dev)
 			    ((pwmcfg >> W83L786NG_PWM_MODE_SHIFT[i]) & 1)
 			    ? 0 : 1;
 			data->pwm_enable[i] =
-			    ((pwmcfg >> W83L786NG_PWM_ENABLE_SHIFT[i]) & 2) + 1;
-			data->pwm[i] = w83l786ng_read_value(client,
-			    W83L786NG_REG_PWM[i]);
+			    ((pwmcfg >> W83L786NG_PWM_ENABLE_SHIFT[i]) & 3) + 1;
+			data->pwm[i] =
+			    (w83l786ng_read_value(client, W83L786NG_REG_PWM[i])
+			     & 0x0f) * 0x11;
 		}
 
 
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index f2f2058..d63973d 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -105,6 +105,7 @@ config I2C_I801
 	    Panther Point (PCH)
 	    Lynx Point (PCH)
 	    Lynx Point-LP (PCH)
+	    Avoton (SOC)
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-i801.
diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index d88ec81..d63e130 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -53,6 +53,7 @@
   Panther Point (PCH)   0x1e22     32     hard     yes     yes     yes
   Lynx Point (PCH)      0x8c22     32     hard     yes     yes     yes
   Lynx Point-LP (PCH)   0x9c22     32     hard     yes     yes     yes
+  Avoton (SOC)          0x1f3c     32     hard     yes     yes     yes
 
   Features supported by this driver:
   Software PEC                     no
@@ -145,6 +146,7 @@
 #define PCI_DEVICE_ID_INTEL_PATSBURG_SMBUS_IDF1	0x1d71
 #define PCI_DEVICE_ID_INTEL_PATSBURG_SMBUS_IDF2	0x1d72
 #define PCI_DEVICE_ID_INTEL_PANTHERPOINT_SMBUS	0x1e22
+#define PCI_DEVICE_ID_INTEL_AVOTON_SMBUS	0x1f3c
 #define PCI_DEVICE_ID_INTEL_DH89XXCC_SMBUS	0x2330
 #define PCI_DEVICE_ID_INTEL_5_3400_SERIES_SMBUS	0x3b30
 #define PCI_DEVICE_ID_INTEL_LYNXPOINT_SMBUS	0x8c22
@@ -639,6 +641,7 @@ static DEFINE_PCI_DEVICE_TABLE(i801_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_PANTHERPOINT_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_LYNXPOINT_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_SMBUS) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_AVOTON_SMBUS) },
 	{ 0, }
 };
 
diff --git a/drivers/input/Kconfig b/drivers/input/Kconfig
index 55f7e57..98b6add 100644
--- a/drivers/input/Kconfig
+++ b/drivers/input/Kconfig
@@ -80,7 +80,7 @@ config INPUT_MATRIXKMAP
 comment "Userland interfaces"
 
 config INPUT_MOUSEDEV
-	tristate "Mouse interface" if EXPERT
+	tristate "Mouse interface"
 	default y
 	help
 	  Say Y here if you want your mouse to be accessible as char devices
diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index c0e11ecc..95f5bd3 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -2,7 +2,7 @@
 # Input core configuration
 #
 menuconfig INPUT_KEYBOARD
-	bool "Keyboards" if EXPERT || !X86
+	bool "Keyboards"
 	default y
 	help
 	  Say Y here, and a list of supported keyboards will be displayed.
@@ -67,7 +67,7 @@ config KEYBOARD_ATARI
 	  module will be called atakbd.
 
 config KEYBOARD_ATKBD
-	tristate "AT keyboard" if EXPERT || !X86
+	tristate "AT keyboard"
 	default y
 	select SERIO
 	select SERIO_LIBPS2
diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
index 55f2c22..93d4182 100644
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -2,7 +2,7 @@
 # Input core configuration
 #
 config SERIO
-	tristate "Serial I/O support" if EXPERT || !X86
+	tristate "Serial I/O support"
 	default y
 	help
 	  Say Yes here if you have any input device that uses serial I/O to
@@ -19,7 +19,7 @@ config SERIO
 if SERIO
 
 config SERIO_I8042
-	tristate "i8042 PC Keyboard controller" if EXPERT || !X86
+	tristate "i8042 PC Keyboard controller"
 	default y
 	depends on !PARISC && (!ARM || ARCH_SHARK || FOOTBRIDGE_HOST) && \
 		   (!SUPERH || SH_CAYMAN) && !M68K && !BLACKFIN
@@ -168,7 +168,7 @@ config SERIO_MACEPS2
 	  module will be called maceps2.
 
 config SERIO_LIBPS2
-	tristate "PS/2 driver library" if EXPERT
+	tristate "PS/2 driver library"
 	depends on SERIO_I8042 || SERIO_I8042=n
 	help
 	  Say Y here if you are using a driver for device connected
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index e560f54..f3535d9 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -779,7 +779,11 @@ static struct dma_pte *pfn_to_dma_pte(struct dmar_domain *domain,
 	int offset;
 
 	BUG_ON(!domain->pgd);
-	BUG_ON(addr_width < BITS_PER_LONG && pfn >> addr_width);
+
+	if (addr_width < BITS_PER_LONG && pfn >> addr_width)
+		/* Address beyond IOMMU's addressing capabilities. */
+		return NULL;
+
 	parent = domain->pgd;
 
 	while (level > 0) {
diff --git a/drivers/isdn/isdnloop/isdnloop.c b/drivers/isdn/isdnloop/isdnloop.c
index baf2686..02125e6 100644
--- a/drivers/isdn/isdnloop/isdnloop.c
+++ b/drivers/isdn/isdnloop/isdnloop.c
@@ -1083,8 +1083,10 @@ isdnloop_start(isdnloop_card *card, isdnloop_sdef *sdefp)
 			spin_unlock_irqrestore(&card->isdnloop_lock, flags);
 			return -ENOMEM;
 		}
-		for (i = 0; i < 3; i++)
-			strcpy(card->s0num[i], sdef.num[i]);
+		for (i = 0; i < 3; i++) {
+			strlcpy(card->s0num[i], sdef.num[i],
+				sizeof(card->s0num[0]));
+		}
 		break;
 	case ISDN_PTYPE_1TR6:
 		if (isdnloop_fake(card, "DRV1.04TC-1TR6-CAPI-CNS-BASIS-29.11.95",
@@ -1097,7 +1099,7 @@ isdnloop_start(isdnloop_card *card, isdnloop_sdef *sdefp)
 			spin_unlock_irqrestore(&card->isdnloop_lock, flags);
 			return -ENOMEM;
 		}
-		strcpy(card->s0num[0], sdef.num[0]);
+		strlcpy(card->s0num[0], sdef.num[0], sizeof(card->s0num[0]));
 		card->s0num[1][0] = '\0';
 		card->s0num[2][0] = '\0';
 		break;
diff --git a/drivers/isdn/mISDN/socket.c b/drivers/isdn/mISDN/socket.c
index abe2d69..ade1bcf 100644
--- a/drivers/isdn/mISDN/socket.c
+++ b/drivers/isdn/mISDN/socket.c
@@ -117,7 +117,6 @@ mISDN_sock_recvmsg(struct kiocb *iocb, struct socket *sock,
 {
 	struct sk_buff		*skb;
 	struct sock		*sk = sock->sk;
-	struct sockaddr_mISDN	*maddr;
 
 	int		copied, err;
 
@@ -135,9 +134,9 @@ mISDN_sock_recvmsg(struct kiocb *iocb, struct socket *sock,
 	if (!skb)
 		return err;
 
-	if (msg->msg_namelen >= sizeof(struct sockaddr_mISDN)) {
-		msg->msg_namelen = sizeof(struct sockaddr_mISDN);
-		maddr = (struct sockaddr_mISDN *)msg->msg_name;
+	if (msg->msg_name) {
+		struct sockaddr_mISDN *maddr = msg->msg_name;
+
 		maddr->family = AF_ISDN;
 		maddr->dev = _pms(sk)->dev->id;
 		if ((sk->sk_protocol == ISDN_P_LAPD_TE) ||
@@ -150,11 +149,7 @@ mISDN_sock_recvmsg(struct kiocb *iocb, struct socket *sock,
 			maddr->sapi = _pms(sk)->ch.addr & 0xFF;
 			maddr->tei =  (_pms(sk)->ch.addr >> 8) & 0xFF;
 		}
-	} else {
-		if (msg->msg_namelen)
-			printk(KERN_WARNING "%s: too small namelen %d\n",
-			       __func__, msg->msg_namelen);
-		msg->msg_namelen = 0;
+		msg->msg_namelen = sizeof(*maddr);
 	}
 
 	copied = skb->len + MISDN_HEADER_LEN;
diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index e9097af..10a13e3 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1668,6 +1668,11 @@ static int __init dm_bufio_init(void)
 {
 	__u64 mem;
 
+	dm_bufio_allocated_kmem_cache = 0;
+	dm_bufio_allocated_get_free_pages = 0;
+	dm_bufio_allocated_vmalloc = 0;
+	dm_bufio_current_allocated = 0;
+
 	memset(&dm_bufio_caches, 0, sizeof dm_bufio_caches);
 	memset(&dm_bufio_cache_names, 0, sizeof dm_bufio_cache_names);
 
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 3f06df5..535c3e2 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1262,20 +1262,6 @@ static int crypt_decode_key(u8 *key, char *hex, unsigned int size)
 	return 0;
 }
 
-/*
- * Encode key into its hex representation
- */
-static void crypt_encode_key(char *hex, u8 *key, unsigned int size)
-{
-	unsigned int i;
-
-	for (i = 0; i < size; i++) {
-		sprintf(hex, "%02x", *key);
-		hex += 2;
-		key++;
-	}
-}
-
 static void crypt_free_tfms(struct crypt_config *cc, int cpu)
 {
 	struct crypt_cpu *cpu_cc = per_cpu_ptr(cc->cpu, cpu);
@@ -1741,11 +1727,11 @@ static int crypt_map(struct dm_target *ti, struct bio *bio,
 	return DM_MAPIO_SUBMITTED;
 }
 
-static int crypt_status(struct dm_target *ti, status_type_t type,
-			char *result, unsigned int maxlen)
+static void crypt_status(struct dm_target *ti, status_type_t type,
+			 char *result, unsigned int maxlen)
 {
 	struct crypt_config *cc = ti->private;
-	unsigned int sz = 0;
+	unsigned i, sz = 0;
 
 	switch (type) {
 	case STATUSTYPE_INFO:
@@ -1755,17 +1741,11 @@ static int crypt_status(struct dm_target *ti, status_type_t type,
 	case STATUSTYPE_TABLE:
 		DMEMIT("%s ", cc->cipher_string);
 
-		if (cc->key_size > 0) {
-			if ((maxlen - sz) < ((cc->key_size << 1) + 1))
-				return -ENOMEM;
-
-			crypt_encode_key(result + sz, cc->key, cc->key_size);
-			sz += cc->key_size << 1;
-		} else {
-			if (sz >= maxlen)
-				return -ENOMEM;
-			result[sz++] = '-';
-		}
+		if (cc->key_size > 0)
+			for (i = 0; i < cc->key_size; i++)
+				DMEMIT("%02x", cc->key[i]);
+		else
+			DMEMIT("-");
 
 		DMEMIT(" %llu %s %llu", (unsigned long long)cc->iv_offset,
 				cc->dev->name, (unsigned long long)cc->start);
@@ -1775,7 +1755,6 @@ static int crypt_status(struct dm_target *ti, status_type_t type,
 
 		break;
 	}
-	return 0;
 }
 
 static void crypt_postsuspend(struct dm_target *ti)
diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index 2dc22dd..fb4bf9b 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -20,6 +20,7 @@
 struct delay_c {
 	struct timer_list delay_timer;
 	struct mutex timer_lock;
+	struct workqueue_struct *kdelayd_wq;
 	struct work_struct flush_expired_bios;
 	struct list_head delayed_bios;
 	atomic_t may_delay;
@@ -45,14 +46,13 @@ struct dm_delay_info {
 
 static DEFINE_MUTEX(delayed_bios_lock);
 
-static struct workqueue_struct *kdelayd_wq;
 static struct kmem_cache *delayed_cache;
 
 static void handle_delayed_timer(unsigned long data)
 {
 	struct delay_c *dc = (struct delay_c *)data;
 
-	queue_work(kdelayd_wq, &dc->flush_expired_bios);
+	queue_work(dc->kdelayd_wq, &dc->flush_expired_bios);
 }
 
 static void queue_timeout(struct delay_c *dc, unsigned long expires)
@@ -191,6 +191,12 @@ out:
 		goto bad_dev_write;
 	}
 
+	dc->kdelayd_wq = alloc_workqueue("kdelayd", WQ_MEM_RECLAIM, 0);
+	if (!dc->kdelayd_wq) {
+		DMERR("Couldn't start kdelayd");
+		goto bad_queue;
+	}
+
 	setup_timer(&dc->delay_timer, handle_delayed_timer, (unsigned long)dc);
 
 	INIT_WORK(&dc->flush_expired_bios, flush_expired_bios);
@@ -203,6 +209,8 @@ out:
 	ti->private = dc;
 	return 0;
 
+bad_queue:
+	mempool_destroy(dc->delayed_pool);
 bad_dev_write:
 	if (dc->dev_write)
 		dm_put_device(ti, dc->dev_write);
@@ -217,7 +225,7 @@ static void delay_dtr(struct dm_target *ti)
 {
 	struct delay_c *dc = ti->private;
 
-	flush_workqueue(kdelayd_wq);
+	destroy_workqueue(dc->kdelayd_wq);
 
 	dm_put_device(ti, dc->dev_read);
 
@@ -294,8 +302,8 @@ static int delay_map(struct dm_target *ti, struct bio *bio,
 	return delay_bio(dc, dc->read_delay, bio);
 }
 
-static int delay_status(struct dm_target *ti, status_type_t type,
-			char *result, unsigned maxlen)
+static void delay_status(struct dm_target *ti, status_type_t type,
+			 char *result, unsigned maxlen)
 {
 	struct delay_c *dc = ti->private;
 	int sz = 0;
@@ -315,8 +323,6 @@ static int delay_status(struct dm_target *ti, status_type_t type,
 			       dc->write_delay);
 		break;
 	}
-
-	return 0;
 }
 
 static int delay_iterate_devices(struct dm_target *ti,
@@ -353,12 +359,6 @@ static int __init dm_delay_init(void)
 {
 	int r = -ENOMEM;
 
-	kdelayd_wq = alloc_workqueue("kdelayd", WQ_MEM_RECLAIM, 0);
-	if (!kdelayd_wq) {
-		DMERR("Couldn't start kdelayd");
-		goto bad_queue;
-	}
-
 	delayed_cache = KMEM_CACHE(dm_delay_info, 0);
 	if (!delayed_cache) {
 		DMERR("Couldn't create delayed bio cache.");
@@ -376,8 +376,6 @@ static int __init dm_delay_init(void)
 bad_register:
 	kmem_cache_destroy(delayed_cache);
 bad_memcache:
-	destroy_workqueue(kdelayd_wq);
-bad_queue:
 	return r;
 }
 
@@ -385,7 +383,6 @@ static void __exit dm_delay_exit(void)
 {
 	dm_unregister_target(&delay_target);
 	kmem_cache_destroy(delayed_cache);
-	destroy_workqueue(kdelayd_wq);
 }
 
 /* Module hooks */
diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index ac49c01..f29d665 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -332,8 +332,8 @@ static int flakey_end_io(struct dm_target *ti, struct bio *bio,
 	return error;
 }
 
-static int flakey_status(struct dm_target *ti, status_type_t type,
-			 char *result, unsigned int maxlen)
+static void flakey_status(struct dm_target *ti, status_type_t type,
+			  char *result, unsigned int maxlen)
 {
 	unsigned sz = 0;
 	struct flakey_c *fc = ti->private;
@@ -363,7 +363,6 @@ static int flakey_status(struct dm_target *ti, status_type_t type,
 
 		break;
 	}
-	return 0;
 }
 
 static int flakey_ioctl(struct dm_target *ti, unsigned int cmd, unsigned long arg)
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index f011d4b..d365365 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1066,6 +1066,7 @@ static void retrieve_status(struct dm_table *table,
 	num_targets = dm_table_get_num_targets(table);
 	for (i = 0; i < num_targets; i++) {
 		struct dm_target *ti = dm_table_get_target(table, i);
+		size_t l;
 
 		remaining = len - (outptr - outbuf);
 		if (remaining <= sizeof(struct dm_target_spec)) {
@@ -1089,15 +1090,18 @@ static void retrieve_status(struct dm_table *table,
 		}
 
 		/* Get the status/table string from the target driver */
-		if (ti->type->status) {
-			if (ti->type->status(ti, type, outptr, remaining)) {
-				param->flags |= DM_BUFFER_FULL_FLAG;
-				break;
-			}
-		} else
+		if (ti->type->status)
+			ti->type->status(ti, type, outptr, remaining);
+		else
 			outptr[0] = '\0';
 
-		outptr += strlen(outptr) + 1;
+		l = strlen(outptr) + 1;
+		if (l == remaining) {
+			param->flags |= DM_BUFFER_FULL_FLAG;
+			break;
+		}
+
+		outptr += l;
 		used = param->data_start + (outptr - outbuf);
 
 		outptr = align_ptr(outptr);
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 3639eea..5a5e9c8 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -95,8 +95,8 @@ static int linear_map(struct dm_target *ti, struct bio *bio,
 	return DM_MAPIO_REMAPPED;
 }
 
-static int linear_status(struct dm_target *ti, status_type_t type,
-			 char *result, unsigned int maxlen)
+static void linear_status(struct dm_target *ti, status_type_t type,
+			  char *result, unsigned int maxlen)
 {
 	struct linear_c *lc = (struct linear_c *) ti->private;
 
@@ -110,7 +110,6 @@ static int linear_status(struct dm_target *ti, status_type_t type,
 				(unsigned long long)lc->start);
 		break;
 	}
-	return 0;
 }
 
 static int linear_ioctl(struct dm_target *ti, unsigned int cmd,
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 93b3c2d..86a56d8 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1345,8 +1345,8 @@ static void multipath_resume(struct dm_target *ti)
  *     [priority selector-name num_ps_args [ps_args]*
  *      num_paths num_selector_args [path_dev [selector_args]* ]+ ]+
  */
-static int multipath_status(struct dm_target *ti, status_type_t type,
-			    char *result, unsigned int maxlen)
+static void multipath_status(struct dm_target *ti, status_type_t type,
+			     char *result, unsigned int maxlen)
 {
 	int sz = 0;
 	unsigned long flags;
@@ -1449,8 +1449,6 @@ static int multipath_status(struct dm_target *ti, status_type_t type,
 	}
 
 	spin_unlock_irqrestore(&m->lock, flags);
-
-	return 0;
 }
 
 static int multipath_message(struct dm_target *ti, unsigned argc, char **argv)
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 017c34d..17def2e 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1066,8 +1066,8 @@ static int raid_map(struct dm_target *ti, struct bio *bio, union map_info *map_c
 	return DM_MAPIO_SUBMITTED;
 }
 
-static int raid_status(struct dm_target *ti, status_type_t type,
-		       char *result, unsigned maxlen)
+static void raid_status(struct dm_target *ti, status_type_t type,
+			char *result, unsigned maxlen)
 {
 	struct raid_set *rs = ti->private;
 	unsigned raid_param_cnt = 1; /* at least 1 for chunksize */
@@ -1202,8 +1202,6 @@ static int raid_status(struct dm_target *ti, status_type_t type,
 				DMEMIT(" -");
 		}
 	}
-
-	return 0;
 }
 
 static int raid_iterate_devices(struct dm_target *ti, iterate_devices_callout_fn fn, void *data)
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index b58b7a3..a3cf259 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -1362,8 +1362,8 @@ static char device_status_char(struct mirror *m)
 }
 
 
-static int mirror_status(struct dm_target *ti, status_type_t type,
-			 char *result, unsigned int maxlen)
+static void mirror_status(struct dm_target *ti, status_type_t type,
+			  char *result, unsigned int maxlen)
 {
 	unsigned int m, sz = 0;
 	struct mirror_set *ms = (struct mirror_set *) ti->private;
@@ -1398,8 +1398,6 @@ static int mirror_status(struct dm_target *ti, status_type_t type,
 		if (ms->features & DM_RAID1_HANDLE_ERRORS)
 			DMEMIT(" 1 handle_errors");
 	}
-
-	return 0;
 }
 
 static int mirror_iterate_devices(struct dm_target *ti,
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 330bfd6..b092338 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -66,6 +66,18 @@ struct dm_snapshot {
 
 	atomic_t pending_exceptions_count;
 
+	/* Protected by "lock" */
+	sector_t exception_start_sequence;
+
+	/* Protected by kcopyd single-threaded callback */
+	sector_t exception_complete_sequence;
+
+	/*
+	 * A list of pending exceptions that completed out of order.
+	 * Protected by kcopyd single-threaded callback.
+	 */
+	struct list_head out_of_order_list;
+
 	mempool_t *pending_pool;
 
 	struct dm_exception_table pending;
@@ -171,6 +183,14 @@ struct dm_snap_pending_exception {
 	 */
 	int started;
 
+	/* There was copying error. */
+	int copy_error;
+
+	/* A sequence number, it is used for in-order completion. */
+	sector_t exception_sequence;
+
+	struct list_head out_of_order_entry;
+
 	/*
 	 * For writing a complete chunk, bypassing the copy.
 	 */
@@ -1090,6 +1110,9 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	s->valid = 1;
 	s->active = 0;
 	atomic_set(&s->pending_exceptions_count, 0);
+	s->exception_start_sequence = 0;
+	s->exception_complete_sequence = 0;
+	INIT_LIST_HEAD(&s->out_of_order_list);
 	init_rwsem(&s->lock);
 	INIT_LIST_HEAD(&s->list);
 	spin_lock_init(&s->pe_lock);
@@ -1448,6 +1471,19 @@ static void commit_callback(void *context, int success)
 	pending_complete(pe, success);
 }
 
+static void complete_exception(struct dm_snap_pending_exception *pe)
+{
+	struct dm_snapshot *s = pe->snap;
+
+	if (unlikely(pe->copy_error))
+		pending_complete(pe, 0);
+
+	else
+		/* Update the metadata if we are persistent */
+		s->store->type->commit_exception(s->store, &pe->e,
+						 commit_callback, pe);
+}
+
 /*
  * Called when the copy I/O has finished.  kcopyd actually runs
  * this code so don't block.
@@ -1457,13 +1493,32 @@ static void copy_callback(int read_err, unsigned long write_err, void *context)
 	struct dm_snap_pending_exception *pe = context;
 	struct dm_snapshot *s = pe->snap;
 
-	if (read_err || write_err)
-		pending_complete(pe, 0);
+	pe->copy_error = read_err || write_err;
 
-	else
-		/* Update the metadata if we are persistent */
-		s->store->type->commit_exception(s->store, &pe->e,
-						 commit_callback, pe);
+	if (pe->exception_sequence == s->exception_complete_sequence) {
+		s->exception_complete_sequence++;
+		complete_exception(pe);
+
+		while (!list_empty(&s->out_of_order_list)) {
+			pe = list_entry(s->out_of_order_list.next,
+					struct dm_snap_pending_exception, out_of_order_entry);
+			if (pe->exception_sequence != s->exception_complete_sequence)
+				break;
+			s->exception_complete_sequence++;
+			list_del(&pe->out_of_order_entry);
+			complete_exception(pe);
+		}
+	} else {
+		struct list_head *lh;
+		struct dm_snap_pending_exception *pe2;
+
+		list_for_each_prev(lh, &s->out_of_order_list) {
+			pe2 = list_entry(lh, struct dm_snap_pending_exception, out_of_order_entry);
+			if (pe2->exception_sequence < pe->exception_sequence)
+				break;
+		}
+		list_add(&pe->out_of_order_entry, lh);
+	}
 }
 
 /*
@@ -1558,6 +1613,8 @@ __find_pending_exception(struct dm_snapshot *s,
 		return NULL;
 	}
 
+	pe->exception_sequence = s->exception_start_sequence++;
+
 	dm_insert_exception(&s->pending, &pe->e);
 
 	return pe;
@@ -1845,8 +1902,8 @@ static void snapshot_merge_resume(struct dm_target *ti)
 	start_merge(s);
 }
 
-static int snapshot_status(struct dm_target *ti, status_type_t type,
-			   char *result, unsigned int maxlen)
+static void snapshot_status(struct dm_target *ti, status_type_t type,
+			    char *result, unsigned int maxlen)
 {
 	unsigned sz = 0;
 	struct dm_snapshot *snap = ti->private;
@@ -1892,8 +1949,6 @@ static int snapshot_status(struct dm_target *ti, status_type_t type,
 					  maxlen - sz);
 		break;
 	}
-
-	return 0;
 }
 
 static int snapshot_iterate_devices(struct dm_target *ti,
@@ -2148,8 +2203,8 @@ static void origin_resume(struct dm_target *ti)
 	ti->split_io = get_origin_minimum_chunksize(dev->bdev);
 }
 
-static int origin_status(struct dm_target *ti, status_type_t type, char *result,
-			 unsigned int maxlen)
+static void origin_status(struct dm_target *ti, status_type_t type, char *result,
+			  unsigned int maxlen)
 {
 	struct dm_dev *dev = ti->private;
 
@@ -2162,8 +2217,6 @@ static int origin_status(struct dm_target *ti, status_type_t type, char *result,
 		snprintf(result, maxlen, "%s", dev->name);
 		break;
 	}
-
-	return 0;
 }
 
 static int origin_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
@@ -2204,7 +2257,7 @@ static struct target_type origin_target = {
 
 static struct target_type snapshot_target = {
 	.name    = "snapshot",
-	.version = {1, 10, 0},
+	.version = {1, 10, 2},
 	.module  = THIS_MODULE,
 	.ctr     = snapshot_ctr,
 	.dtr     = snapshot_dtr,
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 35c94ff..58ffcda 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -302,8 +302,8 @@ static int stripe_map(struct dm_target *ti, struct bio *bio,
  *
  */
 
-static int stripe_status(struct dm_target *ti,
-			 status_type_t type, char *result, unsigned int maxlen)
+static void stripe_status(struct dm_target *ti,
+			  status_type_t type, char *result, unsigned int maxlen)
 {
 	struct stripe_c *sc = (struct stripe_c *) ti->private;
 	char buffer[sc->stripes + 1];
@@ -330,7 +330,6 @@ static int stripe_status(struct dm_target *ti,
 			    (unsigned long long)sc->stripe[i].physical_start);
 		break;
 	}
-	return 0;
 }
 
 static int stripe_end_io(struct dm_target *ti, struct bio *bio,
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index d509f23..43e19b7 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -215,6 +215,11 @@ int dm_table_create(struct dm_table **result, fmode_t mode,
 
 	num_targets = dm_round_up(num_targets, KEYS_PER_NODE);
 
+	if (!num_targets) {
+		kfree(t);
+		return -ENOMEM;
+	}
+
 	if (alloc_targets(t, num_targets)) {
 		kfree(t);
 		t = NULL;
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 1307ba8..7ef83d9 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2378,8 +2378,8 @@ static int pool_message(struct dm_target *ti, unsigned argc, char **argv)
  *    <transaction id> <used metadata sectors>/<total metadata sectors>
  *    <used data sectors>/<total data sectors> <held metadata root>
  */
-static int pool_status(struct dm_target *ti, status_type_t type,
-		       char *result, unsigned maxlen)
+static void pool_status(struct dm_target *ti, status_type_t type,
+			char *result, unsigned maxlen)
 {
 	int r, count;
 	unsigned sz = 0;
@@ -2396,32 +2396,41 @@ static int pool_status(struct dm_target *ti, status_type_t type,
 
 	switch (type) {
 	case STATUSTYPE_INFO:
-		r = dm_pool_get_metadata_transaction_id(pool->pmd,
-							&transaction_id);
-		if (r)
-			return r;
+		r = dm_pool_get_metadata_transaction_id(pool->pmd, &transaction_id);
+		if (r) {
+			DMERR("dm_pool_get_metadata_transaction_id returned %d", r);
+			goto err;
+		}
 
-		r = dm_pool_get_free_metadata_block_count(pool->pmd,
-							  &nr_free_blocks_metadata);
-		if (r)
-			return r;
+		r = dm_pool_get_free_metadata_block_count(pool->pmd, &nr_free_blocks_metadata);
+		if (r) {
+			DMERR("dm_pool_get_free_metadata_block_count returned %d", r);
+			goto err;
+		}
 
 		r = dm_pool_get_metadata_dev_size(pool->pmd, &nr_blocks_metadata);
-		if (r)
-			return r;
+		if (r) {
+			DMERR("dm_pool_get_metadata_dev_size returned %d", r);
+			goto err;
+		}
 
-		r = dm_pool_get_free_block_count(pool->pmd,
-						 &nr_free_blocks_data);
-		if (r)
-			return r;
+		r = dm_pool_get_free_block_count(pool->pmd, &nr_free_blocks_data);
+		if (r) {
+			DMERR("dm_pool_get_free_block_count returned %d", r);
+			goto err;
+		}
 
 		r = dm_pool_get_data_dev_size(pool->pmd, &nr_blocks_data);
-		if (r)
-			return r;
+		if (r) {
+			DMERR("dm_pool_get_data_dev_size returned %d", r);
+			goto err;
+		}
 
 		r = dm_pool_get_metadata_snap(pool->pmd, &held_root);
-		if (r)
-			return r;
+		if (r) {
+			DMERR("dm_pool_get_metadata_snap returned %d", r);
+			goto err;
+		}
 
 		DMEMIT("%llu %llu/%llu %llu/%llu ",
 		       (unsigned long long)transaction_id,
@@ -2459,8 +2468,10 @@ static int pool_status(struct dm_target *ti, status_type_t type,
 
 		break;
 	}
+	return;
 
-	return 0;
+err:
+	DMEMIT("Error");
 }
 
 static int pool_iterate_devices(struct dm_target *ti,
@@ -2712,8 +2723,8 @@ static void thin_postsuspend(struct dm_target *ti)
 /*
  * <nr mapped sectors> <highest mapped sector>
  */
-static int thin_status(struct dm_target *ti, status_type_t type,
-		       char *result, unsigned maxlen)
+static void thin_status(struct dm_target *ti, status_type_t type,
+			char *result, unsigned maxlen)
 {
 	int r;
 	ssize_t sz = 0;
@@ -2727,12 +2738,16 @@ static int thin_status(struct dm_target *ti, status_type_t type,
 		switch (type) {
 		case STATUSTYPE_INFO:
 			r = dm_thin_get_mapped_count(tc->td, &mapped);
-			if (r)
-				return r;
+			if (r) {
+				DMERR("dm_thin_get_mapped_count returned %d", r);
+				goto err;
+			}
 
 			r = dm_thin_get_highest_mapped_block(tc->td, &highest);
-			if (r < 0)
-				return r;
+			if (r < 0) {
+				DMERR("dm_thin_get_highest_mapped_block returned %d", r);
+				goto err;
+			}
 
 			DMEMIT("%llu ", mapped * tc->pool->sectors_per_block);
 			if (r)
@@ -2752,7 +2767,10 @@ static int thin_status(struct dm_target *ti, status_type_t type,
 		}
 	}
 
-	return 0;
+	return;
+
+err:
+	DMEMIT("Error");
 }
 
 static int thin_iterate_devices(struct dm_target *ti,
diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
index 157007d..ca36692 100644
--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity.c
@@ -543,8 +543,8 @@ static int verity_map(struct dm_target *ti, struct bio *bio,
 /*
  * Status: V (valid) or C (corruption found)
  */
-static int verity_status(struct dm_target *ti, status_type_t type,
-			 char *result, unsigned maxlen)
+static void verity_status(struct dm_target *ti, status_type_t type,
+			  char *result, unsigned maxlen)
 {
 	struct dm_verity *v = ti->private;
 	unsigned sz = 0;
@@ -575,8 +575,6 @@ static int verity_status(struct dm_target *ti, status_type_t type,
 				DMEMIT("%02x", v->salt[x]);
 		break;
 	}
-
-	return 0;
 }
 
 static int verity_ioctl(struct dm_target *ti, unsigned cmd,
diff --git a/drivers/media/video/saa7164/saa7164-core.c b/drivers/media/video/saa7164/saa7164-core.c
index 3b7d7b4..8f3c47e 100644
--- a/drivers/media/video/saa7164/saa7164-core.c
+++ b/drivers/media/video/saa7164/saa7164-core.c
@@ -1386,9 +1386,11 @@ static int __devinit saa7164_initdev(struct pci_dev *pci_dev,
 		if (fw_debug) {
 			dev->kthread = kthread_run(saa7164_thread_function, dev,
 				"saa7164 debug");
-			if (!dev->kthread)
+			if (IS_ERR(dev->kthread)) {
+				dev->kthread = NULL;
 				printk(KERN_ERR "%s() Failed to create "
 					"debug kernel thread\n", __func__);
+			}
 		}
 
 	} /* != BOARD_UNKNOWN */
diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 00e5fcac8..cbee842 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -198,6 +198,13 @@ static void enclosure_remove_links(struct enclosure_component *cdev)
 {
 	char name[ENCLOSURE_NAME_SIZE];
 
+	/*
+	 * In odd circumstances, like multipath devices, something else may
+	 * already have removed the links, so check for this condition first.
+	 */
+	if (!cdev->dev->kobj.sd)
+		return;
+
 	enclosure_link_name(cdev, name);
 	sysfs_remove_link(&cdev->dev->kobj, name);
 	sysfs_remove_link(&cdev->cdev.kobj, "device");
diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 7b66292..4c0ce56 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -690,7 +690,7 @@ static int mmc_blk_cmd_error(struct request *req, const char *name, int error,
  * Otherwise we don't understand what happened, so abort.
  */
 static int mmc_blk_cmd_recovery(struct mmc_card *card, struct request *req,
-	struct mmc_blk_request *brq, int *ecc_err)
+	struct mmc_blk_request *brq, int *ecc_err, int *gen_err)
 {
 	bool prev_cmd_status_valid = true;
 	u32 status, stop_status = 0;
@@ -728,6 +728,16 @@ static int mmc_blk_cmd_recovery(struct mmc_card *card, struct request *req,
 	    (brq->cmd.resp[0] & R1_CARD_ECC_FAILED))
 		*ecc_err = 1;
 
+	/* Flag General errors */
+	if (!mmc_host_is_spi(card->host) && rq_data_dir(req) != READ)
+		if ((status & R1_ERROR) ||
+			(brq->stop.resp[0] & R1_ERROR)) {
+			pr_err("%s: %s: general error sending stop or status command, stop cmd response %#x, card status %#x\n",
+			       req->rq_disk->disk_name, __func__,
+			       brq->stop.resp[0], status);
+			*gen_err = 1;
+		}
+
 	/*
 	 * Check the current card state.  If it is in some data transfer
 	 * mode, tell it to stop (and hopefully transition back to TRAN.)
@@ -747,6 +757,13 @@ static int mmc_blk_cmd_recovery(struct mmc_card *card, struct request *req,
 			return ERR_ABORT;
 		if (stop_status & R1_CARD_ECC_FAILED)
 			*ecc_err = 1;
+		if (!mmc_host_is_spi(card->host) && rq_data_dir(req) != READ)
+			if (stop_status & R1_ERROR) {
+				pr_err("%s: %s: general error sending stop command, stop cmd response %#x\n",
+				       req->rq_disk->disk_name, __func__,
+				       stop_status);
+				*gen_err = 1;
+			}
 	}
 
 	/* Check for set block count errors */
@@ -996,7 +1013,7 @@ static int mmc_blk_err_check(struct mmc_card *card,
 						    mmc_active);
 	struct mmc_blk_request *brq = &mq_mrq->brq;
 	struct request *req = mq_mrq->req;
-	int ecc_err = 0;
+	int ecc_err = 0, gen_err = 0;
 
 	/*
 	 * sbc.error indicates a problem with the set block count
@@ -1010,7 +1027,7 @@ static int mmc_blk_err_check(struct mmc_card *card,
 	 */
 	if (brq->sbc.error || brq->cmd.error || brq->stop.error ||
 	    brq->data.error) {
-		switch (mmc_blk_cmd_recovery(card, req, brq, &ecc_err)) {
+		switch (mmc_blk_cmd_recovery(card, req, brq, &ecc_err, &gen_err)) {
 		case ERR_RETRY:
 			return MMC_BLK_RETRY;
 		case ERR_ABORT:
@@ -1040,6 +1057,15 @@ static int mmc_blk_err_check(struct mmc_card *card,
 	 */
 	if (!mmc_host_is_spi(card->host) && rq_data_dir(req) != READ) {
 		u32 status;
+
+		/* Check stop command response */
+		if (brq->stop.resp[0] & R1_ERROR) {
+			pr_err("%s: %s: general error sending stop command, stop cmd response %#x\n",
+			       req->rq_disk->disk_name, __func__,
+			       brq->stop.resp[0]);
+			gen_err = 1;
+		}
+
 		do {
 			int err = get_card_status(card, &status, 5);
 			if (err) {
@@ -1047,6 +1073,14 @@ static int mmc_blk_err_check(struct mmc_card *card,
 				       req->rq_disk->disk_name, err);
 				return MMC_BLK_CMD_ERR;
 			}
+
+			if (status & R1_ERROR) {
+				pr_err("%s: %s: general error sending status command, card status %#x\n",
+				       req->rq_disk->disk_name, __func__,
+				       status);
+				gen_err = 1;
+			}
+
 			/*
 			 * Some cards mishandle the status bits,
 			 * so make sure to check both the busy
@@ -1056,6 +1090,13 @@ static int mmc_blk_err_check(struct mmc_card *card,
 			 (R1_CURRENT_STATE(status) == R1_STATE_PRG));
 	}
 
+	/* if general error occurs, retry the write operation. */
+	if (gen_err) {
+		pr_warning("%s: retrying write for general error\n",
+				req->rq_disk->disk_name);
+		return MMC_BLK_RETRY;
+	}
+
 	if (brq->data.error) {
 		pr_err("%s: error %d transferring data, sector %u, nr %u, cmd response %#x, card status %#x\n",
 		       req->rq_disk->disk_name, brq->data.error,
diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index ed4f9e5..d5f0bc0 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -533,8 +533,9 @@ static ssize_t bonding_store_arp_interval(struct device *d,
 		goto out;
 	}
 	if (bond->params.mode == BOND_MODE_ALB ||
-	    bond->params.mode == BOND_MODE_TLB) {
-		pr_info("%s: ARP monitoring cannot be used with ALB/TLB. Only MII monitoring is supported on %s.\n",
+	    bond->params.mode == BOND_MODE_TLB ||
+	    bond->params.mode == BOND_MODE_8023AD) {
+		pr_info("%s: ARP monitoring cannot be used with ALB/TLB/802.3ad. Only MII monitoring is supported on %s.\n",
 			bond->dev->name, bond->dev->name);
 		ret = -EINVAL;
 		goto out;
@@ -692,6 +693,8 @@ static ssize_t bonding_store_downdelay(struct device *d,
 	int new_value, ret = count;
 	struct bonding *bond = to_bond(d);
 
+	if (!rtnl_trylock())
+		return restart_syscall();
 	if (!(bond->params.miimon)) {
 		pr_err("%s: Unable to set down delay as MII monitoring is disabled\n",
 		       bond->dev->name);
@@ -725,6 +728,7 @@ static ssize_t bonding_store_downdelay(struct device *d,
 	}
 
 out:
+	rtnl_unlock();
 	return ret;
 }
 static DEVICE_ATTR(downdelay, S_IRUGO | S_IWUSR,
@@ -747,6 +751,8 @@ static ssize_t bonding_store_updelay(struct device *d,
 	int new_value, ret = count;
 	struct bonding *bond = to_bond(d);
 
+	if (!rtnl_trylock())
+		return restart_syscall();
 	if (!(bond->params.miimon)) {
 		pr_err("%s: Unable to set up delay as MII monitoring is disabled\n",
 		       bond->dev->name);
@@ -780,6 +786,7 @@ static ssize_t bonding_store_updelay(struct device *d,
 	}
 
 out:
+	rtnl_unlock();
 	return ret;
 }
 static DEVICE_ATTR(updelay, S_IRUGO | S_IWUSR,
diff --git a/drivers/net/ethernet/smsc/smc91x.h b/drivers/net/ethernet/smsc/smc91x.h
index 5f53fbb..a838e71 100644
--- a/drivers/net/ethernet/smsc/smc91x.h
+++ b/drivers/net/ethernet/smsc/smc91x.h
@@ -46,7 +46,8 @@
     defined(CONFIG_MACH_LITTLETON) ||\
     defined(CONFIG_MACH_ZYLONITE2) ||\
     defined(CONFIG_ARCH_VIPER) ||\
-    defined(CONFIG_MACH_STARGATE2)
+    defined(CONFIG_MACH_STARGATE2) ||\
+    defined(CONFIG_ARCH_VERSATILE)
 
 #include <asm/mach-types.h>
 
@@ -206,23 +207,6 @@ SMC_outw(u16 val, void __iomem *ioaddr, int reg)
 #define RPC_LSA_DEFAULT		RPC_LED_TX_RX
 #define RPC_LSB_DEFAULT		RPC_LED_100_10
 
-#elif	defined(CONFIG_ARCH_VERSATILE)
-
-#define SMC_CAN_USE_8BIT	1
-#define SMC_CAN_USE_16BIT	1
-#define SMC_CAN_USE_32BIT	1
-#define SMC_NOWAIT		1
-
-#define SMC_inb(a, r)		readb((a) + (r))
-#define SMC_inw(a, r)		readw((a) + (r))
-#define SMC_inl(a, r)		readl((a) + (r))
-#define SMC_outb(v, a, r)	writeb(v, (a) + (r))
-#define SMC_outw(v, a, r)	writew(v, (a) + (r))
-#define SMC_outl(v, a, r)	writel(v, (a) + (r))
-#define SMC_insl(a, r, p, l)	readsl((a) + (r), p, l)
-#define SMC_outsl(a, r, p, l)	writesl((a) + (r), p, l)
-#define SMC_IRQ_FLAGS		(-1)	/* from resource */
-
 #elif defined(CONFIG_MN10300)
 
 /*
diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index 20f31d0..56b52af 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -979,8 +979,6 @@ static int pppoe_recvmsg(struct kiocb *iocb, struct socket *sock,
 	if (error < 0)
 		goto end;
 
-	m->msg_namelen = 0;
-
 	if (skb) {
 		total_len = min_t(size_t, total_len, skb->len);
 		error = skb_copy_datagram_iovec(skb, 0, m->msg_iov, total_len);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index ca0e7c7..ebfc014 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -443,27 +443,19 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	/* Copy MAC header from skb into command buffer */
 	memcpy(tx_cmd->hdr, hdr, hdr_len);
 
+	txq_id = info->hw_queue;
+
 	if (is_agg)
 		txq_id = priv->tid_data[sta_id][tid].agg.txq_id;
 	else if (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) {
 		/*
-		 * Send this frame after DTIM -- there's a special queue
-		 * reserved for this for contexts that support AP mode.
-		 */
-		txq_id = ctx->mcast_queue;
-
-		/*
 		 * The microcode will clear the more data
 		 * bit in the last frame it transmits.
 		 */
 		hdr->frame_control |=
 			cpu_to_le16(IEEE80211_FCTL_MOREDATA);
-	} else if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN)
-		txq_id = IWL_AUX_QUEUE;
-	else
-		txq_id = ctx->ac_to_queue[skb_get_queue_mapping(skb)];
+	}
 
-	WARN_ON_ONCE(!is_agg && txq_id != info->hw_queue);
 	WARN_ON_ONCE(is_agg &&
 		     priv->queue_to_mac80211[txq_id] != info->hw_queue);
 
diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index 9f2762c..30298e5 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -162,6 +162,8 @@ static int at91_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 
 	at91_alarm_year = tm.tm_year;
 
+	tm.tm_mon = alrm->time.tm_mon;
+	tm.tm_mday = alrm->time.tm_mday;
 	tm.tm_hour = alrm->time.tm_hour;
 	tm.tm_min = alrm->time.tm_min;
 	tm.tm_sec = alrm->time.tm_sec;
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index cb00d70..fbdc2d9 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1258,7 +1258,7 @@ static void complete_scsi_command(struct CommandList *cp)
 					"has check condition: aborted command: "
 					"ASC: 0x%x, ASCQ: 0x%x\n",
 					cp, asc, ascq);
-				cmd->result = DID_SOFT_ERROR << 16;
+				cmd->result |= DID_SOFT_ERROR << 16;
 				break;
 			}
 			/* Must be some other type of check condition */
@@ -4858,7 +4858,7 @@ reinit_after_soft_reset:
 	hpsa_hba_inquiry(h);
 	hpsa_register_scsi(h);	/* hook ourselves into SCSI subsystem */
 	start_controller_lockup_detector(h);
-	return 1;
+	return 0;
 
 clean4:
 	hpsa_free_sg_chain_blocks(h);
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index d109cc3..51ee663 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -211,7 +211,7 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
 		qc->tf.nsect = 0;
 	}
 
-	ata_tf_to_fis(&qc->tf, 1, 0, (u8*)&task->ata_task.fis);
+	ata_tf_to_fis(&qc->tf, qc->dev->link->pmp, 1, (u8 *)&task->ata_task.fis);
 	task->uldd_task = qc;
 	if (ata_is_atapi(qc->tf.protocol)) {
 		memcpy(task->ata_task.atapi_packet, qc->cdb, qc->dev->cdb_len);
diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index 76ea4a8..56a96d3 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -61,6 +61,9 @@
 #include <media/lirc_dev.h>
 #include <media/lirc.h>
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 struct IR;
 
 struct IR_rx {
@@ -942,7 +945,14 @@ static ssize_t read(struct file *filep, char *outbuf, size_t n, loff_t *ppos)
 			schedule();
 			set_current_state(TASK_INTERRUPTIBLE);
 		} else {
-			unsigned char buf[rbuf->chunk_size];
+			unsigned char buf[MAX_XFER_SIZE];
+
+			if (rbuf->chunk_size > sizeof(buf)) {
+				zilog_error("chunk_size is too big (%d)!\n",
+					    rbuf->chunk_size);
+				ret = -EINVAL;
+				break;
+			}
 			m = lirc_buffer_read(rbuf, buf);
 			if (m == rbuf->chunk_size) {
 				ret = copy_to_user((void *)outbuf+written, buf,
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 07a9f9c..dc42d09 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1542,6 +1542,8 @@ static int acm_reset_resume(struct usb_interface *intf)
 
 static const struct usb_device_id acm_ids[] = {
 	/* quirky and broken devices */
+	{ USB_DEVICE(0x17ef, 0x7000), /* Lenovo USB modem */
+	.driver_info = NO_UNION_NORMAL, },/* has no union descriptor */
 	{ USB_DEVICE(0x0870, 0x0001), /* Metricom GS Modem */
 	.driver_info = NO_UNION_NORMAL, /* has no union descriptor */
 	},
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index b79aa83..5e67525 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -4561,8 +4561,9 @@ static void hub_events(void)
 					hub->hdev->children[i - 1];
 
 				dev_dbg(hub_dev, "warm reset port %d\n", i);
-				if (!udev || !(portstatus &
-						USB_PORT_STAT_CONNECTION)) {
+				if (!udev ||
+				    !(portstatus & USB_PORT_STAT_CONNECTION) ||
+				    udev->state == USB_STATE_NOTATTACHED) {
 					status = hub_port_reset(hub, i,
 							NULL, HUB_BH_RESET_TIME,
 							true);
diff --git a/drivers/usb/dwc3/ep0.c b/drivers/usb/dwc3/ep0.c
index 127551c..3fa1d5e 100644
--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -404,6 +404,8 @@ static int dwc3_ep0_handle_feature(struct dwc3 *dwc,
 			dep = dwc3_wIndex_to_dep(dwc, wIndex);
 			if (!dep)
 				return -EINVAL;
+			if (set == 0 && (dep->flags & DWC3_EP_WEDGE))
+				break;
 			ret = __dwc3_gadget_ep_set_halt(dep, set);
 			if (ret)
 				return -EINVAL;
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 5a7755b..625a2f1 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1136,9 +1136,6 @@ int __dwc3_gadget_ep_set_halt(struct dwc3_ep *dep, int value)
 		else
 			dep->flags |= DWC3_EP_STALL;
 	} else {
-		if (dep->flags & DWC3_EP_WEDGE)
-			return 0;
-
 		ret = dwc3_send_gadget_ep_cmd(dwc, dep->number,
 			DWC3_DEPCMD_CLEARSTALL, &params);
 		if (ret)
@@ -1146,7 +1143,7 @@ int __dwc3_gadget_ep_set_halt(struct dwc3_ep *dep, int value)
 					value ? "set" : "clear",
 					dep->name);
 		else
-			dep->flags &= ~DWC3_EP_STALL;
+			dep->flags &= ~(DWC3_EP_STALL | DWC3_EP_WEDGE);
 	}
 
 	return ret;
diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 390749b..dd6777d 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -584,6 +584,7 @@ static void reset_config(struct usb_composite_dev *cdev)
 		bitmap_zero(f->endpoints, 32);
 	}
 	cdev->config = NULL;
+	cdev->delayed_status = 0;
 }
 
 static int set_config(struct usb_composite_dev *cdev,
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 6a979cd..947da9d 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2161,6 +2161,20 @@ static void ftdi_set_termios(struct tty_struct *tty,
 		termios->c_cflag |= CRTSCTS;
 	}
 
+	/*
+	 * All FTDI UART chips are limited to CS7/8. We won't pretend to
+	 * support CS5/6 and revert the CSIZE setting instead.
+	 */
+	if ((C_CSIZE(tty) != CS8) && (C_CSIZE(tty) != CS7)) {
+		dev_warn(&port->dev, "requested CSIZE setting not supported\n");
+
+		termios->c_cflag &= ~CSIZE;
+		if (old_termios)
+			termios->c_cflag |= old_termios->c_cflag & CSIZE;
+		else
+			termios->c_cflag |= CS8;
+	}
+
 	cflag = termios->c_cflag;
 
 	if (!old_termios)
@@ -2197,13 +2211,16 @@ no_skip:
 	} else {
 		urb_value |= FTDI_SIO_SET_DATA_PARITY_NONE;
 	}
-	if (cflag & CSIZE) {
-		switch (cflag & CSIZE) {
-		case CS7: urb_value |= 7; dbg("Setting CS7"); break;
-		case CS8: urb_value |= 8; dbg("Setting CS8"); break;
-		default:
-			dev_err(&port->dev, "CSIZE was set but not CS7-CS8\n");
-		}
+	switch (cflag & CSIZE) {
+	case CS7:
+		urb_value |= 7;
+		dbg("Setting CS7\n");
+		break;
+	default:
+	case CS8:
+		urb_value |= 8;
+		dbg("Setting CS8\n");
+		break;
 	}
 
 	/* This is needed by the break command since it uses the same command
diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 9b026bf..ff91eca 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -191,14 +191,7 @@ retry:
 		return result;
 	}
 
-	/* Try sending off another urb, unless in irq context (in which case
-	 * there will be no free urb). */
-	if (!in_irq())
-		goto retry;
-
-	clear_bit_unlock(USB_SERIAL_WRITE_BUSY, &port->flags);
-
-	return 0;
+	goto retry;	/* try sending off another urb */
 }
 
 /**
diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 08aad01..bc0fd5b 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -1998,25 +1998,25 @@ static void mos7840_change_port_settings(struct tty_struct *tty,
 	iflag = tty->termios->c_iflag;
 
 	/* Change the number of bits */
-	if (cflag & CSIZE) {
-		switch (cflag & CSIZE) {
-		case CS5:
-			lData = LCR_BITS_5;
-			break;
+	switch (cflag & CSIZE) {
+	case CS5:
+		lData = LCR_BITS_5;
+		break;
 
-		case CS6:
-			lData = LCR_BITS_6;
-			break;
+	case CS6:
+		lData = LCR_BITS_6;
+		break;
 
-		case CS7:
-			lData = LCR_BITS_7;
-			break;
-		default:
-		case CS8:
-			lData = LCR_BITS_8;
-			break;
-		}
+	case CS7:
+		lData = LCR_BITS_7;
+		break;
+
+	default:
+	case CS8:
+		lData = LCR_BITS_8;
+		break;
 	}
+
 	/* Change the Parity bit */
 	if (cflag & PARENB) {
 		if (cflag & PARODD) {
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index dbc6919..aac4deb 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -85,6 +85,7 @@ static void option_instat_callback(struct urb *urb);
 #define HUAWEI_PRODUCT_K4505			0x1464
 #define HUAWEI_PRODUCT_K3765			0x1465
 #define HUAWEI_PRODUCT_K4605			0x14C6
+#define HUAWEI_PRODUCT_E173S6			0x1C07
 
 #define QUANTA_VENDOR_ID			0x0408
 #define QUANTA_PRODUCT_Q101			0xEA02
@@ -586,6 +587,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0x1c23, USB_CLASS_COMM, 0x02, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E173, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t) &net_intf1_blacklist },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E173S6, 0xff, 0xff, 0xff),
+		.driver_info = (kernel_ulong_t) &net_intf1_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E1750, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t) &net_intf2_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0x1441, USB_CLASS_COMM, 0x02, 0xff) },
@@ -648,6 +651,10 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x6D) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x6E) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x6F) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x72) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x73) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x74) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x75) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x78) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x79) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x7A) },
@@ -702,6 +709,10 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x6D) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x6E) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x6F) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x72) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x73) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x74) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x75) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x78) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x79) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x7A) },
@@ -756,6 +767,10 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x6D) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x6E) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x6F) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x72) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x73) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x74) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x75) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x78) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x79) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x03, 0x7A) },
@@ -810,6 +825,10 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x6D) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x6E) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x6F) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x72) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x73) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x74) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x75) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x78) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x79) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x04, 0x7A) },
@@ -864,6 +883,10 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x6D) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x6E) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x6F) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x72) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x73) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x74) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x75) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x78) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x79) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x05, 0x7A) },
@@ -918,6 +941,10 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x6D) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x6E) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x6F) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x72) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x73) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x74) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x75) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x78) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x79) },
 	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x06, 0x7A) },
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 5150a27..dd2c8c3 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -278,24 +278,21 @@ static void pl2303_set_termios(struct tty_struct *tty,
 	dev_dbg(&port->dev, "0xa1:0x21:0:0  %d - %x %x %x %x %x %x %x\n", i,
 	    buf[0], buf[1], buf[2], buf[3], buf[4], buf[5], buf[6]);
 
-	if (cflag & CSIZE) {
-		switch (cflag & CSIZE) {
-		case CS5:
-			buf[6] = 5;
-			break;
-		case CS6:
-			buf[6] = 6;
-			break;
-		case CS7:
-			buf[6] = 7;
-			break;
-		default:
-		case CS8:
-			buf[6] = 8;
-			break;
-		}
-		dev_dbg(&port->dev, "data bits = %d\n", buf[6]);
+	switch (cflag & CSIZE) {
+	case CS5:
+		buf[6] = 5;
+		break;
+	case CS6:
+		buf[6] = 6;
+		break;
+	case CS7:
+		buf[6] = 7;
+		break;
+	default:
+	case CS8:
+		buf[6] = 8;
 	}
+	dev_dbg(&port->dev, "data bits = %d\n", buf[6]);
 
 	/* For reference buf[0]:buf[3] baud rate value */
 	/* NOTE: Only the values defined in baud_sup are supported !
diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
index 10760f2..02fde0b 100644
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -385,22 +385,20 @@ static void spcp8x5_set_termios(struct tty_struct *tty,
 	}
 
 	/* Set Data Length : 00:5bit, 01:6bit, 10:7bit, 11:8bit */
-	if (cflag & CSIZE) {
-		switch (cflag & CSIZE) {
-		case CS5:
-			buf[1] |= SET_UART_FORMAT_SIZE_5;
-			break;
-		case CS6:
-			buf[1] |= SET_UART_FORMAT_SIZE_6;
-			break;
-		case CS7:
-			buf[1] |= SET_UART_FORMAT_SIZE_7;
-			break;
-		default:
-		case CS8:
-			buf[1] |= SET_UART_FORMAT_SIZE_8;
-			break;
-		}
+	switch (cflag & CSIZE) {
+	case CS5:
+		buf[1] |= SET_UART_FORMAT_SIZE_5;
+		break;
+	case CS6:
+		buf[1] |= SET_UART_FORMAT_SIZE_6;
+		break;
+	case CS7:
+		buf[1] |= SET_UART_FORMAT_SIZE_7;
+		break;
+	default:
+	case CS8:
+		buf[1] |= SET_UART_FORMAT_SIZE_8;
+		break;
 	}
 
 	/* Set Stop bit2 : 0:1bit 1:2bit */
diff --git a/drivers/video/kyro/fbdev.c b/drivers/video/kyro/fbdev.c
index acb9370..7aa8668 100644
--- a/drivers/video/kyro/fbdev.c
+++ b/drivers/video/kyro/fbdev.c
@@ -625,15 +625,15 @@ static int kyrofb_ioctl(struct fb_info *info,
 		}
 		break;
 	case KYRO_IOCTL_UVSTRIDE:
-		if (copy_to_user(argp, &deviceInfo.ulOverlayUVStride, sizeof(unsigned long)))
+		if (copy_to_user(argp, &deviceInfo.ulOverlayUVStride, sizeof(deviceInfo.ulOverlayUVStride)))
 			return -EFAULT;
 		break;
 	case KYRO_IOCTL_STRIDE:
-		if (copy_to_user(argp, &deviceInfo.ulOverlayStride, sizeof(unsigned long)))
+		if (copy_to_user(argp, &deviceInfo.ulOverlayStride, sizeof(deviceInfo.ulOverlayStride)))
 			return -EFAULT;
 		break;
 	case KYRO_IOCTL_OVERLAY_OFFSET:
-		if (copy_to_user(argp, &deviceInfo.ulOverlayOffset, sizeof(unsigned long)))
+		if (copy_to_user(argp, &deviceInfo.ulOverlayOffset, sizeof(deviceInfo.ulOverlayOffset)))
 			return -EFAULT;
 		break;
 	}
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 8a6ecc5..93cb98e 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -867,9 +867,10 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
 		ret = m2p_add_override(mfn, pages[i], kmap_ops ?
 				       &kmap_ops[i] : NULL);
 		if (ret)
-			return ret;
+			goto out;
 	}
 
+ out:
 	if (lazy)
 		arch_leave_lazy_mmu_mode();
 
@@ -900,9 +901,10 @@ int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
 		ret = m2p_remove_override(pages[i], kmap_ops ?
 				       &kmap_ops[i] : NULL);
 		if (ret)
-			return ret;
+			goto out;
 	}
 
+ out:
 	if (lazy)
 		arch_leave_lazy_mmu_mode();
 
diff --git a/fs/nfs/blocklayout/extents.c b/fs/nfs/blocklayout/extents.c
index 1f9a603..51f9ff2 100644
--- a/fs/nfs/blocklayout/extents.c
+++ b/fs/nfs/blocklayout/extents.c
@@ -44,7 +44,7 @@
 static inline sector_t normalize(sector_t s, int base)
 {
 	sector_t tmp = s; /* Since do_div modifies its argument */
-	return s - do_div(tmp, base);
+	return s - sector_div(tmp, base);
 }
 
 static inline sector_t normalize_up(sector_t s, int base)
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index a89661e..4bb79e7 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3935,8 +3935,7 @@ nfs4_async_handle_error(struct rpc_task *task, const struct nfs_server *server,
 			dprintk("%s ERROR %d, Reset session\n", __func__,
 				task->tk_status);
 			nfs4_schedule_session_recovery(clp->cl_session, task->tk_status);
-			task->tk_status = 0;
-			return -EAGAIN;
+			goto wait_on_recovery;
 #endif /* CONFIG_NFS_V4_1 */
 		case -NFS4ERR_DELAY:
 			nfs_inc_server_stats(server, NFSIOS_DELAY);
@@ -4074,11 +4073,17 @@ static void nfs4_delegreturn_done(struct rpc_task *task, void *calldata)
 		return;
 
 	switch (task->tk_status) {
-	case -NFS4ERR_STALE_STATEID:
-	case -NFS4ERR_EXPIRED:
 	case 0:
 		renew_lease(data->res.server, data->timestamp);
 		break;
+	case -NFS4ERR_ADMIN_REVOKED:
+	case -NFS4ERR_DELEG_REVOKED:
+	case -NFS4ERR_BAD_STATEID:
+	case -NFS4ERR_OLD_STATEID:
+	case -NFS4ERR_STALE_STATEID:
+	case -NFS4ERR_EXPIRED:
+		task->tk_status = 0;
+		break;
 	default:
 		if (nfs4_async_handle_error(task, data->res.server, NULL) ==
 				-EAGAIN) {
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 3a05a41..c03f47d 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -398,7 +398,8 @@ xfs_attrlist_by_handle(
 		return -XFS_ERROR(EPERM);
 	if (copy_from_user(&al_hreq, arg, sizeof(xfs_fsop_attrlist_handlereq_t)))
 		return -XFS_ERROR(EFAULT);
-	if (al_hreq.buflen > XATTR_LIST_MAX)
+	if (al_hreq.buflen < sizeof(struct attrlist) ||
+	    al_hreq.buflen > XATTR_LIST_MAX)
 		return -XFS_ERROR(EINVAL);
 
 	/*
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index c4f2da0..2859665 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -359,7 +359,8 @@ xfs_compat_attrlist_by_handle(
 	if (copy_from_user(&al_hreq, arg,
 			   sizeof(compat_xfs_fsop_attrlist_handlereq_t)))
 		return -XFS_ERROR(EFAULT);
-	if (al_hreq.buflen > XATTR_LIST_MAX)
+	if (al_hreq.buflen < sizeof(struct attrlist) ||
+	    al_hreq.buflen > XATTR_LIST_MAX)
 		return -XFS_ERROR(EINVAL);
 
 	/*
diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 3744d2a..2cddd2b 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -36,6 +36,7 @@ static inline void scatterwalk_sg_chain(struct scatterlist *sg1, int num,
 {
 	sg_set_page(&sg1[num - 1], (void *)sg2, 0, 0);
 	sg1[num - 1].page_link &= ~0x02;
+	sg1[num - 1].page_link |= 0x01;
 }
 
 static inline struct scatterlist *scatterwalk_sg_next(struct scatterlist *sg)
@@ -43,7 +44,7 @@ static inline struct scatterlist *scatterwalk_sg_next(struct scatterlist *sg)
 	if (sg_is_last(sg))
 		return NULL;
 
-	return (++sg)->length ? sg : (void *)sg_page(sg);
+	return (++sg)->length ? sg : sg_chain_ptr(sg);
 }
 
 static inline void scatterwalk_crypto_chain(struct scatterlist *head,
diff --git a/include/linux/compiler-intel.h b/include/linux/compiler-intel.h
index d8e636e..cba9593 100644
--- a/include/linux/compiler-intel.h
+++ b/include/linux/compiler-intel.h
@@ -27,5 +27,3 @@
 #define __must_be_array(a) 0
 
 #endif
-
-#define uninitialized_var(x) x
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 98f34b8..fa09b57 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -72,8 +72,8 @@ typedef void (*dm_postsuspend_fn) (struct dm_target *ti);
 typedef int (*dm_preresume_fn) (struct dm_target *ti);
 typedef void (*dm_resume_fn) (struct dm_target *ti);
 
-typedef int (*dm_status_fn) (struct dm_target *ti, status_type_t status_type,
-			     char *result, unsigned int maxlen);
+typedef void (*dm_status_fn) (struct dm_target *ti, status_type_t status_type,
+			      char *result, unsigned int maxlen);
 
 typedef int (*dm_message_fn) (struct dm_target *ti, unsigned argc, char **argv);
 
diff --git a/include/linux/net.h b/include/linux/net.h
index dc95700..f150cdf 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -198,6 +198,14 @@ struct proto_ops {
 #endif
 	int		(*sendmsg)   (struct kiocb *iocb, struct socket *sock,
 				      struct msghdr *m, size_t total_len);
+	/* Notes for implementing recvmsg:
+	 * ===============================
+	 * msg->msg_namelen should get updated by the recvmsg handlers
+	 * iff msg_name != NULL. It is by default 0 to prevent
+	 * returning uninitialized memory to user space.  The recvfrom
+	 * handlers can assume that msg.msg_name is either NULL or has
+	 * a minimum size of sizeof(struct sockaddr_storage).
+	 */
 	int		(*recvmsg)   (struct kiocb *iocb, struct socket *sock,
 				      struct msghdr *m, size_t total_len,
 				      int flags);
diff --git a/include/linux/random.h b/include/linux/random.h
index 7e58ad2..54b1fd3 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -87,9 +87,9 @@ static inline void prandom32_seed(struct rnd_state *state, u64 seed)
 {
 	u32 i = (seed >> 32) ^ (seed << 10) ^ seed;
 
-	state->s1 = __seed(i, 1);
-	state->s2 = __seed(i, 7);
-	state->s3 = __seed(i, 15);
+	state->s1 = __seed(i, 2);
+	state->s2 = __seed(i, 8);
+	state->s3 = __seed(i, 16);
 }
 
 #ifdef CONFIG_ARCH_RANDOM
diff --git a/include/net/ip.h b/include/net/ip.h
index d34f531..9fd963f 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -446,7 +446,7 @@ extern int	compat_ip_getsockopt(struct sock *sk, int level,
 			int optname, char __user *optval, int __user *optlen);
 extern int	ip_ra_control(struct sock *sk, unsigned char on, void (*destructor)(struct sock *));
 
-extern int 	ip_recv_error(struct sock *sk, struct msghdr *msg, int len);
+extern int 	ip_recv_error(struct sock *sk, struct msghdr *msg, int len, int *addr_len);
 extern void	ip_icmp_error(struct sock *sk, struct sk_buff *skb, int err, 
 			      __be16 port, u32 info, u8 *payload);
 extern void	ip_local_error(struct sock *sk, int err, __be32 daddr, __be16 dport,
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index c11fa5d..94cb787 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -605,8 +605,10 @@ extern int			compat_ipv6_getsockopt(struct sock *sk,
 extern int			ip6_datagram_connect(struct sock *sk, 
 						     struct sockaddr *addr, int addr_len);
 
-extern int 			ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len);
-extern int 			ipv6_recv_rxpmtu(struct sock *sk, struct msghdr *msg, int len);
+extern int 			ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len,
+						int *addr_len);
+extern int 			ipv6_recv_rxpmtu(struct sock *sk, struct msghdr *msg, int len,
+						 int *addr_len);
 extern void			ipv6_icmp_error(struct sock *sk, struct sk_buff *skb, int err, __be16 port,
 						u32 info, u8 *payload);
 extern void			ipv6_local_error(struct sock *sk, int err, struct flowi6 *fl6, u32 info);
diff --git a/include/sound/memalloc.h b/include/sound/memalloc.h
index c425062..ab240bb 100644
--- a/include/sound/memalloc.h
+++ b/include/sound/memalloc.h
@@ -101,7 +101,7 @@ static inline unsigned int snd_sgbuf_aligned_pages(size_t size)
 static inline dma_addr_t snd_sgbuf_get_addr(struct snd_sg_buf *sgbuf, size_t offset)
 {
 	dma_addr_t addr = sgbuf->table[offset >> PAGE_SHIFT].addr;
-	addr &= PAGE_MASK;
+	addr &= ~((dma_addr_t)PAGE_SIZE - 1);
 	return addr + offset % PAGE_SIZE;
 }
 
diff --git a/kernel/futex.c b/kernel/futex.c
index f0ee318..e564a9a 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -285,7 +285,7 @@ again:
 		put_page(page);
 		/* serialize against __split_huge_page_splitting() */
 		local_irq_disable();
-		if (likely(__get_user_pages_fast(address, 1, 1, &page) == 1)) {
+		if (likely(__get_user_pages_fast(address, 1, !ro, &page) == 1)) {
 			page_head = compound_head(page);
 			/*
 			 * page_head is valid pointer but we must pin
diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
index cb228bf..abcd6ca 100644
--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -50,7 +50,7 @@ static void resume_irqs(bool want_early)
 		bool is_early = desc->action &&
 			desc->action->flags & IRQF_EARLY_RESUME;
 
-		if (is_early != want_early)
+		if (!is_early && want_early)
 			continue;
 
 		raw_spin_lock_irqsave(&desc->lock, flags);
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 6f79596..9c16752 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -215,6 +215,14 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 	SEQ_printf(m, "  .%-30s: %d\n", "load_tg",
 			atomic_read(&cfs_rq->tg->load_weight));
 #endif
+#ifdef CONFIG_CFS_BANDWIDTH
+	SEQ_printf(m, "  .%-30s: %d\n", "tg->cfs_bandwidth.timer_active",
+			cfs_rq->tg->cfs_bandwidth.timer_active);
+	SEQ_printf(m, "  .%-30s: %d\n", "throttled",
+			cfs_rq->throttled);
+	SEQ_printf(m, "  .%-30s: %d\n", "throttle_count",
+			cfs_rq->throttle_count);
+#endif
 
 	print_cfs_group_stats(m, cpu, cfs_rq->tg);
 #endif
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 811a254..97ecdafd 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1655,6 +1655,8 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 	cfs_rq->throttled_timestamp = rq->clock;
 	raw_spin_lock(&cfs_b->lock);
 	list_add_tail_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
+	if (!cfs_b->timer_active)
+		__start_cfs_bandwidth(cfs_b);
 	raw_spin_unlock(&cfs_b->lock);
 }
 
diff --git a/lib/random32.c b/lib/random32.c
index 938bde5..aa95712 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -92,7 +92,7 @@ void srandom32(u32 entropy)
 	 */
 	for_each_possible_cpu (i) {
 		struct rnd_state *state = &per_cpu(net_rand_state, i);
-		state->s1 = __seed(state->s1 ^ entropy, 1);
+		state->s1 = __seed(state->s1 ^ entropy, 2);
 	}
 }
 EXPORT_SYMBOL(srandom32);
@@ -109,9 +109,9 @@ static int __init random32_init(void)
 		struct rnd_state *state = &per_cpu(net_rand_state,i);
 
 #define LCG(x)	((x) * 69069)	/* super-duper LCG */
-		state->s1 = __seed(LCG(i + jiffies), 1);
-		state->s2 = __seed(LCG(state->s1), 7);
-		state->s3 = __seed(LCG(state->s2), 15);
+		state->s1 = __seed(LCG(i + jiffies), 2);
+		state->s2 = __seed(LCG(state->s1), 8);
+		state->s3 = __seed(LCG(state->s2), 16);
 
 		/* "warm it up" */
 		prandom32(state);
@@ -138,9 +138,9 @@ static int __init random32_reseed(void)
 		u32 seeds[3];
 
 		get_random_bytes(&seeds, sizeof(seeds));
-		state->s1 = __seed(seeds[0], 1);
-		state->s2 = __seed(seeds[1], 7);
-		state->s3 = __seed(seeds[2], 15);
+		state->s1 = __seed(seeds[0], 2);
+		state->s2 = __seed(seeds[1], 8);
+		state->s3 = __seed(seeds[2], 16);
 
 		/* mix it in */
 		prandom32(state);
diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 2a16765..6c3d561 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -546,6 +546,10 @@ static int p9_virtio_probe(struct virtio_device *vdev)
 	mutex_lock(&virtio_9p_lock);
 	list_add_tail(&chan->chan_list, &virtio_chan_list);
 	mutex_unlock(&virtio_9p_lock);
+
+	/* Let udev rules use the new mount_tag attribute. */
+	kobject_uevent(&(vdev->dev.kobj), KOBJ_CHANGE);
+
 	return 0;
 
 out_free_tag:
@@ -623,6 +627,7 @@ static void p9_virtio_remove(struct virtio_device *vdev)
 	list_del(&chan->chan_list);
 	mutex_unlock(&virtio_9p_lock);
 	sysfs_remove_file(&(vdev->dev.kobj), &dev_attr_mount_tag.attr);
+	kobject_uevent(&(vdev->dev.kobj), KOBJ_CHANGE);
 	kfree(chan->tag);
 	kfree(chan->vc_wq);
 	kfree(chan);
diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index 8685296..5f05768 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -1738,7 +1738,6 @@ static int atalk_recvmsg(struct kiocb *iocb, struct socket *sock, struct msghdr
 			 size_t size, int flags)
 {
 	struct sock *sk = sock->sk;
-	struct sockaddr_at *sat = (struct sockaddr_at *)msg->msg_name;
 	struct ddpehdr *ddp;
 	int copied = 0;
 	int offset = 0;
@@ -1767,14 +1766,13 @@ static int atalk_recvmsg(struct kiocb *iocb, struct socket *sock, struct msghdr
 	}
 	err = skb_copy_datagram_iovec(skb, offset, msg->msg_iov, copied);
 
-	if (!err) {
-		if (sat) {
-			sat->sat_family      = AF_APPLETALK;
-			sat->sat_port        = ddp->deh_sport;
-			sat->sat_addr.s_node = ddp->deh_snode;
-			sat->sat_addr.s_net  = ddp->deh_snet;
-		}
-		msg->msg_namelen = sizeof(*sat);
+	if (!err && msg->msg_name) {
+		struct sockaddr_at *sat = msg->msg_name;
+		sat->sat_family      = AF_APPLETALK;
+		sat->sat_port        = ddp->deh_sport;
+		sat->sat_addr.s_node = ddp->deh_snode;
+		sat->sat_addr.s_net  = ddp->deh_snet;
+		msg->msg_namelen     = sizeof(*sat);
 	}
 
 	skb_free_datagram(sk, skb);	/* Free the datagram. */
diff --git a/net/atm/common.c b/net/atm/common.c
index f0a9b7e..0c0ad93 100644
--- a/net/atm/common.c
+++ b/net/atm/common.c
@@ -520,8 +520,6 @@ int vcc_recvmsg(struct kiocb *iocb, struct socket *sock, struct msghdr *msg,
 	struct sk_buff *skb;
 	int copied, error = -EINVAL;
 
-	msg->msg_namelen = 0;
-
 	if (sock->state != SS_CONNECTED)
 		return -ENOTCONN;
 
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index d53a123..eb37327 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1641,11 +1641,11 @@ static int ax25_recvmsg(struct kiocb *iocb, struct socket *sock,
 
 	skb_copy_datagram_iovec(skb, 0, msg->msg_iov, copied);
 
-	if (msg->msg_namelen != 0) {
-		struct sockaddr_ax25 *sax = (struct sockaddr_ax25 *)msg->msg_name;
+	if (msg->msg_name) {
 		ax25_digi digi;
 		ax25_address src;
 		const unsigned char *mac = skb_mac_header(skb);
+		struct sockaddr_ax25 *sax = msg->msg_name;
 
 		memset(sax, 0, sizeof(struct full_sockaddr_ax25));
 		ax25_addr_parse(mac + 1, skb->data - mac - 1, &src, NULL,
diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
index 821e9d3..63b79e2 100644
--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -240,8 +240,6 @@ int bt_sock_recvmsg(struct kiocb *iocb, struct socket *sock,
 	if (flags & (MSG_OOB))
 		return -EOPNOTSUPP;
 
-	msg->msg_namelen = 0;
-
 	skb = skb_recv_datagram(sk, flags, noblock, &err);
 	if (!skb) {
 		if (sk->sk_shutdown & RCV_SHUTDOWN)
@@ -306,8 +304,6 @@ int bt_sock_stream_recvmsg(struct kiocb *iocb, struct socket *sock,
 	if (flags & MSG_OOB)
 		return -EOPNOTSUPP;
 
-	msg->msg_namelen = 0;
-
 	BT_DBG("sk %p size %zu", sk, size);
 
 	lock_sock(sk);
diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index bedc768..8c2cb05 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -767,8 +767,6 @@ static int hci_sock_recvmsg(struct kiocb *iocb, struct socket *sock,
 	if (!skb)
 		return err;
 
-	msg->msg_namelen = 0;
-
 	copied = skb->len;
 	if (len < copied) {
 		msg->msg_flags |= MSG_TRUNC;
diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 514bead..20bd148 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -629,7 +629,6 @@ static int rfcomm_sock_recvmsg(struct kiocb *iocb, struct socket *sock,
 
 	if (test_and_clear_bit(RFCOMM_DEFER_SETUP, &d->flags)) {
 		rfcomm_dlc_accept(d);
-		msg->msg_namelen = 0;
 		return 0;
 	}
 
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index e1144e1..ff44f5f 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -170,6 +170,8 @@ void br_dev_delete(struct net_device *dev, struct list_head *head)
 		del_nbp(p);
 	}
 
+	br_fdb_delete_by_port(br, NULL, 1);
+
 	del_timer_sync(&br->gc_timer);
 
 	br_sysfs_delbr(br->dev);
diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index 21a1840..bbe5dbd 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -286,8 +286,6 @@ static int caif_seqpkt_recvmsg(struct kiocb *iocb, struct socket *sock,
 	if (m->msg_flags&MSG_OOB)
 		goto read_error;
 
-	m->msg_namelen = 0;
-
 	skb = skb_recv_datagram(sk, flags, 0 , &ret);
 	if (!skb)
 		goto read_error;
@@ -361,8 +359,6 @@ static int caif_stream_recvmsg(struct kiocb *iocb, struct socket *sock,
 	if (flags&MSG_OOB)
 		goto out;
 
-	msg->msg_namelen = 0;
-
 	/*
 	 * Lock the socket to prevent queue disordering
 	 * while sleeps in memcpy_tomsg
diff --git a/net/compat.c b/net/compat.c
index 707f5ba..1d223d5 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -72,7 +72,7 @@ int get_compat_msghdr(struct msghdr *kmsg, struct compat_msghdr __user *umsg)
 	    __get_user(kmsg->msg_flags, &umsg->msg_flags))
 		return -EFAULT;
 	if (kmsg->msg_namelen > sizeof(struct sockaddr_storage))
-		return -EINVAL;
+		kmsg->msg_namelen = sizeof(struct sockaddr_storage);
 	kmsg->msg_name = compat_ptr(tmp1);
 	kmsg->msg_iov = compat_ptr(tmp2);
 	kmsg->msg_control = compat_ptr(tmp3);
@@ -93,7 +93,8 @@ int verify_compat_iovec(struct msghdr *kern_msg, struct iovec *kern_iov,
 			if (err < 0)
 				return err;
 		}
-		kern_msg->msg_name = kern_address;
+		if (kern_msg->msg_name)
+			kern_msg->msg_name = kern_address;
 	} else
 		kern_msg->msg_name = NULL;
 
diff --git a/net/core/dev.c b/net/core/dev.c
index a0eaa60..3fb7c7c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4445,7 +4445,7 @@ static void dev_change_rx_flags(struct net_device *dev, int flags)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
 
-	if ((dev->flags & IFF_UP) && ops->ndo_change_rx_flags)
+	if (ops->ndo_change_rx_flags)
 		ops->ndo_change_rx_flags(dev, flags);
 }
 
diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index 72cceb7..d660ad4 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -443,7 +443,8 @@ static int fib_nl_delrule(struct sk_buff *skb, struct nlmsghdr* nlh, void *arg)
 		if (frh->action && (frh->action != rule->action))
 			continue;
 
-		if (frh->table && (frh_get_table(frh, tb) != rule->table))
+		if (frh_get_table(frh, tb) &&
+		    (frh_get_table(frh, tb) != rule->table))
 			continue;
 
 		if (tb[FRA_PRIORITY] &&
diff --git a/net/core/iovec.c b/net/core/iovec.c
index 7e7aeb0..7fd34a5 100644
--- a/net/core/iovec.c
+++ b/net/core/iovec.c
@@ -48,7 +48,8 @@ int verify_iovec(struct msghdr *m, struct iovec *iov, struct sockaddr_storage *a
 			if (err < 0)
 				return err;
 		}
-		m->msg_name = address;
+		if (m->msg_name)
+			m->msg_name = address;
 	} else {
 		m->msg_name = NULL;
 	}
diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 2a42802..b3c5bac 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -2516,6 +2516,8 @@ static int process_ipsec(struct pktgen_dev *pkt_dev,
 		if (x) {
 			int ret;
 			__u8 *eth;
+			struct iphdr *iph;
+
 			nhead = x->props.header_len - skb_headroom(skb);
 			if (nhead > 0) {
 				ret = pskb_expand_head(skb, nhead, 0, GFP_ATOMIC);
@@ -2537,6 +2539,11 @@ static int process_ipsec(struct pktgen_dev *pkt_dev,
 			eth = (__u8 *) skb_push(skb, ETH_HLEN);
 			memcpy(eth, pkt_dev->hh, 12);
 			*(u16 *) &eth[12] = protocol;
+
+			/* Update IPv4 header len as well as checksum value */
+			iph = ip_hdr(skb);
+			iph->tot_len = htons(skb->len - ETH_HLEN);
+			ip_send_check(iph);
 		}
 	}
 	return 1;
diff --git a/net/ieee802154/6lowpan.c b/net/ieee802154/6lowpan.c
index 32eb417..2dce3b7 100644
--- a/net/ieee802154/6lowpan.c
+++ b/net/ieee802154/6lowpan.c
@@ -818,7 +818,7 @@ lowpan_process_data(struct sk_buff *skb)
 	 * Traffic class carried in-line
 	 * ECN + DSCP (1 byte), Flow Label is elided
 	 */
-	case 1: /* 10b */
+	case 2: /* 10b */
 		if (!skb->len)
 			goto drop;
 		tmp = lowpan_fetch_skb_u8(skb);
@@ -831,7 +831,7 @@ lowpan_process_data(struct sk_buff *skb)
 	 * Flow Label carried in-line
 	 * ECN + 2-bit Pad + Flow Label (3 bytes), DSCP is elided
 	 */
-	case 2: /* 01b */
+	case 1: /* 01b */
 		if (!skb->len)
 			goto drop;
 		tmp = lowpan_fetch_skb_u8(skb);
diff --git a/net/ipv4/datagram.c b/net/ipv4/datagram.c
index 424fafb..ec07510 100644
--- a/net/ipv4/datagram.c
+++ b/net/ipv4/datagram.c
@@ -57,7 +57,7 @@ int ip4_datagram_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	if (IS_ERR(rt)) {
 		err = PTR_ERR(rt);
 		if (err == -ENETUNREACH)
-			IP_INC_STATS_BH(sock_net(sk), IPSTATS_MIB_OUTNOROUTES);
+			IP_INC_STATS(sock_net(sk), IPSTATS_MIB_OUTNOROUTES);
 		goto out;
 	}
 
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index aabeb7b..34790df 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -367,7 +367,7 @@ void ip_local_error(struct sock *sk, int err, __be32 daddr, __be16 port, u32 inf
 /*
  *	Handle MSG_ERRQUEUE
  */
-int ip_recv_error(struct sock *sk, struct msghdr *msg, int len)
+int ip_recv_error(struct sock *sk, struct msghdr *msg, int len, int *addr_len)
 {
 	struct sock_exterr_skb *serr;
 	struct sk_buff *skb, *skb2;
@@ -404,6 +404,7 @@ int ip_recv_error(struct sock *sk, struct msghdr *msg, int len)
 						   serr->addr_offset);
 		sin->sin_port = serr->port;
 		memset(&sin->sin_zero, 0, sizeof(sin->sin_zero));
+		*addr_len = sizeof(*sin);
 	}
 
 	memcpy(&errhdr.ee, &serr->ee, sizeof(struct sock_extended_err));
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 79db4e5..80c0847 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -575,7 +575,7 @@ static int ping_sendmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 		err = PTR_ERR(rt);
 		rt = NULL;
 		if (err == -ENETUNREACH)
-			IP_INC_STATS_BH(net, IPSTATS_MIB_OUTNOROUTES);
+			IP_INC_STATS(net, IPSTATS_MIB_OUTNOROUTES);
 		goto out;
 	}
 
@@ -631,7 +631,6 @@ static int ping_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 			size_t len, int noblock, int flags, int *addr_len)
 {
 	struct inet_sock *isk = inet_sk(sk);
-	struct sockaddr_in *sin = (struct sockaddr_in *)msg->msg_name;
 	struct sk_buff *skb;
 	int copied, err;
 
@@ -641,11 +640,8 @@ static int ping_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 	if (flags & MSG_OOB)
 		goto out;
 
-	if (addr_len)
-		*addr_len = sizeof(*sin);
-
 	if (flags & MSG_ERRQUEUE)
-		return ip_recv_error(sk, msg, len);
+		return ip_recv_error(sk, msg, len, addr_len);
 
 	skb = skb_recv_datagram(sk, flags, noblock, &err);
 	if (!skb)
@@ -665,11 +661,14 @@ static int ping_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 	sock_recv_timestamp(msg, sk, skb);
 
 	/* Copy the address. */
-	if (sin) {
+	if (msg->msg_name) {
+		struct sockaddr_in *sin = (struct sockaddr_in *)msg->msg_name;
+
 		sin->sin_family = AF_INET;
 		sin->sin_port = 0 /* skb->h.uh->source */;
 		sin->sin_addr.s_addr = ip_hdr(skb)->saddr;
 		memset(sin->sin_zero, 0, sizeof(sin->sin_zero));
+		*addr_len = sizeof(*sin);
 	}
 	if (isk->cmsg_flags)
 		ip_cmsg_recv(msg, skb);
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 0753bd7..e9c21f7 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -688,11 +688,8 @@ static int raw_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 	if (flags & MSG_OOB)
 		goto out;
 
-	if (addr_len)
-		*addr_len = sizeof(*sin);
-
 	if (flags & MSG_ERRQUEUE) {
-		err = ip_recv_error(sk, msg, len);
+		err = ip_recv_error(sk, msg, len, addr_len);
 		goto out;
 	}
 
@@ -718,6 +715,7 @@ static int raw_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 		sin->sin_addr.s_addr = ip_hdr(skb)->saddr;
 		sin->sin_port = 0;
 		memset(&sin->sin_zero, 0, sizeof(sin->sin_zero));
+		*addr_len = sizeof(*sin);
 	}
 	if (inet->cmsg_flags)
 		ip_cmsg_recv(msg, skb);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index f374da4..03016d8 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -184,7 +184,7 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	if (IS_ERR(rt)) {
 		err = PTR_ERR(rt);
 		if (err == -ENETUNREACH)
-			IP_INC_STATS_BH(sock_net(sk), IPSTATS_MIB_OUTNOROUTES);
+			IP_INC_STATS(sock_net(sk), IPSTATS_MIB_OUTNOROUTES);
 		return err;
 	}
 
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index cd45011..2598686 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -941,7 +941,7 @@ int udp_sendmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 			err = PTR_ERR(rt);
 			rt = NULL;
 			if (err == -ENETUNREACH)
-				IP_INC_STATS_BH(net, IPSTATS_MIB_OUTNOROUTES);
+				IP_INC_STATS(net, IPSTATS_MIB_OUTNOROUTES);
 			goto out;
 		}
 
@@ -1040,6 +1040,9 @@ int udp_sendpage(struct sock *sk, struct page *page, int offset,
 	struct udp_sock *up = udp_sk(sk);
 	int ret;
 
+	if (flags & MSG_SENDPAGE_NOTLAST)
+		flags |= MSG_MORE;
+
 	if (!up->pending) {
 		struct msghdr msg = {	.msg_flags = flags|MSG_MORE };
 
@@ -1175,14 +1178,8 @@ int udp_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 	int is_udplite = IS_UDPLITE(sk);
 	bool slow;
 
-	/*
-	 *	Check any passed addresses
-	 */
-	if (addr_len)
-		*addr_len = sizeof(*sin);
-
 	if (flags & MSG_ERRQUEUE)
-		return ip_recv_error(sk, msg, len);
+		return ip_recv_error(sk, msg, len, addr_len);
 
 try_again:
 	skb = __skb_recv_datagram(sk, flags | (noblock ? MSG_DONTWAIT : 0),
@@ -1235,6 +1232,7 @@ try_again:
 		sin->sin_port = udp_hdr(skb)->source;
 		sin->sin_addr.s_addr = ip_hdr(skb)->saddr;
 		memset(sin->sin_zero, 0, sizeof(sin->sin_zero));
+		*addr_len = sizeof(*sin);
 	}
 	if (inet->cmsg_flags)
 		ip_cmsg_recv(msg, skb);
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index be2b67d6..bbff67f 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -317,7 +317,7 @@ void ipv6_local_rxpmtu(struct sock *sk, struct flowi6 *fl6, u32 mtu)
 /*
  *	Handle MSG_ERRQUEUE
  */
-int ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len)
+int ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len, int *addr_len)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct sock_exterr_skb *serr;
@@ -368,6 +368,7 @@ int ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len)
 			ipv6_addr_set_v4mapped(*(__be32 *)(nh + serr->addr_offset),
 					       &sin->sin6_addr);
 		}
+		*addr_len = sizeof(*sin);
 	}
 
 	memcpy(&errhdr.ee, &serr->ee, sizeof(struct sock_extended_err));
@@ -376,6 +377,7 @@ int ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len)
 	if (serr->ee.ee_origin != SO_EE_ORIGIN_LOCAL) {
 		sin->sin6_family = AF_INET6;
 		sin->sin6_flowinfo = 0;
+		sin->sin6_port = 0;
 		sin->sin6_scope_id = 0;
 		if (skb->protocol == htons(ETH_P_IPV6)) {
 			sin->sin6_addr = ipv6_hdr(skb)->saddr;
@@ -421,7 +423,8 @@ EXPORT_SYMBOL_GPL(ipv6_recv_error);
 /*
  *	Handle IPV6_RECVPATHMTU
  */
-int ipv6_recv_rxpmtu(struct sock *sk, struct msghdr *msg, int len)
+int ipv6_recv_rxpmtu(struct sock *sk, struct msghdr *msg, int len,
+		     int *addr_len)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct sk_buff *skb;
@@ -455,6 +458,7 @@ int ipv6_recv_rxpmtu(struct sock *sk, struct msghdr *msg, int len)
 		sin->sin6_port = 0;
 		sin->sin6_scope_id = mtu_info.ip6m_addr.sin6_scope_id;
 		sin->sin6_addr = mtu_info.ip6m_addr.sin6_addr;
+		*addr_len = sizeof(*sin);
 	}
 
 	put_cmsg(msg, SOL_IPV6, IPV6_PATHMTU, sizeof(mtu_info), &mtu_info);
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 01cf1cd..9665b28 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -144,8 +144,8 @@ static int ip6_finish_output2(struct sk_buff *skb)
 		return res;
 	}
 	rcu_read_unlock();
-	IP6_INC_STATS_BH(dev_net(dst->dev),
-			 ip6_dst_idev(dst), IPSTATS_MIB_OUTNOROUTES);
+	IP6_INC_STATS(dev_net(dst->dev),
+		      ip6_dst_idev(dst), IPSTATS_MIB_OUTNOROUTES);
 	kfree_skb(skb);
 	return -EINVAL;
 }
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 9dca4a8..dbd6795 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -457,14 +457,11 @@ static int rawv6_recvmsg(struct kiocb *iocb, struct sock *sk,
 	if (flags & MSG_OOB)
 		return -EOPNOTSUPP;
 
-	if (addr_len)
-		*addr_len=sizeof(*sin6);
-
 	if (flags & MSG_ERRQUEUE)
-		return ipv6_recv_error(sk, msg, len);
+		return ipv6_recv_error(sk, msg, len, addr_len);
 
 	if (np->rxpmtu && np->rxopt.bits.rxpmtu)
-		return ipv6_recv_rxpmtu(sk, msg, len);
+		return ipv6_recv_rxpmtu(sk, msg, len, addr_len);
 
 	skb = skb_recv_datagram(sk, flags, noblock, &err);
 	if (!skb)
@@ -499,6 +496,7 @@ static int rawv6_recvmsg(struct kiocb *iocb, struct sock *sk,
 		sin6->sin6_scope_id = 0;
 		if (ipv6_addr_type(&sin6->sin6_addr) & IPV6_ADDR_LINKLOCAL)
 			sin6->sin6_scope_id = IP6CB(skb)->iif;
+		*addr_len = sizeof(*sin6);
 	}
 
 	sock_recv_ts_and_drops(msg, sk, skb);
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 9659bd9..2367444 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -619,8 +619,11 @@ int rt6_route_rcv(struct net_device *dev, u8 *opt, int len,
 		prefix = &prefix_buf;
 	}
 
-	rt = rt6_get_route_info(net, prefix, rinfo->prefix_len, gwaddr,
-				dev->ifindex);
+	if (rinfo->prefix_len == 0)
+		rt = rt6_get_dflt_router(gwaddr, dev);
+	else
+		rt = rt6_get_route_info(net, prefix, rinfo->prefix_len,
+					gwaddr, dev->ifindex);
 
 	if (rt && !lifetime) {
 		ip6_del_rt(rt);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index a006a21..0a56096 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -348,14 +348,11 @@ int udpv6_recvmsg(struct kiocb *iocb, struct sock *sk,
 	int is_udp4;
 	bool slow;
 
-	if (addr_len)
-		*addr_len = sizeof(struct sockaddr_in6);
-
 	if (flags & MSG_ERRQUEUE)
-		return ipv6_recv_error(sk, msg, len);
+		return ipv6_recv_error(sk, msg, len, addr_len);
 
 	if (np->rxpmtu && np->rxopt.bits.rxpmtu)
-		return ipv6_recv_rxpmtu(sk, msg, len);
+		return ipv6_recv_rxpmtu(sk, msg, len, addr_len);
 
 try_again:
 	skb = __skb_recv_datagram(sk, flags | (noblock ? MSG_DONTWAIT : 0),
@@ -423,7 +420,7 @@ try_again:
 			if (ipv6_addr_type(&sin6->sin6_addr) & IPV6_ADDR_LINKLOCAL)
 				sin6->sin6_scope_id = IP6CB(skb)->iif;
 		}
-
+		*addr_len = sizeof(*sin6);
 	}
 	if (is_udp4) {
 		if (inet->cmsg_flags)
diff --git a/net/ipx/af_ipx.c b/net/ipx/af_ipx.c
index dfd6faa..624520d 100644
--- a/net/ipx/af_ipx.c
+++ b/net/ipx/af_ipx.c
@@ -1827,8 +1827,6 @@ static int ipx_recvmsg(struct kiocb *iocb, struct socket *sock,
 	if (skb->tstamp.tv64)
 		sk->sk_stamp = skb->tstamp;
 
-	msg->msg_namelen = sizeof(*sipx);
-
 	if (sipx) {
 		sipx->sipx_family	= AF_IPX;
 		sipx->sipx_port		= ipx->ipx_source.sock;
@@ -1836,6 +1834,7 @@ static int ipx_recvmsg(struct kiocb *iocb, struct socket *sock,
 		sipx->sipx_network	= IPX_SKB_CB(skb)->ipx_source_net;
 		sipx->sipx_type 	= ipx->ipx_type;
 		sipx->sipx_zero		= 0;
+		msg->msg_namelen	= sizeof(*sipx);
 	}
 	rc = copied;
 
diff --git a/net/irda/af_irda.c b/net/irda/af_irda.c
index bd25678..12218f7 100644
--- a/net/irda/af_irda.c
+++ b/net/irda/af_irda.c
@@ -1386,8 +1386,6 @@ static int irda_recvmsg_dgram(struct kiocb *iocb, struct socket *sock,
 
 	IRDA_DEBUG(4, "%s()\n", __func__);
 
-	msg->msg_namelen = 0;
-
 	skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT,
 				flags & MSG_DONTWAIT, &err);
 	if (!skb)
@@ -1452,8 +1450,6 @@ static int irda_recvmsg_stream(struct kiocb *iocb, struct socket *sock,
 	target = sock_rcvlowat(sk, flags & MSG_WAITALL, size);
 	timeo = sock_rcvtimeo(sk, noblock);
 
-	msg->msg_namelen = 0;
-
 	do {
 		int chunk;
 		struct sk_buff *skb = skb_dequeue(&sk->sk_receive_queue);
diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index 625bc50..cd6f7a9 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -1331,8 +1331,6 @@ static int iucv_sock_recvmsg(struct kiocb *iocb, struct socket *sock,
 	struct sk_buff *skb, *rskb, *cskb;
 	int err = 0;
 
-	msg->msg_namelen = 0;
-
 	if ((sk->sk_state == IUCV_DISCONN) &&
 	    skb_queue_empty(&iucv->backlog_skb_q) &&
 	    skb_queue_empty(&sk->sk_receive_queue) &&
diff --git a/net/key/af_key.c b/net/key/af_key.c
index b606ce5..7d500a4 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -3595,7 +3595,6 @@ static int pfkey_recvmsg(struct kiocb *kiocb,
 	if (flags & ~(MSG_PEEK|MSG_DONTWAIT|MSG_TRUNC|MSG_CMSG_COMPAT))
 		goto out;
 
-	msg->msg_namelen = 0;
 	skb = skb_recv_datagram(sk, flags, flags & MSG_DONTWAIT, &err);
 	if (skb == NULL)
 		goto out;
diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index 61d8b75..2bc35bc 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -510,9 +510,6 @@ static int l2tp_ip_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *m
 	if (flags & MSG_OOB)
 		goto out;
 
-	if (addr_len)
-		*addr_len = sizeof(*sin);
-
 	skb = skb_recv_datagram(sk, flags, noblock, &err);
 	if (!skb)
 		goto out;
@@ -535,6 +532,7 @@ static int l2tp_ip_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *m
 		sin->sin_addr.s_addr = ip_hdr(skb)->saddr;
 		sin->sin_port = 0;
 		memset(&sin->sin_zero, 0, sizeof(sin->sin_zero));
+		*addr_len = sizeof(*sin);
 	}
 	if (inet->cmsg_flags)
 		ip_cmsg_recv(msg, skb);
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 2c9ccce..c466f04 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -659,7 +659,7 @@ static int l2tp_ip6_recvmsg(struct kiocb *iocb, struct sock *sk,
 		*addr_len = sizeof(*lsa);
 
 	if (flags & MSG_ERRQUEUE)
-		return ipv6_recv_error(sk, msg, len);
+		return ipv6_recv_error(sk, msg, len, addr_len);
 
 	skb = skb_recv_datagram(sk, flags, noblock, &err);
 	if (!skb)
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 624cf33..63c74b7 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -196,8 +196,6 @@ static int pppol2tp_recvmsg(struct kiocb *iocb, struct socket *sock,
 	if (sk->sk_state & PPPOX_BOUND)
 		goto end;
 
-	msg->msg_namelen = 0;
-
 	err = 0;
 	skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT,
 				flags & MSG_DONTWAIT, &err);
diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index 445882cb..a13c3e2 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -720,8 +720,6 @@ static int llc_ui_recvmsg(struct kiocb *iocb, struct socket *sock,
 	int target;	/* Read at least this many bytes */
 	long timeo;
 
-	msg->msg_namelen = 0;
-
 	lock_sock(sk);
 	copied = -ENOTCONN;
 	if (unlikely(sk->sk_type == SOCK_STREAM && sk->sk_state == TCP_LISTEN))
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index ee8f525a..02e3f9a 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -764,7 +764,8 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
 	u16 sc;
 	u8 tid, ack_policy;
 
-	if (!ieee80211_is_data_qos(hdr->frame_control))
+	if (!ieee80211_is_data_qos(hdr->frame_control) ||
+	    is_multicast_ether_addr(hdr->addr1))
 		goto dont_reorder;
 
 	/*
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index f4980b6..bd9e5b7 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1458,8 +1458,6 @@ static int netlink_recvmsg(struct kiocb *kiocb, struct socket *sock,
 	}
 #endif
 
-	msg->msg_namelen = 0;
-
 	copied = data_skb->len;
 	if (len < copied) {
 		msg->msg_flags |= MSG_TRUNC;
diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 7ed9b1d..dcf6791 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -1181,10 +1181,9 @@ static int nr_recvmsg(struct kiocb *iocb, struct socket *sock,
 		sax->sax25_family = AF_NETROM;
 		skb_copy_from_linear_data_offset(skb, 7, sax->sax25_call.ax25_call,
 			      AX25_ADDR_LEN);
+		msg->msg_namelen = sizeof(*sax);
 	}
 
-	msg->msg_namelen = sizeof(*sax);
-
 	skb_free_datagram(sk, skb);
 
 	release_sock(sk);
diff --git a/net/nfc/rawsock.c b/net/nfc/rawsock.c
index 8b8a6a2..ea01613 100644
--- a/net/nfc/rawsock.c
+++ b/net/nfc/rawsock.c
@@ -241,8 +241,6 @@ static int rawsock_recvmsg(struct kiocb *iocb, struct socket *sock,
 	if (!skb)
 		return rc;
 
-	msg->msg_namelen = 0;
-
 	copied = skb->len;
 	if (len < copied) {
 		msg->msg_flags |= MSG_TRUNC;
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 1522b93..8be3ab6 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -294,6 +294,7 @@ struct packet_sock {
 	unsigned int		tp_reserve;
 	unsigned int		tp_loss:1;
 	unsigned int		tp_tstamp;
+	struct net_device __rcu	*cached_dev;
 	struct packet_type	prot_hook ____cacheline_aligned_in_smp;
 };
 
@@ -349,11 +350,15 @@ static void __fanout_link(struct sock *sk, struct packet_sock *po);
 static void register_prot_hook(struct sock *sk)
 {
 	struct packet_sock *po = pkt_sk(sk);
+
 	if (!po->running) {
-		if (po->fanout)
+		if (po->fanout) {
 			__fanout_link(sk, po);
-		else
+		} else {
 			dev_add_pack(&po->prot_hook);
+			rcu_assign_pointer(po->cached_dev, po->prot_hook.dev);
+		}
+
 		sock_hold(sk);
 		po->running = 1;
 	}
@@ -371,10 +376,13 @@ static void __unregister_prot_hook(struct sock *sk, bool sync)
 	struct packet_sock *po = pkt_sk(sk);
 
 	po->running = 0;
-	if (po->fanout)
+	if (po->fanout) {
 		__fanout_unlink(sk, po);
-	else
+	} else {
 		__dev_remove_pack(&po->prot_hook);
+		RCU_INIT_POINTER(po->cached_dev, NULL);
+	}
+
 	__sock_put(sk);
 
 	if (sync) {
@@ -496,9 +504,9 @@ static void prb_shutdown_retire_blk_timer(struct packet_sock *po,
 
 	pkc = tx_ring ? &po->tx_ring.prb_bdqc : &po->rx_ring.prb_bdqc;
 
-	spin_lock(&rb_queue->lock);
+	spin_lock_bh(&rb_queue->lock);
 	pkc->delete_blk_timer = 1;
-	spin_unlock(&rb_queue->lock);
+	spin_unlock_bh(&rb_queue->lock);
 
 	prb_del_retire_blk_timer(pkc);
 }
@@ -2050,12 +2058,24 @@ static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
 	return tp_len;
 }
 
+static struct net_device *packet_cached_dev_get(struct packet_sock *po)
+{
+	struct net_device *dev;
+
+	rcu_read_lock();
+	dev = rcu_dereference(po->cached_dev);
+	if (dev)
+		dev_hold(dev);
+	rcu_read_unlock();
+
+	return dev;
+}
+
 static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 {
 	struct sk_buff *skb;
 	struct net_device *dev;
 	__be16 proto;
-	bool need_rls_dev = false;
 	int err, reserve = 0;
 	void *ph;
 	struct sockaddr_ll *saddr = (struct sockaddr_ll *)msg->msg_name;
@@ -2069,7 +2089,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 
 	err = -EBUSY;
 	if (saddr == NULL) {
-		dev = po->prot_hook.dev;
+		dev	= packet_cached_dev_get(po);
 		proto	= po->num;
 		addr	= NULL;
 	} else {
@@ -2083,19 +2103,17 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 		proto	= saddr->sll_protocol;
 		addr	= saddr->sll_addr;
 		dev = dev_get_by_index(sock_net(&po->sk), saddr->sll_ifindex);
-		need_rls_dev = true;
 	}
 
 	err = -ENXIO;
 	if (unlikely(dev == NULL))
 		goto out;
-
-	reserve = dev->hard_header_len;
-
 	err = -ENETDOWN;
 	if (unlikely(!(dev->flags & IFF_UP)))
 		goto out_put;
 
+	reserve = dev->hard_header_len;
+
 	size_max = po->tx_ring.frame_size
 		- (po->tp_hdrlen - sizeof(struct sockaddr_ll));
 
@@ -2172,8 +2190,7 @@ out_status:
 	__packet_set_status(po, ph, status);
 	kfree_skb(skb);
 out_put:
-	if (need_rls_dev)
-		dev_put(dev);
+	dev_put(dev);
 out:
 	mutex_unlock(&po->pg_vec_lock);
 	return err;
@@ -2211,7 +2228,6 @@ static int packet_snd(struct socket *sock,
 	struct sk_buff *skb;
 	struct net_device *dev;
 	__be16 proto;
-	bool need_rls_dev = false;
 	unsigned char *addr;
 	int err, reserve = 0;
 	struct virtio_net_hdr vnet_hdr = { 0 };
@@ -2227,7 +2243,7 @@ static int packet_snd(struct socket *sock,
 	 */
 
 	if (saddr == NULL) {
-		dev = po->prot_hook.dev;
+		dev	= packet_cached_dev_get(po);
 		proto	= po->num;
 		addr	= NULL;
 	} else {
@@ -2239,19 +2255,17 @@ static int packet_snd(struct socket *sock,
 		proto	= saddr->sll_protocol;
 		addr	= saddr->sll_addr;
 		dev = dev_get_by_index(sock_net(sk), saddr->sll_ifindex);
-		need_rls_dev = true;
 	}
 
 	err = -ENXIO;
-	if (dev == NULL)
+	if (unlikely(dev == NULL))
 		goto out_unlock;
-	if (sock->type == SOCK_RAW)
-		reserve = dev->hard_header_len;
-
 	err = -ENETDOWN;
-	if (!(dev->flags & IFF_UP))
+	if (unlikely(!(dev->flags & IFF_UP)))
 		goto out_unlock;
 
+	if (sock->type == SOCK_RAW)
+		reserve = dev->hard_header_len;
 	if (po->has_vnet_hdr) {
 		vnet_hdr_len = sizeof(vnet_hdr);
 
@@ -2384,15 +2398,14 @@ static int packet_snd(struct socket *sock,
 	if (err > 0 && (err = net_xmit_errno(err)) != 0)
 		goto out_unlock;
 
-	if (need_rls_dev)
-		dev_put(dev);
+	dev_put(dev);
 
 	return len;
 
 out_free:
 	kfree_skb(skb);
 out_unlock:
-	if (dev && need_rls_dev)
+	if (dev)
 		dev_put(dev);
 out:
 	return err;
@@ -2609,6 +2622,7 @@ static int packet_create(struct net *net, struct socket *sock, int protocol,
 	po = pkt_sk(sk);
 	sk->sk_family = PF_PACKET;
 	po->num = proto;
+	RCU_INIT_POINTER(po->cached_dev, NULL);
 
 	sk->sk_destruct = packet_sock_destruct;
 	sk_refcnt_debug_inc(sk);
@@ -2697,7 +2711,6 @@ static int packet_recvmsg(struct kiocb *iocb, struct socket *sock,
 	struct sock *sk = sock->sk;
 	struct sk_buff *skb;
 	int copied, err;
-	struct sockaddr_ll *sll;
 	int vnet_hdr_len = 0;
 
 	err = -EINVAL;
@@ -2780,22 +2793,10 @@ static int packet_recvmsg(struct kiocb *iocb, struct socket *sock,
 			goto out_free;
 	}
 
-	/*
-	 *	If the address length field is there to be filled in, we fill
-	 *	it in now.
+	/* You lose any data beyond the buffer you gave. If it worries
+	 * a user program they can ask the device for its MTU
+	 * anyway.
 	 */
-
-	sll = &PACKET_SKB_CB(skb)->sa.ll;
-	if (sock->type == SOCK_PACKET)
-		msg->msg_namelen = sizeof(struct sockaddr_pkt);
-	else
-		msg->msg_namelen = sll->sll_halen + offsetof(struct sockaddr_ll, sll_addr);
-
-	/*
-	 *	You lose any data beyond the buffer you gave. If it worries a
-	 *	user program they can ask the device for its MTU anyway.
-	 */
-
 	copied = skb->len;
 	if (copied > len) {
 		copied = len;
@@ -2808,9 +2809,20 @@ static int packet_recvmsg(struct kiocb *iocb, struct socket *sock,
 
 	sock_recv_ts_and_drops(msg, sk, skb);
 
-	if (msg->msg_name)
+	if (msg->msg_name) {
+		/* If the address length field is there to be filled
+		 * in, we fill it in now.
+		 */
+		if (sock->type == SOCK_PACKET) {
+			msg->msg_namelen = sizeof(struct sockaddr_pkt);
+		} else {
+			struct sockaddr_ll *sll = &PACKET_SKB_CB(skb)->sa.ll;
+			msg->msg_namelen = sll->sll_halen +
+				offsetof(struct sockaddr_ll, sll_addr);
+		}
 		memcpy(msg->msg_name, &PACKET_SKB_CB(skb)->sa,
 		       msg->msg_namelen);
+	}
 
 	if (pkt_sk(sk)->auxdata) {
 		struct tpacket_auxdata aux;
diff --git a/net/phonet/datagram.c b/net/phonet/datagram.c
index 12c30f3..38946b2 100644
--- a/net/phonet/datagram.c
+++ b/net/phonet/datagram.c
@@ -139,9 +139,6 @@ static int pn_recvmsg(struct kiocb *iocb, struct sock *sk,
 			MSG_CMSG_COMPAT))
 		goto out_nofree;
 
-	if (addr_len)
-		*addr_len = sizeof(sa);
-
 	skb = skb_recv_datagram(sk, flags, noblock, &rval);
 	if (skb == NULL)
 		goto out_nofree;
@@ -162,8 +159,10 @@ static int pn_recvmsg(struct kiocb *iocb, struct sock *sk,
 
 	rval = (flags & MSG_TRUNC) ? skb->len : copylen;
 
-	if (msg->msg_name != NULL)
-		memcpy(msg->msg_name, &sa, sizeof(struct sockaddr_pn));
+	if (msg->msg_name != NULL) {
+		memcpy(msg->msg_name, &sa, sizeof(sa));
+		*addr_len = sizeof(sa);
+	}
 
 out:
 	skb_free_datagram(sk, skb);
diff --git a/net/rds/recv.c b/net/rds/recv.c
index 9f0f17c..de339b2 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -410,8 +410,6 @@ int rds_recvmsg(struct kiocb *iocb, struct socket *sock, struct msghdr *msg,
 
 	rdsdebug("size %zu flags 0x%x timeo %ld\n", size, msg_flags, timeo);
 
-	msg->msg_namelen = 0;
-
 	if (msg_flags & MSG_OOB)
 		goto out;
 
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 7f645d1..ce5f5b9 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -1220,7 +1220,6 @@ static int rose_recvmsg(struct kiocb *iocb, struct socket *sock,
 {
 	struct sock *sk = sock->sk;
 	struct rose_sock *rose = rose_sk(sk);
-	struct sockaddr_rose *srose = (struct sockaddr_rose *)msg->msg_name;
 	size_t copied;
 	unsigned char *asmptr;
 	struct sk_buff *skb;
@@ -1256,8 +1255,11 @@ static int rose_recvmsg(struct kiocb *iocb, struct socket *sock,
 
 	skb_copy_datagram_iovec(skb, 0, msg->msg_iov, copied);
 
-	if (srose != NULL) {
-		memset(srose, 0, msg->msg_namelen);
+	if (msg->msg_name) {
+		struct sockaddr_rose *srose;
+
+		memset(msg->msg_name, 0, sizeof(struct full_sockaddr_rose));
+		srose = msg->msg_name;
 		srose->srose_family = AF_ROSE;
 		srose->srose_addr   = rose->dest_addr;
 		srose->srose_call   = rose->dest_call;
diff --git a/net/rxrpc/ar-recvmsg.c b/net/rxrpc/ar-recvmsg.c
index 4b48687..898492a 100644
--- a/net/rxrpc/ar-recvmsg.c
+++ b/net/rxrpc/ar-recvmsg.c
@@ -143,10 +143,13 @@ int rxrpc_recvmsg(struct kiocb *iocb, struct socket *sock,
 
 		/* copy the peer address and timestamp */
 		if (!continue_call) {
-			if (msg->msg_name && msg->msg_namelen > 0)
+			if (msg->msg_name) {
+				size_t len =
+					sizeof(call->conn->trans->peer->srx);
 				memcpy(msg->msg_name,
-				       &call->conn->trans->peer->srx,
-				       sizeof(call->conn->trans->peer->srx));
+				       &call->conn->trans->peer->srx, len);
+				msg->msg_namelen = len;
+			}
 			sock_recv_ts_and_drops(msg, &rx->sk, skb);
 		}
 
diff --git a/net/socket.c b/net/socket.c
index c9b6b90..b04050a 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -215,12 +215,13 @@ static int move_addr_to_user(struct sockaddr_storage *kaddr, int klen,
 	int err;
 	int len;
 
+	BUG_ON(klen > sizeof(struct sockaddr_storage));
 	err = get_user(len, ulen);
 	if (err)
 		return err;
 	if (len > klen)
 		len = klen;
-	if (len < 0 || len > sizeof(struct sockaddr_storage))
+	if (len < 0)
 		return -EINVAL;
 	if (len) {
 		if (audit_sockaddr(klen, kaddr))
@@ -1774,8 +1775,10 @@ SYSCALL_DEFINE6(recvfrom, int, fd, void __user *, ubuf, size_t, size,
 	msg.msg_iov = &iov;
 	iov.iov_len = size;
 	iov.iov_base = ubuf;
-	msg.msg_name = (struct sockaddr *)&address;
-	msg.msg_namelen = sizeof(address);
+	/* Save some cycles and don't copy the address if not needed */
+	msg.msg_name = addr ? (struct sockaddr *)&address : NULL;
+	/* We assume all kernel code knows the size of sockaddr_storage */
+	msg.msg_namelen = 0;
 	if (sock->file->f_flags & O_NONBLOCK)
 		flags |= MSG_DONTWAIT;
 	err = sock_recvmsg(sock, &msg, size, flags);
@@ -1904,7 +1907,7 @@ static int copy_msghdr_from_user(struct msghdr *kmsg,
 	if (copy_from_user(kmsg, umsg, sizeof(struct msghdr)))
 		return -EFAULT;
 	if (kmsg->msg_namelen > sizeof(struct sockaddr_storage))
-		return -EINVAL;
+		kmsg->msg_namelen = sizeof(struct sockaddr_storage);
 	return 0;
 }
 
@@ -2155,16 +2158,14 @@ static int ___sys_recvmsg(struct socket *sock, struct msghdr __user *msg,
 			goto out;
 	}
 
-	/*
-	 *      Save the user-mode address (verify_iovec will change the
-	 *      kernel msghdr to use the kernel address space)
+	/* Save the user-mode address (verify_iovec will change the
+	 * kernel msghdr to use the kernel address space)
 	 */
-
 	uaddr = (__force void __user *)msg_sys->msg_name;
 	uaddr_len = COMPAT_NAMELEN(msg);
-	if (MSG_CMSG_COMPAT & flags) {
+	if (MSG_CMSG_COMPAT & flags)
 		err = verify_compat_iovec(msg_sys, iov, &addr, VERIFY_WRITE);
-	} else
+	else
 		err = verify_iovec(msg_sys, iov, &addr, VERIFY_WRITE);
 	if (err < 0)
 		goto out_freeiov;
@@ -2173,6 +2174,9 @@ static int ___sys_recvmsg(struct socket *sock, struct msghdr __user *msg,
 	cmsg_ptr = (unsigned long)msg_sys->msg_control;
 	msg_sys->msg_flags = flags & (MSG_CMSG_CLOEXEC|MSG_CMSG_COMPAT);
 
+	/* We assume all kernel code knows the size of sockaddr_storage */
+	msg_sys->msg_namelen = 0;
+
 	if (sock->file->f_flags & O_NONBLOCK)
 		flags |= MSG_DONTWAIT;
 	err = (nosec ? sock_recvmsg_nosec : sock_recvmsg)(sock, msg_sys,
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 91fd130..9cc3e87 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -917,9 +917,6 @@ static int recv_msg(struct kiocb *iocb, struct socket *sock,
 		goto exit;
 	}
 
-	/* will be updated in set_orig_addr() if needed */
-	m->msg_namelen = 0;
-
 	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 restart:
 
@@ -1036,9 +1033,6 @@ static int recv_stream(struct kiocb *iocb, struct socket *sock,
 		goto exit;
 	}
 
-	/* will be updated in set_orig_addr() if needed */
-	m->msg_namelen = 0;
-
 	target = sock_rcvlowat(sk, flags & MSG_WAITALL, buf_len);
 	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 2e67391..a0df32b 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1765,7 +1765,6 @@ static void unix_copy_addr(struct msghdr *msg, struct sock *sk)
 {
 	struct unix_sock *u = unix_sk(sk);
 
-	msg->msg_namelen = 0;
 	if (u->addr) {
 		msg->msg_namelen = u->addr->len;
 		memcpy(msg->msg_name, u->addr->name, u->addr->len);
@@ -1789,8 +1788,6 @@ static int unix_dgram_recvmsg(struct kiocb *iocb, struct socket *sock,
 	if (flags&MSG_OOB)
 		goto out;
 
-	msg->msg_namelen = 0;
-
 	err = mutex_lock_interruptible(&u->readlock);
 	if (err) {
 		err = sock_intr_errno(sock_rcvtimeo(sk, noblock));
@@ -1932,8 +1929,6 @@ static int unix_stream_recvmsg(struct kiocb *iocb, struct socket *sock,
 	target = sock_rcvlowat(sk, flags&MSG_WAITALL, size);
 	timeo = sock_rcvtimeo(sk, flags&MSG_DONTWAIT);
 
-	msg->msg_namelen = 0;
-
 	/* Lock the socket to prevent queue disordering
 	 * while sleeps in memcpy_tomsg
 	 */
diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index b943e3e..92aed9e 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -1343,10 +1343,9 @@ static int x25_recvmsg(struct kiocb *iocb, struct socket *sock,
 	if (sx25) {
 		sx25->sx25_family = AF_X25;
 		sx25->sx25_addr   = x25->dest_addr;
+		msg->msg_namelen = sizeof(*sx25);
 	}
 
-	msg->msg_namelen = sizeof(struct sockaddr_x25);
-
 	x25_check_rbuf(sk);
 	rc = copied;
 out_free_dgram:
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index db10db2..7b40d22 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -52,6 +52,7 @@
 #include <net/icmp.h>
 #include <net/ip.h>		/* for local_port_range[] */
 #include <net/tcp.h>		/* struct or_callable used in sock_rcv_skb */
+#include <net/inet_connection_sock.h>
 #include <net/net_namespace.h>
 #include <net/netlabel.h>
 #include <linux/uaccess.h>
@@ -3748,6 +3749,30 @@ static int selinux_skb_peerlbl_sid(struct sk_buff *skb, u16 family, u32 *sid)
 	return 0;
 }
 
+/**
+ * selinux_conn_sid - Determine the child socket label for a connection
+ * @sk_sid: the parent socket's SID
+ * @skb_sid: the packet's SID
+ * @conn_sid: the resulting connection SID
+ *
+ * If @skb_sid is valid then the user:role:type information from @sk_sid is
+ * combined with the MLS information from @skb_sid in order to create
+ * @conn_sid.  If @skb_sid is not valid then then @conn_sid is simply a copy
+ * of @sk_sid.  Returns zero on success, negative values on failure.
+ *
+ */
+static int selinux_conn_sid(u32 sk_sid, u32 skb_sid, u32 *conn_sid)
+{
+	int err = 0;
+
+	if (skb_sid != SECSID_NULL)
+		err = security_sid_mls_copy(sk_sid, skb_sid, conn_sid);
+	else
+		*conn_sid = sk_sid;
+
+	return err;
+}
+
 /* socket security operations */
 
 static int socket_sockcreate_sid(const struct task_security_struct *tsec,
@@ -4354,7 +4379,7 @@ static int selinux_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 	struct sk_security_struct *sksec = sk->sk_security;
 	int err;
 	u16 family = sk->sk_family;
-	u32 newsid;
+	u32 connsid;
 	u32 peersid;
 
 	/* handle mapped IPv4 packets arriving via IPv6 sockets */
@@ -4364,16 +4389,11 @@ static int selinux_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 	err = selinux_skb_peerlbl_sid(skb, family, &peersid);
 	if (err)
 		return err;
-	if (peersid == SECSID_NULL) {
-		req->secid = sksec->sid;
-		req->peer_secid = SECSID_NULL;
-	} else {
-		err = security_sid_mls_copy(sksec->sid, peersid, &newsid);
-		if (err)
-			return err;
-		req->secid = newsid;
-		req->peer_secid = peersid;
-	}
+	err = selinux_conn_sid(sksec->sid, peersid, &connsid);
+	if (err)
+		return err;
+	req->secid = connsid;
+	req->peer_secid = peersid;
 
 	return selinux_netlbl_inet_conn_request(req, family);
 }
@@ -4603,6 +4623,7 @@ static unsigned int selinux_ipv6_forward(unsigned int hooknum,
 static unsigned int selinux_ip_output(struct sk_buff *skb,
 				      u16 family)
 {
+	struct sock *sk;
 	u32 sid;
 
 	if (!netlbl_enabled())
@@ -4611,8 +4632,27 @@ static unsigned int selinux_ip_output(struct sk_buff *skb,
 	/* we do this in the LOCAL_OUT path and not the POST_ROUTING path
 	 * because we want to make sure we apply the necessary labeling
 	 * before IPsec is applied so we can leverage AH protection */
-	if (skb->sk) {
-		struct sk_security_struct *sksec = skb->sk->sk_security;
+	sk = skb->sk;
+	if (sk) {
+		struct sk_security_struct *sksec;
+
+		if (sk->sk_state == TCP_LISTEN)
+			/* if the socket is the listening state then this
+			 * packet is a SYN-ACK packet which means it needs to
+			 * be labeled based on the connection/request_sock and
+			 * not the parent socket.  unfortunately, we can't
+			 * lookup the request_sock yet as it isn't queued on
+			 * the parent socket until after the SYN-ACK is sent.
+			 * the "solution" is to simply pass the packet as-is
+			 * as any IP option based labeling should be copied
+			 * from the initial connection request (in the IP
+			 * layer).  it is far from ideal, but until we get a
+			 * security label in the packet itself this is the
+			 * best we can do. */
+			return NF_ACCEPT;
+
+		/* standard practice, label using the parent socket */
+		sksec = sk->sk_security;
 		sid = sksec->sid;
 	} else
 		sid = SECINITSID_KERNEL;
@@ -4697,12 +4737,12 @@ static unsigned int selinux_ip_postroute(struct sk_buff *skb, int ifindex,
 	if (!secmark_active && !peerlbl_active)
 		return NF_ACCEPT;
 
-	/* if the packet is being forwarded then get the peer label from the
-	 * packet itself; otherwise check to see if it is from a local
-	 * application or the kernel, if from an application get the peer label
-	 * from the sending socket, otherwise use the kernel's sid */
 	sk = skb->sk;
 	if (sk == NULL) {
+		/* Without an associated socket the packet is either coming
+		 * from the kernel or it is being forwarded; check the packet
+		 * to determine which and if the packet is being forwarded
+		 * query the packet directly to determine the security label. */
 		if (skb->skb_iif) {
 			secmark_perm = PACKET__FORWARD_OUT;
 			if (selinux_skb_peerlbl_sid(skb, family, &peer_sid))
@@ -4711,7 +4751,26 @@ static unsigned int selinux_ip_postroute(struct sk_buff *skb, int ifindex,
 			secmark_perm = PACKET__SEND;
 			peer_sid = SECINITSID_KERNEL;
 		}
+	} else if (sk->sk_state == TCP_LISTEN) {
+		/* Locally generated packet but the associated socket is in the
+		 * listening state which means this is a SYN-ACK packet.  In
+		 * this particular case the correct security label is assigned
+		 * to the connection/request_sock but unfortunately we can't
+		 * query the request_sock as it isn't queued on the parent
+		 * socket until after the SYN-ACK packet is sent; the only
+		 * viable choice is to regenerate the label like we do in
+		 * selinux_inet_conn_request().  See also selinux_ip_output()
+		 * for similar problems. */
+		u32 skb_sid;
+		struct sk_security_struct *sksec = sk->sk_security;
+		if (selinux_skb_peerlbl_sid(skb, family, &skb_sid))
+			return NF_DROP;
+		if (selinux_conn_sid(sksec->sid, skb_sid, &peer_sid))
+			return NF_DROP;
+		secmark_perm = PACKET__SEND;
 	} else {
+		/* Locally generated packet, fetch the security label from the
+		 * associated socket. */
 		struct sk_security_struct *sksec = sk->sk_security;
 		peer_sid = sksec->sid;
 		secmark_perm = PACKET__SEND;
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 45f1b1c..9df1421 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6291,6 +6291,7 @@ enum {
 	ALC861_FIXUP_AMP_VREF_0F,
 	ALC861_FIXUP_NO_JACK_DETECT,
 	ALC861_FIXUP_ASUS_A6RP,
+	ALC660_FIXUP_ASUS_W7J,
 };
 
 /* On some laptops, VREF of pin 0x0f is abused for controlling the main amp */
@@ -6341,10 +6342,22 @@ static const struct alc_fixup alc861_fixups[] = {
 		.v.func = alc861_fixup_asus_amp_vref_0f,
 		.chained = true,
 		.chain_id = ALC861_FIXUP_NO_JACK_DETECT,
+	},
+	[ALC660_FIXUP_ASUS_W7J] = {
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			/* ASUS W7J needs a magic pin setup on unused NID 0x10
+			 * for enabling outputs
+			 */
+			{0x10, AC_VERB_SET_PIN_WIDGET_CONTROL, 0x24},
+			{ }
+		},
 	}
 };
 
 static const struct snd_pci_quirk alc861_fixup_tbl[] = {
+	SND_PCI_QUIRK(0x1043, 0x1253, "ASUS W7J", ALC660_FIXUP_ASUS_W7J),
+	SND_PCI_QUIRK(0x1043, 0x1263, "ASUS Z35HL", ALC660_FIXUP_ASUS_W7J),
 	SND_PCI_QUIRK(0x1043, 0x1393, "ASUS A6Rp", ALC861_FIXUP_ASUS_A6RP),
 	SND_PCI_QUIRK_VENDOR(0x1043, "ASUS laptop", ALC861_FIXUP_AMP_VREF_0F),
 	SND_PCI_QUIRK(0x1462, 0x7254, "HP DX2200", ALC861_FIXUP_NO_JACK_DETECT),
diff --git a/sound/soc/codecs/wm8731.c b/sound/soc/codecs/wm8731.c
index 9d1b9b02..067cc12 100644
--- a/sound/soc/codecs/wm8731.c
+++ b/sound/soc/codecs/wm8731.c
@@ -406,10 +406,10 @@ static int wm8731_set_dai_fmt(struct snd_soc_dai *codec_dai,
 		iface |= 0x0001;
 		break;
 	case SND_SOC_DAIFMT_DSP_A:
-		iface |= 0x0003;
+		iface |= 0x0013;
 		break;
 	case SND_SOC_DAIFMT_DSP_B:
-		iface |= 0x0013;
+		iface |= 0x0003;
 		break;
 	default:
 		return -EINVAL;
diff --git a/sound/soc/codecs/wm8990.c b/sound/soc/codecs/wm8990.c
index db63c97..9c43b10 100644
--- a/sound/soc/codecs/wm8990.c
+++ b/sound/soc/codecs/wm8990.c
@@ -1264,6 +1264,8 @@ static int wm8990_set_bias_level(struct snd_soc_codec *codec,
 
 		/* disable POBCTRL, SOFT_ST and BUFDCOPEN */
 		snd_soc_write(codec, WM8990_ANTIPOP2, 0x0);
+
+		codec->cache_sync = 1;
 		break;
 	}
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1b29357..6c6631a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1698,6 +1698,9 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	int r;
 	struct kvm_vcpu *vcpu, *v;
 
+	if (id >= KVM_MAX_VCPUS)
+		return -EINVAL;
+
 	vcpu = kvm_arch_vcpu_create(kvm, id);
 	if (IS_ERR(vcpu))
 		return PTR_ERR(vcpu);
