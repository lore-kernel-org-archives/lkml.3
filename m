Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369AbaJIRm0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 13:42:26 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:60423 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaJIRmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 13:42:18 -0400
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
To: <linux-kernel@vger.kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH RESEND] fs: sysfs: return EFBIG on write if offset is larger than binary file size
Date: Thu, 9 Oct 2014 20:41:55 +0300
Message-ID: <1412876515-12057-1-git-send-email-vladimir_zapolskiy@mentor.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.202.0.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the user expectations common utilities like dd or sh
redirection operator '>' should work correctly over binary files from
sysfs. At the moment doing excessive write can not be ever completed
(no error is returned), e.g. for 4-byte file:

  write(1, "\0\0\0\0\0\0\0\0", 8)         = 4
  write(1, "\0\0\0\0", 4)                 = 0
  write(1, "\0\0\0\0", 4)                 = 0
  write(1, "\0\0\0\0", 4)                 = 0
  write(1, "\0\0\0\0", 4)                 = 0
  write(1, "\0\0\0\0", 4)                 = 0
  .......

This is not a successful completion of write(2), so fix the problem by
returning EFBIG as described in POSIX.1-2001:

  [EFBIG]
    The file is a regular file, nbyte is greater than 0, and the
    starting position is greater than or equal to the offset maximum
    established in the open file description associated with fildes.

Note, the write(2) ABI is changed, however
1) write(2) behaviour is corrected in conformance to POSIX, the
   existing userspace applications must be aware of possible errors on
   a syscall,
2) the return value is changed on error path, so it is an exceptional
   situation,
3) the change is related only to binary sysfs files, which is a very
   small class of files, mainly representing non-volatile registers or
   ram, eeproms etc, many of such files are read-only.

Presumably it is safe to apply the change, the described problem is
definitely in the kernel and userspace utilities can not be changed to
process 0 return value as an error, because it is just not an error
according to POSIX.

Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index e9ef59b..589abee 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -125,7 +125,7 @@ static ssize_t sysfs_kf_bin_write(struct kernfs_open_file *of, char *buf,
 
 	if (size) {
 		if (size <= pos)
-			return 0;
+			return -EFBIG;
 		count = min_t(ssize_t, count, size - pos);
 	}
 	if (!count)
-- 
1.7.10.4

