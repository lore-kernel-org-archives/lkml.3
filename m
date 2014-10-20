Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253AbaJTWqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 18:46:10 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:46180 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430AbaJTWqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 18:46:07 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/2 v2] binfmt_misc: clean up code style a bit
Date: Mon, 20 Oct 2014 18:46:00 -0400
Message-Id: <1413845160-22497-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1413845160-22497-1-git-send-email-vapier@gentoo.org>
References: <1413759826-11958-1-git-send-email-vapier@gentoo.org>
 <1413845160-22497-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up various coding style issues that checkpatch complains about.
No functional changes here.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
v2
	- rebased

 fs/binfmt_misc.c | 295 +++++++++++++++++++++++++++----------------------------
 1 file changed, 146 insertions(+), 149 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 5670b17..a953458 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -1,19 +1,10 @@
 /*
- *  binfmt_misc.c
+ * binfmt_misc.c
  *
- *  Copyright (C) 1997 Richard Günther
+ * Copyright (C) 1997 Richard Günther
  *
- *  binfmt_misc detects binaries via a magic or filename extension and invokes
- *  a specified wrapper. This should obsolete binfmt_java, binfmt_em86 and
- *  binfmt_mz.
- *
- *  1997-04-25 first version
- *  [...]
- *  1997-05-19 cleanup
- *  1997-06-26 hpa: pass the real filename rather than argv[0]
- *  1997-06-30 minor cleanup
- *  1997-08-09 removed extension stripping, locking cleanup
- *  2001-02-28 AV: rewritten into something that resembles C. Original didn't.
+ * binfmt_misc detects binaries via a magic or filename extension and invokes
+ * a specified wrapper. See Documentation/binfmt_misc.txt for more details.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -48,9 +39,9 @@ static LIST_HEAD(entries);
 static int enabled = 1;
 
 enum {Enabled, Magic};
-#define MISC_FMT_PRESERVE_ARGV0 (1<<31)
-#define MISC_FMT_OPEN_BINARY (1<<30)
-#define MISC_FMT_CREDENTIALS (1<<29)
+#define MISC_FMT_PRESERVE_ARGV0 (1 << 31)
+#define MISC_FMT_OPEN_BINARY (1 << 30)
+#define MISC_FMT_CREDENTIALS (1 << 29)
 
 typedef struct {
 	struct list_head list;
@@ -134,7 +125,7 @@ static Node *check_file(struct linux_binprm *bprm)
 static int load_misc_binary(struct linux_binprm *bprm)
 {
 	Node *fmt;
-	struct file * interp_file = NULL;
+	struct file *interp_file = NULL;
 	char iname[BINPRM_BUF_SIZE];
 	const char *iname_addr = iname;
 	int retval;
@@ -142,7 +133,7 @@ static int load_misc_binary(struct linux_binprm *bprm)
 
 	retval = -ENOEXEC;
 	if (!enabled)
-		goto _ret;
+		goto ret;
 
 	/* to keep locking time low, we copy the interpreter string */
 	read_lock(&entries_lock);
@@ -151,25 +142,26 @@ static int load_misc_binary(struct linux_binprm *bprm)
 		strlcpy(iname, fmt->interpreter, BINPRM_BUF_SIZE);
 	read_unlock(&entries_lock);
 	if (!fmt)
