Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbaCKK2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:28:49 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:36846 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754431AbaCKK2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:28:11 -0400
From: Yann Droneaud <ydroneaud@opteya.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Yann Droneaud <ydroneaud@opteya.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCHv6 6/6] file: remove macro get_unused_fd()
Date: Tue, 11 Mar 2014 11:23:45 +0100
Message-Id: <1aac909bfb462d4e770c58e8bcfb4bb5cce8bfc8.1394532336.git.ydroneaud@opteya.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <cover.1394532336.git.ydroneaud@opteya.com>
References: <cover.1394532336.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1394532336.git.ydroneaud@opteya.com>
References: <cover.1394532336.git.ydroneaud@opteya.com>
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

Link: http://lkml.kernel.org/r/cover.1394532336.git.ydroneaud@opteya.com
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
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
1.8.5.3

