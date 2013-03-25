Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915Ab3CYUgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 16:36:47 -0400
Received: from tex.lwn.net ([70.33.254.29]:41389 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758299Ab3CYUgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 16:36:45 -0400
X-Greylist: delayed 1688 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Mar 2013 16:36:45 EDT
Date: Mon, 25 Mar 2013 14:08:35 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Joseph CHANG <josright123@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Matthew Leach <matthew@mattleach.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joseph CHANG <joseph_chang@davicom.com.tw>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ethernet driver: dm9000: davicom: Upgrade the
 driver to suit for all DM9000 series chips
Message-ID: <20130325140835.115bf6ab@lwn.net>
In-Reply-To: <1364198682-1589-1-git-send-email-josright123@gmail.com>
References: <1364198682-1589-1-git-send-email-josright123@gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Mar 2013 16:04:42 +0800
Joseph CHANG <josright123@gmail.com> wrote:

> From: Joseph CHANG <joseph_chang@davicom.com.tw>
> 
> Some necessary modification for DM9000 series chips to be better in operation!

Interesting, this had been sent to me privately at about the same time.
For the record, here's what I sent back:

From: Jonathan Corbet <corbet@lwn.net>
To: Allen Huang (黃偉格) <allen_huang@davicom.com.tw>
Subject: Re: Davicom Linux driver
Date: Mon, 25 Mar 2013 09:55:48 -0600
Organization: LWN.net

On Mon, 25 Mar 2013 18:31:35 +0800
Allen Huang (黃偉格) <allen_huang@davicom.com.tw> wrote:

> Please see our Linux Patch in the attachment and we would appreciate any
> comments that you have on our driver and/or whether it is ready to go into
> the kernel. Thanks.   

I'll take a quick look at it.  But the only true way to know whether it's
ready, of course, is to post it to the public lists.

> Some necessary modification for DM9000 series chips to be better in operation!  

The patch will be better received if you say what "better in operation"
actually means.  Are you supporting new hardware, adding new features,
fixing bugs?  Hopefully not more than one of those in a single patch.

> Had tested to all of DM9000 series chips, include DM9000E, DM9000A, DM9000B,
> and DM9000C in X86 and ARM embedded Linux system these years.
> 
> Signed-off-by: Joseph CHANG <joseph_chang@davicom.com.tw>
> ---
>  drivers/net/ethernet/davicom/dm9000.c |   28 +++++++++++++++++++++++-----
>  drivers/net/ethernet/davicom/dm9000.h |    4 +++-
>  2 files changed, 26 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
> index 8cdf025..54bdc92 100644
> --- a/drivers/net/ethernet/davicom/dm9000.c
> +++ b/drivers/net/ethernet/davicom/dm9000.c
> @@ -47,7 +47,8 @@
>  #define DM9000_PHY		0x40	/* PHY address 0x01 */
>  
>  #define CARDNAME	"dm9000"
> -#define DRV_VERSION	"1.31"
> +/* [KERN-ADD-1](upgrade) */  

I would lose the [KERN-ADD*] comments, those will certainly draw some
grumbling when the patch is posted publicly.  They don't add any value; the
repository will show which changes were made when.

> +#define DRV_VERSION	"1.39"
>  
>  /*
>   * Transmit timeout, default 5 seconds.
> @@ -671,10 +672,16 @@ dm9000_poll_work(struct work_struct *w)
>  			if (netif_msg_link(db))
>  				dm9000_show_carrier(db, new_carrier, nsr);
>  
> -			if (!new_carrier)
> +			/* [KERN-ADD-2] */
> +			if (!new_carrier) {
>  				netif_carrier_off(ndev);
> -			else
> +				netdev_info(ndev, "[%s Ethernet Driver, V%s]: Link-Down!!\n",
> +					CARDNAME, DRV_VERSION);
> +			} else {
>  				netif_carrier_on(ndev);
> +				netdev_info(ndev, "[%s Ethernet Driver, V%s]: Link-Up!!\n",
> +					CARDNAME, DRV_VERSION);
> +			}  

So "better in operation" means more log messages?  This, too, will likely
draw complaints.  That could be a lot of log messages!  The additional
information is also probably unnecessary, netdev_info() should print the
relevant device information.

>  		}
>  	} else
>  		mii_check_media(&db->mii, netif_msg_link(db), 0);
> @@ -794,6 +801,9 @@ dm9000_init_dm9000(struct net_device *dev)
>  			(dev->features & NETIF_F_RXCSUM) ? RCSR_CSUM : 0);
>  
>  	iow(db, DM9000_GPCR, GPCR_GEP_CNTL);	/* Let GPIO0 output */
> +    /* [KERN-ADD-3] */
> +	dm9000_phy_write(dev, 0, 0, 0x8000); /* reset PHY */
> +	mdelay(2);  

