Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925Ab3HONMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 09:12:52 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:34498 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757776Ab3HONMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 09:12:49 -0400
From: Yann Droneaud <ydroneaud@opteya.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Yann Droneaud <ydroneaud@opteya.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 06/10] binfmt_misc: use get_unused_fd_flags(0) instead of get_unused_fd()
Date: Thu, 15 Aug 2013 15:10:56 +0200
Message-Id: <d7dceeb5b0f0be85d37fcc02df5fb51a0ac13ef5.1376327678.git.ydroneaud@opteya.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1376327678.git.ydroneaud@opteya.com>
References: <cover.1376327678.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1376327678.git.ydroneaud@opteya.com>
References: <cover.1376327678.git.ydroneaud@opteya.com>
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
Link: http://lkml.kernel.org/r/cover.1376327678.git.ydroneaud@opteya.com

---
 fs/binfmt_misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 1c740e1..052f6dc 100644
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
1.8.3.1

