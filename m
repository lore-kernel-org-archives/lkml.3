Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab3A1XVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 18:21:50 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:55304 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab3A1XVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 18:21:48 -0500
X-AuditID: 9c93016f-b7b70ae000000e36-d6-510708094e24
Date: Tue, 29 Jan 2013 08:21:45 +0900
From: Minchan Kim <minchan@kernel.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, stable@vger.kernel.org,
        Jerome Marchand <jmarchan@redhat.com>
Subject: Re: [RESEND PATCH v5 1/4] zram: Fix deadlock bug in partial write
Message-ID: <20130128232145.GA2666@blaptop>
References: <1359333506-13599-1-git-send-email-minchan@kernel.org>
 <CAOJsxLFg_5uhZsvPmVVC0nnsZLGpkJ0W6mHa=aavmguLGuTTnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLFg_5uhZsvPmVVC0nnsZLGpkJ0W6mHa=aavmguLGuTTnA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 09:16:35AM +0200, Pekka Enberg wrote:
> On Mon, Jan 28, 2013 at 2:38 AM, Minchan Kim <minchan@kernel.org> wrote:
> > Now zram allocates new page with GFP_KERNEL in zram I/O path
> > if IO is partial. Unfortunately, It may cuase deadlock with
> 
> s/cuase/cause/g

Thanks!

> 
> > reclaim path so this patch solves the problem.
> 
> It'd be nice to know about the problem in more detail. I'm also
> curious on why you decided on GFP_ATOMIC for the read path and
> GFP_NOIO in the write path.

In read path, we called kmap_atomic.

How about this?
------------------------- >8 -------------------------------

>From 9f8756ae0b0f2819f93cb94dcd38da372843aa12 Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Mon, 21 Jan 2013 13:58:52 +0900
Subject: [RESEND PATCH v5 1/4] zram: Fix deadlock bug in partial read/write

Now zram allocates new page with GFP_KERNEL in zram I/O path
if IO is partial. Unfortunately, It may cause deadlock with
reclaim path like below.

write_page from fs
fs_lock
allocation(GFP_KERNEL)
reclaim
pageout
				write_page from fs
				fs_lock <-- deadlock

This patch fixes it by using GFP_ATOMIC and GFP_NOIO.
In read path, we called kmap_atomic so that we need GFP_ATOMIC
while we need GFP_NOIO in write path.

Cc: stable@vger.kernel.org
Cc: Jerome Marchand <jmarchan@redhat.com>
Acked-by: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
We could use GFP_IO instead of GFP_ATOMIC in zram_bvec_read with
some modification related to buffer allocation in case of partial IO.
But it needs more churn and prevent merge this patch into stable
if we should send this to stable so I'd like to keep it as simple
as possbile. GFP_IO usage could be separate patch after we merge it.
Thanks.
 drivers/staging/zram/zram_drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 61fb8f1..b285b3a 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -220,7 +220,7 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
 	user_mem = kmap_atomic(page);
 	if (is_partial_io(bvec))
 		/* Use  a temporary buffer to decompress the page */
-		uncmem = kmalloc(PAGE_SIZE, GFP_KERNEL);
+		uncmem = kmalloc(PAGE_SIZE, GFP_ATOMIC);
 	else
 		uncmem = user_mem;
 
@@ -268,7 +268,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 		 * This is a partial IO. We need to read the full page
 		 * before to write the changes.
 		 */
-		uncmem = kmalloc(PAGE_SIZE, GFP_KERNEL);
+		uncmem = kmalloc(PAGE_SIZE, GFP_NOIO);
 		if (!uncmem) {
 			pr_info("Error allocating temp memory!\n");
 			ret = -ENOMEM;
-- 
1.7.9.5

-- 
Kind regards,
Minchan Kim
