Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaBZJrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 04:47:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49561 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaBZJqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 04:46:37 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: Re: [3.5.y.z extended stable] Linux 3.5.7.31
Date: Wed, 26 Feb 2014 09:46:29 +0000
Message-Id: <1393407989-8604-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393407989-8604-1-git-send-email-luis.henriques@canonical.com>
References: <1393407989-8604-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index b532f56..615517f 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 5
 SUBLEVEL = 7
-EXTRAVERSION = .30
+EXTRAVERSION = .31
 NAME = Saber-toothed Squirrel
 
 # *DOCUMENTATION*
diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index f3000a4..51fb1ef 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -25,6 +25,7 @@
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/spinlock.h>
 #include "crypt_s390.h"
 
 #define AES_KEYLEN_128		1
@@ -32,6 +33,7 @@
 #define AES_KEYLEN_256		4
 
 static u8 *ctrblk;
+static DEFINE_SPINLOCK(ctrblk_lock);
 static char keylen_flag;
 
 struct s390_aes_ctx {
@@ -760,43 +762,67 @@ static int ctr_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	return aes_set_key(tfm, in_key, key_len);
 }
 
+static unsigned int __ctrblk_init(u8 *ctrptr, unsigned int nbytes)
+{
+	unsigned int i, n;
+
+	/* only use complete blocks, max. PAGE_SIZE */
+	n = (nbytes > PAGE_SIZE) ? PAGE_SIZE : nbytes & ~(AES_BLOCK_SIZE - 1);
+	for (i = AES_BLOCK_SIZE; i < n; i += AES_BLOCK_SIZE) {
+		memcpy(ctrptr + i, ctrptr + i - AES_BLOCK_SIZE,
+		       AES_BLOCK_SIZE);
+		crypto_inc(ctrptr + i, AES_BLOCK_SIZE);
+	}
+	return n;
+}
+
 static int ctr_aes_crypt(struct blkcipher_desc *desc, long func,
 			 struct s390_aes_ctx *sctx, struct blkcipher_walk *walk)
 {
 	int ret = blkcipher_walk_virt_block(desc, walk, AES_BLOCK_SIZE);
-	unsigned int i, n, nbytes;
-	u8 buf[AES_BLOCK_SIZE];
-	u8 *out, *in;
+	unsigned int n, nbytes;
+	u8 buf[AES_BLOCK_SIZE], ctrbuf[AES_BLOCK_SIZE];
+	u8 *out, *in, *ctrptr = ctrbuf;
 
 	if (!walk->nbytes)
 		return ret;
 
-	memcpy(ctrblk, walk->iv, AES_BLOCK_SIZE);
+	if (spin_trylock(&ctrblk_lock))
+		ctrptr = ctrblk;
+
+	memcpy(ctrptr, walk->iv, AES_BLOCK_SIZE);
 	while ((nbytes = walk->nbytes) >= AES_BLOCK_SIZE) {
 		out = walk->dst.virt.addr;
 		in = walk->src.virt.addr;
 		while (nbytes >= AES_BLOCK_SIZE) {
-			/* only use complete blocks, max. PAGE_SIZE */
-			n = (nbytes > PAGE_SIZE) ? PAGE_SIZE :
-						 nbytes & ~(AES_BLOCK_SIZE - 1);
-			for (i = AES_BLOCK_SIZE; i < n; i += AES_BLOCK_SIZE) {
-				memcpy(ctrblk + i, ctrblk + i - AES_BLOCK_SIZE,
-				       AES_BLOCK_SIZE);
-				crypto_inc(ctrblk + i, AES_BLOCK_SIZE);
-			}
-			ret = crypt_s390_kmctr(func, sctx->key, out, in, n, ctrblk);
-			if (ret < 0 || ret != n)
+			if (ctrptr == ctrblk)
+				n = __ctrblk_init(ctrptr, nbytes);
+			else
+				n = AES_BLOCK_SIZE;
+			ret = crypt_s390_kmctr(func, sctx->key, out, in,
+					       n, ctrptr);
+			if (ret < 0 || ret != n) {
+				if (ctrptr == ctrblk)
+					spin_unlock(&ctrblk_lock);
 				return -EIO;
+			}
 			if (n > AES_BLOCK_SIZE)
-				memcpy(ctrblk, ctrblk + n - AES_BLOCK_SIZE,
+				memcpy(ctrptr, ctrptr + n - AES_BLOCK_SIZE,
 				       AES_BLOCK_SIZE);
-			crypto_inc(ctrblk, AES_BLOCK_SIZE);
+			crypto_inc(ctrptr, AES_BLOCK_SIZE);
 			out += n;
 			in += n;
 			nbytes -= n;
 		}
 		ret = blkcipher_walk_done(desc, walk, nbytes);
 	}
+	if (ctrptr == ctrblk) {
+		if (nbytes)
+			memcpy(ctrbuf, ctrptr, AES_BLOCK_SIZE);
+		else
+			memcpy(walk->iv, ctrptr, AES_BLOCK_SIZE);
+		spin_unlock(&ctrblk_lock);
+	}
 	/*
 	 * final block may be < AES_BLOCK_SIZE, copy only nbytes
 	 */
@@ -804,14 +830,15 @@ static int ctr_aes_crypt(struct blkcipher_desc *desc, long func,
 		out = walk->dst.virt.addr;
 		in = walk->src.virt.addr;
 		ret = crypt_s390_kmctr(func, sctx->key, buf, in,
-				       AES_BLOCK_SIZE, ctrblk);
+				       AES_BLOCK_SIZE, ctrbuf);
 		if (ret < 0 || ret != AES_BLOCK_SIZE)
 			return -EIO;
 		memcpy(out, buf, nbytes);
-		crypto_inc(ctrblk, AES_BLOCK_SIZE);
+		crypto_inc(ctrbuf, AES_BLOCK_SIZE);
 		ret = blkcipher_walk_done(desc, walk, 0);
+		memcpy(walk->iv, ctrbuf, AES_BLOCK_SIZE);
 	}
-	memcpy(walk->iv, ctrblk, AES_BLOCK_SIZE);
+
 	return ret;
 }
 
diff --git a/arch/s390/crypto/des_s390.c b/arch/s390/crypto/des_s390.c
index 00d649c..991fb7d 100644
--- a/arch/s390/crypto/des_s390.c
+++ b/arch/s390/crypto/des_s390.c
@@ -25,6 +25,7 @@
 #define DES3_KEY_SIZE	(3 * DES_KEY_SIZE)
 
 static u8 *ctrblk;
