Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbaFZUko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 16:40:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbaFZUkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 16:40:43 -0400
Date: Thu, 26 Jun 2014 16:39:59 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Cc: ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org, greg@kroah.com,
        bp@alien8.de, dyoung@redhat.com, chaowang@redhat.com, bhe@redhat.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH 00/15][V4] kexec: A new system call to allow in kernel
 loading
Message-ID: <20140626203958.GD11136@redhat.com>
References: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 04:33:29PM -0400, Vivek Goyal wrote:
> Hi,
> 
> This is V4 of the patchset. Previous versions were posted here.
> 
> V1: https://lkml.org/lkml/2013/11/20/540
> V2: https://lkml.org/lkml/2014/1/27/331
> V3: https://lkml.org/lkml/2014/6/3/432
>

I used following kexec-tools patch to test my changes.

Thanks
Vivek

kexec-tools: Provide an option to make use of new system call

This patch provides and option --kexec-file-syscall, to force use of
new system call for kexec. Default is to continue to use old syscall.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 kexec/arch/x86_64/kexec-bzImage64.c |   86 +++++++++++++++++++++++
 kexec/kexec-syscall.h               |   32 ++++++++
 kexec/kexec.c                       |  132 +++++++++++++++++++++++++++++++++++-
 kexec/kexec.h                       |   11 ++-
 4 files changed, 257 insertions(+), 4 deletions(-)

Index: kexec-tools/kexec/kexec.c
===================================================================
--- kexec-tools.orig/kexec/kexec.c	2014-06-17 13:15:37.723825990 -0400
+++ kexec-tools/kexec/kexec.c	2014-06-26 15:19:59.064940065 -0400
@@ -51,6 +51,8 @@
 unsigned long long mem_min = 0;
 unsigned long long mem_max = ULONG_MAX;
 static unsigned long kexec_flags = 0;
+/* Flags for kexec file (fd) based syscall */
+static unsigned long kexec_file_flags = 0;
 int kexec_debug = 0;
 
 void dbgprint_mem_range(const char *prefix, struct memory_range *mr, int nr_mr)
@@ -787,6 +789,19 @@ static int my_load(const char *type, int
 	return result;
 }
 
+static int kexec_file_unload(unsigned long kexec_file_flags)
+{
+	int ret = 0;
+
+	ret = kexec_file_load(-1, -1, 0, NULL, kexec_file_flags);
+	if (ret != 0) {
+		/* The unload failed, print some debugging information */
+		fprintf(stderr, "kexec_file_load(unload) failed\n: %s\n",
+			strerror(errno));
+	}
+	return ret;
+}
+
 static int k_unload (unsigned long kexec_flags)
 {
 	int result;
@@ -925,6 +940,7 @@ void usage(void)
 	       "                      (0 means it's not jump back or\n"
 	       "                      preserve context)\n"
 	       "                      to original kernel.\n"
+	       " -s --kexec-file-syscall Use file based syscall for kexec operation\n"
 	       " -d, --debug           Enable debugging to help spot a failure.\n"
 	       "\n"
 	       "Supported kernel file types and options: \n");
@@ -1072,6 +1088,82 @@ char *concat_cmdline(const char *base, c
 	return cmdline;
 }
 
