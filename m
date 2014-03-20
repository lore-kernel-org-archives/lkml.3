Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759532AbaCTRae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 13:30:34 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:43691 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757244AbaCTRad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 13:30:33 -0400
Message-ID: <201403201730.s2KHUVpf005157@farm-0039.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 20 Mar 2014 11:31:55 -0400
Subject: [PATCH] compat_audit: allow it to work without asm/unistd32.h
To: <linux-kernel@vger.kernel.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Eric Paris <eparis@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For architectures that use the asm-generic syscall table for both
32- and 64-bit, there should be no need to provide a separate
<asm/unistd32.h>; just using <linux/unistd.h> is sufficient.
Conditionalize use of <asm/unistd32.h> on the one platform that
currently requires it (arm64).  If another platform ends up needing
it we can create a suitable config flag at that point.

This change fixes the tilegx build failure seen in linux-next.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
By the way - I also note that commit 223b24d807610 that introduced
this also put an "#ifdef COMPAT_xxx" in a UAPI header.  This seems
like a pretty clear signal that the added code should be in
linux/include/audit.h, not linux/uapi/include/audit.h.  But here
I'm just focussing on getting tilegx to continue to build...

 lib/compat_audit.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/lib/compat_audit.c b/lib/compat_audit.c
index 873f75b640ab..e89a84b3fbe8 100644
--- a/lib/compat_audit.c
+++ b/lib/compat_audit.c
@@ -1,6 +1,11 @@
 #include <linux/init.h>
 #include <linux/types.h>
-#include <asm/unistd32.h>
+#ifdef COMPAT_ARM64
+/* 64-bit syscalls are generic, but 32-bit are not. */
+# include <asm/unistd32.h>
+#else
+# include <linux/unistd.h>
+#endif
 
 unsigned compat_dir_class[] = {
 #include <asm-generic/audit_dir_write.h>
-- 
1.8.3.1

