Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbaAEUjO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 15:39:14 -0500
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:59476 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbaAEUjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 15:39:10 -0500
From: Yann Droneaud <ydroneaud@opteya.com>
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Cc: Yann Droneaud <ydroneaud@opteya.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCHv5 1/7] ia64: use get_unused_fd_flags(0) instead of get_unused_fd()
Date: Sun,  5 Jan 2014 21:36:28 +0100
Message-Id: <d8999c560d6348e40b5f037bc73f4e48bc3ad977.1388952061.git.ydroneaud@opteya.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <cover.1388952061.git.ydroneaud@opteya.com>
References: <cover.1388952061.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1388952061.git.ydroneaud@opteya.com>
References: <cover.1388952061.git.ydroneaud@opteya.com>
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

Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
Link: http://lkml.kernel.org/r/cover.1388952061.git.ydroneaud@opteya.com
---
 arch/ia64/kernel/perfmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index cb592773c78b..44b148fbb560 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -2662,7 +2662,7 @@ pfm_context_create(pfm_context_t *ctx, void *arg, int count, struct pt_regs *reg
 
 	ret = -ENOMEM;
 
-	fd = get_unused_fd();
+	fd = get_unused_fd_flags(0);
 	if (fd < 0)
 		return fd;
 
-- 
1.8.4.2

