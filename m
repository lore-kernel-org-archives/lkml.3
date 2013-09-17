Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab3IQKTC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 06:19:02 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:54689 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab3IQKTA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 06:19:00 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-86-52382c92b55c
From: Tomasz Figa <t.figa@samsung.com>
To: =?ISO-8859-1?Q?Jos=E9_Miguel_Gon=E7alves?= <jose.goncalves@inov.pt>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] serial: samsung: add support for manual RTS setting
Date: Tue, 17 Sep 2013 12:18:50 +0200
Message-id: <35383907.gKXZyKLrYq@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11 (Linux/3.10.10-gentoo; KDE/4.11.0; x86_64; ; )
In-reply-to: <1378894107-7904-1-git-send-email-jose.goncalves@inov.pt>
References: <1378894107-7904-1-git-send-email-jose.goncalves@inov.pt>
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=iso-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t/xy7qTdCyCDH6fErH42LSWyeLyrjls
	FjPO72OyOLO4l92BxePx9rtMHp83yQUwRXHZpKTmZJalFunbJXBldF4/wVywRKTiyO6rLA2M
	zwS6GDk5JARMJB4eusEIYYtJXLi3ng3EFhJYyiix92o4hN3FJNEysRTEZhNQk/jc8AisRkTA
	XWLKjPVgvcwCyRK9f74DxTk4hAU8JFZfTAEJswioSny/3A9WziugJTHnznewcn4BdYl3254y
	gdiiAq4SnxZuZAexOQXcJLqXfGKGWOsqMXnLFWaIXkGJH5PvsUCs0pZ48u4CK4StI9H7/Rvz
	BEbBWUjKZiEpm4WkbAEj8ypG0dTS5ILipPRcI73ixNzi0rx0veT83E2MkOD9uoNx6TGrQ4wC
	HIxKPLw/lM2DhFgTy4orcw8xSnAwK4nwhrJYBAnxpiRWVqUW5ccXleakFh9iZOLglGpg9D+z
	I8x9iVhaxL/JZ7xvua1dGB52TG/lJNsGC67zpnn3LuTwN9heOLltYxxf9AlhO+n7b84Z5P7m
	ccwonqF8o8CeyfLv0q52CS7PDNHXMZ7/XgTxS6VmSRhp/cgXbhL+e/t899PIpgve/e8/esad
	2smesvT/rooJnGJ6hmbJctXpfRLfal4qsRRnJBpqMRcVJwIAg9vMFDwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi José,

Please see my comments below.

On Wednesday 11 of September 2013 11:08:27 José Miguel Gonçalves wrote:
> The Samsung serial driver currently does not support setting the
> RTS pin with an ioctl(TIOCMSET) call. This patch adds this support.
> 
> Signed-off-by: José Miguel Gonçalves <jose.goncalves@inov.pt>
> ---
>  drivers/tty/serial/samsung.c |   17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
> index f3dfa19..e5dd808 100644
> --- a/drivers/tty/serial/samsung.c
> +++ b/drivers/tty/serial/samsung.c
> @@ -407,7 +407,14 @@ static unsigned int s3c24xx_serial_get_mctrl(struct
> uart_port *port)
> 
>  static void s3c24xx_serial_set_mctrl(struct uart_port *port, unsigned
> int mctrl) {
> -	/* todo - possibly remove AFC and do manual CTS */
> +	unsigned int umcon = rd_regl(port, S3C2410_UMCON);
> +
> +	if (mctrl & TIOCM_RTS)
> +		umcon |= S3C2410_UMCOM_RTS_LOW;
> +	else
> +		umcon &= ~S3C2410_UMCOM_RTS_LOW;
> +
> +	wr_regl(port, S3C2410_UMCON, umcon);

I wonder if port capability shouldn't be considered here. Depending on SoC, 
only selected ports provide modem control capability.

For example on S3C64xx only ports 0 and 1 support modem control, while 
ports 2 and 3 don't.

>  }
> 
>  static void s3c24xx_serial_break_ctl(struct uart_port *port, int
> break_state) @@ -774,8 +781,6 @@ static void
> s3c24xx_serial_set_termios(struct uart_port *port, if (termios->c_cflag
> & CSTOPB)
>  		ulcon |= S3C2410_LCON_STOPB;
> 
> -	umcon = (termios->c_cflag & CRTSCTS) ? S3C2410_UMCOM_AFC : 0;
> -
>  	if (termios->c_cflag & PARENB) {
>  		if (termios->c_cflag & PARODD)
>  			ulcon |= S3C2410_LCON_PODD;
> @@ -792,6 +797,12 @@ static void s3c24xx_serial_set_termios(struct
> uart_port *port,
> 
>  	wr_regl(port, S3C2410_ULCON, ulcon);
>  	wr_regl(port, S3C2410_UBRDIV, quot);
> +
> +	if (termios->c_cflag & CRTSCTS)
> +		umcon = S3C2410_UMCOM_AFC;

Is it correct to override the last manual RTS value set to this register 
when activating manual flow control?

Shouldn't the code be more like the following:

	umcon = rd_regb(port, S3C2410_UMCON);
	if (termios->c_cflag & CRTSCTS)
		umcon |= S3C2410_UMCOM_AFC;
	else
		umcon &= ~S3C2410_UMCOM_AFC;
	wr_regl(port, S3C2410_UMCON, umcon);

Probably port capability should be considered here as well.

Best regards,
Tomasz

