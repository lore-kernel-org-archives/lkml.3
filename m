Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784AbbAJOaA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 09:30:00 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbbAJO36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 09:29:58 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/2] UBI: Add initial support for scatter gather
Date: Sat, 10 Jan 2015 15:29:47 +0100
Message-Id: <1420900188-15781-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a new set of functions to deal with scatter gather.
ubi_eba_read_leb_sg() will read from a LEB into a scatter gather list.
The new data structure struct ubi_sgl will be used within UBI to
hold the scatter gather list itself and metadata to have a cursor
within the list.

Signed-off-by: Richard Weinberger <richard@nod.at>
Tested-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
---
 drivers/mtd/ubi/eba.c   | 56 +++++++++++++++++++++++++++++
 drivers/mtd/ubi/kapi.c  | 95 +++++++++++++++++++++++++++++++++++++++++--------
 drivers/mtd/ubi/ubi.h   |  3 ++
 include/linux/mtd/ubi.h | 33 +++++++++++++++++
 4 files changed, 172 insertions(+), 15 deletions(-)

diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
index b698534..0aaf707 100644
--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -481,6 +481,62 @@ out_unlock:
 }
 
 /**
+ * ubi_eba_read_leb_sg - read data into a scatter gather list.
+ * @ubi: UBI device description object
+ * @vol: volume description object
+ * @lnum: logical eraseblock number
+ * @sgl: UBI scatter gather list to store the read data
+ * @offset: offset from where to read
+ * @len: how many bytes to read
+ * @check: data CRC check flag
+ *
+ * This function works exactly like ubi_eba_read_leb(). But instead of
+ * storing the read data into a buffer it writes to an UBI scatter gather
+ * list.
+ */
+int ubi_eba_read_leb_sg(struct ubi_device *ubi, struct ubi_volume *vol,
+			struct ubi_sgl *sgl, int lnum, int offset, int len,
+			int check)
+{
+	int to_read;
+	int ret;
+	struct scatterlist *sg;
+
+	for (;;) {
+		ubi_assert(sgl->list_pos < UBI_MAX_SG_COUNT);
+		sg = &sgl->sg[sgl->list_pos];
+		if (len < sg->length - sgl->page_pos)
+			to_read = len;
+		else
+			to_read = sg->length - sgl->page_pos;
+
+		ret = ubi_eba_read_leb(ubi, vol, lnum,
+				       sg_virt(sg) + sgl->page_pos, offset,
+				       to_read, check);
+		if (ret < 0)
+			goto out;
+
+		offset += to_read;
+		len -= to_read;
+		if (!len) {
+			sgl->page_pos += to_read;
+			if (sgl->page_pos == sg->length) {
+				sgl->list_pos++;
+				sgl->page_pos = 0;
+			}
+
+			break;
+		}
+
+		sgl->list_pos++;
+		sgl->page_pos = 0;
+	}
+
+out:
+	return ret;
+}
+
+/**
  * recover_peb - recover from write failure.
  * @ubi: UBI device description object
  * @pnum: the physical eraseblock to recover
diff --git a/drivers/mtd/ubi/kapi.c b/drivers/mtd/ubi/kapi.c
index f3bab66..d0055a2 100644
--- a/drivers/mtd/ubi/kapi.c
+++ b/drivers/mtd/ubi/kapi.c
@@ -355,6 +355,43 @@ void ubi_close_volume(struct ubi_volume_desc *desc)
 EXPORT_SYMBOL_GPL(ubi_close_volume);
 
 /**
+ * leb_read_sanity_check - does sanity checks on read requests.
+ * @desc: volume descriptor
+ * @lnum: logical eraseblock number to read from
+ * @offset: offset within the logical eraseblock to read from
+ * @len: how many bytes to read
+ *
+ * This function is used by ubi_leb_read() and ubi_leb_read_sg()
+ * to perfrom sanity checks.
+ */
+static int leb_read_sanity_check(struct ubi_volume_desc *desc, int lnum,
+				 int offset, int len)
+{
+	struct ubi_volume *vol = desc->vol;
+	struct ubi_device *ubi = vol->ubi;
+	int vol_id = vol->vol_id;
+
+	if (vol_id < 0 || vol_id >= ubi->vtbl_slots || lnum < 0 ||
+	    lnum >= vol->used_ebs || offset < 0 || len < 0 ||
+	    offset + len > vol->usable_leb_size)
+		return -EINVAL;
+
+	if (vol->vol_type == UBI_STATIC_VOLUME) {
+		if (vol->used_ebs == 0)
+			/* Empty static UBI volume */
+			return 0;
+		if (lnum == vol->used_ebs - 1 &&
+		    offset + len > vol->last_eb_bytes)
+			return -EINVAL;
+	}
+
+	if (vol->upd_marker)
+		return -EBADF;
+
+	return 0;
+}
+
+/**
  * ubi_leb_read - read data.
  * @desc: volume descriptor
  * @lnum: logical eraseblock number to read from
@@ -390,22 +427,10 @@ int ubi_leb_read(struct ubi_volume_desc *desc, int lnum, char *buf, int offset,
 
 	dbg_gen("read %d bytes from LEB %d:%d:%d", len, vol_id, lnum, offset);
 
-	if (vol_id < 0 || vol_id >= ubi->vtbl_slots || lnum < 0 ||
-	    lnum >= vol->used_ebs || offset < 0 || len < 0 ||
-	    offset + len > vol->usable_leb_size)
-		return -EINVAL;
-
-	if (vol->vol_type == UBI_STATIC_VOLUME) {
-		if (vol->used_ebs == 0)
-			/* Empty static UBI volume */
-			return 0;
-		if (lnum == vol->used_ebs - 1 &&
-		    offset + len > vol->last_eb_bytes)
-			return -EINVAL;
-	}
+	err = leb_read_sanity_check(desc, lnum, offset, len);
+	if (err < 0)
+		return err;
 
