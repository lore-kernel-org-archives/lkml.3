Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbaLAUA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 15:00:59 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:50257 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932101AbaLAUA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 15:00:57 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19CygfAHREgtSHylzsIUXYL
Date: Mon, 1 Dec 2014 11:58:42 -0800
From: Tony Lindgren <tony@atomide.com>
To: Alexander Kochetkov <al.kochet@gmail.com>
Cc: Kevin Hilman <khilman@kernel.org>, Felipe Balbi <balbi@ti.com>,
        Wolfram Sang <wsa@the-dreams.de>, linux-omap@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/2] i2c: omap: fix buffer overruns during RX/TX data
 processing
Message-ID: <20141201195841.GD2817@atomide.com>
References: <1417294803-14729-1-git-send-email-al.kochet@gmail.com>
 <1417294803-14729-2-git-send-email-al.kochet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417294803-14729-2-git-send-email-al.kochet@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alexander Kochetkov <al.kochet@gmail.com> [141129 13:02]:
> commit dd74548ddece4b9d68e5528287a272fa552c81d0 ("i2c: omap:
> resize fifos before each message") dropped check for dev->buf_len.
> As result, data processing loop cause dev->buf overruns for
> devices with 16-bit data register (omap2420).
> 
> In the dd74548ddece4b9d68 code, for each loop iteration if the
> flag OMAP_I2C_FLAG_16BIT_DATA_REG is set (omap2420), dev->buf
> is incremented twice, and dev->buf_len decremented twice.
> 
> Also buffer overrun could happen (in theory) due to wrong
> ISR handling (bug).
> 
> The commit fix data processing for omap2420 and add guard checks
> in the data processing loops do disallow accesses to the buffer,
> when dev->buf_len is zero. Also added warnings to unhide the bug.
> 
> Found by code review.
> 
> Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>
> Fixes: dd74548ddece4b9d68e5528287a272fa552c81d0 "i2c: omap: resize fifos before each message"
> Reported-by: Tony Lindgren <tony@atomide.com>

I think this is a different issue than what I'm seeing.

Not sure if I've seen what you're describing.. The $subject patch
should be reviewed by Felipe and Aaro, but this does not help
things on 2430.

Regards,

Tony


>  drivers/i2c/busses/i2c-omap.c |   36 ++++++++++++++++++++++++++++--------
>  1 file changed, 28 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
> index 4563200..e890295 100644
> --- a/drivers/i2c/busses/i2c-omap.c
> +++ b/drivers/i2c/busses/i2c-omap.c
> @@ -938,20 +938,30 @@ static int errata_omap3_i462(struct omap_i2c_dev *dev)
>  static void omap_i2c_receive_data(struct omap_i2c_dev *dev, u8 num_bytes,
>  		bool is_rdr)
>  {
> -	u16		w;
> +	u16 w;
> +
> +	if (unlikely(num_bytes > dev->buf_len)) {
> +		dev_err(dev->dev, "%s interrupt can't receive %u byte(s)\n",
> +			is_rdr ? "RDR" : "RRDY", (num_bytes - dev->buf_len));
> +		num_bytes = dev->buf_len;
> +	}
>  
> -	while (num_bytes--) {
> +	while (num_bytes) {
>  		w = omap_i2c_read_reg(dev, OMAP_I2C_DATA_REG);
>  		*dev->buf++ = w;
>  		dev->buf_len--;
> +		num_bytes--;
>  
>  		/*
>  		 * Data reg in 2430, omap3 and
>  		 * omap4 is 8 bit wide
>  		 */
>  		if (dev->flags & OMAP_I2C_FLAG_16BIT_DATA_REG) {
> -			*dev->buf++ = w >> 8;
> -			dev->buf_len--;
> +			if (num_bytes) {
> +				*dev->buf++ = w >> 8;
> +				dev->buf_len--;
> +				num_bytes--;
> +			}
>  		}
>  	}
>  }
> @@ -959,19 +969,29 @@ static void omap_i2c_receive_data(struct omap_i2c_dev *dev, u8 num_bytes,
>  static int omap_i2c_transmit_data(struct omap_i2c_dev *dev, u8 num_bytes,
>  		bool is_xdr)
>  {
> -	u16		w;
> +	u16 w;
> +
> +	if (unlikely(num_bytes > dev->buf_len)) {
> +		dev_err(dev->dev, "%s interrupt can't transmit %u byte(s)\n",
> +			is_xdr ? "XDR" : "XRDY", (num_bytes - dev->buf_len));
> +		num_bytes = dev->buf_len;
> +	}
>  
> -	while (num_bytes--) {
> +	while (num_bytes) {
>  		w = *dev->buf++;
>  		dev->buf_len--;
> +		num_bytes--;
>  
>  		/*
>  		 * Data reg in 2430, omap3 and
>  		 * omap4 is 8 bit wide
>  		 */
>  		if (dev->flags & OMAP_I2C_FLAG_16BIT_DATA_REG) {
> -			w |= *dev->buf++ << 8;
> -			dev->buf_len--;
> +			if (num_bytes) {
> +				w |= *dev->buf++ << 8;
> +				dev->buf_len--;
> +				num_bytes--;
> +			}
>  		}
>  
>  		if (dev->errata & I2C_OMAP_ERRATA_I462) {
> -- 
> 1.7.9.5
> 
