Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbaENWHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 18:07:40 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:34126 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751660AbaENWHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 18:07:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgtIAG3oc1N5LL1sPGdsb2JhbABZgwaDPoUKpCQBAQEBAQEGmh0BgScXAwEBAQE4NYIlAQEFJxMcIxAIAw4KCSUPBSUDBxoTiEDRXxcWhT6IegeDK4EVBJlQll0r
Date: Thu, 15 May 2014 08:07:36 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: Mateusz Guzik <mguzik@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Eric Sandeen <esandeen@redhat.com>
Subject: Re: [PATCH V2 1/2] fs: include device name in error messages about
 freezing
Message-ID: <20140514220736.GE5421@dastard>
References: <1400018683-5565-1-git-send-email-mguzik@redhat.com>
 <20140514111048.GA5824@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140514111048.GA5824@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 01:10:48PM +0200, Jan Kara wrote:
> On Wed 14-05-14 00:04:42, Mateusz Guzik wrote:
> > While here use pr_err instead of printk(KERN_ERR...)
>   The patch looks good. Just one nit below:
> 
> > Signed-off-by: Mateusz Guzik <mguzik@redhat.com>
> > Cc: linux-fsdevel@vger.kernel.org
> > Cc: Josef Bacik <jbacik@fb.com>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: Al Viro <viro@ZenIV.linux.org.uk>
> > Cc: Eric Sandeen <esandeen@redhat.com>
> > ---
> >  fs/super.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/super.c b/fs/super.c
> > index 48377f7..017e10a 100644
> > --- a/fs/super.c
> > +++ b/fs/super.c
> > @@ -1323,8 +1323,7 @@ int freeze_super(struct super_block *sb)
> >  	if (sb->s_op->freeze_fs) {
> >  		ret = sb->s_op->freeze_fs(sb);
> >  		if (ret) {
> > -			printk(KERN_ERR
> > -				"VFS:Filesystem freeze failed\n");
> > +			pr_err("VFS:Filesystem %s freeze failed\n", sb->s_id);
>   I'd somewhat prefer to have the format like:
> VFS (device %s): Filesystem freeze failed\n
>
>   That should easy to programatically parse if necessary and also more
> consistent with how filesystems report errors. Now VFS itself doesn't have
> any unified style but still...

I'd suggest that filesystems should be outputting a failure message
if something goes wrong during a freeze. As you mention, they
already have their own device tailored log messages, but they also
have a much better idea of what the failure actually is. And some
filesystems will have already outputted an error if something went
wrong during the freeze....

Further, the freeze failure errno is is sent back to the caller
(i.e. userspace), so the user should already be getting a message
saying the freeze failed (just like for remount,ro). So why do we
need dmesg output for something that already has a working error
reporting path?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
