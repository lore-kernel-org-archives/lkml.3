Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447Ab3FGWNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 18:13:48 -0400
Received: from smtp105.biz.mail.gq1.yahoo.com ([98.137.12.180]:45239 "HELO
	smtp105.biz.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752746Ab3FGWNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 18:13:47 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: .7XTuOQVM1kULlD0e8.lsv9tneTBroTTC2bpoVOMCQrnxfn
 88SsvsbW0TAWxJJ6H9adcO4TDWC0bKWR1Y.KdSTnjsOZ9tTLh6LwTcJlCpT5
 dFeel5MmvBz3ytgKul_JM2qvjtOuxgiOlDmHp.HvwaivDnqH2PjU1aDyp8GU
 bvJFZNSVIl5dM1Sv4E1eGNSNd1ixTQD5_Ik.BCBxfRX2DvWHhQAuabpkHukQ
 H9hY4joBSggEe0h35NB7DvdloEvqNKm3lX1KXhIBp7qp7iIPPJVMP0VPHHpG
 ngJnPR0QDvu2OlbnyvHubWtsS3OBjLf4X6T3rQgZMtuchR6mjsASEBiibvS1
 N9_438d.gXyUMmTLfGt1eyW1Kfs.DtYCk6jiJURGhERWy3.RQR5VL2hHv9LK
 UXF14LrtJSLAra6jQlt5hGp6VllFgf.P5YWCp_2GQ74YVki43qAV1GiqTWpB
 Gf2SIv1POVz2nGBl31FJxn6FvdmoGsUYNgs1yX9h.u.e8QDduxbtxqAoyZFM
 OUbyhjYqbBt6.ij5aKOmB_ELxx5_ZdUzFZc2tRmvpkg9g
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with plain)
        by smtp105.biz.mail.gq1.yahoo.com with SMTP; 07 Jun 2013 15:13:46 -0700 PDT
Message-ID: <51B25B17.3010807@schaufler-ca.com>
Date: Fri, 07 Jun 2013 15:13:43 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
CC: Casey Schaufler <casey@schaufler-ca.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/2] f2fs: support xattr security labels
References: <1370584557-20592-1-git-send-email-jaegeuk.kim@samsung.com> <1370584557-20592-2-git-send-email-jaegeuk.kim@samsung.com>
In-Reply-To: <1370584557-20592-2-git-send-email-jaegeuk.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/6/2013 10:55 PM, Jaegeuk Kim wrote:
> This patch adds the support of security labels for f2fs, which will be used
> by SElinux.

Please be inclusive. Security xattrs are used by LSMs other than SELinux.

> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> ---
>  fs/f2fs/Kconfig |  9 +++++++++
>  fs/f2fs/dir.c   |  5 +++++
>  fs/f2fs/xattr.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  fs/f2fs/xattr.h | 12 +++++++++++-
>  4 files changed, 82 insertions(+), 3 deletions(-)
>
> diff --git a/fs/f2fs/Kconfig b/fs/f2fs/Kconfig
> index fd27e7e..2214cc9 100644
> --- a/fs/f2fs/Kconfig
> +++ b/fs/f2fs/Kconfig
> @@ -51,3 +51,12 @@ config F2FS_FS_POSIX_ACL
>  	  Linux website <http://acl.bestbits.at/>.
>  
>  	  If you don't know what Access Control Lists are, say N
> +
> +config F2FS_FS_SECURITY
> +	bool "F2FS Security Labels"
> +	depends on F2FS_FS_XATTR
> +	help
> +	  Security labels provide acls used by the security modules
> +	  like SELinux. This option should be used with the xattr mode.

This description missuses the term "acl". Security labels are not
Access Control Lists (ACLs). What is the "xattr mode"? If this option
depends on xattr support "should" is not correct.

