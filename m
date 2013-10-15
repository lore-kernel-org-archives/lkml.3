Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060Ab3JOD0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 23:26:09 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:44121 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820Ab3JOD0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 23:26:07 -0400
Date: Tue, 15 Oct 2013 11:26:00 +0800
From: majianpeng <majianpeng@gmail.com>
To: viro <viro@zeniv.linux.org.uk>
Cc: jbacik <jbacik@fusionio.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: [PATCH] inode: For readonly filesystem, func file_update_time should return -EROFS rather than zero.
X-Priority: 3
X-GUID: CDB112EE-D599-42A8-83E1-C5FF5B058F0B
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.93[cn]
Mime-Version: 1.0
Message-ID: <201310151125581359520@gmail.com>
Content-Type: text/plain;
	charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9F3QVou020772

For ext2 mounted with errors=remount-ro, if write a file and because the
harddisk error, the fs became ro.But the following test can't return.

int main()
{
	int ret;
	int i = 0;
	char buff[SIZE];
	int fd = open("/opt/test", O_WRONLY|O_TRUNC|O_CREAT);

	if (fd < 0) {
		printf("open error %s\n", strerror(errno));
		return errno;
	}

	ret = write(fd, buff, SIZE);
	lseek(fd, 0, 0);

	while (1) {
		ret = write(fd, buff, SIZE);
		if (ret < 0) {
			printf("write error %s\n", strerror(errno));
			break;
		}
		lseek(fd, 0, 0);
		i++;
	}
	printf("write count=%d\n", i);
	close(fd);

	return 0;
}

For ext3/ext4, because jbd the test can return. But for ext2, because no
jbd and not reading bitmap from harddisk, the test continue.

So we should add check readonly-fs on write-path. Func file_update_time
already check the readonly flag,but it can't return -EROFS.
For readonly-fs, it can't update a/c/m time of file,it should return
-EROFS rather than zero.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 fs/inode.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index b33ba8e..65302c1 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1644,8 +1644,9 @@ int file_update_time(struct file *file)
 		return 0;
 
 	/* Finally allowed to write? Takes lock. */
-	if (__mnt_want_write_file(file))
-		return 0;
+	ret = __mnt_want_write_file(file);
+	if (ret)
+		return ret;
 
 	ret = update_time(inode, &now, sync_it);
 	__mnt_drop_write_file(file);
-- 
1.8.4
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
