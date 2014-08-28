Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936398AbaH1IyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 04:54:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:14587 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934718AbaH1IyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 04:54:18 -0400
X-AuditID: cbfee61a-f79e46d00000134f-0f-53feee386edc
From: Chao Yu <chao2.yu@samsung.com>
To: "'Changman Lee'" <cm224.lee@samsung.com>
Cc: "'Jaegeuk Kim'" <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <009101cfc119$8e7a5a00$ab6f0e00$@samsung.com>
 <20140828014736.GA6808@lcm>
In-reply-to: <20140828014736.GA6808@lcm>
Subject: RE: [f2fs-dev] [PATCH] f2fs: reposition unlock_new_inode to prevent
 accessing invalid inode
Date: Thu, 28 Aug 2014 16:53:01 +0800
Message-id: <003801cfc29d$a370dad0$ea529070$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJC9zN8uLy8W6ggdThZHmijqLCZcQKHZbFJmusNEiA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t9jQV2Ld/+CDR78lrC4tq+RyeLJ+lnM
	FpcWuVtc3jWHzYHFY9OqTjaP3Qs+M3n0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxvzrP5kL
	bipWzPt4hbmBcaNUFyMnh4SAicSBC7+ZIGwxiQv31rN1MXJxCAlMZ5R49H0LE4Tzg1Hi+uS1
	zCBVbAIqEss7/oN1iAhoSezv6WYBsZkF8iS+XNnCCmILCYRL3Om5zQ5icwpoSJw53gzWKyyQ
	JnFhUg9YnEVAVWLyj3awXl4BS4k7P2+wQdiCEj8m34OaqSWxeVsTK4QtL7F5zVtmiEsVJHac
	fc0IcYOVRMfPRcwQNeISG4/cYpnAKDQLyahZSEbNQjJqFpKWBYwsqxhFUwuSC4qT0nMN9YoT
	c4tL89L1kvNzNzGCo+CZ1A7GlQ0WhxgFOBiVeHgd4v4FC7EmlhVX5h5ilOBgVhLhPXocKMSb
	klhZlVqUH19UmpNafIhRmoNFSZz3QKt1oJBAemJJanZqakFqEUyWiYNTqoFRq+y/95cT1U7P
	vcringTH7C5eZHc/v2LuwaDmWyz/1hyQfnzsHVftvgCDq4fOpmQlyYkkp/b+jmrVF1t9R2bq
	v1uNMX9/bDNJlj1z/qzFqodW7Vf0mcMFFnlsa9lwo6HsXeDB0w9NlM1kFJZ/npRzJ+fcnuCe
	U50G2t6qnzSK/xUunHNAU8RSiaU4I9FQi7moOBEANszZAX4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Changman,

> -----Original Message-----
> From: Changman Lee [mailto:cm224.lee@samsung.com]
> Sent: Thursday, August 28, 2014 9:48 AM
> To: Chao Yu
> Cc: Jaegeuk Kim; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net
> Subject: Re: [f2fs-dev] [PATCH] f2fs: reposition unlock_new_inode to prevent accessing invalid
> inode
> 
> Hi Chao,
> 
> I agree it's correct unlock_new_inode should be located after make_bad_inode.
> 
> About this scenario,
> I think we should check some condition if this could be occured;

I think this condition is the almost impossible but which can happen theoretically.

> A inode allocated newly could be victim by gc thread.
> Then, f2fs_iget called by Thread A have to fail because we handled it as
> bad_inode in Thread B. However, f2fs_iget could still get inode.
> How about check it using is_bad_inode() in f2fs_iget.

Yes, agreed. How about return -EIO when this inode we iget_locked is bad?

Thanks,
Yu

> 
> Thanks,
> 
> On Tue, Aug 26, 2014 at 06:35:29PM +0800, Chao Yu wrote:
> > As the race condition on the inode cache, following scenario can appear:
> > [Thread a]				[Thread b]
> > 					->f2fs_mkdir
> > 					  ->f2fs_add_link
> > 					    ->__f2fs_add_link
> > 					      ->init_inode_metadata failed here
> > ->gc_thread_func
> >   ->f2fs_gc
> >     ->do_garbage_collect
> >       ->gc_data_segment
> >         ->f2fs_iget
> >           ->iget_locked
> >             ->wait_on_inode
> > 					  ->unlock_new_inode
> >         ->move_data_page
> > 					  ->make_bad_inode
> > 					  ->iput
> >
> > When we fail in create/symlink/mkdir/mknod/tmpfile, the new allocated inode
> > should be set as bad to avoid being accessed by other thread. But in above
> > scenario, it allows f2fs to access the invalid inode before this inode was set
> > as bad.
> > This patch fix the potential problem, and this issue was found by code review.
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/namei.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
> > index 6b53ce9..845f1be 100644
> > --- a/fs/f2fs/namei.c
> > +++ b/fs/f2fs/namei.c
> > @@ -134,8 +134,8 @@ static int f2fs_create(struct inode *dir, struct dentry *dentry, umode_t
> mode,
> >  	return 0;
> >  out:
> >  	clear_nlink(inode);
> > -	unlock_new_inode(inode);
> >  	make_bad_inode(inode);
> > +	unlock_new_inode(inode);
> >  	iput(inode);
> >  	alloc_nid_failed(sbi, ino);
> >  	return err;
> > @@ -267,8 +267,8 @@ static int f2fs_symlink(struct inode *dir, struct dentry *dentry,
> >  	return err;
> >  out:
> >  	clear_nlink(inode);
> > -	unlock_new_inode(inode);
> >  	make_bad_inode(inode);
> > +	unlock_new_inode(inode);
> >  	iput(inode);
> >  	alloc_nid_failed(sbi, inode->i_ino);
> >  	return err;
> > @@ -308,8 +308,8 @@ static int f2fs_mkdir(struct inode *dir, struct dentry *dentry, umode_t
> mode)
> >  out_fail:
> >  	clear_inode_flag(F2FS_I(inode), FI_INC_LINK);
> >  	clear_nlink(inode);
> > -	unlock_new_inode(inode);
> >  	make_bad_inode(inode);
> > +	unlock_new_inode(inode);
> >  	iput(inode);
> >  	alloc_nid_failed(sbi, inode->i_ino);
> >  	return err;
> > @@ -354,8 +354,8 @@ static int f2fs_mknod(struct inode *dir, struct dentry *dentry,
> >  	return 0;
> >  out:
> >  	clear_nlink(inode);
> > -	unlock_new_inode(inode);
> >  	make_bad_inode(inode);
> > +	unlock_new_inode(inode);
> >  	iput(inode);
> >  	alloc_nid_failed(sbi, inode->i_ino);
> >  	return err;
> > @@ -688,8 +688,8 @@ release_out:
> >  out:
> >  	f2fs_unlock_op(sbi);
> >  	clear_nlink(inode);
> > -	unlock_new_inode(inode);
> >  	make_bad_inode(inode);
> > +	unlock_new_inode(inode);
> >  	iput(inode);
> >  	alloc_nid_failed(sbi, inode->i_ino);
> >  	return err;
> > --
> > 2.0.0.421.g786a89d
> >
> >
> >
> > ------------------------------------------------------------------------------
> > Slashdot TV.
> > Video for Nerds.  Stuff that matters.
> > http://tv.slashdot.org/
> > _______________________________________________
> > Linux-f2fs-devel mailing list
> > Linux-f2fs-devel@lists.sourceforge.net
> > https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

