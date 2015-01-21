Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbbAUIma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 03:42:30 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:19700 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbbAUImY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 03:42:24 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-0a-54bf666ef6bb
From: Chao Yu <chao2.yu@samsung.com>
To: "'Changman Lee'" <cm224.lee@gmail.com>
Cc: "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'Changman Lee'" <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <000a01d02e37$8e245890$aa6d09b0$@samsung.com>
 <CAN863PvqoS4EpUJRLYxhra6ZyUG6ATMSGnJh_NNj_QpznUuu6Q@mail.gmail.com>
In-reply-to: <CAN863PvqoS4EpUJRLYxhra6ZyUG6ATMSGnJh_NNj_QpznUuu6Q@mail.gmail.com>
Subject: RE: [f2fs-dev][RFC PATCH 06/10] f2fs: add core functions for rb-tree
 extent cache
Date: Wed, 21 Jan 2015 16:41:17 +0800
Message-id: <00a501d03556$2a882750$7f9875f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKeVPLQy9+F4bGTWoVZW3/EA2BwswHrFpenmx4up5A=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsVy+t9jQd28tP0hBo296hZnerrZLK7ta2Sy
	eLJ+FrPFpUXuFpd3zWFzYPXYOesuu8emVZ1sHrsXfGby6NuyitHj8ya5ANYoLpuU1JzMstQi
	fbsErozrtx6yF5y3qrj3+xNbA+MsjS5GTg4JAROJEy/amCBsMYkL99azdTFycQgJTGeUeLBq
	PjOE84NRYurR2YwgVWwCKhLLO/6DdYgIaEjMavjMAlLELDCNUWL274dMEB0NjBIrj59lA6ni
	FAiWuHR4PQuILSwQI9H/9iXQWA4OFgFViVdHakHCvAKWEntXH2GDsAUlfky+B1bOLKAuMWne
	ImYIW15i85q3zBCnKkjsOPuaEWSMiICVxLx+VogScYmNR26xTGAUmoVk0iwkk2YhmTQLScsC
	RpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMGR8Ux6B+OqBotDjAIcjEo8vC8U94cIsSaW
	FVfmHmKU4GBWEuFVlAAK8aYkVlalFuXHF5XmpBYfYpTmYFES51WybwsREkhPLEnNTk0tSC2C
	yTJxcEo1MFodSGn5UPl8Te65w0/jGhp/3mllYZlzvepyw+8/klan1hUanAiZqvchJz8id0lZ
	ddbe7Xt36HVo3mfhv2t2KEWlWePSE9sXb13exP8uZ8wQ3rv2PpNUgZg218UlNSKH/tpLVk18
	Jb7cLGfFi6M7WactK2DJqVh+2v+N5wb7QCm2VzJfxLOzzyqxFGckGmoxFxUnAgAc4ERWiAIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Changman,

> -----Original Message-----
> From: Changman Lee [mailto:cm224.lee@gmail.com]
> Sent: Tuesday, January 20, 2015 11:06 PM
> To: Chao Yu
> Cc: Jaegeuk Kim; Changman Lee; linux-f2fs-devel@lists.sourceforge.net;
> linux-kernel@vger.kernel.org
> Subject: Re: [f2fs-dev][RFC PATCH 06/10] f2fs: add core functions for rb-tree extent cache
> 
> Hi Chao,
> 
> Great works. :)

Thanks! :)

> 
> 2015-01-12 16:14 GMT+09:00 Chao Yu <chao2.yu@samsung.com>:
> > This patch adds core functions including slab cache init function and
> > init/lookup/update/shrink/destroy function for rb-tree based extent cache.
> >
> > Thank Jaegeuk Kim and Changman Lee as they gave much suggestion about detail
> > design and implementation of extent cache.
> >
> > Todo:
> >  * add a cached_ei into struct extent_tree for a quick recent cache.
> >  * register rb-based extent cache shrink with mm shrink interface.
> >  * disable dir inode's extent cache.
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > Signed-off-by: Changman Lee <cm224.lee@samsung.com>

If you do not object, I'd like to keep this as lots of details and ideas are from
you and Jaegeuk.

