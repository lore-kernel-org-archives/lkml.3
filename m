Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbaIPBIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 21:08:15 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34957 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbaIPBIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 21:08:13 -0400
Message-ID: <54178D6E.9090705@oracle.com>
Date: Mon, 15 Sep 2014 21:07:58 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>, konrad.wilk@oracle.com,
        David Vrabel <david.vrabel@citrix.com>,
        stefano.stabellini@eu.citrix.com, mukesh.rathor@oracle.com
CC: xen-devel@lists.xenproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] drivers/xen/xenbus/xenbus_client.c: Improve the failure
 processing for __xenbus_switch_state()
References: <54157282.40402@gmail.com> <5415737D.2030209@gmail.com>
In-Reply-To: <5415737D.2030209@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/14/2014 06:52 AM, Chen Gang wrote:
> When failure occurs, need return failure code instead of 0, or the upper
> caller will misunderstand.
>
> Also when retry for EAGAIN reason, better to schedule out for a while,
> so can let others have chance to continue their tasks (especially,
> their tasks are related EAGAIN under UP kernel).
>
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>   drivers/xen/xenbus/xenbus_client.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
> index 620ffd2..fc8699b 100644
> --- a/drivers/xen/xenbus/xenbus_client.c
> +++ b/drivers/xen/xenbus/xenbus_client.c
> @@ -36,6 +36,7 @@
>   #include <linux/spinlock.h>
>   #include <linux/vmalloc.h>
>   #include <linux/export.h>
> +#include <linux/delay.h>
>   #include <asm/xen/hypervisor.h>
>   #include <asm/xen/page.h>
>   #include <xen/interface/xen.h>
> @@ -196,7 +197,7 @@ again:
>   	err = xenbus_transaction_start(&xbt);
>   	if (err) {
>   		xenbus_switch_fatal(dev, depth, err, "starting transaction");
> -		return 0;
> +		return err;
>   	}
>   
>   	err = xenbus_scanf(xbt, dev->nodename, "state", "%d", &current_state);
> @@ -213,13 +214,15 @@ again:
>   abort:
>   	err = xenbus_transaction_end(xbt, abort);
>   	if (err) {
> -		if (err == -EAGAIN && !abort)
> +		if (err == -EAGAIN && !abort) {
> +			msleep(20);

I'd suggest you use schedule() here.

-boris

>   			goto again;
> +		}
>   		xenbus_switch_fatal(dev, depth, err, "ending transaction");
>   	} else
>   		dev->state = state;
>   
> -	return 0;
> +	return err;
>   }
>   
>   /**

