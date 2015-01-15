Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbbAOToX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 14:44:23 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:47519 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbbAOToU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 14:44:20 -0500
Message-ID: <54B8188D.1060907@linux.vnet.ibm.com>
Date: Thu, 15 Jan 2015 11:44:13 -0800
From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Laurent Dufour <ldufour@linux.vnet.ibm.com>, mpe@ellerman.id.au
CC: paulus@samba.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] pseries/le: Fix another endiannes issue in RTAS call
 from xmon
References: <1421295950.11409.3.camel@ellerman.id.au> <1421342627-7214-1-git-send-email-ldufour@linux.vnet.ibm.com>
In-Reply-To: <1421342627-7214-1-git-send-email-ldufour@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011519-0033-0000-0000-00000358455B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2015 09:23 AM, Laurent Dufour wrote:
> The commit 3b8a3c010969 ("powerpc/pseries: Fix endiannes issue in RTAS
> call from xmon") was fixing an endianness issue in the call made from
> xmon to RTAS.
> 
> However, as Michael Ellerman noticed, this fix was not complete, the
> token value was not byte swapped. This lead to call an unexpected and
> most of the time unexisting RTAS function, which is silently ignored
> by RTAS.

Nit. Not so much that is silently ignored by RTAS as much as
disable_surveillance silently doesn't check the return status of the
RTAS call. Maybe a check is warranted and reporting of non-success.

-Tyrel

> 
> This fix addresses this hole.
> 
> Reported-by: Michael Ellerman <mpe@ellerman.id.au>
> Cc: stable@vger.kernel.org
> Signed-off-by: Laurent Dufour <ldufour@linux.vnet.ibm.com>
> ---
>  arch/powerpc/xmon/xmon.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
> index 5b150f0c5df9..13c6e200b24e 100644
> --- a/arch/powerpc/xmon/xmon.c
> +++ b/arch/powerpc/xmon/xmon.c
> @@ -337,6 +337,7 @@ static inline void disable_surveillance(void)
>  	args.token = rtas_token("set-indicator");
>  	if (args.token == RTAS_UNKNOWN_SERVICE)
>  		return;
> +	args.token = cpu_to_be32(args.token);
>  	args.nargs = cpu_to_be32(3);
>  	args.nret = cpu_to_be32(1);
>  	args.rets = &args.args[3];
> 

