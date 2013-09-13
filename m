Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab3IMSpd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 14:45:33 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:52922 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab3IMSpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 14:45:31 -0400
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9Dbc7nsXB+5knFuK6YxiM=
X-RZG-CLASS-ID: mo00
Message-ID: <52335D49.1000105@hartkopp.net>
Date: Fri, 13 Sep 2013 20:45:29 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130820 Icedove/17.0.8
MIME-Version: 1.0
To: Andre Naujoks <nautsch2@gmail.com>
CC: davem@davemloft.net, Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/3] slip/slcan: added locking in wakeup function
References: <1379093833-4949-1-git-send-email-nautsch2@gmail.com> <1379093833-4949-2-git-send-email-nautsch2@gmail.com>
In-Reply-To: <1379093833-4949-2-git-send-email-nautsch2@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.09.2013 19:37, Andre Naujoks wrote:
> The locking is needed, since the the internal buffer for the CAN frames is
> changed during the wakeup call. This could cause buffer inconsistencies
> under high loads, especially for the outgoing short CAN packet skbuffs.
> 
> The needed locks led to deadlocks before commit
> "5ede52538ee2b2202d9dff5b06c33bfde421e6e4 tty: Remove extra wakeup from pty
> write() path", which removed the direct callback to the wakeup function from the
> tty layer.
> 
> As slcan.c is based on slip.c the issue in the original code is fixed, too.
> 
> Signed-off-by: Andre Naujoks <nautsch2@gmail.com>

At least for slcan.c:

Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>

Tnx for figuring that out with your heavy load testing.

Best regards,
Oliver

> ---
>  drivers/net/can/slcan.c | 3 +++
>  drivers/net/slip/slip.c | 3 +++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
> index 874188b..d571e2e 100644
> --- a/drivers/net/can/slcan.c
> +++ b/drivers/net/can/slcan.c
> @@ -286,11 +286,13 @@ static void slcan_write_wakeup(struct tty_struct *tty)
>  	if (!sl || sl->magic != SLCAN_MAGIC || !netif_running(sl->dev))
>  		return;
>  
> +	spin_lock(&sl->lock);
>  	if (sl->xleft <= 0)  {
>  		/* Now serial buffer is almost free & we can start
>  		 * transmission of another packet */
>  		sl->dev->stats.tx_packets++;
>  		clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
> +		spin_unlock(&sl->lock);
>  		netif_wake_queue(sl->dev);
>  		return;
>  	}
> @@ -298,6 +300,7 @@ static void slcan_write_wakeup(struct tty_struct *tty)
>  	actual = tty->ops->write(tty, sl->xhead, sl->xleft);
>  	sl->xleft -= actual;
>  	sl->xhead += actual;
> +	spin_unlock(&sl->lock);
>  }
>  
>  /* Send a can_frame to a TTY queue. */
> diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
> index a34d6bf..cc70ecf 100644
> --- a/drivers/net/slip/slip.c
> +++ b/drivers/net/slip/slip.c
> @@ -429,11 +429,13 @@ static void slip_write_wakeup(struct tty_struct *tty)
>  	if (!sl || sl->magic != SLIP_MAGIC || !netif_running(sl->dev))
>  		return;
>  
> +	spin_lock(&sl->lock);
>  	if (sl->xleft <= 0)  {
>  		/* Now serial buffer is almost free & we can start
>  		 * transmission of another packet */
>  		sl->dev->stats.tx_packets++;
>  		clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
> +		spin_unlock(&sl->lock);
>  		sl_unlock(sl);
>  		return;
>  	}
> @@ -441,6 +443,7 @@ static void slip_write_wakeup(struct tty_struct *tty)
>  	actual = tty->ops->write(tty, sl->xhead, sl->xleft);
>  	sl->xleft -= actual;
>  	sl->xhead += actual;
> +	spin_unlock(&sl->lock);
>  }
>  
>  static void sl_tx_timeout(struct net_device *dev)
> 

