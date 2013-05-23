Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759163Ab3EWN6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 09:58:46 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48021 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759131Ab3EWN6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 09:58:44 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, stable@gnu.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v3 part1 4/4] sg_io: resolve conflicts between commands assigned to multiple classes (CVE-2012-4542)
Date: Thu, 23 May 2013 15:58:23 +0200
Message-Id: <1369317503-4095-5-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369317503-4095-1-git-send-email-pbonzini@redhat.com>
References: <1369317503-4095-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some SCSI commands can be sent to disks via SG_IO even by unprivileged
users.  Unfortunately, some opcodes overlap across SCSI device classes
and have different meanings for different classes.  Four of them can
be used for read-only file descriptors on MMC, but should be limited to
descriptors opened for read-write on SBC:

- READ SUBCHANNEL <-> UNMAP (destructive, but no control on written
  data)

- GET PERFORMANCE <-> ERASE (not really a problem, no one supports
  ERASE anyway)

- READ DISC INFORMATION <-> XPWRITE (not commonly implemented but
  most dangerous)

- PLAY AUDIO TI <-> SANITIZE (a very new command)

In addition, REPORT KEY's opcode A4h is used in SPC for SET TARGET PORT
GROUPS and various other management commands, and should be blocked
for everything except CD-ROMs and the like.

To fix this, the series modifies the bitmap entries for these five
commands.  This is the smallest change that fixes this bug.

Cc: stable@gnu.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 block/scsi_ioctl.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 6e18156..7a1d9f6 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -199,6 +199,32 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	sgio_bitmap_set(GPCMD_SET_STREAMING, write);
 	sgio_bitmap_set(GPCMD_SET_READ_AHEAD, write);
 #undef sgio_bitmap_set
+
+	/*
+	 * Treat specially those commands that have a different meaning
+	 * for disks: READ SUBCHANNEL conflicts with UNMAP.
+	 */
+	filter->read_ok[GPCMD_READ_SUBCHANNEL] &= ~(1 << TYPE_DISK);
+	filter->write_ok[GPCMD_READ_SUBCHANNEL] |= (1 << TYPE_DISK);
+
+	/* PLAY AUDIO TI conflicts with SANITIZE.  */
+	filter->read_ok[GPCMD_PLAY_AUDIO_TI] &= ~((1 << TYPE_DISK) | (1 << TYPE_RBC));
+	filter->write_ok[GPCMD_PLAY_AUDIO_TI] |= (1 << TYPE_DISK) | (1 << TYPE_RBC);
+
+	/* READ DISC INFORMATION conflicts with XPWRITE.  */
+	filter->read_ok[GPCMD_READ_DISC_INFO] &= ~(1 << TYPE_DISK);
+	filter->write_ok[GPCMD_READ_DISC_INFO] |= (1 << TYPE_DISK);
+
+	/* GET PERFORMANCE conflicts with ERASE.  */
+	filter->read_ok[GPCMD_GET_PERFORMANCE] &= ~(1 << TYPE_MOD);
+	filter->write_ok[GPCMD_GET_PERFORMANCE] |= (1 << TYPE_MOD);
+
+	/*
+	 * REPORT KEY conflicts with many management commands under operation
+	 * code 0xA4, enable it only for MMC devices.
+	 */
+	filter->read_ok[GPCMD_REPORT_KEY] = (1 << TYPE_ROM);
+	filter->write_ok[GPCMD_REPORT_KEY] = (1 << TYPE_ROM);
 }
 
 int blk_verify_command(struct request_queue *q,
-- 
1.8.1.4

