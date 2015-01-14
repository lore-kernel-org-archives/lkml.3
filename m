Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbbANVDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:03:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385AbbANVDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:03:30 -0500
Date: Wed, 14 Jan 2015 16:03:24 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Paul Moore <pmoore@redhat.com>
Cc: linux-audit@redhat.com, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/5] fs: create proper filename objects using
 getname_kernel()
Message-ID: <20150114210324.GN29998@madcap2.tricolour.ca>
References: <20150108164514.11316.85331.stgit@localhost>
 <20150108165036.11316.14958.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150108165036.11316.14958.stgit@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/01/08, Paul Moore wrote:
> There are several areas in the kernel that create temporary filename
> objects using the following pattern:
> 
> 	int func(const char *name)
> 	{
> 		struct filename *file = { .name = name };
> 		...
> 		return 0;
> 	}
> 
> ... which for the most part works okay, but it causes havoc within the
> audit subsystem as the filename object does not persist beyond the
> lifetime of the function.  This patch converts all of these temporary
> filename objects into proper filename objects using getname_kernel()
> and putname() which ensure that the filename object persists until the
> audit subsystem is finished with it.
> 
> Signed-off-by: Paul Moore <pmoore@redhat.com>

Reviewed-by: Richard Guy Briggs <rgb@redhat.com>

> ---
>  fs/exec.c  |   11 +++++++++--
>  fs/namei.c |   34 ++++++++++++++++++++++++++--------
>  fs/open.c  |   11 +++++++++--
>  3 files changed, 44 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index a3d33fe..d067771 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -789,8 +789,15 @@ exit:
>  
>  struct file *open_exec(const char *name)
>  {
> -	struct filename tmp = { .name = name };
> -	return do_open_exec(&tmp);
> +	struct file *file;
> +	struct filename *tmp;
> +
> +	tmp = getname_kernel(name);
> +	if (unlikely(IS_ERR(tmp)))
> +		return (void *)tmp;
> +	file = do_open_exec(tmp);
> +	putname(tmp);
> +	return file;
>  }
>  EXPORT_SYMBOL(open_exec);
>  
> diff --git a/fs/namei.c b/fs/namei.c
> index eeb3b83..c3d21b7 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -2001,9 +2001,15 @@ static int filename_lookup(int dfd, struct filename *name,
>  static int do_path_lookup(int dfd, const char *name,
>  				unsigned int flags, struct nameidata *nd)
>  {
> -	struct filename filename = { .name = name };
> +	int retval;
> +	struct filename *filename;
>  
> -	return filename_lookup(dfd, &filename, flags, nd);
> +	filename = getname_kernel(name);
> +	if (unlikely(IS_ERR(filename)))
> +		return PTR_ERR(filename);
> +	retval = filename_lookup(dfd, filename, flags, nd);
> +	putname(filename);
> +	return retval;
>  }
>  
>  /* does lookup, returns the object with parent locked */
> @@ -2368,8 +2374,15 @@ int
>  kern_path_mountpoint(int dfd, const char *name, struct path *path,
>  			unsigned int flags)
>  {
> -	struct filename s = {.name = name};
> -	return filename_mountpoint(dfd, &s, path, flags);
> +	int retval;
> +	struct filename *s;
> +
> +	s = getname_kernel(name);
> +	if (unlikely(IS_ERR(s)))
> +		return PTR_ERR(s);
> +	retval = filename_mountpoint(dfd, s, path, flags);
> +	putname(s);
> +	return retval;
>  }
>  EXPORT_SYMBOL(kern_path_mountpoint);
>  
> @@ -3259,7 +3272,7 @@ struct file *do_file_open_root(struct dentry *dentry, struct vfsmount *mnt,
>  {
>  	struct nameidata nd;
>  	struct file *file;
> -	struct filename filename = { .name = name };
> +	struct filename *filename;
>  	int flags = op->lookup_flags | LOOKUP_ROOT;
>  
>  	nd.root.mnt = mnt;
> @@ -3268,11 +3281,16 @@ struct file *do_file_open_root(struct dentry *dentry, struct vfsmount *mnt,
>  	if (d_is_symlink(dentry) && op->intent & LOOKUP_OPEN)
>  		return ERR_PTR(-ELOOP);
>  
> -	file = path_openat(-1, &filename, &nd, op, flags | LOOKUP_RCU);
> +	filename = getname_kernel(name);
> +	if (unlikely(IS_ERR(filename)))
> +		return (void *)filename;
> +
> +	file = path_openat(-1, filename, &nd, op, flags | LOOKUP_RCU);
>  	if (unlikely(file == ERR_PTR(-ECHILD)))
> -		file = path_openat(-1, &filename, &nd, op, flags);
> +		file = path_openat(-1, filename, &nd, op, flags);
>  	if (unlikely(file == ERR_PTR(-ESTALE)))
> -		file = path_openat(-1, &filename, &nd, op, flags | LOOKUP_REVAL);
> +		file = path_openat(-1, filename, &nd, op, flags | LOOKUP_REVAL);
> +	putname(filename);
>  	return file;
>  }
>  
> diff --git a/fs/open.c b/fs/open.c
> index d6fd3ac..666982b 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -940,8 +940,15 @@ struct file *file_open_name(struct filename *name, int flags, umode_t mode)
>   */
>  struct file *filp_open(const char *filename, int flags, umode_t mode)
>  {
> -	struct filename name = {.name = filename};
> -	return file_open_name(&name, flags, mode);
> +	struct file *file;
> +	struct filename *name;
> +
> +	name = getname_kernel(filename);
> +	if (unlikely(IS_ERR(name)))
> +		return (void *)name;
> +	file = file_open_name(name, flags, mode);
> +	putname(name);
> +	return file;
>  }
>  EXPORT_SYMBOL(filp_open);
>  
> 
> --
> Linux-audit mailing list
> Linux-audit@redhat.com
> https://www.redhat.com/mailman/listinfo/linux-audit

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
