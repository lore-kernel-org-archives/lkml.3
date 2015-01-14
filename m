Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbbANTuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 14:50:06 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:58066 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbbANTuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 14:50:04 -0500
From: Paul Moore <paul@paul-moore.com>
To: Mark Salyzyn <salyzyn@android.com>
Cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>, selinux@tycho.nsa.gov,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 5/5] pstore: selinux: add security in-core xattr support for pstore and debugfs
Date: Wed, 14 Jan 2015 14:50:01 -0500
Message-ID: <4175437.ksvLooJb8o@sifl>
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <1421188410-2006-1-git-send-email-salyzyn@android.com>
References: <1421188410-2006-1-git-send-email-salyzyn@android.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 13, 2015 02:33:18 PM Mark Salyzyn wrote:
> - add "pstore" and "debugfs" to list of in-core exceptions
> - change fstype checks to boolean equation
> - change from strncmp to strcmp for checking
> 
> Signed-off-by: Mark Salyzyn <salyzyn@android.com>
> ---
>  security/selinux/hooks.c | 25 ++++++++-----------------
>  1 file changed, 8 insertions(+), 17 deletions(-)

Not a huge fan of the coding style, but merged into the next branch 
regardless.

Thanks.

> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 6da7532..789a7e1 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -401,23 +401,14 @@ static int selinux_is_sblabel_mnt(struct super_block
> *sb) {
>  	struct superblock_security_struct *sbsec = sb->s_security;
> 
> -	if (sbsec->behavior == SECURITY_FS_USE_XATTR ||
> -	    sbsec->behavior == SECURITY_FS_USE_TRANS ||
> -	    sbsec->behavior == SECURITY_FS_USE_TASK)
> -		return 1;
> -
> -	/* Special handling for sysfs. Is genfs but also has setxattr handler*/
> -	if (strncmp(sb->s_type->name, "sysfs", sizeof("sysfs")) == 0)
> -		return 1;
> -
> -	/*
> -	 * Special handling for rootfs. Is genfs but supports
> -	 * setting SELinux context on in-core inodes.
> -	 */
> -	if (strncmp(sb->s_type->name, "rootfs", sizeof("rootfs")) == 0)
> -		return 1;
> -
> -	return 0;
> +	return sbsec->behavior == SECURITY_FS_USE_XATTR ||
> +		sbsec->behavior == SECURITY_FS_USE_TRANS ||
> +		sbsec->behavior == SECURITY_FS_USE_TASK ||
> +		/* Special handling. Genfs but also in-core setxattr handler */
> +		!strcmp(sb->s_type->name, "sysfs") ||
> +		!strcmp(sb->s_type->name, "pstore") ||
> +		!strcmp(sb->s_type->name, "debugfs") ||
> +		!strcmp(sb->s_type->name, "rootfs");
>  }
> 
>  static int sb_finish_set_opts(struct super_block *sb)

-- 
paul moore
www.paul-moore.com

