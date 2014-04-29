Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbaD2Hyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 03:54:38 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:12142 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbaD2Hyh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 03:54:37 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-cd-535f5abbcbc5
From: Chao Yu <chao2.yu@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <001801cf6370$e0553040$a0ff90c0$@samsung.com>
 <1398752174.13268.4.camel@kjgkr>
In-reply-to: <1398752174.13268.4.camel@kjgkr>
Subject: RE: [f2fs-dev][PATCH 3/3 v3] f2fs: fix to truncate inline data in
 inode page when setattr
Date: Tue, 29 Apr 2014 15:53:44 +0800
Message-id: <001901cf6380$43643c80$ca2cb580$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQK5SRT2d708D3IY6HeK19r/RY85WQJfKFt6mUFdK/A=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t9jQd3dUfHBBjs2G1lc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXG//SBLwSOZimX7
	b7A1ML4W62Lk5JAQMJH4cO4cG4QtJnHh3nowW0hgOqPE9s0CXYxcQPYPRolvG16xgyTYBFQk
	lnf8ZwKxRQSkJWZ9mscCYjMLZErca5rBDNEcI3F3TidYPaeArsThfxC2sECKxJlnHxhBbBYB
	VYnOZ7PAenkFLCX2zZoCZQtK/Jh8D8jmAJqpLjFlSi7EeG2JJ+8usELcqSCx4+xrRogTrCQm
	X7jFDlEjLrHxyC2WCYxCs5BMmoUwaRaSSbOQdCxgZFnFKJpakFxQnJSea6hXnJhbXJqXrpec
	n7uJERz0z6R2MK5ssDjEKMDBqMTDaxAVFyzEmlhWXJl7iFGCg1lJhDffKj5YiDclsbIqtSg/
	vqg0J7X4EKM0B4uSOO+BVutAIYH0xJLU7NTUgtQimCwTB6dUA2PemWQdP235B0svtPk45kUo
	HGgVeZOx4e6M42Wn29cJcISJ7OQXmNS7YvfKA19TumpuvYtR4DzfGZ7HuuKFfwNL/SGn3ITN
	98L55KS5I6Xin/cLe3bWMn8SmxPwZ1PbRKcbK1L33tPrPlqn83VO9iuJM5vyXyxe0KrCv+ns
	6oemS3/Ezo4RkFZiKc5INNRiLipOBAAhAeWWdgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Tuesday, April 29, 2014 2:16 PM
> To: Chao Yu
> Cc: linux-f2fs-devel@lists.sourceforge.net; linux-fsdevel@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [f2fs-dev][PATCH 3/3 v3] f2fs: fix to truncate inline data in inode page when setattr
> 
> Hi,
> 
> 2014-04-29 (화), 14:03 +0800, Chao Yu:
> > Previous we do not truncate inline data in inode page when setattr, so following
> > case could still read the inline data which has already truncated:
> >
> > 1.write inline data
> > 2.ftruncate size to 0
> > 3.ftruncate size to max inline data size
> > 4.read from offset 0
> >
> > This patch introduces truncate_inline_data() to fix this problem.
> >
> > change log from v1:
> >  o fix a bug and do not truncate first page data after truncate inline data.
> > change log from v2:
> >  o wait to writeback for inode page if it was already submitted.
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/f2fs.h   |    1 +
> >  fs/f2fs/file.c   |    3 +++
> >  fs/f2fs/inline.c |   19 +++++++++++++++++++
> >  3 files changed, 23 insertions(+)
> >
> > diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> > index 2b67679..676a2c6 100644
> > --- a/fs/f2fs/f2fs.h
> > +++ b/fs/f2fs/f2fs.h
> > @@ -1410,5 +1410,6 @@ bool f2fs_may_inline(struct inode *);
> >  int f2fs_read_inline_data(struct inode *, struct page *);
> >  int f2fs_convert_inline_data(struct inode *, pgoff_t);
> >  int f2fs_write_inline_data(struct inode *, struct page *, unsigned int);
> > +void truncate_inline_data(struct inode *, u64);
> >  int recover_inline_data(struct inode *, struct page *);
> >  #endif
> > diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> > index b9f4fbf..d97e5c4 100644
> > --- a/fs/f2fs/file.c
> > +++ b/fs/f2fs/file.c
> > @@ -369,6 +369,9 @@ static void truncate_partial_data_page(struct inode *inode, u64 from)
> >  	unsigned offset = from & (PAGE_CACHE_SIZE - 1);
> >  	struct page *page;
> >
> > +	if (f2fs_has_inline_data(inode))
> > +		return truncate_inline_data(inode, from);
> > +
> >  	if (!offset)
> >  		return;
> >
> > diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
> > index 3258c7c..6a13997 100644
> > --- a/fs/f2fs/inline.c
> > +++ b/fs/f2fs/inline.c
> > @@ -176,6 +176,25 @@ int f2fs_write_inline_data(struct inode *inode,
> >  	return 0;
> >  }
> >
> > +void truncate_inline_data(struct inode *inode, u64 from)
> > +{
> > +	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
> > +	struct page *ipage;
> > +
> > +	if (from >= MAX_INLINE_DATA)
> > +		return;
> > +
> > +	ipage = get_node_page(sbi, inode->i_ino);
> > +	if (IS_ERR(ipage))
> > +		return;
> > +
> > +	f2fs_wait_on_page_writeback(ipage, NODE);
> 
> The get_node_page() triggers,
>  grab_cache_page_write_begin()
>   -> wait_for_stable_page()
>      -> wait_on_page_writeback().

Oh, it's my mistake for this missing, thanks for the mention.:)

> 
> Any bugs in there?

If we wait in grab_cache_page_write_begin(), maybe we will face long time delay
or potential deadlock caused by f2fs bio cache. So how about use
grab_cache_page & f2fs_wait_on_page_writeback to avoid this?

> 
> > +	zero_user_segment(ipage, INLINE_DATA_OFFSET + from,
> > +				INLINE_DATA_OFFSET + MAX_INLINE_DATA);
> > +	set_page_dirty(ipage);
> > +	f2fs_put_page(ipage, 1);
> > +}
> > +
> >  int recover_inline_data(struct inode *inode, struct page *npage)
> >  {
> >  	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
> 
> --
> Jaegeuk Kim
> Samsung

