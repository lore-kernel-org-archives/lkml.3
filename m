Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab3KKRPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 12:15:14 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:59901 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab3KKRPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 12:15:06 -0500
Date: Mon, 11 Nov 2013 18:15:03 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/build changes for v3.13
Message-ID: <20131111171503.GA12932@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-build-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-build-for-linus

   # HEAD: 7f71be4c9f9a334e7bd0adc66225db4eb88c3bc4 x86, defconfig: Add DEVTMPFS and DEVTMPFS_MOUNT to *86*_defconfig

Two small changes.

 Thanks,

	Ingo

------------------>
Chen Gang (1):
      x86, defconfig: Add DEVTMPFS and DEVTMPFS_MOUNT to *86*_defconfig

Kees Cook (1):
      x86, build: move build output statistics away from stderr


 arch/x86/boot/Makefile            |  3 ++-
 arch/x86/boot/tools/build.c       | 40 +++++++++++++++++++++++----------------
 arch/x86/configs/i386_defconfig   |  2 ++
 arch/x86/configs/x86_64_defconfig |  2 ++
 4 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 379814b..dce69a2 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -71,7 +71,8 @@ GCOV_PROFILE := n
 $(obj)/bzImage: asflags-y  := $(SVGA_MODE)
 
 quiet_cmd_image = BUILD   $@
-cmd_image = $(obj)/tools/build $(obj)/setup.bin $(obj)/vmlinux.bin $(obj)/zoffset.h > $@
+cmd_image = $(obj)/tools/build $(obj)/setup.bin $(obj)/vmlinux.bin \
+			       $(obj)/zoffset.h $@
 
 $(obj)/bzImage: $(obj)/setup.bin $(obj)/vmlinux.bin $(obj)/tools/build FORCE
 	$(call if_changed,image)
diff --git a/arch/x86/boot/tools/build.c b/arch/x86/boot/tools/build.c
index c941d6a..8e15b22 100644
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -5,14 +5,15 @@
  */
 
 /*
- * This file builds a disk-image from two different files:
+ * This file builds a disk-image from three different files:
  *
  * - setup: 8086 machine code, sets up system parm
  * - system: 80386 code for actual system
+ * - zoffset.h: header with ZO_* defines
  *
- * It does some checking that all files are of the correct type, and
- * just writes the result to stdout, removing headers and padding to
- * the right amount. It also writes some system data to stderr.
+ * It does some checking that all files are of the correct type, and writes
+ * the result to the specified destination, removing headers and padding to
+ * the right amount. It also writes some system data to stdout.
  */
 
 /*
@@ -136,7 +137,7 @@ static void die(const char * str, ...)
 
 static void usage(void)
 {
-	die("Usage: build setup system [zoffset.h] [> image]");
+	die("Usage: build setup system zoffset.h image");
 }
 
 #ifdef CONFIG_EFI_STUB
@@ -265,7 +266,7 @@ int main(int argc, char ** argv)
 	int c;
 	u32 sys_size;
 	struct stat sb;
-	FILE *file;
+	FILE *file, *dest;
 	int fd;
 	void *kernel;
 	u32 crc = 0xffffffffUL;
@@ -280,10 +281,13 @@ int main(int argc, char ** argv)
 	startup_64 = 0x200;
 #endif
 
-	if (argc == 4)
-		parse_zoffset(argv[3]);
-	else if (argc != 3)
+	if (argc != 5)
 		usage();
+	parse_zoffset(argv[3]);
+
+	dest = fopen(argv[4], "w");
+	if (!dest)
+		die("Unable to write `%s': %m", argv[4]);
 
 	/* Copy the setup code */
 	file = fopen(argv[1], "r");
@@ -318,7 +322,7 @@ int main(int argc, char ** argv)
 	/* Set the default root device */
 	put_unaligned_le16(DEFAULT_ROOT_DEV, &buf[508]);
 
-	fprintf(stderr, "Setup is %d bytes (padded to %d bytes).\n", c, i);
+	printf("Setup is %d bytes (padded to %d bytes).\n", c, i);
 
 	/* Open and stat the kernel file */
 	fd = open(argv[2], O_RDONLY);
@@ -327,7 +331,7 @@ int main(int argc, char ** argv)
 	if (fstat(fd, &sb))
 		die("Unable to stat `%s': %m", argv[2]);
 	sz = sb.st_size;
-	fprintf (stderr, "System is %d kB\n", (sz+1023)/1024);
+	printf("System is %d kB\n", (sz+1023)/1024);
 	kernel = mmap(NULL, sz, PROT_READ, MAP_SHARED, fd, 0);
 	if (kernel == MAP_FAILED)
 		die("Unable to mmap '%s': %m", argv[2]);
@@ -348,27 +352,31 @@ int main(int argc, char ** argv)
 #endif
 
 	crc = partial_crc32(buf, i, crc);
-	if (fwrite(buf, 1, i, stdout) != i)
+	if (fwrite(buf, 1, i, dest) != i)
 		die("Writing setup failed");
 
 	/* Copy the kernel code */
 	crc = partial_crc32(kernel, sz, crc);
-	if (fwrite(kernel, 1, sz, stdout) != sz)
+	if (fwrite(kernel, 1, sz, dest) != sz)
 		die("Writing kernel failed");
 
 	/* Add padding leaving 4 bytes for the checksum */
 	while (sz++ < (sys_size*16) - 4) {
 		crc = partial_crc32_one('\0', crc);
-		if (fwrite("\0", 1, 1, stdout) != 1)
+		if (fwrite("\0", 1, 1, dest) != 1)
 			die("Writing padding failed");
 	}
 
 	/* Write the CRC */
-	fprintf(stderr, "CRC %x\n", crc);
+	printf("CRC %x\n", crc);
 	put_unaligned_le32(crc, buf);
-	if (fwrite(buf, 1, 4, stdout) != 4)
+	if (fwrite(buf, 1, 4, dest) != 4)
 		die("Writing CRC failed");
 
+	/* Catch any delayed write failures */
+	if (fclose(dest))
+		die("Writing image failed");
+
 	close(fd);
 
 	/* Everything is OK */
diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index 9444708..a7fef26 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -142,6 +142,8 @@ CONFIG_MAC80211=y
 CONFIG_MAC80211_LEDS=y
 CONFIG_RFKILL=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
+CONFIG_DEVTMPFS=y
+CONFIG_DEVTMPFS_MOUNT=y
 CONFIG_DEBUG_DEVRES=y
 CONFIG_CONNECTOR=y
 CONFIG_BLK_DEV_LOOP=y
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index 671524d..c1119d4 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -141,6 +141,8 @@ CONFIG_MAC80211=y
 CONFIG_MAC80211_LEDS=y
 CONFIG_RFKILL=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
+CONFIG_DEVTMPFS=y
+CONFIG_DEVTMPFS_MOUNT=y
 CONFIG_DEBUG_DEVRES=y
 CONFIG_CONNECTOR=y
 CONFIG_BLK_DEV_LOOP=y
