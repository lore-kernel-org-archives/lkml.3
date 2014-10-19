Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbaJSXDv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 19:03:51 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:59558 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572AbaJSXDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 19:03:49 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/2] binfmt_misc: add comments & debug logs
Date: Sun, 19 Oct 2014 19:03:45 -0400
Message-Id: <1413759826-11958-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When trying to develop a custom format handler, the errors returned all
effectively get bucketed as EINVAL with no kernel messages.  The other
errors (ENOMEM/EFAULT) are internal/obvious and basic.  Thus any time a
bad handler is rejected, the developer has to walk the dense code and
try to guess where it went wrong.  Needing to dive into kernel code is
itself a fairly high barrier for a lot of people.

To improve this situation, let's deploy extensive pr_debug markers at
logical parse points, and add comments to the dense parsing logic.  It
let's you see exactly where the parsing aborts, the string the kernel
received (useful when dealing with shell code), how it translated the
buffers to binary data, and how it will apply the mask at runtime.

Some example output:
$ echo ':qemu-foo:M::\x7fELF\xAD\xAD\x01\x00:\xff\xff\xff\xff\xff\x00\xff\x00:/usr/bin/qemu-foo:POC' > register
$ dmesg
binfmt_misc: register: received 92 bytes
binfmt_misc: register: delim: 0x3a {:}
binfmt_misc: register: name: {qemu-foo}
binfmt_misc: register: type: M (magic)
binfmt_misc: register: offset: 0x0
binfmt_misc: register: magic[raw]: 5c 78 37 66 45 4c 46 5c 78 41 44 5c 78 41 44 5c  \x7fELF\xAD\xAD\
binfmt_misc: register: magic[raw]: 78 30 31 5c 78 30 30 00                          x01\x00.
binfmt_misc: register:  mask[raw]: 5c 78 66 66 5c 78 66 66 5c 78 66 66 5c 78 66 66  \xff\xff\xff\xff
binfmt_misc: register:  mask[raw]: 5c 78 66 66 5c 78 30 30 5c 78 66 66 5c 78 30 30  \xff\x00\xff\x00
binfmt_misc: register:  mask[raw]: 00                                               .
binfmt_misc: register: magic/mask length: 8
binfmt_misc: register: magic[decoded]: 7f 45 4c 46 ad ad 01 00                          .ELF....
binfmt_misc: register:  mask[decoded]: ff ff ff ff ff 00 ff 00                          ........
binfmt_misc: register:  magic[masked]: 7f 45 4c 46 ad 00 01 00                          .ELF....
binfmt_misc: register: interpreter: {/usr/bin/qemu-foo}
binfmt_misc: register: flag: P (preserve argv0)
binfmt_misc: register: flag: O (open binary)
binfmt_misc: register: flag: C (preserve creds)

The [raw] lines show us exactly what was received from userspace.
The lines after that show us how the kernel has decoded things.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 fs/binfmt_misc.c | 136 +++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 121 insertions(+), 15 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index fd8beb9..dbf0ac5 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -16,6 +16,8 @@
  *  2001-02-28 AV: rewritten into something that resembles C. Original didn't.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/sched.h>
@@ -30,8 +32,13 @@
 #include <linux/mount.h>
 #include <linux/syscalls.h>
 #include <linux/fs.h>
+#include <linux/uaccess.h>
 
