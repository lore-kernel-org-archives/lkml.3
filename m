Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbaA1Iuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 03:50:39 -0500
Received: from ns.omicron.at ([212.183.10.25]:41926 "EHLO ns.omicron.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684AbaA1Iuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 03:50:37 -0500
From: Christian Riesch <christian.riesch@omicron.at>
To: <linux-mtd@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>,
        Christian Riesch <christian.riesch@omicron.at>,
        Artem Bityutskiy <Artem.Bityutskiy@linux.intel.com>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH v2 RESEND 1/2] mtd: Add a retlen parameter to _get_{fact,user}_prot_info
Date: Tue, 28 Jan 2014 09:29:44 +0100
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390897785-991-1-git-send-email-christian.riesch@omicron.at>
References: <1390897785-991-1-git-send-email-christian.riesch@omicron.at>
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <db5db0eb-2c50-4642-ab11-5c406356bdeb@mary.at.omicron.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christian Riesch <christian.riesch@omicron.at>
Cc: Artem Bityutskiy <Artem.Bityutskiy@linux.intel.com>
Cc: Brian Norris <computersforpeace@gmail.com>
---
 drivers/mtd/chips/cfi_cmdset_0001.c |   31 +++++++++++++------------------
 drivers/mtd/devices/mtd_dataflash.c |    7 ++++---
 drivers/mtd/mtdchar.c               |   11 ++++++-----
 drivers/mtd/mtdcore.c               |   12 ++++++------
 drivers/mtd/mtdpart.c               |   14 ++++++++------
 drivers/mtd/onenand/onenand_base.c  |   30 ++++++++++++------------------
 include/linux/mtd/mtd.h             |   16 ++++++++--------
 7 files changed, 57 insertions(+), 64 deletions(-)

diff --git a/drivers/mtd/chips/cfi_cmdset_0001.c b/drivers/mtd/chips/cfi_cmdset_0001.c
index 7751443..7aa581f 100644
--- a/drivers/mtd/chips/cfi_cmdset_0001.c
+++ b/drivers/mtd/chips/cfi_cmdset_0001.c
@@ -69,10 +69,10 @@ static int cfi_intelext_read_fact_prot_reg (struct mtd_info *, loff_t, size_t, s
 static int cfi_intelext_read_user_prot_reg (struct mtd_info *, loff_t, size_t, size_t *, u_char *);
 static int cfi_intelext_write_user_prot_reg (struct mtd_info *, loff_t, size_t, size_t *, u_char *);
 static int cfi_intelext_lock_user_prot_reg (struct mtd_info *, loff_t, size_t);
-static int cfi_intelext_get_fact_prot_info (struct mtd_info *,
-					    struct otp_info *, size_t);
-static int cfi_intelext_get_user_prot_info (struct mtd_info *,
-					    struct otp_info *, size_t);
+static int cfi_intelext_get_fact_prot_info(struct mtd_info *, size_t,
+					   size_t *, struct otp_info *);
+static int cfi_intelext_get_user_prot_info(struct mtd_info *, size_t,
+					   size_t *, struct otp_info *);
 #endif
 static int cfi_intelext_suspend (struct mtd_info *);
 static void cfi_intelext_resume (struct mtd_info *);
@@ -2399,24 +2399,19 @@ static int cfi_intelext_lock_user_prot_reg(struct mtd_info *mtd,
 				     NULL, do_otp_lock, 1);
 }
 
