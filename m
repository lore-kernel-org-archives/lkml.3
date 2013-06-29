Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab3F2NO7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 09:14:59 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:46376 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab3F2NOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 09:14:54 -0400
From: Sami Kerola <kerolasa@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: kerolasa@iki.fi, Karel Zak <kzak@redhat.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay@vrfy.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] proc: make high precision system boot time available
Date: Sat, 29 Jun 2013 14:14:38 +0100
Message-Id: <1372511678-2726-1-git-send-email-kerolasa@iki.fi>
X-Mailer: git-send-email 1.8.3.1
Organization: Lastminute.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel does not expose precise start time anywhere.  Precision of
sysinfo() is limited to a second.  The /proc/uptime has precision of two
decimals.  Neither are good enough when klog messages are displayed with
a log time stamp that is converted to human understandable format, such
as ISO-8601.  The problem is that imprecise knowledge about uptime will
lead human readable klog time stamps to wiggle in user commands, such as
dmesg(1).

Additionally the current dmesg and journalctl(1) are disagreeing when
kernel events occurred.  The dmesg is using sysinfo(2) to determine boot
time, while journalctl is using systemd(1)'s early clock_gettime(2) call.
Here is demonstration how different baseline effects on a random laptop.

$ dmesg --ctime | grep 'Initializing cgroup subsys cpuset'
[Fri Jun 28 07:40:12 2013] Initializing cgroup subsys cpuset
$ journalctl -b | grep 'Initializing cgroup subsys cpuset'
Jun 28 07:40:21 kerolasa-home kernel: Initializing cgroup subsys cpuset

To solve the wiggling problem, and to have a boot time coming from source
which everyone can agree is 'good enough' estimation of system start up,
the kernel needs to tell the boot time as precisily as it can.

CC: Karel Zak <kzak@redhat.com>
CC: Lennart Poettering <lennart@poettering.net>
CC: Kay Sievers <kay@vrfy.org>
CC: Eric W. Biederman <ebiederm@xmission.com>
References: http://www.spinics.net/lists/util-linux-ng/msg08092.html
Measurement: https://plus.google.com/u/0/117341944650953092607/posts/SHy5qu1HpSU
Signed-off-by: Sami Kerola <kerolasa@iki.fi>
---
 Documentation/ABI/testing/procfs-boottime | 15 ++++++++++++++
 fs/proc/Makefile                          |  1 +
 fs/proc/boottime.c                        | 33 +++++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+)
 create mode 100644 Documentation/ABI/testing/procfs-boottime
 create mode 100644 fs/proc/boottime.c

diff --git a/Documentation/ABI/testing/procfs-boottime b/Documentation/ABI/testing/procfs-boottime
new file mode 100644
index 0000000..d5bf8f2
--- /dev/null
+++ b/Documentation/ABI/testing/procfs-boottime
@@ -0,0 +1,15 @@
+What:		/proc/boottime
+Date:		June 2013
+KernelVersion:	3.11
+Contact:	Sami Kerola <kerolasa@iki.fi>
+
+Description:	Show high precision time stamp when linux kernel thinks
+		the system start up.  The value is suitable to be used as
+		struct timespec.
+
+		struct timespec ts;
+		hpu = fopen("/sys/kernel/boottime", "r");
+		fscanf(hpu, "%ld.%ld", &ts.tv_sec, &ts.tv_nsec);
+
+Users:		At least utilities that print klog entries in
+		times stamps converted for humans.
diff --git a/fs/proc/Makefile b/fs/proc/Makefile
index ab30716..5a7ec5a 100644
--- a/fs/proc/Makefile
+++ b/fs/proc/Makefile
@@ -10,6 +10,7 @@ proc-$(CONFIG_MMU)	:= task_mmu.o
 proc-y       += inode.o root.o base.o generic.o array.o \
 		fd.o
 proc-$(CONFIG_TTY)      += proc_tty.o
+proc-y	+= boottime.o
 proc-y	+= cmdline.o
 proc-y	+= consoles.o
 proc-y	+= cpuinfo.o
diff --git a/fs/proc/boottime.c b/fs/proc/boottime.c
new file mode 100644
index 0000000..f56c624
--- /dev/null
+++ b/fs/proc/boottime.c
@@ -0,0 +1,33 @@
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <linux/time.h>
+
+static int boottime_proc_show(struct seq_file *m, void *v)
+{
+	struct timespec ts;
+	getboottime(&ts);
+	seq_printf(m, "%ld.%ld\n", ts.tv_sec, ts.tv_nsec);
+	return 0;
+}
+
+static int boottime_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, boottime_proc_show, NULL);
+}
+
+static const struct file_operations boottime_proc_fops = {
+	.open = boottime_proc_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static int __init proc_boottime_init(void)
+{
+	proc_create("boottime", 0, NULL, &boottime_proc_fops);
+	return 0;
+}
+
+module_init(proc_boottime_init);
-- 
1.8.3.1

