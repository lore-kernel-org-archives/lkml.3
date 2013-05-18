Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab3ERDBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:01:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8107 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758837Ab3ERDAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:34 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=6rkdsWIXJo8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=PyA3nOzLVloA:10 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=ystiDt0KqCeuntxXZ0YA:9 a=0kPLrQdw3YYA:10 a=jbrJJM5MRmoA:10 a=jEp0ucaQiEUA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021650.637113339@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mel Gorman <mgorman@suse.de>, Jerome Marchand <jmarchan@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [ 055/136 ] mm: swap: mark swap pages writeback before queueing for direct IO
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0055-mm-swap-mark-swap-pages-writeback-before-queueing-fo.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

[ Upstream commit 0cdc444a67ccdbd58bfbcba865cb17a9f17a7691 ]

As pointed out by Andrew Morton, the swap-over-NFS writeback is not
setting PageWriteback before it is queued for direct IO.  While swap
pages do not participate in BDI or process dirty accounting and the IO
is synchronous, the writeback bit is still required and not setting it
in this case was an oversight.  swapoff depends on the page writeback to
synchronoise all pending writes on a swap page before it is reused.
Swapcache freeing and reuse depend on checking the PageWriteback under
lock to ensure the page is safe to reuse.

Direct IO handlers and the direct IO handler for NFS do not deal with
PageWriteback as they are synchronous writes.  In the case of NFS, it
schedules pages (or a page in the case of swap) for IO and then waits
synchronously for IO to complete in nfs_direct_write().  It is
recognised that this is a slowdown from normal swap handling which is
asynchronous and uses a completion handler.  Shoving PageWriteback
handling down into direct IO handlers looks like a bad fit to handle the
swap case although it may have to be dealt with some day if swap is
converted to use direct IO in general and bmap is finally done away
with.  At that point it will be necessary to refit asynchronous direct
IO with completion handlers onto the swap subsystem.

As swapcache currently depends on PageWriteback to protect against
races, this patch sets PageWriteback under the page lock before queueing
it for direct IO.  It is cleared when the direct IO handler returns.  IO
errors are treated similarly to the direct-to-bio case except PageError
is not set as in the case of swap-over-NFS, it is likely to be a
transient error.

It was asked what prevents such a page being reclaimed in parallel.
With this patch applied, such a page will now be skipped (most of the
time) or blocked until the writeback completes.  Reclaim checks
PageWriteback under the page lock before calling try_to_free_swap and
the page lock should prevent the page being requeued for IO before it is
freed.

This and Jerome's related patch should considered for -stable as far
back as 3.6 when swap-over-NFS was introduced.

[akpm@linux-foundation.org: use pr_err_ratelimited()]
[akpm@linux-foundation.org: remove hopefully-unneeded cast in printk]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>	[3.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 mm/page_io.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/page_io.c b/mm/page_io.c
index 04ca00d..6182870 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -214,6 +214,7 @@ int swap_writepage(struct page *page, struct writeback_control *wbc)
 		kiocb.ki_left = PAGE_SIZE;
 		kiocb.ki_nbytes = PAGE_SIZE;
 
+		set_page_writeback(page);
 		unlock_page(page);
 		ret = mapping->a_ops->direct_IO(KERNEL_WRITE,
 						&kiocb, &iov,
@@ -223,8 +224,22 @@ int swap_writepage(struct page *page, struct writeback_control *wbc)
 			count_vm_event(PSWPOUT);
 			ret = 0;
 		} else {
+			/*
+			 * In the case of swap-over-nfs, this can be a
+			 * temporary failure if the system has limited
+			 * memory for allocating transmit buffers.
+			 * Mark the page dirty and avoid
+			 * rotate_reclaimable_page but rate-limit the
+			 * messages but do not flag PageError like
+			 * the normal direct-to-bio case as it could
+			 * be temporary.
+			 */
 			set_page_dirty(page);
+			ClearPageReclaim(page);
+			pr_err_ratelimited("Write error on dio swapfile (%Lu)\n",
+				page_file_offset(page));
 		}
+		end_page_writeback(page);
 		return ret;
 	}
 
-- 
1.7.10.4


