Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab3J3Tuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 15:50:46 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:56957 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881Ab3J3Tuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 15:50:44 -0400
From: Yann Droneaud <ydroneaud@opteya.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Yann Droneaud <ydroneaud@opteya.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/7] file: use get_unused_fd_flags(0) instead of get_unused_fd()
Date: Wed, 30 Oct 2013 20:47:44 +0100
Message-Id: <3120dfc4b59637efad2eb6e2778f3b4d92914f36.1383121137.git.ydroneaud@opteya.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1383121137.git.ydroneaud@opteya.com>
References: <cover.1383121137.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1383121137.git.ydroneaud@opteya.com>
References: <cover.1383121137.git.ydroneaud@opteya.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Macro get_unused_fd() is used to allocate a file descriptor with
default flags. Those default flags (0) can be "unsafe":
O_CLOEXEC must be used by default to not leak file descriptor
across exec().

Instead of macro get_unused_fd(), functions anon_inode_getfd()
or get_unused_fd_flags() should be used with flags given by userspace.
If not possible, flags should be set to O_CLOEXEC to provide userspace
with a default safe behavor.

In a further patch, get_unused_fd() will be removed so that
new code start using anon_inode_getfd() or get_unused_fd_flags()
with correct flags.

This patch replaces calls to get_unused_fd() with equivalent call to
get_unused_fd_flags(0) to preserve current behavor for existing code.

The hard coded flag value (0) should be reviewed on a per-subsystem basis,
and, if possible, set to O_CLOEXEC.

Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
Link: http://lkml.kernel.org/r/cover.1383121137.git.ydroneaud@opteya.com
---
 fs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/file.c b/fs/file.c
index 4a78f98..1420d28 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -897,7 +897,7 @@ SYSCALL_DEFINE1(dup, unsigned int, fildes)
 	struct file *file = fget_raw(fildes);
 
 	if (file) {
-		ret = get_unused_fd();
+		ret = get_unused_fd_flags(0);
 		if (ret >= 0)
 			fd_install(ret, file);
 		else
-- 
1.8.3.1

