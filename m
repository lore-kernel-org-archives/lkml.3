Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab3LJJ5N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:57:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41107 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab3LJJ4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:56:43 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: Re: [3.5.y.z extended stable] Linux 3.5.7.27
Date: Tue, 10 Dec 2013 09:56:32 +0000
Message-Id: <1386669392-7234-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386669392-7234-1-git-send-email-luis.henriques@canonical.com>
References: <1386669392-7234-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 8a0c61d..ab9a201 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 5
 SUBLEVEL = 7
-EXTRAVERSION = .26
+EXTRAVERSION = .27
 NAME = Saber-toothed Squirrel
 
 # *DOCUMENTATION*
diff --git a/arch/arm/mach-imx/clk-imx6q.c b/arch/arm/mach-imx/clk-imx6q.c
index e1a17ac..cca5799 100644
--- a/arch/arm/mach-imx/clk-imx6q.c
+++ b/arch/arm/mach-imx/clk-imx6q.c
@@ -278,7 +278,7 @@ int __init mx6q_clocks_init(void)
 	clk[asrc_podf]        = imx_clk_divider("asrc_podf",        "asrc_pred",         base + 0x30, 9,  3);
 	clk[spdif_pred]       = imx_clk_divider("spdif_pred",       "spdif_sel",         base + 0x30, 25, 3);
 	clk[spdif_podf]       = imx_clk_divider("spdif_podf",       "spdif_pred",        base + 0x30, 22, 3);
-	clk[can_root]         = imx_clk_divider("can_root",         "pll3_usb_otg",      base + 0x20, 2,  6);
+	clk[can_root]         = imx_clk_divider("can_root",         "pll3_60m",          base + 0x20, 2,  6);
 	clk[ecspi_root]       = imx_clk_divider("ecspi_root",       "pll3_60m",          base + 0x38, 19, 6);
 	clk[gpu2d_core_podf]  = imx_clk_divider("gpu2d_core_podf",  "gpu2d_core_sel",    base + 0x18, 23, 3);
 	clk[gpu3d_core_podf]  = imx_clk_divider("gpu3d_core_podf",  "gpu3d_core_sel",    base + 0x18, 26, 3);
