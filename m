Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324Ab3IFKlg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 06:41:36 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:38981 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab3IFKlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 06:41:14 -0400
From: Yann Droneaud <ydroneaud@opteya.com>
To: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-ia64@vger.kernel.org, Yann Droneaud <ydroneaud@opteya.com>
Subject: [PATCH v3 1/8] ia64: use get_unused_fd_flags(0) instead of get_unused_fd()
Date: Fri,  6 Sep 2013 12:39:51 +0200
Message-Id: <7dbd986a286a51b882f08192da8399c65dc5d1e4.1378460926.git.ydroneaud@opteya.com>
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
 arch/ia64/kernel/perfmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index 5a9ff1c..64757c1 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -2668,7 +2668,7 @@ pfm_context_create(pfm_context_t *ctx, void *arg, int count, struct pt_regs *reg
 
 	ret = -ENOMEM;
 
-	fd = get_unused_fd();
+	fd = get_unused_fd_flags(0);
 	if (fd < 0)
 		return fd;
 
-- 
1.8.3.1