> +
> +	  If you are not using a security module, say N.
> diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
> index 67e2d13..81a1d6f 100644
> --- a/fs/f2fs/dir.c
> +++ b/fs/f2fs/dir.c
> @@ -13,6 +13,7 @@
>  #include "f2fs.h"
>  #include "node.h"
>  #include "acl.h"
> +#include "xattr.h"
>  
>  static unsigned long dir_blocks(struct inode *inode)
>  {
> @@ -334,6 +335,10 @@ static struct page *init_inode_metadata(struct inode *inode,
>  		if (err)
>  			goto error;
>  
> +		err = f2fs_init_security(inode, dir, name);
> +		if (err)
> +			goto error;
> +
>  		wait_on_page_writeback(page);
>  	} else {
>  		page = get_node_page(F2FS_SB(dir->i_sb), inode->i_ino);
> diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
> index ae61f35..b5292fa 100644
> --- a/fs/f2fs/xattr.c
> +++ b/fs/f2fs/xattr.c
> @@ -20,6 +20,7 @@
>   */
>  #include <linux/rwsem.h>
>  #include <linux/f2fs_fs.h>
> +#include <linux/security.h>
>  #include "f2fs.h"
>  #include "xattr.h"
>  
> @@ -43,6 +44,10 @@ static size_t f2fs_xattr_generic_list(struct dentry *dentry, char *list,
>  		prefix = XATTR_TRUSTED_PREFIX;
>  		prefix_len = XATTR_TRUSTED_PREFIX_LEN;
>  		break;
> +	case F2FS_XATTR_INDEX_SECURITY:
> +		prefix = XATTR_SECURITY_PREFIX;
> +		prefix_len = XATTR_SECURITY_PREFIX_LEN;
> +		break;
>  	default:
>  		return -EINVAL;
>  	}
> @@ -70,13 +75,14 @@ static int f2fs_xattr_generic_get(struct dentry *dentry, const char *name,
>  		if (!capable(CAP_SYS_ADMIN))
>  			return -EPERM;
>  		break;
> +	case F2FS_XATTR_INDEX_SECURITY:
> +		break;
>  	default:
>  		return -EINVAL;
>  	}
>  	if (strcmp(name, "") == 0)
>  		return -EINVAL;
> -	return f2fs_getxattr(dentry->d_inode, type, name,
> -			buffer, size);
> +	return f2fs_getxattr(dentry->d_inode, type, name, buffer, size);
>  }
>  
>  static int f2fs_xattr_generic_set(struct dentry *dentry, const char *name,
> @@ -93,6 +99,8 @@ static int f2fs_xattr_generic_set(struct dentry *dentry, const char *name,
>  		if (!capable(CAP_SYS_ADMIN))
>  			return -EPERM;
>  		break;
> +	case F2FS_XATTR_INDEX_SECURITY:
> +		break;
>  	default:
>  		return -EINVAL;
>  	}
> @@ -145,6 +153,40 @@ static int f2fs_xattr_advise_set(struct dentry *dentry, const char *name,
>  	return 0;
>  }
>  
> +#ifdef CONFIG_F2FS_FS_SECURITY
> +static int f2fs_initxattrs(struct inode *inode, const struct xattr *xattr_array,
> +		void *fs_info)
> +{
> +	const struct xattr *xattr;
> +	char *name;
> +	int err = 0;
> +
> +	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
> +		name = kmalloc(XATTR_SECURITY_PREFIX_LEN +
> +			       strlen(xattr->name) + 1, GFP_NOFS);
> +		if (!name) {
> +			err = -ENOMEM;
> +			break;
> +		}
> +		strcpy(name, XATTR_SECURITY_PREFIX);
> +		strcpy(name + XATTR_SECURITY_PREFIX_LEN, xattr->name);

		sprintf(name, XATTR_SECURITY_PREFIX "%s", xattr->name);

might look simpler.

> +		err = f2fs_setxattr(inode, F2FS_XATTR_INDEX_SECURITY, name,
> +					xattr->value, xattr->value_len);
> +		kfree(name);
> +		if (err < 0)
> +			break;
> +	}
> +	return err;
> +}
> +
> +int f2fs_init_security(struct inode *inode, struct inode *dir,
> +				const struct qstr *qstr)
> +{
> +	return security_inode_init_security(inode, dir, qstr,
> +				&f2fs_initxattrs, NULL);
> +}
> +#endif
> +
>  const struct xattr_handler f2fs_xattr_user_handler = {
>  	.prefix	= XATTR_USER_PREFIX,
>  	.flags	= F2FS_XATTR_INDEX_USER,
> @@ -169,6 +211,13 @@ const struct xattr_handler f2fs_xattr_advise_handler = {
>  	.set    = f2fs_xattr_advise_set,
>  };
>  
> +const struct xattr_handler f2fs_xattr_security_handler = {
> +	.prefix	= XATTR_SECURITY_PREFIX,
> +	.list	= f2fs_xattr_generic_list,
> +	.get	= f2fs_xattr_generic_get,
> +	.set	= f2fs_xattr_generic_set,
> +};
> +
>  static const struct xattr_handler *f2fs_xattr_handler_map[] = {
>  	[F2FS_XATTR_INDEX_USER] = &f2fs_xattr_user_handler,
>  #ifdef CONFIG_F2FS_FS_POSIX_ACL
> @@ -177,6 +226,9 @@ static const struct xattr_handler *f2fs_xattr_handler_map[] = {
>  #endif
>  	[F2FS_XATTR_INDEX_TRUSTED] = &f2fs_xattr_trusted_handler,
>  	[F2FS_XATTR_INDEX_ADVISE] = &f2fs_xattr_advise_handler,
> +#ifdef CONFIG_F2FS_FS_SECURITY
> +	[F2FS_XATTR_INDEX_SECURITY] = &f2fs_xattr_security_handler,
> +#endif
>  };
>  
>  const struct xattr_handler *f2fs_xattr_handlers[] = {
> @@ -187,6 +239,9 @@ const struct xattr_handler *f2fs_xattr_handlers[] = {
>  #endif
>  	&f2fs_xattr_trusted_handler,
>  	&f2fs_xattr_advise_handler,
> +#ifdef CONFIG_F2FS_FS_SECURITY
> +	&f2fs_xattr_security_handler,
> +#endif
>  	NULL,
>  };
>  
> diff --git a/fs/f2fs/xattr.h b/fs/f2fs/xattr.h
> index 49c9558..14e1329 100644
> --- a/fs/f2fs/xattr.h
> +++ b/fs/f2fs/xattr.h
> @@ -112,6 +112,7 @@ extern const struct xattr_handler f2fs_xattr_trusted_handler;
>  extern const struct xattr_handler f2fs_xattr_acl_access_handler;
>  extern const struct xattr_handler f2fs_xattr_acl_default_handler;
>  extern const struct xattr_handler f2fs_xattr_advise_handler;
> +extern const struct xattr_handler f2fs_xattr_security_handler;
>  
>  extern const struct xattr_handler *f2fs_xattr_handlers[];
>  
> @@ -121,7 +122,6 @@ extern int f2fs_getxattr(struct inode *inode, int name_index, const char *name,
>  		void *buffer, size_t buffer_size);
>  extern ssize_t f2fs_listxattr(struct dentry *dentry, char *buffer,
>  		size_t buffer_size);
> -
>  #else
>  
>  #define f2fs_xattr_handlers	NULL
> @@ -142,4 +142,14 @@ static inline ssize_t f2fs_listxattr(struct dentry *dentry, char *buffer,
>  }
>  #endif
>  
> +#ifdef CONFIG_F2FS_FS_SECURITY
> +extern int f2fs_init_security(struct inode *inode, struct inode *dir,
> +				const struct qstr *qstr);
> +#else
> +static inline int f2fs_init_security(struct inode *inode, struct inode *dir,
> +				const struct qstr *qstr)
> +{
> +	return 0;
> +}
> +#endif
>  #endif /* __F2FS_XATTR_H__ */

