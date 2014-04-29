Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515AbaD2INS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:13:18 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:55538 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756455AbaD2INN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:13:13 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-53-535f5f18f2b0
From: Chao Yu <chao2.yu@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <001801cf6370$e0553040$a0ff90c0$@samsung.com>
 <1398752174.13268.4.camel@kjgkr> <001901cf6380$43643c80$ca2cb580$@samsung.com>
 <1398758534.13268.8.camel@kjgkr>
In-reply-to: <1398758534.13268.8.camel@kjgkr>
Subject: RE: [f2fs-dev][PATCH 3/3 v3] f2fs: fix to truncate inline data in
 inode page when setattr
Date: Tue, 29 Apr 2014 16:12:27 +0800
Message-id: <001a01cf6382$dcf18db0$96d4a910$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQK5SRT2d708D3IY6HeK19r/RY85WQJfKFt6AmW4LbwBhDbBUJkiKdXA
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9jAV2J+Phgg2vH1C2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgynh4+jpzwTH1ii8T
	1rI2MG6U62Lk5JAQMJF49X0lC4QtJnHh3nq2LkYuDiGBRYwST3etZYVwfjBK/G9ayghSxSag
	IrG84z8TiC0iIC0x69M8sG5mgUyJe00zmCEa1jJKXJwCkeAEunr18V1gzcICKRJnnn0As1kE
	VCW2L/gPVsMrYCnRtv0BM4QtKPFj8j2gOAfQUHWJKVNyIeZrSzx5d4EV4lIFiR1nXzNC3OAm
	cW/yDHaIGnGJjUdusUxgFJqFZNIshEmzkEyahaRjASPLKkbR1ILkguKk9FxDveLE3OLSvHS9
	5PzcTYzgwH8mtYNxZYPFIUYBDkYlHl6DqLhgIdbEsuLK3EOMEhzMSiK8+VbxwUK8KYmVValF
	+fFFpTmpxYcYpTlYlMR5D7RaBwoJpCeWpGanphakFsFkmTg4pRoYs733scelph5pXL112+vf
	jmI7XlvNOyGXcXs3k4n7d843n7XrJ1Wb2EzfHxp6acbJXxMudDEcORBkXf3KP3Pv10k1N+ao
	zSi7K75Uv6BpqbXPtA8cf7l3R/W87do4peVUV+Er3ld7HdZLMh2OfrzvuPOZkmaHtvAJnPNi
	p97u0k7P31+084rHfSWW4oxEQy3mouJEAML+rOJ4AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Tuesday, April 29, 2014 4:02 PM
