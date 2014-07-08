Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbaGHF4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 01:56:18 -0400
Received: from mail.kernel.org ([198.145.19.201]:49753 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbaGHF4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 01:56:17 -0400
Date: Mon, 7 Jul 2014 22:56:13 -0700
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao2.yu@samsung.com>
Cc: "'Changman Lee'" <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [f2fs-dev][PATCH 1/2] f2fs: check name_len of dir entry to
 prevent from deadloop
Message-ID: <20140708055613.GA37622@jmac.local>
References: <000001cf95b5$eac71ad0$c0555070$@samsung.com>
 <20140705064313.GA35795@jmac.local>
 <005f01cf9982$4b8920f0$e29b62d0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <005f01cf9982$4b8920f0$e29b62d0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 09:24:05AM +0800, Chao Yu wrote:
> Hi Jaegeuk,
> 
> > -----Original Message-----
> > From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> > Sent: Saturday, July 05, 2014 2:43 PM
> > To: Chao Yu
> > Cc: Changman Lee; linux-f2fs-devel@lists.sourceforge.net; linux-fsdevel@vger.kernel.org;
> > linux-kernel@vger.kernel.org
> > Subject: Re: [f2fs-dev][PATCH 1/2] f2fs: check name_len of dir entry to prevent from deadloop
> > 
> > Hi Chao,
> > 
> > On Wed, Jul 02, 2014 at 01:23:47PM +0800, Chao Yu wrote:
> > > We assume that modification of some special application could result in zeroed
> > > name_len, or it is consciously made by somebody. We will deadloop in
> > > find_in_block when name_len of dir entry is zero.
> > 
> > Could you explain this a little bit more?
> > I'm not sure how it can happen.
> 
> IMO,
> On one hand, programs like mkfs/fsck/img2simg and f2fs could directly operate
> the raw device, so bugs of these software may be triggered to generate the
> corrupt data such as zeroed name_len.

Well...
If such the programs try to corrupt the f2fs image crucially, the bug should be
fixed inside the programs, not from the workaround through f2fs.

As I mentioned, even though f2fs avoids such the dead loop whatever at that
moment, it will be operating with inconsistent file system status, resulting
in system crash in the near furture finally.

Why should we avoid this specific case only?
It seems that it is a kinda intentional user-made case.
Is it really normal?

> On the other hand, it' could be treated as a potential security problem, because
> user could crafted such a malicious image include zeroed name_len for hacking purpose.

If user can try to do something like that, why do they write zeroed name_len only?
To crash the system, they can do everything.

Thanks,

> Once such special image is being mounted, deadloop could be triggered, finally will
> result in effecting on linux system's running.
> 
> Thanks,
> Yu
> 
> > I think the zeroed name_len would cause some problems in f2fs_add_link.
> > 
> > Thanks,
> > 
> > >
> > > This patch is added for preventing deadloop in above scenario.
> > >
> > > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > > ---
> > >  fs/f2fs/dir.c |   10 ++++++++++
> > >  1 file changed, 10 insertions(+)
> > >
> > > diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
> > > index be8c7af..4316ec5 100644
> > > --- a/fs/f2fs/dir.c
> > > +++ b/fs/f2fs/dir.c
> > > @@ -121,6 +121,16 @@ static struct f2fs_dir_entry *find_in_block(struct page *dentry_page,
> > >  			}
> > >  		}
> > >
> > > +		/* check name_len to prevent from deadloop here */
> > > +		if (unlikely(de->name_len == 0)) {
> > > +			struct inode *inode = dentry_page->mapping->host;
> > > +
> > > +			f2fs_msg(inode->i_sb, KERN_ERR,
> > > +				"zero-length dir entry, ino = %lu, name = %s",
> > > +				(unsigned long)inode->i_ino, name->name);
> > > +			break;
> > > +		}
> > > +
> > >  		bit_start = bit_pos
> > >  				+ GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
> > >  	}
> > > --
> > > 1.7.9.5
> > 
> > --
> > Jaegeuk Kim

-- 
Jaegeuk Kim
