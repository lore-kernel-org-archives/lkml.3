Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990AbaAGOlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:41:55 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:32800 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaAGOlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:41:39 -0500
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        dan.carpenter@oracle.com, fengguang.wu@intel.com, weiyj.lk@gmail.com,
        jim.epost@gmail.com, sfr@canb.auug.org.au, jsvogt@de.ibm.com,
        MIJUNG@de.ibm.com, michael@ibmra.de, schwidefsky@de.ibm.com,
        cody@linux.vnet.ibm.com, cascardo@linux.vnet.ibm.com,
        kernel-janitors@vger.kernel.org, haver@linux.vnet.ibm.com
Subject: [PATCH 1/3] GenWQE: Rework return code for flash-update ioctl
Date: Tue,  7 Jan 2014 15:41:23 +0100
Message-Id: <1389105685-25245-1-git-send-email-haver@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1389105556.15325.22.camel@oc7383187364.ibm.com>
References: <1389105556.15325.22.camel@oc7383187364.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010714-2966-0000-0000-000009DE510E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of remaining bytes of a failing copy_to_user, the flash-update
ioctl is returning now -EFAULT. In addtion Dan discovered user triggerable
dev_errs(). Those I removed now from card_dev.c too. Some dev_infos()
were deleted and some others turned into dev_dbgs().

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Frank Haverkamp <haver@linux.vnet.ibm.com>
---
 drivers/misc/genwqe/card_dev.c |  172 ++++++++++-------------------------------
 1 file changed, 43 insertions(+), 129 deletions(-)

