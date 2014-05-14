Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbaENL6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 07:58:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbaENL6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 07:58:43 -0400
Date: Wed, 14 May 2014 13:58:34 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
X-X-Sender: lczerner@localhost.localdomain
To: Jan Kara <jack@suse.cz>
cc: Mateusz Guzik <mguzik@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Eric Sandeen <esandeen@redhat.com>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH V2 2/2] fs: print a message when freezing/unfreezing
 filesystems
In-Reply-To: <20140514111449.GB5824@quack.suse.cz>
Message-ID: <alpine.LFD.2.00.1405141355570.9727@localhost.localdomain>
References: <1400018683-5565-1-git-send-email-mguzik@redhat.com> <1400018683-5565-2-git-send-email-mguzik@redhat.com> <20140514111449.GB5824@quack.suse.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2014, Jan Kara wrote:

> Date: Wed, 14 May 2014 13:14:49 +0200
> From: Jan Kara <jack@suse.cz>
> To: Mateusz Guzik <mguzik@redhat.com>
> Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
>     Josef Bacik <jbacik@fb.com>, Jan Kara <jack@suse.cz>,
>     Al Viro <viro@ZenIV.linux.org.uk>, Eric Sandeen <esandeen@redhat.com>,
>     Joe Perches <joe@perches.com>
> Subject: Re: [PATCH V2 2/2] fs: print a message when freezing/unfreezing
>     filesystems
> 
> On Wed 14-05-14 00:04:43, Mateusz Guzik wrote:
> > This helps hang troubleshooting efforts when only dmesg is available.
> > 
> > While here remove code duplication with MS_RDONLY case and fix a
> > whitespace nit.
>   I'm somewhat undecided here I have to say. On one hand I don't like
> printing to kernel log when everything is fine and kernel is operating
> normally. On the other hand I've seen quite a few cases where people have
> shot themselves in the foot with filesystem freezing so having some trace
> of this in the log doesn't seem like a completely bad thing either. What do
> other people think?

I think that this message is definitely useful to have. As Mateusz
already mentioned I think that this is of the same importance as the
"file system mounted/remounted" message.

-Lukas

> 
> 								Honza
> > Signed-off-by: Mateusz Guzik <mguzik@redhat.com>
> > Cc: linux-fsdevel@vger.kernel.org
> > Cc: Josef Bacik <jbacik@fb.com>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: Al Viro <viro@ZenIV.linux.org.uk>
> > Cc: Eric Sandeen <esandeen@redhat.com>
> > Cc: Joe Perches <joe@perches.com>
> > ---
> > since v1:
> > 	fix copy-pasto which found its way into the patch
> > 	restore curly brackets in MS_RDONLY case
> >  fs/super.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/super.c b/fs/super.c
> > index 017e10a..4dd7356 100644
> > --- a/fs/super.c
> > +++ b/fs/super.c
> > @@ -1291,9 +1291,7 @@ int freeze_super(struct super_block *sb)
> >  
> >  	if (sb->s_flags & MS_RDONLY) {
> >  		/* Nothing to do really... */
> > -		sb->s_writers.frozen = SB_FREEZE_COMPLETE;
> > -		up_write(&sb->s_umount);
> > -		return 0;
> > +		goto out;
> >  	}
> >  
> >  	/* From now on, no new normal writers can start */
> > @@ -1335,8 +1333,10 @@ int freeze_super(struct super_block *sb)
> >  	 * This is just for debugging purposes so that fs can warn if it
> >  	 * sees write activity when frozen is set to SB_FREEZE_COMPLETE.
> >  	 */
> > +out:
> >  	sb->s_writers.frozen = SB_FREEZE_COMPLETE;
> >  	up_write(&sb->s_umount);
> > +	pr_info("VFS:Filesystem %s frozen\n", sb->s_id);
> >  	return 0;
> >  }
> >  EXPORT_SYMBOL(freeze_super);
> > @@ -1374,7 +1374,7 @@ out:
> >  	smp_wmb();
> >  	wake_up(&sb->s_writers.wait_unfrozen);
> >  	deactivate_locked_super(sb);
> > -
> > +	pr_info("VFS:Filesystem %s thawed\n", sb->s_id);
> >  	return 0;
> >  }
> >  EXPORT_SYMBOL(thaw_super);
> > -- 
> > 1.8.3.1
> > 
> 
