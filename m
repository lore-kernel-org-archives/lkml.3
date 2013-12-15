Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab3LOTUB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 14:20:01 -0500
Received: from mail-1.atlantis.sk ([80.94.52.57]:58113 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab3LOTUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 14:20:00 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-mmc@vger.kernel.org
Subject: [PATCH] Re: Toshiba TC6371AF PCI SD card controller (SD TypA) driver
Date: Sun, 15 Dec 2013 20:19:30 +0100
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: Kernel development list <linux-kernel@vger.kernel.org>
References: <201312101952.05713.linux@rainbow-software.org>
In-Reply-To: <201312101952.05713.linux@rainbow-software.org>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2895
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201312152019.31588.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've manged to fix the Richards' driver - it now compiles with 3.13-rc3 and
works - it reads&writes both SD and SDHC cards. See the (ugly) patch below.
It still needs a lot of work.

The chip on the board is T7L65XB (can be seen after removing keyboard).


diff --git a/drivers/mmc/host/toshsd.c b/drivers/mmc/host/toshsd.c
index 85bd5641..d7667f6 100644
--- a/drivers/mmc/host/toshsd.c
+++ b/drivers/mmc/host/toshsd.c
@@ -14,12 +14,14 @@
 
 #include <linux/delay.h>
 #include <linux/highmem.h>
+#include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/scatterlist.h>
 #include <linux/interrupt.h>
 
 #include <linux/mmc/host.h>
-#include <linux/mmc/protocol.h>
+#include <linux/mmc/mmc.h>
+#include <linux/mmc/sd.h>
 
 #include "toshsd.h"
 
@@ -51,12 +53,6 @@ MODULE_DEVICE_TABLE(pci, pci_ids);
 static int toshsd_init(struct toshsd_host *host);
 
 static void
-toshsd_dumpregs(struct toshsd_host *host)
-{
-        printk(KERN_DEBUG DRIVER_NAME "0x%08x\n", 0x00);
-}
-
-static void
 toshsd_mmc_finish_request(struct toshsd_host *host)
 {
         struct mmc_request *mrq = host->mrq;
@@ -80,6 +76,7 @@ toshsd_mmc_data_transfer(unsigned long h)
 {
         struct toshsd_host *host = (struct toshsd_host *) h;
         struct mmc_data *data = host->data;
+        void *sg_virt;
         unsigned short *buf;
         int count;
         unsigned long flags;
@@ -88,10 +85,10 @@ toshsd_mmc_data_transfer(unsigned long h)
                 DBG("Spurious Data IRQ\n");
                 return;
         }
-//      spin_lock(&host->lock);
+	spin_lock_irqsave(&host->lock, flags);
 
-        buf = kmap(host->sg_ptr->page);
-        buf += host->sg_ptr->offset / 2 + host->sg_off / 2;
+  	sg_virt = kmap_atomic(sg_page(host->sg_ptr)) + host->sg_ptr->offset;
+        buf = (unsigned short *)(sg_virt + host->sg_off);
 
         /* Ensure we dont read more than one block. The chip will interrupt us
          * When the next block is available.
@@ -101,8 +98,8 @@ toshsd_mmc_data_transfer(unsigned long h)
                 count = data->blksz;
         }
 
-        DBG("count: %08x, page: %p, offset: %08x flags %08x\n", count,
-            host->sg_ptr->page, host->sg_off, data->flags);
+        DBG("count: %08x, offset: %08x flags %08x\n", count,
+            host->sg_off, data->flags);
 
         host->sg_off += count;
 
@@ -123,15 +120,14 @@ toshsd_mmc_data_transfer(unsigned long h)
                 }
         }
 
-        flush_dcache_page(host->sg_ptr->page);
-        kunmap(host->sg_ptr->page);
+	kunmap_atomic(sg_virt - host->sg_ptr->offset);
 
         if (host->sg_off == host->sg_ptr->length) {
-                host->sg_ptr++;
+                host->sg_ptr = sg_next(host->sg_ptr);
                 host->sg_off = 0;
                 --host->sg_len;
         }
-//      spin_unlock(&host->lock);
+        spin_unlock_irqrestore(&host->lock, flags);
 
         return;
 }
@@ -188,11 +184,11 @@ toshsd_mmc_cmd_irq(struct toshsd_host *host, unsigned int buffer_stat)
         }
 
         if (buffer_stat & SD_CTRL_BUFFERSTATUS_CMD_TIMEOUT) {
-                cmd->error = MMC_ERR_TIMEOUT;
+                cmd->error = -ETIMEDOUT;
                 DBG("Timeout\n");
         } else if ((buffer_stat & SD_CTRL_BUFFERSTATUS_CRC_ERROR)
                    && (cmd->flags & MMC_RSP_CRC)) {
-                cmd->error = MMC_ERR_BADCRC;
+                cmd->error = -EIO;
                 DBG("BadCRC\n");
         } else if (buffer_stat & (SD_CTRL_BUFFERSTATUS_ILLEGAL_ACCESS
                                   | SD_CTRL_BUFFERSTATUS_CMD_INDEX_ERROR
@@ -206,13 +202,13 @@ toshsd_mmc_cmd_irq(struct toshsd_host *host, unsigned int buffer_stat)
                     READ_TOSHSD(SD_CTRL_ErrorStatus0));
                 DBG("detail1 error status 0x%04x\n",
                     READ_TOSHSD(SD_CTRL_ErrorStatus1));
-                cmd->error = MMC_ERR_FAILED;
+                cmd->error = -EIO;
         }
 
         DBG("Command IRQ complete %d %d %x\n", cmd->opcode, cmd->error,
             cmd->flags);
 
-        if (cmd->error == MMC_ERR_NONE) {
+        if (cmd->error == 0) {
                 switch (cmd->opcode) {
                 case SD_APP_SET_BUS_WIDTH:
                         if (cmd->arg == SD_BUS_WIDTH_4) {
@@ -258,7 +254,7 @@ toshsd_mmc_cmd_irq(struct toshsd_host *host, unsigned int buffer_stat)
 
         /* If there is data to handle we enable data IRQs here, and we will
          * ultimatley finish the request in the mmc_data_end_irq handler.*/
-        if (host->data && (cmd->error == MMC_ERR_NONE)) {
+        if (host->data && (cmd->error == 0)) {
                 bmask = READ_TOSHSD(SD_CTRL_IntMaskBuffer);
 
                 if (host->data->flags & MMC_DATA_READ) {
@@ -297,7 +293,7 @@ toshsd_mmc_data_end_irq(struct toshsd_host *host)
                 return;
         }
 
-        if (data->error == MMC_ERR_NONE) {
+        if (data->error == 0) {
                 data->bytes_xfered = data->blocks * data->blksz;
         } else {
                 data->bytes_xfered = 0;
@@ -342,17 +338,8 @@ toshsd_irq(int irq, void *dev_id)
 
 //    DBG("IRQ bstatus:%x bmask:%x cstatus:%x cmask:%x\n", bstatus, bmask, cstatus, cmask);
 
-        if (!breg && !creg) {
-                /* This occurs sometimes for no known reason.  It doesn't hurt anything, so I don't print it.  */
-                spin_lock(&host->lock);
-                WRITE_TOSHSD(SD_CTRL_IntMaskBuffer, bmask & ~breg);
-                WRITE_TOSHSD(SD_CTRL_IntMaskCard, cmask & ~creg);
-                spin_unlock(&host->lock);
-
-                result = IRQ_NONE;
-
-                goto out;
-        }
+        if (!breg && !creg)
+                return IRQ_NONE;
 
         while (breg || creg) {
 
@@ -436,8 +423,6 @@ toshsd_irq(int irq, void *dev_id)
       out:
         /* Ensure all interrupt sources are cleared */
         spin_lock(&host->lock);
-        WRITE_TOSHSD(SD_CTRL_BufferCtrl, 0);
-        WRITE_TOSHSD(SD_CTRL_CardStatus, 0);
 
         if (reset && 0) {
                 DBG("Resetting device\n");
@@ -467,7 +452,6 @@ toshsd_mmc_start_command(struct toshsd_host *host, struct mmc_command *cmd)
                 cmd->resp[1] = 0;
                 cmd->resp[2] = 0;
                 cmd->resp[3] = 0;
-                cmd->resp[4] = 0;
 
                 return;
         }
@@ -529,9 +513,9 @@ toshsd_mmc_start_command(struct toshsd_host *host, struct mmc_command *cmd)
                                             |
                                             SD_CTRL_INTMASKCARD_CARD_INSERTED_0));
 
-        WRITE_TOSHSD(SD_CTRL_IntMaskBuffer, ~(SD_CTRL_INTMASKBUFFER_UNK7
+        WRITE_TOSHSD(SD_CTRL_IntMaskBuffer, SD_CTRL_INTMASKBUFFER_UNK7
                                               |
-                                              SD_CTRL_INTMASKBUFFER_CMD_BUSY));
+                                              SD_CTRL_INTMASKBUFFER_CMD_BUSY);
 
         /* Send the command */
         WRITE_TOSHSD(SD_CTRL_Arg1, cmd->arg >> 16);
@@ -542,7 +526,7 @@ toshsd_mmc_start_command(struct toshsd_host *host, struct mmc_command *cmd)
 static void
 toshsd_mmc_start_data(struct toshsd_host *host, struct mmc_data *data)
 {
-        DBG("setup data transfer: blocksize %08x  nr_blocks %d, page: %08x, offset: %08x\n", data->blksz, data->blocks, (unsigned int) data->sg->page, data->sg->offset);
+        DBG("setup data transfer: blocksize %08x  nr_blocks %d, offset: %08x\n", data->blksz, data->blocks, data->sg->offset);
 
         host->sg_len = data->sg_len;
         host->sg_ptr = data->sg;
@@ -729,14 +713,14 @@ toshsd_suspend(struct pci_dev *pdev, pm_message_t state)
                     pci_write_config_word(host->chip->pdev, SD_CONFIG_Command,
                                           0);
 
-                ret = mmc_suspend_host(host->mmc, state);
-                if (ret) {
-                        for (i--; i >= 0; i--) {
-                                mmc_resume_host(chip->hosts[i]->mmc);
-                        }
-
-                        return ret;
-                }
+//                ret = mmc_suspend_host(host->mmc, state);
+//                if (ret) {
+//                        for (i--; i >= 0; i--) {
+//                                mmc_resume_host(chip->hosts[i]->mmc);
+//                        }
+//
+//                        return ret;
+//                }
         }
 
         pci_save_state(pdev);
@@ -772,10 +756,10 @@ toshsd_resume(struct pci_dev *pdev)
                 toshsd_init(chip->hosts[i]);
 //              mmiowb();
 
-                ret = mmc_resume_host(chip->hosts[i]->mmc);
-                if (ret) {
-                        return ret;
-                }
+//                ret = mmc_resume_host(chip->hosts[i]->mmc);
+//                if (ret) {
+//                        return ret;
+//                }
         }
 
         return 0;
@@ -954,7 +938,7 @@ toshsd_probe_slot(struct pci_dev *pdev, int slot)
         }
 
         ret =
-            request_irq(host->irq, toshsd_irq, SA_SHIRQ, host->slot_descr,
+            request_irq(host->irq, toshsd_irq, IRQF_SHARED, host->slot_descr,
                         host);
         if (ret) {
                 goto untasklet;
diff --git a/drivers/mmc/host/toshsd.h b/drivers/mmc/host/toshsd.h
index bbb0e32..5057902 100644
--- a/drivers/mmc/host/toshsd.h
+++ b/drivers/mmc/host/toshsd.h
@@ -56,8 +56,8 @@
 #define SD_CTRL_Response7            0x1a
 #define SD_CTRL_CardStatus           0x1c
 #define SD_CTRL_BufferCtrl           0x1e
-#define SD_CTRL_IntMaskBuffer        0x20
-#define SD_CTRL_IntMaskCard          0x22
+#define SD_CTRL_IntMaskCard          0x20
+#define SD_CTRL_IntMaskBuffer        0x22
 #define SD_CTRL_CardClockCtrl        0x24
 #define SD_CTRL_MemCardXferDataLen   0x26
 #define SD_CTRL_MemCardOptionSetup   0x28


-- 
Ondrej Zary
