Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab3KYWDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 17:03:08 -0500
Received: from mail-qe0-f51.google.com ([209.85.128.51]:49366 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab3KYWDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 17:03:04 -0500
From: Paul Moore <paul@paul-moore.com>
To: "Geyslan G. Bem" <geyslan@gmail.com>
Cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@parisplace.org>,
        linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov
Subject: Re: [PATCH] selinux: fix possible memory leak
Date: Mon, 25 Nov 2013 17:02:59 -0500
Message-ID: <15945270.AQEhGkaEur@sifl>
User-Agent: KMail/4.11.3 (Linux/3.12.0-gentoo; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1385293021-2767-1-git-send-email-geyslan@gmail.com>
References: <1385293021-2767-1-git-send-email-geyslan@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 24, 2013 08:37:01 AM Geyslan G. Bem wrote:
> Free 'ctx_str' when necessary.
> 
> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
> ---
>  security/selinux/xfrm.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)

Nice catch, applied.

> diff --git a/security/selinux/xfrm.c b/security/selinux/xfrm.c
> index a91d205..cf79a45 100644
> --- a/security/selinux/xfrm.c
> +++ b/security/selinux/xfrm.c
> @@ -327,19 +327,22 @@ int selinux_xfrm_state_alloc_acquire(struct xfrm_state
> *x, return rc;
> 
>  	ctx = kmalloc(sizeof(*ctx) + str_len, GFP_ATOMIC);
> -	if (!ctx)
> -		return -ENOMEM;
> +	if (!ctx) {
> +		rc = -ENOMEM;
> +		goto out;
> +	}
> 
>  	ctx->ctx_doi = XFRM_SC_DOI_LSM;
>  	ctx->ctx_alg = XFRM_SC_ALG_SELINUX;
>  	ctx->ctx_sid = secid;
>  	ctx->ctx_len = str_len;
>  	memcpy(ctx->ctx_str, ctx_str, str_len);
> -	kfree(ctx_str);
> 
>  	x->security = ctx;
>  	atomic_inc(&selinux_xfrm_refcount);
> -	return 0;
> +out:
> +	kfree(ctx_str);
> +	return rc;
>  }
> 
>  /*

-- 
paul moore
www.paul-moore.com