-static int cfi_intelext_get_fact_prot_info(struct mtd_info *mtd,
-					   struct otp_info *buf, size_t len)
-{
-	size_t retlen;
-	int ret;
+static int cfi_intelext_get_fact_prot_info(struct mtd_info *mtd, size_t len,
+					   size_t *retlen, struct otp_info *buf)
 
-	ret = cfi_intelext_otp_walk(mtd, 0, len, &retlen, (u_char *)buf, NULL, 0);
-	return ret ? : retlen;
+{
+	return cfi_intelext_otp_walk(mtd, 0, len, retlen, (u_char *)buf,
+				     NULL, 0);
 }
 
-static int cfi_intelext_get_user_prot_info(struct mtd_info *mtd,
-					   struct otp_info *buf, size_t len)
+static int cfi_intelext_get_user_prot_info(struct mtd_info *mtd, size_t len,
+					   size_t *retlen, struct otp_info *buf)
 {
-	size_t retlen;
-	int ret;
-
-	ret = cfi_intelext_otp_walk(mtd, 0, len, &retlen, (u_char *)buf, NULL, 1);
-	return ret ? : retlen;
+	return cfi_intelext_otp_walk(mtd, 0, len, retlen, (u_char *)buf,
+				     NULL, 1);
 }
 
 #endif
diff --git a/drivers/mtd/devices/mtd_dataflash.c b/drivers/mtd/devices/mtd_dataflash.c
index 28779b6..09c69ce 100644
--- a/drivers/mtd/devices/mtd_dataflash.c
+++ b/drivers/mtd/devices/mtd_dataflash.c
@@ -442,8 +442,8 @@ static int dataflash_write(struct mtd_info *mtd, loff_t to, size_t len,
 
 #ifdef CONFIG_MTD_DATAFLASH_OTP
 
-static int dataflash_get_otp_info(struct mtd_info *mtd,
-		struct otp_info *info, size_t len)
+static int dataflash_get_otp_info(struct mtd_info *mtd, size_t len,
+				  size_t *retlen, struct otp_info *info)
 {
 	/* Report both blocks as identical:  bytes 0..64, locked.
 	 * Unless the user block changed from all-ones, we can't
@@ -452,7 +452,8 @@ static int dataflash_get_otp_info(struct mtd_info *mtd,
 	info->start = 0;
 	info->length = 64;
 	info->locked = 1;
-	return sizeof(*info);
+	*retlen = sizeof(*info);
+	return 0;
 }
 
 static ssize_t otp_read(struct spi_device *spi, unsigned base,
diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 684bfa3..0edb0ca 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -888,25 +888,26 @@ static int mtdchar_ioctl(struct file *file, u_int cmd, u_long arg)
 	case OTPGETREGIONINFO:
 	{
 		struct otp_info *buf = kmalloc(4096, GFP_KERNEL);
+		size_t retlen;
 		if (!buf)
 			return -ENOMEM;
 		switch (mfi->mode) {
 		case MTD_FILE_MODE_OTP_FACTORY:
-			ret = mtd_get_fact_prot_info(mtd, buf, 4096);
+			ret = mtd_get_fact_prot_info(mtd, 4096, &retlen, buf);
 			break;
 		case MTD_FILE_MODE_OTP_USER:
-			ret = mtd_get_user_prot_info(mtd, buf, 4096);
+			ret = mtd_get_user_prot_info(mtd, 4096, &retlen, buf);
 			break;
 		default:
 			ret = -EINVAL;
 			break;
 		}
-		if (ret >= 0) {
+		if (!ret) {
 			if (cmd == OTPGETREGIONCOUNT) {
-				int nbr = ret / sizeof(struct otp_info);
+				int nbr = retlen / sizeof(struct otp_info);
 				ret = copy_to_user(argp, &nbr, sizeof(int));
 			} else
-				ret = copy_to_user(argp, buf, ret);
+				ret = copy_to_user(argp, buf, retlen);
 			if (ret)
 				ret = -EFAULT;
 		}
diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 048c823..d0c3d41 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -877,14 +877,14 @@ EXPORT_SYMBOL_GPL(mtd_read_oob);
  * devices. The user data is one time programmable but the factory data is read
  * only.
  */
-int mtd_get_fact_prot_info(struct mtd_info *mtd, struct otp_info *buf,
-			   size_t len)
+int mtd_get_fact_prot_info(struct mtd_info *mtd, size_t len, size_t *retlen,
+			   struct otp_info *buf)
 {
 	if (!mtd->_get_fact_prot_info)
 		return -EOPNOTSUPP;
 	if (!len)
 		return 0;
-	return mtd->_get_fact_prot_info(mtd, buf, len);
+	return mtd->_get_fact_prot_info(mtd, len, retlen, buf);
 }
 EXPORT_SYMBOL_GPL(mtd_get_fact_prot_info);
 
@@ -900,14 +900,14 @@ int mtd_read_fact_prot_reg(struct mtd_info *mtd, loff_t from, size_t len,
 }
 EXPORT_SYMBOL_GPL(mtd_read_fact_prot_reg);
 
-int mtd_get_user_prot_info(struct mtd_info *mtd, struct otp_info *buf,
-			   size_t len)
+int mtd_get_user_prot_info(struct mtd_info *mtd, size_t len, size_t *retlen,
+			   struct otp_info *buf)
 {
 	if (!mtd->_get_user_prot_info)
 		return -EOPNOTSUPP;
 	if (!len)
 		return 0;
-	return mtd->_get_user_prot_info(mtd, buf, len);
+	return mtd->_get_user_prot_info(mtd, len, retlen, buf);
 }
 EXPORT_SYMBOL_GPL(mtd_get_user_prot_info);
 
diff --git a/drivers/mtd/mtdpart.c b/drivers/mtd/mtdpart.c
index 3014933..57d8cf7 100644
--- a/drivers/mtd/mtdpart.c
+++ b/drivers/mtd/mtdpart.c
@@ -150,11 +150,12 @@ static int part_read_user_prot_reg(struct mtd_info *mtd, loff_t from,
 						 retlen, buf);
 }
 
-static int part_get_user_prot_info(struct mtd_info *mtd,
-		struct otp_info *buf, size_t len)
+static int part_get_user_prot_info(struct mtd_info *mtd, size_t len,
+				   size_t *retlen, struct otp_info *buf)
 {
 	struct mtd_part *part = PART(mtd);
-	return part->master->_get_user_prot_info(part->master, buf, len);
+	return part->master->_get_user_prot_info(part->master, len, retlen,
+						 buf);
 }
 
 static int part_read_fact_prot_reg(struct mtd_info *mtd, loff_t from,
@@ -165,11 +166,12 @@ static int part_read_fact_prot_reg(struct mtd_info *mtd, loff_t from,
 						 retlen, buf);
 }
 
-static int part_get_fact_prot_info(struct mtd_info *mtd, struct otp_info *buf,
-		size_t len)
+static int part_get_fact_prot_info(struct mtd_info *mtd, size_t len,
+				   size_t *retlen, struct otp_info *buf)
 {
 	struct mtd_part *part = PART(mtd);
-	return part->master->_get_fact_prot_info(part->master, buf, len);
+	return part->master->_get_fact_prot_info(part->master, len, retlen,
+						 buf);
 }
 
 static int part_write(struct mtd_info *mtd, loff_t to, size_t len,
diff --git a/drivers/mtd/onenand/onenand_base.c b/drivers/mtd/onenand/onenand_base.c
index b3f41f2..419c538 100644
--- a/drivers/mtd/onenand/onenand_base.c
+++ b/drivers/mtd/onenand/onenand_base.c
@@ -3242,20 +3242,17 @@ static int onenand_otp_walk(struct mtd_info *mtd, loff_t from, size_t len,
 /**
  * onenand_get_fact_prot_info - [MTD Interface] Read factory OTP info
  * @param mtd		MTD device structure
- * @param buf		the databuffer to put/get data
  * @param len		number of bytes to read
+ * @param retlen	pointer to variable to store the number of read bytes
+ * @param buf		the databuffer to put/get data
  *
  * Read factory OTP info.
  */
-static int onenand_get_fact_prot_info(struct mtd_info *mtd,
-			struct otp_info *buf, size_t len)
+static int onenand_get_fact_prot_info(struct mtd_info *mtd, size_t len,
+				      size_t *retlen, struct otp_info *buf)
 {
-	size_t retlen;
-	int ret;
-
-	ret = onenand_otp_walk(mtd, 0, len, &retlen, (u_char *) buf, NULL, MTD_OTP_FACTORY);
-
-	return ret ? : retlen;
+	return onenand_otp_walk(mtd, 0, len, retlen, (u_char *) buf, NULL,
+				MTD_OTP_FACTORY);
 }
 
 /**
@@ -3277,20 +3274,17 @@ static int onenand_read_fact_prot_reg(struct mtd_info *mtd, loff_t from,
 /**
  * onenand_get_user_prot_info - [MTD Interface] Read user OTP info
  * @param mtd		MTD device structure
- * @param buf		the databuffer to put/get data
+ * @param retlen	pointer to variable to store the number of read bytes
  * @param len		number of bytes to read
+ * @param buf		the databuffer to put/get data
  *
  * Read user OTP info.
  */
-static int onenand_get_user_prot_info(struct mtd_info *mtd,
-			struct otp_info *buf, size_t len)
+static int onenand_get_user_prot_info(struct mtd_info *mtd, size_t len,
+				      size_t *retlen, struct otp_info *buf)
 {
-	size_t retlen;
-	int ret;
-
-	ret = onenand_otp_walk(mtd, 0, len, &retlen, (u_char *) buf, NULL, MTD_OTP_USER);
-
-	return ret ? : retlen;
+	return onenand_otp_walk(mtd, 0, len, retlen, (u_char *) buf, NULL,
+				MTD_OTP_USER);
 }
 
 /**
diff --git a/include/linux/mtd/mtd.h b/include/linux/mtd/mtd.h
index a5cf4e8..af35068 100644
--- a/include/linux/mtd/mtd.h
+++ b/include/linux/mtd/mtd.h
@@ -204,12 +204,12 @@ struct mtd_info {
 			  struct mtd_oob_ops *ops);
 	int (*_write_oob) (struct mtd_info *mtd, loff_t to,
 			   struct mtd_oob_ops *ops);
-	int (*_get_fact_prot_info) (struct mtd_info *mtd, struct otp_info *buf,
-				    size_t len);
+	int (*_get_fact_prot_info) (struct mtd_info *mtd, size_t len,
+				    size_t *retlen, struct otp_info *buf);
 	int (*_read_fact_prot_reg) (struct mtd_info *mtd, loff_t from,
 				    size_t len, size_t *retlen, u_char *buf);
-	int (*_get_user_prot_info) (struct mtd_info *mtd, struct otp_info *buf,
-				    size_t len);
+	int (*_get_user_prot_info) (struct mtd_info *mtd, size_t len,
+				    size_t *retlen, struct otp_info *buf);
 	int (*_read_user_prot_reg) (struct mtd_info *mtd, loff_t from,
 				    size_t len, size_t *retlen, u_char *buf);
 	int (*_write_user_prot_reg) (struct mtd_info *mtd, loff_t to,
@@ -278,12 +278,12 @@ static inline int mtd_write_oob(struct mtd_info *mtd, loff_t to,
 	return mtd->_write_oob(mtd, to, ops);
 }
 
-int mtd_get_fact_prot_info(struct mtd_info *mtd, struct otp_info *buf,
-			   size_t len);
+int mtd_get_fact_prot_info(struct mtd_info *mtd, size_t len, size_t *retlen,
+			   struct otp_info *buf);
 int mtd_read_fact_prot_reg(struct mtd_info *mtd, loff_t from, size_t len,
 			   size_t *retlen, u_char *buf);
-int mtd_get_user_prot_info(struct mtd_info *mtd, struct otp_info *buf,
-			   size_t len);
+int mtd_get_user_prot_info(struct mtd_info *mtd, size_t len, size_t *retlen,
+			   struct otp_info *buf);
 int mtd_read_user_prot_reg(struct mtd_info *mtd, loff_t from, size_t len,
 			   size_t *retlen, u_char *buf);
 int mtd_write_user_prot_reg(struct mtd_info *mtd, loff_t to, size_t len,
-- 
1.7.9.5