Magic constants aren't good, you can't define a symbol for that?

dm900_poll_work() is a workqueue function, right?  So it can sleep.  So you
should almost certainly use msleep() rather than mdelay().

>  	ncr = (db->flags & DM9000_PLATF_EXT_PHY) ? NCR_EXT_PHY : 0;
>  
> @@ -830,6 +840,8 @@ dm9000_init_dm9000(struct net_device *dev)
>  	db->tx_pkt_cnt = 0;
>  	db->queue_pkt_len = 0;
>  	dev->trans_start = jiffies;
> +    /* [KERN-ADD-4]	*/
> +	dm9000_phy_write(dev, 0, 27, 0xE100);  

Again, can we avoid the magic constants?

>  }
>  
>  /* Our watchdog timed out. Called by the networking layer */
> @@ -1181,7 +1193,8 @@ dm9000_open(struct net_device *dev)
>  
>  	/* GPIO0 on pre-activate PHY, Reg 1F is not set by reset */
>  	iow(db, DM9000_GPR, 0);	/* REG_1F bit0 activate phyxcer */
> -	mdelay(1); /* delay needs by DM9000B */
> +	/* [KERN-ADD-5](Enable PHY) */
> +	mdelay(2); /* delay needs by DM9000B */  

You say "Enable PHY" but I see no change that does that?
Again, msleep() would be better here - an open function can certainly
sleep! 

>  	/* Initialize DM9000 board */
>  	dm9000_reset(db);
> @@ -1311,6 +1324,8 @@ dm9000_shutdown(struct net_device *dev)
>  
>  	/* RESET device */
>  	dm9000_phy_write(dev, 0, MII_BMCR, BMCR_RESET);	/* PHY RESET */
> +    /* [KERN-ADD-6](NOTICE)(by)("if (!db->wake_state) ..") */
> +    /* iow(db, DM9000_GPR, 0x01); */
>  	iow(db, DM9000_GPR, 0x01);	/* Power-Down PHY */  

What is the purpose of this change?

>  	iow(db, DM9000_IMR, IMR_PAR);	/* Disable all interrupt */
>  	iow(db, DM9000_RCR, 0x00);	/* Disable RX */
> @@ -1465,6 +1480,8 @@ dm9000_probe(struct platform_device *pdev)
>  	/* fill in parameters for net-dev structure */
>  	ndev->base_addr = (unsigned long)db->io_addr;
>  	ndev->irq	= db->irq_res->start;
> +    /* [KERN-ADD-7] */
> +	netdev_info(ndev, "[dm9] %s ndev->irq=%x\n", __func__, ndev->irq);  

That should be unnecessary; that information is available in
/proc/interrupts, and probably via ethtool too.

>  	/* ensure at least we have a default set of IO routines */
>  	dm9000_set_io(db, iosize);
> @@ -1502,7 +1519,8 @@ dm9000_probe(struct platform_device *pdev)
>  	db->flags |= DM9000_PLATF_SIMPLE_PHY;
>  #endif
>  
> -	dm9000_reset(db);
> +    /* [KERN-ADD-8](SPECIAL WHEN INIT_OF_PROBE)[takeover"dm9000_reset(db)"] */
> +	iow(db, DM9000_NCR, NCR_MAC_LBK | NCR_RST); /* 0x03 */  

What is accomplished by this change?  Should it maybe be a parameter to
dm9000_reset()?

>  	/* try multiple times, DM9000 sometimes gets the read wrong */
>  	for (i = 0; i < 8; i++) {
> diff --git a/drivers/net/ethernet/davicom/dm9000.h b/drivers/net/ethernet/davicom/dm9000.h
> index 55688bd..d644506 100644
> --- a/drivers/net/ethernet/davicom/dm9000.h
> +++ b/drivers/net/ethernet/davicom/dm9000.h
> @@ -69,7 +69,9 @@
>  #define NCR_WAKEEN          (1<<6)
>  #define NCR_FCOL            (1<<4)
>  #define NCR_FDX             (1<<3)
> -#define NCR_LBK             (3<<1)
> +
> +#define NCR_RESERVED        (3<<1)
> +#define NCR_MAC_LBK         (1<<1) /* [kern-add-0] */
>  #define NCR_RST	            (1<<0)
>  
>  #define NSR_SPEED           (1<<7)
> -- 
> 1.7.1
>   
Hope that helps,

jon
