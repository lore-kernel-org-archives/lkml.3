Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbaA1IgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 03:36:09 -0500
Received: from ns.omicron.at ([212.183.10.25]:41269 "EHLO ns.omicron.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbaA1IgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 03:36:07 -0500
X-Greylist: delayed 316 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Jan 2014 03:36:06 EST
From: Christian Riesch <christian.riesch@omicron.at>
To: <linux-mtd@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>,
        Christian Riesch <christian.riesch@omicron.at>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Amul Kumar Saha <amul.saha@samsung.com>
Subject: [PATCH v2 RESEND 2/2] mtd: Fix the behavior of otp write if there is not enough room for data
Date: Tue, 28 Jan 2014 09:29:45 +0100
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390897785-991-1-git-send-email-christian.riesch@omicron.at>
References: <1390897785-991-1-git-send-email-christian.riesch@omicron.at>
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <b8fb0b78-04b2-41bf-a1f4-6f54039b7829@mary.at.omicron.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An OTP write shall write as much data as possible to the OTP memory
and return the number of bytes that have actually been written.
If no data could be written at all due to lack of OTP memory,
return -ENOSPC.

Signed-off-by: Christian Riesch <christian.riesch@omicron.at>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Amul Kumar Saha <amul.saha@samsung.com>
---
 drivers/mtd/chips/cfi_cmdset_0001.c |   13 +++++++++++--
 drivers/mtd/devices/mtd_dataflash.c |   13 +++++--------
 drivers/mtd/mtdchar.c               |    7 +++++++
 drivers/mtd/onenand/onenand_base.c  |   10 +++++++++-
 4 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/drivers/mtd/chips/cfi_cmdset_0001.c b/drivers/mtd/chips/cfi_cmdset_0001.c
index 7aa581f..cf423a6 100644
--- a/drivers/mtd/chips/cfi_cmdset_0001.c
+++ b/drivers/mtd/chips/cfi_cmdset_0001.c
@@ -2387,8 +2387,17 @@ static int cfi_intelext_write_user_prot_reg(struct mtd_info *mtd, loff_t from,
 					    size_t len, size_t *retlen,
 					     u_char *buf)
 {
-	return cfi_intelext_otp_walk(mtd, from, len, retlen,
-				     buf, do_otp_write, 1);
+	int ret;
+
+	ret = cfi_intelext_otp_walk(mtd, from, len, retlen,
+				    buf, do_otp_write, 1);
+
+	/* if no data could be written due to lack of OTP memory,
+	   return ENOSPC */
+	if (!ret && len && !(*retlen))
+		return -ENOSPC;
+
+	return ret;
 }
 
 static int cfi_intelext_lock_user_prot_reg(struct mtd_info *mtd,
diff --git a/drivers/mtd/devices/mtd_dataflash.c b/drivers/mtd/devices/mtd_dataflash.c
index 09c69ce..5236d85 100644
--- a/drivers/mtd/devices/mtd_dataflash.c
+++ b/drivers/mtd/devices/mtd_dataflash.c
@@ -545,14 +545,11 @@ static int dataflash_write_user_otp(struct mtd_info *mtd,
 	struct dataflash	*priv = mtd->priv;
 	int			status;
 
-	if (len > 64)
-		return -EINVAL;
-
-	/* Strictly speaking, we *could* truncate the write ... but
-	 * let's not do that for the only write that's ever possible.
-	 */
-	if ((from + len) > 64)
-		return -EINVAL;
+	if ((from + len) > 64) {
+		len = 64 - from;
+		if (len <= 0)
+			return -ENOSPC;
+	}
 
 	/* OUT: OP_WRITE_SECURITY, 3 zeroes, 64 data-or-zero bytes
 	 * IN:  ignore all
diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 0edb0ca..db99031 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -323,6 +323,13 @@ static ssize_t mtdchar_write(struct file *file, const char __user *buf, size_t c
 		default:
 			ret = mtd_write(mtd, *ppos, len, &retlen, kbuf);
 		}
+		/* return -ENOSPC only if no data was written */
+		if ((ret == -ENOSPC) && (total_retlen)) {
+			ret = 0;
+			retlen = 0;
+			/* drop the remaining data */
+			count = 0;
+		}
 		if (!ret) {
 			*ppos += retlen;
 			total_retlen += retlen;
diff --git a/drivers/mtd/onenand/onenand_base.c b/drivers/mtd/onenand/onenand_base.c
index 419c538..6c49a6f 100644
--- a/drivers/mtd/onenand/onenand_base.c
+++ b/drivers/mtd/onenand/onenand_base.c
@@ -3316,7 +3316,15 @@ static int onenand_read_user_prot_reg(struct mtd_info *mtd, loff_t from,
 static int onenand_write_user_prot_reg(struct mtd_info *mtd, loff_t from,
 			size_t len, size_t *retlen, u_char *buf)
 {
-	return onenand_otp_walk(mtd, from, len, retlen, buf, do_otp_write, MTD_OTP_USER);
+	int ret;
+	ret = onenand_otp_walk(mtd, from, len, retlen, buf, do_otp_write, MTD_OTP_USER);
+
+	/* if no data could be written due to lack of OTP memory,
+	   return ENOSPC */
+	if (!ret && len && !(*retlen))
+		return -ENOSPC;
+
+	return ret;
 }
 
 /**
-- 
1.7.9.5

