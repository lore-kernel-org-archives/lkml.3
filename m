Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433Ab3IFKlo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 06:41:44 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:40926 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab3IFKlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 06:41:40 -0400
From: Yann Droneaud <ydroneaud@opteya.com>
To: linux-kernel@vger.kernel.org, Jeremy Kerr <jk@ozlabs.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org, cbe-oss-dev@lists.ozlabs.org,
        Yann Droneaud <ydroneaud@opteya.com>
Subject: [PATCH v3 2/8] ppc/cell: use get_unused_fd_flags(0) instead of get_unused_fd()
Date: Fri,  6 Sep 2013 12:39:52 +0200
Message-Id: <74f26a6b6bce2e30c65cd198e5709ce1634ad041.1378460926.git.ydroneaud@opteya.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1378460926.git.ydroneaud@opteya.com>
References: <cover.1378460926.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1378460926.git.ydroneaud@opteya.com>
References: <cover.1378460926.git.ydroneaud@opteya.com>
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
Link: http://lkml.kernel.org/r/cover.1378460926.git.ydroneaud@opteya.com
---
 arch/powerpc/platforms/cell/spufs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index 87ba7cf..51effce 100644
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
1.8.3.1

