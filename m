Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbaCTK7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 06:59:31 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:24269 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755381AbaCTK73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 06:59:29 -0400
From: Andrey Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: criu@openvz.org, Andrey Vagin <avagin@openvz.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Rob Landley <rob@landley.net>
Subject: [PATCH] proc: show mnt_id in fdinfo files (v2)
Date: Thu, 20 Mar 2014 14:57:28 +0400
Message-Id: <1395313048-12072-1-git-send-email-avagin@openvz.org>
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

$ ls -l /proc/1/fd/1
lrwx------ 1 root root 64 Mar 19 23:54 /proc/1/fd/1 -> /dev/null

$ cat /proc/1/fdinfo/1
pos:	0
flags:	0100002
mnt_id:	16

$ cat /proc/1/mountinfo | grep ^16
16 32 0:4 / /dev rw,nosuid shared:2 - devtmpfs devtmpfs rw,size=1013356k,nr_inodes=253339,mode=755

v2: update Documentation/filesystems/proc.txt

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Rob Landley <rob@landley.net>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 Documentation/filesystems/proc.txt | 17 ++++++++++++-----
 fs/proc/fd.c                       |  6 ++++--
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index f00bee1..8b9cd8e 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -1648,18 +1648,21 @@ pids, so one need to either stop or freeze processes being inspected
 if precise results are needed.
 
 
-3.7	/proc/<pid>/fdinfo/<fd> - Information about opened file
+3.8	/proc/<pid>/fdinfo/<fd> - Information about opened file
 ---------------------------------------------------------------
 This file provides information associated with an opened file. The regular
-files have at least two fields -- 'pos' and 'flags'. The 'pos' represents
-the current offset of the opened file in decimal form [see lseek(2) for
-details] and 'flags' denotes the octal O_xxx mask the file has been
-created with [see open(2) for details].
+files have at least three fields -- 'pos', 'flags' and mnt_id. The 'pos'
+represents the current offset of the opened file in decimal form [see lseek(2)
+for details], 'flags' denotes the octal O_xxx mask the file has been
+created with [see open(2) for details] and 'mnt_id' represents mount ID of
+the file system containing the opened file [see 3.5 /proc/<pid>/mountinfo
+for details].
 
 A typical output is
 
 	pos:	0
 	flags:	0100002
+	mnt_id:	19
 
 The files such as eventfd, fsnotify, signalfd, epoll among the regular pos/flags
 pair provide additional information particular to the objects they represent.
@@ -1668,6 +1671,7 @@ pair provide additional information particular to the objects they represent.
 	~~~~~~~~~~~~~
 	pos:	0
 	flags:	04002
+	mnt_id:	9
 	eventfd-count:	5a
 
 	where 'eventfd-count' is hex value of a counter.
@@ -1676,6 +1680,7 @@ pair provide additional information particular to the objects they represent.
 	~~~~~~~~~~~~~~
 	pos:	0
 	flags:	04002
+	mnt_id:	9
 	sigmask:	0000000000000200
 
 	where 'sigmask' is hex value of the signal mask associated
@@ -1685,6 +1690,7 @@ pair provide additional information particular to the objects they represent.
 	~~~~~~~~~~~
 	pos:	0
 	flags:	02
+	mnt_id:	9
 	tfd:        5 events:       1d data: ffffffffffffffff
 
 	where 'tfd' is a target file descriptor number in decimal form,
@@ -1718,6 +1724,7 @@ pair provide additional information particular to the objects they represent.
 
 	pos:	0
 	flags:	02
+	mnt_id:	9
 	fanotify flags:10 event-flags:0
 	fanotify mnt_id:12 mflags:40 mask:38 ignored_mask:40000003
 	fanotify ino:4f969 sdev:800013 mflags:0 mask:3b ignored_mask:40000000 fhandle-bytes:8 fhandle-type:1 f_handle:69f90400c275b5b4
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

