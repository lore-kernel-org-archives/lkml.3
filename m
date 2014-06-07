Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbaFGDDA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 23:03:00 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:63762 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbaFGDCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 23:02:41 -0400
From: Thomas Wood <tommyandrena@gmail.com>
To: dan.carpenter@oracle.com
Cc: marek.belisko@gmail.com, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Thomas Wood <tommyandrena@gmail.com>
Subject: [PATCH v2 5/5] staging: ft1000: ft1000-usb: ft1000_debug.c: Misc. fixes.
Date: Fri,  6 Jun 2014 20:02:18 -0700
Message-Id: <1402110138-13713-6-git-send-email-tommyandrena@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402110138-13713-1-git-send-email-tommyandrena@gmail.com>
References: <20140602103056.GY15585@mwanda>
 <1402110138-13713-1-git-send-email-tommyandrena@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove initialization of static value.
Invert the empty if statement's test to replace the else statement.
Remove parentheses from a return statement.
Fix some code indentation.

Signed-off-by: Thomas Wood <tommyandrena@gmail.com>
---

I'm pretty sure that the indentation was caused by a mistake by me earlier on in the patch set, so I'm fixing it now.

 drivers/staging/ft1000/ft1000-usb/ft1000_debug.c | 89 ++++++++++++------------
 1 file changed, 44 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
index 94fb9f9..ef08db9 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
@@ -38,7 +38,7 @@
 #include <linux/debugfs.h>
 #include "ft1000_usb.h"
 
-static int ft1000_flarion_cnt = 0;
+static int ft1000_flarion_cnt;
 
 static int ft1000_open(struct inode *inode, struct file *file);
 static unsigned int ft1000_poll_dev(struct file *file, poll_table *wait);
@@ -389,7 +389,7 @@ static unsigned int ft1000_poll_dev(struct file *file, poll_table *wait)
 	poll_wait(file, &dev->app_info[i].wait_dpram_msg, wait);
 	/* DEBUG("FT1000:ft1000_poll_dev:Polling for data from DSP\n"); */
 
-	return (0);
+	return 0;
 }
 
 /*
@@ -592,70 +592,69 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
 					/* Check message qtype type which is the lower byte within qos_class */
 					qtype = ntohs(dpram_data->pseudohdr.qos_class) & 0xff;
 					/* DEBUG("FT1000_ft1000_ioctl: qtype = %d\n", qtype); */
-					if (qtype) {
-					} else {
+					if (!qtype) {
 						/* Put message into Slow Queue */
 						/* Only put a message into the DPRAM if msg doorbell is available */
 						status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_DOORBELL);
 						/* DEBUG("FT1000_ft1000_ioctl: READ REGISTER tempword=%x\n", tempword); */
 						if (tempword & FT1000_DB_DPRAM_TX) {
-						/* Suspend for 2ms and try again due to DSP doorbell busy */
-						mdelay(2);
-						status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_DOORBELL);
-						if (tempword & FT1000_DB_DPRAM_TX) {
-							/* Suspend for 1ms and try again due to DSP doorbell busy */
-							mdelay(1);
+							/* Suspend for 2ms and try again due to DSP doorbell busy */
+							mdelay(2);
 							status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_DOORBELL);
 							if (tempword & FT1000_DB_DPRAM_TX) {
+								/* Suspend for 1ms and try again due to DSP doorbell busy */
+								mdelay(1);
 								status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_DOORBELL);
 								if (tempword & FT1000_DB_DPRAM_TX) {
-									/* Suspend for 3ms and try again due to DSP doorbell busy */
-									mdelay(3);
 									status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_DOORBELL);
 									if (tempword & FT1000_DB_DPRAM_TX) {
-										DEBUG("FT1000:ft1000_ioctl:Doorbell not available\n");
-										result = -ENOTTY;
-										kfree(dpram_data);
-										break;
+										/* Suspend for 3ms and try again due to DSP doorbell busy */
+										mdelay(3);
+										status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_DOORBELL);
+										if (tempword & FT1000_DB_DPRAM_TX) {
+											DEBUG("FT1000:ft1000_ioctl:Doorbell not available\n");
+											result = -ENOTTY;
+											kfree(dpram_data);
+											break;
+										}
 									}
 								}
 							}
 						}
-					}
 
-					/*DEBUG("FT1000_ft1000_ioctl: finished reading register\n"); */
-
-					/* Make sure we are within the limits of the slow queue memory limitation */
-					if ((msgsz < MAX_CMD_SQSIZE) && (msgsz > PSEUDOSZ)) {
-						/* Need to put sequence number plus new checksum for message */
-						pmsg = (u16 *)&dpram_data->pseudohdr;
-						ppseudo_hdr = (struct pseudo_hdr *)pmsg;
-						total_len = msgsz+2;
-						if (total_len & 0x1)
-							total_len++;
-
-						/* Insert slow queue sequence number */
-						ppseudo_hdr->seq_num = info->squeseqnum++;
-						ppseudo_hdr->portsrc = ft1000dev->app_info[app_index].app_id;
-						/* Calculate new checksum */
-						ppseudo_hdr->checksum = *pmsg++;
-						/* DEBUG("checksum = 0x%x\n", ppseudo_hdr->checksum); */
-						for (i = 1; i < 7; i++) {
-							ppseudo_hdr->checksum ^= *pmsg++;
+						/*DEBUG("FT1000_ft1000_ioctl: finished reading register\n"); */
+
+						/* Make sure we are within the limits of the slow queue memory limitation */
+						if ((msgsz < MAX_CMD_SQSIZE) && (msgsz > PSEUDOSZ)) {
+							/* Need to put sequence number plus new checksum for message */
+							pmsg = (u16 *)&dpram_data->pseudohdr;
+							ppseudo_hdr = (struct pseudo_hdr *)pmsg;
+							total_len = msgsz+2;
+							if (total_len & 0x1)
+								total_len++;
+
+							/* Insert slow queue sequence number */
+							ppseudo_hdr->seq_num = info->squeseqnum++;
+							ppseudo_hdr->portsrc = ft1000dev->app_info[app_index].app_id;
+							/* Calculate new checksum */
+							ppseudo_hdr->checksum = *pmsg++;
 							/* DEBUG("checksum = 0x%x\n", ppseudo_hdr->checksum); */
-						}
-						pmsg++;
-						ppseudo_hdr = (struct pseudo_hdr *)pmsg;
-						card_send_command(ft1000dev, (unsigned short *)dpram_data, total_len+2);
+							for (i = 1; i < 7; i++) {
+								ppseudo_hdr->checksum ^= *pmsg++;
+								/* DEBUG("checksum = 0x%x\n", ppseudo_hdr->checksum); */
+							}
+							pmsg++;
+							ppseudo_hdr = (struct pseudo_hdr *)pmsg;
+							card_send_command(ft1000dev, (unsigned short *)dpram_data, total_len+2);
 
 
-						ft1000dev->app_info[app_index].nTxMsg++;
-						} else {
-							result = -EINVAL;
+							ft1000dev->app_info[app_index].nTxMsg++;
+							} else {
+								result = -EINVAL;
+							}
 						}
 					}
-				}
-			} else {
+				} else {
 				DEBUG("FT1000:ft1000_ioctl: Card not ready take messages\n");
 				result = -EACCES;
 			}
-- 
1.9.1

