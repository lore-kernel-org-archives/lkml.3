Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab3GQLUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 07:20:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927Ab3GQLUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 07:20:24 -0400
Date: Wed, 17 Jul 2013 13:20:09 +0200
From: Niels de Vos <ndevos@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Brian Foster <bfoster@redhat.com>, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [fuse-devel] [PATCH] fuse: fix occasional dentry leak when
 readdirplus is used
Message-ID: <20130717112009.GU18803@ndevos-laptop.usersys.redhat.com>
References: <1373893160-30601-1-git-send-email-ndevos@redhat.com>
 <51E456B6.8050601@redhat.com>
 <20130716103939.GL18803@ndevos-laptop.usersys.redhat.com>
 <51E54764.4070106@redhat.com>
 <20130716161458.GA19664@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130716161458.GA19664@tucsk.piliscsaba.szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 06:14:58PM +0200, Miklos Szeredi wrote:
> On Tue, Jul 16, 2013 at 09:15:16AM -0400, Brian Foster wrote:
>  
> > I'm not sure why it would need to have a valid inode. A dentry with a
> > NULL inode is valid, no?
> 
> It is valid, yes.  It's called a "negative" dentry, which caches the information
> that the file does not exist.
> 
> > I think the question is whether the above state (multiple, hashed dentries)
> > can be valid for whatever reason. It certainly looks suspicious.
> 
> That state is not valid.  So we certainly need to unhash the negative dentry
> first, before hashing a new one.  We could also reuse the old dentry, but that
> is just an optimization.
> 
> Below patch fixes several issues with that function.  Could you please give it a
> go?

Thanks Miklos! This looks much cleaner and the additional error checking 
surely reduces the chance of any further problems. I've added only one 
little comment in the patch below.

I can confirm that your patch fixes the original panic/BUG() with both 
Brian's test-case and the GlusterFS regression tests.

Feel free to add my Tested-by/Reviewed-by signoff for this patch.

Cheers,
Niels


> 
> Thanks,
> Miklos
> 
> 
> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index 0eda527..a8208c5 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -1223,28 +1223,45 @@ static int fuse_direntplus_link(struct file *file,
>  		if (name.name[1] == '.' && name.len == 2)
>  			return 0;
>  	}
> +
> +	if (invalid_nodeid(o->nodeid))
> +		return -EIO;
> +	if (!fuse_valid_type(o->attr.mode))
> +		return -EIO;
> +
>  	fc = get_fuse_conn(dir);
>  
>  	name.hash = full_name_hash(name.name, name.len);
>  	dentry = d_lookup(parent, &name);
> -	if (dentry && dentry->d_inode) {
> +	if (dentry) {
>  		inode = dentry->d_inode;
> -		if (get_node_id(inode) == o->nodeid) {
> +		if (!inode) {
> +			d_drop(dentry);
> +		} else if (get_node_id(inode) != o->nodeid ||
> +			   ((o->attr.mode ^ inode->i_mode) & S_IFMT)) {
> +			err = d_invalidate(dentry);
> +			if (err)
> +				goto out;
> +		} else if (is_bad_inode(inode)) {
> +			err = -EIO;
> +			goto out;
> +		} else {
>  			struct fuse_inode *fi;
>  			fi = get_fuse_inode(inode);
>  			spin_lock(&fc->lock);
>  			fi->nlookup++;
>  			spin_unlock(&fc->lock);
>  
> +			fuse_change_attributes(inode, &o->attr,
> +					       entry_attr_timeout(o),
> +					       attr_version);
> +
>  			/*
>  			 * The other branch to 'found' comes via fuse_iget()
>  			 * which bumps nlookup inside
>  			 */
>  			goto found;
>  		}
> -		err = d_invalidate(dentry);
> -		if (err)
> -			goto out;
>  		dput(dentry);
>  		dentry = NULL;

You might want to remove that 'dentry = NULL' line, as the result of 
d_alloc() is assigned to dentry on line below the if-statement.

>  	}
> @@ -1259,25 +1276,30 @@ static int fuse_direntplus_link(struct file *file,
>  	if (!inode)
>  		goto out;
>  
> -	alias = d_materialise_unique(dentry, inode);
> -	err = PTR_ERR(alias);
> -	if (IS_ERR(alias))
> -		goto out;
> +	if (S_ISDIR(inode->i_mode)) {
> +		mutex_lock(&fc->inst_mutex);
> +		alias = fuse_d_add_directory(dentry, inode);
> +		mutex_unlock(&fc->inst_mutex);
> +		err = PTR_ERR(alias);
> +		if (IS_ERR(alias)) {
> +			iput(inode);
> +			goto out;
> +		}
> +	} else {
> +		alias = d_splice_alias(inode, dentry);
> +	}
> +
>  	if (alias) {
>  		dput(dentry);
>  		dentry = alias;
>  	}
>  
>  found:
> -	fuse_change_attributes(inode, &o->attr, entry_attr_timeout(o),
> -			       attr_version);
> -
>  	fuse_change_entry_timeout(dentry, o);
>  
>  	err = 0;
>  out:
> -	if (dentry)
> -		dput(dentry);
> +	dput(dentry);
>  	return err;
>  }
>  
