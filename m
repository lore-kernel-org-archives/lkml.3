Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbaKGVj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 16:39:28 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:49952 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbaKGVjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 16:39:24 -0500
From: Paul Moore <paul@paul-moore.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] Overlayfs: Use copy-up security hooks
Date: Fri, 07 Nov 2014 16:39:21 -0500
Message-ID: <4109261.WfcAOoSvNG@sifl>
User-Agent: KMail/4.14.2 (Linux/3.16.7-gentoo; KDE/4.14.2; x86_64; ; )
In-Reply-To: <20141105154238.2555.85960.stgit@warthog.procyon.org.uk>
References: <20141105154217.2555.578.stgit@warthog.procyon.org.uk> <20141105154238.2555.85960.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 05, 2014 03:42:38 PM David Howells wrote:
> Use the copy-up security hooks previously provided to allow an LSM to adjust
> the security on a newly created copy and to filter the xattrs copied to
> that file copy.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  fs/overlayfs/copy_up.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index ea10a8719107..53a357d0a214 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -58,6 +58,14 @@ int ovl_copy_xattr(struct dentry *old, struct dentry
> *new) error = size;
>  			goto out_free_value;
>  		}
> +		error = security_inode_copy_up_xattr(old, new,
> +						     name, value, &size);

So the LSM must modify the xattr in place?  I suppose that since the @value is 
allocated to the max size it shouldn't be a problem.  Just checking ...

> +		if (error < 0)
> +			goto out_free_value;
> +		if (error == 1) {
> +			error = 0;
> +			continue; /* Discard */
> +		}
>  		error = vfs_setxattr(new, name, value, size, 0);
>  		if (error)
>  			goto out_free_value;

-- 
paul moore
www.paul-moore.com

