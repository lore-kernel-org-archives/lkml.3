Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaIEPse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 11:48:34 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38251 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaIEPsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 11:48:32 -0400
Date: Fri, 5 Sep 2014 08:48:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Milosz Tanski <milosz@adfin.com>, LKML <linux-kernel@vger.kernel.org>,
        Volker Lendecke <Volker.Lendecke@SerNet.DE>, Tejun Heo <tj@kernel.org>,
        linux-aio@kvack.org
Subject: Re: read()/readv() only from page cache
Message-ID: <20140905154829.GA22956@infradead.org>
References: <CANP1eJGE=vQBdLnMBFPcTWrvh+dUA-UCK=ugO-tc2KN4LWLPSA@mail.gmail.com>
 <20140905110927.GI17501@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <20140905110927.GI17501@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 05, 2014 at 12:09:27PM +0100, Mel Gorman wrote:
> I suggest you look at the recent fincore debate. It did not progress much
> the last time because the author wanted to push a lot of functionality in
> there where as reviewers felt it should start simple.  The simple case is
> likely a good fit for what you want. The primary downside is that it would
> be race-prone in memory pressure situations as the page could be reclaimed
> between the fincore check and the read but I expect that your application
> is already avoiding reclaim activity.

I've actually experimentally hacked up O_NONBLOCK support for regular
files so that it only returns data from the page cache, and not
otherwise.  Volker promised to test it with Samba, but we never made
any progress on it, and just last week a customer told me they would
have liked to use it if it was available.

Note that we might want to also avoid blocking on locks, and I have some
vague memory that we shouldn't actually implement O_NONBLOCK on regular
files due to compatibility options but would have to use a new flag
instead.

Note that mincor/fincore would not help for the usual use case where you
have a non blocking event main loop and want to offload actual blocking
I/O to helper threads, as you it returns information that can be stale
any time.

One further consideration would be to finally implement real buffered
I/O in kernel space by something like the above and offloading to
workqueues in kernelspace.  I think our workqueues now are way better
than any possible user thread pool, although we'd need to find a way to
temporarily tie the work threads to a user address space.

--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=support-O_NONBLOCK-reads

Index: xfs/include/linux/mm.h
===================================================================
--- xfs.orig/include/linux/mm.h	2012-09-21 17:50:32.243490371 +0200
+++ xfs/include/linux/mm.h	2012-09-21 17:50:43.333490305 +0200
@@ -1467,6 +1467,12 @@ void page_cache_async_readahead(struct a
 				pgoff_t offset,
 				unsigned long size);
 
+void page_cache_nonblock_readahead(struct address_space *mapping,
+				struct file_ra_state *ra,
+				struct file *filp,
+				pgoff_t offset,
+				unsigned long size);
+
 unsigned long max_sane_readahead(unsigned long nr);
 unsigned long ra_submit(struct file_ra_state *ra,
 			struct address_space *mapping,
Index: xfs/mm/filemap.c
===================================================================
--- xfs.orig/mm/filemap.c	2012-09-21 17:50:32.243490371 +0200
+++ xfs/mm/filemap.c	2012-09-21 18:35:53.343474115 +0200
@@ -1107,6 +1107,9 @@ static void do_generic_file_read(struct
 find_page:
 		page = find_get_page(mapping, index);
 		if (!page) {
+			if (filp && filp->f_flags & O_NONBLOCK)
+				goto short_read;
+
 			page_cache_sync_readahead(mapping,
 					ra, filp,
 					index, last_index - index);
@@ -1218,6 +1221,12 @@ page_not_up_to_date_locked:
 		}
 
 readpage:
+		if (filp && filp->f_flags & O_NONBLOCK) {
+			unlock_page(page);
+			page_cache_release(page);
+			goto short_read;
+		}
+
 		/*
 		 * A previous I/O error may have been due to temporary
 		 * failures, eg. multipath errors.
@@ -1293,6 +1302,10 @@ out:
 
 	*ppos = ((loff_t)index << PAGE_CACHE_SHIFT) + offset;
 	file_accessed(filp);
+	return;
+short_read:
+	page_cache_nonblock_readahead(mapping, ra, filp, index,
+				      last_index - index);
 }
 
 int file_read_actor(read_descriptor_t *desc, struct page *page,
@@ -1466,7 +1479,8 @@ generic_file_aio_read(struct kiocb *iocb
 		do_generic_file_read(filp, ppos, &desc, file_read_actor);
 		retval += desc.written;
 		if (desc.error) {
-			retval = retval ?: desc.error;
+			if (!retval)
+				retval = desc.error;
 			break;
 		}
 		if (desc.count > 0)
Index: xfs/mm/readahead.c
===================================================================
--- xfs.orig/mm/readahead.c	2012-09-21 17:50:32.243490371 +0200
+++ xfs/mm/readahead.c	2012-09-21 17:50:43.336823641 +0200
@@ -565,6 +565,22 @@ page_cache_async_readahead(struct addres
 }
 EXPORT_SYMBOL_GPL(page_cache_async_readahead);
 
+void
+page_cache_nonblock_readahead(struct address_space *mapping,
+			   struct file_ra_state *ra, struct file *filp,
+			   pgoff_t offset, unsigned long req_size)
+{
+	/*
+	 * Defer asynchronous read-ahead on IO congestion.
+	 */
+	if (bdi_read_congested(mapping->backing_dev_info))
+		return;
+
+	/* do read-ahead */
+	ondemand_readahead(mapping, ra, filp, false, offset, req_size);
+}
+EXPORT_SYMBOL_GPL(page_cache_nonblock_readahead);
+
 static ssize_t
 do_readahead(struct address_space *mapping, struct file *filp,
 	     pgoff_t index, unsigned long nr)

--5vNYLRcllDrimb99--