-		goto _ret;
+		goto ret;
 
 	if (!(fmt->flags & MISC_FMT_PRESERVE_ARGV0)) {
 		retval = remove_arg_zero(bprm);
 		if (retval)
-			goto _ret;
+			goto ret;
 	}
 
 	if (fmt->flags & MISC_FMT_OPEN_BINARY) {
 
 		/* if the binary should be opened on behalf of the
 		 * interpreter than keep it open and assign descriptor
-		 * to it */
- 		fd_binary = get_unused_fd();
- 		if (fd_binary < 0) {
- 			retval = fd_binary;
- 			goto _ret;
- 		}
- 		fd_install(fd_binary, bprm->file);
+		 * to it
+		 */
+		fd_binary = get_unused_fd();
+		if (fd_binary < 0) {
+			retval = fd_binary;
+			goto ret;
+		}
+		fd_install(fd_binary, bprm->file);
 
 		/* if the binary is not readable than enforce mm->dumpable=0
 		   regardless of the interpreter's permissions */
@@ -182,32 +174,32 @@ static int load_misc_binary(struct linux_binprm *bprm)
 		bprm->interp_flags |= BINPRM_FLAGS_EXECFD;
 		bprm->interp_data = fd_binary;
 
- 	} else {
- 		allow_write_access(bprm->file);
- 		fput(bprm->file);
- 		bprm->file = NULL;
- 	}
+	} else {
+		allow_write_access(bprm->file);
+		fput(bprm->file);
+		bprm->file = NULL;
+	}
 	/* make argv[1] be the path to the binary */
-	retval = copy_strings_kernel (1, &bprm->interp, bprm);
+	retval = copy_strings_kernel(1, &bprm->interp, bprm);
 	if (retval < 0)
-		goto _error;
+		goto error;
 	bprm->argc++;
 
 	/* add the interp as argv[0] */
-	retval = copy_strings_kernel (1, &iname_addr, bprm);
+	retval = copy_strings_kernel(1, &iname_addr, bprm);
 	if (retval < 0)
-		goto _error;
-	bprm->argc ++;
+		goto error;
+	bprm->argc++;
 
 	/* Update interp in case binfmt_script needs it. */
 	retval = bprm_change_interp(iname, bprm);
 	if (retval < 0)
-		goto _error;
+		goto error;
 
-	interp_file = open_exec (iname);
-	retval = PTR_ERR (interp_file);
-	if (IS_ERR (interp_file))
-		goto _error;
+	interp_file = open_exec(iname);
+	retval = PTR_ERR(interp_file);
+	if (IS_ERR(interp_file))
+		goto error;
 
 	bprm->file = interp_file;
 	if (fmt->flags & MISC_FMT_CREDENTIALS) {
@@ -218,23 +210,23 @@ static int load_misc_binary(struct linux_binprm *bprm)
 		memset(bprm->buf, 0, BINPRM_BUF_SIZE);
 		retval = kernel_read(bprm->file, 0, bprm->buf, BINPRM_BUF_SIZE);
 	} else
-		retval = prepare_binprm (bprm);
+		retval = prepare_binprm(bprm);
 
 	if (retval < 0)
-		goto _error;
+		goto error;
 
 	retval = search_binary_handler(bprm);
 	if (retval < 0)
-		goto _error;
+		goto error;
 
-_ret:
+ret:
 	return retval;
-_error:
+error:
 	if (fd_binary > 0)
 		sys_close(fd_binary);
 	bprm->interp_flags = 0;
 	bprm->interp_data = 0;
-	goto _ret;
+	goto ret;
 }
 
 /* Command parsers */
@@ -261,39 +253,40 @@ static char *scanarg(char *s, char del)
 	return s;
 }
 
-static char * check_special_flags (char * sfs, Node * e)
+static char *check_special_flags(char *sfs, Node *e)
 {
-	char * p = sfs;
+	char *p = sfs;
 	int cont = 1;
 
 	/* special flags */
 	while (cont) {
 		switch (*p) {
-			case 'P':
-				pr_debug("register: flag: P (preserve argv0)\n");
-				p++;
-				e->flags |= MISC_FMT_PRESERVE_ARGV0;
-				break;
-			case 'O':
-				pr_debug("register: flag: O (open binary)\n");
-				p++;
-				e->flags |= MISC_FMT_OPEN_BINARY;
-				break;
-			case 'C':
-				pr_debug("register: flag: C (preserve creds)\n");
-				p++;
-				/* this flags also implies the
-				   open-binary flag */
-				e->flags |= (MISC_FMT_CREDENTIALS |
-						MISC_FMT_OPEN_BINARY);
-				break;
-			default:
-				cont = 0;
+		case 'P':
+			pr_debug("register: flag: P (preserve argv0)\n");
+			p++;
+			e->flags |= MISC_FMT_PRESERVE_ARGV0;
+			break;
+		case 'O':
+			pr_debug("register: flag: O (open binary)\n");
+			p++;
+			e->flags |= MISC_FMT_OPEN_BINARY;
+			break;
+		case 'C':
+			pr_debug("register: flag: C (preserve creds)\n");
+			p++;
+			/* this flags also implies the
+			   open-binary flag */
+			e->flags |= (MISC_FMT_CREDENTIALS |
+					MISC_FMT_OPEN_BINARY);
+			break;
+		default:
+			cont = 0;
 		}
 	}
 
 	return p;
 }
