Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbaGBTMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 15:12:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34996 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659AbaGBTMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 15:12:46 -0400
Date: Wed, 2 Jul 2014 12:12:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH] f2fs: check bdi->dirty_exceeded when trying to skip
 data writes
Message-Id: <20140702121245.b940538a410975ca91b40cfc@linux-foundation.org>
In-Reply-To: <20140702093126.GA25404@jmac.local>
References: <1403956718-17575-1-git-send-email-jaegeuk@kernel.org>
	<20140701225420.6cc94fb5.akpm@linux-foundation.org>
	<20140702093126.GA25404@jmac.local>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2014 02:31:26 -0700 Jaegeuk Kim <jaegeuk@kernel.org> wrote:

> > > --- a/fs/f2fs/node.c
> > > +++ b/fs/f2fs/node.c
> > > @@ -43,6 +43,8 @@ bool available_free_memory(struct f2fs_sb_info *sbi, int type)
> > >  		mem_size = (nm_i->nat_cnt * sizeof(struct nat_entry)) >> 12;
> > >  		res = mem_size < ((val.totalram * nm_i->ram_thresh / 100) >> 2);
> > >  	} else if (type == DIRTY_DENTS) {
> > > +		if (sbi->sb->s_bdi->dirty_exceeded)
> > > +			return false;
> > >  		mem_size = get_pages(sbi, F2FS_DIRTY_DENTS);
> > >  		res = mem_size < ((val.totalram * nm_i->ram_thresh / 100) >> 1);
> > >  	}
> > 
> > err, filesystems should not be playing around with this.
> > 
> > Perhaps VFS changes are needed.  Please tell us much much more about
> > what is going on here.
> 
> The f2fs has a feature which throttles IOs to merge bios in the fs level as much
> as possible by bypassing writepages in some cases.

OK, I just looked at fs/f2fs/data.c.  AFAICT it has basically
bypassed/reimplemented/worked around the VFS.

That may be good or it may be bad.  Maybe it indicates shortcomings in
the VFS, maybe it doesn't.  Presumably there were good reasons for this
design but I am unable to determine what they were, because the code is
undocumented.  No description of what it is trying to achieve or how or
why.  It's just a great blob of C statements.

This is all rather a shame, because perhaps there were opportunities
here to improve the core VFS.

Oh well, I think I'll pretend I never saw it.  Good luck!