--- a/drivers/misc/genwqe/card_dev.c
+++ b/drivers/misc/genwqe/card_dev.c
@@ -516,17 +516,11 @@ static int do_flash_update(struct genwqe
 	struct genwqe_dev *cd = cfile->cd;
 	struct pci_dev *pci_dev = cd->pci_dev;
 
-	if ((load->size & 0x3) != 0) {
-		dev_err(&pci_dev->dev,
-			"err: buf %d bytes not 4 bytes aligned!\n",
-			load->size);
+	if ((load->size & 0x3) != 0)
 		return -EINVAL;
-	}
-	if (((unsigned long)(load->data_addr) & ~PAGE_MASK) != 0) {
-		dev_err(&pci_dev->dev,
-			"err: buf is not page aligned!\n");
+
+	if (((unsigned long)(load->data_addr) & ~PAGE_MASK) != 0)
 		return -EINVAL;
-	}
 
 	/* FIXME Bits have changed for new service layer! */
 	switch ((char)load->partition) {
@@ -538,20 +532,13 @@ static int do_flash_update(struct genwqe
 		break;		/* download/erase_first/part_1 */
 	case 'v':		/* cmdopts = 0x0c (VPD) */
 	default:
-		dev_err(&pci_dev->dev,
-			"err: invalid partition %02x!\n", load->partition);
 		return -EINVAL;
 	}
-	dev_info(&pci_dev->dev,
-		 "[%s] start flash update UID: 0x%x size: %u bytes part: %c\n",
-		 __func__, load->uid, load->size, (char)load->partition);
 
 	buf = (u8 __user *)load->data_addr;
 	xbuf = __genwqe_alloc_consistent(cd, FLASH_BLOCK, &dma_addr);
-	if (xbuf == NULL) {
-		dev_err(&pci_dev->dev, "err: no memory\n");
+	if (xbuf == NULL)
 		return -ENOMEM;
-	}
 
 	blocks_to_flash = load->size / FLASH_BLOCK;
 	while (load->size) {
@@ -565,14 +552,13 @@ static int do_flash_update(struct genwqe
 
 		rc = copy_from_user(xbuf, buf, tocopy);
 		if (rc) {
-			dev_err(&pci_dev->dev,
-				"err: could not copy all data rc=%d\n", rc);
+			rc = -EFAULT;
 			goto free_buffer;
 		}
 		crc = genwqe_crc32(xbuf, tocopy, 0xffffffff);
 
-		dev_info(&pci_dev->dev,
-			 "[%s] DMA: 0x%llx CRC: %08x SZ: %ld %d\n",
+		dev_dbg(&pci_dev->dev,
+			"[%s] DMA: 0x%llx CRC: %08x SZ: %ld %d\n",
 			__func__, dma_addr, crc, tocopy, blocks_to_flash);
 
 		/* prepare DDCB for SLU process */
@@ -626,21 +612,11 @@ static int do_flash_update(struct genwqe
 		load->progress = req->progress;
 
 		if (rc < 0) {
-			dev_err(&pci_dev->dev,
-				"  [%s] DDCB returned (RETC=%x ATTN=%x "
-				"PROG=%x rc=%d)\n", __func__, req->retc,
-				req->attn, req->progress, rc);
-
 			ddcb_requ_free(req);
 			goto free_buffer;
 		}
 
 		if (req->retc != DDCB_RETC_COMPLETE) {
-			dev_info(&pci_dev->dev,
-				 "  [%s] DDCB returned (RETC=%x ATTN=%x "
-				 "PROG=%x)\n", __func__, req->retc,
-				 req->attn, req->progress);
-
 			rc = -EIO;
 			ddcb_requ_free(req);
 			goto free_buffer;
@@ -671,16 +647,11 @@ static int do_flash_read(struct genwqe_f
 	struct pci_dev *pci_dev = cd->pci_dev;
 	struct genwqe_ddcb_cmd *cmd;
 
-	if ((load->size & 0x3) != 0) {
-		dev_err(&pci_dev->dev,
-			"err: buf size %d bytes not 4 bytes aligned!\n",
-			load->size);
+	if ((load->size & 0x3) != 0)
 		return -EINVAL;
-	}
-	if (((unsigned long)(load->data_addr) & ~PAGE_MASK) != 0) {
-		dev_err(&pci_dev->dev, "err: buf is not page aligned!\n");
+
+	if (((unsigned long)(load->data_addr) & ~PAGE_MASK) != 0)
 		return -EINVAL;
-	}
 
 	/* FIXME Bits have changed for new service layer! */
 	switch ((char)load->partition) {
@@ -692,20 +663,13 @@ static int do_flash_read(struct genwqe_f
 		break;		/* upload/part_1 */
 	case 'v':
 	default:
-		dev_err(&pci_dev->dev,
-			"err: invalid partition %02x!\n", load->partition);
 		return -EINVAL;
 	}
-	dev_info(&pci_dev->dev,
-		 "[%s] start flash read UID: 0x%x size: %u bytes part: %c\n",
-		 __func__, load->uid, load->size, (char)load->partition);
 
 	buf = (u8 __user *)load->data_addr;
 	xbuf = __genwqe_alloc_consistent(cd, FLASH_BLOCK, &dma_addr);
-	if (xbuf == NULL) {
-		dev_err(&pci_dev->dev, "err: no memory\n");
+	if (xbuf == NULL)
 		return -ENOMEM;
-	}
 
 	blocks_to_flash = load->size / FLASH_BLOCK;
 	while (load->size) {
@@ -715,9 +679,9 @@ static int do_flash_read(struct genwqe_f
 		 */
 		tocopy = min_t(size_t, load->size, FLASH_BLOCK);
 
-		dev_info(&pci_dev->dev,
-			 "[%s] DMA: 0x%llx SZ: %ld %d\n",
-			 __func__, dma_addr, tocopy, blocks_to_flash);
+		dev_dbg(&pci_dev->dev,
+			"[%s] DMA: 0x%llx SZ: %ld %d\n",
+			__func__, dma_addr, tocopy, blocks_to_flash);
 
 		/* prepare DDCB for SLU process */
 		cmd = ddcb_requ_alloc();
@@ -735,7 +699,7 @@ static int do_flash_read(struct genwqe_f
 			*(__be64 *)&cmd->__asiv[16] = cpu_to_be64(flash);
 			*(__be32 *)&cmd->__asiv[24] = cpu_to_be32(0);
 			cmd->__asiv[24] = load->uid;
-			*(__be32 *)&cmd->__asiv[28] = cpu_to_be32(0)  /* CRC */;
+			*(__be32 *)&cmd->__asiv[28] = cpu_to_be32(0) /* CRC */;
 			cmd->asiv_length = 32; /* bytes included in crc calc */
 		} else {	/* setup DDCB for ATS architecture */
 			*(__be64 *)&cmd->asiv[0]  = cpu_to_be64(dma_addr);
@@ -761,20 +725,13 @@ static int do_flash_read(struct genwqe_f
 		load->progress = cmd->progress;
 
 		if ((rc < 0) && (rc != -EBADMSG)) {
-			dev_err(&pci_dev->dev,
-				"  [%s] DDCB returned (RETC=%x ATTN=%x "
-				"PROG=%x rc=%d)\n", __func__, cmd->retc,
-				cmd->attn, cmd->progress, rc);
 			ddcb_requ_free(cmd);
 			goto free_buffer;
 		}
 
 		rc = copy_to_user(buf, xbuf, tocopy);
 		if (rc) {
-			dev_err(&pci_dev->dev,
-				"  [%s] copy data to user failed rc=%d\n",
-				__func__, rc);
-			rc = -EIO;
+			rc = -EFAULT;
 			ddcb_requ_free(cmd);
 			goto free_buffer;
 		}
@@ -784,10 +741,6 @@ static int do_flash_read(struct genwqe_f
 		     (cmd->attn != 0x02)) ||  /* Normally ignore CRC error */
 		    ((cmd->retc == DDCB_RETC_COMPLETE) &&
 		     (cmd->attn != 0x00))) {  /* Everything was fine */
-			dev_err(&pci_dev->dev,
-				"  [%s] DDCB returned (RETC=%x ATTN=%x "
-				"PROG=%x rc=%d)\n", __func__, cmd->retc,
-				cmd->attn, cmd->progress, rc);
 			rc = -EIO;
 			ddcb_requ_free(cmd);
 			goto free_buffer;
@@ -906,7 +859,6 @@ static int ddcb_cmd_fixups(struct genwqe
 	struct genwqe_dev *cd = cfile->cd;
 	struct genwqe_ddcb_cmd *cmd = &req->cmd;
 	struct dma_mapping *m;
-	struct pci_dev *pci_dev = cd->pci_dev;
 	const char *type = "UNKNOWN";
 
 	for (i = 0, asiv_offs = 0x00; asiv_offs <= 0x58;
@@ -1018,9 +970,6 @@ static int ddcb_cmd_fixups(struct genwqe
 			break;
 		}
 		default:
-			dev_err(&pci_dev->dev,
-				"[%s] err: invalid ATS flags %01llx\n",
-				__func__, ats_flags);
 			rc = -EINVAL;
 			goto err_out;
 		}
@@ -1028,7 +977,6 @@ static int ddcb_cmd_fixups(struct genwqe
 	return 0;
 
  err_out:
-	dev_err(&pci_dev->dev, "[%s] err: rc=%d\n", __func__, rc);
 	ddcb_cmd_cleanup(cfile, req);
 	return rc;
 }
@@ -1063,7 +1011,6 @@ static int do_execute_ddcb(struct genwqe
 	struct genwqe_ddcb_cmd *cmd;
 	struct ddcb_requ *req;
 	struct genwqe_dev *cd = cfile->cd;
-	struct pci_dev *pci_dev = cd->pci_dev;
 
 	cmd = ddcb_requ_alloc();
 	if (cmd == NULL)
@@ -1072,8 +1019,6 @@ static int do_execute_ddcb(struct genwqe
 	req = container_of(cmd, struct ddcb_requ, cmd);
 
 	if (copy_from_user(cmd, (void __user *)arg, sizeof(*cmd))) {
-		dev_err(&pci_dev->dev,
-			"err: could not copy params from user\n");
 		ddcb_requ_free(cmd);
 		return -EFAULT;
 	}
@@ -1087,8 +1032,6 @@ static int do_execute_ddcb(struct genwqe
 	   back since the copy got modified by the driver. */
 	if (copy_to_user((void __user *)arg, cmd,
 			 sizeof(*cmd) - DDCB_ASIV_LENGTH)) {
-		dev_err(&pci_dev->dev,
-			"err: could not copy params to user\n");
 		ddcb_requ_free(cmd);
 		return -EFAULT;
 	}
@@ -1114,12 +1057,9 @@ static long genwqe_ioctl(struct file *fi
 	struct genwqe_reg_io __user *io;
 	u64 val;
 	u32 reg_offs;
-	struct pci_dev *pci_dev = cd->pci_dev;
 
-	if (_IOC_TYPE(cmd) != GENWQE_IOC_CODE) {
-		dev_err(&pci_dev->dev, "err: ioctl code does not match!\n");
+	if (_IOC_TYPE(cmd) != GENWQE_IOC_CODE)
 		return -EINVAL;
-	}
 
 	switch (cmd) {
 
@@ -1131,10 +1071,9 @@ static long genwqe_ioctl(struct file *fi
 	case GENWQE_READ_REG64: {
 		io = (struct genwqe_reg_io __user *)arg;
 
-		if (get_user(reg_offs, &io->num)) {
-			dev_err(&pci_dev->dev, "err: reg read64\n");
+		if (get_user(reg_offs, &io->num))
 			return -EFAULT;
-		}
+
 		if ((reg_offs >= cd->mmio_len) || (reg_offs & 0x7))
 			return -EINVAL;
 
@@ -1152,17 +1091,15 @@ static long genwqe_ioctl(struct file *fi
 		if ((filp->f_flags & O_ACCMODE) == O_RDONLY)
 			return -EPERM;
 
-		if (get_user(reg_offs, &io->num)) {
-			dev_err(&pci_dev->dev, "err: reg write64\n");
+		if (get_user(reg_offs, &io->num))
 			return -EFAULT;
-		}
+
 		if ((reg_offs >= cd->mmio_len) || (reg_offs & 0x7))
 			return -EINVAL;
 
-		if (get_user(val, &io->val64)) {
-			dev_err(&pci_dev->dev, "err: reg write64\n");
+		if (get_user(val, &io->val64))
 			return -EFAULT;
-		}
+
 		__genwqe_writeq(cd, reg_offs, val);
 		return 0;
 	}
@@ -1170,10 +1107,9 @@ static long genwqe_ioctl(struct file *fi
 	case GENWQE_READ_REG32: {
 		io = (struct genwqe_reg_io __user *)arg;
 
-		if (get_user(reg_offs, &io->num)) {
-			dev_err(&pci_dev->dev, "err: reg read32\n");
+		if (get_user(reg_offs, &io->num))
 			return -EFAULT;
-		}
+
 		if ((reg_offs >= cd->mmio_len) || (reg_offs & 0x3))
 			return -EINVAL;
 
@@ -1191,17 +1127,15 @@ static long genwqe_ioctl(struct file *fi
 		if ((filp->f_flags & O_ACCMODE) == O_RDONLY)
 			return -EPERM;
 
-		if (get_user(reg_offs, &io->num)) {
-			dev_err(&pci_dev->dev, "err: reg write32\n");
+		if (get_user(reg_offs, &io->num))
 			return -EFAULT;
-		}
+
 		if ((reg_offs >= cd->mmio_len) || (reg_offs & 0x3))
 			return -EINVAL;
 
-		if (get_user(val, &io->val64)) {
-			dev_err(&pci_dev->dev, "err: reg write32\n");
+		if (get_user(val, &io->val64))
 			return -EFAULT;
-		}
+
 		__genwqe_writel(cd, reg_offs, val);
 		return 0;
 	}
@@ -1217,19 +1151,14 @@ static long genwqe_ioctl(struct file *fi
 			return -EPERM;
 
 		if (copy_from_user(&load, (void __user *)arg,
-				   sizeof(load))) {
-			dev_err(&pci_dev->dev,
-				"err: could not copy params from user\n");
+				   sizeof(load)))
 			return -EFAULT;
-		}
+
 		rc = do_flash_update(cfile, &load);
 
-		if (copy_to_user((void __user *)arg, &load, sizeof(load))) {
-			dev_err(&pci_dev->dev,
-				"err: could not copy params to user\n");
+		if (copy_to_user((void __user *)arg, &load, sizeof(load)))
 			return -EFAULT;
-		}
-		dev_info(&pci_dev->dev, "[%s] rc=%d\n", __func__, rc);
+
 		return rc;
 	}
 
@@ -1242,20 +1171,14 @@ static long genwqe_ioctl(struct file *fi
 		if (genwqe_flash_readback_fails(cd))
 			return -ENOSPC;	 /* known to fail for old versions */
 
-		if (copy_from_user(&load, (void __user *)arg,
-				   sizeof(load))) {
-			dev_err(&pci_dev->dev,
-				"err: could not copy params from user\n");
+		if (copy_from_user(&load, (void __user *)arg, sizeof(load)))
 			return -EFAULT;
-		}
+
 		rc = do_flash_read(cfile, &load);
 
-		if (copy_to_user((void __user *)arg, &load, sizeof(load))) {
-			dev_err(&pci_dev->dev,
-				"err: could not copy params to user\n");
+		if (copy_to_user((void __user *)arg, &load, sizeof(load)))
 			return -EFAULT;
-		}
-		dev_info(&pci_dev->dev, "[%s] rc=%d\n", __func__, rc);
+
 		return rc;
 	}
 
@@ -1263,24 +1186,18 @@ static long genwqe_ioctl(struct file *fi
 	case GENWQE_PIN_MEM: {
 		struct genwqe_mem m;
 
-		if (copy_from_user(&m, (void __user *)arg,
-				   sizeof(m))) {
-			dev_err(&pci_dev->dev,
-				"err: could not copy params from user\n");
+		if (copy_from_user(&m, (void __user *)arg, sizeof(m)))
 			return -EFAULT;
-		}
+
 		return genwqe_pin_mem(cfile, &m);
 	}
 
 	case GENWQE_UNPIN_MEM: {
 		struct genwqe_mem m;
 
-		if (copy_from_user(&m, (void __user *)arg,
-				   sizeof(m))) {
-			dev_err(&pci_dev->dev,
-				"err: could not copy params from user\n");
+		if (copy_from_user(&m, (void __user *)arg, sizeof(m)))
 			return -EFAULT;
-		}
+
 		return genwqe_unpin_mem(cfile, &m);
 	}
 
@@ -1290,16 +1207,13 @@ static long genwqe_ioctl(struct file *fi
 
 	case GENWQE_EXECUTE_RAW_DDCB: {
 
-		if (!capable(CAP_SYS_ADMIN)) {
-			dev_err(&pci_dev->dev,
-				"err: must be superuser execute raw DDCB!\n");
+		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
-		}
+
 		return do_execute_ddcb(cfile, arg, 1);
 	}
 
 	default:
-		pr_err("unknown ioctl %x/%lx**\n", cmd, arg);
 		return -EINVAL;
 	}
 