+static DEFINE_SPINLOCK(ctrblk_lock);
 
 struct s390_des_ctx {
 	u8 iv[DES_BLOCK_SIZE];
@@ -106,29 +107,35 @@ static int ecb_desall_crypt(struct blkcipher_desc *desc, long func,
 }
 
 static int cbc_desall_crypt(struct blkcipher_desc *desc, long func,
-			    u8 *iv, struct blkcipher_walk *walk)
+			    struct blkcipher_walk *walk)
 {
+	struct s390_des_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
 	int ret = blkcipher_walk_virt(desc, walk);
 	unsigned int nbytes = walk->nbytes;
+	struct {
+		u8 iv[DES_BLOCK_SIZE];
+		u8 key[DES3_KEY_SIZE];
+	} param;
 
 	if (!nbytes)
 		goto out;
 
-	memcpy(iv, walk->iv, DES_BLOCK_SIZE);
+	memcpy(param.iv, walk->iv, DES_BLOCK_SIZE);
+	memcpy(param.key, ctx->key, DES3_KEY_SIZE);
 	do {
 		/* only use complete blocks */
 		unsigned int n = nbytes & ~(DES_BLOCK_SIZE - 1);
 		u8 *out = walk->dst.virt.addr;
 		u8 *in = walk->src.virt.addr;
 
-		ret = crypt_s390_kmc(func, iv, out, in, n);
+		ret = crypt_s390_kmc(func, &param, out, in, n);
 		if (ret < 0 || ret != n)
 			return -EIO;
 
 		nbytes &= DES_BLOCK_SIZE - 1;
 		ret = blkcipher_walk_done(desc, walk, nbytes);
 	} while ((nbytes = walk->nbytes));
-	memcpy(walk->iv, iv, DES_BLOCK_SIZE);
+	memcpy(walk->iv, param.iv, DES_BLOCK_SIZE);
 
 out:
 	return ret;
@@ -181,22 +188,20 @@ static int cbc_des_encrypt(struct blkcipher_desc *desc,
 			   struct scatterlist *dst, struct scatterlist *src,
 			   unsigned int nbytes)
 {
-	struct s390_des_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return cbc_desall_crypt(desc, KMC_DEA_ENCRYPT, ctx->iv, &walk);
+	return cbc_desall_crypt(desc, KMC_DEA_ENCRYPT, &walk);
 }
 
 static int cbc_des_decrypt(struct blkcipher_desc *desc,
 			   struct scatterlist *dst, struct scatterlist *src,
 			   unsigned int nbytes)
 {
-	struct s390_des_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return cbc_desall_crypt(desc, KMC_DEA_DECRYPT, ctx->iv, &walk);
+	return cbc_desall_crypt(desc, KMC_DEA_DECRYPT, &walk);
 }
 
 static struct crypto_alg cbc_des_alg = {
@@ -333,22 +338,20 @@ static int cbc_des3_encrypt(struct blkcipher_desc *desc,
 			    struct scatterlist *dst, struct scatterlist *src,
 			    unsigned int nbytes)
 {
-	struct s390_des_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return cbc_desall_crypt(desc, KMC_TDEA_192_ENCRYPT, ctx->iv, &walk);
+	return cbc_desall_crypt(desc, KMC_TDEA_192_ENCRYPT, &walk);
 }
 
 static int cbc_des3_decrypt(struct blkcipher_desc *desc,
 			    struct scatterlist *dst, struct scatterlist *src,
 			    unsigned int nbytes)
 {
-	struct s390_des_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return cbc_desall_crypt(desc, KMC_TDEA_192_DECRYPT, ctx->iv, &walk);
+	return cbc_desall_crypt(desc, KMC_TDEA_192_DECRYPT, &walk);
 }
 
 static struct crypto_alg cbc_des3_alg = {
@@ -374,54 +377,80 @@ static struct crypto_alg cbc_des3_alg = {
 	}
 };
 
+static unsigned int __ctrblk_init(u8 *ctrptr, unsigned int nbytes)
+{
+	unsigned int i, n;
+
+	/* align to block size, max. PAGE_SIZE */
+	n = (nbytes > PAGE_SIZE) ? PAGE_SIZE : nbytes & ~(DES_BLOCK_SIZE - 1);
+	for (i = DES_BLOCK_SIZE; i < n; i += DES_BLOCK_SIZE) {
+		memcpy(ctrptr + i, ctrptr + i - DES_BLOCK_SIZE, DES_BLOCK_SIZE);
+		crypto_inc(ctrptr + i, DES_BLOCK_SIZE);
+	}
+	return n;
+}
+
 static int ctr_desall_crypt(struct blkcipher_desc *desc, long func,
-			    struct s390_des_ctx *ctx, struct blkcipher_walk *walk)
+			    struct s390_des_ctx *ctx,
+			    struct blkcipher_walk *walk)
 {
 	int ret = blkcipher_walk_virt_block(desc, walk, DES_BLOCK_SIZE);
-	unsigned int i, n, nbytes;
-	u8 buf[DES_BLOCK_SIZE];
-	u8 *out, *in;
+	unsigned int n, nbytes;
+	u8 buf[DES_BLOCK_SIZE], ctrbuf[DES_BLOCK_SIZE];
+	u8 *out, *in, *ctrptr = ctrbuf;
+
+	if (!walk->nbytes)
+		return ret;
 
-	memcpy(ctrblk, walk->iv, DES_BLOCK_SIZE);
+	if (spin_trylock(&ctrblk_lock))
+		ctrptr = ctrblk;
+
+	memcpy(ctrptr, walk->iv, DES_BLOCK_SIZE);
 	while ((nbytes = walk->nbytes) >= DES_BLOCK_SIZE) {
 		out = walk->dst.virt.addr;
 		in = walk->src.virt.addr;
 		while (nbytes >= DES_BLOCK_SIZE) {
-			/* align to block size, max. PAGE_SIZE */
-			n = (nbytes > PAGE_SIZE) ? PAGE_SIZE :
-				nbytes & ~(DES_BLOCK_SIZE - 1);
-			for (i = DES_BLOCK_SIZE; i < n; i += DES_BLOCK_SIZE) {
-				memcpy(ctrblk + i, ctrblk + i - DES_BLOCK_SIZE,
-				       DES_BLOCK_SIZE);
-				crypto_inc(ctrblk + i, DES_BLOCK_SIZE);
-			}
-			ret = crypt_s390_kmctr(func, ctx->key, out, in, n, ctrblk);
-			if (ret < 0 || ret != n)
+			if (ctrptr == ctrblk)
+				n = __ctrblk_init(ctrptr, nbytes);
+			else
+				n = DES_BLOCK_SIZE;
+			ret = crypt_s390_kmctr(func, ctx->key, out, in,
+					       n, ctrptr);
+			if (ret < 0 || ret != n) {
+				if (ctrptr == ctrblk)
+					spin_unlock(&ctrblk_lock);
 				return -EIO;
+			}
 			if (n > DES_BLOCK_SIZE)
-				memcpy(ctrblk, ctrblk + n - DES_BLOCK_SIZE,
+				memcpy(ctrptr, ctrptr + n - DES_BLOCK_SIZE,
 				       DES_BLOCK_SIZE);
-			crypto_inc(ctrblk, DES_BLOCK_SIZE);
+			crypto_inc(ctrptr, DES_BLOCK_SIZE);
 			out += n;
 			in += n;
 			nbytes -= n;
 		}
 		ret = blkcipher_walk_done(desc, walk, nbytes);
 	}
-
+	if (ctrptr == ctrblk) {
+		if (nbytes)
+			memcpy(ctrbuf, ctrptr, DES_BLOCK_SIZE);
+		else
+			memcpy(walk->iv, ctrptr, DES_BLOCK_SIZE);
+		spin_unlock(&ctrblk_lock);
+	}
 	/* final block may be < DES_BLOCK_SIZE, copy only nbytes */
 	if (nbytes) {
 		out = walk->dst.virt.addr;
 		in = walk->src.virt.addr;
 		ret = crypt_s390_kmctr(func, ctx->key, buf, in,
-				       DES_BLOCK_SIZE, ctrblk);
+				       DES_BLOCK_SIZE, ctrbuf);
 		if (ret < 0 || ret != DES_BLOCK_SIZE)
 			return -EIO;
 		memcpy(out, buf, nbytes);
-		crypto_inc(ctrblk, DES_BLOCK_SIZE);
+		crypto_inc(ctrbuf, DES_BLOCK_SIZE);
 		ret = blkcipher_walk_done(desc, walk, 0);
+		memcpy(walk->iv, ctrbuf, DES_BLOCK_SIZE);
 	}
-	memcpy(walk->iv, ctrblk, DES_BLOCK_SIZE);
 	return ret;
 }
 
diff --git a/arch/s390/kernel/head64.S b/arch/s390/kernel/head64.S
index 99348c0..78be245 100644
--- a/arch/s390/kernel/head64.S
+++ b/arch/s390/kernel/head64.S
@@ -61,7 +61,7 @@ ENTRY(startup_continue)
 	.quad	0			# cr12: tracing off
 	.quad	0			# cr13: home space segment table
 	.quad	0xc0000000		# cr14: machine check handling off
-	.quad	0			# cr15: linkage stack operations
+	.quad	.Llinkage_stack		# cr15: linkage stack operations
 .Lpcmsk:.quad	0x0000000180000000
 .L4malign:.quad 0xffffffffffc00000
 .Lscan2g:.quad	0x80000000 + 0x20000 - 8	# 2GB + 128K - 8
@@ -69,12 +69,15 @@ ENTRY(startup_continue)
 .Lparmaddr:
 	.quad	PARMAREA
 	.align	64
-.Lduct: .long	0,0,0,0,.Lduald,0,0,0
+.Lduct: .long	0,.Laste,.Laste,0,.Lduald,0,0,0
 	.long	0,0,0,0,0,0,0,0
+.Laste:	.quad	0,0xffffffffffffffff,0,0,0,0,0,0
 	.align	128
 .Lduald:.rept	8
 	.long	0x80000000,0,0,0	# invalid access-list entries
 	.endr
+.Llinkage_stack:
+	.long	0,0,0x89000000,0,0,0,0x8a000000,0
 
 ENTRY(_ehead)
 
diff --git a/arch/s390/mm/page-states.c b/arch/s390/mm/page-states.c
index a90d45e..27c50f4 100644
--- a/arch/s390/mm/page-states.c
+++ b/arch/s390/mm/page-states.c
@@ -12,6 +12,8 @@
 #include <linux/mm.h>
 #include <linux/gfp.h>
 #include <linux/init.h>
+#include <asm/setup.h>
+#include <asm/ipl.h>
 
 #define ESSA_SET_STABLE		1
 #define ESSA_SET_UNUSED		2
@@ -41,6 +43,14 @@ void __init cmma_init(void)
 
 	if (!cmma_flag)
 		return;
+	/*
+	 * Disable CMM for dump, otherwise  the tprot based memory
+	 * detection can fail because of unstable pages.
+	 */
+	if (OLDMEM_BASE || ipl_info.type == IPL_TYPE_FCP_DUMP) {
+		cmma_flag = 0;
+		return;
+	}
 	asm volatile(
 		"       .insn rrf,0xb9ab0000,%1,%1,0,0\n"
 		"0:     la      %0,0\n"
diff --git a/block/blk-lib.c b/block/blk-lib.c
index 2b461b4..36751e2 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -101,6 +101,14 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 
 		atomic_inc(&bb.done);
 		submit_bio(type, bio);
+
+		/*
+		 * We can loop for a long time in here, if someone does
+		 * full device discards (like mkfs). Be nice and allow
+		 * us to schedule out to avoid softlocking if preempt
+		 * is disabled.
+		 */
+		cond_resched();
 	}
 
 	/* Wait for bios in-flight */
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 77795cf..5630e99 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -427,17 +427,19 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	/* Marvell */
 	{ PCI_VDEVICE(MARVELL, 0x6145), board_ahci_mv },	/* 6145 */
 	{ PCI_VDEVICE(MARVELL, 0x6121), board_ahci_mv },	/* 6121 */
-	{ PCI_DEVICE(0x1b4b, 0x9123),
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9123),
 	  .class = PCI_CLASS_STORAGE_SATA_AHCI,
 	  .class_mask = 0xffffff,
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9128 */
-	{ PCI_DEVICE(0x1b4b, 0x9125),
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9125),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9125 */
-	{ PCI_DEVICE(0x1b4b, 0x917a),
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x917a),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 */
-	{ PCI_DEVICE(0x1b4b, 0x9192),
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9172),
+	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 */
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9192),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 on some Gigabyte */
-	{ PCI_DEVICE(0x1b4b, 0x91a3),
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x91a3),
 	  .driver_data = board_ahci_yes_fbs },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9230),
 	  .driver_data = board_ahci_yes_fbs },
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 1188f4e..73fb731 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1341,13 +1341,16 @@ static void blkback_changed(struct xenbus_device *dev,
 	case XenbusStateReconfiguring:
 	case XenbusStateReconfigured:
 	case XenbusStateUnknown:
-	case XenbusStateClosed:
 		break;
 
 	case XenbusStateConnected:
 		blkfront_connect(info);
 		break;
 
+	case XenbusStateClosed:
+		if (dev->state == XenbusStateClosed)
+			break;
+		/* Missed the backend's Closing state -- fallthrough */
 	case XenbusStateClosing:
 		blkfront_closing(info);
 		break;
diff --git a/drivers/char/raw.c b/drivers/char/raw.c
index 54a3a6d..5959669 100644
--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -190,7 +190,7 @@ static int bind_get(int number, dev_t *dev)
 	struct raw_device_data *rawdev;
 	struct block_device *bdev;
 
-	if (number <= 0 || number >= MAX_RAW_MINORS)
+	if (number <= 0 || number >= max_raw_minors)
 		return -EINVAL;
 
 	rawdev = &raw_devices[number];
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index de5ba86e..5d4321e 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -483,7 +483,8 @@ static void edac_mc_workq_function(struct work_struct *work_req)
  *
  *		called with the mem_ctls_mutex held
  */
-static void edac_mc_workq_setup(struct mem_ctl_info *mci, unsigned msec)
+static void edac_mc_workq_setup(struct mem_ctl_info *mci, unsigned msec,
+				bool init)
 {
 	debugf0("%s()\n", __func__);
 
@@ -491,7 +492,9 @@ static void edac_mc_workq_setup(struct mem_ctl_info *mci, unsigned msec)
 	if (mci->op_state != OP_RUNNING_POLL)
 		return;
 
-	INIT_DELAYED_WORK(&mci->work, edac_mc_workq_function);
+	if (init)
+		INIT_DELAYED_WORK(&mci->work, edac_mc_workq_function);
+
 	queue_delayed_work(edac_workqueue, &mci->work, msecs_to_jiffies(msec));
 }
 
@@ -551,7 +554,7 @@ void edac_mc_reset_delay_period(int value)
 	list_for_each(item, &mc_devices) {
 		mci = list_entry(item, struct mem_ctl_info, link);
 
-		edac_mc_workq_setup(mci, (unsigned long) value);
+		edac_mc_workq_setup(mci, (unsigned long) value, false);
 	}
 
 	mutex_unlock(&mem_ctls_mutex);
@@ -700,7 +703,7 @@ int edac_mc_add_mc(struct mem_ctl_info *mci)
 		/* This instance is NOW RUNNING */
 		mci->op_state = OP_RUNNING_POLL;
 
-		edac_mc_workq_setup(mci, edac_mc_get_poll_msec());
+		edac_mc_workq_setup(mci, edac_mc_get_poll_msec(), true);
 	} else {
 		mci->op_state = OP_RUNNING_INTERRUPT;
 	}
