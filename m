Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392Ab3JNODI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 10:03:08 -0400
Received: from 17.mo3.mail-out.ovh.net ([87.98.178.58]:51807 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756048Ab3JNODG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 10:03:06 -0400
X-Greylist: delayed 322 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Oct 2013 10:03:06 EDT
Date: Mon, 14 Oct 2013 15:58:09 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josh Wu <josh.wu@atmel.com>, Bo Shen <voice.shen@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tty/serial: at91: fix uart/usart selection for older
 products
Message-ID: <20131014135809.GF11420@ns203013.ovh.net>
References: <a58fe8bc7fdd128a2f9cf60785f81ebde4c0c247.1381394411.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a58fe8bc7fdd128a2f9cf60785f81ebde4c0c247.1381394411.git.nicolas.ferre@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 17930237492734634860
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrvdejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrvdejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:43 Thu 10 Oct     , Nicolas Ferre wrote:
> Since commit 055560b04a8cd063aea916fd083b7aec02c2adb8 (serial: at91:
> distinguish usart and uart) the older products which do not have a
> name field in their register map are unable to use their serial output.
> As the main console output is usually the serial interface (aka DBGU) it
> is pretty unfortunate.
> So, instead of failing during probe() we just silently configure the serial
> peripheral as an uart. It allows us to use these serial outputs.
> The proper solution is proposed in another patch.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  drivers/tty/serial/atmel_serial.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
> index d067285..6b0f75e 100644
> --- a/drivers/tty/serial/atmel_serial.c
> +++ b/drivers/tty/serial/atmel_serial.c
> @@ -1499,7 +1499,7 @@ static void atmel_set_ops(struct uart_port *port)
>  /*
>   * Get ip name usart or uart
>   */
> -static int atmel_get_ip_name(struct uart_port *port)
> +static void atmel_get_ip_name(struct uart_port *port)
>  {
>  	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
>  	int name = UART_GET_IP_NAME(port);
> @@ -1518,10 +1518,7 @@ static int atmel_get_ip_name(struct uart_port *port)
>  		atmel_port->is_usart = false;
>  	} else {
		a dev_warn here maybe

usefull to known when we will have a new ip name and not yet wupported

Best Regards,
J.
>  		dev_err(port->dev, "Not supported ip name, set to uart\n");
> -		return -EINVAL;
>  	}
> -
> -	return 0;
>  }
>  
>  /*
> @@ -2405,9 +2402,7 @@ static int atmel_serial_probe(struct platform_device *pdev)
>  	/*
>  	 * Get port name of usart or uart
>  	 */
> -	ret = atmel_get_ip_name(&port->uart);
> -	if (ret < 0)
> -		goto err_add_port;
> +	atmel_get_ip_name(&port->uart);
>  
>  	return 0;
>  
> -- 
> 1.8.2.2
> 