+/* New file based kexec system call related code */
+static int do_kexec_file_load(int fileind, int argc, char **argv,
+			unsigned long flags) {
+
+	char *kernel;
+	int kernel_fd, i;
+	struct kexec_info info;
+	int ret = 0;
+	char *kernel_buf;
+	off_t kernel_size;
+
+	memset(&info, 0, sizeof(info));
+	info.segment = NULL;
+	info.nr_segments = 0;
+	info.entry = NULL;
+	info.backup_start = 0;
+	info.kexec_flags = flags;
+
+	info.file_mode = 1;
+	info.initrd_fd = -1;
+
+	if (argc - fileind <= 0) {
+		fprintf(stderr, "No kernel specified\n");
+		usage();
+		return -1;
+	}
+
+	kernel = argv[fileind];
+
+	kernel_fd = open(kernel, O_RDONLY);
+	if (kernel_fd == -1) {
+		fprintf(stderr, "Failed to open file %s:%s\n", kernel,
+				strerror(errno));
+		return -1;
+	}
+
+	/* slurp in the input kernel */
+	kernel_buf = slurp_decompress_file(kernel, &kernel_size);
+
+	for (i = 0; i < file_types; i++) {
+		if (file_type[i].probe(kernel_buf, kernel_size) >= 0)
+			break;
+	}
+
+	if (i == file_types) {
+		fprintf(stderr, "Cannot determine the file type " "of %s\n",
+				kernel);
+		return -1;
+	}
+
+	ret = file_type[i].load(argc, argv, kernel_buf, kernel_size, &info);
+	if (ret < 0) {
+		fprintf(stderr, "Cannot load %s\n", kernel);
+		return ret;
+	}
+
+	if (!is_kexec_file_load_implemented()) {
+		fprintf(stderr, "syscall kexec_file_load not available.\n");
+		return -1;
+	}
+
+	/*
+	 * If there is no initramfs, set KEXEC_FILE_NO_INITRAMFS flag so that
+	 * kernel does not return error with negative initrd_fd.
+	 */
+	if (info.initrd_fd == -1)
+		info.kexec_flags |= KEXEC_FILE_NO_INITRAMFS;
+
+	ret = kexec_file_load(kernel_fd, info.initrd_fd, info.command_line_len,
+			info.command_line, info.kexec_flags);
+	if (ret != 0)
+		fprintf(stderr, "kexec_file_load failed: %s\n",
+					strerror(errno));
+	return ret;
+}
+
 
 int main(int argc, char *argv[])
 {
@@ -1083,6 +1175,7 @@ int main(int argc, char *argv[])
 	int do_ifdown = 0;
 	int do_unload = 0;
 	int do_reuse_initrd = 0;
+	int do_kexec_file_syscall = 0;
 	void *entry = 0;
 	char *type = 0;
 	char *endptr;
@@ -1095,6 +1188,23 @@ int main(int argc, char *argv[])
 	};
 	static const char short_options[] = KEXEC_ALL_OPT_STR;
 
