Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408AbaDHOt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 10:49:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932163AbaDHOty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 10:49:54 -0400
Date: Tue, 8 Apr 2014 10:49:43 -0400
From: Dave Jones <davej@redhat.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>
Subject: Re: fs,seq_file: huge allocations for seq file reads
Message-ID: <20140408144943.GA6165@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
References: <53440B8B.1010304@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53440B8B.1010304@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 10:45:31AM -0400, Sasha Levin wrote:
 
 > It seems that when we attempt to read huge chunks of data from a seq file
 > there would be no check for the size being read, leading to the kernel
 > attempting to allocate huge chunks of data internally.
 > 
 > As far as I remember, there was a PAGE_SIZE limitation on those, but I'm
 > not certain about that. Could someone please confirm it?

I've had this diff sitting around for a while to figure out which
seq_file we're talking about.  I think Al wrote it, I forget..


diff --git a/fs/seq_file.c b/fs/seq_file.c
index 1d641bb108d2..e3ca909c8fea 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -82,7 +82,7 @@ int seq_open(struct file *file, const struct seq_operations *op)
 }
 EXPORT_SYMBOL(seq_open);
 
-static int traverse(struct seq_file *m, loff_t offset)
+static int traverse(struct file *file, struct seq_file *m, loff_t offset)
 {
 	loff_t pos = 0, index;
 	int error = 0;
@@ -137,6 +137,13 @@ Eoverflow:
 	m->op->stop(m, p);
 	kfree(m->buf);
 	m->count = 0;
+	if ((m->size <<= 1) >= (PAGE_SIZE << 4)) {
+		printk(KERN_ERR "traverse on %s. Size: %ld\n",
+			file->f_path.dentry->d_name.name,
+			(unsigned long) (m->size));
+		m->buf = NULL;
+		return -ENOMEM;
+	}
 	m->buf = kmalloc(m->size <<= 1, GFP_KERNEL);
 	return !m->buf ? -ENOMEM : -EAGAIN;
 }
@@ -176,7 +183,7 @@ ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
 
 	/* Don't assume *ppos is where we left it */
 	if (unlikely(*ppos != m->read_pos)) {
-		while ((err = traverse(m, *ppos)) == -EAGAIN)
+		while ((err = traverse(file, m, *ppos)) == -EAGAIN)
 			;
 		if (err) {
 			/* With prejudice... */
@@ -192,6 +199,14 @@ ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
 
 	/* grab buffer if we didn't have one */
 	if (!m->buf) {
+		if ((m->size <<= 1) >= (PAGE_SIZE << 4)) {
+			printk(KERN_ERR "seq_read on %s. Size: %ld\n",
+				file->f_path.dentry->d_name.name,
+				(unsigned long) (m->size));
+			m->buf = NULL;
+			goto Enomem;;
+		}
+
 		m->buf = kmalloc(m->size = PAGE_SIZE, GFP_KERNEL);
 		if (!m->buf)
 			goto Enomem;
@@ -234,6 +249,15 @@ ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
 		m->op->stop(m, p);
 		kfree(m->buf);
 		m->count = 0;
+
+		if ((m->size <<= 1) >= (PAGE_SIZE << 4)) {
+			printk(KERN_ERR "seq_read on %s. Size: %ld\n",
+				file->f_path.dentry->d_name.name,
+				(unsigned long) (m->size));
+			m->buf = NULL;
+			goto Enomem;;
+		}
+
 		m->buf = kmalloc(m->size <<= 1, GFP_KERNEL);
 		if (!m->buf)
 			goto Enomem;
@@ -316,7 +340,7 @@ loff_t seq_lseek(struct file *file, loff_t offset, int whence)
 			break;
 		retval = offset;
 		if (offset != m->read_pos) {
-			while ((retval = traverse(m, offset)) == -EAGAIN)
+			while ((retval = traverse(file, m, offset)) == -EAGAIN)
 				;
 			if (retval) {
 				/* with extreme prejudice... */
