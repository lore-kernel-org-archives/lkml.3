Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbaDWLlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 07:41:11 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:44273 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbaDWLlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 07:41:07 -0400
Date: Wed, 23 Apr 2014 14:40:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, security@kernel.org,
        ebiederm@xmission.com, stable@vger.kernel.org
Subject: Re: [PATCH] crypto_user: Fix out-of-bounds read
Message-ID: <20140423114039.GY4963@mwanda>
References: <57bf4e51f05fad506a0d1638852a5233b359e1dc.1398194946.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57bf4e51f05fad506a0d1638852a5233b359e1dc.1398194946.git.luto@amacapital.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 12:30:28PM -0700, Andy Lutomirski wrote:
> This is unlikely to be exploitable for anything except an OOPS.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
> 
> Notes:
>     This is entirely untested, but it looks obviously correct to me.
> 
>  crypto/crypto_user.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
> index 1512e41..bc7c4b5 100644
> --- a/crypto/crypto_user.c
> +++ b/crypto/crypto_user.c
> @@ -460,7 +460,7 @@ static int crypto_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>  	int type, err;
>  
>  	type = nlh->nlmsg_type;
> -	if (type > CRYPTO_MSG_MAX)
> +	if (type < CRYPTO_MSG_BASE || type > CRYPTO_MSG_MAX)
>  		return -EINVAL;

Adding a check here is obviously harmless but I think this is only
called from netlink_rcv_skb() which already checks:

	if (nlh->nlmsg_type < NLMSG_MIN_TYPE)
		goto ack;

NLMSG_MIN_TYPE is 0x10 as well, so I don't think we can hit your
condition.

Your patch freaked me out a little because this is one of the bugs that
I should have caught throught static analysis.

regards,
dan carpenter

