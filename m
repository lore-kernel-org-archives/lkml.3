Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab3LBTJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:09:36 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:48728 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab3LBTJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:09:32 -0500
Date: Mon, 2 Dec 2013 11:09:29 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH v2 tty-next 1/5] tty: Always handle NULL flag ptr
Message-ID: <20131202190928.GC5245@core.coreip.homeip.net>
References: <20131122222040.GA12800@core.coreip.homeip.net>
 <1386010563-4864-1-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386010563-4864-1-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 01:56:03PM -0500, Peter Hurley wrote:
> Most line disciplines already handle the undocumented NULL flag
> ptr in their .receive_buf method; however, several don't.
> 
> Document the NULL flag ptr, and correct handling in the
> N_MOUSE, N_GSM0710 and N_R394 line disciplines.
> 
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>

For serport:

	Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Thanks.

> ---
> 
> v2 - Uses 0 for no flags to serio layer per Dmitry.
> 
>  drivers/input/serio/serport.c | 28 +++++++++++++++-------------
>  drivers/tty/n_gsm.c           |  5 +++--
>  drivers/tty/n_r3964.c         |  2 +-
>  include/linux/tty_ldisc.h     |  6 ++++--
>  4 files changed, 23 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/input/serio/serport.c b/drivers/input/serio/serport.c
> index 8755f5f..0cb7ef5 100644
> --- a/drivers/input/serio/serport.c
> +++ b/drivers/input/serio/serport.c
> @@ -124,7 +124,7 @@ static void serport_ldisc_receive(struct tty_struct *tty, const unsigned char *c
>  {
>  	struct serport *serport = (struct serport*) tty->disc_data;
>  	unsigned long flags;
> -	unsigned int ch_flags;
> +	unsigned int ch_flags = 0;
>  	int i;
>  
>  	spin_lock_irqsave(&serport->lock, flags);
> @@ -133,18 +133,20 @@ static void serport_ldisc_receive(struct tty_struct *tty, const unsigned char *c
>  		goto out;
>  
>  	for (i = 0; i < count; i++) {
> -		switch (fp[i]) {
> -		case TTY_FRAME:
> -			ch_flags = SERIO_FRAME;
> -			break;
> -
> -		case TTY_PARITY:
> -			ch_flags = SERIO_PARITY;
> -			break;
> -
> -		default:
> -			ch_flags = 0;
> -			break;
> +		if (fp) {
> +			switch (fp[i]) {
> +			case TTY_FRAME:
> +				ch_flags = SERIO_FRAME;
> +				break;
> +
> +			case TTY_PARITY:
> +				ch_flags = SERIO_PARITY;
> +				break;
> +
> +			default:
> +				ch_flags = 0;
> +				break;
> +			}
>  		}
>  
>  		serio_interrupt(serport->serio, cp[i], ch_flags);
> diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
> index c0f76da..c09db11 100644
> --- a/drivers/tty/n_gsm.c
> +++ b/drivers/tty/n_gsm.c
> @@ -2269,14 +2269,15 @@ static void gsmld_receive_buf(struct tty_struct *tty, const unsigned char *cp,
>  	char *f;
>  	int i;
>  	char buf[64];
> -	char flags;
> +	char flags = TTY_NORMAL;
>  
>  	if (debug & 4)
>  		print_hex_dump_bytes("gsmld_receive: ", DUMP_PREFIX_OFFSET,
>  				     cp, count);
>  
>  	for (i = count, dp = cp, f = fp; i; i--, dp++) {
> -		flags = *f++;
> +		if (f)
> +			flags = *f++;
>  		switch (flags) {
>  		case TTY_NORMAL:
>  			gsm->receive(gsm, *dp);
> diff --git a/drivers/tty/n_r3964.c b/drivers/tty/n_r3964.c
> index 1e64050..8b157d6 100644
> --- a/drivers/tty/n_r3964.c
> +++ b/drivers/tty/n_r3964.c
> @@ -1244,7 +1244,7 @@ static void r3964_receive_buf(struct tty_struct *tty, const unsigned char *cp,
>  {
>  	struct r3964_info *pInfo = tty->disc_data;
>  	const unsigned char *p;
> -	char *f, flags = 0;
> +	char *f, flags = TTY_NORMAL;
>  	int i;
>  
>  	for (i = count, p = cp, f = fp; i; i--, p++) {
> diff --git a/include/linux/tty_ldisc.h b/include/linux/tty_ldisc.h
> index f15c898..b8347c2 100644
> --- a/include/linux/tty_ldisc.h
> +++ b/include/linux/tty_ldisc.h
> @@ -84,7 +84,8 @@
>   *	processing.  <cp> is a pointer to the buffer of input
>   *	character received by the device.  <fp> is a pointer to a
>   *	pointer of flag bytes which indicate whether a character was
> - *	received with a parity error, etc.
> + *	received with a parity error, etc. <fp> may be NULL to indicate
> + *	all data received is TTY_NORMAL.
>   *
>   * void	(*write_wakeup)(struct tty_struct *);
>   *
> @@ -118,7 +119,8 @@
>   *	processing.  <cp> is a pointer to the buffer of input
>   *	character received by the device.  <fp> is a pointer to a
>   *	pointer of flag bytes which indicate whether a character was
> - *	received with a parity error, etc.
> + *	received with a parity error, etc. <fp> may be NULL to indicate
> + *	all data received is TTY_NORMAL.
>   *	If assigned, prefer this function for automatic flow control.
>   */
>  
> -- 
> 1.8.1.2
> 

-- 
Dmitry