+	/*
+	 * First check if --use-kexec-file-syscall is set. That changes lot of
+	 * things
+	 */
+	while ((opt = getopt_long(argc, argv, short_options,
+				  options, 0)) != -1) {
+		switch(opt) {
+		case OPT_KEXEC_FILE_SYSCALL:
+			do_kexec_file_syscall = 1;
+			break;
+		}
+	}
+
+	/* Reset getopt for the next pass. */
+	opterr = 1;
+	optind = 1;
+
 	while ((opt = getopt_long(argc, argv, short_options,
 				  options, 0)) != -1) {
 		switch(opt) {
@@ -1127,6 +1237,8 @@ int main(int argc, char *argv[])
 			do_shutdown = 0;
 			do_sync = 0;
 			do_unload = 1;
+			if (do_kexec_file_syscall)
+				kexec_file_flags |= KEXEC_FILE_UNLOAD;
 			break;
 		case OPT_EXEC:
 			do_load = 0;
@@ -1169,7 +1281,10 @@ int main(int argc, char *argv[])
 			do_exec = 0;
 			do_shutdown = 0;
 			do_sync = 0;
-			kexec_flags = KEXEC_ON_CRASH;
+			if (do_kexec_file_syscall)
+				kexec_file_flags |= KEXEC_FILE_ON_CRASH;
+			else
+				kexec_flags = KEXEC_ON_CRASH;
 			break;
 		case OPT_MEM_MIN:
 			mem_min = strtoul(optarg, &endptr, 0);
@@ -1194,6 +1309,9 @@ int main(int argc, char *argv[])
 		case OPT_REUSE_INITRD:
 			do_reuse_initrd = 1;
 			break;
+		case OPT_KEXEC_FILE_SYSCALL:
+			/* We already parsed it. Nothing to do. */
+			break;
 		default:
 			break;
 		}
@@ -1238,10 +1356,18 @@ int main(int argc, char *argv[])
 	}
 
 	if (do_unload) {
-		result = k_unload(kexec_flags);
+		if (do_kexec_file_syscall)
+			result = kexec_file_unload(kexec_file_flags);
+		else
+			result = k_unload(kexec_flags);
 	}
 	if (do_load && (result == 0)) {
-		result = my_load(type, fileind, argc, argv, kexec_flags, entry);
+		if (do_kexec_file_syscall)
+			result = do_kexec_file_load(fileind, argc, argv,
+						 kexec_file_flags);
+		else
+			result = my_load(type, fileind, argc, argv,
+						kexec_flags, entry);
 	}
 	/* Don't shutdown unless there is something to reboot to! */
 	if ((result == 0) && (do_shutdown || do_exec) && !kexec_loaded()) {
Index: kexec-tools/kexec/kexec.h
===================================================================
--- kexec-tools.orig/kexec/kexec.h	2014-06-17 13:15:37.723825990 -0400
+++ kexec-tools/kexec/kexec.h	2014-06-17 13:44:14.634927130 -0400
@@ -156,6 +156,13 @@ struct kexec_info {
 	unsigned long kexec_flags;
 	unsigned long backup_src_start;
 	unsigned long backup_src_size;
+	/* Set to 1 if we are using kexec file syscall */
+	unsigned long file_mode :1;
+
+	/* Filled by kernel image processing code */
+	int initrd_fd;
+	char *command_line;
+	int command_line_len;
 };
 
 struct arch_map_entry {
@@ -207,6 +214,7 @@ extern int file_types;
 #define OPT_UNLOAD		'u'
 #define OPT_TYPE		't'
 #define OPT_PANIC		'p'
+#define OPT_KEXEC_FILE_SYSCALL	's'
 #define OPT_MEM_MIN             256
 #define OPT_MEM_MAX             257
 #define OPT_REUSE_INITRD	258
@@ -230,9 +238,10 @@ extern int file_types;
 	{ "mem-min",		1, 0, OPT_MEM_MIN }, \
 	{ "mem-max",		1, 0, OPT_MEM_MAX }, \
 	{ "reuseinitrd",	0, 0, OPT_REUSE_INITRD }, \
+	{ "kexec-file-syscall",	0, 0, OPT_KEXEC_FILE_SYSCALL }, \
 	{ "debug",		0, 0, OPT_DEBUG }, \
 
-#define KEXEC_OPT_STR "h?vdfxluet:p"
+#define KEXEC_OPT_STR "h?vdfxluet:ps"
 
 extern void dbgprint_mem_range(const char *prefix, struct memory_range *mr, int nr_mr);
 extern void die(const char *fmt, ...)
Index: kexec-tools/kexec/arch/x86_64/kexec-bzImage64.c
===================================================================
--- kexec-tools.orig/kexec/arch/x86_64/kexec-bzImage64.c	2014-06-17 13:15:37.723825990 -0400
+++ kexec-tools/kexec/arch/x86_64/kexec-bzImage64.c	2014-06-17 13:17:39.916833188 -0400
@@ -235,6 +235,89 @@ static int do_bzImage64_load(struct kexe
 	return 0;
 }
 
+/* This assumes file is being loaded using file based kexec2 syscall */
+int bzImage64_load_file(int argc, char **argv, struct kexec_info *info)
+{
+	int ret = 0;
+	char *command_line = NULL, *tmp_cmdline = NULL;
+	const char *ramdisk = NULL, *append = NULL;
+	int entry_16bit = 0, entry_32bit = 0;
+	int opt;
+	int command_line_len;
+
+	/* See options.h -- add any more there, too. */
+	static const struct option options[] = {
+		KEXEC_ARCH_OPTIONS
+		{ "command-line",	1, 0, OPT_APPEND },
+		{ "append",		1, 0, OPT_APPEND },
+		{ "reuse-cmdline",	0, 0, OPT_REUSE_CMDLINE },
+		{ "initrd",		1, 0, OPT_RAMDISK },
+		{ "ramdisk",		1, 0, OPT_RAMDISK },
+		{ "real-mode",		0, 0, OPT_REAL_MODE },
+		{ "entry-32bit",	0, 0, OPT_ENTRY_32BIT },
+		{ 0,			0, 0, 0 },
+	};
+	static const char short_options[] = KEXEC_ARCH_OPT_STR "d";
+
+	while ((opt = getopt_long(argc, argv, short_options, options, 0)) != -1) {
+		switch (opt) {
+		default:
+			/* Ignore core options */
+			if (opt < OPT_ARCH_MAX)
+				break;
+		case OPT_APPEND:
+			append = optarg;
+			break;
+		case OPT_REUSE_CMDLINE:
+			tmp_cmdline = get_command_line();
+			break;
+		case OPT_RAMDISK:
+			ramdisk = optarg;
+			break;
+		case OPT_REAL_MODE:
+			entry_16bit = 1;
+			break;
+		case OPT_ENTRY_32BIT:
+			entry_32bit = 1;
+			break;
+		}
+	}
+	command_line = concat_cmdline(tmp_cmdline, append);
+	if (tmp_cmdline)
+		free(tmp_cmdline);
+	command_line_len = 0;
+	if (command_line) {
+		command_line_len = strlen(command_line) + 1;
+	} else {
+		command_line = strdup("\0");
+		command_line_len = 1;
+	}
+
+	if (entry_16bit || entry_32bit) {
+		fprintf(stderr, "Kexec2 syscall does not support 16bit"
+			" or 32bit entry yet\n");
+		ret = -1;
+		goto out;
+	}
+
+	if (ramdisk) {
+		info->initrd_fd = open(ramdisk, O_RDONLY);
+		if (info->initrd_fd == -1) {
+			fprintf(stderr, "Could not open initrd file %s:%s\n",
+					ramdisk, strerror(errno));
+			ret = -1;
+			goto out;
+		}
+	}
+
+	info->command_line = command_line;
+	info->command_line_len = command_line_len;
+	return ret;
+out:
+	free(command_line);
+	return ret;
+}
+
 int bzImage64_load(int argc, char **argv, const char *buf, off_t len,
 	struct kexec_info *info)
 {
@@ -247,6 +330,9 @@ int bzImage64_load(int argc, char **argv
 	int opt;
 	int result;
 
+	if (info->file_mode)
+		return bzImage64_load_file(argc, argv, info);
+
 	/* See options.h -- add any more there, too. */
 	static const struct option options[] = {
 		KEXEC_ARCH_OPTIONS
Index: kexec-tools/kexec/kexec-syscall.h
===================================================================
--- kexec-tools.orig/kexec/kexec-syscall.h	2014-06-17 13:15:37.723825990 -0400
+++ kexec-tools/kexec/kexec-syscall.h	2014-06-26 15:19:59.063940065 -0400
@@ -53,6 +53,19 @@
 #endif
 #endif /*ifndef __NR_kexec_load*/
 
+#ifndef __NR_kexec_file_load
+
+#ifdef __x86_64__
+#define __NR_kexec_file_load	317
+#endif
+
+#ifndef __NR_kexec_file_load
+/* system call not available for the arch */
+#define __NR_kexec_file_load	0xffffffff	/* system call not available */
+#endif
+
+#endif /*ifndef __NR_kexec_file_load*/
+
 struct kexec_segment;
 
 static inline long kexec_load(void *entry, unsigned long nr_segments,
@@ -61,10 +74,29 @@ static inline long kexec_load(void *entr
 	return (long) syscall(__NR_kexec_load, entry, nr_segments, segments, flags);
 }
 
+static inline int is_kexec_file_load_implemented(void) {
+	if (__NR_kexec_file_load != 0xffffffff)
+		return 1;
+	return 0;
+}
+
+static inline long kexec_file_load(int kernel_fd, int initrd_fd,
+			unsigned long cmdline_len, const char *cmdline_ptr,
+			unsigned long flags)
+{
+	return (long) syscall(__NR_kexec_file_load, kernel_fd, initrd_fd,
+				cmdline_len, cmdline_ptr, flags);
+}
+
 #define KEXEC_ON_CRASH		0x00000001
 #define KEXEC_PRESERVE_CONTEXT	0x00000002
 #define KEXEC_ARCH_MASK		0xffff0000
 
+/* Flags for kexec file based system call */
+#define KEXEC_FILE_UNLOAD	0x00000001
+#define KEXEC_FILE_ON_CRASH	0x00000002
+#define KEXEC_FILE_NO_INITRAMFS	0x00000004
+
 /* These values match the ELF architecture values. 
  * Unless there is a good reason that should continue to be the case.
  */