diff --git a/arch/arm/mach-integrator/integrator_cp.c b/arch/arm/mach-integrator/integrator_cp.c
index a56c536..a7c5b00 100644
--- a/arch/arm/mach-integrator/integrator_cp.c
+++ b/arch/arm/mach-integrator/integrator_cp.c
@@ -352,7 +352,8 @@ static AMBA_APB_DEVICE(aaci, "mb:1d", 0, INTEGRATOR_CP_AACI_BASE,
 static void cp_clcd_enable(struct clcd_fb *fb)
 {
 	struct fb_var_screeninfo *var = &fb->fb.var;
-	u32 val = CM_CTRL_STATIC1 | CM_CTRL_STATIC2;
+	u32 val = CM_CTRL_STATIC1 | CM_CTRL_STATIC2
+			| CM_CTRL_LCDEN0 | CM_CTRL_LCDEN1;
 
 	if (var->bits_per_pixel <= 8 ||
 	    (var->bits_per_pixel == 16 && var->green.length == 5))
diff --git a/arch/arm/mach-sa1100/assabet.c b/arch/arm/mach-sa1100/assabet.c
index d1dc7f1..3417058 100644
--- a/arch/arm/mach-sa1100/assabet.c
+++ b/arch/arm/mach-sa1100/assabet.c
@@ -509,6 +509,9 @@ static void __init assabet_map_io(void)
 	 * Its called GPCLKR0 in my SA1110 manual.
 	 */
 	Ser1SDCR0 |= SDCR0_SUS;
+	MSC1 = (MSC1 & ~0xffff) |
+		MSC_NonBrst | MSC_32BitStMem |
+		MSC_RdAcc(2) | MSC_WrAcc(2) | MSC_Rec(0);
 
 	if (!machine_has_neponset())
 		sa1100_register_uart_fns(&assabet_port_fns);
diff --git a/arch/arm/plat-omap/omap_device.c b/arch/arm/plat-omap/omap_device.c
index c490240..ccc4536 100644
--- a/arch/arm/plat-omap/omap_device.c
+++ b/arch/arm/plat-omap/omap_device.c
@@ -756,6 +756,7 @@ static int _od_suspend_noirq(struct device *dev)
 
 	if (!ret && !pm_runtime_status_suspended(dev)) {
 		if (pm_generic_runtime_suspend(dev) == 0) {
+			pm_runtime_set_suspended(dev);
 			if (!(od->flags & OMAP_DEVICE_NO_IDLE_ON_SUSPEND))
 				omap_device_idle(pdev);
 			od->flags |= OMAP_DEVICE_SUSPENDED;
@@ -770,11 +771,19 @@ static int _od_resume_noirq(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct omap_device *od = to_omap_device(pdev);
 
-	if ((od->flags & OMAP_DEVICE_SUSPENDED) &&
-	    !pm_runtime_status_suspended(dev)) {
+	if (od->flags & OMAP_DEVICE_SUSPENDED) {
 		od->flags &= ~OMAP_DEVICE_SUSPENDED;
 		if (!(od->flags & OMAP_DEVICE_NO_IDLE_ON_SUSPEND))
 			omap_device_enable(pdev);
+		/*
+		 * XXX: we run before core runtime pm has resumed itself. At
+		 * this point in time, we just restore the runtime pm state and
+		 * considering symmetric operations in resume, we donot expect
+		 * to fail. If we failed, something changed in core runtime_pm
+		 * framework OR some device driver messed things up, hence, WARN
+		 */
+		WARN(pm_runtime_set_active(dev),
+		     "Could not set %s runtime state active\n", dev_name(dev));
 		pm_generic_runtime_resume(dev);
 	}
 
diff --git a/arch/avr32/boot/u-boot/head.S b/arch/avr32/boot/u-boot/head.S
index 4488fa2..2ffc298 100644
--- a/arch/avr32/boot/u-boot/head.S
+++ b/arch/avr32/boot/u-boot/head.S
@@ -8,6 +8,8 @@
  * published by the Free Software Foundation.
  */
 #include <asm/setup.h>
+#include <asm/thread_info.h>
+#include <asm/sysreg.h>
 
 	/*
 	 * The kernel is loaded where we want it to be and all caches
@@ -20,11 +22,6 @@
 	.section .init.text,"ax"
 	.global _start
 _start:
-	/* Check if the boot loader actually provided a tag table */
-	lddpc	r0, magic_number
-	cp.w	r12, r0
-	brne	no_tag_table
-
 	/* Initialize .bss */
 	lddpc	r2, bss_start_addr
 	lddpc   r3, end_addr
@@ -34,6 +31,25 @@ _start:
 	cp      r2, r3
 	brlo    1b
 
+	/* Initialize status register */
+	lddpc	r0, init_sr
+	mtsr	SYSREG_SR, r0
+
+	/* Set initial stack pointer */
+	lddpc	sp, stack_addr
+	sub	sp, -THREAD_SIZE
+
+#ifdef CONFIG_FRAME_POINTER
+	/* Mark last stack frame */
+	mov	lr, 0
+	mov	r7, 0
+#endif
+
+	/* Check if the boot loader actually provided a tag table */
+	lddpc	r0, magic_number
+	cp.w	r12, r0
+	brne	no_tag_table
+
 	/*
 	 * Save the tag table address for later use. This must be done
 	 * _after_ .bss has been initialized...
@@ -53,8 +69,15 @@ bss_start_addr:
 	.long   __bss_start
 end_addr:
 	.long   _end
+init_sr:
+	.long	0x007f0000	/* Supervisor mode, everything masked */
+stack_addr:
+	.long	init_thread_union
+panic_addr:
+	.long	panic
 
 no_tag_table:
 	sub	r12, pc, (. - 2f)
-	bral	panic
+	/* branch to panic() which can be far away with that construct */
+	lddpc	pc, panic_addr
 2:	.asciz	"Boot loader didn't provide correct magic number\n"
diff --git a/arch/avr32/kernel/entry-avr32b.S b/arch/avr32/kernel/entry-avr32b.S
index df28841..55da272 100644
--- a/arch/avr32/kernel/entry-avr32b.S
+++ b/arch/avr32/kernel/entry-avr32b.S
@@ -399,9 +399,10 @@ handle_critical:
 	/* We should never get here... */
 bad_return:
 	sub	r12, pc, (. - 1f)
-	bral	panic
+	lddpc	pc, 2f
 	.align	2
 1:	.asciz	"Return from critical exception!"
+2:	.long	panic
 
 	.align	1
 do_bus_error_write:
diff --git a/arch/avr32/kernel/head.S b/arch/avr32/kernel/head.S
index 6163bd0..59eae6d 100644
--- a/arch/avr32/kernel/head.S
+++ b/arch/avr32/kernel/head.S
@@ -10,33 +10,13 @@
 #include <linux/linkage.h>
 
 #include <asm/page.h>
-#include <asm/thread_info.h>
-#include <asm/sysreg.h>
 
 	.section .init.text,"ax"
 	.global kernel_entry
 kernel_entry:
-	/* Initialize status register */
-	lddpc   r0, init_sr
-	mtsr	SYSREG_SR, r0
-
-	/* Set initial stack pointer */
-	lddpc   sp, stack_addr
-	sub	sp, -THREAD_SIZE
-
-#ifdef CONFIG_FRAME_POINTER
-	/* Mark last stack frame */
-	mov	lr, 0
-	mov	r7, 0
-#endif
-
 	/* Start the show */
 	lddpc   pc, kernel_start_addr
 
 	.align  2
-init_sr:
-	.long   0x007f0000	/* Supervisor mode, everything masked */
-stack_addr:
-	.long   init_thread_union
 kernel_start_addr:
 	.long   start_kernel
diff --git a/arch/ia64/include/asm/processor.h b/arch/ia64/include/asm/processor.h
index 832dd37..f641343 100644
--- a/arch/ia64/include/asm/processor.h
+++ b/arch/ia64/include/asm/processor.h
@@ -319,7 +319,7 @@ struct thread_struct {
 	regs->loadrs = 0;									\
 	regs->r8 = get_dumpable(current->mm);	/* set "don't zap registers" flag */		\
 	regs->r12 = new_sp - 16;	/* allocate 16 byte scratch area */			\
-	if (unlikely(!get_dumpable(current->mm))) {							\
+	if (unlikely(get_dumpable(current->mm) != SUID_DUMP_USER)) {	\
 		/*										\
 		 * Zap scratch regs to avoid leaking bits between processes with different	\
 		 * uid/privileges.								\
diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
index 8b4c049..14d2c04 100644
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -438,6 +438,12 @@ static int save_user_regs(struct pt_regs *regs, struct mcontext __user *frame,
 #endif /* CONFIG_ALTIVEC */
 	if (copy_fpr_to_user(&frame->mc_fregs, current))
 		return 1;
+
+	/*
+	 * Clear the MSR VSX bit to indicate there is no valid state attached
+	 * to this context, except in the specific case below where we set it.
+	 */
+	msr &= ~MSR_VSX;
 #ifdef CONFIG_VSX
 	/*
 	 * Copy VSR 0-31 upper half from thread_struct to local
diff --git a/arch/powerpc/kernel/signal_64.c b/arch/powerpc/kernel/signal_64.c
index d183f87..ff33391 100644
--- a/arch/powerpc/kernel/signal_64.c
+++ b/arch/powerpc/kernel/signal_64.c
@@ -117,6 +117,12 @@ static long setup_sigcontext(struct sigcontext __user *sc, struct pt_regs *regs,
 	flush_fp_to_thread(current);
 	/* copy fpr regs and fpscr */
 	err |= copy_fpr_to_user(&sc->fp_regs, current);
+
+	/*
+	 * Clear the MSR VSX bit to indicate there is no valid state attached
+	 * to this context, except in the specific case below where we set it.
+	 */
+	msr &= ~MSR_VSX;
 #ifdef CONFIG_VSX
 	/*
 	 * Copy VSX low doubleword to local buffer for formatting,
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 3c50ed9..fe33f00 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -213,8 +213,6 @@ static u64 scan_dispatch_log(u64 stop_tb)
 	if (i == vpa->dtl_idx)
 		return 0;
 	while (i < vpa->dtl_idx) {
-		if (dtl_consumer)
-			dtl_consumer(dtl, i);
 		dtb = dtl->timebase;
 		tb_delta = dtl->enqueue_to_dispatch_time +
 			dtl->ready_to_enqueue_time;
@@ -227,6 +225,8 @@ static u64 scan_dispatch_log(u64 stop_tb)
 		}
 		if (dtb > stop_tb)
 			break;
+		if (dtl_consumer)
+			dtl_consumer(dtl, i);
 		stolen += tb_delta;
 		++i;
 		++dtl;
diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index a9ce135..6522bb7 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -35,7 +35,6 @@ static u8 *ctrblk;
 static char keylen_flag;
 
 struct s390_aes_ctx {
-	u8 iv[AES_BLOCK_SIZE];
 	u8 key[AES_MAX_KEY_SIZE];
 	long enc;
 	long dec;
@@ -442,29 +441,35 @@ static int cbc_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	return aes_set_key(tfm, in_key, key_len);
 }
 
-static int cbc_aes_crypt(struct blkcipher_desc *desc, long func, void *param,
+static int cbc_aes_crypt(struct blkcipher_desc *desc, long func,
 			 struct blkcipher_walk *walk)
 {
+	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
 	int ret = blkcipher_walk_virt(desc, walk);
 	unsigned int nbytes = walk->nbytes;
+	struct {
+		u8 iv[AES_BLOCK_SIZE];
+		u8 key[AES_MAX_KEY_SIZE];
+	} param;
 
 	if (!nbytes)
 		goto out;
 
-	memcpy(param, walk->iv, AES_BLOCK_SIZE);
+	memcpy(param.iv, walk->iv, AES_BLOCK_SIZE);
+	memcpy(param.key, sctx->key, sctx->key_len);
 	do {
 		/* only use complete blocks */
 		unsigned int n = nbytes & ~(AES_BLOCK_SIZE - 1);
 		u8 *out = walk->dst.virt.addr;
 		u8 *in = walk->src.virt.addr;
 
-		ret = crypt_s390_kmc(func, param, out, in, n);
+		ret = crypt_s390_kmc(func, &param, out, in, n);
 		BUG_ON((ret < 0) || (ret != n));
 
 		nbytes &= AES_BLOCK_SIZE - 1;
 		ret = blkcipher_walk_done(desc, walk, nbytes);
 	} while ((nbytes = walk->nbytes));
-	memcpy(walk->iv, param, AES_BLOCK_SIZE);
+	memcpy(walk->iv, param.iv, AES_BLOCK_SIZE);
 
 out:
 	return ret;
@@ -481,7 +486,7 @@ static int cbc_aes_encrypt(struct blkcipher_desc *desc,
 		return fallback_blk_enc(desc, dst, src, nbytes);
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return cbc_aes_crypt(desc, sctx->enc, sctx->iv, &walk);
+	return cbc_aes_crypt(desc, sctx->enc, &walk);
 }
 
 static int cbc_aes_decrypt(struct blkcipher_desc *desc,
@@ -495,7 +500,7 @@ static int cbc_aes_decrypt(struct blkcipher_desc *desc,
 		return fallback_blk_dec(desc, dst, src, nbytes);
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return cbc_aes_crypt(desc, sctx->dec, sctx->iv, &walk);
+	return cbc_aes_crypt(desc, sctx->dec, &walk);
 }
 
 static struct crypto_alg cbc_aes_alg = {
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 5d8cf0d..b316ffe 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -338,7 +338,7 @@ static enum ucode_state request_microcode_amd(int cpu, struct device *device)
 		snprintf(fw_name, sizeof(fw_name), "amd-ucode/microcode_amd_fam%.2xh.bin", c->x86);
 
 	if (request_firmware(&fw, (const char *)fw_name, device)) {
-		pr_err("failed to load file %s\n", fw_name);
+		pr_debug("failed to load file %s\n", fw_name);
 		goto out;
 	}
 
diff --git a/block/blk-core.c b/block/blk-core.c
index e17ce4b..ac4e3ea 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -605,10 +605,12 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	__set_bit(QUEUE_FLAG_BYPASS, &q->queue_flags);
 
 	if (blkcg_init_queue(q))
-		goto fail_id;
+		goto fail_bdi;
 
 	return q;
 
+fail_bdi:
+	bdi_destroy(&q->backing_dev_info);
 fail_id:
 	ida_simple_remove(&blk_queue_ida, q->id);
 fail_q:
@@ -2144,6 +2146,7 @@ void blk_start_request(struct request *req)
 	if (unlikely(blk_bidi_rq(req)))
 		req->next_rq->resid_len = blk_rq_bytes(req->next_rq);
 
+	BUG_ON(test_bit(REQ_ATOM_COMPLETE, &req->atomic_flags));
 	blk_add_timer(req);
 }
 EXPORT_SYMBOL(blk_start_request);
diff --git a/block/blk-settings.c b/block/blk-settings.c
index d3234fc..191d33e 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -144,6 +144,7 @@ void blk_set_stacking_limits(struct queue_limits *lim)
 	lim->max_segments = USHRT_MAX;
 	lim->max_hw_sectors = UINT_MAX;
 
+	lim->max_segment_size = UINT_MAX;
 	lim->max_sectors = BLK_DEF_MAX_SECTORS;
 }
 EXPORT_SYMBOL(blk_set_stacking_limits);
diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index 6e4744c..5a6296e 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -90,8 +90,8 @@ static void blk_rq_timed_out(struct request *req)
 		__blk_complete_request(req);
 		break;
 	case BLK_EH_RESET_TIMER:
-		blk_clear_rq_complete(req);
 		blk_add_timer(req);
+		blk_clear_rq_complete(req);
 		break;
 	case BLK_EH_NOT_HANDLED:
 		/*
@@ -173,7 +173,6 @@ void blk_add_timer(struct request *req)
 		return;
 
 	BUG_ON(!list_empty(&req->timeout_list));
-	BUG_ON(test_bit(REQ_ATOM_COMPLETE, &req->atomic_flags));
 
 	/*
 	 * Some LLDs, like scsi, peek at the timeout to prevent a
diff --git a/drivers/acpi/acpica/exoparg1.c b/drivers/acpi/acpica/exoparg1.c
index 9ba8c73..fe2f9d9 100644
--- a/drivers/acpi/acpica/exoparg1.c
+++ b/drivers/acpi/acpica/exoparg1.c
@@ -970,10 +970,17 @@ acpi_status acpi_ex_opcode_1A_0T_1R(struct acpi_walk_state *walk_state)
 					 */
 					return_desc =
 					    *(operand[0]->reference.where);
-					if (return_desc) {
-						acpi_ut_add_reference
-						    (return_desc);
+					if (!return_desc) {
+						/*
+						 * Element is NULL, do not allow the dereference.
+						 * This provides compatibility with other ACPI
+						 * implementations.
+						 */
+						return_ACPI_STATUS
+						    (AE_AML_UNINITIALIZED_ELEMENT);
 					}
+
+					acpi_ut_add_reference(return_desc);
 					break;
 
 				default:
@@ -998,11 +1005,40 @@ acpi_status acpi_ex_opcode_1A_0T_1R(struct acpi_walk_state *walk_state)
 									 acpi_namespace_node
 									 *)
 									return_desc);
-				}
+					if (!return_desc) {
+						break;
+					}
 
-				/* Add another reference to the object! */
+					/*
+					 * June 2013:
+					 * buffer_fields/field_units require additional resolution
+					 */
+					switch (return_desc->common.type) {
+					case ACPI_TYPE_BUFFER_FIELD:
+					case ACPI_TYPE_LOCAL_REGION_FIELD:
+					case ACPI_TYPE_LOCAL_BANK_FIELD:
+					case ACPI_TYPE_LOCAL_INDEX_FIELD:
 
-				acpi_ut_add_reference(return_desc);
+						status =
+						    acpi_ex_read_data_from_field
+						    (walk_state, return_desc,
+						     &temp_desc);
+						if (ACPI_FAILURE(status)) {
+							goto cleanup;
+						}
+
+						return_desc = temp_desc;
+						break;
+
+					default:
+
+						/* Add another reference to the object */
+
+						acpi_ut_add_reference
+						    (return_desc);
+						break;
+					}
+				}
 				break;
 
 			default:
diff --git a/drivers/acpi/acpica/exstore.c b/drivers/acpi/acpica/exstore.c
index c6cf843..9806f4b 100644
--- a/drivers/acpi/acpica/exstore.c
+++ b/drivers/acpi/acpica/exstore.c
@@ -57,6 +57,11 @@ acpi_ex_store_object_to_index(union acpi_operand_object *val_desc,
 			      union acpi_operand_object *dest_desc,
 			      struct acpi_walk_state *walk_state);
 
+static acpi_status
+acpi_ex_store_direct_to_node(union acpi_operand_object *source_desc,
+			     struct acpi_namespace_node *node,
+			     struct acpi_walk_state *walk_state);
+
 /*******************************************************************************
  *
  * FUNCTION:    acpi_ex_store
@@ -376,7 +381,11 @@ acpi_ex_store_object_to_index(union acpi_operand_object *source_desc,
  *              When storing into an object the data is converted to the
  *              target object type then stored in the object.  This means
  *              that the target object type (for an initialized target) will
- *              not be changed by a store operation.
+ *              not be changed by a store operation. A copy_object can change
+ *              the target type, however.
+ *
+ *              The implicit_conversion flag is set to NO/FALSE only when
+ *              storing to an arg_x -- as per the rules of the ACPI spec.
  *
  *              Assumes parameters are already validated.
  *
@@ -400,7 +409,7 @@ acpi_ex_store_object_to_node(union acpi_operand_object *source_desc,
 	target_type = acpi_ns_get_type(node);
 	target_desc = acpi_ns_get_attached_object(node);
 
-	ACPI_DEBUG_PRINT((ACPI_DB_EXEC, "Storing %p(%s) into node %p(%s)\n",
+	ACPI_DEBUG_PRINT((ACPI_DB_EXEC, "Storing %p (%s) to node %p (%s)\n",
 			  source_desc,
 			  acpi_ut_get_object_type_name(source_desc), node,
 			  acpi_ut_get_type_name(target_type)));
@@ -414,46 +423,31 @@ acpi_ex_store_object_to_node(union acpi_operand_object *source_desc,
 		return_ACPI_STATUS(status);
 	}
 
-	/* If no implicit conversion, drop into the default case below */
-
-	if ((!implicit_conversion) ||
-	    ((walk_state->opcode == AML_COPY_OP) &&
-	     (target_type != ACPI_TYPE_LOCAL_REGION_FIELD) &&
-	     (target_type != ACPI_TYPE_LOCAL_BANK_FIELD) &&
-	     (target_type != ACPI_TYPE_LOCAL_INDEX_FIELD))) {
-		/*
-		 * Force execution of default (no implicit conversion). Note:
-		 * copy_object does not perform an implicit conversion, as per the ACPI
-		 * spec -- except in case of region/bank/index fields -- because these
-		 * objects must retain their original type permanently.
-		 */
-		target_type = ACPI_TYPE_ANY;
-	}
-
 	/* Do the actual store operation */
 
 	switch (target_type) {
-	case ACPI_TYPE_BUFFER_FIELD:
-	case ACPI_TYPE_LOCAL_REGION_FIELD:
-	case ACPI_TYPE_LOCAL_BANK_FIELD:
-	case ACPI_TYPE_LOCAL_INDEX_FIELD:
-
-		/* For fields, copy the source data to the target field. */
-
-		status = acpi_ex_write_data_to_field(source_desc, target_desc,
-						     &walk_state->result_obj);
-		break;
-
 	case ACPI_TYPE_INTEGER:
 	case ACPI_TYPE_STRING:
 	case ACPI_TYPE_BUFFER:
 
 		/*
-		 * These target types are all of type Integer/String/Buffer, and
-		 * therefore support implicit conversion before the store.
-		 *
-		 * Copy and/or convert the source object to a new target object
+		 * The simple data types all support implicit source operand
+		 * conversion before the store.
 		 */
+
+		if ((walk_state->opcode == AML_COPY_OP) || !implicit_conversion) {
+			/*
+			 * However, copy_object and Stores to arg_x do not perform
+			 * an implicit conversion, as per the ACPI specification.
+			 * A direct store is performed instead.
+			 */
+			status = acpi_ex_store_direct_to_node(source_desc, node,
+							      walk_state);
+			break;
+		}
+
+		/* Store with implicit source operand conversion support */
+
 		status =
 		    acpi_ex_store_object_to_object(source_desc, target_desc,
 						   &new_desc, walk_state);
@@ -467,13 +461,12 @@ acpi_ex_store_object_to_node(union acpi_operand_object *source_desc,
 			 * the Name's type to that of the value being stored in it.
 			 * source_desc reference count is incremented by attach_object.
 			 *
-			 * Note: This may change the type of the node if an explicit store
-			 * has been performed such that the node/object type has been
-			 * changed.
+			 * Note: This may change the type of the node if an explicit
+			 * store has been performed such that the node/object type
+			 * has been changed.
 			 */
-			status =
-			    acpi_ns_attach_object(node, new_desc,
-						  new_desc->common.type);
+			status = acpi_ns_attach_object(node, new_desc,
+						       new_desc->common.type);
 
 			ACPI_DEBUG_PRINT((ACPI_DB_EXEC,
 					  "Store %s into %s via Convert/Attach\n",
@@ -484,19 +477,83 @@ acpi_ex_store_object_to_node(union acpi_operand_object *source_desc,
 		}
 		break;
 
+	case ACPI_TYPE_BUFFER_FIELD:
+	case ACPI_TYPE_LOCAL_REGION_FIELD:
+	case ACPI_TYPE_LOCAL_BANK_FIELD:
+	case ACPI_TYPE_LOCAL_INDEX_FIELD:
+		/*
+		 * For all fields, always write the source data to the target
+		 * field. Any required implicit source operand conversion is
+		 * performed in the function below as necessary. Note, field
+		 * objects must retain their original type permanently.
+		 */
+		status = acpi_ex_write_data_to_field(source_desc, target_desc,
+						     &walk_state->result_obj);
+		break;
+
 	default:
+		/*
+		 * No conversions for all other types. Directly store a copy of
+		 * the source object. This is the ACPI spec-defined behavior for
+		 * the copy_object operator.
+		 *
+		 * NOTE: For the Store operator, this is a departure from the
+		 * ACPI spec, which states "If conversion is impossible, abort
+		 * the running control method". Instead, this code implements
+		 * "If conversion is impossible, treat the Store operation as
+		 * a CopyObject".
+		 */
+		status = acpi_ex_store_direct_to_node(source_desc, node,
+						      walk_state);
+		break;
+	}
 
-		ACPI_DEBUG_PRINT((ACPI_DB_EXEC,
-				  "Storing %s (%p) directly into node (%p) with no implicit conversion\n",
-				  acpi_ut_get_object_type_name(source_desc),
-				  source_desc, node));
+	return_ACPI_STATUS(status);
+}
 
-		/* No conversions for all other types.  Just attach the source object */
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_ex_store_direct_to_node
+ *
+ * PARAMETERS:  source_desc             - Value to be stored
+ *              node                    - Named object to receive the value
+ *              walk_state              - Current walk state
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: "Store" an object directly to a node. This involves a copy
+ *              and an attach.
+ *
+ ******************************************************************************/
 
-		status = acpi_ns_attach_object(node, source_desc,
-					       source_desc->common.type);
-		break;
+static acpi_status
+acpi_ex_store_direct_to_node(union acpi_operand_object *source_desc,
+			     struct acpi_namespace_node *node,
+			     struct acpi_walk_state *walk_state)
+{
+	acpi_status status;
+	union acpi_operand_object *new_desc;
+
+	ACPI_FUNCTION_TRACE(ex_store_direct_to_node);
+
+	ACPI_DEBUG_PRINT((ACPI_DB_EXEC,
+			  "Storing [%s] (%p) directly into node [%s] (%p)"
+			  " with no implicit conversion\n",
+			  acpi_ut_get_object_type_name(source_desc),
+			  source_desc, acpi_ut_get_type_name(node->type),
+			  node));
+
+	/* Copy the source object to a new object */
+
+	status =
+	    acpi_ut_copy_iobject_to_iobject(source_desc, &new_desc, walk_state);
+	if (ACPI_FAILURE(status)) {
+		return_ACPI_STATUS(status);
 	}
 
+	/* Attach the new object to the node */
+
+	status = acpi_ns_attach_object(node, new_desc, new_desc->common.type);
+	acpi_ut_remove_reference(new_desc);
 	return_ACPI_STATUS(status);
 }
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index d0f8a93..77795cf 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -439,6 +439,8 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 on some Gigabyte */
 	{ PCI_DEVICE(0x1b4b, 0x91a3),
 	  .driver_data = board_ahci_yes_fbs },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9230),
+	  .driver_data = board_ahci_yes_fbs },
 
 	/* Promise */
 	{ PCI_VDEVICE(PROMISE, 0x3f20), board_ahci },	/* PDC42819 */
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 4e8213a..a7d70e2 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -546,7 +546,7 @@ static struct kobject *brd_probe(dev_t dev, int *part, void *data)
 
 	mutex_lock(&brd_devices_mutex);
 	brd = brd_init_one(MINOR(dev) >> part_shift);
-	kobj = brd ? get_disk(brd->brd_disk) : ERR_PTR(-ENOMEM);
+	kobj = brd ? get_disk(brd->brd_disk) : NULL;
 	mutex_unlock(&brd_devices_mutex);
 
 	*part = 0;
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index c5e0f73..34f5e1a 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -878,13 +878,6 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 
 	bio_list_init(&lo->lo_bio_list);
 
-	/*
-	 * set queue make_request_fn, and add limits based on lower level
-	 * device
-	 */
-	blk_queue_make_request(lo->lo_queue, loop_make_request);
-	lo->lo_queue->queuedata = lo;
-
 	if (!(lo_flags & LO_FLAGS_READ_ONLY) && file->f_op->fsync)
 		blk_queue_flush(lo->lo_queue, REQ_FLUSH);
 
@@ -1607,6 +1600,8 @@ static int loop_add(struct loop_device **l, int i)
 	if (!lo)
 		goto out;
 
+	lo->lo_state = Lo_unbound;
+
 	if (!idr_pre_get(&loop_index_idr, GFP_KERNEL))
 		goto out_free_dev;
 
@@ -1634,7 +1629,13 @@ static int loop_add(struct loop_device **l, int i)
 
 	lo->lo_queue = blk_alloc_queue(GFP_KERNEL);
 	if (!lo->lo_queue)
-		goto out_free_dev;
+		goto out_free_idr;
+
+	/*
+	 * set queue make_request_fn
+	 */
+	blk_queue_make_request(lo->lo_queue, loop_make_request);
+	lo->lo_queue->queuedata = lo;
 
 	disk = lo->lo_disk = alloc_disk(1 << part_shift);
 	if (!disk)
@@ -1678,6 +1679,8 @@ static int loop_add(struct loop_device **l, int i)
 
 out_free_queue:
 	blk_cleanup_queue(lo->lo_queue);
+out_free_idr:
+	idr_remove(&loop_index_idr, i);
 out_free_dev:
 	kfree(lo);
 out:
@@ -1741,7 +1744,7 @@ static struct kobject *loop_probe(dev_t dev, int *part, void *data)
 	if (err < 0)
 		err = loop_add(&lo, MINOR(dev) >> part_shift);
 	if (err < 0)
-		kobj = ERR_PTR(err);
+		kobj = NULL;
 	else
 		kobj = get_disk(lo->lo_disk);
 	mutex_unlock(&loop_index_mutex);
diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index b83b40e..ae1b0c4 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -406,6 +406,8 @@ static int dispatch_discard_io(struct xen_blkif *blkif,
 	unsigned long secure;
 	struct phys_req preq;
 
+	xen_blkif_get(blkif);
+
 	preq.sector_number = req->u.discard.sector_number;
 	preq.nr_sects      = req->u.discard.nr_sectors;
 
@@ -418,7 +420,6 @@ static int dispatch_discard_io(struct xen_blkif *blkif,
 	}
 	blkif->st_ds_req++;
 
-	xen_blkif_get(blkif);
 	secure = (blkif->vbd.discard_secure &&
 		 (req->u.discard.flag & BLKIF_DISCARD_SECURE)) ?
 		 BLKDEV_DISCARD_SECURE : 0;
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 05f75ff..c0668fb 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -5015,7 +5015,9 @@ static void i9xx_update_cursor(struct drm_crtc *crtc, u32 base)
 		intel_crtc->cursor_visible = visible;
 	}
 	/* and commit changes on next vblank */
+	POSTING_READ(CURCNTR(pipe));
 	I915_WRITE(CURBASE(pipe), base);
+	POSTING_READ(CURBASE(pipe));
 }
 
 static void ivb_update_cursor(struct drm_crtc *crtc, u32 base)
@@ -5040,7 +5042,9 @@ static void ivb_update_cursor(struct drm_crtc *crtc, u32 base)
 		intel_crtc->cursor_visible = visible;
 	}
 	/* and commit changes on next vblank */
+	POSTING_READ(CURCNTR_IVB(pipe));
 	I915_WRITE(CURBASE_IVB(pipe), base);
+	POSTING_READ(CURBASE_IVB(pipe));
 }
 
 /* If no-part of the cursor is visible on the framebuffer, then the GPU may hang... */
diff --git a/drivers/gpu/drm/nouveau/nouveau_gem.c b/drivers/gpu/drm/nouveau/nouveau_gem.c
index 30f5423..9a5851a 100644
--- a/drivers/gpu/drm/nouveau/nouveau_gem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -286,7 +286,8 @@ validate_fini_list(struct list_head *list, struct nouveau_fence *fence)
 	list_for_each_safe(entry, tmp, list) {
 		nvbo = list_entry(entry, struct nouveau_bo, entry);
 
-		nouveau_bo_fence(nvbo, fence);
+		if (likely(fence))
+			nouveau_bo_fence(nvbo, fence);
 
 		if (unlikely(nvbo->validate_mapped)) {
 			ttm_bo_kunmap(&nvbo->kmap);
diff --git a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c b/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
index 9760e5a..b44bbf5 100644
--- a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
@@ -416,6 +416,7 @@ int radeon_crtc_do_set_base(struct drm_crtc *crtc,
 	/* Pin framebuffer & get tilling informations */
 	obj = radeon_fb->obj;
 	rbo = gem_to_radeon_bo(obj);
+retry:
 	r = radeon_bo_reserve(rbo, false);
 	if (unlikely(r != 0))
 		return r;
@@ -424,6 +425,33 @@ int radeon_crtc_do_set_base(struct drm_crtc *crtc,
 				     &base);
 	if (unlikely(r != 0)) {
 		radeon_bo_unreserve(rbo);
+
+		/* On old GPU like RN50 with little vram pining can fails because
+		 * current fb is taking all space needed. So instead of unpining
+		 * the old buffer after pining the new one, first unpin old one
+		 * and then retry pining new one.
+		 *
+		 * As only master can set mode only master can pin and it is
+		 * unlikely the master client will race with itself especialy
+		 * on those old gpu with single crtc.
+		 *
+		 * We don't shutdown the display controller because new buffer
+		 * will end up in same spot.
+		 */
+		if (!atomic && fb && fb != crtc->fb) {
+			struct radeon_bo *old_rbo;
+			unsigned long nsize, osize;
+
+			old_rbo = gem_to_radeon_bo(to_radeon_framebuffer(fb)->obj);
+			osize = radeon_bo_size(old_rbo);
+			nsize = radeon_bo_size(rbo);
+			if (nsize <= osize && !radeon_bo_reserve(old_rbo, false)) {
+				radeon_bo_unpin(old_rbo);
+				radeon_bo_unreserve(old_rbo);
+				fb = NULL;
+				goto retry;
+			}
+		}
 		return -EINVAL;
 	}
 	radeon_bo_get_tiling_flags(rbo, &tiling_flags, NULL);
diff --git a/drivers/gpu/drm/radeon/radeon_semaphore.c b/drivers/gpu/drm/radeon/radeon_semaphore.c
index e2ace5d..5ba2d38 100644
--- a/drivers/gpu/drm/radeon/radeon_semaphore.c
+++ b/drivers/gpu/drm/radeon/radeon_semaphore.c
@@ -30,7 +30,7 @@
 #include "drmP.h"
 #include "drm.h"
 #include "radeon.h"
-
+#include "radeon_trace.h"
 
 int radeon_semaphore_create(struct radeon_device *rdev,
 			    struct radeon_semaphore **semaphore)
@@ -57,6 +57,8 @@ int radeon_semaphore_create(struct radeon_device *rdev,
 void radeon_semaphore_emit_signal(struct radeon_device *rdev, int ring,
 			          struct radeon_semaphore *semaphore)
 {
+	trace_radeon_semaphore_signale(ring, semaphore);
+
 	--semaphore->waiters;
 	radeon_semaphore_ring_emit(rdev, ring, &rdev->ring[ring], semaphore, false);
 }
@@ -64,6 +66,8 @@ void radeon_semaphore_emit_signal(struct radeon_device *rdev, int ring,
 void radeon_semaphore_emit_wait(struct radeon_device *rdev, int ring,
 			        struct radeon_semaphore *semaphore)
 {
+	trace_radeon_semaphore_wait(ring, semaphore);
+
 	++semaphore->waiters;
 	radeon_semaphore_ring_emit(rdev, ring, &rdev->ring[ring], semaphore, true);
 }
diff --git a/drivers/gpu/drm/radeon/radeon_trace.h b/drivers/gpu/drm/radeon/radeon_trace.h
index eafd816..a20bc7e 100644
--- a/drivers/gpu/drm/radeon/radeon_trace.h
+++ b/drivers/gpu/drm/radeon/radeon_trace.h
@@ -74,6 +74,42 @@ DEFINE_EVENT(radeon_fence_request, radeon_fence_wait_end,
 	    TP_ARGS(dev, seqno)
 );
 
+DECLARE_EVENT_CLASS(radeon_semaphore_request,
+
+	    TP_PROTO(int ring, struct radeon_semaphore *sem),
+
+	    TP_ARGS(ring, sem),
+
+	    TP_STRUCT__entry(
+			     __field(int, ring)
+			     __field(signed, waiters)
+			     __field(uint64_t, gpu_addr)
+			     ),
+
+	    TP_fast_assign(
+			   __entry->ring = ring;
+			   __entry->waiters = sem->waiters;
+			   __entry->gpu_addr = sem->gpu_addr;
+			   ),
+
+	    TP_printk("ring=%u, waiters=%d, addr=%010Lx", __entry->ring,
+		      __entry->waiters, __entry->gpu_addr)
+);
+
+DEFINE_EVENT(radeon_semaphore_request, radeon_semaphore_signale,
+
+	    TP_PROTO(int ring, struct radeon_semaphore *sem),
+
+	    TP_ARGS(ring, sem)
+);
+
+DEFINE_EVENT(radeon_semaphore_request, radeon_semaphore_wait,
+
+	    TP_PROTO(int ring, struct radeon_semaphore *sem),
+
+	    TP_ARGS(ring, sem)
+);
+
 #endif
 
 /* This part must be outside protection */
diff --git a/drivers/gpu/drm/radeon/sid.h b/drivers/gpu/drm/radeon/sid.h
index 0a240fa..cc94c77 100644
--- a/drivers/gpu/drm/radeon/sid.h
+++ b/drivers/gpu/drm/radeon/sid.h
@@ -184,7 +184,7 @@
 #define		NOOFGROUPS_SHIFT				12
 #define		NOOFGROUPS_MASK					0x00001000
 
-#define	MC_SEQ_TRAIN_WAKEUP_CNTL			0x2808
+#define	MC_SEQ_TRAIN_WAKEUP_CNTL			0x28e8
 #define		TRAIN_DONE_D0      			(1 << 30)
 #define		TRAIN_DONE_D1      			(1 << 31)
 
diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 36f4b28..a414452 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -1099,24 +1099,32 @@ out_unlock:
 	return ret;
 }
 
-static int ttm_bo_mem_compat(struct ttm_placement *placement,
-			     struct ttm_mem_reg *mem)
+static bool ttm_bo_mem_compat(struct ttm_placement *placement,
+			      struct ttm_mem_reg *mem,
+			      uint32_t *new_flags)
 {
 	int i;
 
 	if (mem->mm_node && placement->lpfn != 0 &&
 	    (mem->start < placement->fpfn ||
 	     mem->start + mem->num_pages > placement->lpfn))
-		return -1;
+		return false;
 
 	for (i = 0; i < placement->num_placement; i++) {
-		if ((placement->placement[i] & mem->placement &
-			TTM_PL_MASK_CACHING) &&
-			(placement->placement[i] & mem->placement &
-			TTM_PL_MASK_MEM))
-			return i;
+		*new_flags = placement->placement[i];
+		if ((*new_flags & mem->placement & TTM_PL_MASK_CACHING) &&
+		    (*new_flags & mem->placement & TTM_PL_MASK_MEM))
+			return true;
+	}
+
+	for (i = 0; i < placement->num_busy_placement; i++) {
+		*new_flags = placement->busy_placement[i];
+		if ((*new_flags & mem->placement & TTM_PL_MASK_CACHING) &&
+		    (*new_flags & mem->placement & TTM_PL_MASK_MEM))
+			return true;
 	}
-	return -1;
+
+	return false;
 }
 
 int ttm_bo_validate(struct ttm_buffer_object *bo,
@@ -1125,6 +1133,7 @@ int ttm_bo_validate(struct ttm_buffer_object *bo,
 			bool no_wait_gpu)
 {
 	int ret;
+	uint32_t new_flags;
 
 	BUG_ON(!atomic_read(&bo->reserved));
 	/* Check that range is valid */
@@ -1135,8 +1144,7 @@ int ttm_bo_validate(struct ttm_buffer_object *bo,
 	/*
 	 * Check whether we need to move buffer.
 	 */
-	ret = ttm_bo_mem_compat(placement, &bo->mem);
-	if (ret < 0) {
+	if (!ttm_bo_mem_compat(placement, &bo->mem, &new_flags)) {
 		ret = ttm_bo_move_buffer(bo, placement, interruptible, no_wait_reserve, no_wait_gpu);
 		if (ret)
 			return ret;
@@ -1145,7 +1153,7 @@ int ttm_bo_validate(struct ttm_buffer_object *bo,
 		 * Use the access and other non-mapping-related flag bits from
 		 * the compatible memory placement flags to the active flags
 		 */
-		ttm_flag_masked(&bo->mem.placement, placement->placement[ret],
+		ttm_flag_masked(&bo->mem.placement, new_flags,
 				~TTM_PL_MASK_MEMTYPE);
 	}
 	/*
diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
index f8187ea..05577e8 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -337,12 +337,22 @@ int ttm_bo_move_memcpy(struct ttm_buffer_object *bo,
 	if (ret)
 		goto out;
 
+	/*
+	 * Single TTM move. NOP.
+	 */
 	if (old_iomap == NULL && new_iomap == NULL)
 		goto out2;
+
+	/*
+	 * Move nonexistent data. NOP.
+	 */
 	if (old_iomap == NULL && ttm == NULL)
 		goto out2;
 
-	if (ttm->state == tt_unpopulated) {
+	/*
+	 * TTM might be null for moves within the same region.
+	 */
+	if (ttm && ttm->state == tt_unpopulated) {
 		ret = ttm->bdev->driver->ttm_tt_populate(ttm);
 		if (ret)
 			goto out1;
@@ -390,7 +400,12 @@ out1:
 	ttm_mem_reg_iounmap(bdev, old_mem, new_iomap);
 out:
 	ttm_mem_reg_iounmap(bdev, &old_copy, old_iomap);
-	ttm_bo_mem_put(bo, &old_copy);
+
+	/*
+	 * On error, keep the mm node!
+	 */
+	if (!ret)
+		ttm_bo_mem_put(bo, &old_copy);
 	return ret;
 }
 EXPORT_SYMBOL(ttm_bo_move_memcpy);
diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index 22b14a68..1f4f941 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -278,7 +278,7 @@ static const struct lm90_params lm90_params[] = {
 	[max6696] = {
 		.flags = LM90_HAVE_EMERGENCY
 		  | LM90_HAVE_EMERGENCY_ALARM | LM90_HAVE_TEMP3,
-		.alert_alarms = 0x187c,
+		.alert_alarms = 0x1c7c,
 		.max_convrate = 6,
 		.reg_local_ext = MAX6657_REG_R_LOCAL_TEMPL,
 	},
@@ -1504,19 +1504,22 @@ static void lm90_alert(struct i2c_client *client, unsigned int flag)
 	if ((alarms & 0x7f) == 0 && (alarms2 & 0xfe) == 0) {
 		dev_info(&client->dev, "Everything OK\n");
 	} else {
-		if (alarms & 0x61)
+		if ((alarms & 0x61) || (alarms2 & 0x80))
 			dev_warn(&client->dev,
 				 "temp%d out of range, please check!\n", 1);
-		if (alarms & 0x1a)
+		if ((alarms & 0x1a) || (alarms2 & 0x20))
 			dev_warn(&client->dev,
 				 "temp%d out of range, please check!\n", 2);
 		if (alarms & 0x04)
 			dev_warn(&client->dev,
 				 "temp%d diode open, please check!\n", 2);
 
-		if (alarms2 & 0x18)
+		if (alarms2 & 0x5a)
 			dev_warn(&client->dev,
 				 "temp%d out of range, please check!\n", 3);
+		if (alarms2 & 0x04)
+			dev_warn(&client->dev,
+				 "temp%d diode open, please check!\n", 3);
 
 		/*
 		 * Disable ALERT# output, because these chips don't implement
diff --git a/drivers/infiniband/hw/ipath/ipath_user_sdma.c b/drivers/infiniband/hw/ipath/ipath_user_sdma.c
index f5cb13b..cc04b7b 100644
--- a/drivers/infiniband/hw/ipath/ipath_user_sdma.c
+++ b/drivers/infiniband/hw/ipath/ipath_user_sdma.c
@@ -280,9 +280,7 @@ static int ipath_user_sdma_pin_pages(const struct ipath_devdata *dd,
 	int j;
 	int ret;
 
-	ret = get_user_pages(current, current->mm, addr,
-			     npages, 0, 1, pages, NULL);
-
+	ret = get_user_pages_fast(addr, npages, 0, pages);
 	if (ret != npages) {
 		int i;
 
@@ -811,10 +809,7 @@ int ipath_user_sdma_writev(struct ipath_devdata *dd,
 	while (dim) {
 		const int mxp = 8;
 
-		down_write(&current->mm->mmap_sem);
 		ret = ipath_user_sdma_queue_pkts(dd, pq, &list, iov, dim, mxp);
-		up_write(&current->mm->mmap_sem);
-
 		if (ret <= 0)
 			goto done_unlock;
 		else {
diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 5f306f7..0ec9abb 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -765,6 +765,7 @@ static struct pnp_device_id pnp_kbd_devids[] = {
 	{ .id = "CPQA0D7", .driver_data = 0 },
 	{ .id = "", },
 };
+MODULE_DEVICE_TABLE(pnp, pnp_kbd_devids);
 
 static struct pnp_driver i8042_pnp_kbd_driver = {
 	.name           = "i8042 kbd",
@@ -786,6 +787,7 @@ static struct pnp_device_id pnp_aux_devids[] = {
 	{ .id = "SYN0801", .driver_data = 0 },
 	{ .id = "", },
 };
+MODULE_DEVICE_TABLE(pnp, pnp_aux_devids);
 
 static struct pnp_driver i8042_pnp_aux_driver = {
 	.name           = "i8042 aux",
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index f220a69..d509f23 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -581,14 +581,28 @@ static int adjoin(struct dm_table *table, struct dm_target *ti)
 
 /*
  * Used to dynamically allocate the arg array.
+ *
+ * We do first allocation with GFP_NOIO because dm-mpath and dm-thin must
+ * process messages even if some device is suspended. These messages have a
+ * small fixed number of arguments.
+ *
+ * On the other hand, dm-switch needs to process bulk data using messages and
+ * excessive use of GFP_NOIO could cause trouble.
  */
 static char **realloc_argv(unsigned *array_size, char **old_argv)
 {
 	char **argv;
 	unsigned new_size;
+	gfp_t gfp;
 
-	new_size = *array_size ? *array_size * 2 : 64;
-	argv = kmalloc(new_size * sizeof(*argv), GFP_KERNEL);
+	if (*array_size) {
+		new_size = *array_size * 2;
+		gfp = GFP_KERNEL;
+	} else {
+		new_size = 8;
+		gfp = GFP_NOIO;
+	}
+	argv = kmalloc(new_size * sizeof(*argv), gfp);
 	if (argv) {
 		memcpy(argv, old_argv, *array_size * sizeof(*argv));
 		*array_size = new_size;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5f5e10e..84f0f19 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3681,6 +3681,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 		mddev->in_sync = 1;
 		del_timer_sync(&mddev->safemode_timer);
 	}
+	blk_set_stacking_limits(&mddev->queue->limits);
 	pers->run(mddev);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 	mddev_resume(mddev);
diff --git a/drivers/misc/atmel_pwm.c b/drivers/misc/atmel_pwm.c
index 28f5aaa..2741108 100644
--- a/drivers/misc/atmel_pwm.c
+++ b/drivers/misc/atmel_pwm.c
@@ -90,8 +90,10 @@ int pwm_channel_alloc(int index, struct pwm_channel *ch)
 	unsigned long	flags;
 	int		status = 0;
 
-	/* insist on PWM init, with this signal pinned out */
-	if (!pwm || !(pwm->mask & 1 << index))
+	if (!pwm)
+		return -EPROBE_DEFER;
+
+	if (!(pwm->mask & 1 << index))
 		return -ENODEV;
 
 	if (index < 0 || index >= PWM_NCHAN || !ch)
diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 5d0d68c..e857734 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -71,7 +71,7 @@
 
 /* Define max times to check status register before we give up. */
 #define	MAX_READY_WAIT_JIFFIES	(40 * HZ)	/* M25P16 specs 40s max chip erase */
-#define	MAX_CMD_SIZE		5
+#define	MAX_CMD_SIZE		6
 
 #ifdef CONFIG_M25PXX_USE_FAST_READ
 #define OPCODE_READ 	OPCODE_FAST_READ
@@ -848,14 +848,13 @@ static int __devinit m25p_probe(struct spi_device *spi)
 		}
 	}
 
-	flash = kzalloc(sizeof *flash, GFP_KERNEL);
+	flash = devm_kzalloc(&spi->dev, sizeof(*flash), GFP_KERNEL);
 	if (!flash)
 		return -ENOMEM;
-	flash->command = kmalloc(MAX_CMD_SIZE + FAST_READ_DUMMY_BYTE, GFP_KERNEL);
-	if (!flash->command) {
-		kfree(flash);
+
+	flash->command = devm_kzalloc(&spi->dev, MAX_CMD_SIZE, GFP_KERNEL);
+	if (!flash->command)
 		return -ENOMEM;
-	}
 
 	flash->spi = spi;
 	mutex_init(&flash->lock);
@@ -952,14 +951,10 @@ static int __devinit m25p_probe(struct spi_device *spi)
 static int __devexit m25p_remove(struct spi_device *spi)
 {
 	struct m25p	*flash = dev_get_drvdata(&spi->dev);
-	int		status;
 
 	/* Clean up MTD stuff. */
-	status = mtd_device_unregister(&flash->mtd);
-	if (status == 0) {
-		kfree(flash->command);
-		kfree(flash);
-	}
+	mtd_device_unregister(&flash->mtd);
+
 	return 0;
 }
 
diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
index a6cad5c..e19fd89 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
@@ -230,8 +230,6 @@ static void dma_irq_callback(void *param)
 	struct gpmi_nand_data *this = param;
 	struct completion *dma_c = &this->dma_done;
 
-	complete(dma_c);
-
 	switch (this->dma_type) {
 	case DMA_FOR_COMMAND:
 		dma_unmap_sg(this->dev, &this->cmd_sgl, 1, DMA_TO_DEVICE);
@@ -256,6 +254,8 @@ static void dma_irq_callback(void *param)
 	default:
 		pr_err("in wrong DMA operation.\n");
 	}
+
+	complete(dma_c);
 }
 
 int start_dma_without_bch_irq(struct gpmi_nand_data *this,
diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index c429abd..09d0cea 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -2905,10 +2905,21 @@ static int nand_flash_detect_onfi(struct mtd_info *mtd, struct nand_chip *chip,
 	sanitize_string(p->model, sizeof(p->model));
 	if (!mtd->name)
 		mtd->name = p->model;
+
 	mtd->writesize = le32_to_cpu(p->byte_per_page);
-	mtd->erasesize = le32_to_cpu(p->pages_per_block) * mtd->writesize;
+
+	/*
+	 * pages_per_block and blocks_per_lun may not be a power-of-2 size
+	 * (don't ask me who thought of this...). MTD assumes that these
+	 * dimensions will be power-of-2, so just truncate the remaining area.
+	 */
+	mtd->erasesize = 1 << (fls(le32_to_cpu(p->pages_per_block)) - 1);
+	mtd->erasesize *= mtd->writesize;
+
 	mtd->oobsize = le16_to_cpu(p->spare_bytes_per_page);
-	chip->chipsize = le32_to_cpu(p->blocks_per_lun);
+
+	/* See erasesize comment */
+	chip->chipsize = 1 << (fls(le32_to_cpu(p->blocks_per_lun)) - 1);
 	chip->chipsize *= (uint64_t)mtd->erasesize * p->lun_count;
 	*busw = 0;
 	if (le16_to_cpu(p->features) & 1)
diff --git a/drivers/net/wireless/libertas/debugfs.c b/drivers/net/wireless/libertas/debugfs.c
index a06cc28..0b48430 100644
--- a/drivers/net/wireless/libertas/debugfs.c
+++ b/drivers/net/wireless/libertas/debugfs.c
@@ -913,7 +913,10 @@ static ssize_t lbs_debugfs_write(struct file *f, const char __user *buf,
 	char *p2;
 	struct debug_data *d = f->private_data;
 
-	pdata = kmalloc(cnt, GFP_KERNEL);
+	if (cnt == 0)
+		return 0;
+
+	pdata = kmalloc(cnt + 1, GFP_KERNEL);
 	if (pdata == NULL)
 		return 0;
 
@@ -922,6 +925,7 @@ static ssize_t lbs_debugfs_write(struct file *f, const char __user *buf,
 		kfree(pdata);
 		return 0;
 	}
+	pdata[cnt] = '\0';
 
 	p0 = pdata;
 	for (i = 0; i < num_of_items; i++) {
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 821d9d2..44677fd 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -944,7 +944,10 @@ static int mwifiex_decode_rx_packet(struct mwifiex_adapter *adapter,
 				    struct sk_buff *skb, u32 upld_typ)
 {
 	u8 *cmd_buf;
+	__le16 *curr_ptr = (__le16 *)skb->data;
+	u16 pkt_len = le16_to_cpu(*curr_ptr);
 
+	skb_trim(skb, pkt_len);
 	skb_pull(skb, INTF_HEADER_LEN);
 
 	switch (upld_typ) {
diff --git a/drivers/net/wireless/prism54/islpci_dev.c b/drivers/net/wireless/prism54/islpci_dev.c
index 5970ff6..d498b02 100644
--- a/drivers/net/wireless/prism54/islpci_dev.c
+++ b/drivers/net/wireless/prism54/islpci_dev.c
@@ -811,6 +811,10 @@ static const struct net_device_ops islpci_netdev_ops = {
 	.ndo_validate_addr	= eth_validate_addr,
 };
 
+static struct device_type wlan_type = {
+	.name	= "wlan",
+};
+
 struct net_device *
 islpci_setup(struct pci_dev *pdev)
 {
@@ -821,9 +825,8 @@ islpci_setup(struct pci_dev *pdev)
 		return ndev;
 
 	pci_set_drvdata(pdev, ndev);
-#if defined(SET_NETDEV_DEV)
 	SET_NETDEV_DEV(ndev, &pdev->dev);
-#endif
+	SET_NETDEV_DEVTYPE(ndev, &wlan_type);
 
 	/* setup the structure members */
 	ndev->base_addr = pci_resource_start(pdev, 0);
diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
index 4110a6d..c78fb9a 100644
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -37,6 +37,7 @@
 
 #include <linux/ip.h>
 #include <linux/module.h>
+#include <linux/udp.h>
 
 /*
  *NOTICE!!!: This file will be very big, we should
@@ -957,61 +958,51 @@ u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx)
 	if (!ieee80211_is_data(fc))
 		return false;
 
+	ip = (const struct iphdr *)(skb->data + mac_hdr_len +
+				    SNAP_SIZE + PROTOC_TYPE_SIZE);
+	ether_type = be16_to_cpup((__be16 *)
+				  (skb->data + mac_hdr_len + SNAP_SIZE));
 
-	ip = (struct iphdr *)((u8 *) skb->data + mac_hdr_len +
-			      SNAP_SIZE + PROTOC_TYPE_SIZE);
-	ether_type = *(u16 *) ((u8 *) skb->data + mac_hdr_len + SNAP_SIZE);
-	/*	ether_type = ntohs(ether_type); */
-
-	if (ETH_P_IP == ether_type) {
-		if (IPPROTO_UDP == ip->protocol) {
-			struct udphdr *udp = (struct udphdr *)((u8 *) ip +
-							       (ip->ihl << 2));
-			if (((((u8 *) udp)[1] == 68) &&
-			     (((u8 *) udp)[3] == 67)) ||
-			    ((((u8 *) udp)[1] == 67) &&
-			     (((u8 *) udp)[3] == 68))) {
-				/*
-				 * 68 : UDP BOOTP client
-				 * 67 : UDP BOOTP server
-				 */
-				RT_TRACE(rtlpriv, (COMP_SEND | COMP_RECV),
-					 DBG_DMESG, "dhcp %s !!\n",
-					 is_tx ? "Tx" : "Rx");
-
-				if (is_tx) {
-					schedule_work(&rtlpriv->
-						      works.lps_leave_work);
-					ppsc->last_delaylps_stamp_jiffies =
-					    jiffies;
-				}
+	switch (ether_type) {
+	case ETH_P_IP: {
+		struct udphdr *udp;
+		u16 src;
+		u16 dst;
 
-				return true;
-			}
-		}
-	} else if (ETH_P_ARP == ether_type) {
-		if (is_tx) {
-			schedule_work(&rtlpriv->works.lps_leave_work);
-			ppsc->last_delaylps_stamp_jiffies = jiffies;
-		}
+		if (ip->protocol != IPPROTO_UDP)
+			return false;
+		udp = (struct udphdr *)((u8 *)ip + (ip->ihl << 2));
+		src = be16_to_cpu(udp->source);
+		dst = be16_to_cpu(udp->dest);
 
-		return true;
-	} else if (ETH_P_PAE == ether_type) {
+		/* If this case involves port 68 (UDP BOOTP client) connecting
+		 * with port 67 (UDP BOOTP server), then return true so that
+		 * the lowest speed is used.
+		 */
+		if (!((src == 68 && dst == 67) || (src == 67 && dst == 68)))
+			return false;
+
+		RT_TRACE(rtlpriv, (COMP_SEND | COMP_RECV), DBG_DMESG,
+			 "dhcp %s !!\n", is_tx ? "Tx" : "Rx");
+		break;
+	}
+	case ETH_P_ARP:
+		break;
+	case ETH_P_PAE:
 		RT_TRACE(rtlpriv, (COMP_SEND | COMP_RECV), DBG_DMESG,
 			 "802.1X %s EAPOL pkt!!\n", is_tx ? "Tx" : "Rx");
-
-		if (is_tx) {
-			schedule_work(&rtlpriv->works.lps_leave_work);
-			ppsc->last_delaylps_stamp_jiffies = jiffies;
-		}
-
-		return true;
-	} else if (ETH_P_IPV6 == ether_type) {
-		/* IPv6 */
-		return true;
+		break;
+	case ETH_P_IPV6:
+		/* TODO: Is this right? */
+		return false;
+	default:
+		return false;
 	}
-
-	return false;
+	if (is_tx) {
+		schedule_work(&rtlpriv->works.lps_leave_work);
+		ppsc->last_delaylps_stamp_jiffies = jiffies;
+	}
+	return true;
 }
 
 /*********************************************************
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
index 7e91c76..ce0f14a 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
@@ -762,7 +762,7 @@ static long _rtl92c_signal_scale_mapping(struct ieee80211_hw *hw,
 
 static void _rtl92c_query_rxphystatus(struct ieee80211_hw *hw,
 				      struct rtl_stats *pstats,
-				      struct rx_desc_92c *pdesc,
+				      struct rx_desc_92c *p_desc,
 				      struct rx_fwinfo_92c *p_drvinfo,
 				      bool packet_match_bssid,
 				      bool packet_toself,
@@ -777,11 +777,11 @@ static void _rtl92c_query_rxphystatus(struct ieee80211_hw *hw,
 	u32 rssi, total_rssi = 0;
 	bool in_powersavemode = false;
 	bool is_cck_rate;
+	u8 *pdesc = (u8 *)p_desc;
 
-	is_cck_rate = RX_HAL_IS_CCK_RATE(pdesc);
+	is_cck_rate = RX_HAL_IS_CCK_RATE(p_desc);
 	pstats->packet_matchbssid = packet_match_bssid;
 	pstats->packet_toself = packet_toself;
-	pstats->is_cck = is_cck_rate;
 	pstats->packet_beacon = packet_beacon;
 	pstats->is_cck = is_cck_rate;
 	pstats->RX_SIGQ[0] = -1;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
index 9adb21a..5654b0a 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -303,10 +303,10 @@ out:
 bool rtl92cu_rx_query_desc(struct ieee80211_hw *hw,
 			   struct rtl_stats *stats,
 			   struct ieee80211_rx_status *rx_status,
-			   u8 *p_desc, struct sk_buff *skb)
+			   u8 *pdesc, struct sk_buff *skb)
 {
 	struct rx_fwinfo_92c *p_drvinfo;
-	struct rx_desc_92c *pdesc = (struct rx_desc_92c *)p_desc;
+	struct rx_desc_92c *p_desc = (struct rx_desc_92c *)pdesc;
 	u32 phystatus = GET_RX_DESC_PHY_STATUS(pdesc);
 
 	stats->length = (u16) GET_RX_DESC_PKT_LEN(pdesc);
@@ -345,12 +345,11 @@ bool rtl92cu_rx_query_desc(struct ieee80211_hw *hw,
 	if (phystatus) {
 		p_drvinfo = (struct rx_fwinfo_92c *)(skb->data +
 						     stats->rx_bufshift);
-		rtl92c_translate_rx_signal_stuff(hw, skb, stats, pdesc,
+		rtl92c_translate_rx_signal_stuff(hw, skb, stats, p_desc,
 						 p_drvinfo);
 	}
 	/*rx_status->qual = stats->signal; */
-	rx_status->signal = stats->rssi + 10;
-	/*rx_status->noise = -stats->noise; */
+	rx_status->signal = stats->recvsignalpower + 10;
 	return true;
 }
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/trx.c b/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
index 1666ef7..5ea19cc 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
@@ -530,8 +530,7 @@ bool rtl92de_rx_query_desc(struct ieee80211_hw *hw,	struct rtl_stats *stats,
 						   p_drvinfo);
 	}
 	/*rx_status->qual = stats->signal; */
-	rx_status->signal = stats->rssi + 10;
-	/*rx_status->noise = -stats->noise; */
+	rx_status->signal = stats->recvsignalpower + 10;
 	return true;
 }
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/rf.c b/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
index 08c2f56..c405f96 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
@@ -268,7 +268,7 @@ static void _rtl92s_get_txpower_writeval_byregulatory(struct ieee80211_hw *hw,
 				    rtlefuse->pwrgroup_ht40
 				    [RF90_PATH_A][chnl - 1]) {
 					pwrdiff_limit[i] =
-					  rtlefuse->pwrgroup_ht20
+					  rtlefuse->pwrgroup_ht40
 					  [RF90_PATH_A][chnl - 1];
 				}
 			} else {
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
index 812b585..4e4bb57 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
@@ -583,8 +583,7 @@ bool rtl92se_rx_query_desc(struct ieee80211_hw *hw, struct rtl_stats *stats,
 	}
 
 	/*rx_status->qual = stats->signal; */
-	rx_status->signal = stats->rssi + 10;
-	/*rx_status->noise = -stats->noise; */
+	rx_status->signal = stats->recvsignalpower + 10;
 
 	return true;
 }
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index dec7c55..fa02202 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -77,11 +77,7 @@
 #define RTL_SLOT_TIME_9				9
 #define RTL_SLOT_TIME_20			20
 
-/*related with tcp/ip. */
-/*if_ehther.h*/
-#define ETH_P_PAE		0x888E	/*Port Access Entity (IEEE 802.1X) */
-#define ETH_P_IP		0x0800	/*Internet Protocol packet */
-#define ETH_P_ARP		0x0806	/*Address Resolution packet */
+/*related to tcp/ip. */
 #define SNAP_SIZE		6
 #define PROTOC_TYPE_SIZE	2
 
diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
index e0610bd..7e41b70 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -151,7 +151,6 @@ static int __devinit pcie_portdrv_probe(struct pci_dev *dev,
 static void pcie_portdrv_remove(struct pci_dev *dev)
 {
 	pcie_port_device_remove(dev);
-	pci_disable_device(dev);
 }
 
 static int error_detected_iter(struct device *device, void *data)
diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 0bd38da..05fbc3d 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -508,7 +508,8 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 		goto cleanup;
 	}
 
-	if (fibsize > (dev->max_fib_size - sizeof(struct aac_fibhdr))) {
+	if ((fibsize < (sizeof(struct user_aac_srb) - sizeof(struct user_sgentry))) ||
+	    (fibsize > (dev->max_fib_size - sizeof(struct aac_fibhdr)))) {
 		rcode = -EINVAL;
 		goto cleanup;
 	}
diff --git a/drivers/staging/iio/accel/kxsd9.c b/drivers/staging/iio/accel/kxsd9.c
index 8cf7cd9..cfa77fb 100644
--- a/drivers/staging/iio/accel/kxsd9.c
+++ b/drivers/staging/iio/accel/kxsd9.c
@@ -116,9 +116,10 @@ static int kxsd9_read(struct iio_dev *indio_dev, u8 address)
 	spi_message_add_tail(&xfers[0], &msg);
 	spi_message_add_tail(&xfers[1], &msg);
 	ret = spi_sync(st->us, &msg);
-	if (ret)
-		return ret;
-	return (((u16)(st->rx[0])) << 8) | (st->rx[1] & 0xF0);
+	if (!ret)
+		ret = (((u16)(st->rx[0])) << 8) | (st->rx[1] & 0xF0);
+	mutex_unlock(&st->buf_lock);
+	return ret;
 }
 
 static IIO_CONST_ATTR(accel_scale_available,
diff --git a/drivers/staging/tidspbridge/Kconfig b/drivers/staging/tidspbridge/Kconfig
index 0dd479f..f67c78e 100644
--- a/drivers/staging/tidspbridge/Kconfig
+++ b/drivers/staging/tidspbridge/Kconfig
@@ -4,7 +4,7 @@
 
 menuconfig TIDSPBRIDGE
 	tristate "DSP Bridge driver"
-	depends on ARCH_OMAP3
+	depends on ARCH_OMAP3 && BROKEN
 	select OMAP_MBOX_FWK
 	help
 	  DSP/BIOS Bridge is designed for platforms that contain a GPP and
diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 06f27f6..858e2a8 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -976,6 +976,7 @@ BOOL BBbVT3184Init(PSDevice pDevice)
     PBYTE                   pbyAgc;
     WORD                    wLengthAgc;
     BYTE                    abyArray[256];
+	u8 data;
 
     ntStatus = CONTROLnsRequestIn(pDevice,
                                   MESSAGE_TYPE_READ,
@@ -1144,6 +1145,16 @@ else {
     ControlvWriteByte(pDevice,MESSAGE_REQUEST_BBREG,0x0D,0x01);
 
     RFbRFTableDownload(pDevice);
+
+	/* Fix for TX USB resets from vendors driver */
+	CONTROLnsRequestIn(pDevice, MESSAGE_TYPE_READ, USB_REG4,
+		MESSAGE_REQUEST_MEM, sizeof(data), &data);
+
+	data |= 0x2;
+
+	CONTROLnsRequestOut(pDevice, MESSAGE_TYPE_WRITE, USB_REG4,
+		MESSAGE_REQUEST_MEM, sizeof(data), &data);
+
     return TRUE;//ntStatus;
 }
 
diff --git a/drivers/staging/vt6656/rndis.h b/drivers/staging/vt6656/rndis.h
index fccf7e9..dcf7bf5 100644
--- a/drivers/staging/vt6656/rndis.h
+++ b/drivers/staging/vt6656/rndis.h
@@ -69,6 +69,7 @@
 
 #define VIAUSB20_PACKET_HEADER          0x04
 
+#define USB_REG4	0x604
 
 /*---------------------  Export Classes  ----------------------------*/
 
diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
index 8ded9a0..0cebb76 100644
--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -230,7 +230,12 @@ static struct page *get_next_page(struct page *page)
 	return next;
 }
 
-/* Encode <page, obj_idx> as a single handle value */
+/*
+ * Encode <page, obj_idx> as a single handle value.
+ * On hardware platforms with physical memory starting at 0x0 the pfn
+ * could be 0 so we ensure that the handle will never be 0 by adjusting the
+ * encoded obj_idx value before encoding.
+ */
 static void *obj_location_to_handle(struct page *page, unsigned long obj_idx)
 {
 	unsigned long handle;
@@ -241,19 +246,23 @@ static void *obj_location_to_handle(struct page *page, unsigned long obj_idx)
 	}
 
 	handle = page_to_pfn(page) << OBJ_INDEX_BITS;
-	handle |= (obj_idx & OBJ_INDEX_MASK);
+	handle |= ((obj_idx + 1) & OBJ_INDEX_MASK);
 
 	return (void *)handle;
 }
 
-/* Decode <page, obj_idx> pair from the given object handle */
+/*
+ * Decode <page, obj_idx> pair from the given object handle. We adjust the
+ * decoded obj_idx back to its original value since it was adjusted in
+ * obj_location_to_handle().
+ */
 static void obj_handle_to_location(void *handle, struct page **page,
 				unsigned long *obj_idx)
 {
 	unsigned long hval = (unsigned long)handle;
 
 	*page = pfn_to_page(hval >> OBJ_INDEX_BITS);
-	*obj_idx = hval & OBJ_INDEX_MASK;
+	*obj_idx = (hval & OBJ_INDEX_MASK) - 1;
 }
 
 static unsigned long obj_idx_to_offset(struct page *page,
diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index a0fc7b9..b54f6ec 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -174,6 +174,7 @@ static int chap_server_compute_md5(
 	unsigned char client_digest[MD5_SIGNATURE_SIZE];
 	unsigned char server_digest[MD5_SIGNATURE_SIZE];
 	unsigned char chap_n[MAX_CHAP_N_SIZE], chap_r[MAX_RESPONSE_LENGTH];
+	size_t compare_len;
 	struct iscsi_chap *chap = conn->auth_protocol;
 	struct crypto_hash *tfm;
 	struct hash_desc desc;
@@ -212,7 +213,9 @@ static int chap_server_compute_md5(
 		goto out;
 	}
 
-	if (memcmp(chap_n, auth->userid, strlen(auth->userid)) != 0) {
+	/* Include the terminating NULL in the compare */
+	compare_len = strlen(auth->userid) + 1;
+	if (strncmp(chap_n, auth->userid, compare_len) != 0) {
 		pr_err("CHAP_N values do not match!\n");
 		goto out;
 	}
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 0184bea..89f8909 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -89,7 +89,7 @@ int extract_param(
 	if (len < 0)
 		return -1;
 
-	if (len > max_length) {
+	if (len >= max_length) {
 		pr_err("Length of input: %d exceeds max_length:"
 			" %d\n", len, max_length);
 		return -1;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 047f49a..3223867 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4263,6 +4263,7 @@ int transport_check_aborted_status(struct se_cmd *cmd, int send_status)
 			cmd->se_tfo->get_task_tag(cmd));
 
 		cmd->se_cmd_flags |= SCF_SENT_DELAYED_TAS;
+		cmd->scsi_status = SAM_STAT_TASK_ABORTED;
 		cmd->se_tfo->queue_status(cmd);
 		ret = 1;
 	}
@@ -4291,6 +4292,7 @@ void transport_send_task_abort(struct se_cmd *cmd)
 		if (cmd->se_tfo->write_pending_status(cmd) != 0) {
 			cmd->transport_state |= CMD_T_ABORTED;
 			smp_mb__after_atomic_inc();
+			return;
 		}
 	}
 	cmd->scsi_status = SAM_STAT_TASK_ABORTED;
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 4ee522b..4543520 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -3327,11 +3327,13 @@ static __u16 ACL_to_cifs_posix(char *parm_data, const char *pACL,
 		return 0;
 	}
 	cifs_acl->version = cpu_to_le16(1);
-	if (acl_type == ACL_TYPE_ACCESS)
+	if (acl_type == ACL_TYPE_ACCESS) {
 		cifs_acl->access_entry_count = cpu_to_le16(count);
-	else if (acl_type == ACL_TYPE_DEFAULT)
+		cifs_acl->default_entry_count = __constant_cpu_to_le16(0xFFFF);
+	} else if (acl_type == ACL_TYPE_DEFAULT) {
 		cifs_acl->default_entry_count = cpu_to_le16(count);
-	else {
+		cifs_acl->access_entry_count = __constant_cpu_to_le16(0xFFFF);
+	} else {
 		cFYI(1, "unknown ACL type %d", acl_type);
 		return 0;
 	}
diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 7e6c52d..c91f6d1 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -56,10 +56,19 @@ static void configfs_d_iput(struct dentry * dentry,
 	struct configfs_dirent *sd = dentry->d_fsdata;
 
 	if (sd) {
-		BUG_ON(sd->s_dentry != dentry);
 		/* Coordinate with configfs_readdir */
 		spin_lock(&configfs_dirent_lock);
-		sd->s_dentry = NULL;
+		/* Coordinate with configfs_attach_attr where will increase
+		 * sd->s_count and update sd->s_dentry to new allocated one.
+		 * Only set sd->dentry to null when this dentry is the only
+		 * sd owner.
+		 * If not do so, configfs_d_iput may run just after
+		 * configfs_attach_attr and set sd->s_dentry to null
+		 * even it's still in use.
+		 */
+		if (atomic_read(&sd->s_count) <= 2)
+			sd->s_dentry = NULL;
+
 		spin_unlock(&configfs_dirent_lock);
 		configfs_put(sd);
 	}
@@ -426,8 +435,11 @@ static int configfs_attach_attr(struct configfs_dirent * sd, struct dentry * den
 	struct configfs_attribute * attr = sd->s_element;
 	int error;
 
+	spin_lock(&configfs_dirent_lock);
 	dentry->d_fsdata = configfs_get(sd);
 	sd->s_dentry = dentry;
+	spin_unlock(&configfs_dirent_lock);
+
 	error = configfs_create(dentry, (attr->ca_mode & S_IALLUGO) | S_IFREG,
 				configfs_init_file);
 	if (error) {
diff --git a/fs/exec.c b/fs/exec.c
index 832763a..ac0a868 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -2049,6 +2049,12 @@ static int __get_dumpable(unsigned long mm_flags)
 	return (ret >= 2) ? 2 : ret;
 }
 
+/*
+ * This returns the actual value of the suid_dumpable flag. For things
+ * that are using this for checking for privilege transitions, it must
+ * test against SUID_DUMP_USER rather than treating it as a boolean
+ * value.
+ */
 int get_dumpable(struct mm_struct *mm)
 {
 	return __get_dumpable(mm->flags);
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index e979d5d..2f7cf35 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1330,6 +1330,7 @@ retry:
 					new_extra_isize = s_min_extra_isize;
 					kfree(is); is = NULL;
 					kfree(bs); bs = NULL;
+					brelse(bh);
 					goto retry;
 				}
 				error = -1;
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 65ed9bf..b2ae2da 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -161,8 +161,8 @@ static __be32 *read_buf(struct nfsd4_compoundargs *argp, u32 nbytes)
 	 */
 	memcpy(p, argp->p, avail);
 	/* step to next page */
-	argp->pagelist++;
 	argp->p = page_address(argp->pagelist[0]);
+	argp->pagelist++;
 	if (argp->pagelen < PAGE_SIZE) {
 		argp->end = argp->p + (argp->pagelen>>2);
 		argp->pagelen = 0;
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 20c5092..474afc6 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -297,41 +297,12 @@ commit_metadata(struct svc_fh *fhp)
 }
 
 /*
- * Set various file attributes.
- * N.B. After this call fhp needs an fh_put
+ * Go over the attributes and take care of the small differences between
+ * NFS semantics and what Linux expects.
  */
-__be32
-nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp, struct iattr *iap,
-	     int check_guard, time_t guardtime)
+static void
+nfsd_sanitize_attrs(struct inode *inode, struct iattr *iap)
 {
-	struct dentry	*dentry;
-	struct inode	*inode;
-	int		accmode = NFSD_MAY_SATTR;
-	umode_t		ftype = 0;
-	__be32		err;
-	int		host_err;
-	int		size_change = 0;
-
-	if (iap->ia_valid & (ATTR_ATIME | ATTR_MTIME | ATTR_SIZE))
-		accmode |= NFSD_MAY_WRITE|NFSD_MAY_OWNER_OVERRIDE;
-	if (iap->ia_valid & ATTR_SIZE)
-		ftype = S_IFREG;
-
-	/* Get inode */
-	err = fh_verify(rqstp, fhp, ftype, accmode);
-	if (err)
-		goto out;
-
-	dentry = fhp->fh_dentry;
-	inode = dentry->d_inode;
-
-	/* Ignore any mode updates on symlinks */
-	if (S_ISLNK(inode->i_mode))
-		iap->ia_valid &= ~ATTR_MODE;
-
-	if (!iap->ia_valid)
-		goto out;
-
 	/*
 	 * NFSv2 does not differentiate between "set-[ac]time-to-now"
 	 * which only requires access, and "set-[ac]time-to-X" which
@@ -341,8 +312,7 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp, struct iattr *iap,
 	 * convert to "set to now" instead of "set to explicit time"
 	 *
 	 * We only call inode_change_ok as the last test as technically
-	 * it is not an interface that we should be using.  It is only
-	 * valid if the filesystem does not define it's own i_op->setattr.
+	 * it is not an interface that we should be using.
 	 */
 #define BOTH_TIME_SET (ATTR_ATIME_SET | ATTR_MTIME_SET)
 #define	MAX_TOUCH_TIME_ERROR (30*60)
@@ -368,30 +338,6 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp, struct iattr *iap,
 			iap->ia_valid &= ~BOTH_TIME_SET;
 		}
 	}
-	    
-	/*
-	 * The size case is special.
-	 * It changes the file as well as the attributes.
-	 */
-	if (iap->ia_valid & ATTR_SIZE) {
-		if (iap->ia_size < inode->i_size) {
-			err = nfsd_permission(rqstp, fhp->fh_export, dentry,
-					NFSD_MAY_TRUNC|NFSD_MAY_OWNER_OVERRIDE);
-			if (err)
-				goto out;
-		}
-
-		host_err = get_write_access(inode);
-		if (host_err)
-			goto out_nfserr;
-
-		size_change = 1;
-		host_err = locks_verify_truncate(inode, NULL, iap->ia_size);
-		if (host_err) {
-			put_write_access(inode);
-			goto out_nfserr;
-		}
-	}
 
 	/* sanitize the mode change */
 	if (iap->ia_valid & ATTR_MODE) {
@@ -414,32 +360,111 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp, struct iattr *iap,
 			iap->ia_valid |= (ATTR_KILL_SUID | ATTR_KILL_SGID);
 		}
 	}
+}
 
-	/* Change the attributes. */
+static __be32
+nfsd_get_write_access(struct svc_rqst *rqstp, struct svc_fh *fhp,
+		struct iattr *iap)
+{
+	struct inode *inode = fhp->fh_dentry->d_inode;
+	int host_err;
 
-	iap->ia_valid |= ATTR_CTIME;
+	if (iap->ia_size < inode->i_size) {
+		__be32 err;
 
-	err = nfserr_notsync;
-	if (!check_guard || guardtime == inode->i_ctime.tv_sec) {
-		host_err = nfsd_break_lease(inode);
-		if (host_err)
-			goto out_nfserr;
-		fh_lock(fhp);
+		err = nfsd_permission(rqstp, fhp->fh_export, fhp->fh_dentry,
+				NFSD_MAY_TRUNC | NFSD_MAY_OWNER_OVERRIDE);
+		if (err)
+			return err;
+	}
 
-		host_err = notify_change(dentry, iap);
-		err = nfserrno(host_err);
-		fh_unlock(fhp);
+	host_err = get_write_access(inode);
+	if (host_err)
+		goto out_nfserrno;
+
+	host_err = locks_verify_truncate(inode, NULL, iap->ia_size);
+	if (host_err)
+		goto out_put_write_access;
+	return 0;
+
+out_put_write_access:
+	put_write_access(inode);
+out_nfserrno:
+	return nfserrno(host_err);
+}
+
+/*
+ * Set various file attributes.  After this call fhp needs an fh_put.
+ */
+__be32
+nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp, struct iattr *iap,
+	     int check_guard, time_t guardtime)
+{
+	struct dentry	*dentry;
+	struct inode	*inode;
+	int		accmode = NFSD_MAY_SATTR;
+	umode_t		ftype = 0;
+	__be32		err;
+	int		host_err;
+	int		size_change = 0;
+
+	if (iap->ia_valid & (ATTR_ATIME | ATTR_MTIME | ATTR_SIZE))
+		accmode |= NFSD_MAY_WRITE|NFSD_MAY_OWNER_OVERRIDE;
+	if (iap->ia_valid & ATTR_SIZE)
+		ftype = S_IFREG;
+
+	/* Get inode */
+	err = fh_verify(rqstp, fhp, ftype, accmode);
+	if (err)
+		goto out;
+
+	dentry = fhp->fh_dentry;
+	inode = dentry->d_inode;
+
+	/* Ignore any mode updates on symlinks */
+	if (S_ISLNK(inode->i_mode))
+		iap->ia_valid &= ~ATTR_MODE;
+
+	if (!iap->ia_valid)
+		goto out;
+
+	nfsd_sanitize_attrs(inode, iap);
+
+	/*
+	 * The size case is special, it changes the file in addition to the
+	 * attributes.
+	 */
+	if (iap->ia_valid & ATTR_SIZE) {
+		err = nfsd_get_write_access(rqstp, fhp, iap);
+		if (err)
+			goto out;
+		size_change = 1;
 	}
+
+	iap->ia_valid |= ATTR_CTIME;
+
+	if (check_guard && guardtime != inode->i_ctime.tv_sec) {
+		err = nfserr_notsync;
+		goto out_put_write_access;
+	}
+
+	host_err = nfsd_break_lease(inode);
+	if (host_err)
+		goto out_put_write_access_nfserror;
+
+	fh_lock(fhp);
+	host_err = notify_change(dentry, iap);
+	fh_unlock(fhp);
+
+out_put_write_access_nfserror:
+	err = nfserrno(host_err);
+out_put_write_access:
 	if (size_change)
 		put_write_access(inode);
 	if (!err)
 		commit_metadata(fhp);
 out:
 	return err;
-
-out_nfserr:
-	err = nfserrno(host_err);
-	goto out;
 }
 
 #if defined(CONFIG_NFSD_V2_ACL) || \
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 5bab59b..424b381 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -113,9 +113,6 @@ extern void setup_new_exec(struct linux_binprm * bprm);
 extern void would_dump(struct linux_binprm *, struct file *);
 
 extern int suid_dumpable;
-#define SUID_DUMP_DISABLE	0	/* No setuid dumping */
-#define SUID_DUMP_USER		1	/* Dump as user of process */
-#define SUID_DUMP_ROOT		2	/* Dump as root */
 
 /* Stack area protections */
 #define EXSTACK_DEFAULT   0	/* Whatever the arch defaults to */
diff --git a/include/linux/mtd/map.h b/include/linux/mtd/map.h
index 3595a02..292645f 100644
--- a/include/linux/mtd/map.h
+++ b/include/linux/mtd/map.h
@@ -362,7 +362,7 @@ static inline map_word map_word_load_partial(struct map_info *map, map_word orig
 			bitpos = (map_bankwidth(map)-1-i)*8;
 #endif
 			orig.x[0] &= ~(0xff << bitpos);
-			orig.x[0] |= buf[i-start] << bitpos;
+			orig.x[0] |= (unsigned long)buf[i-start] << bitpos;
 		}
 	}
 	return orig;
@@ -381,7 +381,7 @@ static inline map_word map_word_ff(struct map_info *map)
 
 	if (map_bankwidth(map) < MAP_FF_LIMIT) {
 		int bw = 8 * map_bankwidth(map);
-		r.x[0] = (1 << bw) - 1;
+		r.x[0] = (1UL << bw) - 1;
 	} else {
 		for (i=0; i<map_words(map); i++)
 			r.x[i] = ~0UL;
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index a3f8d6d..5066e76 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1602,6 +1602,7 @@
 #define PCI_SUBDEVICE_ID_KEYSPAN_SX2	0x5334
 
 #define PCI_VENDOR_ID_MARVELL		0x11ab
+#define PCI_VENDOR_ID_MARVELL_EXT	0x1b4b
 #define PCI_DEVICE_ID_MARVELL_GT64111	0x4146
 #define PCI_DEVICE_ID_MARVELL_GT64260	0x6430
 #define PCI_DEVICE_ID_MARVELL_MV64360	0x6460
diff --git a/include/linux/sched.h b/include/linux/sched.h
index ebd15f9..be28098 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -406,6 +406,10 @@ static inline void arch_pick_mmap_layout(struct mm_struct *mm) {}
 extern void set_dumpable(struct mm_struct *mm, int value);
 extern int get_dumpable(struct mm_struct *mm);
 
+#define SUID_DUMP_DISABLE	0	/* No setuid dumping */
+#define SUID_DUMP_USER		1	/* Dump as user of process */
+#define SUID_DUMP_ROOT		2	/* Dump as root */
+
 /* mm flags */
 /* dumpable bits */
 #define MMF_DUMPABLE      0  /* core dump is permitted */
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 7697249..763bf05 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -379,7 +379,8 @@ ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 	__data_size += (len) * sizeof(type);
 
 #undef __string
-#define __string(item, src) __dynamic_array(char, item, strlen(src) + 1)
+#define __string(item, src) __dynamic_array(char, item,			\
+		    strlen((src) ? (const char *)(src) : "(null)") + 1)
 
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
@@ -504,7 +505,7 @@ static inline notrace int ftrace_get_offsets_##call(			\
 
 #undef __assign_str
 #define __assign_str(dst, src)						\
-	strcpy(__get_str(dst), src);
+	strcpy(__get_str(dst), (src) ? (const char *)(src) : "(null)");
 
 #undef TP_fast_assign
 #define TP_fast_assign(args...) args
diff --git a/kernel/audit.c b/kernel/audit.c
index 5917dfe..03900ab 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -625,7 +625,7 @@ static int audit_log_common_recv_msg(struct audit_buffer **ab, u16 msg_type,
 	char *ctx = NULL;
 	u32 len;
 
-	if (!audit_enabled) {
+	if (!audit_enabled && msg_type != AUDIT_USER_AVC) {
 		*ab = NULL;
 		return rc;
 	}
@@ -684,6 +684,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 
 	switch (msg_type) {
 	case AUDIT_GET:
+		status_set.mask		 = 0;
 		status_set.enabled	 = audit_enabled;
 		status_set.failure	 = audit_failure;
 		status_set.pid		 = audit_pid;
@@ -695,7 +696,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 				 &status_set, sizeof(status_set));
 		break;
 	case AUDIT_SET:
-		if (nlh->nlmsg_len < sizeof(struct audit_status))
+		if (nlmsg_len(nlh) < sizeof(struct audit_status))
 			return -EINVAL;
 		status_get   = (struct audit_status *)data;
 		if (status_get->mask & AUDIT_STATUS_ENABLED) {
@@ -899,7 +900,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		struct task_struct *tsk;
 		unsigned long flags;
 
-		if (nlh->nlmsg_len < sizeof(struct audit_tty_status))
+		if (nlmsg_len(nlh) < sizeof(struct audit_tty_status))
 			return -EINVAL;
 		s = data;
 		if (s->enabled != 0 && s->enabled != 1)
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 4611da5..2627f0d0 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -983,8 +983,10 @@ static void cpuset_change_task_nodemask(struct task_struct *tsk,
 	need_loop = task_has_mempolicy(tsk) ||
 			!nodes_intersects(*newmems, tsk->mems_allowed);
 
-	if (need_loop)
+	if (need_loop) {
+		local_irq_disable();
 		write_seqcount_begin(&tsk->mems_allowed_seq);
+	}
 
 	nodes_or(tsk->mems_allowed, tsk->mems_allowed, *newmems);
 	mpol_rebind_task(tsk, newmems, MPOL_REBIND_STEP1);
@@ -992,8 +994,10 @@ static void cpuset_change_task_nodemask(struct task_struct *tsk,
 	mpol_rebind_task(tsk, newmems, MPOL_REBIND_STEP2);
 	tsk->mems_allowed = *newmems;
 
-	if (need_loop)
+	if (need_loop) {
 		write_seqcount_end(&tsk->mems_allowed_seq);
+		local_irq_enable();
+	}
 
 	task_unlock(tsk);
 }
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 0de2857..91c04f1 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1398,7 +1398,11 @@ int hibernate_preallocate_memory(void)
 	 * highmem and non-highmem zones separately.
 	 */
 	pages_highmem = preallocate_image_highmem(highmem / 2);
-	alloc = (count - max_size) - pages_highmem;
+	alloc = count - max_size;
+	if (alloc > pages_highmem)
+		alloc -= pages_highmem;
+	else
+		alloc = 0;
 	pages = preallocate_image_memory(alloc, avail_normal);
 	if (pages < alloc) {
 		/* We have exhausted non-highmem pages, try highmem. */
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index b96de86b4..6bdbe71 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -253,7 +253,8 @@ ok:
 	smp_rmb();
 	if (task->mm)
 		dumpable = get_dumpable(task->mm);
-	if (!dumpable  && !ptrace_has_cap(task_user_ns(task), mode))
+	if (dumpable != SUID_DUMP_USER &&
+	    !ptrace_has_cap(task_user_ns(task), mode))
 		return -EPERM;
 
 	return security_ptrace_access_check(task, mode);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 36759bf..9d7ae0c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -312,9 +312,6 @@ static int remove_ftrace_list_ops(struct ftrace_ops **list,
 
 static int __register_ftrace_function(struct ftrace_ops *ops)
 {
-	if (ftrace_disabled)
-		return -ENODEV;
-
 	if (FTRACE_WARN_ON(ops == &global_ops))
 		return -EINVAL;
 
@@ -348,9 +345,6 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 {
 	int ret;
 
-	if (ftrace_disabled)
-		return -ENODEV;
-
 	if (WARN_ON(!(ops->flags & FTRACE_OPS_FL_ENABLED)))
 		return -EBUSY;
 
@@ -1930,10 +1924,15 @@ static void ftrace_startup_enable(int command)
 static int ftrace_startup(struct ftrace_ops *ops, int command)
 {
 	bool hash_enable = true;
+	int ret;
 
 	if (unlikely(ftrace_disabled))
 		return -ENODEV;
 
+	ret = __register_ftrace_function(ops);
+	if (ret)
+		return ret;
+
 	ftrace_start_up++;
 	command |= FTRACE_UPDATE_CALLS;
 
@@ -1955,12 +1954,17 @@ static int ftrace_startup(struct ftrace_ops *ops, int command)
 	return 0;
 }
 
-static void ftrace_shutdown(struct ftrace_ops *ops, int command)
+static int ftrace_shutdown(struct ftrace_ops *ops, int command)
 {
 	bool hash_disable = true;
+	int ret;
 
 	if (unlikely(ftrace_disabled))
-		return;
+		return -ENODEV;
+
+	ret = __unregister_ftrace_function(ops);
+	if (ret)
+		return ret;
 
 	ftrace_start_up--;
 	/*
@@ -1995,9 +1999,10 @@ static void ftrace_shutdown(struct ftrace_ops *ops, int command)
 	}
 
 	if (!command || !ftrace_enabled)
-		return;
+		return 0;
 
 	ftrace_run_update_code(command);
+	return 0;
 }
 
 static void ftrace_startup_sysctl(void)
@@ -2841,16 +2846,13 @@ static void __enable_ftrace_function_probe(void)
 	if (i == FTRACE_FUNC_HASHSIZE)
 		return;
 
-	ret = __register_ftrace_function(&trace_probe_ops);
-	if (!ret)
-		ret = ftrace_startup(&trace_probe_ops, 0);
+	ret = ftrace_startup(&trace_probe_ops, 0);
 
 	ftrace_probe_registered = 1;
 }
 
 static void __disable_ftrace_function_probe(void)
 {
-	int ret;
 	int i;
 
 	if (!ftrace_probe_registered)
@@ -2863,9 +2865,7 @@ static void __disable_ftrace_function_probe(void)
 	}
 
 	/* no more funcs left */
-	ret = __unregister_ftrace_function(&trace_probe_ops);
-	if (!ret)
-		ftrace_shutdown(&trace_probe_ops, 0);
+	ftrace_shutdown(&trace_probe_ops, 0);
 
 	ftrace_probe_registered = 0;
 }
@@ -3942,12 +3942,15 @@ device_initcall(ftrace_nodyn_init);
 static inline int ftrace_init_dyn_debugfs(struct dentry *d_tracer) { return 0; }
 static inline void ftrace_startup_enable(int command) { }
 /* Keep as macros so we do not need to define the commands */
-# define ftrace_startup(ops, command)			\
-	({						\
-		(ops)->flags |= FTRACE_OPS_FL_ENABLED;	\
-		0;					\
+# define ftrace_startup(ops, command)					\
+	({								\
+		int ___ret = __register_ftrace_function(ops);		\
+		if (!___ret)						\
+			(ops)->flags |= FTRACE_OPS_FL_ENABLED;		\
+		___ret;							\
 	})
-# define ftrace_shutdown(ops, command)	do { } while (0)
+# define ftrace_shutdown(ops, command) __unregister_ftrace_function(ops)
+
 # define ftrace_startup_sysctl()	do { } while (0)
 # define ftrace_shutdown_sysctl()	do { } while (0)
 
@@ -4317,15 +4320,8 @@ int register_ftrace_function(struct ftrace_ops *ops)
 
 	mutex_lock(&ftrace_lock);
 
-	if (unlikely(ftrace_disabled))
-		goto out_unlock;
-
-	ret = __register_ftrace_function(ops);
-	if (!ret)
-		ret = ftrace_startup(ops, 0);
-
+	ret = ftrace_startup(ops, 0);
 
- out_unlock:
 	mutex_unlock(&ftrace_lock);
 	return ret;
 }
@@ -4342,9 +4338,7 @@ int unregister_ftrace_function(struct ftrace_ops *ops)
 	int ret;
 
 	mutex_lock(&ftrace_lock);
-	ret = __unregister_ftrace_function(ops);
-	if (!ret)
-		ftrace_shutdown(ops, 0);
+	ret = ftrace_shutdown(ops, 0);
 	mutex_unlock(&ftrace_lock);
 
 	return ret;
@@ -4538,6 +4532,12 @@ ftrace_suspend_notifier_call(struct notifier_block *bl, unsigned long state,
 	return NOTIFY_DONE;
 }
 
+/* Just a place holder for function graph */
+static struct ftrace_ops fgraph_ops __read_mostly = {
+	.func		= ftrace_stub,
+	.flags		= FTRACE_OPS_FL_GLOBAL,
+};
+
 int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 			trace_func_graph_ent_t entryfunc)
 {
@@ -4564,7 +4564,7 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 	ftrace_graph_return = retfunc;
 	ftrace_graph_entry = entryfunc;
 
-	ret = ftrace_startup(&global_ops, FTRACE_START_FUNC_RET);
+	ret = ftrace_startup(&fgraph_ops, FTRACE_START_FUNC_RET);
 
 out:
 	mutex_unlock(&ftrace_lock);
@@ -4581,7 +4581,7 @@ void unregister_ftrace_graph(void)
 	ftrace_graph_active--;
 	ftrace_graph_return = (trace_func_graph_ret_t)ftrace_stub;
 	ftrace_graph_entry = ftrace_graph_entry_stub;
-	ftrace_shutdown(&global_ops, FTRACE_STOP_FUNC_RET);
+	ftrace_shutdown(&fgraph_ops, FTRACE_STOP_FUNC_RET);
 	unregister_pm_notifier(&ftrace_suspend_notifier);
 	unregister_trace_sched_switch(ftrace_graph_probe_sched_switch, NULL);
 
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 6b0dd20..46b5fb6 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -599,14 +599,16 @@ EXPORT_SYMBOL_GPL(rpc_shutdown_client);
 /*
  * Free an RPC client
  */
-static void
+static struct rpc_clnt *
 rpc_free_client(struct rpc_clnt *clnt)
 {
+	struct rpc_clnt *parent = NULL;
+
 	dprintk_rcu("RPC:       destroying %s client for %s\n",
 			clnt->cl_protname,
 			rcu_dereference(clnt->cl_xprt)->servername);
 	if (clnt->cl_parent != clnt)
-		rpc_release_client(clnt->cl_parent);
+		parent = clnt->cl_parent;
 	rpc_unregister_client(clnt);
 	rpc_clnt_remove_pipedir(clnt);
 	rpc_free_iostats(clnt->cl_metrics);
@@ -615,18 +617,17 @@ rpc_free_client(struct rpc_clnt *clnt)
 	xprt_put(rcu_dereference_raw(clnt->cl_xprt));
 	rpciod_down();
 	kfree(clnt);
+	return parent;
 }
 
 /*
  * Free an RPC client
  */
-static void
+static struct rpc_clnt * 
 rpc_free_auth(struct rpc_clnt *clnt)
 {
-	if (clnt->cl_auth == NULL) {
-		rpc_free_client(clnt);
-		return;
-	}
+	if (clnt->cl_auth == NULL)
+		return rpc_free_client(clnt);
 
 	/*
 	 * Note: RPCSEC_GSS may need to send NULL RPC calls in order to
@@ -637,7 +638,8 @@ rpc_free_auth(struct rpc_clnt *clnt)
 	rpcauth_release(clnt->cl_auth);
 	clnt->cl_auth = NULL;
 	if (atomic_dec_and_test(&clnt->cl_count))
-		rpc_free_client(clnt);
+		return rpc_free_client(clnt);
+	return NULL;
 }
 
 /*
@@ -648,10 +650,13 @@ rpc_release_client(struct rpc_clnt *clnt)
 {
 	dprintk("RPC:       rpc_release_client(%p)\n", clnt);
 
-	if (list_empty(&clnt->cl_tasks))
-		wake_up(&destroy_wait);
-	if (atomic_dec_and_test(&clnt->cl_count))
-		rpc_free_auth(clnt);
+	do {
+		if (list_empty(&clnt->cl_tasks))
+			wake_up(&destroy_wait);
+		if (!atomic_dec_and_test(&clnt->cl_count))
+			break;
+		clnt = rpc_free_auth(clnt);
+	} while (clnt != NULL);
 }
 
 /**
@@ -1334,9 +1339,9 @@ call_refreshresult(struct rpc_task *task)
 		return;
 	case -ETIMEDOUT:
 		rpc_delay(task, 3*HZ);
-	case -EKEYEXPIRED:
 	case -EAGAIN:
 		status = -EACCES;
+	case -EKEYEXPIRED:
 		if (!task->tk_cred_retry)
 			break;
 		task->tk_cred_retry--;
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 79064471..31f981d 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -390,8 +390,10 @@ static int xs_send_kvec(struct socket *sock, struct sockaddr *addr, int addrlen,
 	return kernel_sendmsg(sock, &msg, NULL, 0, 0);
 }
 
-static int xs_send_pagedata(struct socket *sock, struct xdr_buf *xdr, unsigned int base, int more)
+static int xs_send_pagedata(struct socket *sock, struct xdr_buf *xdr, unsigned int base, int more, bool zerocopy)
 {
+	ssize_t (*do_sendpage)(struct socket *sock, struct page *page,
+			int offset, size_t size, int flags);
 	struct page **ppage;
 	unsigned int remainder;
 	int err, sent = 0;
@@ -400,6 +402,9 @@ static int xs_send_pagedata(struct socket *sock, struct xdr_buf *xdr, unsigned i
 	base += xdr->page_base;
 	ppage = xdr->pages + (base >> PAGE_SHIFT);
 	base &= ~PAGE_MASK;
+	do_sendpage = sock->ops->sendpage;
+	if (!zerocopy)
+		do_sendpage = sock_no_sendpage;
 	for(;;) {
 		unsigned int len = min_t(unsigned int, PAGE_SIZE - base, remainder);
 		int flags = XS_SENDMSG_FLAGS;
@@ -407,7 +412,7 @@ static int xs_send_pagedata(struct socket *sock, struct xdr_buf *xdr, unsigned i
 		remainder -= len;
 		if (remainder != 0 || more)
 			flags |= MSG_MORE;
-		err = sock->ops->sendpage(sock, *ppage, base, len, flags);
+		err = do_sendpage(sock, *ppage, base, len, flags);
 		if (remainder == 0 || err != len)
 			break;
 		sent += err;
@@ -428,9 +433,10 @@ static int xs_send_pagedata(struct socket *sock, struct xdr_buf *xdr, unsigned i
  * @addrlen: UDP only -- length of destination address
  * @xdr: buffer containing this request
  * @base: starting position in the buffer
+ * @zerocopy: true if it is safe to use sendpage()
  *
  */
-static int xs_sendpages(struct socket *sock, struct sockaddr *addr, int addrlen, struct xdr_buf *xdr, unsigned int base)
+static int xs_sendpages(struct socket *sock, struct sockaddr *addr, int addrlen, struct xdr_buf *xdr, unsigned int base, bool zerocopy)
 {
 	unsigned int remainder = xdr->len - base;
 	int err, sent = 0;
@@ -458,7 +464,7 @@ static int xs_sendpages(struct socket *sock, struct sockaddr *addr, int addrlen,
 	if (base < xdr->page_len) {
 		unsigned int len = xdr->page_len - base;
 		remainder -= len;
-		err = xs_send_pagedata(sock, xdr, base, remainder != 0);
+		err = xs_send_pagedata(sock, xdr, base, remainder != 0, zerocopy);
 		if (remainder == 0 || err != len)
 			goto out;
 		sent += err;
@@ -561,7 +567,7 @@ static int xs_local_send_request(struct rpc_task *task)
 			req->rq_svec->iov_base, req->rq_svec->iov_len);
 
 	status = xs_sendpages(transport->sock, NULL, 0,
-						xdr, req->rq_bytes_sent);
+						xdr, req->rq_bytes_sent, true);
 	dprintk("RPC:       %s(%u) = %d\n",
 			__func__, xdr->len - req->rq_bytes_sent, status);
 	if (likely(status >= 0)) {
@@ -617,7 +623,7 @@ static int xs_udp_send_request(struct rpc_task *task)
 	status = xs_sendpages(transport->sock,
 			      xs_addr(xprt),
 			      xprt->addrlen, xdr,
-			      req->rq_bytes_sent);
+			      req->rq_bytes_sent, true);
 
 	dprintk("RPC:       xs_udp_send_request(%u) = %d\n",
 			xdr->len - req->rq_bytes_sent, status);
@@ -688,6 +694,7 @@ static int xs_tcp_send_request(struct rpc_task *task)
 	struct rpc_xprt *xprt = req->rq_xprt;
 	struct sock_xprt *transport = container_of(xprt, struct sock_xprt, xprt);
 	struct xdr_buf *xdr = &req->rq_snd_buf;
+	bool zerocopy = true;
 	int status;
 
 	xs_encode_stream_record_marker(&req->rq_snd_buf);
@@ -695,13 +702,20 @@ static int xs_tcp_send_request(struct rpc_task *task)
 	xs_pktdump("packet data:",
 				req->rq_svec->iov_base,
 				req->rq_svec->iov_len);
+	/* Don't use zero copy if this is a resend. If the RPC call
+	 * completes while the socket holds a reference to the pages,
+	 * then we may end up resending corrupted data.
+	 */
+	if (task->tk_flags & RPC_TASK_SENT)
+		zerocopy = false;
 
 	/* Continue transmitting the packet/record. We must be careful
 	 * to cope with writespace callbacks arriving _after_ we have
 	 * called sendmsg(). */
 	while (1) {
 		status = xs_sendpages(transport->sock,
-					NULL, 0, xdr, req->rq_bytes_sent);
+					NULL, 0, xdr, req->rq_bytes_sent,
+					zerocopy);
 
 		dprintk("RPC:       xs_tcp_send_request(%u) = %d\n",
 				xdr->len - req->rq_bytes_sent, status);
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index d8edff2..d6aab27 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -62,7 +62,6 @@ static struct ima_measure_rule_entry default_rules[] = {
 	{.action = DONT_MEASURE,.fsmagic = SYSFS_MAGIC,.flags = IMA_FSMAGIC},
 	{.action = DONT_MEASURE,.fsmagic = DEBUGFS_MAGIC,.flags = IMA_FSMAGIC},
 	{.action = DONT_MEASURE,.fsmagic = TMPFS_MAGIC,.flags = IMA_FSMAGIC},
-	{.action = DONT_MEASURE,.fsmagic = RAMFS_MAGIC,.flags = IMA_FSMAGIC},
 	{.action = DONT_MEASURE,.fsmagic = SECURITYFS_MAGIC,.flags = IMA_FSMAGIC},
 	{.action = DONT_MEASURE,.fsmagic = SELINUX_MAGIC,.flags = IMA_FSMAGIC},
 	{.action = MEASURE,.func = FILE_MMAP,.mask = MAY_EXEC,
diff --git a/security/selinux/netlabel.c b/security/selinux/netlabel.c
index da4b8b2..6235d05 100644
--- a/security/selinux/netlabel.c
+++ b/security/selinux/netlabel.c
@@ -442,8 +442,7 @@ int selinux_netlbl_socket_connect(struct sock *sk, struct sockaddr *addr)
 	    sksec->nlbl_state != NLBL_CONNLABELED)
 		return 0;
 
-	local_bh_disable();
-	bh_lock_sock_nested(sk);
+	lock_sock(sk);
 
 	/* connected sockets are allowed to disconnect when the address family
 	 * is set to AF_UNSPEC, if that is what is happening we want to reset
@@ -464,7 +463,6 @@ int selinux_netlbl_socket_connect(struct sock *sk, struct sockaddr *addr)
 		sksec->nlbl_state = NLBL_CONNLABELED;
 
 socket_connect_return:
-	bh_unlock_sock(sk);
-	local_bh_enable();
+	release_sock(sk);
 	return rc;
 }
diff --git a/sound/drivers/pcsp/pcsp.c b/sound/drivers/pcsp/pcsp.c
index 99704e6..7ab6741 100644
--- a/sound/drivers/pcsp/pcsp.c
+++ b/sound/drivers/pcsp/pcsp.c
@@ -187,8 +187,8 @@ static int __devinit pcsp_probe(struct platform_device *dev)
 static int __devexit pcsp_remove(struct platform_device *dev)
 {
 	struct snd_pcsp *chip = platform_get_drvdata(dev);
-	alsa_card_pcsp_exit(chip);
 	pcspkr_input_remove(chip->input_dev);
+	alsa_card_pcsp_exit(chip);
 	platform_set_drvdata(dev, NULL);
 	return 0;
 }
diff --git a/sound/isa/msnd/msnd_pinnacle.c b/sound/isa/msnd/msnd_pinnacle.c
index 29cc8e1..a7d6a52 100644
--- a/sound/isa/msnd/msnd_pinnacle.c
+++ b/sound/isa/msnd/msnd_pinnacle.c
@@ -73,9 +73,11 @@
 #ifdef MSND_CLASSIC
 #  include "msnd_classic.h"
 #  define LOGNAME			"msnd_classic"
+#  define DEV_NAME			"msnd-classic"
 #else
 #  include "msnd_pinnacle.h"
 #  define LOGNAME			"snd_msnd_pinnacle"
+#  define DEV_NAME			"msnd-pinnacle"
 #endif
 
 static void __devinit set_default_audio_parameters(struct snd_msnd *chip)
@@ -1068,8 +1070,6 @@ static int __devexit snd_msnd_isa_remove(struct device *pdev, unsigned int dev)
 	return 0;
 }
 
-#define DEV_NAME "msnd-pinnacle"
-
 static struct isa_driver snd_msnd_driver = {
 	.match		= snd_msnd_isa_match,
 	.probe		= snd_msnd_isa_probe,
diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index f33bb78..0948888 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -2312,9 +2312,6 @@ int snd_hda_codec_reset(struct hda_codec *codec)
 
 #ifdef CONFIG_SND_HDA_POWER_SAVE
 	cancel_delayed_work_sync(&codec->power_work);
-	codec->power_on = 0;
-	codec->power_transition = 0;
-	codec->power_jiffies = jiffies;
 	flush_workqueue(bus->workq);
 #endif
 	snd_hda_ctls_clear(codec);
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 72694bd..45f1b1c 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6887,6 +6887,7 @@ static int patch_alc662(struct hda_codec *codec)
 		case 0x10ec0272:
 		case 0x10ec0663:
 		case 0x10ec0665:
+		case 0x10ec0668:
 			set_beep_amp(spec, 0x0b, 0x04, HDA_INPUT);
 			break;
 		case 0x10ec0273:
@@ -6944,6 +6945,7 @@ static int patch_alc680(struct hda_codec *codec)
  */
 static const struct hda_codec_preset snd_hda_preset_realtek[] = {
 	{ .id = 0x10ec0221, .name = "ALC221", .patch = patch_alc269 },
+	{ .id = 0x10ec0231, .name = "ALC231", .patch = patch_alc269 },
 	{ .id = 0x10ec0260, .name = "ALC260", .patch = patch_alc260 },
 	{ .id = 0x10ec0262, .name = "ALC262", .patch = patch_alc262 },
 	{ .id = 0x10ec0267, .name = "ALC267", .patch = patch_alc268 },
diff --git a/sound/soc/blackfin/bf5xx-i2s.c b/sound/soc/blackfin/bf5xx-i2s.c
index 4dccf03..f59a961 100644
--- a/sound/soc/blackfin/bf5xx-i2s.c
+++ b/sound/soc/blackfin/bf5xx-i2s.c
@@ -111,6 +111,7 @@ static int bf5xx_i2s_hw_params(struct snd_pcm_substream *substream,
 		bf5xx_i2s->tcr2 |= 7;
 		bf5xx_i2s->rcr2 |= 7;
 		sport_handle->wdsize = 1;
+		break;
 	case SNDRV_PCM_FORMAT_S16_LE:
 		bf5xx_i2s->tcr2 |= 15;
 		bf5xx_i2s->rcr2 |= 15;
diff --git a/sound/soc/codecs/cs42l52.h b/sound/soc/codecs/cs42l52.h
index 60985c0..647a693 100644
--- a/sound/soc/codecs/cs42l52.h
+++ b/sound/soc/codecs/cs42l52.h
@@ -179,7 +179,7 @@
 #define CS42L52_MICB_CTL			0x11
 #define	CS42L52_MIC_CTL_MIC_SEL_MASK		0xBF
 #define	CS42L52_MIC_CTL_MIC_SEL_SHIFT		6
-#define CS42L52_MIC_CTL_TYPE_MASK		0xDF
+#define CS42L52_MIC_CTL_TYPE_MASK		0x20
 #define CS42L52_MIC_CTL_TYPE_SHIFT		5
 
 
diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index bff98fb..c4afa36 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -3687,6 +3687,8 @@ static __devinit int wm8962_i2c_probe(struct i2c_client *i2c,
 	if (ret < 0)
 		goto err_regmap;
 
+	regcache_cache_only(wm8962->regmap, true);
+
 	/* The drivers should power up as needed */
 	regulator_bulk_disable(ARRAY_SIZE(wm8962->supplies), wm8962->supplies);
 
diff --git a/sound/soc/fsl/imx-pcm-fiq.c b/sound/soc/fsl/imx-pcm-fiq.c
index 456b7d7..b18279d 100644
--- a/sound/soc/fsl/imx-pcm-fiq.c
+++ b/sound/soc/fsl/imx-pcm-fiq.c
@@ -42,7 +42,8 @@ struct imx_pcm_runtime_data {
 	struct hrtimer hrt;
 	int poll_time_ns;
 	struct snd_pcm_substream *substream;
-	atomic_t running;
+	atomic_t playing;
+	atomic_t capturing;
 };
 
 static enum hrtimer_restart snd_hrtimer_callback(struct hrtimer *hrt)
@@ -54,7 +55,7 @@ static enum hrtimer_restart snd_hrtimer_callback(struct hrtimer *hrt)
 	struct pt_regs regs;
 	unsigned long delta;
 
-	if (!atomic_read(&iprtd->running))
+	if (!atomic_read(&iprtd->playing) && !atomic_read(&iprtd->capturing))
 		return HRTIMER_NORESTART;
 
 	get_fiq_regs(&regs);
@@ -122,7 +123,6 @@ static int snd_imx_pcm_prepare(struct snd_pcm_substream *substream)
 	return 0;
 }
 
-static int fiq_enable;
 static int imx_pcm_fiq;
 
 static int snd_imx_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
@@ -134,23 +134,27 @@ static int snd_imx_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
 	case SNDRV_PCM_TRIGGER_START:
 	case SNDRV_PCM_TRIGGER_RESUME:
 	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
-		atomic_set(&iprtd->running, 1);
+		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+			atomic_set(&iprtd->playing, 1);
+		else
+			atomic_set(&iprtd->capturing, 1);
 		hrtimer_start(&iprtd->hrt, ns_to_ktime(iprtd->poll_time_ns),
 		      HRTIMER_MODE_REL);
-		if (++fiq_enable == 1)
-			enable_fiq(imx_pcm_fiq);
-
+		enable_fiq(imx_pcm_fiq);
 		break;
 
 	case SNDRV_PCM_TRIGGER_STOP:
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
-		atomic_set(&iprtd->running, 0);
-
-		if (--fiq_enable == 0)
+		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+			atomic_set(&iprtd->playing, 0);
+		else
+			atomic_set(&iprtd->capturing, 0);
+		if (!atomic_read(&iprtd->playing) &&
+				!atomic_read(&iprtd->capturing))
 			disable_fiq(imx_pcm_fiq);
-
 		break;
+
 	default:
 		return -EINVAL;
 	}
@@ -198,7 +202,8 @@ static int snd_imx_open(struct snd_pcm_substream *substream)
 
 	iprtd->substream = substream;
 
-	atomic_set(&iprtd->running, 0);
+	atomic_set(&iprtd->playing, 0);
+	atomic_set(&iprtd->capturing, 0);
 	hrtimer_init(&iprtd->hrt, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	iprtd->hrt.function = snd_hrtimer_callback;
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e32731c..1b29357 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -770,7 +770,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		/* destroy any largepage mappings for dirty tracking */
 	}
 
-	if (!npages) {
+	if (!npages || base_gfn != old.base_gfn) {
 		struct kvm_memory_slot *slot;
 
 		r = -ENOMEM;
@@ -786,8 +786,10 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		old_memslots = kvm->memslots;
 		rcu_assign_pointer(kvm->memslots, slots);
 		synchronize_srcu_expedited(&kvm->srcu);
-		/* From this point no new shadow pages pointing to a deleted
-		 * memslot will be created.
+		/* slot was deleted or moved, clear iommu mapping */
+		kvm_iommu_unmap_pages(kvm, &old);
+		/* From this point no new shadow pages pointing to a deleted,
+		 * or moved, memslot will be created.
 		 *
 		 * validation of sp->gfn happens in:
 		 * 	- gfn_to_hva (kvm_read_guest, gfn_to_pfn)
@@ -801,20 +803,19 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (r)
 		goto out_free;
 
-	/* map/unmap the pages in iommu page table */
-	if (npages) {
-		r = kvm_iommu_map_pages(kvm, &new);
-		if (r)
-			goto out_free;
-	} else
-		kvm_iommu_unmap_pages(kvm, &old);
-
 	r = -ENOMEM;
 	slots = kmemdup(kvm->memslots, sizeof(struct kvm_memslots),
 			GFP_KERNEL);
 	if (!slots)
 		goto out_free;
 
+	/* map new memory slot into the iommu */
+	if (npages) {
+		r = kvm_iommu_map_pages(kvm, &new);
+		if (r)
+			goto out_slots;
+	}
+
 	/* actual memory is freed via old in kvm_free_physmem_slot below */
 	if (!npages) {
 		new.rmap = NULL;
@@ -841,6 +842,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 
 	return 0;
 
+out_slots:
+	kfree(slots);
 out_free:
 	kvm_free_physmem_slot(&new, &old);
 out:
