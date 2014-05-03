Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbaECKt3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 06:49:29 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:54431 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbaECKtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 06:49:11 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Matthew Garrett <matthew.garrett@nebula.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-doc@vger.kernel.org, Sonal Santan <sonal.santan@gmail.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 2/2] Documentation: Rename hpfall.c => freefall.c, fixes for Dell
Date: Sat,  3 May 2014 12:47:57 +0200
Message-Id: <1399114077-19314-3-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399114077-19314-1-git-send-email-pali.rohar@gmail.com>
References: <1399114077-19314-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dell kernel driver dell-smo8800 provides same freefall interface as hp_accel so
program hpfall.c works also on Dell laptops. So rename it to freefall.c.

Dell driver does not provide hp::hddprotect led so make sure that freefall.c
works also if hp::hddprotect does not exist in sysfs.

Additionally write info to syslog.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Cc: Sonal Santan <sonal.santan@gmail.com>
---
 Documentation/laptops/00-INDEX   |    4 +-
 Documentation/laptops/freefall.c |  171 ++++++++++++++++++++++++++++++++++++++
 Documentation/laptops/hpfall.c   |  146 --------------------------------
 3 files changed, 173 insertions(+), 148 deletions(-)
 create mode 100644 Documentation/laptops/freefall.c
 delete mode 100644 Documentation/laptops/hpfall.c

diff --git a/Documentation/laptops/00-INDEX b/Documentation/laptops/00-INDEX
index d13b9a9..d399ae1 100644
--- a/Documentation/laptops/00-INDEX
+++ b/Documentation/laptops/00-INDEX
@@ -8,8 +8,8 @@ disk-shock-protection.txt
 	- information on hard disk shock protection.
 dslm.c
 	- Simple Disk Sleep Monitor program
-hpfall.c
-	- (HP) laptop accelerometer program for disk protection.
+freefall.c
+	- (HP/DELL) laptop accelerometer program for disk protection.
 laptop-mode.txt
 	- how to conserve battery power using laptop-mode.
 sony-laptop.txt
diff --git a/Documentation/laptops/freefall.c b/Documentation/laptops/freefall.c
new file mode 100644
index 0000000..4d4d90a
--- /dev/null
+++ b/Documentation/laptops/freefall.c
@@ -0,0 +1,171 @@
+/* Disk protection for HP/DELL machines.
+ *
+ * Copyright 2008 Eric Piel
+ * Copyright 2009 Pavel Machek <pavel@ucw.cz>
+ * Copyright 2012 Sonal Santan
+ * Copyright 2014 Pali Rohár <pali.rohar@gmail.com>
+ *
+ * GPLv2.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <string.h>
+#include <stdint.h>
+#include <errno.h>
+#include <signal.h>
+#include <sys/mman.h>
+#include <sched.h>
+#include <syslog.h>
+
+static int noled;
+static char unload_heads_path[64];
+static char device_path[32];
+static const char app_name[] = "FREE FALL";
+
+static int set_unload_heads_path(char *device)
+{
+	char devname[64];
+
+	if (strlen(device) <= 5 || strncmp(device, "/dev/", 5) != 0)
+		return -EINVAL;
+	strncpy(devname, device + 5, sizeof(devname) - 1);
+	strncpy(device_path, device, sizeof(device_path) - 1);
+
+	snprintf(unload_heads_path, sizeof(unload_heads_path) - 1,
+				"/sys/block/%s/device/unload_heads", devname);
+	return 0;
+}
+
+static int valid_disk(void)
+{
+	int fd = open(unload_heads_path, O_RDONLY);
+	if (fd < 0) {
+		perror(unload_heads_path);
+		return 0;
+	}
+
+	close(fd);
+	return 1;
+}
+
+static void write_int(char *path, int i)
+{
+	char buf[1024];
+	int fd = open(path, O_RDWR);
+	if (fd < 0) {
+		perror("open");
+		exit(1);
+	}
+	sprintf(buf, "%d", i);
+	if (write(fd, buf, strlen(buf)) != strlen(buf)) {
+		perror("write");
+		exit(1);
+	}
+	close(fd);
+}
+
+static void set_led(int on)
+{
+	if (noled)
+		return;
+	write_int("/sys/class/leds/hp::hddprotect/brightness", on);
+}
+
+static void protect(int seconds)
+{
+	const char *str = (seconds == 0) ? "Unparked" : "Parked";
+	write_int(unload_heads_path, seconds*1000);
+	syslog(LOG_INFO, "%s %s disk head\n", str, device_path);
+}
+
+static int on_ac(void)
+{
+	/* /sys/class/power_supply/AC0/online */
+	return 1;
+}
+
+static int lid_open(void)
+{
+	/* /proc/acpi/button/lid/LID/state */
+	return 1;
+}
+
+static void ignore_me(int signum)
+{
+	protect(0);
+	set_led(0);
+}
+
+int main(int argc, char **argv)
+{
+	int fd, ret;
+	struct stat st;
+	struct sched_param param;
+
+	if (argc == 1)
+		ret = set_unload_heads_path("/dev/sda");
+	else if (argc == 2)
+		ret = set_unload_heads_path(argv[1]);
+	else
+		ret = -EINVAL;
+
+	if (ret || !valid_disk()) {
+		fprintf(stderr, "usage: %s <device> (default: /dev/sda)\n",
+				argv[0]);
+		exit(1);
+	}
+
+	fd = open("/dev/freefall", O_RDONLY);
+	if (fd < 0) {
+		perror("/dev/freefall");
+		return EXIT_FAILURE;
+	}
+
+	if (stat("/sys/class/leds/hp::hddprotect/brightness", &st))
+		noled = 1;
+
+	if (daemon(0, 0) != 0) {
+		perror("daemon");
+		return EXIT_FAILURE;
+	}
+
+	openlog(app_name,  LOG_CONS | LOG_PID | LOG_NDELAY, LOG_LOCAL1);
+
+	param.sched_priority = sched_get_priority_max(SCHED_FIFO);
+	sched_setscheduler(0, SCHED_FIFO, &param);
+	mlockall(MCL_CURRENT|MCL_FUTURE);
+
+	signal(SIGALRM, ignore_me);
+
+	for (;;) {
+		unsigned char count;
+
+		ret = read(fd, &count, sizeof(count));
+		alarm(0);
+		if ((ret == -1) && (errno == EINTR)) {
+			/* Alarm expired, time to unpark the heads */
+			continue;
+		}
+
+		if (ret != sizeof(count)) {
+			perror("read");
+			break;
+		}
+
+		protect(21);
+		set_led(1);
+		if (1 || on_ac() || lid_open())
+			alarm(2);
+		else
+			alarm(20);
+	}
+
+	closelog();
+	close(fd);
+	return EXIT_SUCCESS;
+}
diff --git a/Documentation/laptops/hpfall.c b/Documentation/laptops/hpfall.c
deleted file mode 100644
index b85dbba..0000000
--- a/Documentation/laptops/hpfall.c
+++ /dev/null
@@ -1,146 +0,0 @@
-/* Disk protection for HP machines.
- *
- * Copyright 2008 Eric Piel
- * Copyright 2009 Pavel Machek <pavel@ucw.cz>
- *
- * GPLv2.
- */
-
-#include <stdio.h>
-#include <stdlib.h>
-#include <unistd.h>
-#include <fcntl.h>
-#include <sys/stat.h>
-#include <sys/types.h>
-#include <string.h>
-#include <stdint.h>
-#include <errno.h>
-#include <signal.h>
-#include <sys/mman.h>
-#include <sched.h>
-
-char unload_heads_path[64];
-
-int set_unload_heads_path(char *device)
-{
-	char devname[64];
-
-	if (strlen(device) <= 5 || strncmp(device, "/dev/", 5) != 0)
-		return -EINVAL;
-	strncpy(devname, device + 5, sizeof(devname));
-
-	snprintf(unload_heads_path, sizeof(unload_heads_path) - 1,
-				"/sys/block/%s/device/unload_heads", devname);
-	return 0;
-}
-int valid_disk(void)
-{
-	int fd = open(unload_heads_path, O_RDONLY);
-	if (fd < 0) {
-		perror(unload_heads_path);
-		return 0;
-	}
-
-	close(fd);
-	return 1;
-}
-
-void write_int(char *path, int i)
-{
-	char buf[1024];
-	int fd = open(path, O_RDWR);
-	if (fd < 0) {
-		perror("open");
-		exit(1);
-	}
-	sprintf(buf, "%d", i);
-	if (write(fd, buf, strlen(buf)) != strlen(buf)) {
-		perror("write");
-		exit(1);
-	}
-	close(fd);
-}
-
-void set_led(int on)
-{
-	write_int("/sys/class/leds/hp::hddprotect/brightness", on);
-}
-
-void protect(int seconds)
-{
-	write_int(unload_heads_path, seconds*1000);
-}
-
-int on_ac(void)
-{
-//	/sys/class/power_supply/AC0/online
-}
-
-int lid_open(void)
-{
-//	/proc/acpi/button/lid/LID/state
-}
-
-void ignore_me(void)
-{
-	protect(0);
-	set_led(0);
-}
-
-int main(int argc, char **argv)
-{
-	int fd, ret;
-	struct sched_param param;
-
-	if (argc == 1)
-		ret = set_unload_heads_path("/dev/sda");
-	else if (argc == 2)
-		ret = set_unload_heads_path(argv[1]);
-	else
-		ret = -EINVAL;
-
-	if (ret || !valid_disk()) {
-		fprintf(stderr, "usage: %s <device> (default: /dev/sda)\n",
-				argv[0]);
-		exit(1);
-	}
-
-	fd = open("/dev/freefall", O_RDONLY);
-	if (fd < 0) {
-		perror("/dev/freefall");
-		return EXIT_FAILURE;
-	}
-
-	daemon(0, 0);
-	param.sched_priority = sched_get_priority_max(SCHED_FIFO);
-	sched_setscheduler(0, SCHED_FIFO, &param);
-	mlockall(MCL_CURRENT|MCL_FUTURE);
-
-	signal(SIGALRM, ignore_me);
-
-	for (;;) {
-		unsigned char count;
-
-		ret = read(fd, &count, sizeof(count));
-		alarm(0);
-		if ((ret == -1) && (errno == EINTR)) {
-			/* Alarm expired, time to unpark the heads */
-			continue;
-		}
-
-		if (ret != sizeof(count)) {
-			perror("read");
-			break;
-		}
-
-		protect(21);
-		set_led(1);
-		if (1 || on_ac() || lid_open())
-			alarm(2);
-		else
-			alarm(20);
-	}
-
-	close(fd);
-	return EXIT_SUCCESS;
-}
-- 
1.7.9.5

