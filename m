Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab3IZXNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 19:13:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57548 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab3IZXNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 19:13:10 -0400
Date: Thu, 26 Sep 2013 16:12:56 -0700
From: tip-bot for Kees Cook <tipbot@zytor.com>
Message-ID: <tip-809373e29a183e4d4f0e4f56ef8b211c6219123c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        keescook@chromium.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20130906181532.GA31260@www.outflux.net>
References: <20130906181532.GA31260@www.outflux.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/build] x86, build:
  move build output statistics away from stderr
Git-Commit-ID: 809373e29a183e4d4f0e4f56ef8b211c6219123c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 26 Sep 2013 16:13:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  809373e29a183e4d4f0e4f56ef8b211c6219123c
Gitweb:     http://git.kernel.org/tip/809373e29a183e4d4f0e4f56ef8b211c6219123c
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Fri, 6 Sep 2013 11:15:32 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 26 Sep 2013 14:05:41 -0700

x86, build: move build output statistics away from stderr

When building on x86, the final image building step always emits stats
to stderr, even though this information is neither a warning nor an error:

  BUILD   arch/x86/boot/bzImage
Setup is 16188 bytes (padded to 16384 bytes).
System is 6368 kB
CRC cbe50c61

Validating automated builds would be cleaner if stderr did not have to
filter out these lines. Instead, change how tools/build is called, and
make the zoffset header unconditional, and write to a specified file
instead of to stdout, which can then be used for statistics, leaving
stderr open for legitimate warnings and errors, like the output from
die().

Signed-off-by: Kees Cook <keescook@chromium.org>
Link: http://lkml.kernel.org/r/20130906181532.GA31260@www.outflux.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/Makefile      |  3 ++-
 arch/x86/boot/tools/build.c | 40 ++++++++++++++++++++++++----------------
 2 files changed, 26 insertions(+), 17 deletions(-)

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
