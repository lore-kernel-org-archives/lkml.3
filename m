Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbaDAKaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 06:30:24 -0400
Received: from order.stressinduktion.org ([87.106.68.36]:44004 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaDAKaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 06:30:21 -0400
Date: Tue, 1 Apr 2014 12:30:20 +0200
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Vegard Nossum <vegard.nossum@oracle.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org
Subject: Re: [PATCH] isdnloop: NUL-terminate strings from userspace
Message-ID: <20140401103020.GG24150@order.stressinduktion.org>
Mail-Followup-To: Vegard Nossum <vegard.nossum@oracle.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dan Carpenter <dan.carpenter@oracle.com>,
	"David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org
References: <1396346898-8950-1-git-send-email-vegard.nossum@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1396346898-8950-1-git-send-email-vegard.nossum@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 12:08:18PM +0200, Vegard Nossum wrote:
> Both the in-kernel and BSD strlcpy() require that the source string is
> NUL terminated. We could use strncpy() + explicitly terminate the result,
> but this relies on src and dest having the same size, so the safest thing
> to do seems to explicitly terminate the source string before doing the
> strlcpy().
> 
> Fixes: f9a23c84486ed35 ("isdnloop: use strlcpy() instead of strcpy()")
> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: stable@vger.kernel.org
> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
> ---
>  drivers/isdn/isdnloop/isdnloop.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/isdn/isdnloop/isdnloop.c b/drivers/isdn/isdnloop/isdnloop.c
> index 02125e6..50cd348 100644
> --- a/drivers/isdn/isdnloop/isdnloop.c
> +++ b/drivers/isdn/isdnloop/isdnloop.c
> @@ -1070,6 +1070,14 @@ isdnloop_start(isdnloop_card *card, isdnloop_sdef *sdefp)
>  		return -EBUSY;
>  	if (copy_from_user((char *) &sdef, (char *) sdefp, sizeof(sdef)))
>  		return -EFAULT;
> +
> +	/*
> +	 * Null terminate strings from userspace so we don't have to worry
> +	 * about this later on.
> +	 */
> +	for (i = 0; i < 3; i++)
> +		sdef.num[i][sizeof(sdef.num[0]) - 1] = '\0';
> +

Looking down the problem, it seems the problem is that the strlen in strlcpy
could read beyond the input buffer?

To prevent this problem in other parts of the kernel wouldn't it be better to
replace the strlen with strnlen in strlcpy?

Bye,

  Hannes

