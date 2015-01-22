Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbbAVC3N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 21:29:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706AbbAVC3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 21:29:02 -0500
From: Paul Moore <pmoore@redhat.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Guenter Roeck <linux@roeck-us.net>, Sabrina Dubroca <sd@queasysnail.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-audit@redhat.com, Richard Guy Briggs <rgb@redhat.com>
Subject: Re: linux-next: Tree for Jan 20 -- Kernel panic - Unable to mount root fs
Date: Wed, 21 Jan 2015 21:28:51 -0500
Message-ID: <1829267.G68Yz0UZrY@sifl>
Organization: Red Hat
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20150121212833.GS29656@ZenIV.linux.org.uk>
References: <54BF1292.2080902@roeck-us.net> <54C01418.5060204@roeck-us.net> <20150121212833.GS29656@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 21, 2015 09:28:33 PM Al Viro wrote:
> On Wed, Jan 21, 2015 at 01:03:20PM -0800, Guenter Roeck wrote:
> > failing case:
> > 
> > path_lookupat: calling path_init 'usr' flags=40
> > path_init: link_path_walk() returned 0
> > path_lookupat: path_init 'usr' flags=40[50] returned 0
> > walk_component: lookup_fast() returned 1
> > walk_component: lookup_slow() returned 0
> > walk_component: inode=  (null), negative=1
> > do_path_lookup(usr, 0x10)
> > path_lookupat: calling path_init 'usr' flags=50
> > path_init: link_path_walk() returned 0
> > path_lookupat: path_init 'usr' flags=50[50] returned 0
> > mkdir[c74012a0,/kkk] => 0						<==== SIC!
> 
> Cute. 'k' being 0x6b, aka POISON_FREE...  OK, the next question is what's
> been freed under us - I don't believe that it's dentry itself...
> Oh, fuck.  OK, I see what happens.  Look at kern_path_create(); it does
> LOOKUP_PARENT walk, leaving nd->last pointing to the last component of
> the *COPY* of the name it's just created, walked and freed.
> 
> OK...  Fortunately, struct nameidata is completely opaque outside of
> fs/namei.c, so we only need to care about a couple of codepaths.
> 
> Folks, could you check if the following on top of linux-next fixes the
> problem?

Thanks Al, and Guenter, and Sabrina for helping resolve this; it surely would 
have taken me much longer alone.

Al, do you mind if I fold your patch below into the existing patches?
 
> diff --git a/fs/namei.c b/fs/namei.c
> index 323957f..cda89c3 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -2056,13 +2056,22 @@ static int do_path_lookup(int dfd, const char *name,
> /* does lookup, returns the object with parent locked */
>  struct dentry *kern_path_locked(const char *name, struct path *path)
>  {
> +	struct filename *filename = getname_kernel(name);
>  	struct nameidata nd;
>  	struct dentry *d;
> -	int err = do_path_lookup(AT_FDCWD, name, LOOKUP_PARENT, &nd);
> -	if (err)
> +	int err;
> +
> +	if (IS_ERR(filename))
> +		return ERR_CAST(filename);
> +
> +	err = filename_lookup(AT_FDCWD, filename, LOOKUP_PARENT, &nd);
> +	if (err) {
> +		putname(filename);
>  		return ERR_PTR(err);
> +	}
>  	if (nd.last_type != LAST_NORM) {
>  		path_put(&nd.path);
> +		putname(filename);
>  		return ERR_PTR(-EINVAL);
>  	}
>  	mutex_lock_nested(&nd.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
> @@ -2070,9 +2079,11 @@ struct dentry *kern_path_locked(const char *name,
> struct path *path) if (IS_ERR(d)) {
>  		mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
>  		path_put(&nd.path);
> +		putname(filename);
>  		return d;
>  	}
>  	*path = nd.path;
> +	putname(filename);
>  	return d;
>  }
> 
> @@ -3314,7 +3325,7 @@ struct file *do_file_open_root(struct dentry *dentry,
> struct vfsmount *mnt, return file;
>  }
> 
> -struct dentry *kern_path_create(int dfd, const char *pathname,
> +static struct dentry *filename_create(int dfd, struct filename *name,
>  				struct path *path, unsigned int lookup_flags)
>  {
>  	struct dentry *dentry = ERR_PTR(-EEXIST);
> @@ -3329,7 +3340,7 @@ struct dentry *kern_path_create(int dfd, const char
> *pathname, */
>  	lookup_flags &= LOOKUP_REVAL;
> 
> -	error = do_path_lookup(dfd, pathname, LOOKUP_PARENT|lookup_flags, &nd);
> +	error = filename_lookup(dfd, name, LOOKUP_PARENT|lookup_flags, &nd);
>  	if (error)
>  		return ERR_PTR(error);
> 
> @@ -3383,6 +3394,19 @@ out:
>  	path_put(&nd.path);
>  	return dentry;
>  }
> +
> +struct dentry *kern_path_create(int dfd, const char *pathname,
> +				struct path *path, unsigned int lookup_flags)
> +{
> +	struct filename *filename = getname_kernel(pathname);
> +	struct dentry *res = ERR_CAST(filename);
> +
> +	if (!IS_ERR(filename)) {
> +		res = filename_create(dfd, filename, path, lookup_flags);
> +		putname(filename);
> +	}
> +	return res;
> +}
>  EXPORT_SYMBOL(kern_path_create);
> 
>  void done_path_create(struct path *path, struct dentry *dentry)
> @@ -3401,7 +3425,7 @@ struct dentry *user_path_create(int dfd, const char
> __user *pathname, struct dentry *res;
>  	if (IS_ERR(tmp))
>  		return ERR_CAST(tmp);
> -	res = kern_path_create(dfd, tmp->name, path, lookup_flags);
> +	res = filename_create(dfd, tmp, path, lookup_flags);
>  	putname(tmp);
>  	return res;
>  }

-- 
paul moore
security @ redhat

