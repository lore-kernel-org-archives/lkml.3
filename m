Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbbA1U4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:56:38 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:56451 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746AbbA1U4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:56:32 -0500
Message-ID: <54C9125D.5040706@mvista.com>
Date: Wed, 28 Jan 2015 10:46:21 -0600
From: Corey Minyard <cminyard@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, minyard@acm.org
CC: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ipmi: avoid gcc warning
References: <2457592.UIVPJ2WNL3@wuerfel>
In-Reply-To: <2457592.UIVPJ2WNL3@wuerfel>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, queued for 3.20.

-corey

On 01/28/2015 09:00 AM, Arnd Bergmann wrote:
> A new harmless warning has come up on ARM builds with gcc-4.9:
>
> drivers/char/ipmi/ipmi_msghandler.c: In function 'smi_send.isra.11':
> include/linux/spinlock.h:372:95: warning: 'flags' may be used uninitialized in this function [-Wmaybe-uninitialized]
>   raw_spin_unlock_irqrestore(&lock->rlock, flags);
>                                                                                                ^
> drivers/char/ipmi/ipmi_msghandler.c:1490:16: note: 'flags' was declared here
>   unsigned long flags;
>                 ^
>
> This could be worked around by initializing the 'flags' variable, but it
> seems better to rework the code to avoid this.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 7ea0ed2b5be81 ("ipmi: Make the message handler easier to use for SMI interfaces")
>
> diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
> index 6b65fa4e0c55..fb0f8eacd208 100644
> --- a/drivers/char/ipmi/ipmi_msghandler.c
> +++ b/drivers/char/ipmi/ipmi_msghandler.c
> @@ -1483,14 +1483,10 @@ static inline void format_lan_msg(struct ipmi_smi_msg   *smi_msg,
>  	smi_msg->msgid = msgid;
>  }
>  
> -static void smi_send(ipmi_smi_t intf, struct ipmi_smi_handlers *handlers,
> -		     struct ipmi_smi_msg *smi_msg, int priority)
> +static struct ipmi_smi_msg *smi_add_send_msg(ipmi_smi_t intf,
> +					     struct ipmi_smi_msg *smi_msg,
> +					     int priority)
>  {
> -	int run_to_completion = intf->run_to_completion;
> -	unsigned long flags;
> -
> -	if (!run_to_completion)
> -		spin_lock_irqsave(&intf->xmit_msgs_lock, flags);
>  	if (intf->curr_msg) {
>  		if (priority > 0)
>  			list_add_tail(&smi_msg->link, &intf->hp_xmit_msgs);
> @@ -1500,8 +1496,24 @@ static void smi_send(ipmi_smi_t intf, struct ipmi_smi_handlers *handlers,
>  	} else {
>  		intf->curr_msg = smi_msg;
>  	}
> -	if (!run_to_completion)
> +
> +	return smi_msg;
> +}
> +
> +
> +static void smi_send(ipmi_smi_t intf, struct ipmi_smi_handlers *handlers,
> +		     struct ipmi_smi_msg *smi_msg, int priority)
> +{
> +	int run_to_completion = intf->run_to_completion;
> +
> +	if (run_to_completion) {
> +		smi_msg = smi_add_send_msg(intf, smi_msg, priority);
> +	} else {
> +		unsigned long flags;
> +		spin_lock_irqsave(&intf->xmit_msgs_lock, flags);
> +		smi_msg = smi_add_send_msg(intf, smi_msg, priority);
>  		spin_unlock_irqrestore(&intf->xmit_msgs_lock, flags);
> +	}
>  
>  	if (smi_msg)
>  		handlers->sender(intf->send_info, smi_msg);
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

