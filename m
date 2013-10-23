Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab3JWNpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 09:45:18 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35111 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab3JWNpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 09:45:16 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@karo-electronics.de>,
        Ming Lei <ming.lei@canonical.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH next] sysfs: fix sysfs_write_file for bin file
Date: Wed, 23 Oct 2013 21:44:53 +0800
Message-Id: <1382535893-20543-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before patch(sysfs: prepare path write for unified regular / bin
file handling), when size of bin file is zero, writting still can
continue, but this patch changes the behaviour.

The worse thing is that firmware loader is broken by this patch,
and user space application can't write to firmware bin file any more
because both firmware loader and drivers can't know at advance how
large the firmware file is and have to set its initialized size as
zero.

This patch fixes the problem and keeps behaviour of writting to bin
as before.

Reported-and-tested-by: Lothar Waßmann <LW@karo-electronics.de>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 fs/sysfs/file.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 5d818df..c379597 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -275,11 +275,10 @@ static ssize_t sysfs_write_file(struct file *file, const char __user *user_buf,
 {
 	struct sysfs_open_file *of = sysfs_of(file);
 	ssize_t len = min_t(size_t, count, PAGE_SIZE);
+	loff_t size = file_inode(file)->i_size;
 	char *buf;
 
-	if (sysfs_is_bin(of->sd)) {
-		loff_t size = file_inode(file)->i_size;
-
+	if (sysfs_is_bin(of->sd) && size) {
 		if (size <= *ppos)
 			return 0;
 		len = min_t(ssize_t, len, size - *ppos);
-- 
1.7.9.5

