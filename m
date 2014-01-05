Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaAEUkJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 15:40:09 -0500
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:59518 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbaAEUkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 15:40:07 -0500
From: Yann Droneaud <ydroneaud@opteya.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Yann Droneaud <ydroneaud@opteya.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCHv5 7/7] file: remove macro get_unused_fd()
Date: Sun,  5 Jan 2014 21:36:34 +0100
Message-Id: <3716c4782ba81be22ad0cff437a00a64305f3f26.1388952061.git.ydroneaud@opteya.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <cover.1388952061.git.ydroneaud@opteya.com>
References: <cover.1388952061.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1388952061.git.ydroneaud@opteya.com>
References: <cover.1388952061.git.ydroneaud@opteya.com>
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

Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
Link: http://lkml.kernel.org/r/cover.1388952061.git.ydroneaud@opteya.com
---
 include/linux/file.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/file.h b/include/linux/file.h
index cbacf4faf447..866600259c07 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -63,7 +63,6 @@ extern void set_close_on_exec(unsigned int fd, int flag);
 extern bool get_close_on_exec(unsigned int fd);
 extern void put_filp(struct file *);
 extern int get_unused_fd_flags(unsigned flags);
-#define get_unused_fd() get_unused_fd_flags(0)
 extern void put_unused_fd(unsigned int fd);
 
 extern void fd_install(unsigned int fd, struct file *file);
-- 
1.8.4.2

