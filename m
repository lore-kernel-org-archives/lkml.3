Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab3C1STs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 14:19:48 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:19570 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab3C1STr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 14:19:47 -0400
MIME-Version: 1.0
Message-ID: <5f1504e7-8b07-4109-8271-b214b496ca61@default>
Date: Thu, 28 Mar 2013 11:19:12 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Shaohua Li <shli@kernel.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Bob Liu <bob.liu@oracle.com>
Subject: RE: [RFC] mm: remove swapcache page early
References: <1364350932-12853-1-git-send-email-minchan@kernel.org>
 <alpine.LNX.2.00.1303271230210.29687@eggly.anvils>
 <433aaa17-7547-4e39-b472-7060ee15e85f@default>
 <20130328010706.GB22908@blaptop>
In-Reply-To: <20130328010706.GB22908@blaptop>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6668.5000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Minchan Kim [mailto:minchan@kernel.org]
> Subject: Re: [RFC] mm: remove swapcache page early
> 
> Hi Dan,
> 
> On Wed, Mar 27, 2013 at 03:24:00PM -0700, Dan Magenheimer wrote:
> > > From: Hugh Dickins [mailto:hughd@google.com]
> > > Subject: Re: [RFC] mm: remove swapcache page early
> > >
> > > I believe the answer is for frontswap/zmem to invalidate the frontswap
> > > copy of the page (to free up the compressed memory when possible) and
> > > SetPageDirty on the PageUptodate PageSwapCache page when swapping in
> > > (setting page dirty so nothing will later go to read it from the
> > > unfreed location on backing swap disk, which was never written).
> >
> > There are two duplication issues:  (1) When can the page be removed
> > from the swap cache after a call to frontswap_store; and (2) When
> > can the page be removed from the frontswap storage after it
> > has been brought back into memory via frontswap_load.
> >
> > This patch from Minchan addresses (1).  The issue you are raising
> 
> No. I am addressing (2).
> 
> > here is (2).  You may not know that (2) has recently been solved
> > in frontswap, at least for zcache.  See frontswap_exclusive_gets_enabled.
> > If this is enabled (and it is for zcache but not yet for zswap),
> > what you suggest (SetPageDirty) is what happens.
> 
> I am blind on zcache so I didn't see it. Anyway, I'd like to address it
> on zram and zswap.

Zswap can enable it trivially by adding a function call in init_zswap.
(Note that it is not enabled by default for all frontswap backends
because it is another complicated tradeoff of cpu time vs memory space
that needs more study on a broad set of workloads.)

I wonder if something like this would have a similar result for zram?
(Completely untested... snippet stolen from swap_entry_free with
SetPageDirty added... doesn't compile yet, but should give you the idea.)

diff --git a/mm/page_io.c b/mm/page_io.c
index 56276fe..2d10988 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -81,7 +81,17 @@ void end_swap_bio_read(struct bio *bio, int err)
 				iminor(bio->bi_bdev->bd_inode),
 				(unsigned long long)bio->bi_sector);
 	} else {
+		struct swap_info_struct *sis;
+
 		SetPageUptodate(page);
+		sis = page_swap_info(page);
+		if (sis->flags & SWP_BLKDEV) {
+			struct gendisk *disk = sis->bdev->bd_disk;
+			if (disk->fops->swap_slot_free_notify) {
+				SetPageDirty(page);
+				disk->fops->swap_slot_free_notify(sis->bdev,
+								  offset);
+			}
+		}
 	}
 	unlock_page(page);
 	bio_put(bio);
