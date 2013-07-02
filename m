Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab3GBQnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 12:43:00 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:43851 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174Ab3GBQkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 12:40:23 -0400
From: Yann Droneaud <ydroneaud@opteya.com>
To: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Yann Droneaud <ydroneaud@opteya.com>
Subject: [PATCH 05/13] android/sync: use get_unused_fd_flags(0) instead of get_unused_fd()
Date: Tue,  2 Jul 2013 18:39:29 +0200
Message-Id: <747eab1873d0e8285a243ed42540485f12af1e91.1372777600.git.ydroneaud@opteya.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1372777600.git.ydroneaud@opteya.com>
References: <cover.1372777600.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1372777600.git.ydroneaud@opteya.com>
References: <cover.1372777600.git.ydroneaud@opteya.com>
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
---
 drivers/staging/android/sync.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index 2996077..c40c743 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -697,7 +697,7 @@ static long sync_fence_ioctl_wait(struct sync_fence *fence, unsigned long arg)
 
 static long sync_fence_ioctl_merge(struct sync_fence *fence, unsigned long arg)
 {
-	int fd = get_unused_fd();
+	int fd = get_unused_fd_flags(0);
 	int err;
 	struct sync_fence *fence2, *fence3;
 	struct sync_merge_data data;
-- 
1.8.3.1

