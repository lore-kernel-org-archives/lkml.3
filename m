Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab3BNHsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 02:48:36 -0500
Received: from mail-ve0-f181.google.com ([209.85.128.181]:60517 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab3BNHsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 02:48:33 -0500
MIME-Version: 1.0
In-Reply-To: <959cfd74266e82f72e5879c6c8b798d76f6cad31.1360746454.git.dmitry.kasatkin@intel.com>
References: <959cfd74266e82f72e5879c6c8b798d76f6cad31.1360746454.git.dmitry.kasatkin@intel.com>
Date: Thu, 14 Feb 2013 09:48:32 +0200
Message-ID: <CALLzPKZEnrYoz8mVCsdnQPbdM2Ni2bT+XXz7-ogtBP6quTFv5Q@mail.gmail.com>
Subject: Re: [RFC 1/1] xattr: provide integrity. namespace to read real values
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: linux-security-module@vger.kernel.org, James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, casey@schaufler-ca.com,
        zohar@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Any comments about this patch and functionality?

Thanks,
Dmitry

On Wed, Feb 13, 2013 at 11:07 AM, Dmitry Kasatkin
<dmitry.kasatkin@intel.com> wrote:
> User space tools use getxattr() system call to read values of extended
> attributes. getxattr() system call uses vfs_getattr(), which for "security."
> namespace might get a value of the xattr indirectly from LSM via calling
> xattr_getsecurity(). For that reason value set by setxattr and read by getxattr
> might differ.
>
> Here is an example of SMACK label, which shows that set and read values are
> different:
>
>   setfattr -n security.SMACK64 -v "hello world" foo
>   getfattr -n security.SMACK64 foo
>   # file: foo
>   security.SMACK64="hello"
>
> EVM uses vfs_getxattr_alloc(), which directly reads xattr values from the file
> system. When performing the file system labeling with digital signatures, it is
> necessary to read real xattr values in order to generate the correct signatures.
>
> This patch adds the virtual "integrity." name space, which allows to bypass
> calling LSM and read real extended attribute values.
>
>   getfattr -e text -n integrity.SMACK64 foo
>   # file: foo
>   integrity.SMACK64="hello world"
>
> Suggested-by: Casey Schaufler <casey@schaufler-ca.com>
> Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
> ---
>  fs/xattr.c                 |   22 +++++++++++++++++++---
>  include/uapi/linux/xattr.h |    4 ++++
>  2 files changed, 23 insertions(+), 3 deletions(-)
>
> diff --git a/fs/xattr.c b/fs/xattr.c
> index 3377dff..76c2620 100644
> --- a/fs/xattr.c
> +++ b/fs/xattr.c
> @@ -232,12 +232,28 @@ vfs_getxattr(struct dentry *dentry, const char *name, void *value, size_t size)
>  {
>         struct inode *inode = dentry->d_inode;
>         int error;
> +       char *usename = (char *)name, name_buf[XATTR_NAME_MAX];
> +
> +       /* because this function calls LSM for "security." namespace,
> +        * it may be impossible to get real value stored in xattr.
> +        * An LSM may mangle the attribute value to its own ends.
> +        * Smack is known to do this.
> +        * virtual namespace "integrity." is used to fetch real
> +        * security attributes without talking to LSM
> +        */
> +       if (!strncmp(name, XATTR_INTEGRITY_PREFIX,
> +                               XATTR_INTEGRITY_PREFIX_LEN)) {
> +               /* replace "integrity. with security. */
> +               snprintf(name_buf, sizeof(name_buf), "security.%s",
> +                        name + XATTR_INTEGRITY_PREFIX_LEN);
> +               usename = name_buf;
> +       }
>
> -       error = xattr_permission(inode, name, MAY_READ);
> +       error = xattr_permission(inode, usename, MAY_READ);
>         if (error)
>                 return error;
>
> -       error = security_inode_getxattr(dentry, name);
> +       error = security_inode_getxattr(dentry, usename);
>         if (error)
>                 return error;
>
> @@ -255,7 +271,7 @@ vfs_getxattr(struct dentry *dentry, const char *name, void *value, size_t size)
>         }
>  nolsm:
>         if (inode->i_op->getxattr)
> -               error = inode->i_op->getxattr(dentry, name, value, size);
> +               error = inode->i_op->getxattr(dentry, usename, value, size);
>         else
>                 error = -EOPNOTSUPP;
>
> diff --git a/include/uapi/linux/xattr.h b/include/uapi/linux/xattr.h
> index 26607bd..133998b 100644
> --- a/include/uapi/linux/xattr.h
> +++ b/include/uapi/linux/xattr.h
> @@ -20,6 +20,10 @@
>  #define XATTR_SECURITY_PREFIX  "security."
>  #define XATTR_SECURITY_PREFIX_LEN (sizeof (XATTR_SECURITY_PREFIX) - 1)
>
> +/* integrity - security mirror namespace for integrity purpose */
> +#define XATTR_INTEGRITY_PREFIX "integrity."
> +#define XATTR_INTEGRITY_PREFIX_LEN (sizeof (XATTR_INTEGRITY_PREFIX) - 1)
> +
>  #define XATTR_SYSTEM_PREFIX "system."
>  #define XATTR_SYSTEM_PREFIX_LEN (sizeof (XATTR_SYSTEM_PREFIX) - 1)
>
> --
> 1.7.10.4
>
