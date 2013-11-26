Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab3KZR0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 12:26:52 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:56678 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317Ab3KZR0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 12:26:50 -0500
Message-ID: <5294D9D8.2030305@acm.org>
Date: Tue, 26 Nov 2013 11:26:48 -0600
From: Corey Minyard <minyard@acm.org>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Srinivas_G_Gowda@Dell.com, tcminyard@gmail.com,
        linux-kernel@vger.kernel.org, openipmi@mvista.com
Subject: Re: [PATCH 1/1] ipmi: setting mod_timer for read_event_msg buffer
 cmd
References: <52931C2D.4070908@dell.com>
In-Reply-To: <52931C2D.4070908@dell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 03:51 AM, Srinivas_G_Gowda@Dell.com wrote:
> Setting up mod_timer() for IPMI_READ_EVENT_MSG_BUFFER_CMD. 
>  Driver stalls in case we hit error cases for IPMI_READ_EVENT_MSG_BUFFER_CMD.
>
> Signed-off-by: Srinivas Gowda <srinivas_g_gowda@dell.com>
> ---
>  drivers/char/ipmi/ipmi_si_intf.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
> index 15e4a60..affcc52 100644
> --- a/drivers/char/ipmi/ipmi_si_intf.c
> +++ b/drivers/char/ipmi/ipmi_si_intf.c
> @@ -843,6 +843,9 @@ static enum si_sm_result smi_event_handler(struct smi_info *smi_info,
>  		smi_info->curr_msg->data[1] = IPMI_READ_EVENT_MSG_BUFFER_CMD;
>  		smi_info->curr_msg->data_size = 2;
>  
> +		smi_info->last_timeout_jiffies = jiffies;
> +		mod_timer(&smi_info->si_timer, (jiffies + SI_TIMEOUT_JIFFIES));
> +

This change is not correct and will mess up timing.  That code is called
from a number of places and that's where the timer modification should
be done, if any are required.  I can't imagine how this change would
make a difference, but if it does, it points to a bug elsewhere in the
code (or possibly in the BMC), not here.

-corey

>  		smi_info->handlers->start_transaction(
>  			smi_info->si_sm,
>  			smi_info->curr_msg->data,

