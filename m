Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab3BLWmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 17:42:33 -0500
Received: from mail.df.lth.se ([194.47.250.12]:18890 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759148Ab3BLWlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 17:41:36 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 9/9] block: xd: replace all printks with pr_*
Date: Tue, 12 Feb 2013 23:41:00 +0100
Message-Id: <1360708860-23466-11-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1360708860-23466-10-git-send-email-linus.walleij@linaro.org>
References: <1360708860-23466-1-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-2-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-3-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-4-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-5-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-6-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-7-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-8-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-9-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-10-git-send-email-linus.walleij@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This replaces all the printk() statements with pr_* messages
tagged with the apropriate log level. Errors are printed as
pr_err() etc.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/block/xd.c | 97 ++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 62 insertions(+), 35 deletions(-)

diff --git a/drivers/block/xd.c b/drivers/block/xd.c
index 7ecebd4..8ee500f 100644
--- a/drivers/block/xd.c
+++ b/drivers/block/xd.c
@@ -331,7 +331,7 @@ static inline u_int xd_wait_for_IRQ(void)
 	release_dma_lock(flags);
 
 	if (xd_error) {
-		printk("xd: missed IRQ - command aborted\n");
+		pr_err("xd: missed IRQ - command aborted\n");
 		xd_error = 0;
 		return (1);
 	}
@@ -397,7 +397,7 @@ static u_int xd_command(u_char *command, u_char mode, u_char *indata,
 	if (csb & CSB_ERROR) {									/* read sense data if error */
 		xd_build(cmdblk,CMD_SENSE,(csb & CSB_LUN) >> 5,0,0,0,0,0);
 		if (xd_command(cmdblk,0,sense,NULL,NULL,XD_TIMEOUT))
-			printk("xd: warning! sense command failed!\n");
+			pr_warning("xd: warning! sense command failed!\n");
 	}
 
 	pr_debug("%s: completed with csb = 0x%X\n", __func__, csb);
@@ -426,7 +426,8 @@ static void __init xd_setparam (u_char command, u_char drive, u_char heads,
 
 	/* Some controllers require geometry info as data, not command */
 	if (xd_command(cmdblk,PIO_MODE,NULL,&cmdblk[6],NULL,XD_TIMEOUT * 2))
-		printk("xd: error setting characteristics for xd%c\n", 'a'+drive);
+		pr_err("xd: error setting characteristics for xd%c\n",
+		       'a' + drive);
 }
 
 /**
@@ -439,7 +440,8 @@ static void xd_recalibrate(u_char drive)
 
 	xd_build(cmdblk,CMD_RECALIBRATE,drive,0,0,0,0,0);
 	if (xd_command(cmdblk,PIO_MODE,NULL,NULL,NULL,XD_TIMEOUT * 8))
-		printk("xd%c: warning! error recalibrating, controller may be unstable\n", 'a'+drive);
+		pr_warning("xd%c: warning! error recalibrating, controller may be unstable\n",
+			   'a' + drive);
 }
 
 /**
@@ -488,29 +490,40 @@ static int xd_readwrite(u_char operation, struct xd_info *p, char *buffer,
 
 		switch (xd_command(cmdblk,mode,(u_char *)(*real_buffer),(u_char *)(*real_buffer),sense,XD_TIMEOUT)) {
 			case 1:
-				printk("xd%c: %s timeout, recalibrating drive\n",'a'+drive,(operation == READ ? "read" : "write"));
+				pr_err("xd%c: %s timeout, recalibrating drive\n",
+				       'a' + drive,
+				       (operation == READ ? "read" : "write"));
 				xd_recalibrate(drive);
 				spin_lock_irq(&xd_lock);
 				return -EIO;
 			case 2:
 				if (sense[0] & 0x30) {
-					printk("xd%c: %s - ",'a'+drive,(operation == READ ? "reading" : "writing"));
+					pr_err("xd%c: %s - ", 'a' + drive,
+					       (operation == READ ? "reading" : "writing"));
 					switch ((sense[0] & 0x30) >> 4) {
-					case 0: printk("drive error, code = 0x%X",sense[0] & 0x0F);
+					case 0:
+						pr_cont("drive error, code = 0x%X",
+						       sense[0] & 0x0F);
 						break;
-					case 1: printk("controller error, code = 0x%X",sense[0] & 0x0F);
+					case 1:
+						pr_cont("controller error, code = 0x%X",
+						       sense[0] & 0x0F);
 						break;
-					case 2: printk("command error, code = 0x%X",sense[0] & 0x0F);
+					case 2:
+						pr_cont("command error, code = 0x%X",
+						       sense[0] & 0x0F);
 						break;
-					case 3: printk("miscellaneous error, code = 0x%X",sense[0] & 0x0F);
+					case 3:
+						pr_cont("miscellaneous error, code = 0x%X",
+						       sense[0] & 0x0F);
 						break;
 					}
 				}
 				if (sense[0] & 0x80)
-					printk(" - CHS = %d/%d/%d\n",((sense[2] & 0xC0) << 2) | sense[3],sense[1] & 0x1F,sense[2] & 0x3F);
+					pr_cont(" - CHS = %d/%d/%d\n",((sense[2] & 0xC0) << 2) | sense[3],sense[1] & 0x1F,sense[2] & 0x3F);
 				/*	reported drive number = (sense[1] & 0xE0) >> 5 */
 				else
-					printk(" - no valid disk address\n");
+					pr_cont(" - no valid disk address\n");
 				spin_lock_irq(&xd_lock);
 				return -EIO;
 		}