diff --git a/drivers/gpu/drm/mgag200/mgag200_mode.c b/drivers/gpu/drm/mgag200/mgag200_mode.c
index f780f2c..74886ee 100644
--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -1487,11 +1487,11 @@ static int mga_vga_mode_valid(struct drm_connector *connector,
 		(mga_vga_calculate_mode_bandwidth(mode, bpp)
 			> (32700 * 1024))) {
 		return MODE_BANDWIDTH;
-	} else if (mode->type == G200_EH &&
+	} else if (mdev->type == G200_EH &&
 		(mga_vga_calculate_mode_bandwidth(mode, bpp)
 			> (37500 * 1024))) {
 		return MODE_BANDWIDTH;
-	} else if (mode->type == G200_ER &&
+	} else if (mdev->type == G200_ER &&
 		(mga_vga_calculate_mode_bandwidth(mode,
 			bpp) > (55000 * 1024))) {
 		return MODE_BANDWIDTH;
diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index c881e74..a7bbde9 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -2279,6 +2279,11 @@ static int qib_7322_bringup_serdes(struct qib_pportdata *ppd)
 	qib_write_kreg_port(ppd, krp_ibcctrl_a, ppd->cpspec->ibcctrl_a);
 	qib_write_kreg(dd, kr_scratch, 0ULL);
 
+	/* ensure previous Tx parameters are not still forced */
+	qib_write_kreg_port(ppd, krp_tx_deemph_override,
+		SYM_MASK(IBSD_TX_DEEMPHASIS_OVERRIDE_0,
+		reset_tx_deemphasis_override));
+
 	if (qib_compat_ddr_negotiate) {
 		ppd->cpspec->ibdeltainprog = 1;
 		ppd->cpspec->ibsymsnap = read_7322_creg32_port(ppd,
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 10f122a..da4dc25 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -185,8 +185,12 @@ config MD_FAULTY
 
 	  In unsure, say N.
 
+config BLK_DEV_DM_BUILTIN
+	boolean
+
 config BLK_DEV_DM
 	tristate "Device mapper support"
+	select BLK_DEV_DM_BUILTIN
 	---help---
 	  Device-mapper is a low level volume manager.  It works by allowing
 	  people to specify mappings for ranges of logical sectors.  Various
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 8b2e0df..4e87c54 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_MD_MULTIPATH)	+= multipath.o
 obj-$(CONFIG_MD_FAULTY)		+= faulty.o
 obj-$(CONFIG_BLK_DEV_MD)	+= md-mod.o
 obj-$(CONFIG_BLK_DEV_DM)	+= dm-mod.o
+obj-$(CONFIG_BLK_DEV_DM_BUILTIN) += dm-builtin.o
 obj-$(CONFIG_DM_BUFIO)		+= dm-bufio.o
 obj-$(CONFIG_DM_CRYPT)		+= dm-crypt.o
 obj-$(CONFIG_DM_DELAY)		+= dm-delay.o
diff --git a/drivers/md/dm-builtin.c b/drivers/md/dm-builtin.c
new file mode 100644
index 0000000..797daec
--- /dev/null
+++ b/drivers/md/dm-builtin.c
@@ -0,0 +1,50 @@
+#include "dm.h"
+
+#include <linux/export.h>
+
+/*
+ * The kobject release method must not be placed in the module itself,
+ * otherwise we are subject to module unload races.
+ *
+ * The release method is called when the last reference to the kobject is
+ * dropped. It may be called by any other kernel code that drops the last
+ * reference.
+ *
+ * The release method suffers from module unload race. We may prevent the
+ * module from being unloaded at the start of the release method (using
+ * increased module reference count or synchronizing against the release
+ * method), however there is no way to prevent the module from being
+ * unloaded at the end of the release method.
+ *
+ * If this code were placed in the dm module, the following race may
+ * happen:
+ *  1. Some other process takes a reference to dm kobject
+ *  2. The user issues ioctl function to unload the dm device
+ *  3. dm_sysfs_exit calls kobject_put, however the object is not released
+ *     because of the other reference taken at step 1
+ *  4. dm_sysfs_exit waits on the completion
+ *  5. The other process that took the reference in step 1 drops it,
+ *     dm_kobject_release is called from this process
+ *  6. dm_kobject_release calls complete()
+ *  7. a reschedule happens before dm_kobject_release returns
+ *  8. dm_sysfs_exit continues, the dm device is unloaded, module reference
+ *     count is decremented
+ *  9. The user unloads the dm module
+ * 10. The other process that was rescheduled in step 7 continues to run,
+ *     it is now executing code in unloaded module, so it crashes
+ *
+ * Note that if the process that takes the foreign reference to dm kobject
+ * has a low priority and the system is sufficiently loaded with
+ * higher-priority processes that prevent the low-priority process from
+ * being scheduled long enough, this bug may really happen.
+ *
+ * In order to fix this module unload race, we place the release method
+ * into a helper code that is compiled directly into the kernel.
+ */
+
+void dm_kobject_release(struct kobject *kobj)
+{
+	complete(dm_get_completion_from_kobject(kobj));
+}
+
+EXPORT_SYMBOL(dm_kobject_release);
diff --git a/drivers/md/dm-sysfs.c b/drivers/md/dm-sysfs.c
index e0cc5d6..c62c5ab 100644
--- a/drivers/md/dm-sysfs.c
+++ b/drivers/md/dm-sysfs.c
@@ -79,11 +79,6 @@ static const struct sysfs_ops dm_sysfs_ops = {
 	.show	= dm_attr_show,
 };
 
-static void dm_kobject_release(struct kobject *kobj)
-{
-	complete(dm_get_completion_from_kobject(kobj));
-}
-
 /*
  * dm kobject is embedded in mapped_device structure
  * no need to define release function here
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 062f89a..f65ae26 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -191,11 +191,8 @@ struct mapped_device {
 	/* forced geometry settings */
 	struct hd_geometry geometry;
 
-	/* sysfs handle */
-	struct kobject kobj;
-
-	/* wait until the kobject is released */
-	struct completion kobj_completion;
+	/* kobject and completion */
+	struct dm_kobject_holder kobj_holder;
 
 	/* zero-length flush that will be cloned and submitted to targets */
 	struct bio flush_bio;
@@ -1901,7 +1898,7 @@ static struct mapped_device *alloc_dev(int minor)
 	init_waitqueue_head(&md->wait);
 	INIT_WORK(&md->work, dm_wq_work);
 	init_waitqueue_head(&md->eventq);
-	init_completion(&md->kobj_completion);
+	init_completion(&md->kobj_holder.completion);
 
 	md->disk->major = _major;
 	md->disk->first_minor = minor;
@@ -2693,20 +2690,14 @@ struct gendisk *dm_disk(struct mapped_device *md)
 
 struct kobject *dm_kobject(struct mapped_device *md)
 {
-	return &md->kobj;
+	return &md->kobj_holder.kobj;
 }
 
-/*
- * struct mapped_device should not be exported outside of dm.c
- * so use this check to verify that kobj is part of md structure
- */
 struct mapped_device *dm_get_from_kobject(struct kobject *kobj)
 {
 	struct mapped_device *md;
 
-	md = container_of(kobj, struct mapped_device, kobj);
-	if (&md->kobj != kobj)
-		return NULL;
+	md = container_of(kobj, struct mapped_device, kobj_holder.kobj);
 
 	if (test_bit(DMF_FREEING, &md->flags) ||
 	    dm_deleting_md(md))
@@ -2716,13 +2707,6 @@ struct mapped_device *dm_get_from_kobject(struct kobject *kobj)
 	return md;
 }
 
-struct completion *dm_get_completion_from_kobject(struct kobject *kobj)
-{
-	struct mapped_device *md = container_of(kobj, struct mapped_device, kobj);
-
-	return &md->kobj_completion;
-}
-
 int dm_suspended_md(struct mapped_device *md)
 {
 	return test_bit(DMF_SUSPENDED, &md->flags);
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 1174e96..9db80c9 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -16,6 +16,7 @@
 #include <linux/blkdev.h>
 #include <linux/hdreg.h>
 #include <linux/completion.h>
+#include <linux/kobject.h>
 
 /*
  * Suspend feature flags
@@ -120,11 +121,25 @@ void dm_interface_exit(void);
 /*
  * sysfs interface
  */
+struct dm_kobject_holder {
+	struct kobject kobj;
+	struct completion completion;
+};
+
+static inline struct completion *dm_get_completion_from_kobject(struct kobject *kobj)
+{
+	return &container_of(kobj, struct dm_kobject_holder, kobj)->completion;
+}
+
 int dm_sysfs_init(struct mapped_device *md);
 void dm_sysfs_exit(struct mapped_device *md);
 struct kobject *dm_kobject(struct mapped_device *md);
 struct mapped_device *dm_get_from_kobject(struct kobject *kobj);
-struct completion *dm_get_completion_from_kobject(struct kobject *kobj);
+
+/*
+ * The kobject helper
+ */
+void dm_kobject_release(struct kobject *kobj);
 
 /*
  * Targets for linear and striped mappings
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index eb0f9ea..a42eda2 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4737,23 +4737,43 @@ raid5_size(struct mddev *mddev, sector_t sectors, int raid_disks)
 	return sectors * (raid_disks - conf->max_degraded);
 }
 
+static void free_scratch_buffer(struct r5conf *conf, struct raid5_percpu *percpu)
+{
+	safe_put_page(percpu->spare_page);
+	kfree(percpu->scribble);
+	percpu->spare_page = NULL;
+	percpu->scribble = NULL;
+}
+
+static int alloc_scratch_buffer(struct r5conf *conf, struct raid5_percpu *percpu)
+{
+	if (conf->level == 6 && !percpu->spare_page)
+		percpu->spare_page = alloc_page(GFP_KERNEL);
+	if (!percpu->scribble)
+		percpu->scribble = kmalloc(conf->scribble_len, GFP_KERNEL);
+
+	if (!percpu->scribble || (conf->level == 6 && !percpu->spare_page)) {
+		free_scratch_buffer(conf, percpu);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
 static void raid5_free_percpu(struct r5conf *conf)
 {
-	struct raid5_percpu *percpu;
 	unsigned long cpu;
 
 	if (!conf->percpu)
 		return;
 
-	get_online_cpus();
-	for_each_possible_cpu(cpu) {
-		percpu = per_cpu_ptr(conf->percpu, cpu);
-		safe_put_page(percpu->spare_page);
-		kfree(percpu->scribble);
-	}
 #ifdef CONFIG_HOTPLUG_CPU
 	unregister_cpu_notifier(&conf->cpu_notify);
 #endif
+
+	get_online_cpus();
+	for_each_possible_cpu(cpu)
+		free_scratch_buffer(conf, per_cpu_ptr(conf->percpu, cpu));
 	put_online_cpus();
 
 	free_percpu(conf->percpu);
@@ -4779,15 +4799,7 @@ static int raid456_cpu_notify(struct notifier_block *nfb, unsigned long action,
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		if (conf->level == 6 && !percpu->spare_page)
-			percpu->spare_page = alloc_page(GFP_KERNEL);
-		if (!percpu->scribble)
-			percpu->scribble = kmalloc(conf->scribble_len, GFP_KERNEL);
-
-		if (!percpu->scribble ||
-		    (conf->level == 6 && !percpu->spare_page)) {
-			safe_put_page(percpu->spare_page);
-			kfree(percpu->scribble);
+		if (alloc_scratch_buffer(conf, percpu)) {
 			pr_err("%s: failed memory allocation for cpu%ld\n",
 			       __func__, cpu);
 			return notifier_from_errno(-ENOMEM);
@@ -4795,10 +4807,7 @@ static int raid456_cpu_notify(struct notifier_block *nfb, unsigned long action,
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		safe_put_page(percpu->spare_page);
-		kfree(percpu->scribble);
-		percpu->spare_page = NULL;
-		percpu->scribble = NULL;
+		free_scratch_buffer(conf, per_cpu_ptr(conf->percpu, cpu));
 		break;
 	default:
 		break;
@@ -4810,40 +4819,29 @@ static int raid456_cpu_notify(struct notifier_block *nfb, unsigned long action,
 static int raid5_alloc_percpu(struct r5conf *conf)
 {
 	unsigned long cpu;
-	struct page *spare_page;
-	struct raid5_percpu __percpu *allcpus;
-	void *scribble;
-	int err;
+	int err = 0;
 
-	allcpus = alloc_percpu(struct raid5_percpu);
-	if (!allcpus)
+	conf->percpu = alloc_percpu(struct raid5_percpu);
+	if (!conf->percpu)
 		return -ENOMEM;
-	conf->percpu = allcpus;
+
+#ifdef CONFIG_HOTPLUG_CPU
+	conf->cpu_notify.notifier_call = raid456_cpu_notify;
+	conf->cpu_notify.priority = 0;
+	err = register_cpu_notifier(&conf->cpu_notify);
+	if (err)
+		return err;
+#endif
 
 	get_online_cpus();
-	err = 0;
 	for_each_present_cpu(cpu) {
-		if (conf->level == 6) {
-			spare_page = alloc_page(GFP_KERNEL);
-			if (!spare_page) {
-				err = -ENOMEM;
-				break;
-			}
-			per_cpu_ptr(conf->percpu, cpu)->spare_page = spare_page;
-		}
-		scribble = kmalloc(conf->scribble_len, GFP_KERNEL);
-		if (!scribble) {
-			err = -ENOMEM;
+		err = alloc_scratch_buffer(conf, per_cpu_ptr(conf->percpu, cpu));
+		if (err) {
+			pr_err("%s: failed memory allocation for cpu%ld\n",
+			       __func__, cpu);
 			break;
 		}
-		per_cpu_ptr(conf->percpu, cpu)->scribble = scribble;
 	}
-#ifdef CONFIG_HOTPLUG_CPU
-	conf->cpu_notify.notifier_call = raid456_cpu_notify;
-	conf->cpu_notify.priority = 0;
-	if (err == 0)
-		err = register_cpu_notifier(&conf->cpu_notify);
-#endif
 	put_online_cpus();
 
 	return err;
diff --git a/drivers/media/dvb/dvb-usb/mxl111sf-tuner.h b/drivers/media/dvb/dvb-usb/mxl111sf-tuner.h
index ff33396..10b93c4 100644
--- a/drivers/media/dvb/dvb-usb/mxl111sf-tuner.h
+++ b/drivers/media/dvb/dvb-usb/mxl111sf-tuner.h
@@ -69,7 +69,7 @@ struct dvb_frontend *mxl111sf_tuner_attach(struct dvb_frontend *fe,
 #else
 static inline
 struct dvb_frontend *mxl111sf_tuner_attach(struct dvb_frontend *fe,
-					   struct mxl111sf_state *mxl_state
+					   struct mxl111sf_state *mxl_state,
 					   struct mxl111sf_tuner_config *cfg)
 {
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
diff --git a/drivers/media/dvb/dvb-usb/mxl111sf.c b/drivers/media/dvb/dvb-usb/mxl111sf.c
index cd84279..086fb8a 100644
--- a/drivers/media/dvb/dvb-usb/mxl111sf.c
+++ b/drivers/media/dvb/dvb-usb/mxl111sf.c
@@ -101,7 +101,7 @@ int mxl111sf_read_reg(struct mxl111sf_state *state, u8 addr, u8 *data)
 		ret = -EINVAL;
 	}
 
-	deb_reg("R: (0x%02x, 0x%02x)\n", addr, *data);
+	deb_reg("R: (0x%02x, 0x%02x)\n", addr, buf[1]);
 fail:
 	return ret;
 }
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 29641e7..b53c7f0 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -30,6 +30,10 @@ int htc_modparam_nohwcrypt;
 module_param_named(nohwcrypt, htc_modparam_nohwcrypt, int, 0444);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption");
 
+static int ath9k_ps_enable;
+module_param_named(ps_enable, ath9k_ps_enable, int, 0444);
+MODULE_PARM_DESC(ps_enable, "Enable WLAN PowerSave");
+
 #define CHAN2G(_freq, _idx)  { \
 	.center_freq = (_freq), \
 	.hw_value = (_idx), \
@@ -699,11 +703,13 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 		IEEE80211_HW_SPECTRUM_MGMT |
 		IEEE80211_HW_HAS_RATE_CONTROL |
 		IEEE80211_HW_RX_INCLUDES_FCS |
-		IEEE80211_HW_SUPPORTS_PS |
 		IEEE80211_HW_PS_NULLFUNC_STACK |
 		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
 		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING;
 
+	if (ath9k_ps_enable)
+		hw->flags |= IEEE80211_HW_SUPPORTS_PS;
+
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC) |
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 9aa005e..a933eb2 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -46,6 +46,10 @@ static int ath9k_btcoex_enable;
 module_param_named(btcoex_enable, ath9k_btcoex_enable, int, 0444);
 MODULE_PARM_DESC(btcoex_enable, "Enable wifi-BT coexistence");
 
+static int ath9k_ps_enable;
+module_param_named(ps_enable, ath9k_ps_enable, int, 0444);
+MODULE_PARM_DESC(ps_enable, "Enable WLAN PowerSave");
+
 bool is_ath9k_unloaded;
 /* We use the hw_value as an index into our private channel structure */
 
@@ -673,11 +677,13 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 		IEEE80211_HW_SIGNAL_DBM |
-		IEEE80211_HW_SUPPORTS_PS |
 		IEEE80211_HW_PS_NULLFUNC_STACK |
 		IEEE80211_HW_SPECTRUM_MGMT |
 		IEEE80211_HW_REPORTS_TX_ACK_STATUS;
 
+	if (ath9k_ps_enable)
+		hw->flags |= IEEE80211_HW_SUPPORTS_PS;
+
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT)
 		 hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
 
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index fa7c0f0..caeddd4 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1974,6 +1974,9 @@ void pci_free_cap_save_buffers(struct pci_dev *dev)
 /**
  * pci_enable_ari - enable ARI forwarding if hardware support it
  * @dev: the PCI device
+ *
+ * If @dev and its upstream bridge both support ARI, enable ARI in the
+ * bridge.  Otherwise, disable ARI in the bridge.
  */
 void pci_enable_ari(struct pci_dev *dev)
 {
@@ -1985,10 +1988,6 @@ void pci_enable_ari(struct pci_dev *dev)
 	if (pcie_ari_disabled || !pci_is_pcie(dev) || dev->devfn)
 		return;
 
-	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ARI);
-	if (!pos)
-		return;
-
 	bridge = dev->bus->self;
 	if (!bridge || !pci_is_pcie(bridge))
 		return;
@@ -2007,10 +2006,14 @@ void pci_enable_ari(struct pci_dev *dev)
 		return;
 
 	pci_read_config_word(bridge, pos + PCI_EXP_DEVCTL2, &ctrl);
-	ctrl |= PCI_EXP_DEVCTL2_ARI;
+	if (pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ARI)) {
+		ctrl |= PCI_EXP_DEVCTL2_ARI;
+		bridge->ari_enabled = 1;
+	} else {
+		ctrl &= ~PCI_EXP_DEVCTL2_ARI;
+		bridge->ari_enabled = 0;
+	}
 	pci_write_config_word(bridge, pos + PCI_EXP_DEVCTL2, ctrl);
-
-	bridge->ari_enabled = 1;
 }
 
 /**
diff --git a/drivers/power/max17040_battery.c b/drivers/power/max17040_battery.c
index c284143..ec8b948 100644
--- a/drivers/power/max17040_battery.c
+++ b/drivers/power/max17040_battery.c
@@ -148,7 +148,7 @@ static void max17040_get_online(struct i2c_client *client)
 {
 	struct max17040_chip *chip = i2c_get_clientdata(client);
 
-	if (chip->pdata->battery_online)
+	if (chip->pdata && chip->pdata->battery_online)
 		chip->online = chip->pdata->battery_online();
 	else
 		chip->online = 1;
@@ -158,7 +158,8 @@ static void max17040_get_status(struct i2c_client *client)
 {
 	struct max17040_chip *chip = i2c_get_clientdata(client);
 
-	if (!chip->pdata->charger_online || !chip->pdata->charger_enable) {
+	if (!chip->pdata || !chip->pdata->charger_online
+			|| !chip->pdata->charger_enable) {
 		chip->status = POWER_SUPPLY_STATUS_UNKNOWN;
 		return;
 	}
diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 6a4adf7..d76a77c 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -34,11 +34,11 @@
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
 #include <linux/platform_device.h>
-#include <linux/mod_devicetable.h>
 #include <linux/log2.h>
 #include <linux/pm.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
+#include <linux/dmi.h>
 
 /* this is for "generic access to PC-style RTC" using CMOS_READ/CMOS_WRITE */
 #include <asm-generic/rtc.h>
