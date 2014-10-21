Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbaJUH5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 03:57:15 -0400
Received: from mga03.intel.com ([134.134.136.65]:27329 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430AbaJUH5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 03:57:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,760,1406617200"; 
   d="scan'208";a="592945330"
Message-ID: <1413878186.7906.405.camel@sauron.fi.intel.com>
Subject: Re: [PATCH V5] mtd: ubi: Extend UBI layer debug/messaging
 capabilities
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: ezequiel.garcia@free-electrons.com, linux-mtd@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        open list <linux-kernel@vger.kernel.org>
Date: Tue, 21 Oct 2014 10:56:26 +0300
In-Reply-To: <1413824221-31235-1-git-send-email-tlinder@codeaurora.org>
References: <1413824221-31235-1-git-send-email-tlinder@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-20 at 19:57 +0300, Tanya Brokhman wrote:
> If there is more then one UBI device mounted, there is no way to
> distinguish between messages from different UBI devices.
> Add device number to all ubi layer message types.
> 
> The R/O block driver messages were replaced by pr_* since
> ubi_device structure is not used by it.
> 
> Signed-off-by: Tanya Brokhman <tlinder@codeaurora.org>

Pushed to linux-ubifs.git, thanks.

You did not get indentations right, though, so I amended your patch.
Also, some lines were split unnecessarily. My amendments are in the diff
below. Please, take this into account for the similar UBIFS patch which
you was going to send. Thank you!

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index 3da5df1..9d2e16f 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -671,7 +671,7 @@ static int early_erase_peb(struct ubi_device *ubi,
 		 * erase counters internally.
 		 */
 		ubi_err(ubi, "erase counter overflow at PEB %d, EC %d",
-				pnum, ec);
+			pnum, ec);
 		return -EINVAL;
 	}
 
@@ -1637,7 +1637,7 @@ static int self_check_ai(struct ubi_device *ubi, struct ubi_attach_info *ai)
 			err = ubi_io_read_vid_hdr(ubi, aeb->pnum, vidh, 1);
 			if (err && err != UBI_IO_BITFLIPS) {
 				ubi_err(ubi, "VID header is not OK (%d)",
-						err);
+					err);
 				if (err > 0)
 					err = -EIO;
 				return err;
@@ -1691,7 +1691,7 @@ static int self_check_ai(struct ubi_device *ubi, struct ubi_attach_info *ai)
 
 		if (av->last_data_size != be32_to_cpu(vidh->data_size)) {
 			ubi_err(ubi, "bad last_data_size %d",
-					av->last_data_size);
+				av->last_data_size);
 			goto bad_vid_hdr;
 		}
 	}
diff --git a/drivers/mtd/ubi/block.c b/drivers/mtd/ubi/block.c
index 657ff08..6b6bce2 100644
--- a/drivers/mtd/ubi/block.c
+++ b/drivers/mtd/ubi/block.c
@@ -117,7 +117,7 @@ static int __init ubiblock_set_param(const char *val,
 
 	if (len == UBIBLOCK_PARAM_LEN) {
 		pr_err("UBI: block: parameter \"%s\" is too long, max. is %d\n",
-			val, UBIBLOCK_PARAM_LEN);
+		       val, UBIBLOCK_PARAM_LEN);
 		return -EINVAL;
 	}
 
@@ -446,7 +446,7 @@ int ubiblock_create(struct ubi_volume_info *vi)
 	/* Must be the last step: anyone can call file ops from now on */
 	add_disk(dev->gd);
 	dev_info(disk_to_dev(dev->gd), "created from ubi%d:%d(%s)",
-		dev->ubi_num, dev->vol_id, vi->name);
+		 dev->ubi_num, dev->vol_id, vi->name);
 	return 0;
 
 out_free_queue:
@@ -518,7 +518,7 @@ static int ubiblock_resize(struct ubi_volume_info *vi)
 	if ((sector_t)disk_capacity != disk_capacity) {
 		mutex_unlock(&devices_mutex);
 		dev_warn(disk_to_dev(dev->gd), "the volume is too big (%d LEBs), cannot resize",
-			vi->size);
+			 vi->size);
 		return -EFBIG;
 	}
 
@@ -527,7 +527,7 @@ static int ubiblock_resize(struct ubi_volume_info *vi)
 	if (get_capacity(dev->gd) != disk_capacity) {
 		set_capacity(dev->gd, disk_capacity);
 		dev_info(disk_to_dev(dev->gd), "resized to %lld bytes",
-			vi->used_bytes);
+			 vi->used_bytes);
 	}
 	mutex_unlock(&dev->dev_mutex);
 	mutex_unlock(&devices_mutex);
@@ -596,7 +596,7 @@ static int __init ubiblock_create_from_param(void)
 		desc = open_volume_desc(p->name, p->ubi_num, p->vol_id);
 		if (IS_ERR(desc)) {
 			pr_err("UBI: block: can't open volume, err=%ld\n",
-				PTR_ERR(desc));
+			       PTR_ERR(desc));
 			ret = PTR_ERR(desc);
 			break;
 		}
@@ -607,7 +607,7 @@ static int __init ubiblock_create_from_param(void)
 		ret = ubiblock_create(&vi);
 		if (ret) {
 			pr_err("UBI: block: can't add '%s' volume, err=%d\n",
-				vi.name, ret);
+			       vi.name, ret);
 			break;
 		}
 	}
diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 802f29e..3405be4 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -960,8 +960,7 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
 		ubi->fm_disabled = 1;
 	}
 
-	ubi_msg(ubi, "default fastmap pool size: %d",
-		ubi->fm_pool.max_size);
+	ubi_msg(ubi, "default fastmap pool size: %d", ubi->fm_pool.max_size);
 	ubi_msg(ubi, "default fastmap WL pool size: %d",
 		ubi->fm_wl_pool.max_size);
 #else
@@ -1224,7 +1223,7 @@ static int __init ubi_init(void)
 
 	if (mtd_devs > UBI_MAX_DEVICES) {
 		pr_err("UBI error: too many MTD devices, maximum is %d",
-			UBI_MAX_DEVICES);
+		       UBI_MAX_DEVICES);
 		return -EINVAL;
 	}
 
@@ -1272,7 +1271,7 @@ static int __init ubi_init(void)
 		if (IS_ERR(mtd)) {
 			err = PTR_ERR(mtd);
 			pr_err("UBI error: cannot open mtd %s, error %d",
-				 p->name, err);
+			       p->name, err);
 			/* See comment below re-ubi_is_module(). */
 			if (ubi_is_module())
 				goto out_detach;