+
 /*
  * This registers a new binary format, it recognises the syntax
  * ':name:type:offset:magic:mask:interpreter:flags'
@@ -323,26 +316,26 @@ static Node *create_entry(const char __user *buffer, size_t count)
 
 	memset(e, 0, sizeof(Node));
 	if (copy_from_user(buf, buffer, count))
-		goto Efault;
+		goto efault;
 
 	del = *p++;	/* delimeter */
 
 	pr_debug("register: delim: %#x {%c}\n", del, del);
 
 	/* Pad the buffer with the delim to simplify parsing below. */
-	memset(buf+count, del, 8);
+	memset(buf + count, del, 8);
 
 	/* Parse the 'name' field. */
 	e->name = p;
 	p = strchr(p, del);
 	if (!p)
-		goto Einval;
+		goto einval;
 	*p++ = '\0';
 	if (!e->name[0] ||
 	    !strcmp(e->name, ".") ||
 	    !strcmp(e->name, "..") ||
 	    strchr(e->name, '/'))
-		goto Einval;
+		goto einval;
 
 	pr_debug("register: name: {%s}\n", e->name);
 
@@ -357,10 +350,10 @@ static Node *create_entry(const char __user *buffer, size_t count)
 		e->flags = (1 << Enabled) | (1 << Magic);
 		break;
 	default:
-		goto Einval;
+		goto einval;
 	}
 	if (*p++ != del)
