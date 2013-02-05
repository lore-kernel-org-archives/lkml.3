Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab3BEHMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 02:12:37 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:47398 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab3BEHMe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 02:12:34 -0500
MIME-Version: 1.0
In-Reply-To: <CAKYAXd8Qo44D8sNo8+r21fmV2ZQinSbqk8WmNiip+vgh9Wo6ow@mail.gmail.com>
References: <1359988901-7384-1-git-send-email-linkinjeon@gmail.com>
	<CAKYAXd8QsGzz0FHUNZfBt7kskPQprVrTQcuag75oxx09_R22Ow@mail.gmail.com>
	<1360046719.26950.26.camel@kjgkr>
	<CAKYAXd8Qo44D8sNo8+r21fmV2ZQinSbqk8WmNiip+vgh9Wo6ow@mail.gmail.com>
Date: Tue, 5 Feb 2013 16:12:34 +0900
Message-ID: <CAKYAXd9NqhRs1PO01K4Y8LM4=nAuFNQ-bBs93mKwpa_59e+xdg@mail.gmail.com>
Subject: Re: [PATCH] f2fs: add compat_ioctl to provide backward compatability
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/5, Namjae Jeon <linkinjeon@gmail.com>:
> 2013/2/5, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
>> Hi,
>>
>> 2013-02-05 (화), 14:28 +0900, Namjae Jeon:
>>> Hi Jaegeuk.
>>>
>>> Oops!, I was missing include header.
>>> Sorry, I will send v2 patch again.
>>
>> I got a build error, and simply added the following header file in your
>> patch.
>>
>> #include <linux/compat.h>
>>
>> Is it correct?
> Yes, Right :) It should be needed.
> Sorry for my mistake again. Could you add this header instead of me
> ?(because I can resend the patch tonight....).
>
> Thanks!
>>
>> Thanks,
>>
Hi Jaegeuk.
I tried to paste the patch in mail.
Could you take below patch instead of previous patch ?

Thanks.


--------------------------------------------------------------------------------------------------------
Subject: [PATCH] f2fs: add compat_ioctl to provide backward compatibility
From: Namjae Jeon <namjae.jeon@samsung.com>

adding compat_ioctl to provide support for backward comptability - 32bit binary
execution on 64bit kernel.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/f2fs.h |   15 +++++++++++++++
 fs/f2fs/file.c |   21 +++++++++++++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 5022a7d..e980dd5 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -104,6 +104,20 @@ static inline int update_sits_in_cursum(struct
f2fs_summary_block *rs, int i)
 }

 /*
+ * ioctl commands
+ */
+#define F2FS_IOC_GETFLAGS               FS_IOC_GETFLAGS
+#define F2FS_IOC_SETFLAGS               FS_IOC_SETFLAGS
+
+#if defined(__KERNEL__) && defined(CONFIG_COMPAT)
+/*
+ * ioctl commands in 32 bit emulation
+ */
+#define F2FS_IOC32_GETFLAGS             FS_IOC32_GETFLAGS
+#define F2FS_IOC32_SETFLAGS             FS_IOC32_SETFLAGS
+#endif
+
+/*
  * For INODE and NODE manager
  */
 #define XATTR_NODE_OFFSET	(-1)	/*
@@ -842,6 +856,7 @@ void f2fs_truncate(struct inode *);
 int f2fs_setattr(struct dentry *, struct iattr *);
 int truncate_hole(struct inode *, pgoff_t, pgoff_t);
 long f2fs_ioctl(struct file *, unsigned int, unsigned long);
+long f2fs_compat_ioctl(struct file *, unsigned int, unsigned long);

 /*
  * inode.c
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 33d1736..de3e533 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -17,6 +17,7 @@
 #include <linux/types.h>
 #include <linux/uaccess.h>
 #include <linux/mount.h>
+#include <linux/compat.h>

 #include "f2fs.h"
 #include "node.h"
@@ -634,6 +635,23 @@ out:
 	}
 }

+#ifdef CONFIG_COMPAT
+long f2fs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	switch (cmd) {
+	case F2FS_IOC32_GETFLAGS:
+		cmd = F2FS_IOC_GETFLAGS;
+		break;
+	case F2FS_IOC32_SETFLAGS:
+		cmd = F2FS_IOC_SETFLAGS;
+		break;
+	default:
+		return -ENOIOCTLCMD;
+	}
+	return f2fs_ioctl(file, cmd, (unsigned long) compat_ptr(arg));
+}
+#endif
+
 const struct file_operations f2fs_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
@@ -645,6 +663,9 @@ const struct file_operations f2fs_file_operations = {
 	.fsync		= f2fs_sync_file,
 	.fallocate	= f2fs_fallocate,
 	.unlocked_ioctl	= f2fs_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl   = f2fs_compat_ioctl,
+#endif
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= generic_file_splice_write,
 };
-- 
1.7.2.3