-#include <asm/uaccess.h>
+#ifdef DEBUG
+# define USE_DEBUG 1
+#else
+# define USE_DEBUG 0
+#endif
 
 enum {
 	VERBOSE_STATUS = 1 /* make it zero to save 400 bytes kernel memory */
@@ -87,20 +94,24 @@ static Node *check_file(struct linux_binprm *bprm)
 	char *p = strrchr(bprm->interp, '.');
 	struct list_head *l;
 
+	/* Walk all the registered handlers. */
 	list_for_each(l, &entries) {
 		Node *e = list_entry(l, Node, list);
 		char *s;
 		int j;
 
+		/* Make sure this one is currently enabled. */
 		if (!test_bit(Enabled, &e->flags))
 			continue;
 
+		/* Do matching based on extension if applicable. */
 		if (!test_bit(Magic, &e->flags)) {
 			if (p && !strcmp(e->magic, p + 1))
 				return e;
 			continue;
 		}
 
+		/* Do matching based on magic & mask. */
 		s = bprm->buf + e->offset;
 		if (e->mask) {
 			for (j = 0; j < e->size; j++)
@@ -259,14 +270,17 @@ static char * check_special_flags (char * sfs, Node * e)
 	while (cont) {
 		switch (*p) {
 			case 'P':
+				pr_debug("register: flag: P (preserve argv0)");
 				p++;
 				e->flags |= MISC_FMT_PRESERVE_ARGV0;
 				break;
 			case 'O':
+				pr_debug("register: flag: O (open binary)");
 				p++;
 				e->flags |= MISC_FMT_OPEN_BINARY;
 				break;
 			case 'C':
+				pr_debug("register: flag: C (preserve creds)");
 				p++;
 				/* this flags also implies the
 				   open-binary flag */
@@ -292,6 +306,8 @@ static Node *create_entry(const char __user *buffer, size_t count)
 	char *buf, *p;
 	char del;
 
+	pr_debug("register: received %zu bytes", count);
+
 	/* some sanity checks */
 	err = -EINVAL;
 	if ((count < 11) || (count > MAX_REGISTER_LENGTH))
@@ -311,8 +327,12 @@ static Node *create_entry(const char __user *buffer, size_t count)
 
 	del = *p++;	/* delimeter */
 
+	pr_debug("register: delim: %#x {%c}", del, del);
+
+	/* Pad the buffer with the delim to simplify parsing below. */
 	memset(buf+count, del, 8);
 
+	/* Parse the 'name' field. */
 	e->name = p;
 	p = strchr(p, del);
 	if (!p)
@@ -323,46 +343,113 @@ static Node *create_entry(const char __user *buffer, size_t count)
 	    !strcmp(e->name, "..") ||
 	    strchr(e->name, '/'))
 		goto Einval;
+
+	pr_debug("register: name: {%s}", e->name);
+
+	/* Parse the 'type' field. */
 	switch (*p++) {
-		case 'E': e->flags = 1<<Enabled; break;
-		case 'M': e->flags = (1<<Enabled) | (1<<Magic); break;
-		default: goto Einval;
+	case 'E':
+		pr_debug("register: type: E (extension)");
+		e->flags = 1 << Enabled;
+		break;
+	case 'M':
+		pr_debug("register: type: M (magic)");
+		e->flags = (1 << Enabled) | (1 << Magic);
+		break;
+	default:
+		goto Einval;
 	}
 	if (*p++ != del)
 		goto Einval;
+
 	if (test_bit(Magic, &e->flags)) {
-		char *s = strchr(p, del);
+		/* Handle the 'M' (magic) format. */
+		char *s;
+
+		/* Parse the 'offset' field. */
+		s = strchr(p, del);
 		if (!s)
 			goto Einval;
 		*s++ = '\0';
 		e->offset = simple_strtoul(p, &p, 10);
 		if (*p++)
 			goto Einval;
+		pr_debug("register: offset: %#x", e->offset);
+
+		/* Parse the 'magic' field. */
 		e->magic = p;
 		p = scanarg(p, del);
 		if (!p)
 			goto Einval;
 		p[-1] = '\0';
-		if (!e->magic[0])
+		if (p == e->magic)
 			goto Einval;
+		if (USE_DEBUG)
+			print_hex_dump_bytes(
+				KBUILD_MODNAME ": register: magic[raw]: ",
+				DUMP_PREFIX_NONE, e->magic, p - e->magic);
+
+		/* Parse the 'mask' field. */
 		e->mask = p;
 		p = scanarg(p, del);
 		if (!p)
 			goto Einval;
 		p[-1] = '\0';
-		if (!e->mask[0])
+		if (p == e->mask) {
 			e->mask = NULL;
+			pr_debug("register:  mask[raw]: none");
+		} else if (USE_DEBUG)
+			print_hex_dump_bytes(
+				KBUILD_MODNAME ": register:  mask[raw]: ",
+				DUMP_PREFIX_NONE, e->mask, p - e->mask);
+
+		/*
+		 * Decode the magic & mask fields.
+		 * Note: while we might have accepted embedded NUL bytes from
+		 * above, the unescape helpers here will stop at the first one
+		 * it encounters.
+		 */
 		e->size = string_unescape_inplace(e->magic, UNESCAPE_HEX);
 		if (e->mask &&
 		    string_unescape_inplace(e->mask, UNESCAPE_HEX) != e->size)
 			goto Einval;
 		if (e->size + e->offset > BINPRM_BUF_SIZE)
 			goto Einval;
+		pr_debug("register: magic/mask length: %i", e->size);
+		if (USE_DEBUG) {
+			print_hex_dump_bytes(
+				KBUILD_MODNAME ": register: magic[decoded]: ",
+				DUMP_PREFIX_NONE, e->magic, e->size);
+
+			if (e->mask) {
+				int i;
+				char *masked = kmalloc(e->size, GFP_USER);
+
+				print_hex_dump_bytes(
+					KBUILD_MODNAME ": register:  mask[decoded]: ",
+					DUMP_PREFIX_NONE, e->mask, e->size);
+
+				if (masked) {
+					for (i = 0; i < e->size; ++i)
+						masked[i] = e->magic[i] & e->mask[i];
+					print_hex_dump_bytes(
+						KBUILD_MODNAME ": register:  magic[masked]: ",
+						DUMP_PREFIX_NONE, masked, e->size);
+
+					kfree(masked);
+				}
+			}
+		}
 	} else {
+		/* Handle the 'E' (extension) format. */
+
+		/* Skip the 'offset' field. */
 		p = strchr(p, del);
 		if (!p)
 			goto Einval;
 		*p++ = '\0';
+
+		/* Parse the 'magic' field. */
 		e->magic = p;
 		p = strchr(p, del);
 		if (!p)
@@ -370,11 +457,16 @@ static Node *create_entry(const char __user *buffer, size_t count)
 		*p++ = '\0';
 		if (!e->magic[0] || strchr(e->magic, '/'))
 			goto Einval;
+		pr_debug("register: extension: {%s}", e->magic);
+
+		/* Skip the 'mask' field. */
 		p = strchr(p, del);
 		if (!p)
 			goto Einval;
 		*p++ = '\0';
 	}
+
+	/* Parse the 'interpreter' field. */
 	e->interpreter = p;
 	p = strchr(p, del);
 	if (!p)
@@ -382,10 +474,10 @@ static Node *create_entry(const char __user *buffer, size_t count)
 	*p++ = '\0';
 	if (!e->interpreter[0])
 		goto Einval;
+	pr_debug("register: interpreter: {%s}", e->interpreter);
 
-
+	/* Parse the 'flags' field. */
 	p = check_special_flags (p, e);
-
 	if (*p == '\n')
 		p++;
 	if (p != buf + count)
@@ -553,11 +645,17 @@ static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
 	int res = parse_command(buffer, count);
 
 	switch (res) {
-		case 1: clear_bit(Enabled, &e->flags);
+		case 1:
+			/* Disable this handler. */
+			clear_bit(Enabled, &e->flags);
 			break;
-		case 2: set_bit(Enabled, &e->flags);
+		case 2:
+			/* Enable this handler. */
+			set_bit(Enabled, &e->flags);
 			break;
-		case 3: root = dget(file->f_path.dentry->d_sb->s_root);
+		case 3:
+			/* Delete this handler. */
+			root = dget(file->f_path.dentry->d_sb->s_root);
 			mutex_lock(&root->d_inode->i_mutex);
 
 			kill_node(e);
@@ -661,9 +759,17 @@ static ssize_t bm_status_write(struct file * file, const char __user * buffer,
 	struct dentry *root;
 
 	switch (res) {
-		case 1: enabled = 0; break;
-		case 2: enabled = 1; break;
-		case 3: root = dget(file->f_path.dentry->d_sb->s_root);
+		case 1:
+			/* Disable all handlers. */
+			enabled = 0;
+			break;
+		case 2:
+			/* Enable all handlers. */
+			enabled = 1;
+			break;
+		case 3:
+			/* Delete all handlers. */
+			root = dget(file->f_path.dentry->d_sb->s_root);
 			mutex_lock(&root->d_inode->i_mutex);
 
 			while (!list_empty(&entries))
-- 
2.1.2

