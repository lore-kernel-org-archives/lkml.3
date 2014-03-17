Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663AbaCQKlD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 06:41:03 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:38923 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932348AbaCQKlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 06:41:01 -0400
From: Andrey Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: criu@openvz.org, Andrey Vagin <avagin@openvz.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: [PATCH] proc: show mnt_id in fdinfo files
Date: Mon, 17 Mar 2014 14:39:10 +0400
Message-Id: <1395052750-8525-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we don't have a way how to determing from which mount point
file has been opened. This information is required for proper dumping
and restoring file descriptos due to presence of mount namespaces. It's
possible, that two file descriptors are opened using the same paths, but
one fd references mount point from one namespace while the other fd --
from other namespace.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 fs/proc/fd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/proc/fd.c b/fs/proc/fd.c
index 985ea88..0788d09 100644
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -11,6 +11,7 @@
 
 #include <linux/proc_fs.h>
 
+#include "../mount.h"
 #include "internal.h"
 #include "fd.h"
 
@@ -48,8 +49,9 @@ static int seq_show(struct seq_file *m, void *v)
 	}
 
 	if (!ret) {
-                seq_printf(m, "pos:\t%lli\nflags:\t0%o\n",
-			   (long long)file->f_pos, f_flags);
+		seq_printf(m, "pos:\t%lli\nflags:\t0%o\nmnt_id:\t%i\n",
+			   (long long)file->f_pos, f_flags,
+			   real_mount(file->f_path.mnt)->mnt_id);
 		if (file->f_op->show_fdinfo)
 			ret = file->f_op->show_fdinfo(m, file);
 		fput(file);
-- 
1.8.5.3

