Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab3GHUTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 16:19:53 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:34906 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab3GHUTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 16:19:52 -0400
Message-ID: <51DB1EE5.5040108@google.com>
Date: Mon, 08 Jul 2013 16:19:49 -0400
From: Tristan Schmelcher <tschmelcher@google.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: richard@nod.at, jdike@addtoit.com
CC: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCHv3] uml: Fix which_tmpdir failure when /dev/shm is a symlink,
 and in other edge cases
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tristan Schmelcher <tschmelcher@google.com>

which_tmpdir did the wrong thing if /dev/shm was a symlink (e.g., to /run/shm),
if there were multiple mounts on top of each other, if the mount(s) were
obscured by a later mount, or if /dev/shm was a prefix of another mount point.
This fixes these cases. Applies to 3.9.6.

Signed-off-by: Tristan Schmelcher <tschmelcher@google.com>
---
v2 had a bug where truncation of a path would cause decode_path to say that it
read one more byte than it really did, causing the terminating null to be
removed. Now simpler and safer.

--- linux-3.9.6/arch/um/os-Linux/mem.c.orig	2013-06-24 13:44:10.000000000 -0400
+++ linux-3.9.6/arch/um/os-Linux/mem.c	2013-06-24 13:45:34.000000000 -0400
@@ -53,6 +53,25 @@ static void __init find_tempdir(void)
 }
 
 /*
+ * Remove bytes from the front of the buffer and refill it so that if there's a
+ * partial string that we care about, it will be completed, and we can recognize
+ * it.
+ */
+static int pop(int fd, char *buf, size_t size, size_t npop)
+{
+	ssize_t n;
+	size_t len = strlen(&buf[npop]);
+
+	memmove(buf, &buf[npop], len + 1);
+	n = read(fd, &buf[len], size - len - 1);
+	if (n < 0)
+		return -errno;
+
+	buf[len + n] = '\0';
+	return 1;
+}
+
+/*
  * This will return 1, with the first character in buf being the
  * character following the next instance of c in the file.  This will
  * read the file as needed.  If there's an error, -errno is returned;
@@ -61,7 +80,6 @@ static void __init find_tempdir(void)
 static int next(int fd, char *buf, size_t size, char c)
 {
 	ssize_t n;
-	size_t len;
 	char *ptr;
 
 	while ((ptr = strchr(buf, c)) == NULL) {
@@ -74,20 +92,129 @@ static int next(int fd, char *buf, size_
 		buf[n] = '\0';
 	}
 
-	ptr++;
-	len = strlen(ptr);
-	memmove(buf, ptr, len + 1);
+	return pop(fd, buf, size, ptr - buf + 1);
+}
+
+/*
+ * Decode an octal-escaped and space-terminated path of the form used by
+ * /proc/mounts. May be used to decode a path in-place. "out" must be at least
+ * as large as the input. The output is always null-terminated. "len" gets the
+ * length of the output, excluding the trailing null. Returns 0 if a full path
+ * was successfully decoded, otherwise an error.
+ */
+static int decode_path(const char *in, char *out, size_t *len)
+{
+	char *first = out;
+	int c;
+	int i;
+	int ret = -EINVAL;
+	while (1) {
+		switch (*in) {
+		case '\0':
+			goto out;
+
+		case ' ':
+			ret = 0;
+			goto out;
+
+		case '\\':
+			in++;
+			c = 0;
+			for (i = 0; i < 3; i++) {
+				if (*in < '0' || *in > '7')
+					goto out;
+				c = (c << 3) | (*in++ - '0');
+			}
+			*(unsigned char *)out++ = (unsigned char) c;
+			break;
+
+		default:
+			*out++ = *in++;
+			break;
+		}
+	}
+
+out:
+	*out = '\0';
+	*len = out - first;
+	return ret;
+}
+
+/*
+ * Computes the length of s when encoded with three-digit octal escape sequences
+ * for the characters in chars.
+ */
+static size_t octal_encoded_length(const char *s, const char *chars)
+{
+	size_t len = strlen(s);
+	while ((s = strpbrk(s, chars)) != NULL) {
+		len += 3;
+		s++;
+	}
+
+	return len;
+}
+
+enum {
+	OUTCOME_NOTHING_MOUNTED,
+	OUTCOME_TMPFS_MOUNT,
+	OUTCOME_NON_TMPFS_MOUNT,
+};
+
+/* Read a line of /proc/mounts data looking for a tmpfs mount at "path". */
+static int read_mount(int fd, char *buf, size_t bufsize, const char *path,
+		      int *outcome)
+{
+	int found;
+	int match;
+	char *space;
+	size_t len;
+
+	enum {
+		MATCH_NONE,
+		MATCH_EXACT,
+		MATCH_PARENT,
+	};
+
+	found = next(fd, buf, bufsize, ' ');
+	if (found != 1)
+		return found;
 
 	/*
-	 * Refill the buffer so that if there's a partial string that we care
-	 * about, it will be completed, and we can recognize it.
+	 * If there's no following space in the buffer, then this path is
+	 * truncated, so it can't be the one we're looking for.
 	 */
-	n = read(fd, &buf[len], size - len - 1);
-	if (n < 0)
-		return -errno;
+	space = strchr(buf, ' ');
+	if (space) {
+		match = MATCH_NONE;
+		if (!decode_path(buf, buf, &len)) {
+			if (!strcmp(buf, path))
+				match = MATCH_EXACT;
+			else if (!strncmp(buf, path, len)
+				 && (path[len] == '/' || !strcmp(buf, "/")))
+				match = MATCH_PARENT;
+		}
 
-	buf[len + n] = '\0';
-	return 1;
+		found = pop(fd, buf, bufsize, space - buf + 1);
+		if (found != 1)
+			return found;
+
+		switch (match) {
+		case MATCH_EXACT:
+			if (!strncmp(buf, "tmpfs", strlen("tmpfs")))
+				*outcome = OUTCOME_TMPFS_MOUNT;
+			else
+				*outcome = OUTCOME_NON_TMPFS_MOUNT;
+			break;
+
+		case MATCH_PARENT:
+			/* This mount obscures any previous ones. */
+			*outcome = OUTCOME_NOTHING_MOUNTED;
+			break;
+		}
+	}
+
+	return next(fd, buf, bufsize, '\n');
 }
 
 /* which_tmpdir is called only during early boot */
