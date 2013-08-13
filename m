Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046Ab3HMQ1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:27:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33381 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758136Ab3HMQ1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:27:00 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=0AC-v-DXK1QA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=OpnfZr6NaHgA:10 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=Z4Rwk6OoAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=MSl-tDqOz04A:10 a=7DSvI1NPTFQA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155832.166886525@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [54/88] drivers/cdrom/cdrom.c: use kzalloc() for failing hardware
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0054-drivers-cdrom-cdrom.c-use-kzalloc-for-failing-hardwa.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jonathan Salwan <jonathan.salwan@gmail.com>

[ Upstream commit 542db01579fbb7ea7d1f7bb9ddcef1559df660b2 ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/cdrom/cdrom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index d620b44..8a3aff7 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2882,7 +2882,7 @@ static noinline int mmc_ioctl_cdrom_read_data(struct cdrom_device_info *cdi,
 	if (lba < 0)
 		return -EINVAL;
 
-	cgc->buffer = kmalloc(blocksize, GFP_KERNEL);
+	cgc->buffer = kzalloc(blocksize, GFP_KERNEL);
 	if (cgc->buffer == NULL)
 		return -ENOMEM;
 
-- 
1.7.10.4


