Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933864AbaHHWLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:11:42 -0400
Received: from smtp106.biz.mail.bf1.yahoo.com ([98.139.244.54]:47623 "EHLO
	smtp106.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964797AbaHHWLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 18:11:39 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Aug 2014 18:11:39 EDT
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: __Q3KFQVM1lWbgvbZhoqG3j1lfaSaPV0zN7rX8AFQCFTM_E
 UZN_p4t4GAhb6A5.5ALS9KAqioC0LcDuFP9ibzvrYSscAtkN6AUv4c6_g5A6
 LfjS_LdksjSsfWAt6jV2KC08OIY6DKmts4K2aQYt8K.Fgfrd73jj7HCJFPAU
 mG34j.5hiFhbxHDQ2IM5FXpv6R.ncWAzHdJgmvcanndrzjYWGJKbwkVezSr_
 eR9HoSdl0Dro157n6rk6i3ybC1O1wrpi_OddytjZfZi8IzCDiV0W15EVcm8q
 _VipLC_IFlU_EUb_2XQxbJBW7spevLyzy4O_G0jgeNj5gO.KFDX.LQ5hn84H
 NuQc7iK8otC0RQWZ5Nge2PQA4Um.MU5mRKKnC4PvvdME67.8SQ9Qs6SQIlid
 TTZgL0KwJYg1jPeXPao1hqrdvelF7frTU9wOAuKJq4ZCk0T8qCjVJyDPWxUL
 mTLhDHdarps_PYPfDyjM6ZUj38ta6Wb8SFHHUs9tWXUkE52SzfhF6lZoskxO
 hLfp1fF7cj4g4NIzr0.8v.qGLoooT6366o4Ig1C_s6QBP5O4LECWaWPuOXrH
 i8kyuI.j3wa2jNf.nR0eYaQEAS3vfE.TPOjEXbFek_dyizVf8Cgn1.rhXLQd
 jn8En
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <53E54989.9020008@schaufler-ca.com>
Date: Fri, 08 Aug 2014 15:04:57 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 1/3] Smack: fix behavior of smack_inode_listsecurity
References: <20140807165233.13463.55258.stgit@buzz>
In-Reply-To: <20140807165233.13463.55258.stgit@buzz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/7/2014 9:52 AM, Konstantin Khlebnikov wrote:
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

Applied to git://git.gitorious.org/smack-next/kernel.git#smack-for-3.18

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
>
>

