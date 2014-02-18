Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbaBRXQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:16:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51492 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbaBRXQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 18:16:51 -0500
Date: Tue, 18 Feb 2014 15:16:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] fs: xattr: Don't display attributes without read
 access
Message-Id: <20140218151650.02fb2d6034deb2d3d11ccc7a@linux-foundation.org>
In-Reply-To: <20140216203101.bf432a8b7b40703197a91462@skynet.be>
References: <20140216203101.bf432a8b7b40703197a91462@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Feb 2014 20:31:01 +0800 Fabian Frederick <fabf@skynet.be> wrote:

> Any user can display extented attribute names without read
> access.
> 
> eg: attr -l <filename>
> 
> This patch checks inode_permission in listxattr common
> function before executing vfs_listxattr.
> 
> ...
>
> --- a/fs/xattr.c
> +++ b/fs/xattr.c
> @@ -543,6 +543,10 @@ listxattr(struct dentry *d, char __user *list, size_t size)
>  	char *klist = NULL;
>  	char *vlist = NULL;	/* If non-NULL, we used vmalloc() */
>  
> +	error = inode_permission(d->d_inode, MAY_READ);
> +	if (error)
> +		return error;
> +
>  	if (size) {
>  		if (size > XATTR_LIST_MAX)
>  			size = XATTR_LIST_MAX;

erk.  Doesn't this mean that if existing userspace is relying on the
current behaviour, this patch will cause breakage?

