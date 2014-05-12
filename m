Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbaELB7x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:59:53 -0400
Received: from 1wt.eu ([62.212.114.60]:34636 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753428AbaELBmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:42:49 -0400
Message-Id: <20140512003201.094335349@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:11 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 011/143] drivers/cdrom/cdrom.c: use kzalloc() for failing hardware
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Salwan <jonathan.salwan@gmail.com>

commit 542db01579fbb7ea7d1f7bb9ddcef1559df660b2 upstream

In drivers/cdrom/cdrom.c mmc_ioctl_cdrom_read_data() allocates a memory
area with kmalloc in line 2885.

  2885         cgc->buffer = kmalloc(blocksize, GFP_KERNEL);
  2886         if (cgc->buffer == NULL)
  2887                 return -ENOMEM;

In line 2908 we can find the copy_to_user function:

  2908         if (!ret && copy_to_user(arg, cgc->buffer, blocksize))

The cgc->buffer is never cleaned and initialized before this function.
If ret = 0 with the previous basic block, it's possible to display some
memory bytes in kernel space from userspace.

When we read a block from the disk it normally fills the ->buffer but if
the drive is malfunctioning there is a chance that it would only be
partially filled.  The result is an leak information to userspace.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/cdrom/cdrom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index a4592ec..71a78dc 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2822,7 +2822,7 @@ static noinline int mmc_ioctl_cdrom_read_data(struct cdrom_device_info *cdi,
 	if (lba < 0)
 		return -EINVAL;
 
-	cgc->buffer = kmalloc(blocksize, GFP_KERNEL);
+	cgc->buffer = kzalloc(blocksize, GFP_KERNEL);
 	if (cgc->buffer == NULL)
 		return -ENOMEM;
 
-- 
1.7.12.2.21.g234cd45.dirty



