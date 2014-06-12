Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820AbaFLITB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 04:19:01 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:59340 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932785AbaFLIS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 04:18:57 -0400
Date: Thu, 12 Jun 2014 10:18:46 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: David Rientjes <rientjes@google.com>, Ian Kent <raven@themaw.net>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <20140612081846.GB4296@osiris>
References: <20140521143229.GA32011@infradead.org>
 <20140528085841.GA4219@osiris>
 <20140528090153.GC4219@osiris>
 <20140528153704.b2a3f46dc39ebf8f681d528a@linux-foundation.org>
 <1402301519.2775.47.camel@perseus.fritz.box>
 <20140611124301.GC4296@osiris>
 <alpine.DEB.2.02.1406111524330.27885@chino.kir.corp.google.com>
 <1402554262.2642.16.camel@perseus.fritz.box>
 <alpine.DEB.2.02.1406112350010.23724@chino.kir.corp.google.com>
 <20140612072741.GA4296@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140612072741.GA4296@osiris>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061208-0542-0000-0000-00000973039A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 09:27:41AM +0200, Heiko Carstens wrote:
> On Wed, Jun 11, 2014 at 11:52:31PM -0700, David Rientjes wrote:
> > On Thu, 12 Jun 2014, Ian Kent wrote:
> > > > > +static void seq_alloc(struct seq_file *m)
> > > > > +{
> > > > > +	m->size = PAGE_SIZE;
> > > > > +	m->buf = kmalloc(m->size, GFP_KERNEL | __GFP_NOWARN);
> > > > > +	if (!m->buf)
> > > > > +		m->buf = vmalloc(m->size);
> > > > > +}
> > > > > +
> > > > 
> > > > If m->size is unconditionally PAGE_SIZE, then how is vmalloc() going to 
> > > > allocate this if kmalloc() fails?
> > > 
> > > This is just the initial allocation.
> > > If it runs out of room the allocation size doubles.
> > > 
> > > I think 2*PAGE_SIZE is probably better here since that's closer to what
> > > the original heuristic allocation requested and is likely to avoid
> > > reallocations in most cases.
> > > 
> > > The issue of kmalloc() failing for larger allocations on low speced
> > > hardware with fragmented memory might succeed when vmalloc() is used
> > > since it doesn't require contiguous memory chunks. But I guess the added
> > > pressure on the page table might still be a problem, nevertheless it's
> > > probably worth trying before bailing out. 
> > 
> > I'm not quarreling about using vmalloc() for allocations that are 
> > high-order, I'm referring to the rather obvious fact that m->size is set 
> > to PAGE_SIZE unconditionally above and thus vmalloc() isn't going to help 
> > in the slightest.
> 
> Yes, that doesn't make any sense. I wrote the patch together in a hurry and
> didn't think much about it.
> So below is the what I think most simple conversion to a vmalloc fallback
> approach for seq files. However the question remains if this seems to be an
> acceptable approach at all...

And so that the vmalloc fallback has any effect to the /proc/stat allocation
it also needs to be converted to use single_open_size() instead:

From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Thu, 12 Jun 2014 10:04:39 +0200
Subject: [PATCH] proc/stat: convert to single_open_size()

Use seq_file's single_open_size() to preallocate a buffer that is large
enough to hold the whole output, instead of open coding it.
Also calculate the requested size using the number of online cpus instead
of possible cpus, since the size of the output only depends on the number
of online cpus.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 fs/proc/stat.c | 22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 9d231e9e5f0e..bf2d03f8fd3e 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -184,29 +184,11 @@ static int show_stat(struct seq_file *p, void *v)
 
 static int stat_open(struct inode *inode, struct file *file)
 {
-	size_t size = 1024 + 128 * num_possible_cpus();
-	char *buf;
-	struct seq_file *m;
-	int res;
+	size_t size = 1024 + 128 * num_online_cpus();
 
 	/* minimum size to display an interrupt count : 2 bytes */
 	size += 2 * nr_irqs;
-
-	/* don't ask for more than the kmalloc() max size */
-	if (size > KMALLOC_MAX_SIZE)
-		size = KMALLOC_MAX_SIZE;
-	buf = kmalloc(size, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	res = single_open(file, show_stat, NULL);
-	if (!res) {
-		m = file->private_data;
-		m->buf = buf;
-		m->size = ksize(buf);
-	} else
-		kfree(buf);
-	return res;
+	return single_open_size(file, show_stat, NULL, size);
 }
 
 static const struct file_operations proc_stat_operations = {
-- 
1.8.5.5