> > ---
> >  fs/f2fs/data.c | 458 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/f2fs/node.c |   9 +-
> >  2 files changed, 466 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> > index 4f5b871e..bf8c5eb 100644
> > --- a/fs/f2fs/data.c
> > +++ b/fs/f2fs/data.c
> > @@ -25,6 +25,9 @@
> >  #include "trace.h"
> >  #include <trace/events/f2fs.h>
> >
> 
> ~ snip ~
> 
> > +
> > +static void f2fs_update_extent_tree(struct inode *inode, pgoff_t fofs,
> > +                                                       block_t blkaddr)
> > +{
> > +       struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
> > +       nid_t ino = inode->i_ino;
> > +       struct extent_tree *et;
> > +       struct extent_node *en = NULL, *en1 = NULL, *en2 = NULL, *en3 = NULL;
> > +       struct extent_node *den = NULL;
> > +       struct extent_info *pei;
> > +       struct extent_info ei;
> > +       unsigned int endofs;
> > +
> > +       if (is_inode_flag_set(F2FS_I(inode), FI_NO_EXTENT))
> > +               return;
> > +
> > +retry:
> > +       down_write(&sbi->extent_tree_lock);
> > +       et = radix_tree_lookup(&sbi->extent_tree_root, ino);
> > +       if (!et) {
> 
> We've already made some useful functions.
> How about using f2fs_kmem_cache_alloc and f2fs_radix_tree_insert ?

IMO, we'd better to use original function kmem_cache_alloc and radix_tree_insert,
because if we use f2fs_{kmem_cache_alloc, radix_tree_insert}, we may loop in these
functions without releasing extent_tree_lock lock when OOM, so it will block lock
grabbers for long time which we do not wish to see.

> 
> > +               et = kmem_cache_alloc(extent_tree_slab, GFP_ATOMIC);
> > +               if (!et) {
> > +                       up_write(&sbi->extent_tree_lock);
> > +                       goto retry;
> > +               }
> > +               if (radix_tree_insert(&sbi->extent_tree_root, ino, et)) {
> > +                       up_write(&sbi->extent_tree_lock);
> > +                       kmem_cache_free(extent_tree_slab, et);
> > +                       goto retry;
> > +               }
> > +               memset(et, 0, sizeof(struct extent_tree));
> > +               et->ino = ino;
> > +               et->root = RB_ROOT;
> > +               rwlock_init(&et->lock);
> > +               atomic_set(&et->refcount, 0);
> > +               et->count = 0;
> > +               sbi->total_ext_tree++;
> > +       }
> > +       atomic_inc(&et->refcount);
> > +       up_write(&sbi->extent_tree_lock);
> > +
> 
> ~ snip ~
> 
> > +
> > +       write_unlock(&et->lock);
> > +       atomic_dec(&et->refcount);
> > +}
> > +
> > +void f2fs_shrink_extent_tree(struct f2fs_sb_info *sbi, int nr_shrink)
> > +{
> > +       struct extent_tree *treevec[EXT_TREE_VEC_SIZE];
> > +       struct extent_node *en, *tmp;
> > +       unsigned long ino = F2FS_ROOT_INO(sbi);
> > +       struct radix_tree_iter iter;
> > +       void **slot;
> > +       unsigned int found;
> > +       unsigned int node_cnt = 0, tree_cnt = 0;
> > +
> > +       if (available_free_memory(sbi, EXTENT_CACHE))
> > +               return;
> > +
> > +       spin_lock(&sbi->extent_lock);
> > +       list_for_each_entry_safe(en, tmp, &sbi->extent_list, list) {
> > +               if (!nr_shrink--)
> > +                       break;
> > +               list_del_init(&en->list);
> > +       }
> > +       spin_unlock(&sbi->extent_lock);
> > +
> 
> IMHO, it's expensive to retrieve all extent_tree to free extent_node
> that list_empty() is true.

Yes, it will cause heavy overhead to release extent_node in extent cache
which has huge number of extent_node.

> Is there any idea to improve this?
> For example, if each extent_node has its extent_root, it would be more
> fast by not to retrieve all trees.
> Of course, however, it uses more memory.

I think your solution is a good way to improve the performance.

> 
> But, I think that your patchset might just as well be merged because
> patches are well made and it's clearly separated with mount option. 

I hope so.

> In the next time, we could improve this.

There are also some thoughts in *todo* list, these can be added to developing list
if this patch set is applied.

Thanks for your review and suggestion! :)

Regards,
Yu

> 
> Regards,
> Changman
> 
> > +       down_read(&sbi->extent_tree_lock);
> > +       while ((found = radix_tree_gang_lookup(&sbi->extent_tree_root,
> > +                               (void **)treevec, ino, EXT_TREE_VEC_SIZE))) {
> > +               unsigned i;
> > +
> > +               ino = treevec[found - 1]->ino + 1;
> > +               for (i = 0; i < found; i++) {
> > +                       struct extent_tree *et = treevec[i];
> > +
> > +                       atomic_inc(&et->refcount);
> > +                       write_lock(&et->lock);
> > +                       node_cnt += __free_extent_tree(sbi, et, false);
> > +                       write_unlock(&et->lock);
> > +                       atomic_dec(&et->refcount);
> > +               }
> > +       }
> > +       up_read(&sbi->extent_tree_lock);
> > +
> > +       down_write(&sbi->extent_tree_lock);
> > +       radix_tree_for_each_slot(slot, &sbi->extent_tree_root, &iter,
> > +                                                       F2FS_ROOT_INO(sbi)) {
> > +               struct extent_tree *et = (struct extent_tree *)*slot;
> > +
> > +               if (!atomic_read(&et->refcount) && !et->count) {
> > +                       radix_tree_delete(&sbi->extent_tree_root, et->ino);
> > +                       kmem_cache_free(extent_tree_slab, et);
> > +                       sbi->total_ext_tree--;
> > +                       tree_cnt++;
> > +               }
> > +       }
> > +       up_write(&sbi->extent_tree_lock);
> > +}
> > +
> 
> ~ snip ~
> 
> > --
> > 2.2.1
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/

