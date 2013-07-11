Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab3GKWUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:20:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43321 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189Ab3GKWUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:20:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Salwan <jonathan.salwan@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [ 2/8] drivers/cdrom/cdrom.c: use kzalloc() for failing hardware
Date: Thu, 11 Jul 2013 15:20:31 -0700
Message-Id: <20130711221931.522752920@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130711221931.216612791@linuxfoundation.org>
References: <20130711221931.216612791@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Jonathan Salwan <jonathan.salwan@gmail.com>
Cc: Luis Henriques <luis.henriques@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cdrom/cdrom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2879,7 +2879,7 @@ static noinline int mmc_ioctl_cdrom_read
 	if (lba < 0)
 		return -EINVAL;
 
-	cgc->buffer = kmalloc(blocksize, GFP_KERNEL);
+	cgc->buffer = kzalloc(blocksize, GFP_KERNEL);
 	if (cgc->buffer == NULL)
 		return -ENOMEM;
 


