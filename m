Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab3FXRDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 13:03:20 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:44588 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab3FXRDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 13:03:18 -0400
MIME-Version: 1.0
In-Reply-To: <20130624074453.24481.96622.stgit@aruna-ThinkPad-T420>
References: <20130624074453.24481.96622.stgit@aruna-ThinkPad-T420>
Date: Mon, 24 Jun 2013 10:03:18 -0700
X-Google-Sender-Auth: YxuUnaA-g-1qqv74obZSDw3nQSE
Message-ID: <CAGXu5jJpQJCc5OU6M-CvyvLAMyOOb=pxDMh586deYADxff23hQ@mail.gmail.com>
Subject: Re: [PATCH] pstore: Fail to unlink if a driver has not defined pstore_erase
From: Kees Cook <keescook@chromium.org>
To: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>, jkenisto@linux.vnet.ibm.com,
        benh@kernel.crashing.org, ananth@in.ibm.com, mahesh@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 12:48 AM, Aruna Balakrishnaiah
<aruna@linux.vnet.ibm.com> wrote:
> pstore_erase is used to erase the record from the persistent store.
> So if a driver has not defined pstore_erase callback return
> -EINVAL instead of unlinking a file as deleting the file without
> erasing its record in persistent store will give a wrong impression
> to customers.

This is probably true -- I originally liked the idea of being able to
clean up the entries, regardless of their storage state, but you're
probably right. They shouldn't be deleted unless they can _actually_
be deleted.

So, I support this change, but I think the return needs to be
different. EINVAL isn't listed, for example, in unlink(2)'s man-page.
Perhaps EROFS, EACCESS, or EPERM?

-Kees

>
> Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
> ---
>  fs/pstore/inode.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
> index e4bcb2c..fa6339a 100644
> --- a/fs/pstore/inode.c
> +++ b/fs/pstore/inode.c
> @@ -178,6 +178,8 @@ static int pstore_unlink(struct inode *dir, struct dentry *dentry)
>         if (p->psi->erase)
>                 p->psi->erase(p->type, p->id, p->count,
>                               dentry->d_inode->i_ctime, p->psi);
> +       else
> +               return -EINVAL;
>
>         return simple_unlink(dir, dentry);
>  }
>



--
Kees Cook
Chrome OS Security
