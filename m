Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbaGNLP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 07:15:29 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:35743 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbaGNLPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 07:15:22 -0400
X-AuditID: cbfee61a-f79e46d00000134f-59-53c3bbc9adc8
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jan Kara'" <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
References: <000901cf9425$71219200$5364b600$@samsung.com>
 <20140714084606.GB30550@quack.suse.cz>
In-reply-to: <20140714084606.GB30550@quack.suse.cz>
Subject: RE: [PATCH] udf: avoid redundant memcpy when writing data in ICB
Date: Mon, 14 Jul 2014 19:14:39 +0800
Message-id: <000601cf9f54$e44cc760$ace65620$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQF3KpomVKbMhDPmeOXi/HU12pwodAIl25ThnD8e6ZA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t9jAd2Tuw8HGxyezG8xe3ozk8XlXXPY
	HJg8ziw4wu7xeZNcAFMUl01Kak5mWWqRvl0CV8aqqe2MBVulK27e/sXYwPhStIuRk0NCwETi
	3auDbBC2mMSFe+uBbC4OIYFFjBJtB+dCOT8YJWZ/u8EEUsUmoCKxvOM/kM3BISIgK3H6ZBlI
	mFlAQeLXvU2sILaQQJLEz6VrwWxOAWOJxsWXwRYIC3hKdO9uZwexWQRUJfp2dYGN5BWwlJh1
	4gALhC0o8WPyPRaImVoS63ceZ4Kw5SU2r3nLDHGogsSOs68ZIU6wklixygmiRFxi45FbLBMY
	hWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwaD+T2sG4ssHi
	EKMAB6MSD28Gx+FgIdbEsuLK3EOMEhzMSiK8UuuAQrwpiZVVqUX58UWlOanFhxilOViUxHkP
	tFoHCgmkJ5akZqemFqQWwWSZODilGhjn/fbKmsE04aKET8j0G1UvuM3vqoffev2LRff6tk1r
	8yTYEsou1+77EF1oMHXCtc8uqy7m8+078/P2Jf0u1YdNz6tPMb80f555w9QhhO1CQvkNt5hT
	BfaziuzKRQ6rZ/bGHN2x4kH7lF2Kdk/V57erKeU8vFXBOuvPrdMWoiINtxhz587tz09VYinO
	SDTUYi4qTgQA6uqf62kCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jan Kara [mailto:jack@suse.cz]
> Sent: Monday, July 14, 2014 4:46 PM
> To: Chao Yu
> Cc: jack@suse.cz; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] udf: avoid redundant memcpy when writing data in ICB
> 
> On Mon 30-06-14 13:37:15, Chao Yu wrote:
> > We have already copied the changed data of page to extent area in ICB when call
> > ->write_end() of adinicb aops, so we do not need to copy them another time in
> > ->writepage() of adinicb aops. SetPageUptodate is redundant too, so it's better
> > to remove these redundant codes.
> >
> > Also it looks more reasonable to set inode dirty after extent area are modified,
> > we'd better move mark_inode_dirty() from ->writepage() to ->write_end().
>   This doesn't look right. The copy is there because the page can be
> modified via mmap as well, not only via buffered write... So if anything,

You're right, I have made a mistake that I have not considered the 'mmap' case,
Thank you for reminding me about that. :)

> we may be able to remove the copy in udf_adinicb_write_end() (actually
> using directly simple_write_end() for that), not the one in
> udf_adinicb_write_begin().

Agreed, valid data within i_size will be copied to ICB cache when we writeback
the page by invoking udf_adinicb_writepage, so the copy in udf_adinicb_write_end
is redundant. So our patch should be modified like the following one, is this right?

---
 fs/udf/file.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/fs/udf/file.c b/fs/udf/file.c
index d80738f..a8dc0f1 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -105,16 +105,6 @@ static int udf_adinicb_write_end(struct file *file,
 			loff_t pos, unsigned len, unsigned copied,
 			struct page *page, void *fsdata)
 {
-	struct inode *inode = mapping->host;
-	unsigned offset = pos & (PAGE_CACHE_SIZE - 1);
-	char *kaddr;
-	struct udf_inode_info *iinfo = UDF_I(inode);
-
-	kaddr = kmap_atomic(page);
-	memcpy(iinfo->i_ext.i_data + iinfo->i_lenEAttr + offset,
-		kaddr + offset, copied);
-	kunmap_atomic(kaddr);
-
 	return simple_write_end(file, mapping, pos, len, copied, page, fsdata);
 }
 
-- 
2.0.1.474.g72c7794


> 
> 								Honza
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/udf/file.c |   12 ++----------
> >  1 file changed, 2 insertions(+), 10 deletions(-)
> >
> > diff --git a/fs/udf/file.c b/fs/udf/file.c
> > index d80738f..3cd0a50 100644
> > --- a/fs/udf/file.c
> > +++ b/fs/udf/file.c
> > @@ -65,17 +65,7 @@ static int udf_adinicb_readpage(struct file *file, struct page *page)
> >  static int udf_adinicb_writepage(struct page *page,
> >  				 struct writeback_control *wbc)
> >  {
> > -	struct inode *inode = page->mapping->host;
> > -	char *kaddr;
> > -	struct udf_inode_info *iinfo = UDF_I(inode);
> > -
> >  	BUG_ON(!PageLocked(page));
> > -
> > -	kaddr = kmap(page);
> > -	memcpy(iinfo->i_ext.i_data + iinfo->i_lenEAttr, kaddr, inode->i_size);
> > -	mark_inode_dirty(inode);
> > -	SetPageUptodate(page);
> > -	kunmap(page);
> >  	unlock_page(page);
> >
> >  	return 0;
> > @@ -115,6 +105,8 @@ static int udf_adinicb_write_end(struct file *file,
> >  		kaddr + offset, copied);
> >  	kunmap_atomic(kaddr);
> >
> > +	mark_inode_dirty(inode);
> > +
> >  	return simple_write_end(file, mapping, pos, len, copied, page, fsdata);
> >  }
> >
> > --
> > 1.7.9.5
> >
> >
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR

