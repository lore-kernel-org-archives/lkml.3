Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbaFKW3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 18:29:36 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40239 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbaFKW3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 18:29:34 -0400
Date: Wed, 11 Jun 2014 15:29:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: Ian Kent <raven@themaw.net>, Andrew Morton <akpm@linux-foundation.org>,
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
In-Reply-To: <20140611124301.GC4296@osiris>
Message-ID: <alpine.DEB.2.02.1406111524330.27885@chino.kir.corp.google.com>
References: <20140521122521.GB7471@osiris> <20140521143229.GA32011@infradead.org> <20140528085841.GA4219@osiris> <20140528090153.GC4219@osiris> <20140528153704.b2a3f46dc39ebf8f681d528a@linux-foundation.org> <1402301519.2775.47.camel@perseus.fritz.box>
 <20140611124301.GC4296@osiris>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2014, Heiko Carstens wrote:

> Alternatively we could also change the seqfile code to fall back to
> vmalloc allocations. That would probably "fix" all single_open usages
> where large contiguous memory areas are needed and later on fail due
> to memory fragmentation.
> Does anybody like that approach (sample patch below)?
> 
> ---
>  fs/seq_file.c | 45 +++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 37 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/seq_file.c b/fs/seq_file.c
> index 1d641bb108d2..fca78a04c0d1 100644
> --- a/fs/seq_file.c
> +++ b/fs/seq_file.c
> @@ -8,8 +8,10 @@
>  #include <linux/fs.h>
>  #include <linux/export.h>
>  #include <linux/seq_file.h>
> +#include <linux/vmalloc.h>
>  #include <linux/slab.h>
>  #include <linux/cred.h>
> +#include <linux/mm.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/page.h>
> @@ -82,6 +84,31 @@ int seq_open(struct file *file, const struct seq_operations *op)
>  }
>  EXPORT_SYMBOL(seq_open);
>  
> +static void seq_alloc(struct seq_file *m)
> +{
> +	m->size = PAGE_SIZE;
> +	m->buf = kmalloc(m->size, GFP_KERNEL | __GFP_NOWARN);
> +	if (!m->buf)
> +		m->buf = vmalloc(m->size);
> +}
> +

If m->size is unconditionally PAGE_SIZE, then how is vmalloc() going to 
allocate this if kmalloc() fails?

> +static void seq_free(struct seq_file *m)
> +{
> +	if (unlikely(is_vmalloc_addr(m->buf)))
> +		vfree(m->buf);
> +	else
> +		kfree(m->buf);
> +}
> +
> +static void seq_realloc(struct seq_file *m)
> +{
> +	seq_free(m);
> +	m->size <<= 1;
> +	m->buf = kmalloc(m->size, GFP_KERNEL | __GFP_NOWARN);
> +	if (!m->buf)
> +		m->buf = vmalloc(m->size);
> +}
> +
>  static int traverse(struct seq_file *m, loff_t offset)
>  {
>  	loff_t pos = 0, index;
> @@ -96,7 +123,7 @@ static int traverse(struct seq_file *m, loff_t offset)
>  		return 0;
>  	}
>  	if (!m->buf) {
> -		m->buf = kmalloc(m->size = PAGE_SIZE, GFP_KERNEL);
> +		seq_alloc(m);
>  		if (!m->buf)
>  			return -ENOMEM;
>  	}
> @@ -135,9 +162,8 @@ static int traverse(struct seq_file *m, loff_t offset)
>  
>  Eoverflow:
>  	m->op->stop(m, p);
> -	kfree(m->buf);
>  	m->count = 0;
> -	m->buf = kmalloc(m->size <<= 1, GFP_KERNEL);
> +	seq_realloc(m);
>  	return !m->buf ? -ENOMEM : -EAGAIN;
>  }
>  

It seems like traverse() could be rewritten to use krealloc() which does a 
memcpy() to simplify the calling code.

> @@ -192,7 +218,7 @@ ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
>  
>  	/* grab buffer if we didn't have one */
>  	if (!m->buf) {
> -		m->buf = kmalloc(m->size = PAGE_SIZE, GFP_KERNEL);
> +		seq_alloc(m);
>  		if (!m->buf)
>  			goto Enomem;
>  	}
> @@ -232,9 +258,8 @@ ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
>  		if (m->count < m->size)
>  			goto Fill;
>  		m->op->stop(m, p);
> -		kfree(m->buf);
>  		m->count = 0;
> -		m->buf = kmalloc(m->size <<= 1, GFP_KERNEL);
> +		seq_realloc(m);
>  		if (!m->buf)
>  			goto Enomem;
>  		m->version = 0;
> @@ -350,7 +375,7 @@ EXPORT_SYMBOL(seq_lseek);
>  int seq_release(struct inode *inode, struct file *file)
>  {
>  	struct seq_file *m = file->private_data;
> -	kfree(m->buf);
> +	seq_free(m);
>  	kfree(m);
>  	return 0;
>  }
> @@ -605,8 +630,12 @@ EXPORT_SYMBOL(single_open);
>  int single_open_size(struct file *file, int (*show)(struct seq_file *, void *),
>  		void *data, size_t size)
>  {
> -	char *buf = kmalloc(size, GFP_KERNEL);
> +	char *buf;
>  	int ret;
> +
> +	buf = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
> +	if (!buf)
> +		buf = vmalloc(size);
>  	if (!buf)
>  		return -ENOMEM;
>  	ret = single_open(file, show, data);
