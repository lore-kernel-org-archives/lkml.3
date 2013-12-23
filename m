Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904Ab3LWC3p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 21:29:45 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:32800 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738Ab3LWC3n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 21:29:43 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-1e-52b7a0168d2f
From: Chao Yu <chao2.yu@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <000001cefe33$b62a0f40$227e2dc0$@samsung.com>
 <1387761931.2101.289.camel@kjgkr>
In-reply-to: <1387761931.2101.289.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH 1/3] f2fs: check filename length in
 recover_dentry
Date: Mon, 23 Dec 2013 10:28:52 +0800
Message-id: <002101ceff86$d50072c0$7f015840$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKr2GgGd4VXAJjpeSh/aqvung1/zAJV5AFhmJSgtWA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t9jAV2xBduDDBYfFLG4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+PhEs6CZ8IVS+7f
	ZW1gPMjfxcjJISFgIrF/33EmCFtM4sK99WxdjFwcQgKLGCW2LrrJDuH8YJRo37MRrIpNQEVi
	ecd/MFtEQFpi1qd5LCA2s0CmxJzXk1lBbCGBWIkb77vA4pwCehLT/88BqxcWCJb42dPJBmKz
	CKhKnL5zkhnE5hWwlDi95y8bhC0o8WPyPaBeDqCZ6hJTpuRCjNeWePLuAivEoQoSO86+ZoQ4
	wUri8+I9rBA14hIbj9ximcAoNAvJpFkIk2YhmTQLSccCRpZVjKKpBckFxUnpuYZ6xYm5xaV5
	6XrJ+bmbGMFB/0xqB+PKBotDjAIcjEo8vBwt24OEWBPLiitzDzFKcDArifBG/9gWJMSbklhZ
	lVqUH19UmpNafIhRmoNFSZz3QKt1oJBAemJJanZqakFqEUyWiYNTqoGR78ARxUVLnrGoR70t
	6bef/8BPMbAiUW1X7eJE39S/Pi5Nag9NTOsum5lcKs1/dfW5YFHNhlh7b1mZNGW7aY2L/jT9
	d584W9cklHHWnEy3/8bfVP+6T/0jnLG5ZvHtXJ+M3bPVBJ9c7j79es2FHZGfgtu874ef1rrC
	PSO1R0xAtf2r+TLR4+JKLMUZiYZazEXFiQBqOuLadgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Monday, December 23, 2013 9:26 AM
> To: Chao Yu
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net
> Subject: Re: [f2fs-dev] [PATCH 1/3] f2fs: check filename length in recover_dentry
> 
> 2013-12-21 (토), 18:01 +0800, Chao Yu:
> > In current flow, we will get Null return value of f2fs_find_entry in
> > recover_dentry when name.len is bigger than F2FS_NAME_LEN, and then we
> > still add this inode into its dir entry.
> > To avoid this situation, we must check filename length before we use it.
> >
> > Another point is that we could remove the code of checking filename length
> > In f2fs_find_entry, because f2fs_lookup will be called previously to ensure of
> > validity of filename length.
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/dir.c      |    3 ---
> >  fs/f2fs/recovery.c |    5 +++++
> >  2 files changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
> > index 0cc26ba..3f3b661 100644
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
> > index a3f4542..fdd175b 100644
> > --- a/fs/f2fs/recovery.c
> > +++ b/fs/f2fs/recovery.c
> > @@ -62,6 +62,11 @@ static int recover_dentry(struct page *ipage, struct inode *inode)
> >
> >  	name.len = le32_to_cpu(raw_inode->i_namelen);
> >  	name.name = raw_inode->i_name;
> > +
> > +	if (unlikely(name.len > F2FS_NAME_LEN)) {
> > +		err = -ENAMETOOLONG;
> > +		goto out;
> > +	}
> 
> Have you seen this before?

Not yet.

> This is a trivial bug case, so, if you have got this bug, we should fix
> the bug first instead of adding any workaround patch.

What I worry about is that not only f2fs bug lead to this trivial problem,
but also other program with operation in raw disk could do this.

> Let's add WARN_ON() at least.

Alright.
Thanks.

> Thanks,
> 
> >  retry:
> >  	de = f2fs_find_entry(dir, &name, &page);
> >  	if (de && inode->i_ino == le32_to_cpu(de->ino))
> 
> --
> Jaegeuk Kim
> Samsung

