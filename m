Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933015AbbAIP3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:29:06 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:30770 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758164AbbAIP3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:29:03 -0500
Message-ID: <54AFF3BA.7090704@atmel.com>
Date: Fri, 9 Jan 2015 16:28:58 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Cyrille Pitchen <cyrille.pitchen@atmel.com>, <gregkh@linuxfoundation.org>,
        <wenyou.yang@atmel.com>, <ludovic.desroches@atmel.com>,
        <leilei.zhao@atmel.com>, <voice.shen@atmel.com>, <josh.wu@atmel.com>,
        <linux-serial@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/5] tty/serial: at91: fix error handling in atmel_serial_probe()
References: <cover.1418131298.git.cyrille.pitchen@atmel.com> <95ff85410e2f93993a4f7c5d255c4a88993fd462.1418131298.git.cyrille.pitchen@atmel.com>
In-Reply-To: <95ff85410e2f93993a4f7c5d255c4a88993fd462.1418131298.git.cyrille.pitchen@atmel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 09/12/2014 14:31, Cyrille Pitchen a écrit :
> -EDEFER error wasn't handle properly by atmel_serial_probe().
> As an example, when atmel_serial_probe() is called for the first time, we pass
> the test_and_set_bit() test to check whether the port has already been
> initalized. Then we call atmel_init_port(), which may return -EDEFER, possibly
> returned before by clk_get(). Consequently atmel_serial_probe() used to return
> this error code WITHOUT clearing the port bit in the "atmel_ports_in_use" mask.
> When atmel_serial_probe() was called for the second time, it used to fail on
> the test_and_set_bit() function then returning -EBUSY.
> 
> When atmel_serial_probe() fails, this patch make it clear the port bit in the
> "atmel_ports_in_use" mask, if needed, before returning the error code.
> 
> Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
and you can also add:
Cc: <stable@vger.kernel.org> # 3.12+

Thanks.

> ---
>  drivers/tty/serial/atmel_serial.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
> index c6621dc..92a8b26 100644
> --- a/drivers/tty/serial/atmel_serial.c
> +++ b/drivers/tty/serial/atmel_serial.c
> @@ -2565,7 +2565,7 @@ static int atmel_serial_probe(struct platform_device *pdev)
>  
>  	ret = atmel_init_port(port, pdev);
>  	if (ret)
> -		goto err;
> +		goto err_clear_bit;
>  
>  	if (!atmel_use_pdc_rx(&port->uart)) {
>  		ret = -ENOMEM;
> @@ -2628,6 +2628,8 @@ err_alloc_ring:
>  		clk_put(port->clk);
>  		port->clk = NULL;
>  	}
> +err_clear_bit:
> +	clear_bit(port->uart.line, atmel_ports_in_use);
>  err:
>  	return ret;
>  }
> 


-- 
Nicolas Ferre