@@ -377,6 +377,51 @@ static int cmos_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 	return 0;
 }
 
+/*
+ * Do not disable RTC alarm on shutdown - workaround for b0rked BIOSes.
+ */
+static bool alarm_disable_quirk;
+
+static int __init set_alarm_disable_quirk(const struct dmi_system_id *id)
+{
+	alarm_disable_quirk = true;
+	pr_info("rtc-cmos: BIOS has alarm-disable quirk. ");
+	pr_info("RTC alarms disabled\n");
+	return 0;
+}
+
+static const struct dmi_system_id rtc_quirks[] __initconst = {
+	/* https://bugzilla.novell.com/show_bug.cgi?id=805740 */
+	{
+		.callback = set_alarm_disable_quirk,
+		.ident    = "IBM Truman",
+		.matches  = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "4852570"),
+		},
+	},
+	/* https://bugzilla.novell.com/show_bug.cgi?id=812592 */
+	{
+		.callback = set_alarm_disable_quirk,
+		.ident    = "Gigabyte GA-990XA-UD3",
+		.matches  = {
+			DMI_MATCH(DMI_SYS_VENDOR,
+					"Gigabyte Technology Co., Ltd."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "GA-990XA-UD3"),
+		},
+	},
+	/* http://permalink.gmane.org/gmane.linux.kernel/1604474 */
+	{
+		.callback = set_alarm_disable_quirk,
+		.ident    = "Toshiba Satellite L300",
+		.matches  = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Satellite L300"),
+		},
+	},
+	{}
+};
+
 static int cmos_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
