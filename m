Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab3LTP0l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 10:26:41 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:53843 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab3LTP0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 10:26:39 -0500
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
To: fengguang.wu@intel.com
Cc: jim.epost@gmail.com, sfr@canb.auug.org.au, gregkh@linuxfoundation.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        kbuild-all@01.org, haver@linux.vnet.ibm.com
Subject: [PATCH 1/2] GenWQE: Fix endian issues detected by sparse
Date: Fri, 20 Dec 2013 16:26:10 +0100
Message-Id: <1387553171-31469-1-git-send-email-haver@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <CA+r1Zhimt7Xusnc4kkkVqfoRhfZRnreMmZqaN7WP7rSpZ3XTvw@mail.gmail.com>
References: <CA+r1Zhimt7Xusnc4kkkVqfoRhfZRnreMmZqaN7WP7rSpZ3XTvw@mail.gmail.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13122015-4966-0000-0000-000007E506B6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang Wu used CF=-D__CHECK_ENDIAN__ to check the GenWQE driver for
endian issues. Sparse found a couple of those. Most of them were caused
by not correctly handling __be64/32 and __u64/32. Those I was able to
fix with appropriate castings.

One more serious issue was the ATS entry in struct genwqe_ddcb_cmd.
The kernel expected it in big-endian, but the type was defined __u64.
I decided that it is better to keep the interface consistent using
host endian byte-odering instead of having a mixture. With this change
the kernel likes to see host endian byte order for the ATS entry. That
would have been an interface change, if someone would have used the
driver already. Since this is not the case, I hope it is ok to fix it
now.

For the genqwe_readq/writeq/readl/writel functions I enforced the casts.

It still complains, as far as I can see, about some copy_to/from_user()
usages:

  CHECK   char-misc/drivers/misc/genwqe/card_dev.c
char-misc/arch/x86/include/asm/uaccess.h:625:18: warning: incorrect type in argument 1 (different modifiers)
char-misc/arch/x86/include/asm/uaccess.h:625:18:    expected void *<noident>
char-misc/arch/x86/include/asm/uaccess.h:625:18:    got void const *from
char-misc/arch/x86/include/asm/uaccess.h:625:18: warning: incorrect type in argument 1 (different modifiers)
char-misc/arch/x86/include/asm/uaccess.h:625:18:    expected void *<noident>
char-misc/arch/x86/include/asm/uaccess.h:625:18:    got void const *from
char-misc/arch/x86/include/asm/uaccess.h:625:18: warning: incorrect type in argument 1 (different modifiers)
char-misc/arch/x86/include/asm/uaccess.h:625:18:    expected void *<noident>
char-misc/arch/x86/include/asm/uaccess.h:625:18:    got void const *from
char-misc/arch/x86/include/asm/uaccess.h:625:18: warning: incorrect type in argument 1 (different modifiers)
char-misc/arch/x86/include/asm/uaccess.h:625:18:    expected void *<noident>
char-misc/arch/x86/include/asm/uaccess.h:625:18:    got void const *from
  CC [M]  drivers/misc/genwqe/card_dev.o
  CHECK   char-misc/drivers/misc/genwqe/card_ddcb.c
char-misc/arch/x86/include/asm/uaccess.h:625:18: warning: incorrect type in argument 1 (different modifiers)
char-misc/arch/x86/include/asm/uaccess.h:625:18:    expected void *<noident>
char-misc/arch/x86/include/asm/uaccess.h:625:18:    got void const *from
char-misc/arch/x86/include/asm/uaccess.h:625:18: warning: incorrect type in argument 1 (different modifiers)
char-misc/arch/x86/include/asm/uaccess.h:625:18:    expected void *<noident>
char-misc/arch/x86/include/asm/uaccess.h:625:18:    got void const *from
  CC [M]  drivers/misc/genwqe/card_ddcb.o
  LD [M]  drivers/misc/genwqe/genwqe_card.o

I appreciate some help from you to figure out what is causig those, and
making a proposal how to fix them.

I included the missing header file to fix the
implicit-function-declaration warning when using dynamic_hex_dump.

Signed-off-by: Frank Haverkamp <haver@linux.vnet.ibm.com>
---
 drivers/misc/genwqe/card_ddcb.c     |   16 +++--
 drivers/misc/genwqe/card_dev.c      |   97 +++++++++++++++++++-----------------
 drivers/misc/genwqe/card_utils.c    |   11 +---
 drivers/misc/genwqe/genwqe_driver.h |    3 -
 4 files changed, 68 insertions(+), 59 deletions(-)

