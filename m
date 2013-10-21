Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376Ab3JUUdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 16:33:22 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:41949 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab3JUUdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 16:33:21 -0400
MIME-Version: 1.0
In-Reply-To: <1382384878-12788-1-git-send-email-geyslan@gmail.com>
References: <1382384878-12788-1-git-send-email-geyslan@gmail.com>
Date: Mon, 21 Oct 2013 18:33:20 -0200
Message-ID: <CAGG-pUQn=RR4U5Qeg1C17hXt56M-yKQtu=ssOj=PQqeoSi+3Vw@mail.gmail.com>
Subject: Re: [PATCH] 9p: fix return value in case in v9fs_fid_xattr_set()
From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
To: kernel-br <kernel-br@googlegroups.com>
Cc: "Geyslan G. Bem" <geyslan@gmail.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>,
        "open list:9P FILE SYSTEM" <v9fs-developer@lists.sourceforge.net>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/21 Geyslan G. Bem <geyslan@gmail.com>:
> In case of error in the p9_client_write, the function v9fs_fid_xattr_set
> should return its negative value, what was never being done.
>
> In case of success it only retuned 0. Now it returns the 'offset'
> variable (write_count total).
>
> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
> ---
>  fs/9p/xattr.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/fs/9p/xattr.c b/fs/9p/xattr.c
> index 3c28cdf..04133a1 100644
> --- a/fs/9p/xattr.c
> +++ b/fs/9p/xattr.c
> @@ -138,8 +138,7 @@ int v9fs_fid_xattr_set(struct p9_fid *fid, const char *name,
>         if (retval < 0) {
>                 p9_debug(P9_DEBUG_VFS, "p9_client_xattrcreate failed %d\n",
>                          retval);
> -               p9_client_clunk(fid);
> -               return retval;
> +               goto err;
>         }
>         msize = fid->clnt->msize;
>         while (value_len) {
> @@ -152,12 +151,15 @@ int v9fs_fid_xattr_set(struct p9_fid *fid, const char *name,
>                 if (write_count < 0) {
>                         /* error in xattr write */
>                         retval = write_count;
> -                       break;
> +                       goto err;
>                 }
>                 offset += write_count;
>                 value_len -= write_count;
>         }
> -       return p9_client_clunk(fid);
> +       retval = offset;
> +err:
> +       p9_client_clunk(fid);
> +       return retval;
>  }
>
>  ssize_t v9fs_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size)
> --
> 1.8.4
>

Eric,

As you can see, I modified the success return value to the offset
(write_count sum), following the same principle of
v9fs_fid_xattr_get():
http://lxr.free-electrons.com/source/fs/9p/xattr.c#L65

What do you think?

Regards.
