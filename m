Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbaHDBnh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 21:43:37 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:63379 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbaHDBnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 21:43:35 -0400
X-AuditID: cbfee61b-f79f86d00000144c-f3-53dee54505ab
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: "'Changman Lee'" <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <017301cfacc1$4b476730$e1d63590$@samsung.com>
 <20140802144223.GA1094@jaegeuk-mac02.hsd1.ca.comcast.net>
In-reply-to: <20140802144223.GA1094@jaegeuk-mac02.hsd1.ca.comcast.net>
Subject: RE: [f2fs-dev][PATCH 2/2] f2fs: invalidate xattr node page when evict
 inode
Date: Mon, 04 Aug 2014 09:42:44 +0800
Message-id: <001c01cfaf85$80323940$8096abc0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFcdiRsv9pB4YnJRHAQxBpVspQQAwIGvyVQnJXlSOA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t9jAV3Xp/eCDfrXyVhc29fIZPFk/Sxm
	i0uL3C327D3JYnF51xw2B1aPTas62Tx2L/jM5NG3ZRWjx+dNcgEsUVw2Kak5mWWpRfp2CVwZ
	+1acZivYJlBx+uk11gbGqbxdjJwcEgImEn8OTWCFsMUkLtxbz9bFyMUhJLCIUeLDyTssIAkh
	gR+MEov3qoDYbAIqEss7/jOB2CICahK9+6YwgTQwC0xmlJjVd5cJoqFU4teNKewgNqeAm8Tj
	l+/BBgkLhEmseTwVzGYRUJVYc74NqIaDg1fAUmLJrzqQMK+AoMSPyffASpgFtCTW7zzOBGHL
	S2xe85YZ4lAFiR1nXzOCtIoIWEkcPi8EUSIusfHILZYJjEKzkEyahWTSLCSTZiFpWcDIsopR
	NLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOBaeSe9gXNVgcYhRgINRiYdXYe/dYCHWxLLiytxD
	jBIczEoivNbX7gUL8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Yah0oJJCeWJKanZpakFoEk2Xi
	4JRqYFTpc3nFp651zdQ6s7vu6tuHMVWiZbHea8TtfvRGOzy7/vm6dEu+knjQt8TZs+6uydV9
	wBA8S3Mq08xD2Ufay3UrzvosnzNH1q8l57N46bw9pvbbVEJZNz5nPbfn/LUzB15wHi64wu63
	OOC+jMCB8MDO28L/LvS6+whs3pWUNOlm7cfm64KZZUosxRmJhlrMRcWJAAYV3eCBAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Saturday, August 02, 2014 10:42 PM
> To: Chao Yu
> Cc: Changman Lee; linux-f2fs-devel@lists.sourceforge.net; linux-fsdevel@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [f2fs-dev][PATCH 2/2] f2fs: invalidate xattr node page when evict inode
> 
> Hi Chao,
> 
> On Thu, Jul 31, 2014 at 09:13:11PM +0800, Chao Yu wrote:
> > When inode is evicted, all the page cache belong to this inode should be
> > released including the xattr node page. But previously we didn't do this, this
> > patch fixed this issue.
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/inode.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
> > index 0e69aa9..8a5403b 100644
> > --- a/fs/f2fs/inode.c
> > +++ b/fs/f2fs/inode.c
> > @@ -267,10 +267,16 @@ int f2fs_write_inode(struct inode *inode, struct writeback_control *wbc)
> >  void f2fs_evict_inode(struct inode *inode)
> >  {
> >  	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
> > +	struct f2fs_inode_info *fi = F2FS_I(inode);
> >
> >  	trace_f2fs_evict_inode(inode);
> > +
> >  	truncate_inode_pages_final(&inode->i_data);
> >
> > +	if (fi->i_xattr_nid)
> > +		invalidate_mapping_pages(NODE_MAPPING(sbi),
> > +					fi->i_xattr_nid, fi->i_xattr_nid);
> 
> It would be good to place this below with invalidate_mapping_paages(ino).
> Since, in the case of deletion, we need to get the xattr node page again
> on the remove_inode_page call path.

Yes, IMO, it will be OK now when using above implementation because we will
invalidate this xattr page in truncate_node(), but I'd like use your method
because it's better to guarantee invalidating xattr page by evict_inode itself.

I will send a v2 patch, and thanks for your suggestion.

Regards,
Yu

> 
> Thanks,
> 
> > +
> >  	if (inode->i_ino == F2FS_NODE_INO(sbi) ||
> >  			inode->i_ino == F2FS_META_INO(sbi))
> >  		goto out_clear;
> > --
> > 2.0.1.474.g72c7794

