Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161455Ab3FUNie (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 09:38:34 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:45483 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161367Ab3FUNic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 09:38:32 -0400
Message-ID: <51C45754.4080401@suse.cz>
Date: Fri, 21 Jun 2013 15:38:28 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Sander Bosma <s.bosma@interay.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: n_gsm: improve software flowcontrol
References: <1371719294.8488.6.camel@virtualbox27>
In-Reply-To: <1371719294.8488.6.camel@virtualbox27>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 06/20/2013 11:08 AM, Sander Bosma wrote:
> When a channel got constipated, all messages in the messagequeue were
> still sent to the device. This can cause a bufferoverflow in some
> devices such as the SIM900 modem. This patch removes all pending
> messages belonging to the channel from the messagequeue when a
> channel gets constipated. Those messages are stored in a list within
> the DLCI. Once the channel is no longer constipated the stored
> messages are moved back into the global messagequeue. This
> significantly decreases the chance of bufferoverflows happening on
> receiving devices.
> 
> Signed-off-by: Sander Bosma <s.bosma@interay.com>
> ---
>  drivers/tty/n_gsm.c |   44 ++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 40 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
> index 4a43ef5d7..0cad08fa 100644
> --- a/drivers/tty/n_gsm.c
> +++ b/drivers/tty/n_gsm.c
...
> @@ -931,7 +933,7 @@ static void gsm_dlci_data_sweep(struct gsm_mux *gsm)
>  	int len;
>  	/* Priority ordering: We should do priority with RR of the groups */
>  	int i = 1;
> -
> +	struct tty_struct *tty;

Why did you remove the blank line here?

>  	while (i < NUM_DLCI) {
>  		struct gsm_dlci *dlci;
>  
> @@ -946,6 +948,13 @@ static void gsm_dlci_data_sweep(struct gsm_mux *gsm)
>  			len = gsm_dlci_data_output(gsm, dlci);
>  		else
>  			len = gsm_dlci_data_output_framed(gsm, dlci);
> +
> +		if (len >= 0) {
> +			tty = tty_port_tty_get(&dlci->port);
> +			if (tty)
> +				tty_wakeup(dlci->port.tty);
> +		}

This is incorrect. You leak a tty. And this should be
tty_port_tty_wakeup anyway.

But please also document addition of wakeup in the commit log.

>  		if (len < 0)
>  			break;
>  		/* DLCI empty - try the next */
> @@ -1029,7 +1038,8 @@ static void gsm_process_modem(struct tty_struct *tty, struct gsm_dlci *dlci,
>  	int  mlines = 0;
>  	u8 brk = 0;
>  	int fc;
> -
> +	struct gsm_msg *msg, *nmsg;
> +	unsigned long flags;

Again removed blank line?

>  	/* The modem status command can either contain one octet (v.24 signals)
>  	   or two octets (v.24 signals + break signals). The length field will
>  	   either be 2 or 3 respectively. This is specified in section
> @@ -1047,8 +1057,27 @@ static void gsm_process_modem(struct tty_struct *tty, struct gsm_dlci *dlci,
>  	if (fc && !dlci->constipated) {
>  		/* Need to throttle our output on this device */
>  		dlci->constipated = 1;
> +		spin_lock_irqsave(&dlci->gsm->tx_lock, flags);
> +		list_for_each_entry_safe(msg, nmsg, &dlci->gsm->tx_list, list) {
> +			list_del(&msg->list);	/* remove from msgqueue */
> +			/* add to list of messages which could not be sent
> +			   because of constipation */
> +			list_add_tail(&msg->list, &dlci->constipated_list);

list_move_tail...

> +			dlci->gsm->tx_bytes -= msg->len;
> +		}
> +		spin_unlock_irqrestore(&dlci->gsm->tx_lock, flags);
> +
>  	} else if (!fc && dlci->constipated) {
>  		dlci->constipated = 0;
> +		spin_lock_irqsave(&dlci->gsm->tx_lock, flags);
> +		list_for_each_entry_safe(msg, nmsg, &dlci->constipated_list,
> +					 list) {
> +			list_del(&msg->list);	/* remove from msgqueue */
> +			/* add to global messagequeue */
> +			list_add_tail(&msg->list,  &dlci->gsm->tx_list);

Here too.

> +			dlci->gsm->tx_bytes += msg->len;
> +		}
> +		spin_unlock_irqrestore(&dlci->gsm->tx_lock, flags);
>  		gsm_dlci_data_kick(dlci);
>  	}
>  
...
> @@ -2956,7 +2986,7 @@ static void gsmtty_close(struct tty_struct *tty, struct file *filp)
>  {
>  	struct gsm_dlci *dlci = tty->driver_data;
>  	struct gsm_mux *gsm;
> -
> +	struct gsm_msg *msg, *nmsg;

blank.

thanks,
-- 
js
suse labs
