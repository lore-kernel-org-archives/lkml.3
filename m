Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330AbaJPJIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:08:21 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:57857 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbaJPJIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:08:18 -0400
Message-Id: <63799031ab6a617b3d435e240de54fafef1ba66d.1413223900.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1413223900.git.ydroneaud@opteya.com>
References: <cover.1413223900.git.ydroneaud@opteya.com>
From: Yann Droneaud <ydroneaud@opteya.com>
To: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 21 Mar 2013 00:23:53 +0100
Subject: [PATCHv9 5/5] file: remove get_unused_fd() macro
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Macro get_unused_fd() is used to allocate a file descriptor
with default flags. Those default flags (0) don't enable
close-on-exec.

This can be seen as an unsafe default: in most case close-on-exec
should be enabled to not leak file descriptor across exec().

It would be better to have a "safer" default set of flags, eg.
O_CLOEXEC must be used to enable close-on-exec.

Instead this patch removes get_unused_fd() so that out of tree
modules won't be affect by a runtime behavor change which might
introduce other kind of bugs: it's better to catch the change at
build time, making it easier to fix.

Removing the macro will also promote use of get_unused_fd_flags()
(or anon_inode_getfd()) with flags provided by userspace. Or, if
flags cannot be given by userspace, with flags set to O_CLOEXEC
by default.

Link: http://lkml.kernel.org/r/cover.1413223900.git.ydroneaud@opteya.com
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

