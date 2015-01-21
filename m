Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbbAUVyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 16:54:54 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:47361 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbbAUVyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 16:54:39 -0500
Date: Wed, 21 Jan 2015 21:54:37 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Guenter Roeck <linux@roeck-us.net>, Sabrina Dubroca <sd@queasysnail.net>,
        Paul Moore <pmoore@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-audit@redhat.com, Richard Guy Briggs <rgb@redhat.com>
Subject: Re: linux-next: Tree for Jan 20 -- Kernel panic - Unable to mount
 root fs
In-Reply-To: <20150121212833.GS29656@ZenIV.linux.org.uk>
Message-ID: <alpine.DEB.2.02.1501212153480.5450@utopia.booyaka.com>
References: <54BF1292.2080902@roeck-us.net> <20150121033600.GN29656@ZenIV.linux.org.uk> <54BF2496.4000807@roeck-us.net> <20150121043637.GO29656@ZenIV.linux.org.uk> <20150121110539.GA8924@kria> <54BFAA5D.4040108@roeck-us.net> <20150121182905.GQ29656@ZenIV.linux.org.uk>
 <54BFF8B3.6060802@roeck-us.net> <20150121200626.GR29656@ZenIV.linux.org.uk> <54C01418.5060204@roeck-us.net> <20150121212833.GS29656@ZenIV.linux.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2015, Al Viro wrote:

> Folks, could you check if the following on top of linux-next fixes the problem?

Tested-by: Paul Walmsley <paul@pwsan.com> # Tegra124 Jetson TK1

> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 323957f..cda89c3 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -2056,13 +2056,22 @@ static int do_path_lookup(int dfd, const char *name,
>  /* does lookup, returns the object with parent locked */
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
> @@ -2070,9 +2079,11 @@ struct dentry *kern_path_locked(const char *name, struct path *path)
>  	if (IS_ERR(d)) {
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
> @@ -3314,7 +3325,7 @@ struct file *do_file_open_root(struct dentry *dentry, struct vfsmount *mnt,
>  	return file;
>  }
>  
> -struct dentry *kern_path_create(int dfd, const char *pathname,
> +static struct dentry *filename_create(int dfd, struct filename *name,
>  				struct path *path, unsigned int lookup_flags)
>  {
>  	struct dentry *dentry = ERR_PTR(-EEXIST);
> @@ -3329,7 +3340,7 @@ struct dentry *kern_path_create(int dfd, const char *pathname,
>  	 */
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
> @@ -3401,7 +3425,7 @@ struct dentry *user_path_create(int dfd, const char __user *pathname,
>  	struct dentry *res;
>  	if (IS_ERR(tmp))
>  		return ERR_CAST(tmp);
> -	res = kern_path_create(dfd, tmp->name, path, lookup_flags);
> +	res = filename_create(dfd, tmp, path, lookup_flags);
>  	putname(tmp);
>  	return res;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


- Paul
