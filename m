Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbaHHU14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:27:56 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:60472
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaHHU1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:27:53 -0400
Date: Fri, 8 Aug 2014 22:27:52 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 1/3] Smack: fix behavior of smack_inode_listsecurity
Message-ID: <20140808202752.GB25352@mail.hallyn.com>
References: <20140807165233.13463.55258.stgit@buzz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807165233.13463.55258.stgit@buzz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Konstantin Khlebnikov (k.khlebnikov@samsung.com):
> Security operation ->inode_listsecurity is used for generating list of
> available extended attributes for syscall listxattr. Currently it's used
> only in nfs4 or if filesystem doesn't provide i_op->listxattr.
> 
> The list is the set of NULL-terminated names, one after the other.
> This method must include zero byte at the and into result.
> 
> Also this function must return length even if string does not fit into
> output buffer or it is NULL, see similar method in selinux and man listxattr.
> 
> Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
>  security/smack/smack_lsm.c |    9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index e6ab307..b11ab23 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -1122,13 +1122,12 @@ static int smack_inode_getsecurity(const struct inode *inode,
>  static int smack_inode_listsecurity(struct inode *inode, char *buffer,
>  				    size_t buffer_size)
>  {
> -	int len = strlen(XATTR_NAME_SMACK);
> +	int len = sizeof(XATTR_NAME_SMACK);
>  
> -	if (buffer != NULL && len <= buffer_size) {
> +	if (buffer != NULL && len <= buffer_size)
>  		memcpy(buffer, XATTR_NAME_SMACK, len);
> -		return len;
> -	}
> -	return -EINVAL;
> +
> +	return len;
>  }
>  
>  /**
