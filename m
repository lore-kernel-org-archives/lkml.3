Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbbAORhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 12:37:50 -0500
Received: from smtpout.karoo.kcom.com ([212.50.160.34]:19956 "EHLO
	smtpout.karoo.kcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbbAORht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 12:37:49 -0500
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Jan 2015 12:37:49 EST
X-IronPort-AV: E=Sophos;i="5.09,404,1418083200"; 
   d="scan'208";a="33680406"
Date: Thu, 15 Jan 2015 17:31:32 +0000
From: Mike Crowe <mac@mcrowe.com>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Kay Sievers <kay@vrfy.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: kmsg: lseek errors confuse glibc's dprintf
Message-ID: <20150115173132.GA7486@mcrowe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

glibc's dprintf implementation does not work correctly with /dev/kmsg file
descriptors because glibc treats receiving EBADF and EINVAL from lseek when
trying to determine the current file position as errors. See
https://sourceware.org/bugzilla/show_bug.cgi?id=17830

>From what I can tell prior to Kay Sievers printk record commit
e11fea92e13fb91c50bacca799a6131c81929986, calling lseek(fd, 0, SEEK_CUR)
with such a file descriptor would not return an error.

Prior to Kay's change, Arnd Bergmann's commit
6038f373a3dc1f1c26496e60b6c40b164716f07e seemed to go to some lengths to
preserve the successful return code rather than returning (the perhaps more
logical) -ESPIPE.

glibc is happy with either a successful return or -ESPIPE.

For maximum compatibility it seems that success should be returned but
given Kay's new seek interface perhaps this isn't helpful.

This patch ensures that such a seek succeeds:

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 02d6b6d..b3ff6f0 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -693,7 +693,7 @@ static loff_t devkmsg_llseek(struct file *file, loff_t offset, int whence)
 	loff_t ret = 0;
 
 	if (!user)
-		return -EBADF;
+		return (whence == SEEK_CUR) ? 0 : -EBADF;
 	if (offset)
 		return -ESPIPE;
 
@@ -718,6 +718,11 @@ static loff_t devkmsg_llseek(struct file *file, loff_t offset, int whence)
 		user->idx = log_next_idx;
 		user->seq = log_next_seq;
 		break;
+	case SEEK_CUR:
+		/* For compatibility with userspace requesting the
+		 * current file position. */
+		ret = 0;
+		break;
 	default:
 		ret = -EINVAL;
 	}

(although it could be argued that the !user case should return -ESPIPE
rather than EBADF since the file descriptor _is_ valid.)

and this patch causes a failure that glibc is prepared to accept:

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 02d6b6d..f6b0c93 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -693,7 +693,7 @@ static loff_t devkmsg_llseek(struct file *file, loff_t offset, int whence)
 	loff_t ret = 0;
 
 	if (!user)
-		return -EBADF;
+		return -ESPIPE;
 	if (offset)
 		return -ESPIPE;
 
@@ -718,6 +718,11 @@ static loff_t devkmsg_llseek(struct file *file, loff_t offset, int whence)
 		user->idx = log_next_idx;
 		user->seq = log_next_seq;
 		break;
+	case SEEK_CUR:
+		/* For compatibility with userspace expecting SEEK_CUR
+		 * to not yield EINVAL. */
+		ret = -ESPIPE;
+		break;
 	default:
 		ret = -EINVAL;
 	}

Either makes dprintf work, but is either the right solution?

Thanks.

Mike.
