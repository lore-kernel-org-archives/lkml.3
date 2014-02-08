Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751014AbaBHGBG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 01:01:06 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:45392 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaBHGBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 01:01:04 -0500
Date: Sat, 8 Feb 2014 01:01:01 -0500 (EST)
From: "Michael L. Semon" <mlsemon35@gmail.com>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
cc: "Michael L. Semon" <mlsemon35@gmail.com>, Christoph Hellwig <hch@lst.de>,
        JFS Discussion <jfs-discussion@lists.sourceforge.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] jfs: fix generic posix ACL regression
In-Reply-To: <52F54928.9050601@oracle.com>
Message-ID: <alpine.LNX.2.11.1402072358120.3321@bpserver.ds>
References: <52F54928.9050601@oracle.com>
User-Agent: Alpine 2.11 (LNX 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good.  I'm keeping the patch.  It was placed through the
following tests:

*) the test suite from the January 19 git acl, as root;
    (git://git.savannah.nongnu.org/acl.git)

*) the acl test suite, as a regular user;

*) xfstests (full run); and

*) some fs_mark and LTP fsstress in a dir populated with three
    default ACLs.

Tests were done on an i686 Pentium 4 PC, using kernels 3.14.0-rc1+
and 3.13.0+.  Comparisons were made with standard XFS.  Due to non-JFS
issues, lockdep is off and CONFIG_AIO=n, meaning that their effects
are not represented here.

The xfstests run for JFS looked unchanged over kernel 3.13.0+, with
the exeption of the error "+error: ctime not updated after setfacl"
from generic/307.  The test uses integer seconds to compare ctime, so
I inserted some regular stat commands into the test.  The nanosecond
portion of the timestamps also do not change.  JFS from 3.13.0+
passed this test; XFS from 3.14.0-rc1+ passed this test as well.

For JFS, the new generic ACL infrastructure provides a reduction of
99 failures from the acl test suite, most of them from the misc.test
series of tests.  Pass or fail, results were equal to that of XFS,
which seemed to gain 10 errors from the root/*.test tests.

Thanks!  Christoph's generic ACL work now makes much more sense to
me than it did at this time yesterday.  The prompt patch from Shaggy
allows me to use it on JFS as well :-)

Michael

On Fri, 7 Feb 2014, Dave Kleikamp wrote:

> I missed a couple errors in reviewing the patches converting jfs
> to use the generic posix ACL function. Setting ACL's currently
> fails with -EOPNOTSUPP.
>
> Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
> Reported-by: Michael L. Semon <mlsemon35@gmail.com>
> Cc: Christoph Hellwig <hch@lst.de>
> ---
> fs/jfs/xattr.c | 14 +++++++-------
> 1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/fs/jfs/xattr.c b/fs/jfs/xattr.c
> index 3bd5ee4..46325d5 100644
> --- a/fs/jfs/xattr.c
> +++ b/fs/jfs/xattr.c
> @@ -854,9 +854,6 @@ int jfs_setxattr(struct dentry *dentry, const char *name, const void *value,
> 	int rc;
> 	tid_t tid;
>
> -	if ((rc = can_set_xattr(inode, name, value, value_len)))
> -		return rc;
> -
> 	/*
> 	 * If this is a request for a synthetic attribute in the system.*
> 	 * namespace use the generic infrastructure to resolve a handler
> @@ -865,6 +862,9 @@ int jfs_setxattr(struct dentry *dentry, const char *name, const void *value,
> 	if (!strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
> 		return generic_setxattr(dentry, name, value, value_len, flags);
>
> +	if ((rc = can_set_xattr(inode, name, value, value_len)))
> +		return rc;
> +
> 	if (value == NULL) {	/* empty EA, do not remove */
> 		value = "";
> 		value_len = 0;
> @@ -1034,9 +1034,6 @@ int jfs_removexattr(struct dentry *dentry, const char *name)
> 	int rc;
> 	tid_t tid;
>
> -	if ((rc = can_set_xattr(inode, name, NULL, 0)))
> -		return rc;
> -
> 	/*
> 	 * If this is a request for a synthetic attribute in the system.*
> 	 * namespace use the generic infrastructure to resolve a handler
> @@ -1045,6 +1042,9 @@ int jfs_removexattr(struct dentry *dentry, const char *name)
> 	if (!strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
> 		return generic_removexattr(dentry, name);
>
> +	if ((rc = can_set_xattr(inode, name, NULL, 0)))
> +		return rc;
> +
> 	tid = txBegin(inode->i_sb, 0);
> 	mutex_lock(&ji->commit_mutex);
> 	rc = __jfs_setxattr(tid, dentry->d_inode, name, NULL, 0, XATTR_REPLACE);
> @@ -1061,7 +1061,7 @@ int jfs_removexattr(struct dentry *dentry, const char *name)
>  * attributes are handled directly.
>  */
> const struct xattr_handler *jfs_xattr_handlers[] = {
> -#ifdef JFS_POSIX_ACL
> +#ifdef CONFIG_JFS_POSIX_ACL
> 	&posix_acl_access_xattr_handler,
> 	&posix_acl_default_xattr_handler,
> #endif
> -- 
> 1.8.5.3
>
>