-	if (vol->upd_marker)
-		return -EBADF;
 	if (len == 0)
 		return 0;
 
@@ -419,6 +444,46 @@ int ubi_leb_read(struct ubi_volume_desc *desc, int lnum, char *buf, int offset,
 }
 EXPORT_SYMBOL_GPL(ubi_leb_read);
 
+
+/**
+ * ubi_leb_read_sg - read data into a scatter gather list.
+ * @desc: volume descriptor
+ * @lnum: logical eraseblock number to read from
+ * @buf: buffer where to store the read data
+ * @offset: offset within the logical eraseblock to read from
+ * @len: how many bytes to read
+ * @check: whether UBI has to check the read data's CRC or not.
+ *
+ * This function works exactly like ubi_leb_read_sg(). But instead of
+ * storing the read data into a buffer it writes to an UBI scatter gather
+ * list.
+ */
+int ubi_leb_read_sg(struct ubi_volume_desc *desc, int lnum, struct ubi_sgl *sgl,
+		    int offset, int len, int check)
+{
+	struct ubi_volume *vol = desc->vol;
+	struct ubi_device *ubi = vol->ubi;
+	int err, vol_id = vol->vol_id;
+
+	dbg_gen("read %d bytes from LEB %d:%d:%d", len, vol_id, lnum, offset);
+
+	err = leb_read_sanity_check(desc, lnum, offset, len);
+	if (err < 0)
+		return err;
+
+	if (len == 0)
+		return 0;
+
+	err = ubi_eba_read_leb_sg(ubi, vol, sgl, lnum, offset, len, check);
+	if (err && mtd_is_eccerr(err) && vol->vol_type == UBI_STATIC_VOLUME) {
+		ubi_warn(ubi, "mark volume %d as corrupted", vol_id);
+		vol->corrupted = 1;
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(ubi_leb_read_sg);
+
 /**
  * ubi_leb_write - write data.
  * @desc: volume descriptor
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index ee7ac0b..a5283cf 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -791,6 +791,9 @@ int ubi_eba_unmap_leb(struct ubi_device *ubi, struct ubi_volume *vol,
 		      int lnum);
 int ubi_eba_read_leb(struct ubi_device *ubi, struct ubi_volume *vol, int lnum,
 		     void *buf, int offset, int len, int check);
+int ubi_eba_read_leb_sg(struct ubi_device *ubi, struct ubi_volume *vol,
+			struct ubi_sgl *sgl, int lnum, int offset, int len,
+			int check);
 int ubi_eba_write_leb(struct ubi_device *ubi, struct ubi_volume *vol, int lnum,
 		      const void *buf, int offset, int len);
 int ubi_eba_write_leb_st(struct ubi_device *ubi, struct ubi_volume *vol,
diff --git a/include/linux/mtd/ubi.h b/include/linux/mtd/ubi.h
index c3918a0..406c7cd 100644
--- a/include/linux/mtd/ubi.h
+++ b/include/linux/mtd/ubi.h
@@ -23,11 +23,16 @@
 
 #include <linux/ioctl.h>
 #include <linux/types.h>
+#include <linux/scatterlist.h>
 #include <mtd/ubi-user.h>
 
 /* All voumes/LEBs */
 #define UBI_ALL -1
 
+/* Maximum number of scatter gather list entries,
+ * we use only 64 to have a lower memory foot print. */
+#define UBI_MAX_SG_COUNT 64
+
 /*
  * enum ubi_open_mode - UBI volume open mode constants.
  *
@@ -116,6 +121,22 @@ struct ubi_volume_info {
 };
 
 /**
+ * struct ubi_sgl - UBI scatter gather list data structure.
+ * @list_pos: current position in @sg[]
+ * @page_pos: current position in @sg[@list_pos]
+ * @sg: the scatter gather list itself
+ *
+ * ubi_sgl is a wrapper around a scatter list which keeps track of the
+ * current position in the list and the current list item such that
+ * it can be used across multiple ubi_leb_read_sg() calls.
+ */
+struct ubi_sgl {
+	int list_pos;
+	int page_pos;
+	struct scatterlist sg[UBI_MAX_SG_COUNT];
+};
+
+/**
  * struct ubi_device_info - UBI device description data structure.
  * @ubi_num: ubi device number
  * @leb_size: logical eraseblock size on this UBI device
@@ -210,6 +231,8 @@ int ubi_unregister_volume_notifier(struct notifier_block *nb);
 void ubi_close_volume(struct ubi_volume_desc *desc);
 int ubi_leb_read(struct ubi_volume_desc *desc, int lnum, char *buf, int offset,
 		 int len, int check);
+int ubi_leb_read_sg(struct ubi_volume_desc *desc, int lnum, struct ubi_sgl *sgl,
+		   int offset, int len, int check);
 int ubi_leb_write(struct ubi_volume_desc *desc, int lnum, const void *buf,
 		  int offset, int len);
 int ubi_leb_change(struct ubi_volume_desc *desc, int lnum, const void *buf,
@@ -230,4 +253,14 @@ static inline int ubi_read(struct ubi_volume_desc *desc, int lnum, char *buf,
 {
 	return ubi_leb_read(desc, lnum, buf, offset, len, 0);
 }
+
+/*
+ * This function is the same as the 'ubi_leb_read_sg()' function, but it does
+ * not provide the checking capability.
+ */
+static inline int ubi_read_sg(struct ubi_volume_desc *desc, int lnum,
+			      struct ubi_sgl *sgl, int offset, int len)
+{
+	return ubi_leb_read_sg(desc, lnum, sgl, offset, len, 0);
+}
 #endif /* !__LINUX_UBI_H__ */
-- 
1.8.4.5

