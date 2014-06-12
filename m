Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686AbaFLH1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 03:27:50 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:60022 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405AbaFLH1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 03:27:49 -0400
Date: Thu, 12 Jun 2014 09:27:41 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Ian Kent <raven@themaw.net>, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Righi <andrea@betterlinux.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Thorsten Diehl <thorsten.diehl@de.ibm.com>,
        "Elliott, Robert (Server Storage)" <Elliott@hp.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 2/2] fs: proc/stat: use usual seq_file ops rather than
 single_open
Message-ID: <20140612072741.GA4296@osiris>
References: <20140521122521.GB7471@osiris>
 <20140521143229.GA32011@infradead.org>
 <20140528085841.GA4219@osiris>
 <20140528090153.GC4219@osiris>
 <20140528153704.b2a3f46dc39ebf8f681d528a@linux-foundation.org>
 <1402301519.2775.47.camel@perseus.fritz.box>
 <20140611124301.GC4296@osiris>
 <alpine.DEB.2.02.1406111524330.27885@chino.kir.corp.google.com>
 <1402554262.2642.16.camel@perseus.fritz.box>
 <alpine.DEB.2.02.1406112350010.23724@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1406112350010.23724@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061207-1948-0000-0000-0000002904F7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 11:52:31PM -0700, David Rientjes wrote:
> On Thu, 12 Jun 2014, Ian Kent wrote:
> > > > +static void seq_alloc(struct seq_file *m)
> > > > +{
> > > > +	m->size = PAGE_SIZE;
> > > > +	m->buf = kmalloc(m->size, GFP_KERNEL | __GFP_NOWARN);
> > > > +	if (!m->buf)
> > > > +		m->buf = vmalloc(m->size);
> > > > +}
> > > > +
> > > 
> > > If m->size is unconditionally PAGE_SIZE, then how is vmalloc() going to 
> > > allocate this if kmalloc() fails?
> > 
> > This is just the initial allocation.
> > If it runs out of room the allocation size doubles.
> > 
> > I think 2*PAGE_SIZE is probably better here since that's closer to what
> > the original heuristic allocation requested and is likely to avoid
> > reallocations in most cases.
> > 
> > The issue of kmalloc() failing for larger allocations on low speced
> > hardware with fragmented memory might succeed when vmalloc() is used
> > since it doesn't require contiguous memory chunks. But I guess the added
> > pressure on the page table might still be a problem, nevertheless it's
> > probably worth trying before bailing out. 
> 
> I'm not quarreling about using vmalloc() for allocations that are 
> high-order, I'm referring to the rather obvious fact that m->size is set 
> to PAGE_SIZE unconditionally above and thus vmalloc() isn't going to help 
> in the slightest.

Yes, that doesn't make any sense. I wrote the patch together in a hurry and
didn't think much about it.
So below is the what I think most simple conversion to a vmalloc fallback
approach for seq files. However the question remains if this seems to be an
acceptable approach at all...

---
 fs/seq_file.c | 38 +++++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index 1d641bb108d2..b710130c6d6b 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -8,8 +8,10 @@
 #include <linux/fs.h>
 #include <linux/export.h>
 #include <linux/seq_file.h>
+#include <linux/vmalloc.h>
 #include <linux/slab.h>
 #include <linux/cred.h>
+#include <linux/mm.h>
 
 #include <asm/uaccess.h>
 #include <asm/page.h>
@@ -30,6 +32,24 @@ static void seq_set_overflow(struct seq_file *m)
 	m->count = m->size;
 }
 
+static void *seq_alloc(unsigned long size)
+{
+	void *buf;
+
+	buf = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
+	if (!buf && size > PAGE_SIZE)
+		buf = vmalloc(size);
+	return buf;
+}
+
+static void seq_free(const void *buf)
+{
+	if (unlikely(is_vmalloc_addr(buf)))
+		vfree(buf);
+	else
+		kfree(buf);
+}
+
 /**
  *	seq_open -	initialize sequential file
  *	@file: file we initialize
@@ -96,7 +116,7 @@ static int traverse(struct seq_file *m, loff_t offset)
 		return 0;
 	}
 	if (!m->buf) {
-		m->buf = kmalloc(m->size = PAGE_SIZE, GFP_KERNEL);
+		m->buf = seq_alloc(m->size = PAGE_SIZE);
 		if (!m->buf)
 			return -ENOMEM;
 	}
@@ -135,9 +155,9 @@ static int traverse(struct seq_file *m, loff_t offset)
 
 Eoverflow:
 	m->op->stop(m, p);
-	kfree(m->buf);
+	seq_free(m->buf);
 	m->count = 0;
-	m->buf = kmalloc(m->size <<= 1, GFP_KERNEL);
+	m->buf = seq_alloc(m->size <<= 1);
 	return !m->buf ? -ENOMEM : -EAGAIN;
 }
 
@@ -192,7 +212,7 @@ ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
 
 	/* grab buffer if we didn't have one */
 	if (!m->buf) {
-		m->buf = kmalloc(m->size = PAGE_SIZE, GFP_KERNEL);
+		m->buf = seq_alloc(m->size = PAGE_SIZE);
 		if (!m->buf)
 			goto Enomem;
 	}
@@ -232,9 +252,9 @@ ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
 		if (m->count < m->size)
 			goto Fill;
 		m->op->stop(m, p);
-		kfree(m->buf);
+		seq_free(m->buf);
 		m->count = 0;
-		m->buf = kmalloc(m->size <<= 1, GFP_KERNEL);
+		m->buf = seq_alloc(m->size <<= 1);
 		if (!m->buf)
 			goto Enomem;
 		m->version = 0;
@@ -350,7 +370,7 @@ EXPORT_SYMBOL(seq_lseek);
 int seq_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *m = file->private_data;
-	kfree(m->buf);
+	seq_free(m->buf);
 	kfree(m);
 	return 0;
 }
@@ -605,13 +625,13 @@ EXPORT_SYMBOL(single_open);
 int single_open_size(struct file *file, int (*show)(struct seq_file *, void *),
 		void *data, size_t size)
 {
-	char *buf = kmalloc(size, GFP_KERNEL);
+	char *buf = seq_alloc(size);
 	int ret;
 	if (!buf)
 		return -ENOMEM;
 	ret = single_open(file, show, data);
 	if (ret) {
-		kfree(buf);
+		seq_free(buf);
 		return ret;
 	}
 	((struct seq_file *)file->private_data)->buf = buf;
-- 
1.8.5.5

