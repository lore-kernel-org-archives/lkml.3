Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab3J3Tvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 15:51:33 -0400
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:48837 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001Ab3J3Tva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 15:51:30 -0400
From: Yann Droneaud <ydroneaud@opteya.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Yann Droneaud <ydroneaud@opteya.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 6/7] events: use get_unused_fd_flags(0) instead of get_unused_fd()
Date: Wed, 30 Oct 2013 20:47:46 +0100
Message-Id: <3b0bc009ff1410d04f8a1e71bfae0d27e1254b90.1383121137.git.ydroneaud@opteya.com>
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
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 354a59c..142d13c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6970,7 +6970,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	if ((flags & PERF_FLAG_PID_CGROUP) && (pid == -1 || cpu == -1))
 		return -EINVAL;
 
-	event_fd = get_unused_fd();
+	event_fd = get_unused_fd_flags(0);
 	if (event_fd < 0)
 		return event_fd;
 
-- 
1.8.3.1

