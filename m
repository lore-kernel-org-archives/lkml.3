Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbaFQIGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 04:06:33 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:36914 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbaFQIGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 04:06:30 -0400
Message-ID: <539FF702.7060204@gmail.com>
Date: Tue, 17 Jun 2014 10:06:26 +0200
From: Andre Naujoks <nautsch2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:30.0) Gecko/20100101 Icedove/30.0
MIME-Version: 1.0
To: Tyler Hall <tylerwhall@gmail.com>, netdev@vger.kernel.org
CC: Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] slcan: Port write_wakeup deadlock fix from slip
References: <1402885397-21062-1-git-send-email-tylerwhall@gmail.com> <1402885397-21062-2-git-send-email-tylerwhall@gmail.com>
In-Reply-To: <1402885397-21062-2-git-send-email-tylerwhall@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.06.2014 04:23, schrieb Tyler Hall:
> The commit "slip: Fix deadlock in write_wakeup" fixes a deadlock caused
> by a change made in both slcan and slip. This is a direct port of that
> fix.

I don't know if it is still needed, but for the slcan part, you can add my:

Tested-by: Andre Naujoks <nautsch2@gmail.com>

Regards
  Andre

> 
> Signed-off-by: Tyler Hall <tylerwhall@gmail.com>
> Cc: Oliver Hartkopp <socketcan@hartkopp.net>
> Cc: Andre Naujoks <nautsch2@gmail.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/net/can/slcan.c | 37 +++++++++++++++++++++++++++----------
>  1 file changed, 27 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
> index dcf9196..ea4d4f1 100644
> --- a/drivers/net/can/slcan.c
> +++ b/drivers/net/can/slcan.c
> @@ -52,6 +52,7 @@
>  #include <linux/delay.h>
>  #include <linux/init.h>
>  #include <linux/kernel.h>
> +#include <linux/workqueue.h>
>  #include <linux/can.h>
>  #include <linux/can/skb.h>
>  
> @@ -85,6 +86,7 @@ struct slcan {
>  	struct tty_struct	*tty;		/* ptr to TTY structure	     */
>  	struct net_device	*dev;		/* easy for intr handling    */
>  	spinlock_t		lock;
> +	struct work_struct	tx_work;	/* Flushes transmit buffer   */
>  
>  	/* These are pointers to the malloc()ed frame buffers. */
>  	unsigned char		rbuff[SLC_MTU];	/* receiver buffer	     */
> @@ -309,36 +311,46 @@ static void slc_encaps(struct slcan *sl, struct can_frame *cf)
>  	sl->dev->stats.tx_bytes += cf->can_dlc;
>  }
>  
> -/*
> - * Called by the driver when there's room for more data.  If we have
> - * more packets to send, we send them here.
> - */
> -static void slcan_write_wakeup(struct tty_struct *tty)
> +/* Write out any remaining transmit buffer. Scheduled when tty is writable */
> +static void slcan_transmit(struct work_struct *work)
>  {
> +	struct slcan *sl = container_of(work, struct slcan, tx_work);
>  	int actual;
> -	struct slcan *sl = (struct slcan *) tty->disc_data;
>  
> +	spin_lock_bh(&sl->lock);
>  	/* First make sure we're connected. */
> -	if (!sl || sl->magic != SLCAN_MAGIC || !netif_running(sl->dev))
> +	if (!sl->tty || sl->magic != SLCAN_MAGIC || !netif_running(sl->dev)) {
> +		spin_unlock_bh(&sl->lock);
>  		return;
> +	}
>  
> -	spin_lock_bh(&sl->lock);
>  	if (sl->xleft <= 0)  {
>  		/* Now serial buffer is almost free & we can start
>  		 * transmission of another packet */
>  		sl->dev->stats.tx_packets++;
> -		clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
> +		clear_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
>  		spin_unlock_bh(&sl->lock);
>  		netif_wake_queue(sl->dev);
>  		return;
>  	}
>  
> -	actual = tty->ops->write(tty, sl->xhead, sl->xleft);
> +	actual = sl->tty->ops->write(sl->tty, sl->xhead, sl->xleft);
>  	sl->xleft -= actual;
>  	sl->xhead += actual;
>  	spin_unlock_bh(&sl->lock);
>  }
>  
> +/*
> + * Called by the driver when there's room for more data.
> + * Schedule the transmit.
> + */
> +static void slcan_write_wakeup(struct tty_struct *tty)
> +{
> +	struct slcan *sl = tty->disc_data;
> +
> +	schedule_work(&sl->tx_work);
> +}
> +
>  /* Send a can_frame to a TTY queue. */
>  static netdev_tx_t slc_xmit(struct sk_buff *skb, struct net_device *dev)
>  {
> @@ -528,6 +540,7 @@ static struct slcan *slc_alloc(dev_t line)
>  	sl->magic = SLCAN_MAGIC;
>  	sl->dev	= dev;
>  	spin_lock_init(&sl->lock);
> +	INIT_WORK(&sl->tx_work, slcan_transmit);
>  	slcan_devs[i] = dev;
>  
>  	return sl;
> @@ -626,8 +639,12 @@ static void slcan_close(struct tty_struct *tty)
>  	if (!sl || sl->magic != SLCAN_MAGIC || sl->tty != tty)
>  		return;
>  
> +	spin_lock_bh(&sl->lock);
>  	tty->disc_data = NULL;
>  	sl->tty = NULL;
> +	spin_unlock_bh(&sl->lock);
> +
> +	flush_work(&sl->tx_work);
>  
>  	/* Flush network side */
>  	unregister_netdev(sl->dev);
> 

