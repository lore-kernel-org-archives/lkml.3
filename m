Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab3IPNyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 09:54:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab3IPNys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 09:54:48 -0400
Subject: Re: [PATCH 07/11] gfs2: pass correct dentry to finish_open() in
 __gfs2_lookup()
From: Steven Whitehouse <swhiteho@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mszeredi@suse.cz, stable@vger.kernel.org
In-Reply-To: <20130916133422.GA31733@tucsk.piliscsaba.szeredi.hu>
References: <1379335925-30858-1-git-send-email-miklos@szeredi.hu>
	 <1379335925-30858-8-git-send-email-miklos@szeredi.hu>
	 <1379337194.2718.16.camel@menhir>
	 <20130916133422.GA31733@tucsk.piliscsaba.szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 16 Sep 2013 14:54:54 +0100
Message-ID: <1379339694.2718.21.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2013-09-16 at 15:34 +0200, Miklos Szeredi wrote:
> On Mon, Sep 16, 2013 at 02:13:14PM +0100, Steven Whitehouse wrote:
> > Hi,
> > 
> > On Mon, 2013-09-16 at 14:52 +0200, Miklos Szeredi wrote:
> > > From: Miklos Szeredi <mszeredi@suse.cz>
> > > 
> > > AFAICS if d_splice_alias() returned non-NULL, this code would Oops
> > > (finish_open expects an instantiated dentry).
> > > 
> > > Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> > > Cc: Steven Whitehouse <swhiteho@redhat.com>
> > > Cc: stable@vger.kernel.org
> > > ---
> > >  fs/gfs2/inode.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
> > > index 6d7f976..abe7dae 100644
> > > --- a/fs/gfs2/inode.c
> > > +++ b/fs/gfs2/inode.c
> > > @@ -774,7 +774,7 @@ static struct dentry *__gfs2_lookup(struct inode *dir, struct dentry *dentry,
> > >  
> > >  	d = d_splice_alias(inode, dentry);
> > >  	if (file && S_ISREG(inode->i_mode))
> > > -		error = finish_open(file, dentry, gfs2_open_common, opened);
> > > +		error = finish_open(file, d ? d : dentry, gfs2_open_common, opened);
> > >  
> > >  	gfs2_glock_dq_uninit(&gh);
> > >  	if (error)
> > 
> > Not sure I understand why this is required... when the inode is a
> > regular file, d can only be an error (if the inode is an error) or it
> > will be NULL.
> 
> Okay, you're right.  Still, something like the following should make this clear
> and ensure things don't break in the future.
> 
or better still, just add a comment to explain the situation as the
reader may still be wondering why that BUG_ON() will never trigger,

Steve.

> Thanks,
> Miklos
> 
> ---
>  fs/gfs2/inode.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> --- a/fs/gfs2/inode.c
> +++ b/fs/gfs2/inode.c
> @@ -775,8 +775,10 @@ static struct dentry *__gfs2_lookup(stru
>  	}
>  
>  	d = d_splice_alias(inode, dentry);
> -	if (file && S_ISREG(inode->i_mode))
> +	if (file && S_ISREG(inode->i_mode)) {
> +		BUG_ON(d);
>  		error = finish_open(file, dentry, gfs2_open_common, opened);
> +	}
>  
>  	gfs2_glock_dq_uninit(&gh);
>  	if (error)


