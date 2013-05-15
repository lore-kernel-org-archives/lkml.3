Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345Ab3EOPCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 11:02:50 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:50440 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758844Ab3EOPCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 11:02:48 -0400
Message-ID: <5193A3B5.7010400@suse.cz>
Date: Wed, 15 May 2013 17:03:17 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: Add missing lock in n_tty_write()
References: <20130515105656.GI24440@8bytes.org>
In-Reply-To: <20130515105656.GI24440@8bytes.org>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2013 12:56 PM, Joerg Roedel wrote:
> The call of the tty->ops->write callback is protected by
> output_lock in all other places I looked at. So it seems the
> lock in this code-branch is missing, so take the output_lock
> there too.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Joerg Roedel <joro@8bytes.org>
> ---
>  drivers/tty/n_tty.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
> index d655416..ffb94a4 100644
> --- a/drivers/tty/n_tty.c
> +++ b/drivers/tty/n_tty.c
> @@ -2058,10 +2058,14 @@ static ssize_t n_tty_write(struct tty_struct *tty, struct file *file,
>  			if (tty->ops->flush_chars)
>  				tty->ops->flush_chars(tty);
>  		} else {
> +			struct n_tty_data *l = tty->disc_data;
> +
> +			mutex_lock(&l->output_lock);
>  			while (nr > 0) {
>  				c = tty->ops->write(tty, b, nr);
>  				if (c < 0) {
>  					retval = c;
> +					mutex_unlock(&l->output_lock);
>  					goto break_out;
>  				}
>  				if (!c)
> @@ -2069,6 +2073,7 @@ static ssize_t n_tty_write(struct tty_struct *tty, struct file *file,
>  				b += c;
>  				nr -= c;
>  			}
> +			mutex_unlock(&l->output_lock);
>  		}
>  		if (!nr)
>  			break;
> 

Are you fixing any bug here? output_lock does not protect
tty->ops->write on the other places, not tty->ops->write.

thanks,
-- 
js
suse labs
