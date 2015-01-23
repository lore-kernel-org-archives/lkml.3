Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbbAWTD4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 14:03:56 -0500
Received: from mail.kernel.org ([198.145.29.136]:51026 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364AbbAWTDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 14:03:53 -0500
Date: Fri, 23 Jan 2015 11:03:49 -0800
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH 2/2] f2fs: do checkpoint when umount flag is
 not set
Message-ID: <20150123190349.GB22493@jaegeuk-mac02.mot.com>
References: <1421971730-17024-1-git-send-email-jaegeuk@kernel.org>
 <1421971730-17024-2-git-send-email-jaegeuk@kernel.org>
 <000501d036f8$f5e99660$e1bcc320$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000501d036f8$f5e99660$e1bcc320$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 06:39:25PM +0800, Chao Yu wrote:
> > -----Original Message-----
> > From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> > Sent: Friday, January 23, 2015 8:09 AM
> > To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> > linux-f2fs-devel@lists.sourceforge.net
> > Cc: Jaegeuk Kim
> > Subject: [f2fs-dev] [PATCH 2/2] f2fs: do checkpoint when umount flag is not set
> > 
> > If the previous checkpoint was done without CP_UMOUNT flag, it needs to do
> > checkpoint with CP_UMOUNT for the next fast boot.
> > 
> > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> 
> Reviewed-by: Chao Yu <chao2.yu@samsung.com>
> 
> > ---
> >  fs/f2fs/checkpoint.c | 3 ++-
> >  fs/f2fs/super.c      | 3 ++-
> >  2 files changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> > index 9f5317c..231d8c9 100644
> > --- a/fs/f2fs/checkpoint.c
> > +++ b/fs/f2fs/checkpoint.c
> > @@ -1043,7 +1043,8 @@ void write_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
> > 
> >  	mutex_lock(&sbi->cp_mutex);
> > 
> > -	if (!sbi->s_dirty && cpc->reason != CP_DISCARD)
> > +	if (!sbi->s_dirty &&
> > +			cpc->reason != CP_DISCARD && cpc->reason != CP_UMOUNT)
> >  		goto out;
> >  	if (unlikely(f2fs_cp_error(sbi)))
> >  		goto out;
> > diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> > index 84f95cd..6ef1458 100644
> > --- a/fs/f2fs/super.c
> > +++ b/fs/f2fs/super.c
> > @@ -448,7 +448,8 @@ static void f2fs_put_super(struct super_block *sb)
> >  	stop_gc_thread(sbi);
> > 
> >  	/* We don't need to do checkpoint when it's clean */
> 
> Better to update the annotation above.

Added some comments. :)

Thanks,

> 
> Thanks,
> Yu
> 
> > -	if (sbi->s_dirty) {
> > +	if (sbi->s_dirty ||
> > +			!is_set_ckpt_flags(F2FS_CKPT(sbi), CP_UMOUNT_FLAG)) {
> >  		struct cp_control cpc = {
> >  			.reason = CP_UMOUNT,
> >  		};
> > --
> > 2.1.1
> > 
