Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbaINDDc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 23:03:32 -0400
Received: from senator.holtmann.net ([87.106.208.187]:35038 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbaINDDb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 23:03:31 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 001/001] IEEE 802.15.4: Add module parameter to mrf24j40 to allow use of external transmitters/receivers
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <5414F163.6010309@componentsw.com>
Date: Sat, 13 Sep 2014 20:04:16 -0700
Cc: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-zigbee-devel@lists.sourceforge.net,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <F63BBAD1-8BEF-4CDB-8BD6-962AE400CA8E@holtmann.org>
References: <5414F163.6010309@componentsw.com>
To: Walter Mack <wmack@componentsw.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Walter,

> enhance module drivers/net/ieee802154/mrf24j40.c to allow designs that use external transmitters/receivers.
> 
> Designs that use Microchip's MRF24J40 with external receivers and transmitters require the chip to
> be specifically programmed for this, by setting the "test mode register" to 0xf.
> 
> In my testing, without this flag, I could only receive over a distance of a few feet. Setting this flag allows
> distances well above 100 feet.
> 
> The patch adds a module parameter module_param(ext_rx_tx, bool, 0). When setting the parameter to true,
> the driver configures the "test mode" register of the mrf24j40 device to work with external tranmitters and receivers.
> 
> patch applies to kernel version:3.16.0-rc4csi-git-dirty, git: commit cd3de83f147601356395b57a8673e9c5ff1e59d1
> 
> (I'm doing a patch submission the first time. If I'm doing this wrong, I would appreciate feedback for how to do this better next time).

comments do not belong in the commit message. And please send patches for IEEE 802.15.4 drivers to linux-wpan@vger.kernel.org mailing list.


> Signed-off-by: Walter J. Mack <wmack@componentsw.com>
> 
> ---
> diff --git a/drivers/net/ieee802154/mrf24j40.c b/drivers/net/ieee802154/mrf24j40.c
> index 4048062..18cff47 100644
> --- a/drivers/net/ieee802154/mrf24j40.c
> +++ b/drivers/net/ieee802154/mrf24j40.c
> @@ -26,6 +26,10 @@
> #include <net/mac802154.h>
> #include <net/ieee802154.h>
> 
> +static bool ext_rx_tx = false ;

please fix the coding style here and not need for variable initialization.

> +module_param(ext_rx_tx, bool, 0);

The last parameter is the mode. You might want to use 0444 here at least.

> +MODULE_PARM_DESC(ext_rx_tx, " turn on statemachine to manage external tx/rx");
> +
> /* MRF24J40 Short Address Registers */
> #define REG_RXMCR    0x00  /* Receive MAC control */
> #define REG_PANIDL   0x01  /* PAN ID (low) */
> @@ -63,6 +67,8 @@
> #define REG_SLPCON1    0x220
> #define REG_WAKETIMEL  0x222  /* Wake-up Time Match Value Low */
> #define REG_WAKETIMEH  0x223  /* Wake-up Time Match Value High */
> +#define REG_TESTMODE   0x22f  /* test mode and state machine control register */
> +
> #define REG_RX_FIFO    0x300  /* Receive FIFO */
> 
> /* Device configuration: Only channels 11-26 on page 0 are supported. */
> @@ -669,6 +675,10 @@ static int mrf24j40_probe(struct spi_device *spi)
>     write_short_reg(devrec, REG_RFCTL, 0x0);
>     udelay(192);
> 
> +    if ( false != ext_rx_tx ){
> +      write_long_reg(devrec, REG_TESTMODE, 0x0f);
> +    }
> +

You need to read the coding style document and follow it.

>     /* Set RX Mode. RXMCR<1:0>: 0x0 normal, 0x1 promisc, 0x2 error */
>     ret = read_short_reg(devrec, REG_RXMCR, &val);
>     if (ret)

Regards

Marcel

