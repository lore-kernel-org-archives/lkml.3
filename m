Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab3GKG3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 02:29:35 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:33020 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588Ab3GKG3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 02:29:33 -0400
Date: Thu, 11 Jul 2013 08:29:33 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Airlie <airlied@redhat.com>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH 1/2] anon_inodes: allow external inode allocations
Message-ID: <20130711062933.GN6143@phenom.ffwll.local>
Mail-Followup-To: David Herrmann <dh.herrmann@gmail.com>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Dave Airlie <airlied@redhat.com>, linux-fsdevel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <1373499930-5055-1-git-send-email-dh.herrmann@gmail.com>
 <1373499930-5055-2-git-send-email-dh.herrmann@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373499930-5055-2-git-send-email-dh.herrmann@gmail.com>
X-Operating-System: Linux phenom 3.10.0-rc7+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 01:45:29AM +0200, David Herrmann wrote:
> DRM core shares a single address_space across all inodes that belong to
> the same DRM device. This allows efficient unmapping of user-space
> mappings during buffer destruction. However, there is no easy way to get a
> shared address_space for DRM devices during initialization. Therefore, we
> currently delay this step until the first ->open() and save the given
> inode for future use.

Quick correction for the drm use-case: We don't need the address space at
buffer destruction, since each vma holds a reference to the backing gem
object. So buffer destruction can only happen once there's guaranteed to
be no mmapping around any more.

But we make extensive use of the address_space to shoot down ptes with
unmap_mapping_range before we evict a buffer from the mmio gart. In the
page fault handler we can then move the buffer object back to a place
userspace can get at it and set up new ptes.

> This causes ugly delayed initialization throughout the DRM core. TTM
> devices end up without a dev_mapping pointer and we have to carefully
> respect any underlying filesystem implementation so we don't corrupt the
> inode->i_mapping and inode->i_data fields.
> 
> We can avoid this if we were allowed to allocate an anonymous inode for
> each DRM device. We only have to set file->f_mapping during ->open()
> and no longer need to adjust inode mappings. As fs/anon_inodes.c already
> provides a minimal internal FS mount, we extend it to also provide
> anonymous inodes for use in drivers like DRM.
> 
> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>

I'm not an fs guy so no comment on the patch itself, but having an
inode/address space available at driver load time will allow us to get rid
of tons of ulgy

	if (dev_mapping)
		unmap_mapping_rang(dev_mapping, ...);

code sprinkled all over drm core and drivers. So

Wanted-by: Daniel Vetter <daniel.vetter@ffwll.ch>

> ---
>  fs/anon_inodes.c            | 36 +++++++++++++++++++++++++++++-------
>  include/linux/anon_inodes.h |  1 +
>  2 files changed, 30 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
> index 47a65df..7d8a80a 100644
> --- a/fs/anon_inodes.c
> +++ b/fs/anon_inodes.c
> @@ -25,6 +25,7 @@
>  static struct vfsmount *anon_inode_mnt __read_mostly;
>  static struct inode *anon_inode_inode;
>  static const struct file_operations anon_inode_fops;
> +static struct dentry *anon_inode_root;
>  
>  /*
>   * anon_inodefs_dname() is called from d_path().
> @@ -87,19 +88,18 @@ static struct inode *anon_inode_mkinode(struct super_block *s)
>  static struct dentry *anon_inodefs_mount(struct file_system_type *fs_type,
>  				int flags, const char *dev_name, void *data)
>  {
> -	struct dentry *root;
> -	root = mount_pseudo(fs_type, "anon_inode:", NULL,
> +	anon_inode_root = mount_pseudo(fs_type, "anon_inode:", NULL,
>  			&anon_inodefs_dentry_operations, ANON_INODE_FS_MAGIC);
> -	if (!IS_ERR(root)) {
> -		struct super_block *s = root->d_sb;
> +	if (!IS_ERR(anon_inode_root)) {
> +		struct super_block *s = anon_inode_root->d_sb;
>  		anon_inode_inode = anon_inode_mkinode(s);
>  		if (IS_ERR(anon_inode_inode)) {
> -			dput(root);
> +			dput(anon_inode_root);
>  			deactivate_locked_super(s);
> -			root = ERR_CAST(anon_inode_inode);
> +			anon_inode_root = ERR_CAST(anon_inode_inode);
>  		}
>  	}
> -	return root;
> +	return anon_inode_root;
>  }
>  
>  static struct file_system_type anon_inode_fs_type = {
> @@ -219,6 +219,28 @@ err_put_unused_fd:
>  }
>  EXPORT_SYMBOL_GPL(anon_inode_getfd);
>  
> +/**
> + * anon_inode_new - create private anonymous inode
> + *
> + * Creates a new inode on the anonymous inode FS for driver's use. The inode has
> + * it's own address_space compared to the shared anon_inode_inode. It can be
> + * used in situations where user-space mappings have to be shared across
> + * different files but no backing inode is available.
> + *
> + * Call iput(inode) to release the inode.
> + *
> + * RETURNS:
> + * New inode on success, error pointer on failure.
> + */
> +struct inode *anon_inode_new(void)
> +{
> +	if (IS_ERR(anon_inode_root))
> +		return ERR_CAST(anon_inode_root);
> +
> +	return anon_inode_mkinode(anon_inode_root->d_sb);
> +}
> +EXPORT_SYMBOL_GPL(anon_inode_new);
> +
>  static int __init anon_inode_init(void)
>  {
>  	int error;
> diff --git a/include/linux/anon_inodes.h b/include/linux/anon_inodes.h
> index 8013a45..ddbd67f 100644
> --- a/include/linux/anon_inodes.h
> +++ b/include/linux/anon_inodes.h
> @@ -15,6 +15,7 @@ struct file *anon_inode_getfile(const char *name,
>  				void *priv, int flags);
>  int anon_inode_getfd(const char *name, const struct file_operations *fops,
>  		     void *priv, int flags);
> +struct inode *anon_inode_new(void);
>  
>  #endif /* _LINUX_ANON_INODES_H */
>  
> -- 
> 1.8.3.2
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
