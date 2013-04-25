Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025Ab3DYNCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 09:02:52 -0400
Received: from smarthost04.mail.zen.net.uk ([212.23.1.4]:36442 "EHLO
	smarthost04.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756935Ab3DYNCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 09:02:51 -0400
Message-ID: <1366894965.3528.19.camel@computer5.home>
Subject: Re: [PATCH] mfd: vexpress: Handle pending config transactions
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Thu, 25 Apr 2013 14:02:45 +0100
In-Reply-To: <1366821084-12815-1-git-send-email-pawel.moll@arm.com>
References: <1366821084-12815-1-git-send-email-pawel.moll@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost04-IP: [212.183.128.146]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-24 at 17:31 +0100, Pawel Moll wrote:
> The config transactions "scheduler" was hopelessly broken,
> repeating completed transaction instead of picking up
> next pending one.
> 
> Fixed now. Also improved debug messages.
> 
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> ---
>  drivers/mfd/vexpress-config.c |   31 ++++++++++++++++++++-----------
>  1 file changed, 20 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/mfd/vexpress-config.c b/drivers/mfd/vexpress-config.c
> index 3c1723aa..4991db3 100644
> --- a/drivers/mfd/vexpress-config.c
> +++ b/drivers/mfd/vexpress-config.c
> @@ -184,13 +184,14 @@ static int vexpress_config_schedule(struct vexpress_config_trans *trans)
>  
>  	spin_lock_irqsave(&bridge->transactions_lock, flags);
>  
> -	vexpress_config_dump_trans("Executing", trans);
> -
> -	if (list_empty(&bridge->transactions))
> +	if (list_empty(&bridge->transactions)) {
> +		vexpress_config_dump_trans("Executing", trans);
>  		status = bridge->info->func_exec(trans->func->func,
>  				trans->offset, trans->write, trans->data);
> -	else
> +	} else {
> +		vexpress_config_dump_trans("Queuing", trans);
>  		status = VEXPRESS_CONFIG_STATUS_WAIT;
> +	}
>  
>  	switch (status) {
>  	case VEXPRESS_CONFIG_STATUS_DONE:
> @@ -217,20 +218,28 @@ void vexpress_config_complete(struct vexpress_config_bridge *bridge,
>  
>  	trans = list_first_entry(&bridge->transactions,
>  			struct vexpress_config_trans, list);
> +	trans->status = status;
>  	vexpress_config_dump_trans("Completed", trans);
>  
> -	trans->status = status;
>  	list_del(&trans->list);
>  
> -	if (!list_empty(&bridge->transactions)) {
> -		vexpress_config_dump_trans("Pending", trans);
> +	complete(&trans->completion);
> +
> +	while (!list_empty(&bridge->transactions)) {
> +		trans = list_first_entry(&bridge->transactions,
> +				struct vexpress_config_trans, list);
>  
> -		bridge->info->func_exec(trans->func->func, trans->offset,
> -				trans->write, trans->data);
> +		vexpress_config_dump_trans("Executing pending", trans);
> +		status = bridge->info->func_exec(trans->func->func,
> +				trans->offset, trans->write, trans->data);
> +
> +		if (status == VEXPRESS_CONFIG_STATUS_DONE)
> +			vexpress_config_dump_trans("Finished pending", trans);
> +		else
> +			break;

For each transaction we execute in this loop, don't we also need to do
the actions vexpress_config_complete does? E.g.

	trans->status = status;
	list_del(&trans->list);
	complete(&trans->completion);

except in the case status==VEXPRESS_CONFIG_STATUS_WAIT.

Or, does the call to func_exec cause vexpress_config_complete() to be
called later? (It hadn't better be called synchronously or we get a
deadlock).

Actually, if it is called later, there is still a problem because if the
call to func_exec returns VEXPRESS_CONFIG_STATUS_DONE then the
transaction is left on the list and the while loop will try and execute
it again.

>  	}
> -	spin_unlock_irqrestore(&bridge->transactions_lock, flags);
>  
> -	complete(&trans->completion);
> +	spin_unlock_irqrestore(&bridge->transactions_lock, flags);
>  }
>  EXPORT_SYMBOL(vexpress_config_complete);
>  

-- 
Tixy