@@ -385,6 +430,9 @@ static int cmos_alarm_irq_enable(struct device *dev, unsigned int enabled)
 	if (!is_valid_irq(cmos->irq))
 		return -EINVAL;
 
+	if (alarm_disable_quirk)
+		return 0;
+
 	spin_lock_irqsave(&rtc_lock, flags);
 
 	if (enabled)
@@ -1169,6 +1217,8 @@ static int __init cmos_init(void)
 			platform_driver_registered = true;
 	}
 
+	dmi_check_system(rtc_quirks);
+
 	if (retval == 0)
 		return 0;
 
diff --git a/drivers/spi/spi-nuc900.c b/drivers/spi/spi-nuc900.c
index dae8be2..f244d19 100644
--- a/drivers/spi/spi-nuc900.c
+++ b/drivers/spi/spi-nuc900.c
@@ -374,6 +374,8 @@ static int __devinit nuc900_spi_probe(struct platform_device *pdev)
 	init_completion(&hw->done);
 
 	master->mode_bits          = SPI_MODE_0;
+	if (hw->pdata->lsb)
+		master->mode_bits |= SPI_LSB_FIRST;
 	master->num_chipselect     = hw->pdata->num_cs;
 	master->bus_num            = hw->pdata->bus_num;
 	hw->bitbang.master         = hw->master;
diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index de8c98c..555790c 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -387,6 +387,7 @@ static int pci171x_insn_write_ao(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn, unsigned int *data)
 {
+	unsigned int val;
 	int n, chan, range, ofs;
 
 	chan = CR_CHAN(insn->chanspec);
@@ -402,11 +403,14 @@ static int pci171x_insn_write_ao(struct comedi_device *dev,
 		outw(devpriv->da_ranges, dev->iobase + PCI171x_DAREF);
 		ofs = PCI171x_DA1;
 	}
+	val = devpriv->ao_data[chan];
 
-	for (n = 0; n < insn->n; n++)
-		outw(data[n], dev->iobase + ofs);
+	for (n = 0; n < insn->n; n++) {
+		val = data[n];
+		outw(val, dev->iobase + ofs);
+	}
 
-	devpriv->ao_data[chan] = data[n];
+	devpriv->ao_data[chan] = val;
 
 	return n;
 
@@ -555,6 +559,7 @@ static int pci1720_insn_write_ao(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn, unsigned int *data)
 {
+	unsigned int val;
 	int n, rangereg, chan;
 
 	chan = CR_CHAN(insn->chanspec);
@@ -564,13 +569,15 @@ static int pci1720_insn_write_ao(struct comedi_device *dev,
 		outb(rangereg, dev->iobase + PCI1720_RANGE);
 		devpriv->da_ranges = rangereg;
 	}
+	val = devpriv->ao_data[chan];
 
 	for (n = 0; n < insn->n; n++) {
-		outw(data[n], dev->iobase + PCI1720_DA0 + (chan << 1));
+		val = data[n];
+		outw(val, dev->iobase + PCI1720_DA0 + (chan << 1));
 		outb(0, dev->iobase + PCI1720_SYNCOUT);	/*  update outputs */
 	}
 
-	devpriv->ao_data[chan] = data[n];
+	devpriv->ao_data[chan] = val;
 
 	return n;
 }
diff --git a/drivers/staging/iio/adc/ad799x_core.c b/drivers/staging/iio/adc/ad799x_core.c
index 80e0c6e..b50d1df 100644
--- a/drivers/staging/iio/adc/ad799x_core.c
+++ b/drivers/staging/iio/adc/ad799x_core.c
@@ -911,7 +911,8 @@ static int __devinit ad799x_probe(struct i2c_client *client,
 	return 0;
 
 error_free_irq:
-	free_irq(client->irq, indio_dev);
+	if (client->irq > 0)
+		free_irq(client->irq, indio_dev);
 error_cleanup_ring:
 	ad799x_ring_cleanup(indio_dev);
 error_disable_reg:
diff --git a/drivers/staging/iio/magnetometer/ak8975.c b/drivers/staging/iio/magnetometer/ak8975.c
index 5834e4a..575256b 100644
--- a/drivers/staging/iio/magnetometer/ak8975.c
+++ b/drivers/staging/iio/magnetometer/ak8975.c
@@ -82,6 +82,7 @@
  */
 #define AK8975_MAX_CONVERSION_TIMEOUT	500
 #define AK8975_CONVERSION_DONE_POLL_TIME 10
+#define RAW_TO_GAUSS(asa) ((((asa) + 128) * 3000) / 256)
 
 /*
  * Per-instance context data for the device.
@@ -223,15 +224,15 @@ static int ak8975_setup(struct i2c_client *client)
  *
  * Since 1uT = 100 gauss, our final scale factor becomes:
  *
- * Hadj = H * ((ASA + 128) / 256) * 3/10 * 100
- * Hadj = H * ((ASA + 128) * 30 / 256
+ * Hadj = H * ((ASA + 128) / 256) * 3/10 * 1/100
+ * Hadj = H * ((ASA + 128) * 0.003) / 256
  *
  * Since ASA doesn't change, we cache the resultant scale factor into the
  * device context in ak8975_setup().
  */
-	data->raw_to_gauss[0] = ((data->asa[0] + 128) * 30) >> 8;
-	data->raw_to_gauss[1] = ((data->asa[1] + 128) * 30) >> 8;
-	data->raw_to_gauss[2] = ((data->asa[2] + 128) * 30) >> 8;
+	data->raw_to_gauss[0] = RAW_TO_GAUSS(data->asa[0]);
+	data->raw_to_gauss[1] = RAW_TO_GAUSS(data->asa[1]);
+	data->raw_to_gauss[2] = RAW_TO_GAUSS(data->asa[2]);
 
 	return 0;
 }
@@ -434,8 +435,9 @@ static int ak8975_read_raw(struct iio_dev *indio_dev,
 	case IIO_CHAN_INFO_RAW:
 		return ak8975_read_axis(indio_dev, chan->address, val);
 	case IIO_CHAN_INFO_SCALE:
-		*val = data->raw_to_gauss[chan->address];
-		return IIO_VAL_INT;
+		*val = 0;
+		*val2 = data->raw_to_gauss[chan->address];
+		return IIO_VAL_INT_PLUS_MICRO;
 	}
 	return -EINVAL;
 }
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 4a418e4..acc0eab 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1091,6 +1091,7 @@ static void gsm_control_modem(struct gsm_mux *gsm, u8 *data, int clen)
 {
 	unsigned int addr = 0;
 	unsigned int modem = 0;
+	unsigned int brk = 0;
 	struct gsm_dlci *dlci;
 	int len = clen;
 	u8 *dp = data;
@@ -1117,6 +1118,16 @@ static void gsm_control_modem(struct gsm_mux *gsm, u8 *data, int clen)
 		if (len == 0)
 			return;
 	}
