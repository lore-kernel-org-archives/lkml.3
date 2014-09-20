Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369AbaITXWk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 19:22:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:12731 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbaITXWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 19:22:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,562,1406617200"; 
   d="scan'208";a="594356439"
Message-ID: <1411255352.10688.7.camel@yhuang-mobile.sh.intel.com>
Subject: Re: [PATCH 3/3] f2fs: fix roll-forward missing scenarios
From: Huang Ying <ying.huang@intel.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: huang ying <huang.ying.caritas@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Date: Sun, 21 Sep 2014 07:22:32 +0800
In-Reply-To: <20140920162358.GA18133@jaegeuk-mac02.hsd1.ca.comcast.net>
References: <1411019468-2201-1-git-send-email-jaegeuk@kernel.org>
	 <1411019468-2201-3-git-send-email-jaegeuk@kernel.org>
	 <CAC=cRTPotgNXbuPwG95HHuWiicS2OiD5R3HsOqdMG+2b=8ZyEg@mail.gmail.com>
	 <20140920162358.GA18133@jaegeuk-mac02.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-09-20 at 09:23 -0700, Jaegeuk Kim wrote:
> On Thu, Sep 18, 2014 at 09:04:11PM +0800, huang ying wrote:
> > On Thu, Sep 18, 2014 at 1:51 PM, Jaegeuk Kim <jaegeuk@kernel.org> wrote:
> > 
> > > We can summarize the roll forward recovery scenarios as follows.
> > >
> > > [Term] F: fsync_mark, D: dentry_mark
> > >
> > > 1. inode(x) | CP | inode(x) | dnode(F)
> > > -> Update the latest inode(x).
> > >
> > > 2. inode(x) | CP | inode(F) | dnode(F)
> > > -> No problem.
> > >
> > > 3. inode(x) | CP | dnode(F) | inode(x)
> > > -> Recover to the latest dnode(F), and drop the last inode(x)
> > >
> > > 4. inode(x) | CP | dnode(F) | inode(F)
> > > -> No problem.
> > >
> > > 5. CP | inode(x) | dnode(F)
> > > -> The inode(DF) was missing. Should drop this dnode(F).
> > >
> > > 6. CP | inode(DF) | dnode(F)
> > > -> No problem.
> > >
> > > 7. CP | dnode(F) | inode(DF)
> > > -> If f2fs_iget fails, then goto next to find inode(DF).
> > >
> > > 8. CP | dnode(F) | inode(x)
> > > -> If f2fs_iget fails, then goto next to find inode(DF).
> > >    But it will fail due to no inode(DF).
> > >
> > > So, this patch adds some missing points such as #1, #5, #7, and #8.
> > >
> > > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > > ---
> > >  fs/f2fs/recovery.c | 71
> > > +++++++++++++++++++++++++++++++++++++++++++++---------
> > >  1 file changed, 60 insertions(+), 11 deletions(-)
> > >
> > > diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
> > > index 36d4f73..a4eb978 100644
> > > --- a/fs/f2fs/recovery.c
> > > +++ b/fs/f2fs/recovery.c
> > > @@ -14,6 +14,37 @@
> > >  #include "node.h"
> > >  #include "segment.h"
> > >
> > > +/*
> > > + * Roll forward recovery scenarios.
> > > + *
> > > + * [Term] F: fsync_mark, D: dentry_mark
> > > + *
> > > + * 1. inode(x) | CP | inode(x) | dnode(F)
> > > + * -> Update the latest inode(x).
> > > + *
> > > + * 2. inode(x) | CP | inode(F) | dnode(F)
> > > + * -> No problem.
> > > + *
> > > + * 3. inode(x) | CP | dnode(F) | inode(x)
> > > + * -> Recover to the latest dnode(F), and drop the last inode(x)
> > > + *
> > > + * 4. inode(x) | CP | dnode(F) | inode(F)
> > > + * -> No problem.
> > > + *
> > > + * 5. CP | inode(x) | dnode(F)
> > > + * -> The inode(DF) was missing. Should drop this dnode(F).
> > > + *
> > > + * 6. CP | inode(DF) | dnode(F)
> > > + * -> No problem.
> > > + *
> > > + * 7. CP | dnode(F) | inode(DF)
> > > + * -> If f2fs_iget fails, then goto next to find inode(DF).
> > > + *
> > > + * 8. CP | dnode(F) | inode(x)
> > > + * -> If f2fs_iget fails, then goto next to find inode(DF).
> > > + *    But it will fail due to no inode(DF).
> > > + */
> > > +
> > >  static struct kmem_cache *fsync_entry_slab;
> > >
> > >  bool space_for_roll_forward(struct f2fs_sb_info *sbi)
> > > @@ -110,27 +141,32 @@ out:
> > >         return err;
> > >  }
> > >
> > > -static int recover_inode(struct inode *inode, struct page *node_page)
> > > +static void __recover_inode(struct inode *inode, struct page *page)
> > >  {
> > > -       struct f2fs_inode *raw_inode = F2FS_INODE(node_page);
> > > +       struct f2fs_inode *raw = F2FS_INODE(page);
> > > +
> > > +       inode->i_mode = le16_to_cpu(raw->i_mode);
> > > +       i_size_write(inode, le64_to_cpu(raw->i_size));
> > > +       inode->i_atime.tv_sec = le64_to_cpu(raw->i_mtime);
> > > +       inode->i_ctime.tv_sec = le64_to_cpu(raw->i_ctime);
> > > +       inode->i_mtime.tv_sec = le64_to_cpu(raw->i_mtime);
> > > +       inode->i_atime.tv_nsec = le32_to_cpu(raw->i_mtime_nsec);
> > > +       inode->i_ctime.tv_nsec = le32_to_cpu(raw->i_ctime_nsec);
> > > +       inode->i_mtime.tv_nsec = le32_to_cpu(raw->i_mtime_nsec);
> > > +}
> > >
> > > +static int recover_inode(struct inode *inode, struct page *node_page)
> > > +{
> > >         if (!IS_INODE(node_page))
> > >                 return 0;
> > >
> > > -       inode->i_mode = le16_to_cpu(raw_inode->i_mode);
> > > -       i_size_write(inode, le64_to_cpu(raw_inode->i_size));
> > > -       inode->i_atime.tv_sec = le64_to_cpu(raw_inode->i_mtime);
> > > -       inode->i_ctime.tv_sec = le64_to_cpu(raw_inode->i_ctime);
> > > -       inode->i_mtime.tv_sec = le64_to_cpu(raw_inode->i_mtime);
> > > -       inode->i_atime.tv_nsec = le32_to_cpu(raw_inode->i_mtime_nsec);
> > > -       inode->i_ctime.tv_nsec = le32_to_cpu(raw_inode->i_ctime_nsec);
> > > -       inode->i_mtime.tv_nsec = le32_to_cpu(raw_inode->i_mtime_nsec);
> > > +       __recover_inode(inode, node_page);
> > >
> > >         if (is_dent_dnode(node_page))
> > >                 return recover_dentry(node_page, inode);
> > >
> > >         f2fs_msg(inode->i_sb, KERN_NOTICE, "recover_inode: ino = %x, name
> > > = %s",
> > > -                       ino_of_node(node_page), raw_inode->i_name);
> > > +                       ino_of_node(node_page),
> > > F2FS_INODE(node_page)->i_name);
> > >         return 0;
> > >  }
> > >
> > > @@ -183,10 +219,16 @@ static int find_fsync_dnodes(struct f2fs_sb_info
> > > *sbi, struct list_head *head)
> > >                                 break;
> > >                         }
> > >
> > > +                       /*
> > > +                        * CP | dnode(F) | inode(DF)
> > > +                        * For this case, we should not give up now.
> > > +                        */
> > >                         entry->inode = f2fs_iget(sbi->sb,
> > > ino_of_node(page));
> > >                         if (IS_ERR(entry->inode)) {
> > >                                 err = PTR_ERR(entry->inode);
> > >                                 kmem_cache_free(fsync_entry_slab, entry);
> > > +                               if (err == -ENOENT)
> > > +                                       goto next;
> > >                                 break;
> > >                         }
> > >                         list_add_tail(&entry->list, head);
> > > @@ -423,6 +465,13 @@ static int recover_data(struct f2fs_sb_info *sbi,
> > >                 entry = get_fsync_inode(head, ino_of_node(page));
> > >                 if (!entry)
> > >                         goto next;
> > > +               /*
> > > +                * inode(x) | CP | inode(x) | dnode(F)
> > > +                * In this case, we can lose the latest inode(x).
> > > +                * So, call __recover_inode for the inode update.
> > > +                */
> > >
> > 
> > With 2/3, because both IS_CHECKPOINTED and HAS_FSYNCED_INODE flag are unset
> > for inode, we will append a inode(F).
> 
> No, inode(F) is not appended.
> Please check the fsync rule #1.

>From implementation of need_inode_block_update, we do not append an
inode(F) or inode(DF), only if:

  get_nat_flag(e, HAS_LAST_FSYNC) &&
          (get_nat_flag(e, IS_CHECKPOINTED) ||
           get_nat_flag(e, HAS_FSYNCED_INODE)))

e is nat entry for the inode.

For inode(x) | CP | inode(x) | dnode(F)

We have:

HAS_LAST_FSYNC:    true
IS_CHECKPOINTED:   false
HAS_FSYNCED_INODE: false

So we will append a inode(DF) here.

> > So we do not need to call
> > __recover_inode here?

Thought again, __recover_inode here may be helpful here for the
following situation:

inode(x) | CP | inode(x) | dnode(F) | inode(DF)
                                    |
                                    v
                               Sudden power off

That is, sudden power off before writing inode(DF).

So I think we should keep the code, but maybe change the comments?

Best Regards,
Huang, Ying

> > 
> > 
> > > +               if (IS_INODE(page))
> > > +                       __recover_inode(entry->inode, page);
> > >
> > >                 err = do_recover_data(sbi, entry->inode, page, blkaddr);
> > >                 if (err) {
> > > --
> > >


