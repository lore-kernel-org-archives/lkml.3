Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab3IPNd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 09:33:57 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:64323 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab3IPNdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 09:33:55 -0400
Date: Mon, 16 Sep 2013 15:34:22 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mszeredi@suse.cz, stable@vger.kernel.org
Subject: Re: [PATCH 07/11] gfs2: pass correct dentry to finish_open() in
 __gfs2_lookup()
Message-ID: <20130916133422.GA31733@tucsk.piliscsaba.szeredi.hu>
References: <1379335925-30858-1-git-send-email-miklos@szeredi.hu>
 <1379335925-30858-8-git-send-email-miklos@szeredi.hu>
 <1379337194.2718.16.camel@menhir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379337194.2718.16.camel@menhir>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 02:13:14PM +0100, Steven Whitehouse wrote:
> Hi,
> 
> On Mon, 2013-09-16 at 14:52 +0200, Miklos Szeredi wrote:
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > AFAICS if d_splice_alias() returned non-NULL, this code would Oops
> > (finish_open expects an instantiated dentry).
> > 
> > Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> > Cc: Steven Whitehouse <swhiteho@redhat.com>
> > Cc: stable@vger.kernel.org
> > ---
> >  fs/gfs2/inode.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
> > index 6d7f976..abe7dae 100644
> > --- a/fs/gfs2/inode.c
> > +++ b/fs/gfs2/inode.c
> > @@ -774,7 +774,7 @@ static struct dentry *__gfs2_lookup(struct inode *dir, struct dentry *dentry,
> >  
> >  	d = d_splice_alias(inode, dentry);
> >  	if (file && S_ISREG(inode->i_mode))
> > -		error = finish_open(file, dentry, gfs2_open_common, opened);
> > +		error = finish_open(file, d ? d : dentry, gfs2_open_common, opened);
> >  
> >  	gfs2_glock_dq_uninit(&gh);
> >  	if (error)
> 
> Not sure I understand why this is required... when the inode is a
> regular file, d can only be an error (if the inode is an error) or it
> will be NULL.

Okay, you're right.  Still, something like the following should make this clear
and ensure things don't break in the future.

Thanks,
Miklos

---
 fs/gfs2/inode.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -775,8 +775,10 @@ static struct dentry *__gfs2_lookup(stru
 	}
 
 	d = d_splice_alias(inode, dentry);
-	if (file && S_ISREG(inode->i_mode))
+	if (file && S_ISREG(inode->i_mode)) {
+		BUG_ON(d);
 		error = finish_open(file, dentry, gfs2_open_common, opened);
+	}
 
 	gfs2_glock_dq_uninit(&gh);
 	if (error)
