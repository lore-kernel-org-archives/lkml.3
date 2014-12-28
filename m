Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbaL1VBe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 16:01:34 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:59782
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751776AbaL1VBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 16:01:32 -0500
X-IronPort-AV: E=Sophos;i="5.07,656,1413237600"; 
   d="scan'208";a="94856850"
Date: Sun, 28 Dec 2014 22:01:28 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: SF Markus Elfring <elfring@users.sourceforge.net>
cc: Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>, Ron Minnich <rminnich@sandia.gov>,
        v9fs-developer@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 1/8] fs/9p: Deletion of unnecessary checks before the
 function call "p9_client_clunk"
In-Reply-To: <54A06AB9.4020505@users.sourceforge.net>
Message-ID: <alpine.DEB.2.02.1412282150200.2066@localhost6.localdomain6>
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net>
 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net> <54A01326.3050306@users.sourceforge.net> <54A06AB9.4020505@users.sourceforge.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
> index 9ee5343..a787d4c 100644
> --- a/fs/9p/vfs_inode.c
> +++ b/fs/9p/vfs_inode.c
> @@ -700,11 +700,9 @@ v9fs_create(struct v9fs_session_info *v9ses, struct inode *dir,
>  	}
>  	return ofid;
>  error:
> -	if (ofid)
> -		p9_client_clunk(ofid);
> +	p9_client_clunk(ofid);
>  
> -	if (fid)
> -		p9_client_clunk(fid);
> +	p9_client_clunk(fid);
>  
>  	return ERR_PTR(err);
>  }

This code seems rather sloppy.  ofid could never be NULL at the point 
where it was tested.  There is a useless definition of ofid to NULL at the 
top of the function.  The error handling code could be rearranged with an 
extra error label so that p9_client_clunk is never called on fid when it 
it is not defined.  The the two assignments of fid to NULL could also be 
removed.  There is also a useless initialization of err to 0 at the 
beginning of the function.  And the first two calls to ERR_PTR are not 
needed, as the types of dfid and ofid are the same as the return type of 
the function.

> @@ -768,8 +766,7 @@ static int v9fs_vfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode
>  		v9fs_invalidate_inode_attr(dir);
>  	}
>  
> -	if (fid)
> -		p9_client_clunk(fid);
> +	p9_client_clunk(fid);
>  
>  	return err;
>  }

This function is also unnecessarily complex.  The if above this one, that 
detects the error could just return PTR_ERR(fid);.  The rest of the 
function could call inc_nlink, v9fs_invalidate_inode_attr, and 
p9_client_clunk, and the returnvalue could be 0, removing the need for the 
err variable.

> @@ -916,8 +913,7 @@ out:
>  	return err;
>  
>  error:
> -	if (fid)
> -		p9_client_clunk(fid);
> +	p9_client_clunk(fid);
>  	goto out;
>  }

In the case where fid is set to NULL, it could just goto out directly, 
instead of calling p9_client_clunk, testing fid, coming back, and going to 
out anyway.

julia
  
> diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
> index 6054c16b..3611b0f 100644
> --- a/fs/9p/vfs_inode_dotl.c
> +++ b/fs/9p/vfs_inode_dotl.c
> @@ -363,11 +363,9 @@ out:
>  	return err;
>  
>  error:
> -	if (fid)
> -		p9_client_clunk(fid);
> +	p9_client_clunk(fid);
>  err_clunk_old_fid:
> -	if (ofid)
> -		p9_client_clunk(ofid);
> +	p9_client_clunk(ofid);
>  	goto out;
>  }
>  
> @@ -464,8 +462,7 @@ static int v9fs_vfs_mkdir_dotl(struct inode *dir,
>  	inc_nlink(dir);
>  	v9fs_invalidate_inode_attr(dir);
>  error:
> -	if (fid)
> -		p9_client_clunk(fid);
> +	p9_client_clunk(fid);
>  	v9fs_put_acl(dacl, pacl);
>  	return err;
>  }
> @@ -744,8 +741,7 @@ v9fs_vfs_symlink_dotl(struct inode *dir, struct dentry *dentry,
>  	}
>  
>  error:
> -	if (fid)
> -		p9_client_clunk(fid);
> +	p9_client_clunk(fid);
>  
>  	return err;
>  }
> @@ -896,8 +892,7 @@ v9fs_vfs_mknod_dotl(struct inode *dir, struct dentry *dentry, umode_t omode,
>  		d_instantiate(dentry, inode);
>  	}
>  error:
> -	if (fid)
> -		p9_client_clunk(fid);
> +	p9_client_clunk(fid);
>  	v9fs_put_acl(dacl, pacl);
>  	return err;
>  }
> diff --git a/fs/9p/xattr.c b/fs/9p/xattr.c
> index f95e01e..8e72269 100644
> --- a/fs/9p/xattr.c
> +++ b/fs/9p/xattr.c
> @@ -65,8 +65,7 @@ ssize_t v9fs_fid_xattr_get(struct p9_fid *fid, const char *name,
>  	/* Total read xattr bytes */
>  	retval = offset;
>  error:
> -	if (attr_fid)
> -		p9_client_clunk(attr_fid);
> +	p9_client_clunk(attr_fid);
>  	return retval;
>  
>  }
> -- 
> 2.2.1
> 
> 