@@ -106,8 +233,12 @@ static int checked_tmpdir = 0;
  */
 static void which_tmpdir(void)
 {
-	int fd, found;
-	char buf[128] = { '\0' };
+	int fd;
+	int found;
+	int outcome;
+	char *path;
+	char *buf;
+	size_t bufsize;
 
 	if (checked_tmpdir)
 		return;
@@ -116,49 +247,66 @@ static void which_tmpdir(void)
 
 	printf("Checking for tmpfs mount on /dev/shm...");
 
+	path = realpath("/dev/shm", NULL);
+	if (!path) {
+		printf("failed to check real path, errno = %d\n", errno);
+		return;
+	}
+	printf("%s...", path);
+
+	/*
+	 * The buffer needs to be able to fit the full octal-escaped path, a
+	 * space, and a trailing null in order to successfully decode it.
+	 */
+	bufsize = octal_encoded_length(path, " \t\n\\") + 2;
+
+	if (bufsize < 128)
+		bufsize = 128;
+
+	buf = malloc(bufsize);
+	if (!buf) {
+		printf("malloc failed, errno = %d\n", errno);
+		goto out;
+	}
+	buf[0] = '\0';
+
 	fd = open("/proc/mounts", O_RDONLY);
 	if (fd < 0) {
 		printf("failed to open /proc/mounts, errno = %d\n", errno);
-		return;
+		goto out1;
 	}
 
+	outcome = OUTCOME_NOTHING_MOUNTED;
 	while (1) {
-		found = next(fd, buf, ARRAY_SIZE(buf), ' ');
-		if (found != 1)
-			break;
-
-		if (!strncmp(buf, "/dev/shm", strlen("/dev/shm")))
-			goto found;
-
-		found = next(fd, buf, ARRAY_SIZE(buf), '\n');
+		found = read_mount(fd, buf, bufsize, path, &outcome);
 		if (found != 1)
 			break;
 	}
 
-err:
-	if (found == 0)
-		printf("nothing mounted on /dev/shm\n");
-	else if (found < 0)
+	if (found < 0) {
 		printf("read returned errno %d\n", -found);
+	} else {
+		switch (outcome) {
+		case OUTCOME_TMPFS_MOUNT:
+			printf("OK\n");
+			default_tmpdir = "/dev/shm";
+			break;
 
-out:
-	close(fd);
-
-	return;
-
-found:
-	found = next(fd, buf, ARRAY_SIZE(buf), ' ');
-	if (found != 1)
-		goto err;
+		case OUTCOME_NON_TMPFS_MOUNT:
+			printf("not tmpfs\n");
+			break;
 
-	if (strncmp(buf, "tmpfs", strlen("tmpfs"))) {
-		printf("not tmpfs\n");
-		goto out;
+		default:
+			printf("nothing mounted on /dev/shm\n");
+			break;
+		}
 	}
 
-	printf("OK\n");
-	default_tmpdir = "/dev/shm";
-	goto out;
+	close(fd);
+out1:
+	free(buf);
+out:
+	free(path);
 }
 
 static int __init make_tempfile(const char *template, char **out_tempname,
