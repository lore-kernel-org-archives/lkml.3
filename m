Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbaAUNvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 08:51:01 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:57360 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbaAUNuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 08:50:12 -0500
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>
Subject: [PATCH 2/3] scripts/dtc: Update to upstream version v1.4.0
Date: Tue, 21 Jan 2014 13:50:00 +0000
Message-Id: <1390312201-22754-3-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1390312201-22754-1-git-send-email-grant.likely@linaro.org>
References: <1390312201-22754-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update to the latest version of dtc with the following notable
enhancements and bug fixes:

* fdtput: expand fdt if value does not fit
* dtc/fdt{get, put}/convert-dtsv0-lexer: convert to new usage helpers
* libfdt: Add fdt_next_subnode() to permit easy subnode iteration
* utilfdt_read: pass back up the length of data read
* util_version: new helper for displaying version info
* die: constify format string arg
* utilfdt_read_err: use xmalloc funcs
* Export fdt_stringlist_contains()
* dtc: Drop the '-S is deprecated' warning
* dtc/libfdt: sparse fixes
* dtc/libfdt: introduce fdt types for annotation by endian checkers
* Fix util_is_printable_string
* dtc: srcpos_verror() should print to stderr
* libfdt: Added missing functions to shared library

Shipped bison/flex generated files were built on an Ubuntu 13.10 system.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
---
 scripts/dtc/dtc.c         | 119 +++++++++++++++++++-------------------
 scripts/dtc/dtc.h         |   1 -
 scripts/dtc/srcpos.c      |   6 +-
 scripts/dtc/util.c        | 141 ++++++++++++++++++++++++++++++++++++++++++----
 scripts/dtc/util.h        | 107 +++++++++++++++++++++++++++++++++--
 scripts/dtc/version_gen.h |   2 +-
 6 files changed, 294 insertions(+), 82 deletions(-)

diff --git a/scripts/dtc/dtc.c b/scripts/dtc/dtc.c
index a375683c1534..e3c96536fd9d 100644
--- a/scripts/dtc/dtc.c
+++ b/scripts/dtc/dtc.c
@@ -21,8 +21,6 @@
 #include "dtc.h"
 #include "srcpos.h"
 
-#include "version_gen.h"
-
 /*
  * Command line options
  */
@@ -49,55 +47,60 @@ static void fill_fullpaths(struct node *tree, const char *prefix)
 		fill_fullpaths(child, tree->fullpath);
 }
 
