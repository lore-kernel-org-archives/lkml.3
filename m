Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab3HTDpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 23:45:35 -0400
Received: from intranet.asianux.com ([58.214.24.6]:47496 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab3HTDpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 23:45:33 -0400
X-Spam-Score: -101.1
Message-ID: <5212E61F.7010602@asianux.com>
Date: Tue, 20 Aug 2013 11:44:31 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: steffen.klassert@secunet.com
CC: linux-crypto@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/padata.c: always check the return value of __padata_remove_cpu()
 and __padata_add_cpu()
References: <5212E5E4.8010408@asianux.com>
In-Reply-To: <5212E5E4.8010408@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If this patch is correct, better to let CPU_ONLINE and CPU_DOWN_FAILED
share the same code.

And do we need a comment "/* fall through */" between CPU_UP_CANCELED
and CPU_DOWN_FAILED (or it is another bug, need a 'break' statement) ?

At last, also better to let CPU_DOWN_PREPARE and CPU_UP_CANCELED share
the same code (if need a 'break'), or share the most of code (if "fall
through").

Thanks.

On 08/20/2013 11:43 AM, Chen Gang wrote:
> When failure occures, __padata_add_cpu() and __padata_remove_cpu() will
> return -ENOMEM, which need be noticed in any cases (even in cleaning up
> cases).
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  kernel/padata.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/padata.c b/kernel/padata.c
> index 072f4ee..6a124cd 100644
> --- a/kernel/padata.c
> +++ b/kernel/padata.c
> @@ -871,16 +871,20 @@ static int padata_cpu_callback(struct notifier_block *nfb,
>  		if (!pinst_has_cpu(pinst, cpu))
>  			break;
>  		mutex_lock(&pinst->lock);
> -		__padata_remove_cpu(pinst, cpu);
> +		err = __padata_remove_cpu(pinst, cpu);
>  		mutex_unlock(&pinst->lock);
> +		if (err)
> +			return notifier_from_errno(err);
>  
>  	case CPU_DOWN_FAILED:
>  	case CPU_DOWN_FAILED_FROZEN:
>  		if (!pinst_has_cpu(pinst, cpu))
>  			break;
>  		mutex_lock(&pinst->lock);
> -		__padata_add_cpu(pinst, cpu);
> +		err = __padata_add_cpu(pinst, cpu);
>  		mutex_unlock(&pinst->lock);
> +		if (err)
> +			return notifier_from_errno(err);
>  	}
>  
>  	return NOTIFY_OK;
> 


-- 
Chen Gang