> To: Chao Yu
> Cc: linux-f2fs-devel@lists.sourceforge.net; linux-fsdevel@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: RE: [f2fs-dev][PATCH 3/3 v3] f2fs: fix to truncate inline data in inode page when setattr
> 
> Hi,
> 
> 2014-04-29 (화), 15:53 +0800, Chao Yu:
> > Hi Kim,
> >
> > > -----Original Message-----
> > > From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> > > Sent: Tuesday, April 29, 2014 2:16 PM
> > > To: Chao Yu
> > > Cc: linux-f2fs-devel@lists.sourceforge.net; linux-fsdevel@vger.kernel.org;
> > > linux-kernel@vger.kernel.org
> > > Subject: Re: [f2fs-dev][PATCH 3/3 v3] f2fs: fix to truncate inline data in inode page when
> setattr
> > >
> > > Hi,
> > >
> > > 2014-04-29 (화), 14:03 +0800, Chao Yu:
> > > > Previous we do not truncate inline data in inode page when setattr, so following
> > > > case could still read the inline data which has already truncated:
> > > >
> > > > 1.write inline data
> > > > 2.ftruncate size to 0
> > > > 3.ftruncate size to max inline data size
> > > > 4.read from offset 0
> > > >
> > > > This patch introduces truncate_inline_data() to fix this problem.
> > > >
> > > > change log from v1:
> > > >  o fix a bug and do not truncate first page data after truncate inline data.
> > > > change log from v2:
> > > >  o wait to writeback for inode page if it was already submitted.
> > > >
> > > > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > > > ---
> > > >  fs/f2fs/f2fs.h   |    1 +
> > > >  fs/f2fs/file.c   |    3 +++
> > > >  fs/f2fs/inline.c |   19 +++++++++++++++++++
> > > >  3 files changed, 23 insertions(+)
> > > >
> > > > diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> > > > index 2b67679..676a2c6 100644
> > > > --- a/fs/f2fs/f2fs.h
> > > > +++ b/fs/f2fs/f2fs.h
> > > > @@ -1410,5 +1410,6 @@ bool f2fs_may_inline(struct inode *);
> > > >  int f2fs_read_inline_data(struct inode *, struct page *);
> > > >  int f2fs_convert_inline_data(struct inode *, pgoff_t);
> > > >  int f2fs_write_inline_data(struct inode *, struct page *, unsigned int);
> > > > +void truncate_inline_data(struct inode *, u64);
> > > >  int recover_inline_data(struct inode *, struct page *);
> > > >  #endif
> > > > diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> > > > index b9f4fbf..d97e5c4 100644
> > > > --- a/fs/f2fs/file.c
> > > > +++ b/fs/f2fs/file.c
> > > > @@ -369,6 +369,9 @@ static void truncate_partial_data_page(struct inode *inode, u64 from)
> > > >  	unsigned offset = from & (PAGE_CACHE_SIZE - 1);
> > > >  	struct page *page;
> > > >
> > > > +	if (f2fs_has_inline_data(inode))
> > > > +		return truncate_inline_data(inode, from);
> > > > +
> > > >  	if (!offset)
> > > >  		return;
> > > >
> > > > diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
> > > > index 3258c7c..6a13997 100644
> > > > --- a/fs/f2fs/inline.c
> > > > +++ b/fs/f2fs/inline.c
> > > > @@ -176,6 +176,25 @@ int f2fs_write_inline_data(struct inode *inode,
> > > >  	return 0;
> > > >  }
> > > >
> > > > +void truncate_inline_data(struct inode *inode, u64 from)
> > > > +{
> > > > +	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
> > > > +	struct page *ipage;
> > > > +
> > > > +	if (from >= MAX_INLINE_DATA)
> > > > +		return;
> > > > +
> > > > +	ipage = get_node_page(sbi, inode->i_ino);
> > > > +	if (IS_ERR(ipage))
> > > > +		return;
> > > > +
> > > > +	f2fs_wait_on_page_writeback(ipage, NODE);
> > >
> > > The get_node_page() triggers,
> > >  grab_cache_page_write_begin()
> > >   -> wait_for_stable_page()
> > >      -> wait_on_page_writeback().
> >
> > Oh, it's my mistake for this missing, thanks for the mention.:)
> >
> > >
> > > Any bugs in there?
> >
> > If we wait in grab_cache_page_write_begin(), maybe we will face long time delay
> > or potential deadlock caused by f2fs bio cache. So how about use
> > grab_cache_page & f2fs_wait_on_page_writeback to avoid this?
> 
> Nice catch. :)
> IMO, it'd better merge your v2, and let me investigate all the paths to
> avoid that.
> Is it okay?

It's okay, and thanks for your review. :)
Regards.

> 
> >
> > >
> > > > +	zero_user_segment(ipage, INLINE_DATA_OFFSET + from,
> > > > +				INLINE_DATA_OFFSET + MAX_INLINE_DATA);
> > > > +	set_page_dirty(ipage);
> > > > +	f2fs_put_page(ipage, 1);
> > > > +}
> > > > +
> > > >  int recover_inline_data(struct inode *inode, struct page *npage)
> > > >  {
> > > >  	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
> > >
> > > --
> > > Jaegeuk Kim
> > > Samsung
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> --
> Jaegeuk Kim
> Samsung