@@ -1285,7 +1284,7 @@ static int __init ubi_init(void)
 		mutex_unlock(&ubi_devices_mutex);
 		if (err < 0) {
 			pr_err("UBI error: cannot attach mtd%d",
-				mtd->index);
+			       mtd->index);
 			put_mtd_device(mtd);
 
 			/*
@@ -1417,14 +1416,14 @@ static int __init ubi_mtd_param_parse(const char *val, struct kernel_param *kp)
 
 	if (mtd_devs == UBI_MAX_DEVICES) {
 		pr_err("UBI error: too many parameters, max. is %d\n",
-			UBI_MAX_DEVICES);
+		       UBI_MAX_DEVICES);
 		return -EINVAL;
 	}
 
 	len = strnlen(val, MTD_PARAM_LEN_MAX);
 	if (len == MTD_PARAM_LEN_MAX) {
 		pr_err("UBI error: parameter \"%s\" is too long, max. is %d\n",
-			val, MTD_PARAM_LEN_MAX);
+		       val, MTD_PARAM_LEN_MAX);
 		return -EINVAL;
 	}
 
@@ -1443,8 +1442,7 @@ static int __init ubi_mtd_param_parse(const char *val, struct kernel_param *kp)
 		tokens[i] = strsep(&pbuf, ",");
 
 	if (pbuf) {
-		pr_err("UBI error: too many arguments at \"%s\"\n",
-			val);
+		pr_err("UBI error: too many arguments at \"%s\"\n", val);
 		return -EINVAL;
 	}
 
@@ -1465,7 +1463,7 @@ static int __init ubi_mtd_param_parse(const char *val, struct kernel_param *kp)
 
 		if (err) {
 			pr_err("UBI error: bad value for max_beb_per1024 parameter: %s",
-				token);
+			       token);
 			return -EINVAL;
 		}
 	}
@@ -1476,7 +1474,7 @@ static int __init ubi_mtd_param_parse(const char *val, struct kernel_param *kp)
 
 		if (err) {
 			pr_err("UBI error: bad value for ubi_num parameter: %s",
-				token);
+			       token);
 			return -EINVAL;
 		}
 	} else
diff --git a/drivers/mtd/ubi/cdev.c b/drivers/mtd/ubi/cdev.c
index 722d57c..3410ea81 100644
--- a/drivers/mtd/ubi/cdev.c
+++ b/drivers/mtd/ubi/cdev.c
@@ -738,7 +738,7 @@ static int rename_volumes(struct ubi_device *ubi,
 		if (IS_ERR(re->desc)) {
 			err = PTR_ERR(re->desc);
 			ubi_err(ubi, "cannot open volume %d, error %d",
-					vol_id, err);
+				vol_id, err);
 			kfree(re);
 			goto out_free;
 		}
diff --git a/drivers/mtd/ubi/debug.c b/drivers/mtd/ubi/debug.c
index 737ae0f..7335c9f 100644
--- a/drivers/mtd/ubi/debug.c
+++ b/drivers/mtd/ubi/debug.c
@@ -239,7 +239,7 @@ int ubi_debugfs_init(void)
 		int err = dfs_rootdir ? -ENODEV : PTR_ERR(dfs_rootdir);
 
 		pr_err("UBI error: cannot create \"ubi\" debugfs directory, error %d\n",
-			err);
+		       err);
 		return err;
 	}
 
diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
index 97b3dc2..a40020c 100644
--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -614,8 +614,7 @@ int ubi_eba_write_leb(struct ubi_device *ubi, struct ubi_volume *vol, int lnum,
 
 		err = ubi_io_write_data(ubi, buf, pnum, offset, len);
 		if (err) {
-			ubi_warn(ubi, "failed to write data to PEB %d",
-					pnum);
+			ubi_warn(ubi, "failed to write data to PEB %d", pnum);
 			if (err == -EIO && ubi->bad_allowed)
 				err = recover_peb(ubi, pnum, vol_id, lnum, buf,
 						  offset, len);
diff --git a/drivers/mtd/ubi/io.c b/drivers/mtd/ubi/io.c
index 4d972d3..396aaa5 100644
--- a/drivers/mtd/ubi/io.c
+++ b/drivers/mtd/ubi/io.c
@@ -376,7 +376,7 @@ retry:
 	if (ei.state == MTD_ERASE_FAILED) {
 		if (retries++ < UBI_IO_RETRIES) {
 			ubi_warn(ubi, "error while erasing PEB %d, retry",
-				pnum);
+				 pnum);
 			yield();
 			goto retry;
 		}
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 77970b5..f80ffab 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -51,13 +51,13 @@
 
 /* Normal UBI messages */
 #define ubi_msg(ubi, fmt, ...) pr_notice("UBI-%d: %s:" fmt "\n", \
-				 ubi->ubi_num, __func__, ##__VA_ARGS__)
+					 ubi->ubi_num, __func__, ##__VA_ARGS__)
 /* UBI warning messages */
-#define ubi_warn(ubi, fmt, ...) pr_warn("UBI-%d warning: %s: " fmt "\n",  \
-				   ubi->ubi_num, __func__, ##__VA_ARGS__)
+#define ubi_warn(ubi, fmt, ...) pr_warn("UBI-%d warning: %s: " fmt "\n", \
+					ubi->ubi_num, __func__, ##__VA_ARGS__)
 /* UBI error messages */
-#define ubi_err(ubi, fmt, ...) pr_err("UBI-%d error: %s: " fmt "\n",      \
-				 ubi->ubi_num, __func__, ##__VA_ARGS__)
+#define ubi_err(ubi, fmt, ...) pr_err("UBI-%d error: %s: " fmt "\n", \
+				      ubi->ubi_num, __func__, ##__VA_ARGS__)
 
 /* Background thread name pattern */
 #define UBI_BGT_NAME_PATTERN "ubi_bgt%dd"
diff --git a/drivers/mtd/ubi/vtbl.c b/drivers/mtd/ubi/vtbl.c
index fd43b3b..1931dff 100644
--- a/drivers/mtd/ubi/vtbl.c
+++ b/drivers/mtd/ubi/vtbl.c
@@ -755,8 +755,7 @@ static int check_attaching_info(const struct ubi_device *ubi,
 			 * reboot while the volume was being removed. Discard
 			 * these eraseblocks.
 			 */
-			ubi_msg(ubi, "finish volume %d removal",
-				av->vol_id);
+			ubi_msg(ubi, "finish volume %d removal", av->vol_id);
 			ubi_remove_av(ai, av);
 		} else if (av) {
 			err = check_av(ubi, vol, av);


--
Artem.