@@ -664,7 +677,7 @@ static irqreturn_t xd_interrupt_handler(int irq, void *dev_id)
 		return IRQ_HANDLED;
 	}
 	else
-		printk("xd: unexpected interrupt\n");
+		pr_err("xd: unexpected interrupt\n");
 	return IRQ_NONE;
 }
 
@@ -707,8 +720,10 @@ static void __init xd_dtc_init_controller(unsigned int address)
 		case 0xCA000:	xd_iobase = 0x324;
 		case 0xD0000:				/*5150CX*/
 		case 0xD8000:	break;			/*5150CX & 5150XL*/
-		default:        printk("xd_dtc_init_controller: unsupported BIOS address %06x\n",address);
-				break;
+		default:
+			pr_err("%s: unsupported BIOS address %06x\n",
+			       __func__, address);
+			break;
 	}
 	xd_maxsectors = 0x01;		/* my card seems to have trouble doing multi-block transfers? */
 
@@ -756,7 +771,8 @@ static void __init xd_dtc5150cx_init_drive(u_char drive)
 #endif /* 0 */
 		}
 		else {
-			printk("xd%c: undetermined drive geometry\n",'a'+drive);
+			pr_err("xd%c: undetermined drive geometry\n",
+			       'a' + drive);
 			return;
 		}
 	xd_info[drive].control = 5;				/* control byte */
@@ -785,10 +801,12 @@ static void __init xd_dtc_init_drive(u_char drive)
 		xd_setparam(CMD_DTCSETPARAM,drive,xd_info[drive].heads,xd_info[drive].cylinders,((u_short *) (buf + 1))[0x05],((u_short *) (buf + 1))[0x06],buf[0x0F]);
 		xd_build(cmdblk,CMD_DTCSETSTEP,drive,0,0,0,0,7);
 		if (xd_command(cmdblk,PIO_MODE,NULL,NULL,NULL,XD_TIMEOUT * 2))
-			printk("xd_dtc_init_drive: error setting step rate for xd%c\n", 'a'+drive);
+			pr_err("%s: error setting step rate for xd%c\n",
+			       __func__, 'a'+drive);
 	}
 	else
-		printk("xd_dtc_init_drive: error reading geometry for xd%c\n", 'a'+drive);
+		pr_err("%s: error reading geometry for xd%c\n",
+		       __func__, 'a'+drive);
 }
 
 static void __init xd_wd_init_controller(unsigned int address)
@@ -801,7 +819,9 @@ static void __init xd_wd_init_controller(unsigned int address)
 		case 0xCE000:   xd_iobase = 0x32C; break;
 		case 0xD0000:	xd_iobase = 0x328; break; /* ? */
 		case 0xD8000:	xd_iobase = 0x32C; break; /* ? */
-		default:        printk("xd_wd_init_controller: unsupported BIOS address %06x\n",address);
+		default:
+			pr_err("%s: unsupported BIOS address %06x\n",
+			       __func__, address);
 				break;
 	}
 	/* this one doesn't wrap properly either... */
@@ -880,7 +900,8 @@ static void __init xd_wd_init_drive(u_char drive)
 		}
 	}
 	else
-		printk("xd_wd_init_drive: error reading geometry for xd%c\n",'a'+drive);
+		pr_err("%s: error reading geometry for xd%c\n",
+		       __func__, 'a' + drive);
 }
 
 static void __init xd_seagate_init_controller (unsigned int address)
@@ -891,8 +912,10 @@ static void __init xd_seagate_init_controller (unsigned int address)
 		case 0xD0000:	xd_iobase = 0x324; break;
 		case 0xD8000:	xd_iobase = 0x328; break;
 		case 0xE0000:	xd_iobase = 0x32C; break;
-		default:	printk("xd_seagate_init_controller: unsupported BIOS address %06x\n",address);
-				break;
+		default:
+			pr_err("%s: unsupported BIOS address %06x\n",
+			       __func__, address);
+			break;
 	}
 	xd_maxsectors = 0x40;
 
