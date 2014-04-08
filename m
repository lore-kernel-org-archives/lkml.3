Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbaDHHG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 03:06:59 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:53314 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaDHHG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 03:06:57 -0400
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Zheng Liu <wenqing.lz@taobao.com>
Subject: [RFC][PATCH] vfs: add closefrom(2) syscall
Date: Tue,  8 Apr 2014 15:12:22 +0800
Message-Id: <1396941142-24821-1-git-send-email-wenqing.lz@taobao.com>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zheng Liu <wenqing.lz@taobao.com>

This commit adds a new syscall called closefrom(2) which is almost the
same as closefrom(2) in FreeBSD.  This syscall will close all open file
descriptors that is greater than or equal to the fd that is indicated
by caller.  It is really useful for an application that has opened a
hundreds of thousands of files because it doesn't need to call close(2)
several times.

This version is just an proof-of-concept implementation.  Now there are
two issues that need to be discussed.  The first one is that the syscall
ignores all errors.  It just returns '0'.  Does it need to return some
errors?  Another issue is that 'lowfd' argument is 'int' type but
fdtable->max_fds is 'unsigned int'.  So that means that it could close
all fds if 'lowfd' is greater than 'MAX_INT'.  Now it uses 'int' type
in order to keep consistent with closefrom(2) in FreeBSD.  In FreeBSD
system will close all fds if 'lowfd' is less than 0.

The test program opens a lot of files and closes them, and then we
calculates the time (*unit: us*) of closing these files.  Every cases
the program is run 3 times to compute the average number.

$ lscpu
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                16
On-line CPU(s) list:   0-15
Thread(s) per core:    2
Core(s) per socket:    4
CPU socket(s):         2
NUMA node(s):          2
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 44
Stepping:              2
CPU MHz:               2400.000
BogoMIPS:              4799.88
Virtualization:        VT-x
L1d cache:             32K
L1i cache:             32K
L2 cache:              256K
L3 cache:              12288K
NUMA node0 CPU(s):     0-3,8-11
NUMA node1 CPU(s):     4-7,12-15

*Unit: us*

