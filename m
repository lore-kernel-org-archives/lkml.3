Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbaCNLPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 07:15:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:16891 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753257AbaCNLPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 07:15:20 -0400
X-IronPort-AV: E=Sophos;i="4.97,654,1389715200"; 
   d="scan'208";a="9697414"
Message-ID: <5322D90C.5050207@cn.fujitsu.com>
Date: Fri, 14 Mar 2014 18:25:16 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Benjamin LaHaise <bcrl@kvack.org>
CC: Tang Chen <tangchen@cn.fujitsu.com>, viro@zeniv.linux.org.uk,
        jmoyer@redhat.com, kosaki.motohiro@gmail.com,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, miaox@cn.fujitsu.com
Subject: Re: [RESEND v2 PATCH 1/2] aio, memory-hotplug: Fix confliction when
 migrating and accessing ring pages.
References: <1394439334-28523-1-git-send-email-tangchen@cn.fujitsu.com> <1394439334-28523-2-git-send-email-tangchen@cn.fujitsu.com> <20140311184656.GD16433@kvack.org> <531FEFC6.50709@cn.fujitsu.com> <20140312221735.GF32444@kvack.org>
In-Reply-To: <20140312221735.GF32444@kvack.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/14 18:31:21,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/14 18:31:35,
	Serialize complete at 2014/03/14 18:31:35
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,
On 03/13/2014 06:17 AM, Benjamin LaHaise wrote:

> Hello Tang,
> 
> On Wed, Mar 12, 2014 at 01:25:26PM +0800, Tang Chen wrote:
> ... <snip> ...
> 
>>> Another spot is in
>>> aio_read_events_ring() where head and tail are fetched from the ring 
>>> without
>>> any locking.  I also fear we'll be introducing new performance issues with
>>> all the additonal spinlock bouncing, despite the fact that is only ever
>>> needed for migration.  I'm going to continue looking into this today and
>>> will try to send out a followup to this email later.
>>
>> In the beginning of aio_read_events_ring(), it reads head and tail, not 
>> write.
>> So even if ring pages are migrated, the contents of the pages will not 
>> be changed.
>> So reading it is OK, from old page or from the new page, I think.
> 
> Your assumption that reading it is okay is incorrect.  Since we do not have 
> a reference on the page at that point, it is possible that the read of the 
> page takes place after the page has been freed and allocated to another part 
> of the kernel.  This would result in the read returning invalid information.

What about the following patch? It adds additional reference to protect the page
avoid being freed when we reading it.
ps.It is applied on linux-next(3-13).

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/aio.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 4133ba9..a4f3a4f 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -283,7 +283,7 @@ static int aio_migratepage(struct address_space *mapping, struct page *new,
 {
 	struct kioctx *ctx;
 	unsigned long flags;
-	int rc;
+	int rc, extra_count;
 
 	rc = 0;
 
@@ -311,7 +311,10 @@ static int aio_migratepage(struct address_space *mapping, struct page *new,
 	BUG_ON(PageWriteback(old));
 	get_page(new);
 
-	rc = migrate_page_move_mapping(mapping, new, old, NULL, mode, 1);
+	extra_count = page_count(old) - page_has_private(old) - 2;
+
+	rc = migrate_page_move_mapping(mapping, new, old,
+						NULL, mode, extra_count);
 	if (rc != MIGRATEPAGE_SUCCESS) {
 		put_page(new);
 		return rc;
@@ -1047,13 +1050,17 @@ static long aio_read_events_ring(struct kioctx *ctx,
 	unsigned head, tail, pos;
 	long ret = 0;
 	int copy_ret;
+	struct page *page;
 
 	mutex_lock(&ctx->ring_lock);
 
-	ring = kmap_atomic(ctx->ring_pages[0]);
+	page = ctx->ring_pages[0];
+	get_page(page);
+	ring = kmap_atomic(page);
 	head = ring->head;
 	tail = ring->tail;
 	kunmap_atomic(ring);
+	put_page(page);
 
 	pr_debug("h%u t%u m%u\n", head, tail, ctx->nr_events);
 
@@ -1063,7 +1070,6 @@ static long aio_read_events_ring(struct kioctx *ctx,
 	while (ret < nr) {
 		long avail;
 		struct io_event *ev;
-		struct page *page;
 
 		avail = (head <= tail ?  tail : ctx->nr_events) - head;
 		if (head == tail)
@@ -1075,6 +1081,7 @@ static long aio_read_events_ring(struct kioctx *ctx,
 
 		pos = head + AIO_EVENTS_OFFSET;
 		page = ctx->ring_pages[pos / AIO_EVENTS_PER_PAGE];
+		get_page(page);
 		pos %= AIO_EVENTS_PER_PAGE;
 
 		/*
@@ -1087,6 +1094,7 @@ static long aio_read_events_ring(struct kioctx *ctx,
 		copy_ret = copy_to_user(event + ret, ev + pos,
 					sizeof(*ev) * avail);
 		kunmap(page);
+		put_page(page);
 
 		if (unlikely(copy_ret)) {
 			ret = -EFAULT;
-- 
1.7.7


> 
> 		-ben


