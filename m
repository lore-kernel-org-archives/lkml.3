Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbaJPMfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 08:35:47 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:42716 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751177AbaJPMfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 08:35:45 -0400
Message-ID: <543FBB97.9010006@hurleysoftware.com>
Date: Thu, 16 Oct 2014 08:35:35 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Sudhir Sreedharan <ssreedharan@mvista.com>, gregkh@linuxfoundation.org,
        khilman@kernel.org
CC: linux-serial@vger.kernel.org, jslaby@suse.cz, linux-kernel@vger.kernel.org,
        olof@lixom.net, linux-arm-kernel@lists.infradead.org,
        geert@linux-m68k.org
Subject: Re: [PATCH] tty: serial: 8250_core: restore the LCR register in set_sleep
References: <54369F77.5000906@hurleysoftware.com> <1413355395-5871-1-git-send-email-ssreedharan@mvista.com>
In-Reply-To: <1413355395-5871-1-git-send-email-ssreedharan@mvista.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2014 02:43 AM, Sudhir Sreedharan wrote:
> In ST16650V2 based serial uarts, while initalizing the PM state,
> LCR registers are being initialized to 0 in serial8250_set_sleep().
> If console port is already initialized and being used, this will
> throws garbage in the console.
> 
> Signed-off-by: Sudhir Sreedharan <ssreedharan@mvista.com>
> ---
>  drivers/tty/serial/8250/8250_core.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
> index ca5cfdc..e054482 100644
> --- a/drivers/tty/serial/8250/8250_core.c
> +++ b/drivers/tty/serial/8250/8250_core.c
> @@ -595,6 +595,7 @@ static void serial8250_rpm_put_tx(struct uart_8250_port *p)
>   */
>  static void serial8250_set_sleep(struct uart_8250_port *p, int sleep)
>  {
> +	unsigned char lcr, efr;
>  	/*
>  	 * Exar UARTs have a SLEEP register that enables or disables
>  	 * each UART to enter sleep mode separately.  On the XR17V35x the
> @@ -611,6 +612,8 @@ static void serial8250_set_sleep(struct uart_8250_port *p, int sleep)
>  
>  	if (p->capabilities & UART_CAP_SLEEP) {
>  		if (p->capabilities & UART_CAP_EFR) {
> +			lcr = serial_in(p, UART_LCR);
> +			efr = serial_in(p, UART_EFR);
>  			serial_out(p, UART_LCR, UART_LCR_CONF_MODE_B);
>  			serial_out(p, UART_EFR, UART_EFR_ECB);
>  			serial_out(p, UART_LCR, 0);
> @@ -618,8 +621,8 @@ static void serial8250_set_sleep(struct uart_8250_port *p, int sleep)
>  		serial_out(p, UART_IER, sleep ? UART_IERX_SLEEP : 0);
>  		if (p->capabilities & UART_CAP_EFR) {
>  			serial_out(p, UART_LCR, UART_LCR_CONF_MODE_B);
> -			serial_out(p, UART_EFR, 0);
> -			serial_out(p, UART_LCR, 0);
> +			serial_out(p, UART_EFR, sleep ? 0 : efr);
> +			serial_out(p, UART_LCR, sleep ? 0 : lcr);

Why is it necessary to clear EFR and LCR here? Does the UART not
power down?

UARTs with CAP_SLEEP but not CAP_EFR don't clear LCR before sleep.

However, if there is some kind of intentional side-effect here,
then a comment should note that.

Regards,
Peter Hurley

>  		}
>  	}
>  out:
> 

