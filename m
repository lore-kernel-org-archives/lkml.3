Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030355AbaEQRVR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 13:21:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54337 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030196AbaEQRVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 13:21:14 -0400
Date: Sat, 17 May 2014 18:21:09 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mateusz Guzik <mguzik@redhat.com>
Cc: Manuel =?iso-8859-1?Q?Sch=F6lling?= <manuel.schoelling@gmx.de>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: Cleanup string initializations (char[] instead of
 char *)
Message-ID: <20140517172109.GH18016@ZenIV.linux.org.uk>
References: <1400338818-2853-1-git-send-email-manuel.schoelling@gmx.de>
 <20140517154427.GB1939@mguzik.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140517154427.GB1939@mguzik.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2014 at 05:44:28PM +0200, Mateusz Guzik wrote:
> On Sat, May 17, 2014 at 05:00:18PM +0200, Manuel Schölling wrote:
> > Initializations like 'char *foo = "bar"' will create two variables: a static
> > string and a pointer (foo) to that static string. Instead 'char foo[] = "bar"'
> > will declare a single variable and will end up in shorter
> > assembly (according to Jeff Garzik on the KernelJanitor's TODO list).
> > 
> 
> This is a greatly oversimplifying things, this may or may not happen.
> 
> Out of curiosity I checked my kernel on x86-64 and it has this
> optimized:
> 
> 0xffffffffa00a9629 <bm_entry_read+121>: movabs $0x203a7367616c66,%rcx
> crash> ascii 0x203a7367616c66
> 00203a7367616c66: flags: <NUL>
> 
> 
> >  fs/binfmt_misc.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> > index b605003..2a10529 100644
> > --- a/fs/binfmt_misc.c
> > +++ b/fs/binfmt_misc.c
> > @@ -419,7 +419,7 @@ static void entry_status(Node *e, char *page)
> >  {
> >  	char *dp;
> >  	char *status = "disabled";
> > -	const char * flags = "flags: ";
> > +	const char flags[] = "flags: ";
> >  
> >  	if (test_bit(Enabled, &e->flags))
> >  		status = "enabled";
> 
> This particular function would be better of with removing this variable
> and replacing all pairs like:
> sprintf(dp, ...);
> dp += strlen(...)
> 
> with:
> dp += sprintf(dp, ...);

Sigh...  Premature optimisation and all such...  Folks, seriously, if you
want to do something with it, just switch to single_open().  Something like
this (completely untested):

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index b605003..357e421 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -30,6 +30,7 @@
 #include <linux/mount.h>
 #include <linux/syscalls.h>
 #include <linux/fs.h>
+#include <linux/seq_file.h>
 
 #include <asm/uaccess.h>
 
@@ -415,60 +416,47 @@ static int parse_command(const char __user *buffer, size_t count)
 
 /* generic stuff */
 
-static void entry_status(Node *e, char *page)
+static int entry_status(struct seq_file *m, void *v)
 {
-	char *dp;
-	char *status = "disabled";
-	const char * flags = "flags: ";
+	Node *e = m->private;
 
 	if (test_bit(Enabled, &e->flags))
-		status = "enabled";
+		seq_puts(m, "enabled\n");
+	else
+		seq_puts(m, "disabled\n");
 
-	if (!VERBOSE_STATUS) {
-		sprintf(page, "%s\n", status);
-		return;
-	}
+	if (!VERBOSE_STATUS)
+		return 0;
 
-	sprintf(page, "%s\ninterpreter %s\n", status, e->interpreter);
-	dp = page + strlen(page);
+	seq_printf(m, "interpreter %s\n", e->interpreter);
 
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
+	seq_puts(m, "flags: ");
+	if (e->flags & MISC_FMT_PRESERVE_ARGV0)
+		seq_putc(m, 'P');
+	if (e->flags & MISC_FMT_OPEN_BINARY)
+		seq_putc(m, 'O');
+	if (e->flags & MISC_FMT_CREDENTIALS)
+		seq_putc(m, 'C');
+	seq_putc(m, '\n');
 
 
 	if (!test_bit(Magic, &e->flags)) {
-		sprintf(dp, "extension .%s\n", e->magic);
+		seq_printf(m, "extension .%s\n", e->magic);
 	} else {
 		int i;
 
-		sprintf(dp, "offset %i\nmagic ", e->offset);
-		dp = page + strlen(page);
-		for (i = 0; i < e->size; i++) {
-			sprintf(dp, "%02x", 0xff & (int) (e->magic[i]));
-			dp += 2;
-		}
+		seq_printf(m, "offset %i\nmagic ", e->offset);
+		for (i = 0; i < e->size; i++)
+			seq_printf(m, "%02x", (__u8)e->magic[i]);
 		if (e->mask) {
-			sprintf(dp, "\nmask ");
-			dp += 6;
-			for (i = 0; i < e->size; i++) {
-				sprintf(dp, "%02x", 0xff & (int) (e->mask[i]));
-				dp += 2;
-			}
+			seq_puts(m, "\nmask ");
+			for (i = 0; i < e->size; i++)
+				seq_printf(m, "%02x", (__u8)e->mask[i]);
 		}
-		*dp++ = '\n';
-		*dp = '\0';
+		seq_putc(m, '\n');
 	}
+	return 0;
 }
 
 static struct inode *bm_get_inode(struct super_block *sb, int mode)
@@ -512,22 +500,9 @@ static void kill_node(Node *e)
 
 /* /<entry> */
 
-static ssize_t
-bm_entry_read(struct file * file, char __user * buf, size_t nbytes, loff_t *ppos)
+static int bm_entry_open(struct inode *inode, struct file *file)
 {
-	Node *e = file_inode(file)->i_private;
-	ssize_t res;
-	char *page;
-
-	if (!(page = (char*) __get_free_page(GFP_KERNEL)))
-		return -ENOMEM;
-
-	entry_status(e, page);
-
-	res = simple_read_from_buffer(buf, nbytes, ppos, page, strlen(page));
-
-	free_page((unsigned long) page);
-	return res;
+	return single_open(file, entry_status, file_inode(file)->i_private);
 }
 
 static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
@@ -556,9 +531,11 @@ static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
 }
 
 static const struct file_operations bm_entry_operations = {
-	.read		= bm_entry_read,
+	.open		= bm_entry_open,
+	.release	= single_release,
+	.read		= seq_read,
 	.write		= bm_entry_write,
-	.llseek		= default_llseek,
+	.llseek		= seq_lseek,
 };
 
 /* /register */
