Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbaGIDAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 23:00:08 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:44312 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040AbaGIDAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 23:00:03 -0400
X-AuditID: cbfee61a-f79e46d00000134f-4f-53bcb0300051
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <1404297270-26809-1-git-send-email-jaegeuk@kernel.org>
 <006101cf9992$2a077340$7e1659c0$@samsung.com>
 <20140708063652.GB37622@jmac.local>
In-reply-to: <20140708063652.GB37622@jmac.local>
Subject: RE: [f2fs-dev] [PATCH] f2fs: do checkpoint for the renamed inode
Date: Wed, 09 Jul 2014 10:59:18 +0800
Message-id: <006301cf9b21$df8a42c0$9e9ec840$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKdyc2R7jksmCsoklYob+94qQZLpAKkq/KhArwgrWiZz6k0UA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t9jQV2DDXuCDeZ8ULJ4sn4Ws8WlRe4W
	e/aeZLG4vGsOmwOLx6ZVnWweuxd8ZvL4vEkugDmKyyYlNSezLLVI3y6BK2PS1h2sBVNVK1Ys
	ec/ewLhXtouRk0NCwERi0ZqdrBC2mMSFe+vZuhi5OIQEpjNKbP25hRHC+cEocWN3DztIFZuA
	isTyjv9MILaIgJpE774pYDazQKbEhP4X7BANMxgldv/ZxwaS4BQwkHj35QdQgoNDWMBT4sj8
	CpAwi4CqxIaln8Fm8gpYSrz9NJcJwhaU+DH5HgvETC2J9TuPQ82Xl9i85i0zxKUKEjvOvmaE
	uMFJ4ua762wQNeISG4/cYpnAKDQLyahZSEbNQjJqFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL
	89L1kvNzNzGCQ/+Z1A7GlQ0WhxgFOBiVeHgVePYEC7EmlhVX5h5ilOBgVhLh/eYGFOJNSays
	Si3Kjy8qzUktPsQozcGiJM57oNU6UEggPbEkNTs1tSC1CCbLxMEp1cDoXNPM0vV7tmt8jfnK
	DXFBGTM6BI5KTVRTvnR2yavGlW4OB+cZKX85X6q0qLNnRaZ7nPYTlZZ7QTeD5GUXyz10ZfK5
	Om9qp7r5PGtx5W1pP9JsdRiOHPW/WZDem5Lfqdibbibnz5J2kPv6mywVyYwZ0h1iG3lUq2db
	z/tXH9OT9HsN5zW3N0osxRmJhlrMRcWJAOROlKZ5AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Tuesday, July 08, 2014 2:37 PM
> To: Chao Yu
> Cc: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Subject: Re: [f2fs-dev] [PATCH] f2fs: do checkpoint for the renamed inode
> 
> On Mon, Jul 07, 2014 at 11:17:35AM +0800, Chao Yu wrote:
> > Hi Jaegeuk,
> >
> > > -----Original Message-----
> > > From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> > > Sent: Wednesday, July 02, 2014 6:35 PM
> > > To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> > > linux-f2fs-devel@lists.sourceforge.net
> > > Cc: Jaegeuk Kim
> > > Subject: [f2fs-dev] [PATCH] f2fs: do checkpoint for the renamed inode
> > >
> > > If an inode is renamed, it should be registered as file_lost_pino to conduct
> > > checkpoint at f2fs_sync_file.
> > > Otherwise, the inode cannot be recovered due to no dent_mark in the following
> > > scenario.
> > >
> > > Note that, this scenario is from xfstests/322.
> > >
> > > 1. create "a"
> > > 2. fsync "a"
> > > 3. rename "a" to "b"
> > > 4. fsync "b"
> > > 5. Sudden power-cut
> > >
> > > After recovery is done, "b" should be seen.
> > > However, the result shows "a", since the recovery procedure does not enter
> > > recover_dentry due to no dent_mark.
> >
> > As we know CP is expensive, how about modifying checkpointed value directly
> > in nat cache at step #3? So "b" could be fsynced with dent_mark at step #4.
> 
> Yes, I also thought about that.
> But, when handling the nat cache, one of my concerns was the lock granularity.
> Basically each nat cache entry should be covered by its node page lock, so it
> is a little bit complicate to do something easily in f2fs_rename.
> 
> So, this patch was to fix the bug with a naive approach.
> And we can write additional patch to enhance this too.

Thanks for your explanation! :)

Regards,
Yu

> 
> Thanks,
> 
> >
> > >
> > > The reason is like below.
> > > - The nid of "a" is checkpointed during #2, f2fs_sync_file.
> > > - The inode page for "b" produced by #3 is written without dent_mark by
> > > sync_node_pages.
> > >
> > > So, this patch fixes this bug by assinging file_lost_pino to the "a"'s inode.
> > > If the pino is lost, f2fs_sync_file conducts checkpoint, and then recovers
> > > the latest pino and its dentry information for further recovery.
> > >
> > > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > > ---
> > >  fs/f2fs/namei.c | 10 ++++------
> > >  1 file changed, 4 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
> > > index 96f1dd1..1b3cae0 100644
> > > --- a/fs/f2fs/namei.c
> > > +++ b/fs/f2fs/namei.c
> > > @@ -411,9 +411,6 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
> > >  		}
> > >
> > >  		f2fs_set_link(new_dir, new_entry, new_page, old_inode);
> > > -		down_write(&F2FS_I(old_inode)->i_sem);
> > > -		F2FS_I(old_inode)->i_pino = new_dir->i_ino;
> > > -		up_write(&F2FS_I(old_inode)->i_sem);
> > >
> > >  		new_inode->i_ctime = CURRENT_TIME;
> > >  		down_write(&F2FS_I(new_inode)->i_sem);
> > > @@ -446,6 +443,10 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
> > >  		}
> > >  	}
> > >
> > > +	down_write(&F2FS_I(old_inode)->i_sem);
> > > +	file_lost_pino(old_inode);
> > > +	up_write(&F2FS_I(old_inode)->i_sem);
> > > +
> > >  	old_inode->i_ctime = CURRENT_TIME;
> > >  	mark_inode_dirty(old_inode);
> > >
> > > @@ -455,9 +456,6 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
> > >  		if (old_dir != new_dir) {
> > >  			f2fs_set_link(old_inode, old_dir_entry,
> > >  						old_dir_page, new_dir);
> > > -			down_write(&F2FS_I(old_inode)->i_sem);
> > > -			F2FS_I(old_inode)->i_pino = new_dir->i_ino;
> > > -			up_write(&F2FS_I(old_inode)->i_sem);
> > >  			update_inode_page(old_inode);
> > >  		} else {
> > >  			kunmap(old_dir_page);
> > > --
> > > 1.8.5.2 (Apple Git-48)
> > >
> > >
> > > ------------------------------------------------------------------------------
> > > Open source business process management suite built on Java and Eclipse
> > > Turn processes into business applications with Bonita BPM Community Edition
> > > Quickly connect people, data, and systems into organized workflows
> > > Winner of BOSSIE, CODIE, OW2 and Gartner awards
> > > http://p.sf.net/sfu/Bonitasoft
> > > _______________________________________________
> > > Linux-f2fs-devel mailing list
> > > Linux-f2fs-devel@lists.sourceforge.net
> > > https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
> 
> --
> Jaegeuk Kim

