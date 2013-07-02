Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab3GBQkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 12:40:24 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:43576 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769Ab3GBQkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 12:40:20 -0400
From: Yann Droneaud <ydroneaud@opteya.com>
To: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Yann Droneaud <ydroneaud@opteya.com>
Subject: [PATCH 03/13] infiniband: use get_unused_fd_flags(0) instead of get_unused_fd()
Date: Tue,  2 Jul 2013 18:39:27 +0200
Message-Id: <651e35493f6a970610d35785e1972ec9e2426abf.1372777600.git.ydroneaud@opteya.com>
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
 drivers/infiniband/core/uverbs_cmd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index a7d00f6..9c893bc 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -334,7 +334,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 
 	resp.num_comp_vectors = file->device->num_comp_vectors;
 
-	ret = get_unused_fd();
+	ret = get_unused_fd_flags(0);
 	if (ret < 0)
 		goto err_free;
 	resp.async_fd = ret;
@@ -1184,7 +1184,7 @@ ssize_t ib_uverbs_create_comp_channel(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	ret = get_unused_fd();
+	ret = get_unused_fd_flags(0);
 	if (ret < 0)
 		return ret;
 	resp.fd = ret;
-- 
1.8.3.1