+	len--;
+	if (len > 0) {
+		while (gsm_read_ea(&brk, *dp++) == 0) {
+			len--;
+			if (len == 0)
+				return;
+		}
+		modem <<= 7;
+		modem |= (brk & 0x7f);
+	}
 	tty = tty_port_tty_get(&dlci->port);
 	gsm_process_modem(tty, dlci, modem, clen);
 	if (tty) {
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index a8c59c1..7aca79a 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -138,6 +138,11 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 		xhci_dbg(xhci, "QUIRK: Resetting on resume\n");
 		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
 	}
+	if (pdev->vendor == PCI_VENDOR_ID_RENESAS &&
+			pdev->device == 0x0015 &&
+			pdev->subsystem_vendor == PCI_VENDOR_ID_SAMSUNG &&
+			pdev->subsystem_device == 0xc0cd)
+		xhci->quirks |= XHCI_RESET_ON_RESUME;
 	if (pdev->vendor == PCI_VENDOR_ID_VIA)
 		xhci->quirks |= XHCI_RESET_ON_RESUME;
 }
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 82c392f..ab8b689 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -163,6 +163,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_CANUSB_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CANDAPTER_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_NXTCAM_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_EV3CON_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SCS_DEVICE_0_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SCS_DEVICE_1_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SCS_DEVICE_2_PID) },
@@ -202,6 +203,8 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_IOBOARD_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_MINI_IOBOARD_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SPROG_II) },
+	{ USB_DEVICE(FTDI_VID, FTDI_TAGSYS_LP101_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_TAGSYS_P200X_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_LENZ_LIUSB_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_XF_632_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_XF_634_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index a7019d1..1e2d369 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -50,6 +50,7 @@
 #define TI_XDS100V2_PID		0xa6d0
 
 #define FTDI_NXTCAM_PID		0xABB8 /* NXTCam for Mindstorms NXT */
+#define FTDI_EV3CON_PID		0xABB9 /* Mindstorms EV3 Console Adapter */
 
 /* US Interface Navigator (http://www.usinterface.com/) */
 #define FTDI_USINT_CAT_PID	0xb810	/* Navigator CAT and 2nd PTT lines */
@@ -363,6 +364,12 @@
 /* Sprog II (Andrew Crosland's SprogII DCC interface) */
 #define FTDI_SPROG_II		0xF0C8
 
+/*
+ * Two of the Tagsys RFID Readers
+ */
+#define FTDI_TAGSYS_LP101_PID	0xF0E9	/* Tagsys L-P101 RFID*/
+#define FTDI_TAGSYS_P200X_PID	0xF0EE	/* Tagsys Medio P200x RFID*/
+
 /* an infrared receiver for user access control with IR tags */
 #define FTDI_PIEGROUP_PID	0xF208	/* Product Id */
 
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 83b50db..e681037 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1376,7 +1376,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1267, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1268, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1269, 0xff, 0xff, 0xff) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1270, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1270, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&net_intf5_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1271, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1272, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1273, 0xff, 0xff, 0xff) },
diff --git a/drivers/usb/storage/Kconfig b/drivers/usb/storage/Kconfig
index 685edc8..144386b 100644
--- a/drivers/usb/storage/Kconfig
+++ b/drivers/usb/storage/Kconfig
@@ -19,7 +19,9 @@ config USB_STORAGE
 
 	  This option depends on 'SCSI' support being enabled, but you
 	  probably also need 'SCSI device support: SCSI disk support'
-	  (BLK_DEV_SD) for most USB storage devices.
+	  (BLK_DEV_SD) for most USB storage devices.  Some devices also
+	  will require 'Probe all LUNs on each SCSI device'
+	  (SCSI_MULTI_LUN).
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called usb-storage.
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index a6e4c4a..bacb37b 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -78,6 +78,8 @@ static const char* host_info(struct Scsi_Host *host)
 
 static int slave_alloc (struct scsi_device *sdev)
 {
+	struct us_data *us = host_to_us(sdev->host);
+
 	/*
 	 * Set the INQUIRY transfer length to 36.  We don't use any of
 	 * the extra data and many devices choke if asked for more or
@@ -102,6 +104,10 @@ static int slave_alloc (struct scsi_device *sdev)
 	 */
 	blk_queue_update_dma_alignment(sdev->request_queue, (512 - 1));
 
+	/* Tell the SCSI layer if we know there is more than one LUN */
+	if (us->protocol == USB_PR_BULK && us->max_lun > 0)
+		sdev->sdev_bflags |= BLIST_FORCELUN;
+
 	return 0;
 }
 
diff --git a/drivers/usb/storage/unusual_cypress.h b/drivers/usb/storage/unusual_cypress.h
index 65a6a75..82e8ed0 100644
--- a/drivers/usb/storage/unusual_cypress.h
+++ b/drivers/usb/storage/unusual_cypress.h
@@ -31,7 +31,7 @@ UNUSUAL_DEV(  0x04b4, 0x6831, 0x0000, 0x9999,
 		"Cypress ISD-300LP",
 		USB_SC_CYP_ATACB, USB_PR_DEVICE, NULL, 0),
 
