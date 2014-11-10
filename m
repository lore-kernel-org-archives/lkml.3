Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbaKJUY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:24:29 -0500
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:37021 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751771AbaKJUY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:24:27 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtsNAPgdYVRXQ4qy/2dsb2JhbABcgw6BLbgoBQF0miwCgScXAQEBAQF9hAMBBScvIxBROR4ZiEUBvRyPfwEBAQEGIoY6ilsHhEsFhjqXa5Zgg3s8L4JLAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>, Jens Axboe <axboe@kernel.dk>,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH v2 10/10 linux-next] cdrom: uniformize lba command initialization
Date: Mon, 10 Nov 2014 21:24:19 +0100
Message-Id: <1415651059-10071-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415650916-9975-1-git-send-email-fabf@skynet.be>
References: <1415650916-9975-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

logical block address field was initialized in different
functions directly in package cmd or bio cmd.

Note that cdrom_dummy_generic_packet didn't use & 0xff

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/cdrom/cdrom.c | 33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 9a6fa8f..3922038 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -327,6 +327,14 @@ do {							\
 
 LIST_HEAD(cdrom_list);
 
+static void int_to_cmd_lba(int value, unsigned char *cmd)
+{
+	cmd[2] = (value >> 24) & 0xff;
+	cmd[3] = (value >> 16) & 0xff;
+	cmd[4] = (value >> 8) & 0xff;
+	cmd[5] = value & 0xff;
+}
+
 static int cdrom_dummy_generic_packet(struct cdrom_device_info *cdi,
 				      struct packet_command *cgc)
 {
@@ -1681,10 +1689,7 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		cd_dbg(CD_DVD, "entering DVD_LU_SEND_TITLE_KEY\n");
 		cgc.quiet = 1;
 		setup_report_key(&cgc, ai->lstk.agid, 4);
-		cgc.cmd[5] = ai->lstk.lba;
-		cgc.cmd[4] = ai->lstk.lba >> 8;
-		cgc.cmd[3] = ai->lstk.lba >> 16;
-		cgc.cmd[2] = ai->lstk.lba >> 24;
+		int_to_cmd_lba(ai->lstk.lba, cgc.cmd);
 
 		if ((ret = cdo->generic_packet(cdi, &cgc)))
 			return ret;
@@ -2060,10 +2065,7 @@ static int cdrom_read_cd(struct cdrom_device_info *cdi,
 
 	memset(&cgc->cmd, 0, sizeof(cgc->cmd));
 	cgc->cmd[0] = GPCMD_READ_10;
-	cgc->cmd[2] = (lba >> 24) & 0xff;
-	cgc->cmd[3] = (lba >> 16) & 0xff;
-	cgc->cmd[4] = (lba >>  8) & 0xff;
-	cgc->cmd[5] = lba & 0xff;
+	int_to_cmd_lba(lba, cgc->cmd);
 	cgc->cmd[6] = (nblocks >> 16) & 0xff;
 	cgc->cmd[7] = (nblocks >>  8) & 0xff;
 	cgc->cmd[8] = nblocks & 0xff;
@@ -2083,10 +2085,7 @@ static int cdrom_read_block(struct cdrom_device_info *cdi,
 	/* expected sector size - cdda,mode1,etc. */
 	cgc->cmd[1] = format << 2;
 	/* starting address */
-	cgc->cmd[2] = (lba >> 24) & 0xff;
-	cgc->cmd[3] = (lba >> 16) & 0xff;
-	cgc->cmd[4] = (lba >>  8) & 0xff;
-	cgc->cmd[5] = lba & 0xff;
+	int_to_cmd_lba(lba, cgc->cmd);
 	/* number of blocks */
 	cgc->cmd[6] = (nblocks >> 16) & 0xff;
 	cgc->cmd[7] = (nblocks >>  8) & 0xff;
@@ -2188,10 +2187,7 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 
 		rq->cmd[0] = GPCMD_READ_CD;
 		rq->cmd[1] = 1 << 2;
-		rq->cmd[2] = (lba >> 24) & 0xff;
-		rq->cmd[3] = (lba >> 16) & 0xff;
-		rq->cmd[4] = (lba >>  8) & 0xff;
-		rq->cmd[5] = lba & 0xff;
+		int_to_cmd_lba(lba, rq->cmd);
 		rq->cmd[6] = (nr >> 16) & 0xff;
 		rq->cmd[7] = (nr >>  8) & 0xff;
 		rq->cmd[8] = nr & 0xff;
@@ -3059,10 +3055,7 @@ static noinline int mmc_ioctl_cdrom_play_blk(struct cdrom_device_info *cdi,
 	if (copy_from_user(&blk, (struct cdrom_blk __user *)arg, sizeof(blk)))
 		return -EFAULT;
 	cgc->cmd[0] = GPCMD_PLAY_AUDIO_10;
-	cgc->cmd[2] = (blk.from >> 24) & 0xff;
-	cgc->cmd[3] = (blk.from >> 16) & 0xff;
-	cgc->cmd[4] = (blk.from >>  8) & 0xff;
-	cgc->cmd[5] = blk.from & 0xff;
+	int_to_cmd_lba(blk.from, cgc->cmd);
 	cgc->cmd[7] = (blk.len >> 8) & 0xff;
 	cgc->cmd[8] = blk.len & 0xff;
 	cgc->data_direction = CGC_DATA_NONE;
-- 
1.9.1

