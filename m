Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab3LZCye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 21:54:34 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:62292 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab3LZCyb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 21:54:31 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-9a-52bb9a61b057
From: Chao Yu <chao2.yu@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <002201ceff8c$efbd2da0$cf3788e0$@samsung.com>
 <1388012129.2101.302.camel@kjgkr>
In-reply-to: <1388012129.2101.302.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH 1/3 V2] f2fs: check filename length in
 recover_dentry
Date: Thu, 26 Dec 2013 10:53:39 +0800
Message-id: <000001cf01e5$c9e8a7c0$5db9f740$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJueX9xlPqsTCmpqoBrxwP2EeL6OAFBAuqYmRy/LYA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9jAd3EWbuDDD7PELO4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+PFnDdsBfPEKq6d
	LmpgPCLYxcjJISFgIvH2/BU2CFtM4sK99UA2F4eQwCJGiSe3NjFBOD8YJbobvoJVsQmoSCzv
	+M8EYosISEvM+jSPBcRmFsiUmPN6MiuILSQQK9H58CgziM0poCcxpXkaWI2wQJhE8+Hf7CA2
	i4CqxORD68Dm8ApYSqxbdJAdwhaU+DH5HtRMdYlJ8xYxQ9jaEk/eXWCFuFRBYsfZ14wQN1hJ
	tP/ZxQpRIy6x8cgtlgmMQrOQjJqFZNQsJKNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0L10v
	OT93EyM48J9J7WBc2WBxiFGAg1GJh7dDd3eQEGtiWXFl7iFGCQ5mJRHeXd1AId6UxMqq1KL8
	+KLSnNTiQ4zSHCxK4rwHWq0DhQTSE0tSs1NTC1KLYLJMHJxSDYxsLBaJvizfF3jsFlicbDNL
	YtH3n2ITipSCqvr9+Dfo712asUjnGP++wrNnFnEKhCZ0nD3B/FH2vIngb97uqICd7wzeqVcl
	enZt3PGg0eVg/Lyfr5xWLPr9sIHRQXLi4a8Jc+TStLnmCu3rW85SERN5jXux/Iq1d1n/RSyq
	mreVqyLk0sNJeyKVWIozEg21mIuKEwGseS0FeAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Thursday, December 26, 2013 6:55 AM
> To: Chao Yu
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net
> Subject: Re: [f2fs-dev] [PATCH 1/3 V2] f2fs: check filename length in recover_dentry
> 
> Hi,
> 
> 2013-12-23 (월), 11:12 +0800, Chao Yu:
> > In current flow, we will get Null return value of f2fs_find_entry in
> > recover_dentry when name.len is bigger than F2FS_NAME_LEN, and then we
> > still add this inode into its dir entry.
> > To avoid this situation, we must check filename length before we use it.
> >
> > Another point is that we could remove the code of checking filename length
> > In f2fs_find_entry, because f2fs_lookup will be called previously to ensure of
> > validity of filename length.
> 
> The f2fs_find_entry is called by f2fs_unlink and f2fs_rename too.

As I check code and test, f2fs_unlink and f2fs_rename is protected by
f2fs_lookup well.
Oldfile/newfile/deletedfile name length is check previously in f2fs_lookup.

> So, you can't remove this, instead it'd be better remove it from
> f2fs_lookup.

I think verification of filename length could not be removed from lookup.
Ever you remove it, we could create file in f2fs device with filename length
that vfs not supported.
In my test, kernel seems not be stable after that kind of file created in f2fs.

> Thanks,
> 
> >
> > V2:
> >  o add WARN_ON() as Jaegeuk Kim suggested.
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/dir.c      |    3 ---
> >  fs/f2fs/recovery.c |    6 ++++++
> >  2 files changed, 6 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
> > index 07ad850..f0b4630 100644
> > --- a/fs/f2fs/dir.c
> > +++ b/fs/f2fs/dir.c
> > @@ -190,9 +190,6 @@ struct f2fs_dir_entry *f2fs_find_entry(struct inode *dir,
> >  	unsigned int max_depth;
> >  	unsigned int level;
> >
> > -	if (unlikely(namelen > F2FS_NAME_LEN))
> > -		return NULL;
> > -
> >  	if (npages == 0)
> >  		return NULL;
> >
> > diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
> > index a3f4542..4d411a2 100644
> > --- a/fs/f2fs/recovery.c
> > +++ b/fs/f2fs/recovery.c
> > @@ -62,6 +62,12 @@ static int recover_dentry(struct page *ipage, struct inode *inode)
> >
> >  	name.len = le32_to_cpu(raw_inode->i_namelen);
> >  	name.name = raw_inode->i_name;
> > +
> > +	if (unlikely(name.len > F2FS_NAME_LEN)) {
> > +		WARN_ON(1);
> > +		err = -ENAMETOOLONG;
> > +		goto out;
> > +	}
> >  retry:
> >  	de = f2fs_find_entry(dir, &name, &page);
> >  	if (de && inode->i_ino == le32_to_cpu(de->ino))
> 
> --
> Jaegeuk Kim
> Samsung

