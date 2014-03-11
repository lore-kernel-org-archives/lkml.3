Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbaCKK1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:27:43 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:35111 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708AbaCKK1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:27:42 -0400
From: Yann Droneaud <ydroneaud@opteya.com>
To: Jeremy Kerr <jk@ozlabs.org>, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: Yann Droneaud <ydroneaud@opteya.com>, linuxppc-dev@lists.ozlabs.org,
        cbe-oss-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCHv6 2/6] ppc/cell: use get_unused_fd_flags(0) instead of get_unused_fd()
Date: Tue, 11 Mar 2014 11:23:41 +0100
Message-Id: <2e1a8b1869ff86b1f238e6f4e6ce4b5f2b17b03f.1394532336.git.ydroneaud@opteya.com>
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
 arch/powerpc/platforms/cell/spufs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index 87ba7cf99cd7..51effcec30d8 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -301,7 +301,7 @@ static int spufs_context_open(struct path *path)
 	int ret;
 	struct file *filp;
 
-	ret = get_unused_fd();
+	ret = get_unused_fd_flags(0);
 	if (ret < 0)
 		return ret;
 
@@ -518,7 +518,7 @@ static int spufs_gang_open(struct path *path)
 	int ret;
 	struct file *filp;
 
-	ret = get_unused_fd();
+	ret = get_unused_fd_flags(0);
 	if (ret < 0)
 		return ret;
 
-- 
1.8.5.3

