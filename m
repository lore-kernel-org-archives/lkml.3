Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbaAUVtB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:49:01 -0500
Received: from mail1.windriver.com ([147.11.146.13]:50564 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbaAUVYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:24:03 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>
Subject: [PATCH 03/73] fs/notify: don't use module_init for non-modular inotify_user code
Date: Tue, 21 Jan 2014 16:22:06 -0500
Message-ID: <1390339396-3479-4-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The INOTIFY_USER option is bool, and hence this code is either
present or absent.  It will never be modular, so using
module_init as an alias for __initcall is rather misleading.

Fix this up now, so that we can relocate module_init from
init.h into module.h in the future.  If we don't do this, we'd
have to add module.h to obviously non-modular code, and that
would be a worse thing.

Note that direct use of __initcall is discouraged, vs. one
of the priority categorized subgroups.  As __initcall gets
mapped onto device_initcall, our use of fs_initcall (which
makes sense for fs code) will thus change this registration
from level 6-device to level 5-fs (i.e. slightly earlier).
However no observable impact of that small difference has
been observed during testing, or is expected.

Cc: John McCutchan <john@johnmccutchan.com>
Cc: Robert Love <rlove@rlove.org>
Cc: Eric Paris <eparis@parisplace.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/notify/inotify/inotify_user.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 497395c..0a23b69 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -26,7 +26,7 @@
 #include <linux/fs.h> /* struct inode */
 #include <linux/fsnotify_backend.h>
 #include <linux/idr.h>
-#include <linux/init.h> /* module_init */
+#include <linux/init.h> /* fs_initcall */
 #include <linux/inotify.h>
 #include <linux/kernel.h> /* roundup() */
 #include <linux/namei.h> /* LOOKUP_FOLLOW */
@@ -801,4 +801,4 @@ static int __init inotify_user_setup(void)
 
 	return 0;
 }
-module_init(inotify_user_setup);
+fs_initcall(inotify_user_setup);
-- 
1.8.4.1

