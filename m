Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbaGHIRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:17:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:20367 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbaGHIQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:16:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,624,1400050800"; 
   d="scan'208";a="566595892"
Message-ID: <1404807412.13519.46.camel@yhuang-dev>
Subject: Re: f2fs: Add f2fs_balance_fs for direct IO
From: Huang Ying <ying.huang@intel.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Changman Lee <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Tue, 08 Jul 2014 16:16:52 +0800
In-Reply-To: <20140708075843.GA59558@jmac>
References: <1404711988-18264-1-git-send-email-ying.huang@intel.com>
	 <20140708075843.GA59558@jmac>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jaegeuk,

On Tue, 2014-07-08 at 00:58 -0700, Jaegeuk Kim wrote:
> Hi Huang,
> 
> It occurs a merge conflict.
> Please check the patch.

Sorry, my fault.  I think I need to base my patch on f2fs tree instead
of latest Linus' tree?

> Anyway, IMO, it needs to place f2fs_balance_fs somewhere in get_data_block.

Yes.  I think so too.  So you prefer to add f2fs_balance_fs in both
f2fs_direct_IO and get_data_block, or just add f2fs_blance_fs in
get_data_block only?

Best Regards,
Huang, Ying

> Thanks,
> 
> On Mon, Jul 07, 2014 at 01:46:28PM +0800, Huang Ying wrote:
> > Otherwise, if a large amount of direct IO writes were done, the
> > segment allocation may be failed because no enough segments are gced.
> > 
> > Signed-off-by: Huang, Ying <ying.huang@intel.com>
> > ---
> >  fs/f2fs/data.c |    6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > --- a/fs/f2fs/data.c
> > +++ b/fs/f2fs/data.c
> > @@ -1038,6 +1038,7 @@ static ssize_t f2fs_direct_IO(int rw, st
> >  {
> >  	struct file *file = iocb->ki_filp;
> >  	struct inode *inode = file->f_mapping->host;
> > +	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
> >  
> >  	/* Let buffer I/O handle the inline data case. */
> >  	if (f2fs_has_inline_data(inode))
> > @@ -1046,8 +1047,11 @@ static ssize_t f2fs_direct_IO(int rw, st
> >  	if (check_direct_IO(inode, rw, iter, offset))
> >  		return 0;
> >  
> > +	if (rw == WRITE)
> > +		f2fs_balance_fs(sbi);
> > +
> >  	/* clear fsync mark to recover these blocks */
> > -	fsync_mark_clear(F2FS_SB(inode->i_sb), inode->i_ino);
> > +	fsync_mark_clear(sbi, inode->i_ino);
> >  
> >  	return blockdev_direct_IO(rw, iocb, inode, iter, offset,
> >  				  get_data_block);
> 


