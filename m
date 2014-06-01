Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbaFAS7W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 14:59:22 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:61033 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134AbaFAS7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 14:59:21 -0400
From: Yann Droneaud <ydroneaud@opteya.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Yann Droneaud <ydroneaud@opteya.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCHv7 6/6] file: remove macro get_unused_fd()
Date: Sun,  1 Jun 2014 16:00:48 +0200
Message-Id: <f5c8d0d7f243a67f1ecd1978dd45d57b1b81d07a.1401630396.git.ydroneaud@opteya.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1401630396.git.ydroneaud@opteya.com>
References: <cover.1401630396.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1401630396.git.ydroneaud@opteya.com>
References: <cover.1401630396.git.ydroneaud@opteya.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Macro get_unused_fd() allocates a file descriptor without enabling
close-on-exec: it calls function get_unused_fd_flags() without
O_CLOEXEC flag.

This can be seen as an unsafe default: in most case close-on-exec
should be enabled to not leak file descriptor across exec().

This patch removes get_unused_fd() instead of updating it to use
O_CLOEXEC so that out of tree modules won't be affect by a runtime
behavor change which might introduce other kind of bug. It's better
to catch the change at build time, making it easier to fix.

Removing the macro will also promote use of get_unused_fd_flags()
(or anon_inode_getfd()) with flags provided by userspace. Or, if
flags cannot be given by userspace, with flags set to O_CLOEXEC set
by default.

Link: http://lkml.kernel.org/r/cover.1401630396.git.ydroneaud@opteya.com
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 include/linux/file.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/file.h b/include/linux/file.h
index 4d69123377a2..f87d30882a24 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -66,7 +66,6 @@ extern void set_close_on_exec(unsigned int fd, int flag);
 extern bool get_close_on_exec(unsigned int fd);
 extern void put_filp(struct file *);
 extern int get_unused_fd_flags(unsigned flags);
-#define get_unused_fd() get_unused_fd_flags(0)
 extern void put_unused_fd(unsigned int fd);
 
 extern void fd_install(unsigned int fd, struct file *file);
-- 
1.9.3