-UNUSUAL_DEV( 0x14cd, 0x6116, 0x0000, 0x0219,
+UNUSUAL_DEV( 0x14cd, 0x6116, 0x0160, 0x0160,
 		"Super Top",
 		"USB 2.0  SATA BRIDGE",
 		USB_SC_CYP_ATACB, USB_PR_DEVICE, NULL, 0),
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index d904c59..e72f39a 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1441,6 +1441,13 @@ UNUSUAL_DEV( 0x0f88, 0x042e, 0x0100, 0x0100,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_FIX_CAPACITY ),
 
+/* Reported by Moritz Moeller-Herrmann <moritz-kernel@moeller-herrmann.de> */
+UNUSUAL_DEV(  0x0fca, 0x8004, 0x0201, 0x0201,
+		"Research In Motion",
+		"BlackBerry Bold 9000",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_MAX_SECTORS_64 ),
+
 /* Reported by Michael Stattmann <michael@stattmann.com> */
 UNUSUAL_DEV(  0x0fce, 0xd008, 0x0000, 0x0000,
 		"Sony Ericsson",
diff --git a/drivers/vme/bridges/vme_ca91cx42.c b/drivers/vme/bridges/vme_ca91cx42.c
index e0df92e..7ee77a2 100644
--- a/drivers/vme/bridges/vme_ca91cx42.c
+++ b/drivers/vme/bridges/vme_ca91cx42.c
@@ -882,7 +882,7 @@ static ssize_t ca91cx42_master_read(struct vme_master_resource *image,
 		if (done == count)
 			goto out;
 	}
-	if ((uintptr_t)addr & 0x2) {
+	if ((uintptr_t)(addr + done) & 0x2) {
 		if ((count - done) < 2) {
 			*(u8 *)(buf + done) = ioread8(addr + done);
 			done += 1;
@@ -936,7 +936,7 @@ static ssize_t ca91cx42_master_write(struct vme_master_resource *image,
 		if (done == count)
 			goto out;
 	}
-	if ((uintptr_t)addr & 0x2) {
+	if ((uintptr_t)(addr + done) & 0x2) {
 		if ((count - done) < 2) {
 			iowrite8(*(u8 *)(buf + done), addr + done);
 			done += 1;
diff --git a/fs/buffer.c b/fs/buffer.c
index 2c78739..01d673c 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -613,14 +613,16 @@ EXPORT_SYMBOL(mark_buffer_dirty_inode);
 static void __set_page_dirty(struct page *page,
 		struct address_space *mapping, int warn)
 {
-	spin_lock_irq(&mapping->tree_lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&mapping->tree_lock, flags);
 	if (page->mapping) {	/* Race with truncate? */
 		WARN_ON_ONCE(warn && !PageUptodate(page));
 		account_page_dirtied(page, mapping);
 		radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);
 	}
-	spin_unlock_irq(&mapping->tree_lock);
+	spin_unlock_irqrestore(&mapping->tree_lock, flags);
 	__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
 }
 
diff --git a/fs/file.c b/fs/file.c
index ba3f605..d512ca5 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -47,7 +47,7 @@ static void *alloc_fdmem(size_t size)
 	 * vmalloc() if the allocation size will be considered "large" by the VM.
 	 */
 	if (size <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER)) {
-		void *data = kmalloc(size, GFP_KERNEL|__GFP_NOWARN);
+		void *data = kmalloc(size, GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY);
 		if (data != NULL)
 			return data;
 	}
diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
index aff1c61..43ccfd6 100644
--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -769,6 +769,7 @@ nlmsvc_grant_blocked(struct nlm_block *block)
 	struct nlm_file		*file = block->b_file;
 	struct nlm_lock		*lock = &block->b_call->a_args.lock;
 	int			error;
+	loff_t			fl_start, fl_end;
 
 	dprintk("lockd: grant blocked lock %p\n", block);
 
@@ -786,9 +787,16 @@ nlmsvc_grant_blocked(struct nlm_block *block)
 	}
 
 	/* Try the lock operation again */
+	/* vfs_lock_file() can mangle fl_start and fl_end, but we need
+	 * them unchanged for the GRANT_MSG
+	 */
 	lock->fl.fl_flags |= FL_SLEEP;
+	fl_start = lock->fl.fl_start;
+	fl_end = lock->fl.fl_end;
 	error = vfs_lock_file(file->f_file, F_SETLK, &lock->fl, NULL);
 	lock->fl.fl_flags &= ~FL_SLEEP;
+	lock->fl.fl_start = fl_start;
+	lock->fl.fl_end = fl_end;
 
 	switch (error) {
 	case 0:
diff --git a/include/linux/sched.h b/include/linux/sched.h
index be28098..c980fa7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1203,6 +1203,7 @@ struct sched_entity {
 struct sched_rt_entity {
 	struct list_head run_list;
 	unsigned long timeout;
+	unsigned long watchdog_stamp;
 	unsigned int time_slice;
 
 	struct sched_rt_entity *back;
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 192a302..8ab8e93 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -274,6 +274,7 @@ struct irq_desc *irq_to_desc(unsigned int irq)
 {
 	return (irq < NR_IRQS) ? irq_desc + irq : NULL;
 }
+EXPORT_SYMBOL(irq_to_desc);
 
 static void free_desc(unsigned int irq)
 {
diff --git a/kernel/printk.c b/kernel/printk.c
index e959512..0d430b1 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1827,7 +1827,6 @@ static int __cpuinit console_cpu_notify(struct notifier_block *self,
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_DEAD:
-	case CPU_DYING:
 	case CPU_DOWN_FAILED:
 	case CPU_UP_CANCELED:
 		console_lock();
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 281f186..57d8625 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5357,9 +5357,6 @@ static void migrate_tasks(unsigned int dead_cpu)
 	 */
 	rq->stop = NULL;
 
-	/* Ensure any throttled groups are reachable by pick_next_task */
-	unthrottle_offline_cfs_rqs(rq);
-
 	for ( ; ; ) {
 		/*
 		 * There's this thread running, bail when that's the only
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9e2fe1b..7963693 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2071,7 +2071,7 @@ static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 	hrtimer_cancel(&cfs_b->slack_timer);
 }
 
-void unthrottle_offline_cfs_rqs(struct rq *rq)
+static void unthrottle_offline_cfs_rqs(struct rq *rq)
 {
 	struct cfs_rq *cfs_rq;
 
@@ -2125,7 +2125,7 @@ static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
 	return NULL;
 }
 static inline void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
-void unthrottle_offline_cfs_rqs(struct rq *rq) {}
+static inline void unthrottle_offline_cfs_rqs(struct rq *rq) {}
 
 #endif /* CONFIG_CFS_BANDWIDTH */
 
@@ -4910,6 +4910,9 @@ static void rq_online_fair(struct rq *rq)
 static void rq_offline_fair(struct rq *rq)
 {
 	update_sysctl();
+
+	/* Ensure any throttled groups are reachable by pick_next_task */
+	unthrottle_offline_cfs_rqs(rq);
 }
 
 #endif /* CONFIG_SMP */
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 8480912..6b46fb1 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -691,6 +691,7 @@ balanced:
 		 * runtime - in which case borrowing doesn't make sense.
 		 */
 		rt_rq->rt_runtime = RUNTIME_INF;
+		rt_rq->rt_throttled = 0;
 		raw_spin_unlock(&rt_rq->rt_runtime_lock);
 		raw_spin_unlock(&rt_b->rt_runtime_lock);
 	}
@@ -788,6 +789,19 @@ static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 	const struct cpumask *span;
 
 	span = sched_rt_period_mask();
+#ifdef CONFIG_RT_GROUP_SCHED
+	/*
+	 * FIXME: isolated CPUs should really leave the root task group,
+	 * whether they are isolcpus or were isolated via cpusets, lest
+	 * the timer run on a CPU which does not service all runqueues,
+	 * potentially leaving other CPUs indefinitely throttled.  If
+	 * isolation is really required, the user will turn the throttle
+	 * off to kill the perturbations it causes anyway.  Meanwhile,
+	 * this maintains functionality for boot and/or troubleshooting.
+	 */
+	if (rt_b == &root_task_group.rt_bandwidth)
+		span = cpu_online_mask;
+#endif
 	for_each_cpu(i, span) {
 		int enqueue = 0;
 		struct rt_rq *rt_rq = sched_rt_period_rt_rq(rt_b, i);
@@ -1990,7 +2004,11 @@ static void watchdog(struct rq *rq, struct task_struct *p)
 	if (soft != RLIM_INFINITY) {
 		unsigned long next;
 
-		p->rt.timeout++;
+		if (p->rt.watchdog_stamp != jiffies) {
+			p->rt.timeout++;
+			p->rt.watchdog_stamp = jiffies;
+		}
+
 		next = DIV_ROUND_UP(min(soft, hard), USEC_PER_SEC/HZ);
 		if (p->rt.timeout > next)
 			p->cputime_expires.sched_exp = p->se.sum_exec_runtime;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 65bd8a8..400391f 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1140,7 +1140,6 @@ extern void print_rt_stats(struct seq_file *m, int cpu);
 
 extern void init_cfs_rq(struct cfs_rq *cfs_rq);
 extern void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq);
-extern void unthrottle_offline_cfs_rqs(struct rq *rq);
 
 extern void cfs_bandwidth_usage_inc(void);
 extern void cfs_bandwidth_usage_dec(void);
diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index a470154..955560e 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -51,7 +51,13 @@
  * HZ shrinks, so values greater than 8 overflow 32bits when
  * HZ=100.
  */
+#if HZ < 34
+#define JIFFIES_SHIFT	6
+#elif HZ < 67
+#define JIFFIES_SHIFT	7
+#else
 #define JIFFIES_SHIFT	8
+#endif
 
 static cycle_t jiffies_read(struct clocksource *cs)
 {
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 8954990..3988562 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -986,7 +986,8 @@ static void timekeeping_adjust(s64 offset)
  *
  * Returns the unconsumed cycles.
  */
-static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
+static cycle_t logarithmic_accumulation(cycle_t offset, int shift,
+							unsigned int *clock_set)
 {
 	u64 nsecps = (u64)NSEC_PER_SEC << timekeeper.shift;
 	u64 raw_nsecs;
@@ -1008,7 +1009,7 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 		timekeeper.xtime.tv_sec += leap;
 		timekeeper.wall_to_monotonic.tv_sec -= leap;
 		if (leap)
-			clock_was_set_delayed();
+			*clock_set = 1;
 	}
 
 	/* Accumulate raw time */
@@ -1040,6 +1041,7 @@ static void update_wall_time(void)
 	struct clocksource *clock;
 	cycle_t offset;
 	int shift = 0, maxshift;
+	unsigned int clock_set = 0;
 	unsigned long flags;
 
 	write_seqlock_irqsave(&timekeeper.lock, flags);
@@ -1076,7 +1078,7 @@ static void update_wall_time(void)
 	maxshift = (64 - (ilog2(ntp_tick_length())+1)) - 1;
 	shift = min(shift, maxshift);
 	while (offset >= timekeeper.cycle_interval) {
-		offset = logarithmic_accumulation(offset, shift);
+		offset = logarithmic_accumulation(offset, shift, &clock_set);
 		if(offset < timekeeper.cycle_interval<<shift)
 			shift--;
 	}
@@ -1130,7 +1132,7 @@ static void update_wall_time(void)
 		timekeeper.xtime.tv_sec += leap;
 		timekeeper.wall_to_monotonic.tv_sec -= leap;
 		if (leap)
-			clock_was_set_delayed();
+			clock_set = 1;
 	}
 
 	timekeeping_update(false);
@@ -1138,6 +1140,8 @@ static void update_wall_time(void)
 out:
 	write_sequnlock_irqrestore(&timekeeper.lock, flags);
 
+	if (clock_set)
+		clock_was_set_delayed();
 }
 
 /**
@@ -1192,7 +1196,7 @@ void get_monotonic_boottime(struct timespec *ts)
 	} while (read_seqretry(&timekeeper.lock, seq));
 
 	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec + sleep.tv_sec,
-			ts->tv_nsec + tomono.tv_nsec + sleep.tv_nsec + nsecs);
+		(s64)ts->tv_nsec + tomono.tv_nsec + sleep.tv_nsec + nsecs);
 }
 EXPORT_SYMBOL_GPL(get_monotonic_boottime);
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 524243e..05dc549 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -222,6 +222,29 @@ static void update_global_ops(void)
 	global_ops.func = func;
 }
 
+static void ftrace_sync(struct work_struct *work)
+{
+	/*
+	 * This function is just a stub to implement a hard force
+	 * of synchronize_sched(). This requires synchronizing
+	 * tasks even in userspace and idle.
+	 *
+	 * Yes, function tracing is rude.
+	 */
+}
+
+static void ftrace_sync_ipi(void *data)
+{
+	/* Probably not needed, but do it anyway */
+	smp_rmb();
+}
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+static void update_function_graph_func(void);
+#else
+static inline void update_function_graph_func(void) { }
+#endif
+
 static void update_ftrace_function(void)
 {
 	ftrace_func_t func;
@@ -240,6 +263,8 @@ static void update_ftrace_function(void)
 	else
 		func = ftrace_ops_list_func;
 
+	update_function_graph_func();
+
 #ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	ftrace_trace_function = func;
 #else
@@ -359,16 +384,6 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 	} else if (ops->flags & FTRACE_OPS_FL_CONTROL) {
 		ret = remove_ftrace_list_ops(&ftrace_control_list,
 					     &control_ops, ops);
-		if (!ret) {
-			/*
-			 * The ftrace_ops is now removed from the list,
-			 * so there'll be no new users. We must ensure
-			 * all current users are done before we free
-			 * the control data.
-			 */
-			synchronize_sched();
-			control_ops_free(ops);
-		}
 	} else
 		ret = remove_ftrace_ops(&ftrace_ops_list, ops);
 
@@ -378,13 +393,6 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 	if (ftrace_enabled)
 		update_ftrace_function();
 
-	/*
-	 * Dynamic ops may be freed, we must make sure that all
-	 * callers are done before leaving this function.
-	 */
-	if (ops->flags & FTRACE_OPS_FL_DYNAMIC)
-		synchronize_sched();
-
 	return 0;
 }
 
@@ -1998,10 +2006,41 @@ static int ftrace_shutdown(struct ftrace_ops *ops, int command)
 		command |= FTRACE_UPDATE_TRACE_FUNC;
 	}
 
-	if (!command || !ftrace_enabled)
+	if (!command || !ftrace_enabled) {
+		/*
+		 * If these are control ops, they still need their
+		 * per_cpu field freed. Since, function tracing is
+		 * not currently active, we can just free them
+		 * without synchronizing all CPUs.
+		 */
+		if (ops->flags & FTRACE_OPS_FL_CONTROL)
+			control_ops_free(ops);
 		return 0;
+	}
 
 	ftrace_run_update_code(command);
+
+	/*
+	 * Dynamic ops may be freed, we must make sure that all
+	 * callers are done before leaving this function.
+	 * The same goes for freeing the per_cpu data of the control
+	 * ops.
+	 *
+	 * Again, normal synchronize_sched() is not good enough.
+	 * We need to do a hard force of sched synchronization.
+	 * This is because we use preempt_disable() to do RCU, but
+	 * the function tracers can be called where RCU is not watching
+	 * (like before user_exit()). We can not rely on the RCU
+	 * infrastructure to do the synchronization, thus we must do it
+	 * ourselves.
+	 */
+	if (ops->flags & (FTRACE_OPS_FL_DYNAMIC | FTRACE_OPS_FL_CONTROL)) {
+		schedule_on_each_cpu(ftrace_sync);
+
+		if (ops->flags & FTRACE_OPS_FL_CONTROL)
+			control_ops_free(ops);
+	}
+
 	return 0;
 }
 
@@ -4451,6 +4490,7 @@ int ftrace_graph_entry_stub(struct ftrace_graph_ent *trace)
 trace_func_graph_ret_t ftrace_graph_return =
 			(trace_func_graph_ret_t)ftrace_stub;
 trace_func_graph_ent_t ftrace_graph_entry = ftrace_graph_entry_stub;
+static trace_func_graph_ent_t __ftrace_graph_entry = ftrace_graph_entry_stub;
 
 /* Try to assign a return stack array on FTRACE_RETSTACK_ALLOC_SIZE tasks. */
 static int alloc_retstack_tasklist(struct ftrace_ret_stack **ret_stack_list)
@@ -4591,6 +4631,30 @@ static struct ftrace_ops fgraph_ops __read_mostly = {
 	.flags		= FTRACE_OPS_FL_GLOBAL,
 };
 
+static int ftrace_graph_entry_test(struct ftrace_graph_ent *trace)
+{
+	if (!ftrace_ops_test(&global_ops, trace->func))
+		return 0;
+	return __ftrace_graph_entry(trace);
+}
+
+/*
+ * The function graph tracer should only trace the functions defined
+ * by set_ftrace_filter and set_ftrace_notrace. If another function
+ * tracer ops is registered, the graph tracer requires testing the
+ * function against the global ops, and not just trace any function
+ * that any ftrace_ops registered.
+ */
+static void update_function_graph_func(void)
+{
+	if (ftrace_ops_list == &ftrace_list_end ||
+	    (ftrace_ops_list == &global_ops &&
+	     global_ops.next == &ftrace_list_end))
+		ftrace_graph_entry = __ftrace_graph_entry;
+	else
+		ftrace_graph_entry = ftrace_graph_entry_test;
+}
+
 int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 			trace_func_graph_ent_t entryfunc)
 {
@@ -4615,7 +4679,16 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 	}
 
 	ftrace_graph_return = retfunc;
-	ftrace_graph_entry = entryfunc;
+
+	/*
+	 * Update the indirect function to the entryfunc, and the
+	 * function that gets called to the entry_test first. Then
+	 * call the update fgraph entry function to determine if
+	 * the entryfunc should be called directly or not.
+	 */
+	__ftrace_graph_entry = entryfunc;
+	ftrace_graph_entry = ftrace_graph_entry_test;
+	update_function_graph_func();
 
 	ret = ftrace_startup(&fgraph_ops, FTRACE_START_FUNC_RET);
 
@@ -4634,6 +4707,7 @@ void unregister_ftrace_graph(void)
 	ftrace_graph_active--;
 	ftrace_graph_return = (trace_func_graph_ret_t)ftrace_stub;
 	ftrace_graph_entry = ftrace_graph_entry_stub;
+	__ftrace_graph_entry = ftrace_graph_entry_stub;
 	ftrace_shutdown(&fgraph_ops, FTRACE_STOP_FUNC_RET);
 	unregister_pm_notifier(&ftrace_suspend_notifier);
 	unregister_trace_sched_switch(ftrace_graph_probe_sched_switch, NULL);
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 35bf8f7..177fa4a 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2236,6 +2236,13 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 	write &= RB_WRITE_MASK;
 	tail = write - length;
 
+	/*
+	 * If this is the first commit on the page, then it has the same
+	 * timestamp as the page itself.
+	 */
+	if (!tail)
+		delta = 0;
+
 	/* See if we shot pass the end of this buffer page */
 	if (unlikely(write > BUF_PAGE_SIZE))
 		return rb_move_tail(cpu_buffer, length, tail,
diff --git a/lib/Makefile b/lib/Makefile
index 8c31a0c..f1ab4e00 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -41,6 +41,7 @@ obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
 lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
 lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
 
+GCOV_PROFILE_hweight.o := n
 CFLAGS_hweight.o = $(subst $(quote),,$(CONFIG_ARCH_HWEIGHT_CFLAGS))
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 31ea8e2..82a1891 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1987,11 +1987,12 @@ int __set_page_dirty_nobuffers(struct page *page)
 	if (!TestSetPageDirty(page)) {
 		struct address_space *mapping = page_mapping(page);
 		struct address_space *mapping2;
+		unsigned long flags;
 
 		if (!mapping)
 			return 1;
 
-		spin_lock_irq(&mapping->tree_lock);
+		spin_lock_irqsave(&mapping->tree_lock, flags);
 		mapping2 = page_mapping(page);
 		if (mapping2) { /* Race with truncate? */
 			BUG_ON(mapping2 != mapping);
@@ -2000,7 +2001,7 @@ int __set_page_dirty_nobuffers(struct page *page)
 			radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);
 		}
-		spin_unlock_irq(&mapping->tree_lock);
+		spin_unlock_irqrestore(&mapping->tree_lock, flags);
 		if (mapping->host) {
 			/* !PageAnon && !swapper_space */
 			__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 71373d0..222928f 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1642,7 +1642,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->max = 0;
 	swap_map = p->swap_map;
 	p->swap_map = NULL;
-	p->flags = 0;
 	frontswap_invalidate_area(type);
 	spin_unlock(&swap_lock);
 	mutex_unlock(&swapon_mutex);
@@ -1662,6 +1661,16 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 		mutex_unlock(&inode->i_mutex);
 	}
 	filp_close(swap_file, NULL);
+
+	/*
+	 * Clear the SWP_USED flag after all resources are freed so that swapon
+	 * can reuse this swap_info in alloc_swap_info() safely.  It is ok to
+	 * not hold p->lock after we cleared its SWP_WRITEOK.
+	 */
+	spin_lock(&swap_lock);
+	p->flags = 0;
+	spin_unlock(&swap_lock);
+
 	err = 0;
 	atomic_inc(&proc_poll_event);
 	wake_up_interruptible(&proc_poll_wait);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 79cfca3..df9e376 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -909,7 +909,7 @@ static int ieee80211_fragment(struct ieee80211_tx_data *tx,
 	}
 
 	/* adjust first fragment's length */
-	skb->len = hdrlen + per_fragm;
+	skb_trim(skb, hdrlen + per_fragm);
 	return 0;
 }
 
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 5759751..73ca97a 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -186,8 +186,8 @@ static void do_usb_entry(struct usb_device_id *id,
 				range_lo < 0x9 ? "[%X-9" : "[%X",
 				range_lo);
 			sprintf(alias + strlen(alias),
-				range_hi > 0xA ? "a-%X]" : "%X]",
-				range_lo);
+				range_hi > 0xA ? "A-%X]" : "%X]",
+				range_hi);
 		}
 	}
 	if (bcdDevice_initial_digits < (sizeof(id->bcdDevice_lo) * 2 - 1))
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 4321b8f..c0c3e4e 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -1231,6 +1231,10 @@ static int security_context_to_sid_core(const char *scontext, u32 scontext_len,
 	struct context context;
 	int rc = 0;
 
+	/* An empty security context is never valid. */
+	if (!scontext_len)
+		return -EINVAL;
+
 	if (!ss_initialized) {
 		int i;
 
diff --git a/sound/pci/hda/patch_analog.c b/sound/pci/hda/patch_analog.c
index b1180b5..65e0494 100644
--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -3575,6 +3575,8 @@ static const char * const ad1884_slave_vols[] = {
 static int patch_ad1884(struct hda_codec *codec)
 {
 	struct ad198x_spec *spec;
+	static hda_nid_t conn_0c[] = { 0x08 };
+	static hda_nid_t conn_0d[] = { 0x09 };
 	int err;
 
 	spec = kzalloc(sizeof(*spec), GFP_KERNEL);
@@ -3590,6 +3592,10 @@ static int patch_ad1884(struct hda_codec *codec)
 	}
 	set_beep_amp(spec, 0x10, 0, HDA_OUTPUT);
 
+	/* limit the loopback routes not to confuse the parser */
+	snd_hda_override_conn_list(codec, 0x0c, ARRAY_SIZE(conn_0c), conn_0c);
+	snd_hda_override_conn_list(codec, 0x0d, ARRAY_SIZE(conn_0d), conn_0d);
+
 	spec->multiout.max_channels = 2;
 	spec->multiout.num_dacs = ARRAY_SIZE(ad1884_dac_nids);
 	spec->multiout.dac_nids = ad1884_dac_nids;
diff --git a/sound/usb/Kconfig b/sound/usb/Kconfig
index ff77b28..b861391d 100644
--- a/sound/usb/Kconfig
+++ b/sound/usb/Kconfig
@@ -14,6 +14,7 @@ config SND_USB_AUDIO
 	select SND_HWDEP
 	select SND_RAWMIDI
 	select SND_PCM
+	select BITREVERSE
 	help
 	  Say Y here to include support for USB audio and USB MIDI
 	  devices.
diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 88b2fe3..00d8642 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -154,17 +154,13 @@ int kvm_vm_ioctl_register_coalesced_mmio(struct kvm *kvm,
 	list_add_tail(&dev->list, &kvm->coalesced_zones);
 	mutex_unlock(&kvm->slots_lock);
 
-	return ret;
+	return 0;
 
 out_free_dev:
 	mutex_unlock(&kvm->slots_lock);
-
 	kfree(dev);
 
-	if (dev == NULL)
-		return -ENXIO;
-
-	return 0;
+	return ret;
 }
 
 int kvm_vm_ioctl_unregister_coalesced_mmio(struct kvm *kvm,