--- a/drivers/misc/genwqe/card_ddcb.c
+++ b/drivers/misc/genwqe/card_ddcb.c
@@ -276,7 +276,7 @@ static int enqueue_ddcb(struct genwqe_de
 	unsigned int try;
 	int prev_no;
 	struct ddcb *prev_ddcb;
-	u32 old, new, icrc_hsi_shi;
+	__be32 old, new, icrc_hsi_shi;
 	u64 num;
 
 	/*
@@ -623,9 +623,9 @@ int __genwqe_purge_ddcb(struct genwqe_de
 	unsigned long flags;
 	struct ddcb_queue *queue = req->queue;
 	struct pci_dev *pci_dev = cd->pci_dev;
-	u32 icrc_hsi_shi = 0x0000;
 	u64 queue_status;
-	u32 old, new;
+	__be32 icrc_hsi_shi = 0x0000;
+	__be32 old, new;
 
 	/* unsigned long flags; */
 	if (genwqe_ddcb_software_timeout <= 0) {
@@ -839,8 +839,8 @@ int __genwqe_enqueue_ddcb(struct genwqe_
 		       &req->cmd.__asiv[0],	/* source */
 		       DDCB_ASIV_LENGTH);	/* req->cmd.asiv_length */
 	} else {
-		pddcb->n.ats_64 = req->cmd.ats;
-		memcpy(&pddcb->n.asiv[0],		/* destination */
+		pddcb->n.ats_64 = cpu_to_be64(req->cmd.ats);
+		memcpy(&pddcb->n.asiv[0],	/* destination */
 			&req->cmd.asiv[0],	/* source */
 			DDCB_ASIV_LENGTH_ATS);	/* req->cmd.asiv_length */
 	}
@@ -915,7 +915,8 @@ int __genwqe_execute_raw_ddcb(struct gen
 		goto err_exit;
 
 	if (ddcb_requ_collect_debug_data(req)) {
-		if (copy_to_user((void __user *)cmd->ddata_addr,
+		if (copy_to_user((struct genwqe_debug_data __user *)
+				 (unsigned long)cmd->ddata_addr,
 				 &req->debug_data,
 				 sizeof(struct genwqe_debug_data)))
 			return -EFAULT;
@@ -938,7 +939,8 @@ int __genwqe_execute_raw_ddcb(struct gen
 	__genwqe_purge_ddcb(cd, req);
 
 	if (ddcb_requ_collect_debug_data(req)) {
-		if (copy_to_user((void __user *)cmd->ddata_addr,
+		if (copy_to_user((struct genwqe_debug_data __user *)
+				 (unsigned long)cmd->ddata_addr,
 				 &req->debug_data,
 				 sizeof(struct genwqe_debug_data)))
 			return -EFAULT;
--- a/drivers/misc/genwqe/card_dev.c
+++ b/drivers/misc/genwqe/card_dev.c
@@ -587,30 +587,31 @@ static int do_flash_update(struct genwqe
 
 		/* prepare invariant values */
 		if (genwqe_get_slu_id(cd) <= 0x2) {
-			*(u64 *)&req->__asiv[0]  = cpu_to_be64(dma_addr);
-			*(u64 *)&req->__asiv[8]  = cpu_to_be64(tocopy);
-			*(u64 *)&req->__asiv[16] = cpu_to_be64(flash);
-			*(u32 *)&req->__asiv[24] = cpu_to_be32(0);
+			*(__be64 *)&req->__asiv[0]  = cpu_to_be64(dma_addr);
+			*(__be64 *)&req->__asiv[8]  = cpu_to_be64(tocopy);
+			*(__be64 *)&req->__asiv[16] = cpu_to_be64(flash);
+			*(__be32 *)&req->__asiv[24] = cpu_to_be32(0);
 			req->__asiv[24]	       = load->uid;
-			*(u32 *)&req->__asiv[28] = cpu_to_be32(crc);
+			*(__be32 *)&req->__asiv[28] = cpu_to_be32(crc);
 
 			/* for simulation only */
-			*(u64 *)&req->__asiv[88] = cpu_to_be64(load->slu_id);
-			*(u64 *)&req->__asiv[96] = cpu_to_be64(load->app_id);
+			*(__be64 *)&req->__asiv[88] = cpu_to_be64(load->slu_id);
+			*(__be64 *)&req->__asiv[96] = cpu_to_be64(load->app_id);
 			req->asiv_length = 32; /* bytes included in crc calc */
 		} else {	/* setup DDCB for ATS architecture */
-			*(u64 *)&req->asiv[0]  = cpu_to_be64(dma_addr);
-			*(u32 *)&req->asiv[8]  = cpu_to_be32(tocopy);
-			*(u32 *)&req->asiv[12] = cpu_to_be32(0); /* resvd */
-			*(u64 *)&req->asiv[16] = cpu_to_be64(flash);
-			*(u32 *)&req->asiv[24] = cpu_to_be32(load->uid<<24);
-			*(u32 *)&req->asiv[28] = cpu_to_be32(crc);
+			*(__be64 *)&req->asiv[0]  = cpu_to_be64(dma_addr);
+			*(__be32 *)&req->asiv[8]  = cpu_to_be32(tocopy);
+			*(__be32 *)&req->asiv[12] = cpu_to_be32(0); /* resvd */
+			*(__be64 *)&req->asiv[16] = cpu_to_be64(flash);
+			*(__be32 *)&req->asiv[24] = cpu_to_be32(load->uid<<24);
+			*(__be32 *)&req->asiv[28] = cpu_to_be32(crc);
 
 			/* for simulation only */
-			*(u64 *)&req->asiv[80] = cpu_to_be64(load->slu_id);
-			*(u64 *)&req->asiv[88] = cpu_to_be64(load->app_id);
+			*(__be64 *)&req->asiv[80] = cpu_to_be64(load->slu_id);
+			*(__be64 *)&req->asiv[88] = cpu_to_be64(load->app_id);
 
-			req->ats = cpu_to_be64(0x4ULL << 44);	/* Rd only */
+			/* Rd only */
+			req->ats = 0x4ULL << 44;
 			req->asiv_length = 40; /* bytes included in crc calc */
 		}
 		req->asv_length  = 8;
@@ -729,21 +730,23 @@ static int do_flash_read(struct genwqe_f
 
 		/* prepare invariant values */
 		if (genwqe_get_slu_id(cd) <= 0x2) {
-			*(u64 *)&cmd->__asiv[0]  = cpu_to_be64(dma_addr);
-			*(u64 *)&cmd->__asiv[8]  = cpu_to_be64(tocopy);
-			*(u64 *)&cmd->__asiv[16] = cpu_to_be64(flash);
-			*(u32 *)&cmd->__asiv[24] = cpu_to_be32(0);
+			*(__be64 *)&cmd->__asiv[0]  = cpu_to_be64(dma_addr);
+			*(__be64 *)&cmd->__asiv[8]  = cpu_to_be64(tocopy);
+			*(__be64 *)&cmd->__asiv[16] = cpu_to_be64(flash);
+			*(__be32 *)&cmd->__asiv[24] = cpu_to_be32(0);
 			cmd->__asiv[24] = load->uid;
-			*(u32 *)&cmd->__asiv[28] = cpu_to_be32(0)  /* CRC */;
+			*(__be32 *)&cmd->__asiv[28] = cpu_to_be32(0)  /* CRC */;
 			cmd->asiv_length = 32; /* bytes included in crc calc */
 		} else {	/* setup DDCB for ATS architecture */
-			*(u64 *)&cmd->asiv[0]  = cpu_to_be64(dma_addr);
-			*(u32 *)&cmd->asiv[8]  = cpu_to_be32(tocopy);
-			*(u32 *)&cmd->asiv[12] = cpu_to_be32(0); /* resvd */
-			*(u64 *)&cmd->asiv[16] = cpu_to_be64(flash);
-			*(u32 *)&cmd->asiv[24] = cpu_to_be32(load->uid<<24);
-			*(u32 *)&cmd->asiv[28] = cpu_to_be32(0); /* CRC */
-			cmd->ats = cpu_to_be64(0x5ULL << 44);	/* rd/wr */
+			*(__be64 *)&cmd->asiv[0]  = cpu_to_be64(dma_addr);
+			*(__be32 *)&cmd->asiv[8]  = cpu_to_be32(tocopy);
+			*(__be32 *)&cmd->asiv[12] = cpu_to_be32(0); /* resvd */
+			*(__be64 *)&cmd->asiv[16] = cpu_to_be64(flash);
+			*(__be32 *)&cmd->asiv[24] = cpu_to_be32(load->uid<<24);
+			*(__be32 *)&cmd->asiv[28] = cpu_to_be32(0); /* CRC */
+
+			/* rd/wr */
+			cmd->ats = 0x5ULL << 44;
 			cmd->asiv_length = 40; /* bytes included in crc calc */
 		}
 		cmd->asv_length  = 8;
@@ -911,9 +914,9 @@ static int ddcb_cmd_fixups(struct genwqe
 
 		u64 u_addr, d_addr;
 		u32 u_size = 0;
-		unsigned long ats_flags;
+		u64 ats_flags;
 
-		ats_flags = ATS_GET_FLAGS(be64_to_cpu(cmd->ats), asiv_offs);
+		ats_flags = ATS_GET_FLAGS(cmd->ats, asiv_offs);
 
 		switch (ats_flags) {
 
@@ -922,9 +925,9 @@ static int ddcb_cmd_fixups(struct genwqe
 
 		case ATS_TYPE_FLAT_RDWR:
 		case ATS_TYPE_FLAT_RD: {
-			u_addr = be64_to_cpu(*((u64 *)&cmd->
+			u_addr = be64_to_cpu(*((__be64 *)&cmd->
 					       asiv[asiv_offs]));
-			u_size = be32_to_cpu(*((u32 *)&cmd->
+			u_size = be32_to_cpu(*((__be32 *)&cmd->
 					       asiv[asiv_offs + 0x08]));
 
 			/*
@@ -933,7 +936,7 @@ static int ddcb_cmd_fixups(struct genwqe
 			 * fetch the buffer.
 			 */
 			if (u_size == 0x0) {
-				*((u64 *)&cmd->asiv[asiv_offs]) =
+				*((__be64 *)&cmd->asiv[asiv_offs]) =
 					cpu_to_be64(0x0);
 				break;
 			}
@@ -945,7 +948,8 @@ static int ddcb_cmd_fixups(struct genwqe
 				goto err_out;
 			}
 
-			*((u64 *)&cmd->asiv[asiv_offs]) = cpu_to_be64(d_addr);
+			*((__be64 *)&cmd->asiv[asiv_offs]) =
+				cpu_to_be64(d_addr);
 			break;
 		}
 
@@ -953,9 +957,10 @@ static int ddcb_cmd_fixups(struct genwqe
 		case ATS_TYPE_SGL_RD: {
 			int page_offs, nr_pages, offs;
 
-			u_addr = be64_to_cpu(*((u64 *)&cmd->asiv[asiv_offs]));
-			u_size = be32_to_cpu(*((u32 *)&cmd->asiv[asiv_offs +
-								 0x08]));
+			u_addr = be64_to_cpu(*((__be64 *)
+					       &cmd->asiv[asiv_offs]));
+			u_size = be32_to_cpu(*((__be32 *)
+					       &cmd->asiv[asiv_offs + 0x08]));
 
 			/*
 			 * No data available. Ignore u_addr in this
@@ -963,7 +968,7 @@ static int ddcb_cmd_fixups(struct genwqe
 			 * fetch the empty sgl.
 			 */
 			if (u_size == 0x0) {
-				*((u64 *)&cmd->asiv[asiv_offs]) =
+				*((__be64 *)&cmd->asiv[asiv_offs]) =
 					cpu_to_be64(0x0);
 				break;
 			}
@@ -1007,14 +1012,14 @@ static int ddcb_cmd_fixups(struct genwqe
 					page_offs,
 					nr_pages);
 
-			*((u64 *)&cmd->asiv[asiv_offs]) =
+			*((__be64 *)&cmd->asiv[asiv_offs]) =
 				cpu_to_be64(req->sgl_dma_addr[i]);
 
 			break;
 		}
 		default:
 			dev_err(&pci_dev->dev,
-				"[%s] err: invalid ATS flags %01lx\n",
+				"[%s] err: invalid ATS flags %01llx\n",
 				__func__, ats_flags);
 			rc = -EINVAL;
 			goto err_out;
@@ -1211,7 +1216,8 @@ static long genwqe_ioctl(struct file *fi
 		if ((filp->f_flags & O_ACCMODE) == O_RDONLY)
 			return -EPERM;
 
-		if (copy_from_user(&load, (void __user *)arg, sizeof(load))) {
+		if (copy_from_user(&load, (void __user *)arg,
+				   sizeof(load))) {
 			dev_err(&pci_dev->dev,
 				"err: could not copy params from user\n");
 			return -EFAULT;
@@ -1236,7 +1242,8 @@ static long genwqe_ioctl(struct file *fi
 		if (genwqe_flash_readback_fails(cd))
 			return -ENOSPC;	 /* known to fail for old versions */
 
-		if (copy_from_user(&load, (void __user *)arg, sizeof(load))) {
+		if (copy_from_user(&load, (void __user *)arg,
+				   sizeof(load))) {
 			dev_err(&pci_dev->dev,
 				"err: could not copy params from user\n");
 			return -EFAULT;
@@ -1256,7 +1263,8 @@ static long genwqe_ioctl(struct file *fi
 	case GENWQE_PIN_MEM: {
 		struct genwqe_mem m;
 
-		if (copy_from_user(&m, (void __user *)arg, sizeof(m))) {
+		if (copy_from_user(&m, (void __user *)arg,
+				   sizeof(m))) {
 			dev_err(&pci_dev->dev,
 				"err: could not copy params from user\n");
 			return -EFAULT;
@@ -1267,7 +1275,8 @@ static long genwqe_ioctl(struct file *fi
 	case GENWQE_UNPIN_MEM: {
 		struct genwqe_mem m;
 
-		if (copy_from_user(&m, (void __user *)arg, sizeof(m))) {
+		if (copy_from_user(&m, (void __user *)arg,
+				   sizeof(m))) {
 			dev_err(&pci_dev->dev,
 				"err: could not copy params from user\n");
 			return -EFAULT;
--- a/drivers/misc/genwqe/card_utils.c
+++ b/drivers/misc/genwqe/card_utils.c
@@ -59,7 +59,7 @@ int __genwqe_writeq(struct genwqe_dev *c
 	if (cd->mmio == NULL)
 		return -EIO;
 
-	__raw_writeq(cpu_to_be64((val)), (cd->mmio + byte_offs));
+	__raw_writeq((__force u32)cpu_to_be64(val), cd->mmio + byte_offs);
 	return 0;
 }
 
@@ -72,8 +72,6 @@ int __genwqe_writeq(struct genwqe_dev *c
  */
 u64 __genwqe_readq(struct genwqe_dev *cd, u64 byte_offs)
 {
-	u64 val;
-
 	if (cd->err_inject & GENWQE_INJECT_HARDWARE_FAILURE)
 		return 0xffffffffffffffffull;
 
@@ -88,8 +86,7 @@ u64 __genwqe_readq(struct genwqe_dev *cd
 	if (cd->mmio == NULL)
 		return 0xffffffffffffffffull;
 
-	val = be64_to_cpu(__raw_readq(cd->mmio + byte_offs));
-	return val;
+	return be64_to_cpu((__force __be64)__raw_readq(cd->mmio + byte_offs));
 }
 
 /**
@@ -108,7 +105,7 @@ int __genwqe_writel(struct genwqe_dev *c
 	if (cd->mmio == NULL)
 		return -EIO;
 
-	__raw_writel(cpu_to_be32((val)), cd->mmio + byte_offs);
+	__raw_writel((__force u32)cpu_to_be32(val), cd->mmio + byte_offs);
 	return 0;
 }
 
@@ -127,7 +124,7 @@ u32 __genwqe_readl(struct genwqe_dev *cd
 	if (cd->mmio == NULL)
 		return 0xffffffff;
 
-	return be32_to_cpu(__raw_readl(cd->mmio + byte_offs));
+	return be32_to_cpu((__force __be32)__raw_readl(cd->mmio + byte_offs));
 }
 
 /**
--- a/drivers/misc/genwqe/genwqe_driver.h
+++ b/drivers/misc/genwqe/genwqe_driver.h
@@ -31,8 +31,9 @@
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
 #include <linux/platform_device.h>
-#include <asm/byteorder.h>
+#include <linux/dynamic_debug.h>
 
+#include <asm/byteorder.h>
 #include <linux/genwqe/genwqe_card.h>
 
 #define DRV_VERS_STRING		"2.0.0"

