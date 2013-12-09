Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760295Ab3LICQD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 21:16:03 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:32801 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760192Ab3LICP6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 21:15:58 -0500
X-AuditID: cbfee61a-b7f796d000004313-f4-52a527dd05e0
From: Chao Yu <chao2.yu@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <000501cef263$1c57e710$5507b530$@samsung.com>
 <1386545831.2101.67.camel@kjgkr>
In-reply-to: <1386545831.2101.67.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH 3/3 V2] f2fs: introduce f2fs_cache_node_page()
 to add page into node_inode cache
Date: Mon, 09 Dec 2013 10:14:53 +0800
Message-id: <000901cef484$97536b10$c5fa4130$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQM1EKM7fuPPQQy5873xnWPLUCkM9wEcDPxjl3XxkJA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t9jAd276kuDDOZP47O4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK6Oz7Rl7wX+5in8d
	TxkbGJ9KdDFyckgImEjcO/yYBcIWk7hwbz1bFyMXh5DAIkaJR7O7oZwfjBJHOlYwglSxCahI
	LO/4zwRiiwhIS8z6NA+sm1kgU2LO68msILaQQIzExgezmEFsTgFdidurH7CD2MIChRJn1uwB
	m8MioCrx9+9vMJtXwFLix7a1rBC2oMSPyfegZqpLTJq3iBnC1pZ48u4CK8SlChI7zr5mhLjB
	SmLWvJmsEDXiEhuP3GKZwCg0C8moWUhGzUIyahaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS
	9ZLzczcxgkP/mdQOxpUNFocYBTgYlXh4V7AuDRJiTSwrrsw9xCjBwawkwqt0YkmQEG9KYmVV
	alF+fFFpTmrxIUZpDhYlcd4DrdaBQgLpiSWp2ampBalFMFkmDk6pBsa9O3emmPJaT/5kwGtp
	WbqrY373h8/njSpeLHtwTppNvSZGeQqraNeFP01vS28UiSXsq/RPfur+8/UHnj6l49FfPJ9o
	S23NMPxexClUmOu0ZsX5bBVz1elXpp6b0mCib3ZxwqVXM0Jufytfx3k96OhmJgcz1QN9BeLl
	xyqeqpzMKVmeq5zd0qDEUpyRaKjFXFScCAD7SGuKeQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Monday, December 09, 2013 7:37 AM
> To: Chao Yu
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net
> Subject: Re: [f2fs-dev] [PATCH 3/3 V2] f2fs: introduce f2fs_cache_node_page() to add page into node_inode cache
> 
> 2013-12-06 (금), 17:10 +0800, Chao Yu:
> > This patch introduces f2fs_cache_node_page(), in this function, page which is
> > readed ahead will be copy to node_inode's mapping cache.
> > It will avoid rereading these node pages.
> >
> > change log:
> >  o check validity of grabbed page suggested by Jaegeuk Kim.
> >
> > Suggested-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/node.c |   35 +++++++++++++++++++++++++++++++++++
> >  1 file changed, 35 insertions(+)
> >
> > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> > index 099f06f..3ff98fa 100644
> > --- a/fs/f2fs/node.c
> > +++ b/fs/f2fs/node.c
> > @@ -1600,6 +1600,39 @@ static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
> >  	return 0;
> >  }
> >
> > +/*
> > + * f2fs_cache_node_page() copy updated page data to node_inode cache page.
> > + */
> > +void f2fs_cache_node_page(struct f2fs_sb_info *sbi, struct page *page,
> > +						nid_t nid)
> > +{
> > +	struct address_space *mapping = sbi->node_inode->i_mapping;
> > +	struct page *npage;
> 
> 
> What I meant for the validity was to check the block address to figure
> out this node page is up-to-date or not.
> IOW, something like this.

Yes, you're right.

So, how about the this one?
---
 fs/f2fs/node.c |   39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 099f06f..3e7a336 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1600,13 +1600,46 @@ static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
 	return 0;
 }
 
+/*
+ * f2fs_cache_node_page() check validaty of input page by searching NAT.
+ * Then, it will copy updated data of vaild page to node_inode cache.
+ */
+void f2fs_cache_node_page(struct f2fs_sb_info *sbi, struct page *page,
+						nid_t nid, block_t blkaddr)
+{
+	struct address_space *mapping = sbi->node_inode->i_mapping;
+	struct page *npage;
+	struct node_info ni;
+
+	get_node_info(sbi, nid, &ni);
+
+	if (ni.blk_addr != blkaddr)
+		return;
+
+	npage = grab_cache_page(mapping, nid);
+	if (!npage)
+		return;
+
+	if (PageUptodate(npage)) {
+		f2fs_put_page(npage, 1);
+		return;
+	}
+
+	memcpy(page_address(npage), page_address(page), PAGE_CACHE_SIZE);
+
+	SetPageUptodate(npage);
+	f2fs_put_page(npage, 1);
+
+	return;
+}
+
 int restore_node_summary(struct f2fs_sb_info *sbi,
 			unsigned int segno, struct f2fs_summary_block *sum)
 {
 	struct f2fs_node *rn;
 	struct f2fs_summary *sum_entry;
 	struct page *page, *tmp;
-	block_t addr;
+	block_t addr, blkaddr;
 	int bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
 	int i, last_offset, nrpages, err = 0;
 	LIST_HEAD(page_list);
@@ -1624,6 +1657,7 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
 		if (err)
 			return err;
 
+		blkaddr = addr;
 		list_for_each_entry_safe(page, tmp, &page_list, lru) {
 
 			lock_page(page);
@@ -1633,6 +1667,8 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
 				sum_entry->version = 0;
 				sum_entry->ofs_in_node = 0;
 				sum_entry++;
+				f2fs_cache_node_page(sbi, page,
+					le32_to_cpu(rn->footer.nid), blkaddr);
 			} else {
 				err = -EIO;
 			}
@@ -1640,6 +1676,7 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
 			list_del(&page->lru);
 			unlock_page(page);
 			__free_pages(page, 0);
+			blkaddr++;
 		}
 	}
 	return err;
-- 
1.7.9.5

