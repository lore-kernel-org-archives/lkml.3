Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbaHHUgM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:36:12 -0400
Received: from smtp101.biz.mail.bf1.yahoo.com ([98.139.221.60]:33066 "EHLO
	smtp101.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750853AbaHHUgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:36:09 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Aug 2014 16:36:08 EDT
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: PReVO5AVM1m5nRHKmmCeZNl_jMHXl1tfAaqb3w4v4G4B3Lx
 4U2OK8IAImTcz.oyF4N6U51fiyRSkRUtcoCsz0aX590yMFhBSH8HW2T64_KI
 RllVKKF9PlcnHkXUnuN8x8ApynRiC9cLpNcWszJlZyAK0SrILkcZ_xx0FgzF
 e5oM6vxHP9Dxyiptlr.dBQvbXTUPXiLR_R3n20J1JoWy0KafEVH9B_LpnbBI
 c0lug68lO9zlqbHgNw4.fRTKY3JRfnZl.cVjbDpFOcltB0fR2GGOzvC724C8
 GwRBAqJm.Kb4dsiGbqUlxDKZtolXD5xoRPJ4tlgiJkl5XvaJBrfKmI09Wy2R
 pl7PxPB_OoZq3BkItsTxMZEhPeOC3FQZdgp2aAzx51pde8U2m_vOe4RIm2Wc
 n2VjHl4JfoMjFLDMYXNzgwxHrTzs8weNIquYUvOdfU.Xw9oPrqSUi27C1f03
 bBT7JPfPKMa.HjZaM6Yw0GJpXv2HzahE6WLwk83eKXG7I_3lt4eGX_IevipU
 cZQ3g8swQmBQSn9B27qR.bQ.n
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <53E53329.6060200@schaufler-ca.com>
Date: Fri, 08 Aug 2014 13:29:29 -0700
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

I plan to ack this patch set once I've run them through my tests.

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

