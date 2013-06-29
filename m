Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab3F2JLo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 05:11:44 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:61836 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab3F2JLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 05:11:41 -0400
From: Jiaxing Wang <hello.wjx@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: Jiaxing Wang <hello.wjx@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH] seq_file:update file->f_pos when lseek() to m->read_pos
Date: Sat, 29 Jun 2013 17:11:35 +0800
Message-Id: <1372497096-15914-1-git-send-email-hello.wjx@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After pread(), file->f_pos and m->read_pos get different,
and lseek() to m->read_pos did not update file->f_pos, then
a subsequent read may read from a wrong position, the following
program shows the problem:

    char str1[32] = { 0 };
    char str2[32] = { 0 };
    int poffset = 10;
    int count = 20;

    /*open any seq file*/
    int fd = open("/proc/modules", O_RDONLY);

    pread(fd, str1, count, poffset);
    printf("pread:%s\n", str1);

    /*seek to where m->read_pos is*/
    lseek(fd, poffset+count, SEEK_SET);

    /*supposed to read from poffset+count, but this read from position 0*/
    read(fd, str2, count);
    printf("read:%s\n", str2);

Signed-off-by: Jiaxing Wang <hello.wjx@gmail.com>
---
 fs/seq_file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index 774c1eb..4b22b26 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -328,7 +328,8 @@ loff_t seq_lseek(struct file *file, loff_t offset, int whence)
 				m->read_pos = offset;
 				retval = file->f_pos = offset;
 			}
-		}
+		} else
+			file->f_pos = offset;
 	}
 	file->f_version = m->version;
 	mutex_unlock(&m->lock);
-- 
1.8.1.2