-		goto Einval;
+		goto einval;
 
 	if (test_bit(Magic, &e->flags)) {
 		/* Handle the 'M' (magic) format. */
@@ -369,21 +362,21 @@ static Node *create_entry(const char __user *buffer, size_t count)
 		/* Parse the 'offset' field. */
 		s = strchr(p, del);
 		if (!s)
-			goto Einval;
+			goto einval;
 		*s++ = '\0';
 		e->offset = simple_strtoul(p, &p, 10);
 		if (*p++)
-			goto Einval;
+			goto einval;
 		pr_debug("register: offset: %#x\n", e->offset);
 
 		/* Parse the 'magic' field. */
 		e->magic = p;
 		p = scanarg(p, del);
 		if (!p)
-			goto Einval;
+			goto einval;
 		p[-1] = '\0';
 		if (p == e->magic)
-			goto Einval;
+			goto einval;
 		if (USE_DEBUG)
 			print_hex_dump_bytes(
 				KBUILD_MODNAME ": register: magic[raw]: ",
@@ -393,7 +386,7 @@ static Node *create_entry(const char __user *buffer, size_t count)
 		e->mask = p;
 		p = scanarg(p, del);
 		if (!p)
-			goto Einval;
+			goto einval;
 		p[-1] = '\0';
 		if (p == e->mask) {
 			e->mask = NULL;
@@ -412,9 +405,9 @@ static Node *create_entry(const char __user *buffer, size_t count)
 		e->size = string_unescape_inplace(e->magic, UNESCAPE_HEX);
 		if (e->mask &&
 		    string_unescape_inplace(e->mask, UNESCAPE_HEX) != e->size)
-			goto Einval;
+			goto einval;
 		if (e->size + e->offset > BINPRM_BUF_SIZE)
-			goto Einval;
+			goto einval;
 		pr_debug("register: magic/mask length: %i\n", e->size);
 		if (USE_DEBUG) {
 			print_hex_dump_bytes(
@@ -446,23 +439,23 @@ static Node *create_entry(const char __user *buffer, size_t count)
 		/* Skip the 'offset' field. */
 		p = strchr(p, del);
 		if (!p)
-			goto Einval;
+			goto einval;
 		*p++ = '\0';
 
 		/* Parse the 'magic' field. */
 		e->magic = p;
 		p = strchr(p, del);
 		if (!p)
-			goto Einval;
+			goto einval;
 		*p++ = '\0';
 		if (!e->magic[0] || strchr(e->magic, '/'))
-			goto Einval;
+			goto einval;
 		pr_debug("register: extension: {%s}\n", e->magic);
 
 		/* Skip the 'mask' field. */
 		p = strchr(p, del);
 		if (!p)
-			goto Einval;
+			goto einval;
 		*p++ = '\0';
 	}
 
@@ -470,27 +463,28 @@ static Node *create_entry(const char __user *buffer, size_t count)
 	e->interpreter = p;
 	p = strchr(p, del);
 	if (!p)
-		goto Einval;
+		goto einval;
 	*p++ = '\0';
 	if (!e->interpreter[0])
-		goto Einval;
+		goto einval;
 	pr_debug("register: interpreter: {%s}\n", e->interpreter);
 
 	/* Parse the 'flags' field. */
-	p = check_special_flags (p, e);
+	p = check_special_flags(p, e);
 	if (*p == '\n')
 		p++;
 	if (p != buf + count)
-		goto Einval;
+		goto einval;
+
 	return e;
 
 out:
 	return ERR_PTR(err);
 
-Efault:
+efault:
 	kfree(e);
 	return ERR_PTR(-EFAULT);
-Einval:
+einval:
 	kfree(e);
 	return ERR_PTR(-EINVAL);
 }
@@ -509,7 +503,7 @@ static int parse_command(const char __user *buffer, size_t count)
 		return -EFAULT;
 	if (!count)
 		return 0;
-	if (s[count-1] == '\n')
+	if (s[count - 1] == '\n')
 		count--;
 	if (count == 1 && s[0] == '0')
 		return 1;
@@ -526,7 +520,7 @@ static void entry_status(Node *e, char *page)
 {
 	char *dp;
 	char *status = "disabled";
-	const char * flags = "flags: ";
+	const char *flags = "flags: ";
 
 	if (test_bit(Enabled, &e->flags))
 		status = "enabled";
@@ -540,19 +534,15 @@ static void entry_status(Node *e, char *page)
 	dp = page + strlen(page);
 
 	/* print the special flags */
-	sprintf (dp, "%s", flags);
-	dp += strlen (flags);
-	if (e->flags & MISC_FMT_PRESERVE_ARGV0) {
-		*dp ++ = 'P';
-	}
-	if (e->flags & MISC_FMT_OPEN_BINARY) {
-		*dp ++ = 'O';
-	}
-	if (e->flags & MISC_FMT_CREDENTIALS) {
-		*dp ++ = 'C';
-	}
-	*dp ++ = '\n';
-
+	sprintf(dp, "%s", flags);
+	dp += strlen(flags);
+	if (e->flags & MISC_FMT_PRESERVE_ARGV0)
+		*dp++ = 'P';
+	if (e->flags & MISC_FMT_OPEN_BINARY)
+		*dp++ = 'O';
+	if (e->flags & MISC_FMT_CREDENTIALS)
+		*dp++ = 'C';
+	*dp++ = '\n';
 
 	if (!test_bit(Magic, &e->flags)) {
 		sprintf(dp, "extension .%s\n", e->magic);
@@ -580,7 +570,7 @@ static void entry_status(Node *e, char *page)
 
 static struct inode *bm_get_inode(struct super_block *sb, int mode)
 {
-	struct inode * inode = new_inode(sb);
+	struct inode *inode = new_inode(sb);
 
 	if (inode) {
 		inode->i_ino = get_next_ino();
@@ -620,13 +610,14 @@ static void kill_node(Node *e)
 /* /<entry> */
 
 static ssize_t
-bm_entry_read(struct file * file, char __user * buf, size_t nbytes, loff_t *ppos)
+bm_entry_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
 	Node *e = file_inode(file)->i_private;
 	ssize_t res;
 	char *page;
 
-	if (!(page = (char*) __get_free_page(GFP_KERNEL)))
+	page = (char *) __get_free_page(GFP_KERNEL);
+	if (!page)
 		return -ENOMEM;
 
 	entry_status(e, page);
@@ -645,26 +636,28 @@ static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
 	int res = parse_command(buffer, count);
 
 	switch (res) {
-		case 1:
-			/* Disable this handler. */
-			clear_bit(Enabled, &e->flags);
-			break;
-		case 2:
-			/* Enable this handler. */
-			set_bit(Enabled, &e->flags);
-			break;
-		case 3:
-			/* Delete this handler. */
-			root = dget(file->f_path.dentry->d_sb->s_root);
-			mutex_lock(&root->d_inode->i_mutex);
+	case 1:
+		/* Disable this handler. */
+		clear_bit(Enabled, &e->flags);
+		break;
+	case 2:
+		/* Enable this handler. */
+		set_bit(Enabled, &e->flags);
+		break;
+	case 3:
+		/* Delete this handler. */
+		root = dget(file->f_path.dentry->d_sb->s_root);
+		mutex_lock(&root->d_inode->i_mutex);
 
-			kill_node(e);
+		kill_node(e);
 
-			mutex_unlock(&root->d_inode->i_mutex);
-			dput(root);
-			break;
-		default: return res;
+		mutex_unlock(&root->d_inode->i_mutex);
+		dput(root);
+		break;
+	default:
+		return res;
 	}
+
 	return count;
 }
 
@@ -752,34 +745,36 @@ bm_status_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 	return simple_read_from_buffer(buf, nbytes, ppos, s, strlen(s));
 }
 
-static ssize_t bm_status_write(struct file * file, const char __user * buffer,
+static ssize_t bm_status_write(struct file *file, const char __user *buffer,
 		size_t count, loff_t *ppos)
 {
 	int res = parse_command(buffer, count);
 	struct dentry *root;
 
 	switch (res) {
-		case 1:
-			/* Disable all handlers. */
-			enabled = 0;
-			break;
-		case 2:
-			/* Enable all handlers. */
-			enabled = 1;
-			break;
-		case 3:
-			/* Delete all handlers. */
-			root = dget(file->f_path.dentry->d_sb->s_root);
-			mutex_lock(&root->d_inode->i_mutex);
+	case 1:
+		/* Disable all handlers. */
+		enabled = 0;
+		break;
+	case 2:
+		/* Enable all handlers. */
+		enabled = 1;
+		break;
+	case 3:
+		/* Delete all handlers. */
+		root = dget(file->f_path.dentry->d_sb->s_root);
+		mutex_lock(&root->d_inode->i_mutex);
 
-			while (!list_empty(&entries))
-				kill_node(list_entry(entries.next, Node, list));
+		while (!list_empty(&entries))
+			kill_node(list_entry(entries.next, Node, list));
 
-			mutex_unlock(&root->d_inode->i_mutex);
-			dput(root);
-			break;
-		default: return res;
+		mutex_unlock(&root->d_inode->i_mutex);
+		dput(root);
+		break;
+	default:
+		return res;
 	}
+
 	return count;
 }
 
@@ -796,14 +791,16 @@ static const struct super_operations s_ops = {
 	.evict_inode	= bm_evict_inode,
 };
 
-static int bm_fill_super(struct super_block * sb, void * data, int silent)
+static int bm_fill_super(struct super_block *sb, void *data, int silent)
 {
+	int err;
 	static struct tree_descr bm_files[] = {
 		[2] = {"status", &bm_status_operations, S_IWUSR|S_IRUGO},
 		[3] = {"register", &bm_register_operations, S_IWUSR},
 		/* last one */ {""}
 	};
-	int err = simple_fill_super(sb, BINFMTFS_MAGIC, bm_files);
+
+	err = simple_fill_super(sb, BINFMTFS_MAGIC, bm_files);
 	if (!err)
 		sb->s_op = &s_ops;
 	return err;
-- 
2.1.2

