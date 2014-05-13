Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbaEMSxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 14:53:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbaEMSxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 14:53:23 -0400
Date: Tue, 13 May 2014 20:53:13 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>, Jan Kara <jack@suse.cz>,
        Al Viro <viro@ZenIV.linux.org.uk>, Eric Sandeen <esandeen@redhat.com>
Subject: Re: [PATCH 2/2] fs: print a message when freezing/unfreezing
 filesystems
Message-ID: <20140513185312.GB2738@mguzik.redhat.com>
References: <1400005862-3751-1-git-send-email-mguzik@redhat.com>
 <1400005862-3751-2-git-send-email-mguzik@redhat.com>
 <1400006371.24350.45.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1400006371.24350.45.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 11:39:31AM -0700, Joe Perches wrote:
> On Tue, 2014-05-13 at 20:31 +0200, Mateusz Guzik wrote:
> > This helps hang troubleshooting efforts when only dmesg is available.
> []
> > diff --git a/fs/super.c b/fs/super.c
> []
> > @@ -1289,12 +1289,9 @@ int freeze_super(struct super_block *sb)
> >  		return 0;	/* sic - it's "nothing to do" */
> >  	}
> >  
> > -	if (sb->s_flags & MS_RDONLY) {
> > +	if (sb->s_flags & MS_RDONLY)
> >  		/* Nothing to do really... */
> > -		sb->s_writers.frozen = SB_FREEZE_COMPLETE;
> > -		up_write(&sb->s_umount);
> > -		return 0;
> > -	}
> > +		goto out;
> 
> Should this block really be part of this patch?
> If so, please add a small note to the commit log.
> 

This is the same code which you can find at the end of the function.
I added the label so that I can write freeze printk only once.

> I'm not sure making the reader goto out for this
> bit of the code needs doing as there are multiple
> blocks with return above here.
> 

There are 2. One just returns an error and second one does not change
s_writers.frozen, so unreezing of something like this would fail.

However, the case which got modified results in unfreezable fs, so not
printing the message for this case would result in unmatched entries in
the log.

> Trivially, when there is a comment in a single line
> like this, then braces are often used too.
>  

Thanks, I'll send a modified patch later. Waiting for some other comments.

-- 
Mateusz Guzik
