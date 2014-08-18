Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaHRItQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:49:16 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:53159 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaHRItO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:49:14 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] brd: add ram disk visibility option
In-Reply-To: <53F0F84B.3080806@fb.com>
References: <1408204530-16726-1-git-send-email-dmonakhov@openvz.org> <53F0F84B.3080806@fb.com>
User-Agent: Notmuch/0.6.1 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Mon, 18 Aug 2014 12:49:08 +0400
Message-ID: <8738curxmj.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

On Sun, 17 Aug 2014 12:45:31 -0600, Jens Axboe <axboe@fb.com> wrote:
> On 2014-08-16 09:55, Dmitry Monakhov wrote:
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> 
> You forgot a commit message justifying this change?
I've assumed that one line comment is enough :(
Please take a look at the patch with updated commit message.


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline;
 filename=0001-brd-add-ram-disk-visibility-option.patch

>From cbb15356494fa2fb96114a152f64e962b599575c Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Mon, 18 Aug 2014 12:45:42 +0400
Subject: [PATCH] brd: add ram disk visibility option

Currenly ram disk is not visiable inside /proc/partitions. This was
done for compatibility reasons here: 53978d0a7a27. But some utilities
expect disk presents in /proc/partitions.
Let's add module's option and let's administrator chose visibility behaviour.
By default, old behaviour preserved.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 drivers/block/brd.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index c7d138e..3598110 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -442,12 +442,15 @@ static int rd_nr;
 int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
 static int max_part;
 static int part_shift;
+static int part_show = 0;
 module_param(rd_nr, int, S_IRUGO);
 MODULE_PARM_DESC(rd_nr, "Maximum number of brd devices");
 module_param(rd_size, int, S_IRUGO);
 MODULE_PARM_DESC(rd_size, "Size of each RAM disk in kbytes.");
 module_param(max_part, int, S_IRUGO);
 MODULE_PARM_DESC(max_part, "Maximum number of partitions per RAM disk");
+module_param(part_show, int, S_IRUGO);
+MODULE_PARM_DESC(part_show, "Control RAM disk visibility in /proc/partitions");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(RAMDISK_MAJOR);
 MODULE_ALIAS("rd");
@@ -501,7 +504,8 @@ static struct brd_device *brd_alloc(int i)
 	disk->fops		= &brd_fops;
 	disk->private_data	= brd;
 	disk->queue		= brd->brd_queue;
-	disk->flags |= GENHD_FL_SUPPRESS_PARTITION_INFO;
+	if (!part_show)
+		disk->flags |= GENHD_FL_SUPPRESS_PARTITION_INFO;
 	sprintf(disk->disk_name, "ram%d", i);
 	set_capacity(disk, rd_size * 2);
 
-- 
1.7.1


--=-=-=--
