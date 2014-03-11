Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbaCKK1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:27:49 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:35386 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755409AbaCKK1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:27:47 -0400
From: Yann Droneaud <ydroneaud@opteya.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Yann Droneaud <ydroneaud@opteya.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCHv6 3/6] binfmt_misc: use get_unused_fd_flags(0) instead of get_unused_fd()
Date: Tue, 11 Mar 2014 11:23:42 +0100
Message-Id: <bb98753833c56cf8e6e4089a96cdb3c3f3ece5b0.1394532336.git.ydroneaud@opteya.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <cover.1394532336.git.ydroneaud@opteya.com>
References: <cover.1394532336.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1394532336.git.ydroneaud@opteya.com>
References: <cover.1394532336.git.ydroneaud@opteya.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Macro get_unused_fd() is used to allocate a file descriptor with
default flags. Those default flags (0) can be "unsafe":
O_CLOEXEC must be used by default to not leak file descriptor
across exec().

Instead of macro get_unused_fd(), function get_unused_fd_flags()
(or anon_inode_getfd()) should be used with flags given by userspace.
If not possible, flags should be set to O_CLOEXEC to provide userspace
with a default safe behavor.

In a further patch, get_unused_fd() will be removed so that new code
start using get_unused_fd_flags() (or anon_inode_getfd()) with correct
flags.

This patch replaces calls to get_unused_fd() with equivalent call to
get_unused_fd_flags(0) to preserve current behavor for existing code.

The hard coded flag value (0) should be reviewed on a per-subsystem
basis, and, if possible, set to O_CLOEXEC.

Link: http://lkml.kernel.org/r/cover.1394532336.git.ydroneaud@opteya.com
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 fs/binfmt_misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 1c740e152f38..052f6dc8e549 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -138,7 +138,7 @@ static int load_misc_binary(struct linux_binprm *bprm)
 		/* if the binary should be opened on behalf of the
 		 * interpreter than keep it open and assign descriptor
 		 * to it */
- 		fd_binary = get_unused_fd();
+		fd_binary = get_unused_fd_flags(0);
  		if (fd_binary < 0) {
  			retval = fd_binary;
  			goto _ret;
-- 
1.8.5.3

