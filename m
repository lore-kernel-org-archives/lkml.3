Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab3LZVm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 16:42:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38709 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab3LZVmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 16:42:54 -0500
Date: Thu, 26 Dec 2013 13:42:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ian Kent <raven@themaw.net>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] autofs - fix fix symlinks arent checked for expiry
Message-Id: <20131226134253.5f4b2f02a00e11b8de49770e@linux-foundation.org>
In-Reply-To: <20131224094459.20051.4889.stgit@perseus.fritz.box>
References: <20131224094459.20051.4889.stgit@perseus.fritz.box>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Dec 2013 17:44:59 +0800 Ian Kent <raven@themaw.net> wrote:

> When following a symlink the last_used counter is unconditionally
> updated causing the expire checks from user space to prevent
> expiry. Opps!

A bit unclear.  You're saying that userspace's act of checking expiry
status will itself disrupt the expiry process?

Also, it's rather unclear what the userspace impact is here, and how
severe it is.  Please always carefully describe the user-visible impact
so that others can decide which kernel version(s) need the patch.

> --- a/fs/autofs4/symlink.c
> +++ b/fs/autofs4/symlink.c
> @@ -14,8 +14,9 @@
>  
>  static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
>  {
> +	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
>  	struct autofs_info *ino = autofs4_dentry_ino(dentry);
> -	if (ino)
> +	if (ino && !autofs4_oz_mode(sbi))
>  		ino->last_used = jiffies;
>  	nd_set_link(nd, dentry->d_inode->i_private);
>  	return NULL;

What kernel is this against?  3.13-rc5 is quite different:

static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
{
	nd_set_link(nd, dentry->d_inode->i_private);
	return NULL;
}

