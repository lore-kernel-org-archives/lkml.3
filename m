Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbaJFQbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 12:31:49 -0400
Received: from mail-oi0-f47.google.com ([209.85.218.47]:64926 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbaJFQbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 12:31:47 -0400
Date: Mon, 6 Oct 2014 11:31:36 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH v2 0/3] fuse: Add support for mounts from pid/user
 namespaces
Message-ID: <20141006163136.GF131459@ubuntu-hedt>
Mail-Followup-To: Serge Hallyn <serge.hallyn@ubuntu.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	fuse-devel <fuse-devel@lists.sourceforge.net>,
	Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
	"Serge E. Hallyn" <serge@hallyn.com>
References: <87wq8reftb.fsf@x220.int.ebiederm.org>
 <20140925184403.GB28101@ubuntu-hedt>
 <87bnq3a4xy.fsf@x220.int.ebiederm.org>
 <20140925194825.GB39447@ubuntu-hedt>
 <874mvtkfg2.fsf@x220.int.ebiederm.org>
 <20140927042447.GA19672@ubuntu-hedt>
 <87tx3qdxuz.fsf@x220.int.ebiederm.org>
 <20140930162559.GA1057@ubuntu-hedt>
 <20141005164821.GA5691@ubuntu-mba51>
 <20141006160006.GE26187@ubuntumail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141006160006.GE26187@ubuntumail>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 04:00:06PM +0000, Serge Hallyn wrote:
> Quoting Seth Forshee (seth.forshee@canonical.com):
> ...
> > After digging into this some more I think I agree with you. At minimum
> > letting users insert arbitrary xattrs via fuse bypasses the usual
> > restrictions on setting xattrs. This is probably mitigated by the
> > limited visibility of the fuse mount in the usual case for unprivileged
> > users, but it does seem like a bad idea fundamentally.
> > 
> > So I was thinking of something like the following (untested) to let root
> > in the host support privileged xattrs while limiting unprivileged users
> > to user.*. Miklos, does this look acceptable or would you prefer
> > something different?
> 
> So it won't be possible to set capabilities in a fuse fs?  This may
> be necessary, but it will prevent i.e. live-iso builders from writing
> for instance a CAP_NET_RAW=pe (instead of setuid-root) /bin/ping in the
> iso.

cap_inode_setxattr() already requires CAP_SETFCAP in the host to do
this, which I'd think root in in an unpriv container wouldn't have, so
aren't you prevented from doing so already? I suppose the LSM could
override this restriction though.

> > diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> > index e3123bfbc711..1a3ee5663dea 100644
> > --- a/fs/fuse/dir.c
> > +++ b/fs/fuse/dir.c
> > @@ -1882,6 +1882,10 @@ static int fuse_setxattr(struct dentry *entry, const char *name,
> >  	if (fc->no_setxattr)
> >  		return -EOPNOTSUPP;
> >  
> > +	if (!(fc->flags & FUSE_PRIV_XATTRS) &&
> > +	    strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN) != 0)
> > +		return -EOPNOTSUPP;
> > +
> >  	req = fuse_get_req_nopages(fc);
> >  	if (IS_ERR(req))
> >  		return PTR_ERR(req);
> > @@ -1925,6 +1929,10 @@ static ssize_t fuse_getxattr(struct dentry *entry, const char *name,
> >  	if (fc->no_getxattr)
> >  		return -EOPNOTSUPP;
> >  
> > +	if (!(fc->flags & FUSE_PRIV_XATTRS) &&
> > +	    strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN) != 0)
> > +		return -EOPNOTSUPP;
> > +
> >  	req = fuse_get_req_nopages(fc);
> >  	if (IS_ERR(req))
> >  		return PTR_ERR(req);
> > diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> > index 81187ba04e4a..bc0fd14b962a 100644
> > --- a/fs/fuse/fuse_i.h
> > +++ b/fs/fuse/fuse_i.h
> > @@ -46,6 +46,11 @@
> >      doing the mount will be allowed to access the filesystem */
> >  #define FUSE_ALLOW_OTHER         (1 << 1)
> >  
> > +/** If the FUSE_PRIV_XATTRS flag is given, then xattrs outside the
> > +    user.* namespace are allowed. This option is only allowed for
> > +    system root. */
> > +#define FUSE_PRIV_XATTRS	(1 << 2)
> > +
> >  /** Number of page pointers embedded in fuse_req */
> >  #define FUSE_REQ_INLINE_PAGES 1
> >  
> > diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> > index b88b5a780228..6716b56d43a1 100644
> > --- a/fs/fuse/inode.c
> > +++ b/fs/fuse/inode.c
> > @@ -493,6 +493,7 @@ enum {
> >  	OPT_ALLOW_OTHER,
> >  	OPT_MAX_READ,
> >  	OPT_BLKSIZE,
> > +	OPT_PRIV_XATTRS,
> >  	OPT_ERR
> >  };
> >  
> > @@ -505,6 +506,7 @@ static const match_table_t tokens = {
> >  	{OPT_ALLOW_OTHER,		"allow_other"},
> >  	{OPT_MAX_READ,			"max_read=%u"},
> >  	{OPT_BLKSIZE,			"blksize=%u"},
> > +	{OPT_PRIV_XATTRS,		"priv_xattr"},
> >  	{OPT_ERR,			NULL}
> >  };
> >  
> > @@ -592,6 +594,12 @@ static int parse_fuse_opt(char *opt, struct fuse_mount_data *d, int is_bdev)
> >  			d->blksize = value;
> >  			break;
> >  
> > +		case OPT_PRIV_XATTRS:
> > +			if (!capable(CAP_SYS_ADMIN))
> > +				return 0;
> > +			d->flags |= FUSE_PRIV_XATTRS;
> > +			break;
> > +
> >  		default:
> >  			return 0;
> >  		}
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
