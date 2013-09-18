Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab3IRXXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 19:23:17 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:48491 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab3IRXXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 19:23:16 -0400
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Sep 2013 19:23:16 EDT
From: Vinson Lee <vlee@freedesktop.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Borislav Petkov <bp@suse.de>,
        linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, Vinson Lee <vlee@freedesktop.org>,
        Vinson Lee <vlee@twitter.com>
Subject: [PATCH] tools lib lk: Uninclude linux/magic.h in debugfs.c.
Date: Wed, 18 Sep 2013 16:16:40 -0700
Message-Id: <1379546200-17028-1-git-send-email-vlee@freedesktop.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vinson Lee <vlee@twitter.com>

The compilation only looks for linux/magic.h from the default include
paths, which does not include the source tree. This results in a build
error if linux/magic.h is not available or not installed.

For example, this build error occurs on CentOS 5.

$ make -C tools/lib/lk V=1
[...]
gcc -o debugfs.o -c -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6
-D_FORTIFY_SOURCE=2 -Wbad-function-cast -Wdeclaration-after-statement
-Wformat-security -Wformat-y2k -Winit-self -Wmissing-declarations
-Wmissing-prototypes -Wnested-externs -Wno-system-headers
-Wold-style-definition -Wpacked -Wredundant-decls -Wshadow
-Wstrict-aliasing=3 -Wstrict-prototypes -Wswitch-default -Wswitch-enum
-Wundef -Wwrite-strings -Wformat  -fPIC  -D_LARGEFILE64_SOURCE
-D_FILE_OFFSET_BITS=64 debugfs.c
debugfs.c:8:25: error: linux/magic.h: No such file or directory

The only symbol from linux/magic.h needed by debugfs.c is DEBUGFS_MAGIC,
and that is already defined in debugfs.h. linux/magic.h isn't providing
any extra symbols and can unincluded. This is similar to the approach by
perf, which has its own magic.h wrapper at
tools/perf/util/include/linux/magic.h

Signed-off-by: Vinson Lee <vlee@twitter.com>
Cc: stable@vger.kernel.org # 3.10+
---
 tools/lib/lk/debugfs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/lib/lk/debugfs.c b/tools/lib/lk/debugfs.c
index 099e7cd..7c43479 100644
--- a/tools/lib/lk/debugfs.c
+++ b/tools/lib/lk/debugfs.c
@@ -5,7 +5,6 @@
 #include <stdbool.h>
 #include <sys/vfs.h>
 #include <sys/mount.h>
-#include <linux/magic.h>
 #include <linux/kernel.h>
 
 #include "debugfs.h"
-- 
1.8.2.1