@@ -912,7 +935,8 @@ static void __init xd_seagate_init_drive(u_char drive)
 		xd_info[drive].control = 0;
 	}
 	else
-		printk("xd_seagate_init_drive: error reading geometry from xd%c\n", 'a'+drive);
+		pr_err("%s: error reading geometry from xd%c\n",
+		       __func__, 'a' + drive);
 }
 
 /* Omti support courtesy Dirk Melchers */
@@ -932,7 +956,8 @@ static void __init xd_omti_init_controller(unsigned int address)
 			xd_iobase = 0x32C;
 			break;
 		default:
-			printk("xd_omti_init_controller: unsupported BIOS address %06x\n",address);
+			pr_err("%s: unsupported BIOS address %06x\n",
+			       __func__, address);
 			break;
 	}
 
@@ -976,7 +1001,8 @@ static void __init xd_xebec_init_controller(unsigned int address)
 		case 0xE0000:
 			break;
 		default:
-			printk("xd_xebec_init_controller: unsupported BIOS address %06x\n",address);
+			pr_err("%s: unsupported BIOS address %06x\n",
+			       __func__, address);
 			break;
 		}
 
@@ -1073,7 +1099,8 @@ static void __init do_xd_setup(int *integers)
 			if ((integers[1] >= 0) && (integers[1] < ARRAY_SIZE(xd_sigs)))
 				xd_type = integers[1];
 		case 0: break;
-		default:printk("xd: too many parameters for xd\n");
+		default:
+			pr_err("xd: too many parameters for xd\n");
 	}
 	xd_maxsectors = 0x01;
 }
@@ -1109,18 +1136,18 @@ static int __init xd_init(void)
 
 	if (xd_detect(&controller,&address)) {
 
-		printk("Detected a%s controller (type %d) at address %06x\n",
+		pr_info("Detected a%s controller (type %d) at address %06x\n",
 			xd_sigs[controller].name,controller,address);
 		if (!request_region(xd_iobase,4,"xd")) {
-			printk("xd: Ports at 0x%x are not available\n",
-				xd_iobase);
+			pr_err("xd: Ports at 0x%x are not available\n",
+			       xd_iobase);
 			goto out2;
 		}
 		if (controller)
 			xd_sigs[controller].init_controller(address);
 		xd_drives = xd_initdrives(xd_sigs[controller].init_drive);
 
-		printk("Detected %d hard drive%s (using IRQ%d & DMA%d)\n",
+		pr_info("Detected %d hard drive%s (using IRQ%d & DMA%d)\n",
 			xd_drives,xd_drives == 1 ? "" : "s",xd_irq,xd_dma);
 	}
 
@@ -1132,7 +1159,7 @@ static int __init xd_init(void)
 	if (!xd_dma_buffer && xd_maxsectors) {
 		xd_dma_buffer = (char *)xd_dma_mem_alloc(xd_maxsectors * 0x200);
 		if (!xd_dma_buffer) {
-			printk(KERN_ERR "xd: Out of memory.\n");
+			pr_err("xd: Out of memory.\n");
 			goto out3;
 		}
 	}
@@ -1154,19 +1181,19 @@ static int __init xd_init(void)
 		disk->private_data = p;
 		disk->queue = xd_queue;
 		set_capacity(disk, p->heads * p->cylinders * p->sectors);
-		printk(" %s: CHS=%d/%d/%d\n", disk->disk_name,
+		pr_info(" %s: CHS=%d/%d/%d\n", disk->disk_name,
 			p->cylinders, p->heads, p->sectors);
 		xd_gendisk[i] = disk;
 	}
 
 	err = -EBUSY;
 	if (request_irq(xd_irq,xd_interrupt_handler, 0, "XT hard disk", NULL)) {
-		printk("xd: unable to get IRQ%d\n",xd_irq);
+		pr_err("xd: unable to get IRQ%d\n", xd_irq);
 		goto out4;
 	}
 
 	if (request_dma(xd_dma,"xd")) {
-		printk("xd: unable to get DMA%d\n",xd_dma);
+		pr_err("xd: unable to get DMA%d\n", xd_dma);
 		goto out5;
 	}
 
@@ -1249,7 +1276,7 @@ static int __init xd_manual_geo_init (char *str)
 
 	get_options (str, ARRAY_SIZE(integers), integers);
 	if (integers[0]%3 != 0) {
-		printk("xd: incorrect number of parameters for xd_geo\n");
+		pr_err("xd: incorrect number of parameters for xd_geo\n");
 		return 1;
 	}
 	for (i = 0; (i < integers[0]) && (i < 3*XD_MAXDRIVES); i++)
-- 
1.8.1.2