1,000,000 files
===============
x vanilla
+ closefrom
+------------------------------------------------------------------------+
| ++    +                                                             xxx|
||_MA___|                                                             |A||
+------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   3        799552        810468        807615     805878.33     5661.4285
+   3        474013        504391        476899        485101     16767.836
Difference at 95.0% confidence
        -320777 +/- 28364.7
        -39.8047% +/- 3.51972%
        (Student's t, pooled s = 12514.2)

Improvement: 39.8047%

100,000 files
============
x vanilla
+ closefrom
+------------------------------------------------------------------------+
| +                                                                    x |
|++                                                                    xx|
||A|                                                                   A||
+------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   3         77815         78340         77975     78043.333     269.08797
+   3         46586         47220         47008         46938     322.74448
Difference at 95.0% confidence
        -31105.3 +/- 673.473
        -39.8565% +/- 0.862947%
        (Student's t, pooled s = 297.13)

Improvement: 39.8565%

10,000 files
============
x vanilla
+ closefrom
+------------------------------------------------------------------------+
| +                                                                      |
|++                                                                   xxx|
||A                                                                   |A||
+------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   3          6892          6979          6941     6937.3333     43.615746
+   3          4347          4391          4367     4368.3333     22.030282
Difference at 95.0% confidence
        -2569 +/- 78.3151
        -37.0315% +/- 1.12889%
        (Student's t, pooled s = 34.5519)

Improvement: 37.0315%

1,000 files
===========
x vanilla
+ closefrom
+------------------------------------------------------------------------+
|   +                                                                  x |
|+  +                                                                  xx|
||_AM|                                                                 A||
+------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   3           543           547           545           545             2
+   3           303           314           312     309.66667     5.8594653
Difference at 95.0% confidence
        -235.333 +/- 9.92309
        -43.1804% +/- 1.82075%
        (Student's t, pooled s = 4.37798)

Improvement: 43.1804%

100 files
=========
x vanilla
+ closefrom
+------------------------------------------------------------------------+
|+                                                                       |
|+                                                                   x   |
|+                                                                   x  x|
|A                                                                   MA_||
+------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   3            57            58            57     57.333333    0.57735027
+   3            32            32            32            32             0
Difference at 95.0% confidence
        -25.3333 +/- 0.925333
        -44.186% +/- 1.61395%
        (Student's t, pooled s = 0.408248)

Improvement: 44.186%

10 files
========
x vanilla
+ closefrom
+------------------------------------------------------------------------+
|        +                                                              x|
|        +                              +                               x|
||_______M_________A__________________|                                 A|
+------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   3             7             7             7             7             0
+   3             5             6             5     5.3333333    0.57735027
Difference at 95.0% confidence
        -1.66667 +/- 0.925333
        -23.8095% +/- 13.219%
        (Student's t, pooled s = 0.408248)

Improvement: 23.8095%

1 file
======
x vanilla
+ closefrom
+------------------------------------------------------------------------+
|              *                                                         |
|              *                                                        *|
||_____________M__________________A________________________________|     |
+------------------------------------------------------------------------+
    N           Min           Max        Median           Avg        Stddev
x   3             2             3             2     2.3333333    0.57735027
+   3             2             3             2     2.3333333    0.57735027
No difference proven at 95.0% confidence

Any comment or feedback are always welcome.

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 arch/x86/syscalls/syscall_64.tbl |    1 +
 fs/file.c                        |   30 ++++++++++++++++++++++++++++++
 fs/open.c                        |    6 ++++++
 include/linux/fdtable.h          |    1 +
 4 files changed, 38 insertions(+)

diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index 04376ac3d9ef..33c71e4defc2 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -323,6 +323,7 @@
 314	common	sched_setattr		sys_sched_setattr
 315	common	sched_getattr		sys_sched_getattr
 316	common	renameat2		sys_renameat2
+317	common	closefrom		sys_closefrom
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/fs/file.c b/fs/file.c
index b61293badfb1..15502ac4304c 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -601,6 +601,36 @@ out_unlock:
 	return -EBADF;
 }
 
+int __close_fds(struct files_struct *files, int lowfd)
+{
+	struct file *file;
+	struct fdtable *fdt;
+	int fd;
+
+	if (lowfd < 0)
+		lowfd = 0;
+	spin_lock(&files->file_lock);
+	fdt = files_fdtable(files);
+	if (lowfd >= fdt->max_fds)
+		goto out_unlock;
+	for (fd = lowfd; fd < fdt->max_fds; fd++) {
+		file = fdt->fd[fd];
+		if (!file)
+			continue;
+
+		rcu_assign_pointer(fdt->fd[fd], NULL);
+		__clear_close_on_exec(fd, fdt);
+		__put_unused_fd(files, fd);
+		spin_unlock(&files->file_lock);
+		filp_close(file, files);
+		spin_lock(&files->file_lock);
+	}
+
+out_unlock:
+	spin_unlock(&files->file_lock);
+	return 0;
+}
+
 void do_close_on_exec(struct files_struct *files)
 {
 	unsigned i;
diff --git a/fs/open.c b/fs/open.c
index 631aea815def..afe3b631074a 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1099,6 +1099,12 @@ SYSCALL_DEFINE1(close, unsigned int, fd)
 }
 EXPORT_SYMBOL(sys_close);
 
+SYSCALL_DEFINE1(closefrom, int, lowfd)
+{
+	return __close_fds(current->files, lowfd);
+}
+EXPORT_SYMBOL(sys_closefrom);
+
 /*
  * This routine simulates a hangup on the tty, to arrange that users
  * are given clean terminals at login time.
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index 70e8e21c0a30..b0f9fc736481 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -114,6 +114,7 @@ extern void __fd_install(struct files_struct *files,
 		      unsigned int fd, struct file *file);
 extern int __close_fd(struct files_struct *files,
 		      unsigned int fd);
+extern int __close_fds(struct files_struct *files, int lowfd);
 
 extern struct kmem_cache *files_cachep;
 
-- 
1.7.9.7

