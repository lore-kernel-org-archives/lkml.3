Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030453Ab3DSMwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 08:52:36 -0400
Received: from mail.neotion.com ([91.121.222.125]:55933 "EHLO mail.neotion.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968367Ab3DSMwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 08:52:34 -0400
Message-ID: <51713C4B.7010609@neotion.com>
Date: Fri, 19 Apr 2013 14:44:59 +0200
From: Neil Armstrong <narmstrong@neotion.com>
Reply-To: narmstrong@neotion.com
Organization: Neotion
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-mmc@vger.kernel.org
CC: Chris Ball <cjb@laptop.org>, Namjae Jeon <linkinjeon@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] Add boot_enable sysfs attribute to select MMC boot operation
 partition
X-Enigmail-Version: 1.5.1
OpenPGP: id=1166F485
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sysfs attribute to select the eMMC boot mode operation according to
the eMMC 4.5 specifications.
Valid values are : 0 for disabled, 1 for first boot partition, 2 for
second boot partition, 7 for user area.

Signed-off-by: Neil Armstrong <narmstrong@neotion.com>
---
 drivers/mmc/card/block.c |   72
+++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 71 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 5bab73b..e11c42e 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -114,6 +114,7 @@ struct mmc_blk_data {
      */
     unsigned int    part_curr;
     struct device_attribute force_ro;
+    struct device_attribute boot_enable;
     struct device_attribute power_ro_lock;
     int    area_type;
 };
@@ -264,6 +265,23 @@ static ssize_t force_ro_show(struct device *dev,
struct device_attribute *attr,
     return ret;
 }
 
+static ssize_t boot_enable_show(struct device *dev,
+                 struct device_attribute *attr, char *buf)
+{
+    int ret;
+    struct mmc_card *card;
+    struct mmc_blk_data *md = mmc_blk_get(dev_to_disk(dev));
+
+    md = mmc_blk_get(dev_to_disk(dev));
+    card = md->queue.card;
+
+    ret = snprintf(buf, PAGE_SIZE, "%d",
+                (card->ext_csd.part_config &
+                 EXT_CSD_PART_CONFIG_EN_MASK) >> 3);
+    mmc_blk_put(md);
+    return ret;
+}
+
 static ssize_t force_ro_store(struct device *dev, struct
device_attribute *attr,
                   const char *buf, size_t count)
 {
@@ -283,6 +301,48 @@ out:
     return ret;
 }
 
+static ssize_t boot_enable_store(struct device *dev,
+                  struct device_attribute *attr, const char *buf,
+                  size_t count)
+{
+    int ret;
+    char *end;
+    u8 part_config;
+    struct mmc_card *card;
+    struct mmc_blk_data *md = mmc_blk_get(dev_to_disk(dev));
+    unsigned long set = simple_strtoul(buf, &end, 0);
+    if (end == buf) {
+        ret = -EINVAL;
+        goto out;
+    }
+
+    md = mmc_blk_get(dev_to_disk(dev));
+    card = md->queue.card;
+
+    part_config = card->ext_csd.part_config;
+
+    part_config &= EXT_CSD_PART_CONFIG_EN_MASK;
+    part_config |= (set << 3) & EXT_CSD_PART_CONFIG_EN_MASK;
+
+    mmc_claim_host(card->host);
+
+    ret = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
+                 EXT_CSD_PART_CONFIG, part_config,
+                 card->ext_csd.part_time);
+
+    mmc_release_host(card->host);
+
+    if (ret)
+        return ret;
+
+    card->ext_csd.part_config = part_config;
+
+    ret = count;
+out:
+    mmc_blk_put(md);
+    return ret;
+}
+
 static int mmc_blk_open(struct block_device *bdev, fmode_t mode)
 {
     struct mmc_blk_data *md = mmc_blk_get(bdev->bd_disk);
@@ -2202,6 +2262,15 @@ static int mmc_add_disk(struct mmc_blk_data *md)
     if (ret)
         goto force_ro_fail;
 
+    md->boot_enable.show = boot_enable_show;
+    md->boot_enable.store = boot_enable_store;
+    sysfs_attr_init(&md->boot_enable.attr);
+    md->boot_enable.attr.name = "boot_enable";
+    md->boot_enable.attr.mode = S_IRUGO | S_IWUSR;
+    ret = device_create_file(disk_to_dev(md->disk), &md->boot_enable);
+    if (ret)
+        goto boot_enable_fail;
+
     if ((md->area_type & MMC_BLK_DATA_AREA_BOOT) &&
          card->ext_csd.boot_ro_lockable) {
         umode_t mode;
@@ -2225,6 +2294,8 @@ static int mmc_add_disk(struct mmc_blk_data *md)
     return ret;
 
 power_ro_lock_fail:
+    device_remove_file(disk_to_dev(md->disk), &md->boot_enable);
+boot_enable_fail:
     device_remove_file(disk_to_dev(md->disk), &md->force_ro);
 force_ro_fail:
     del_gendisk(md->disk);
@@ -2434,4 +2505,3 @@ module_exit(mmc_blk_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Multimedia Card (MMC) block device driver");
-
-- 
1.7.0.4

