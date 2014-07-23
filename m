Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbaGWCOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:14:09 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43621 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbaGWCOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:14:08 -0400
X-AuditID: cbfee61a-f79e46d00000134f-17-53cf1a6c7822
From: Chao Yu <chao2.yu@samsung.com>
To: "'Andrey Tsyvarev'" <tsyvarev@ispras.ru>,
        "'Gu Zheng'" <guz.fnst@cn.fujitsu.com>
Cc: "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Alexey Khoroshilov'" <khoroshilov@ispras.ru>,
        linux-f2fs-devel@lists.sourceforge.net
References: <52F320FC.50803@ispras.ru> <534BC29B.3020408@ispras.ru>
 <53CCF1EC.30008@ispras.ru> <53CDC9AF.2050605@cn.fujitsu.com>
 <53CE3722.60307@ispras.ru>
In-reply-to: <53CE3722.60307@ispras.ru>
Subject: RE: [f2fs-dev] f2fs: Possible use-after-free when umount filesystem
Date: Wed, 23 Jul 2014 10:12:52 +0800
Message-id: <000001cfa61b$c693b350$53bb19f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFytas9PwOSgMpUAzyRX4aA2O7urwLC5OzGAi4uvbQB/hgJVwLFf5LUnBkdw6A=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsVy+t9jAd0cqfPBBvdnals8bz/AbPFk/Sxm
	ix3rdrJbXFrkbnF51xw2i+WX4xzYPP4fnMTsMePfVEaPTas62Tx2L/jM5PF5k1wAaxSXTUpq
	TmZZapG+XQJXxs85L9kKzshUtM95w9LAuEy8i5GTQ0LARGLVrCNMELaYxIV769m6GLk4hAQW
	MUrs2nSbEcL5wSix4/tBRpAqNgEVieUd/8E6RAQCJGb/fM4MUsQssJFRYs/qY1Ad8xklHj/e
	yQJSxSmgLrHh4BH2LkYODmEBH4nPbwpATBYBVYnec2YgFbwClhLfNh5jhLAFJX5MvgfWySyg
	JbF+53EmCFteYvOat8wQlypI7Dj7mhHiBj+Jheu/skLUiEtsPHKLZQKj0Cwko2YhGTULyahZ
	SFoWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiOkGdSOxhXNlgcYhTgYFTi4S2oORcs
	xJpYVlyZe4hRgoNZSYT3scj5YCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1qtA4UE0hNLUrNT
	UwtSi2CyTBycUg2MFsuvHuR9v2v+g4jT0sce28xaNUF5s1tmb32X/7yTVhcnZHBse3De2/dN
	2/P4i2dTJ1uXPf3Z/DlFM6Us6oTcGZ62FAHtDLdnz0Tv7rfPE+C+Z9r4qtfgtJLS7t2Rq2u5
	i5aWXd2mlltjZr5VRlzvw2zXqaJVanuu9a1dmD8p3WJ3X/qMxymVSizFGYmGWsxFxYkA3rfz
	n4wCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrey Gu,

> -----Original Message-----
> From: Andrey Tsyvarev [mailto:tsyvarev@ispras.ru]
> Sent: Tuesday, July 22, 2014 6:04 PM
> To: Gu Zheng
> Cc: Jaegeuk Kim; linux-kernel; Alexey Khoroshilov; linux-f2fs-devel@lists.sourceforge.net
> Subject: Re: [f2fs-dev] f2fs: Possible use-after-free when umount filesystem
> 
> Hi Gu,
> 
> >> Investigation shows, that f2fs_evict_inode, when called for 'meta_inode', uses
> invalidate_mapping_pages() for 'node_inode'.
> >> But 'node_inode' is deleted before 'meta_inode' in f2fs_put_super via iput().
> >>
> >> It seems that in common usage scenario this use-after-free is benign, because 'node_inode'
> remains partially valid data even after kmem_cache_free().
> >> But things may change if, while 'meta_inode' is evicted in one f2fs filesystem, another (mounted)
> f2fs filesystem requests inode from cache, and formely
> >> 'node_inode' of the first filesystem is returned.
> > The analysis seems reasonable. Have you tried to swap the reclaim order of node_inde
> > and meta_inode?
> >
> > diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> > index 870fe19..e114418 100644
> > --- a/fs/f2fs/super.c
> > +++ b/fs/f2fs/super.c
> > @@ -430,8 +430,8 @@ static void f2fs_put_super(struct super_block *sb)
> >          if (sbi->s_dirty && get_pages(sbi, F2FS_DIRTY_NODES))
> >                  write_checkpoint(sbi, true);
> >
> > -       iput(sbi->node_inode);
> >          iput(sbi->meta_inode);
> > +       iput(sbi->node_inode);
> >
> >          /* destroy f2fs internal modules */
> >          destroy_node_manager(sbi);
> >
> > Thanks,
> > Gu
> 
> With reclaim order of node_inode and meta_inode swapped, use-after-free
> error disappears.
> 
> But shouldn't initialization order of these inodes be swapped too?
> As meta_inode uses node_inode, it seems logical that it should be
> initialized after it.

IMO, it's not easy to exchange order of initialization between meta_inode and
node_inode, because we should use meta_inode in get_valid_checkpoint for valid
cp first for usual verification, then init node_inode.

As I checked, nids for both meta_inode and node_inode are reservation, so it's not
necessary for us to invalidate pages which will never alloced.

How about skipping it as following?

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 2cf6962..cafba3c 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -273,7 +273,7 @@ void f2fs_evict_inode(struct inode *inode)
 
 	if (inode->i_ino == F2FS_NODE_INO(sbi) ||
 			inode->i_ino == F2FS_META_INO(sbi))
-		goto no_delete;
+		goto out_clear;
 
 	f2fs_bug_on(get_dirty_dents(inode));
 	remove_dirty_dir_inode(inode);
@@ -295,6 +295,7 @@ void f2fs_evict_inode(struct inode *inode)
 
 	sb_end_intwrite(inode->i_sb);
 no_delete:
-	clear_inode(inode);
 	invalidate_mapping_pages(NODE_MAPPING(sbi), inode->i_ino, inode->i_ino);
+out_clear:
+	clear_inode(inode);
 }

> 
> --
> Best regards,
> 
> Andrey Tsyvarev
> Linux Verification Center, ISPRAS
> web:http://linuxtesting.org
> 
> 
> ------------------------------------------------------------------------------
> Want fast and easy access to all the code in your enterprise? Index and
> search up to 200,000 lines of code with a free copy of Black Duck
> Code Sight - the same software that powers the world's largest code
> search on Ohloh, the Black Duck Open Hub! Try it now.
> http://p.sf.net/sfu/bds
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

