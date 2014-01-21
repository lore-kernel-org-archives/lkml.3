Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbaAUOza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 09:55:30 -0500
Received: from gloria.sntech.de ([95.129.55.99]:49439 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606AbaAUOz2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 09:55:28 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Chander Kashyap <chander.kashyap@linaro.org>
Subject: Re: [PATCH] serial: samsung: move clock deactivation below uart registration
Date: Tue, 21 Jan 2014 15:26:42 +0100
Message-ID: <2813762.7GxfVBIcrq@phil>
User-Agent: KMail/4.11.3 (Linux/3.11-2-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <201312050054.39327.heiko@sntech.de>
References: <201312050054.39327.heiko@sntech.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

just wanted to ask about the state of this patch. I can see it in your branch 
named "fixes" [0] but it seems it hasn't made its way into the kernel neither 
during the 3.13-rcs or with your 3.14-pull [1].


Thanks
Heiko


[0] https://git.kernel.org/cgit/linux/kernel/git/gregkh/tty.git/log/?h=fixes
[1] 
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=bcee63488ece9a0fca8be19951428a7b41001e66


Am Donnerstag, 5. Dezember 2013, 00:54:38 schrieb Heiko Stübner:
> Commit 60e93575476f (serial: samsung: enable clock before clearing pending
> interrupts during init) added handling of the controller clock during init.
> 
> On most systems this clock is also one of the baud_clock sources and
> possibly used by the earlycon and thus already enabled by the bootloader.
> 
> Therefore a gap exists between s3c24xx_serial_init_port disabling the
> clock and an attached console reenabling it, making the transition from
> earlycon to regular console possibly hang the system - as seen on my
> S3C2442 based Freerunner today.
> 
> Therefore move the disabling of the clock from s3c24xx_serial_init_port
> below the uart port registration, effectively creating an overlap and
> keeping the clock running non-stop if the console wants to grab this port.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> ---
>  drivers/tty/serial/samsung.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
> index c1af04d..9cd706d 100644
> --- a/drivers/tty/serial/samsung.c
> +++ b/drivers/tty/serial/samsung.c
> @@ -1209,7 +1209,6 @@ static int s3c24xx_serial_init_port(struct
> s3c24xx_uart_port *ourport,
> 
>  	/* reset the fifos (and setup the uart) */
>  	s3c24xx_serial_resetport(port, cfg);
> -	clk_disable_unprepare(ourport->clk);
>  	return 0;
>  }
> 
> @@ -1287,6 +1286,13 @@ static int s3c24xx_serial_probe(struct
> platform_device *pdev) uart_add_one_port(&s3c24xx_uart_drv,
> &ourport->port);
>  	platform_set_drvdata(pdev, &ourport->port);
> 
> +	/*
> +	 * Deactivate the clock enabled in s3c24xx_serial_init_port here,
> +	 * so that a potential re-enablement through the pm-callback overlaps
> +	 * and keeps the clock enabled in this case.
> +	 */
> +	clk_disable_unprepare(ourport->clk);
> +
>  #ifdef CONFIG_SAMSUNG_CLOCK
>  	ret = device_create_file(&pdev->dev, &dev_attr_clock_source);
>  	if (ret < 0)