-static void  __attribute__ ((noreturn)) usage(void)
-{
-	fprintf(stderr, "Usage:\n");
-	fprintf(stderr, "\tdtc [options] <input file>\n");
-	fprintf(stderr, "\nOptions:\n");
-	fprintf(stderr, "\t-h\n");
-	fprintf(stderr, "\t\tThis help text\n");
-	fprintf(stderr, "\t-q\n");
-	fprintf(stderr, "\t\tQuiet: -q suppress warnings, -qq errors, -qqq all\n");
-	fprintf(stderr, "\t-I <input format>\n");
-	fprintf(stderr, "\t\tInput formats are:\n");
-	fprintf(stderr, "\t\t\tdts - device tree source text\n");
-	fprintf(stderr, "\t\t\tdtb - device tree blob\n");
-	fprintf(stderr, "\t\t\tfs - /proc/device-tree style directory\n");
-	fprintf(stderr, "\t-o <output file>\n");
-	fprintf(stderr, "\t-O <output format>\n");
-	fprintf(stderr, "\t\tOutput formats are:\n");
-	fprintf(stderr, "\t\t\tdts - device tree source text\n");
-	fprintf(stderr, "\t\t\tdtb - device tree blob\n");
-	fprintf(stderr, "\t\t\tasm - assembler source\n");
-	fprintf(stderr, "\t-V <output version>\n");
-	fprintf(stderr, "\t\tBlob version to produce, defaults to %d (relevant for dtb\n\t\tand asm output only)\n", DEFAULT_FDT_VERSION);
-	fprintf(stderr, "\t-d <output dependency file>\n");
-	fprintf(stderr, "\t-R <number>\n");
-	fprintf(stderr, "\t\tMake space for <number> reserve map entries (relevant for \n\t\tdtb and asm output only)\n");
-	fprintf(stderr, "\t-S <bytes>\n");
-	fprintf(stderr, "\t\tMake the blob at least <bytes> long (extra space)\n");
-	fprintf(stderr, "\t-p <bytes>\n");
-	fprintf(stderr, "\t\tAdd padding to the blob of <bytes> long (extra space)\n");
-	fprintf(stderr, "\t-b <number>\n");
-	fprintf(stderr, "\t\tSet the physical boot cpu\n");
-	fprintf(stderr, "\t-f\n");
-	fprintf(stderr, "\t\tForce - try to produce output even if the input tree has errors\n");
-	fprintf(stderr, "\t-i\n");
-	fprintf(stderr, "\t\tAdd a path to search for include files\n");
-	fprintf(stderr, "\t-s\n");
-	fprintf(stderr, "\t\tSort nodes and properties before outputting (only useful for\n\t\tcomparing trees)\n");
-	fprintf(stderr, "\t-v\n");
-	fprintf(stderr, "\t\tPrint DTC version and exit\n");
-	fprintf(stderr, "\t-H <phandle format>\n");
-	fprintf(stderr, "\t\tphandle formats are:\n");
-	fprintf(stderr, "\t\t\tlegacy - \"linux,phandle\" properties only\n");
-	fprintf(stderr, "\t\t\tepapr - \"phandle\" properties only\n");
-	fprintf(stderr, "\t\t\tboth - Both \"linux,phandle\" and \"phandle\" properties\n");
-	fprintf(stderr, "\t-W [no-]<checkname>\n");
-	fprintf(stderr, "\t-E [no-]<checkname>\n");
-	fprintf(stderr, "\t\t\tenable or disable warnings and errors\n");
-	exit(3);
-}
+/* Usage related data. */
+static const char usage_synopsis[] = "dtc [options] <input file>";
+static const char usage_short_opts[] = "qI:O:o:V:d:R:S:p:fb:i:H:sW:E:hv";
+static struct option const usage_long_opts[] = {
+	{"quiet",            no_argument, NULL, 'q'},
+	{"in-format",         a_argument, NULL, 'I'},
+	{"out",               a_argument, NULL, 'o'},
+	{"out-format",        a_argument, NULL, 'O'},
+	{"out-version",       a_argument, NULL, 'V'},
+	{"out-dependency",    a_argument, NULL, 'd'},
+	{"reserve",           a_argument, NULL, 'R'},
+	{"space",             a_argument, NULL, 'S'},
+	{"pad",               a_argument, NULL, 'p'},
+	{"boot-cpu",          a_argument, NULL, 'b'},
+	{"force",            no_argument, NULL, 'f'},
+	{"include",           a_argument, NULL, 'i'},
+	{"sort",             no_argument, NULL, 's'},
+	{"phandle",           a_argument, NULL, 'H'},
+	{"warning",           a_argument, NULL, 'W'},
+	{"error",             a_argument, NULL, 'E'},
+	{"help",             no_argument, NULL, 'h'},
+	{"version",          no_argument, NULL, 'v'},
+	{NULL,               no_argument, NULL, 0x0},
+};
+static const char * const usage_opts_help[] = {
+	"\n\tQuiet: -q suppress warnings, -qq errors, -qqq all",
+	"\n\tInput formats are:\n"
+	 "\t\tdts - device tree source text\n"
+	 "\t\tdtb - device tree blob\n"
+	 "\t\tfs  - /proc/device-tree style directory",
+	"\n\tOutput file",
+	"\n\tOutput formats are:\n"
+	 "\t\tdts - device tree source text\n"
+	 "\t\tdtb - device tree blob\n"
+	 "\t\tasm - assembler source",
+	"\n\tBlob version to produce, defaults to %d (for dtb and asm output)", //, DEFAULT_FDT_VERSION);
+	"\n\tOutput dependency file",
+	"\n\ttMake space for <number> reserve map entries (for dtb and asm output)",
+	"\n\tMake the blob at least <bytes> long (extra space)",
+	"\n\tAdd padding to the blob of <bytes> long (extra space)",
+	"\n\tSet the physical boot cpu",
+	"\n\tTry to produce output even if the input tree has errors",
+	"\n\tAdd a path to search for include files",
+	"\n\tSort nodes and properties before outputting (useful for comparing trees)",
+	"\n\tValid phandle formats are:\n"
+	 "\t\tlegacy - \"linux,phandle\" properties only\n"
+	 "\t\tepapr  - \"phandle\" properties only\n"
+	 "\t\tboth   - Both \"linux,phandle\" and \"phandle\" properties",
+	"\n\tEnable/disable warnings (prefix with \"no-\")",
+	"\n\tEnable/disable errors (prefix with \"no-\")",
+	"\n\tPrint this help and exit",
+	"\n\tPrint version and exit",
+	NULL,
+};
 
 int main(int argc, char *argv[])
 {
@@ -118,8 +121,7 @@ int main(int argc, char *argv[])
 	minsize    = 0;
 	padsize    = 0;
 
-	while ((opt = getopt(argc, argv, "hI:O:o:V:d:R:S:p:fqb:i:vH:sW:E:"))
-			!= EOF) {
+	while ((opt = util_getopt_long()) != EOF) {
 		switch (opt) {
 		case 'I':
 			inform = optarg;
@@ -158,8 +160,7 @@ int main(int argc, char *argv[])
 			srcfile_add_search_path(optarg);
 			break;
 		case 'v':
-			printf("Version: %s\n", DTC_VERSION);
-			exit(0);
+			util_version();
 		case 'H':
 			if (streq(optarg, "legacy"))
 				phandle_format = PHANDLE_LEGACY;
@@ -185,13 +186,14 @@ int main(int argc, char *argv[])
 			break;
 
 		case 'h':
+			usage(NULL);
 		default:
-			usage();
+			usage("unknown option");
 		}
 	}
 
 	if (argc > (optind+1))
-		usage();
+		usage("missing files");
 	else if (argc < (optind+1))
 		arg = "-";
 	else
@@ -201,9 +203,6 @@ int main(int argc, char *argv[])
 	if (minsize && padsize)
 		die("Can't set both -p and -S\n");
 
-	if (minsize)
-		fprintf(stderr, "DTC: Use of \"-S\" is deprecated; it will be removed soon, use \"-p\" instead\n");
-
 	if (depname) {
 		depfile = fopen(depname, "w");
 		if (!depfile)
diff --git a/scripts/dtc/dtc.h b/scripts/dtc/dtc.h
index 3e42a071070e..264a20cf66a8 100644
--- a/scripts/dtc/dtc.h
+++ b/scripts/dtc/dtc.h
@@ -66,7 +66,6 @@ typedef uint32_t cell_t;
 #define strneq(a, b, n)	(strncmp((a), (b), (n)) == 0)
 
 #define ALIGN(x, a)	(((x) + (a) - 1) & ~((a) - 1))
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 
 /* Data blobs */
 enum markertype {
diff --git a/scripts/dtc/srcpos.c b/scripts/dtc/srcpos.c
index 246ab4bc0d9d..c20bc5315bc1 100644
--- a/scripts/dtc/srcpos.c
+++ b/scripts/dtc/srcpos.c
@@ -297,9 +297,9 @@ srcpos_verror(struct srcpos *pos, char const *fmt, va_list va)
 
        srcstr = srcpos_string(pos);
 
-       fprintf(stdout, "Error: %s ", srcstr);
-       vfprintf(stdout, fmt, va);
-       fprintf(stdout, "\n");
+       fprintf(stderr, "Error: %s ", srcstr);
+       vfprintf(stderr, fmt, va);
+       fprintf(stderr, "\n");
 }
 
 void
diff --git a/scripts/dtc/util.c b/scripts/dtc/util.c
index 2422c34e11df..3055c16e980d 100644
--- a/scripts/dtc/util.c
+++ b/scripts/dtc/util.c
@@ -34,6 +34,7 @@
 
 #include "libfdt.h"
 #include "util.h"
+#include "version_gen.h"
 
 char *xstrdup(const char *s)
 {
@@ -72,7 +73,7 @@ char *join_path(const char *path, const char *name)
 int util_is_printable_string(const void *data, int len)
 {
 	const char *s = data;
-	const char *ss;
+	const char *ss, *se;
 
 	/* zero length is not */
 	if (len == 0)
@@ -82,13 +83,19 @@ int util_is_printable_string(const void *data, int len)
 	if (s[len - 1] != '\0')
 		return 0;
 
-	ss = s;
-	while (*s && isprint(*s))
-		s++;
+	se = s + len;
 
-	/* not zero, or not done yet */
-	if (*s != '\0' || (s + 1 - ss) < len)
-		return 0;
+	while (s < se) {
+		ss = s;
+		while (s < se && *s && isprint(*s))
+			s++;
+
+		/* not zero, or not done yet */
+		if (*s != '\0' || s == ss)
+			return 0;
+
+		s++;
+	}
 
 	return 1;
 }
@@ -191,7 +198,7 @@ char get_escape_char(const char *s, int *i)
 	return val;
 }
 
-int utilfdt_read_err(const char *filename, char **buffp)
+int utilfdt_read_err_len(const char *filename, char **buffp, off_t *len)
 {
 	int fd = 0;	/* assume stdin */
 	char *buf = NULL;
@@ -206,12 +213,12 @@ int utilfdt_read_err(const char *filename, char **buffp)
 	}
 
 	/* Loop until we have read everything */
-	buf = malloc(bufsize);
+	buf = xmalloc(bufsize);
 	do {
 		/* Expand the buffer to hold the next chunk */
 		if (offset == bufsize) {
 			bufsize *= 2;
-			buf = realloc(buf, bufsize);
+			buf = xrealloc(buf, bufsize);
 			if (!buf) {
 				ret = ENOMEM;
 				break;
@@ -232,13 +239,20 @@ int utilfdt_read_err(const char *filename, char **buffp)
 		free(buf);
 	else
 		*buffp = buf;
+	*len = bufsize;
 	return ret;
 }
 
-char *utilfdt_read(const char *filename)
+int utilfdt_read_err(const char *filename, char **buffp)
+{
+	off_t len;
+	return utilfdt_read_err_len(filename, buffp, &len);
+}
+
+char *utilfdt_read_len(const char *filename, off_t *len)
 {
 	char *buff;
-	int ret = utilfdt_read_err(filename, &buff);
+	int ret = utilfdt_read_err_len(filename, &buff, len);
 
 	if (ret) {
 		fprintf(stderr, "Couldn't open blob from '%s': %s\n", filename,
@@ -249,6 +263,12 @@ char *utilfdt_read(const char *filename)
 	return buff;
 }
 
+char *utilfdt_read(const char *filename)
+{
+	off_t len;
+	return utilfdt_read_len(filename, &len);
+}
+
 int utilfdt_write_err(const char *filename, const void *blob)
 {
 	int fd = 1;	/* assume stdout */
@@ -329,3 +349,100 @@ int utilfdt_decode_type(const char *fmt, int *type, int *size)
 		return -1;
 	return 0;
 }
+
+void utilfdt_print_data(const char *data, int len)
+{
+	int i;
+	const char *p = data;
+	const char *s;
+
+	/* no data, don't print */
+	if (len == 0)
+		return;
+
+	if (util_is_printable_string(data, len)) {
+		printf(" = ");
+
+		s = data;
+		do {
+			printf("\"%s\"", s);
+			s += strlen(s) + 1;
+			if (s < data + len)
+				printf(", ");
+		} while (s < data + len);
+
+	} else if ((len % 4) == 0) {
+		const uint32_t *cell = (const uint32_t *)data;
+
+		printf(" = <");
+		for (i = 0; i < len; i += 4)
+			printf("0x%08x%s", fdt32_to_cpu(cell[i]),
+			       i < (len - 4) ? " " : "");
+		printf(">");
+	} else {
+		printf(" = [");
+		for (i = 0; i < len; i++)
+			printf("%02x%s", *p++, i < len - 1 ? " " : "");
+		printf("]");
+	}
+}
+
+void util_version(void)
+{
+	printf("Version: %s\n", DTC_VERSION);
+	exit(0);
+}
+
+void util_usage(const char *errmsg, const char *synopsis,
+		const char *short_opts, struct option const long_opts[],
+		const char * const opts_help[])
+{
+	FILE *fp = errmsg ? stderr : stdout;
+	const char a_arg[] = "<arg>";
+	size_t a_arg_len = strlen(a_arg) + 1;
+	size_t i;
+	int optlen;
+
+	fprintf(fp,
+		"Usage: %s\n"
+		"\n"
+		"Options: -[%s]\n", synopsis, short_opts);
+
+	/* prescan the --long opt length to auto-align */
+	optlen = 0;
+	for (i = 0; long_opts[i].name; ++i) {
+		/* +1 is for space between --opt and help text */
+		int l = strlen(long_opts[i].name) + 1;
+		if (long_opts[i].has_arg == a_argument)
+			l += a_arg_len;
+		if (optlen < l)
+			optlen = l;
+	}
+
+	for (i = 0; long_opts[i].name; ++i) {
+		/* helps when adding new applets or options */
+		assert(opts_help[i] != NULL);
+
+		/* first output the short flag if it has one */
+		if (long_opts[i].val > '~')
+			fprintf(fp, "      ");
+		else
+			fprintf(fp, "  -%c, ", long_opts[i].val);
+
+		/* then the long flag */
+		if (long_opts[i].has_arg == no_argument)
+			fprintf(fp, "--%-*s", optlen, long_opts[i].name);
+		else
+			fprintf(fp, "--%s %s%*s", long_opts[i].name, a_arg,
+				(int)(optlen - strlen(long_opts[i].name) - a_arg_len), "");
+
+		/* finally the help text */
+		fprintf(fp, "%s\n", opts_help[i]);
+	}
+
+	if (errmsg) {
+		fprintf(fp, "\nError: %s\n", errmsg);
+		exit(EXIT_FAILURE);
+	} else
+		exit(EXIT_SUCCESS);
+}
diff --git a/scripts/dtc/util.h b/scripts/dtc/util.h
index c8eb45d9f04b..8f40b4499359 100644
--- a/scripts/dtc/util.h
+++ b/scripts/dtc/util.h
@@ -2,6 +2,7 @@
 #define _UTIL_H
 
 #include <stdarg.h>
+#include <getopt.h>
 
 /*
  * Copyright 2011 The Chromium Authors, All Rights Reserved.
@@ -23,7 +24,9 @@
  *                                                                   USA
  */
 
-static inline void __attribute__((noreturn)) die(char * str, ...)
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
+
+static inline void __attribute__((noreturn)) die(const char *str, ...)
 {
 	va_list ap;
 
@@ -57,12 +60,14 @@ extern char *xstrdup(const char *s);
 extern char *join_path(const char *path, const char *name);
 
 /**
- * Check a string of a given length to see if it is all printable and
- * has a valid terminator.
+ * Check a property of a given length to see if it is all printable and
+ * has a valid terminator. The property can contain either a single string,
+ * or multiple strings each of non-zero length.
  *
  * @param data	The string to check
  * @param len	The string length including terminator
- * @return 1 if a valid printable string, 0 if not */
+ * @return 1 if a valid printable string, 0 if not
+ */
 int util_is_printable_string(const void *data, int len);
 
 /*
@@ -83,6 +88,13 @@ char get_escape_char(const char *s, int *i);
 char *utilfdt_read(const char *filename);
 
 /**
+ * Like utilfdt_read(), but also passes back the size of the file read.
+ *
+ * @param len		If non-NULL, the amount of data we managed to read
+ */
+char *utilfdt_read_len(const char *filename, off_t *len);
+
+/**
  * Read a device tree file into a buffer. Does not report errors, but only
  * returns them. The value returned can be passed to strerror() to obtain
  * an error message for the user.
@@ -93,6 +105,12 @@ char *utilfdt_read(const char *filename);
  */
 int utilfdt_read_err(const char *filename, char **buffp);
 
+/**
+ * Like utilfdt_read_err(), but also passes back the size of the file read.
+ *
+ * @param len		If non-NULL, the amount of data we managed to read
+ */
+int utilfdt_read_err_len(const char *filename, char **buffp, off_t *len);
 
 /**
  * Write a device tree buffer to a file. This will report any errors on
@@ -148,6 +166,85 @@ int utilfdt_decode_type(const char *fmt, int *type, int *size);
 #define USAGE_TYPE_MSG \
 	"<type>\ts=string, i=int, u=unsigned, x=hex\n" \
 	"\tOptional modifier prefix:\n" \
-	"\t\thh or b=byte, h=2 byte, l=4 byte (default)\n";
+	"\t\thh or b=byte, h=2 byte, l=4 byte (default)";
+
+/**
+ * Print property data in a readable format to stdout
+ *
+ * Properties that look like strings will be printed as strings. Otherwise
+ * the data will be displayed either as cells (if len is a multiple of 4
+ * bytes) or bytes.
+ *
+ * If len is 0 then this function does nothing.
+ *
+ * @param data	Pointers to property data
+ * @param len	Length of property data
+ */
+void utilfdt_print_data(const char *data, int len);
+
+/**
+ * Show source version and exit
+ */
+void util_version(void) __attribute__((noreturn));
+
+/**
+ * Show usage and exit
+ *
+ * This helps standardize the output of various utils.  You most likely want
+ * to use the usage() helper below rather than call this.
+ *
+ * @param errmsg	If non-NULL, an error message to display
+ * @param synopsis	The initial example usage text (and possible examples)
+ * @param short_opts	The string of short options
+ * @param long_opts	The structure of long options
+ * @param opts_help	An array of help strings (should align with long_opts)
+ */
+void util_usage(const char *errmsg, const char *synopsis,
+		const char *short_opts, struct option const long_opts[],
+		const char * const opts_help[]) __attribute__((noreturn));
+
+/**
+ * Show usage and exit
+ *
+ * If you name all your usage variables with usage_xxx, then you can call this
+ * help macro rather than expanding all arguments yourself.
+ *
+ * @param errmsg	If non-NULL, an error message to display
+ */
+#define usage(errmsg) \
+	util_usage(errmsg, usage_synopsis, usage_short_opts, \
+		   usage_long_opts, usage_opts_help)
+
+/**
+ * Call getopt_long() with standard options
+ *
+ * Since all util code runs getopt in the same way, provide a helper.
+ */
+#define util_getopt_long() getopt_long(argc, argv, usage_short_opts, \
+				       usage_long_opts, NULL)
+
+/* Helper for aligning long_opts array */
+#define a_argument required_argument
+
+/* Helper for usage_short_opts string constant */
+#define USAGE_COMMON_SHORT_OPTS "hV"
+
+/* Helper for usage_long_opts option array */
+#define USAGE_COMMON_LONG_OPTS \
+	{"help",      no_argument, NULL, 'h'}, \
+	{"version",   no_argument, NULL, 'V'}, \
+	{NULL,        no_argument, NULL, 0x0}
+
+/* Helper for usage_opts_help array */
+#define USAGE_COMMON_OPTS_HELP \
+	"Print this help and exit", \
+	"Print version and exit", \
+	NULL
+
+/* Helper for getopt case statements */
+#define case_USAGE_COMMON_FLAGS \
+	case 'h': usage(NULL); \
+	case 'V': util_version(); \
+	case '?': usage("unknown option");
 
 #endif /* _UTIL_H */
diff --git a/scripts/dtc/version_gen.h b/scripts/dtc/version_gen.h
index 6158b867df99..e0b82fe8e7de 100644
--- a/scripts/dtc/version_gen.h
+++ b/scripts/dtc/version_gen.h
@@ -1 +1 @@
-#define DTC_VERSION "DTC 1.2.0-g37c0b6a0"
+#define DTC_VERSION "DTC 1.4.0"
-- 
1.8.3.2

