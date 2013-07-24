Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab3GXOOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:14:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45862 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752380Ab3GXOGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:51 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Jens Axboe" <axboe@kernel.dk>,
        "Jonathan Salwan" <jonathan.salwan@gmail.com>,
        "Dan Carpenter" <dan.carpenter@oracle.com>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.119657787@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [81/85] drivers/cdrom/cdrom.c: use kzalloc() for failing hardware
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Salwan <jonathan.salwan@gmail.com>

commit 542db01579fbb7ea7d1f7bb9ddcef1559df660b2 upstream.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/cdrom/cdrom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2885,7 +2885,7 @@ static noinline int mmc_ioctl_cdrom_read
 	if (lba < 0)
 		return -EINVAL;
 
-	cgc->buffer = kmalloc(blocksize, GFP_KERNEL);
+	cgc->buffer = kzalloc(blocksize, GFP_KERNEL);
 	if (cgc->buffer == NULL)
 		return -ENOMEM;
 

