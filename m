Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab3GOJSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 05:18:45 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:54466 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754434Ab3GOJSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 05:18:43 -0400
Message-ID: <1373879920.2591.13.camel@x61.thuisdomein>
Subject: [PATCH] [SCSI] scsi_debug: silence GCC warning
From: Paul Bolle <pebolle@tiscali.nl>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 15 Jul 2013 11:18:40 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 15 Jul 2013 09:18:40.0894 (UTC) FILETIME=[4BBBC1E0:01CE813C]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building scsi_debug.o triggers a GCC warning:
    drivers/scsi/scsi_debug.c: In function ‘dif_verify’:
    drivers/scsi/scsi_debug.c:1755:3: warning: ‘csum’ may be used uninitialized in this function [-Wmaybe-uninitialized]

This is a false positive, but if we make scsi_debug_guard a bool, we
supply GCC with enough information to determine that csum will not be
used uninitialized. It also allows for a minor cleanup.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Compile tested only.

1) This warning is apparently introduced in v3.11-rc1 by commit beb40ea42b
("[SCSI] scsi_debug: reduce duplication between prot_verify_read and
prot_verify_write")

 drivers/scsi/scsi_debug.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index cb4fefa..98e6436 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -169,7 +169,7 @@ static int scsi_debug_dix = DEF_DIX;
 static int scsi_debug_dsense = DEF_D_SENSE;
 static int scsi_debug_every_nth = DEF_EVERY_NTH;
 static int scsi_debug_fake_rw = DEF_FAKE_RW;
-static int scsi_debug_guard = DEF_GUARD;
+static bool scsi_debug_guard = DEF_GUARD;
 static int scsi_debug_lowest_aligned = DEF_LOWEST_ALIGNED;
 static int scsi_debug_max_luns = DEF_MAX_LUNS;
 static int scsi_debug_max_queue = SCSI_DEBUG_CANQUEUE;
@@ -1736,10 +1736,10 @@ static u16 dif_compute_csum(const void *buf, int len)
 	u16 csum;
 
 	switch (scsi_debug_guard) {
-	case 1:
+	case true:
 		csum = ip_compute_csum(buf, len);
 		break;
-	case 0:
+	case false:
 		csum = cpu_to_be16(crc_t10dif(buf, len));
 		break;
 	}
@@ -2736,7 +2736,7 @@ module_param_named(dix, scsi_debug_dix, int, S_IRUGO);
 module_param_named(dsense, scsi_debug_dsense, int, S_IRUGO | S_IWUSR);
 module_param_named(every_nth, scsi_debug_every_nth, int, S_IRUGO | S_IWUSR);
 module_param_named(fake_rw, scsi_debug_fake_rw, int, S_IRUGO | S_IWUSR);
-module_param_named(guard, scsi_debug_guard, int, S_IRUGO);
+module_param_named(guard, scsi_debug_guard, bool, S_IRUGO);
 module_param_named(lbpu, scsi_debug_lbpu, int, S_IRUGO);
 module_param_named(lbpws, scsi_debug_lbpws, int, S_IRUGO);
 module_param_named(lbpws10, scsi_debug_lbpws10, int, S_IRUGO);
@@ -3312,11 +3312,6 @@ static int __init scsi_debug_init(void)
 		return -EINVAL;
 	}
 
-	if (scsi_debug_guard > 1) {
-		printk(KERN_ERR "scsi_debug_init: guard must be 0 or 1\n");
-		return -EINVAL;
-	}
-
 	if (scsi_debug_ato > 1) {
 		printk(KERN_ERR "scsi_debug_init: ato must be 0 or 1\n");
 		return -EINVAL;
@@ -4028,7 +4023,7 @@ static int sdebug_driver_probe(struct device * dev)
 	       (host_prot & SHOST_DIX_TYPE2_PROTECTION) ? " DIX2" : "",
 	       (host_prot & SHOST_DIX_TYPE3_PROTECTION) ? " DIX3" : "");
 
-	if (scsi_debug_guard == 1)
+	if (scsi_debug_guard == true)
 		scsi_host_set_guard(hpnt, SHOST_DIX_GUARD_IP);
 	else
 		scsi_host_set_guard(hpnt, SHOST_DIX_GUARD_CRC);
-- 
1.8.1.4

