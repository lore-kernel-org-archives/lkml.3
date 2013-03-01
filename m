Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab3CATSG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:18:06 -0500
Received: from mail1.windriver.com ([147.11.146.13]:34759 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab3CATSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:18:03 -0500
Message-ID: <5130FEBC.7030806@windriver.com>
Date: Fri, 1 Mar 2013 14:17:16 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Wang YanQing <udknight@gmail.com>, <gregkh@linuxfoundation.org>,
        <swarren@wwwdotorg.org>, <jslaby@suse.cz>, <alan@linux.intel.com>,
        <arnd@arndb.de>, <damm@opensource.se>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]serial: 8250: Fix detect XScale port wrong
References: <20130301055610.GA31770@udknight>
In-Reply-To: <20130301055610.GA31770@udknight>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-03-01 12:56 AM, Wang YanQing wrote:
> Some UARTs add enhanced functions with unused bit in
> 16550 standard, like UART_IER_UUE bit, it cause XScale

Which xscale platform?  It would be nice to know the specifics.

> detect wrong. Now detect UART_IER_UUE and UART_IER_RTOIE
> to reduce the annoying wrong result which cause UARTs don't
> work.

You should ideally identify the original commit which caused
the regression.  Assuming you have fully understood the problem
you should be able to do this with "git blame" and not need to
do the full bisect.

In addition, you should also describe how they fail, since just
saying "don't work" does not convey what the end user symptom
looked like at all.

> 
> Serial controller: Device 4348:3253(CH352 PCI based Multi-I/O Controller)
> is a example. It use UART_IER_UUE as the LOWPOWER function,
> you can get the datasheet from below urls:
> 
> http://wch-ic.com/download/list.asp?id=116
> CH352DS1.PDF
> 
> http://wch-ic.com/download/list.asp?id=117
> CH352DS2.PDF.

Rather than quote links that will expire and no longer be
valid in six months, it would be better if you described
exactly how and why these ports are different directly in
your commit long log.

> I choice UART_IER_RTOIE as another test bit, because
> choice it is harmless for current code, we will set
> UART_CAP_RTOIE if it is XScale port.

There are a lot of 8250/16550 variations out there, and you
really need to be careful when claiming that you can make
"harmless" changes.  It might look harmless but at the same
time break some 8250 clone in some SoC.

> 
> Signed-off-by: Wang YanQing <udknight@gmail.com>
> ---
>  drivers/tty/serial/8250/8250.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
> index 0efc815..2c1f9c9 100644
> --- a/drivers/tty/serial/8250/8250.c
> +++ b/drivers/tty/serial/8250/8250.c
> @@ -841,6 +841,7 @@ static void autoconfig_16550a(struct uart_8250_port *up)
>  {
>  	unsigned char status1, status2;
>  	unsigned int iersave;
> +	unsigned int iertest;

It looks to me like this is never written to, aside from the 1st
assignment and hence could just as easily be a #define or similar.

>  
>  	up->port.type = PORT_16550A;
>  	up->capabilities |= UART_CAP_FIFO;
> @@ -966,16 +967,25 @@ static void autoconfig_16550a(struct uart_8250_port *up)
>  	 * We're going to explicitly set the UUE bit to 0 before
>  	 * trying to write and read a 1 just to make sure it's not
>  	 * already a 1 and maybe locked there before we even start start.
> +	 *
> +	 * 01/03/2013
> +	 * Some UARTs add enhanced functions with unused bit in
> +	 * 16550 standard, like UART_IER_UUE bit, it cause XScale
> +	 * detect wrong. Now detect UART_IER_UUE and UART_IER_RTOIE
> +	 * to reduce the annoying wrong result which cause UART don't
> +	 * work.
>  	 */
>  	iersave = serial_in(up, UART_IER);
> -	serial_out(up, UART_IER, iersave & ~UART_IER_UUE);
> -	if (!(serial_in(up, UART_IER) & UART_IER_UUE)) {
> +	iertest = UART_IER_UUE | UART_IER_RTOIE;
> +
> +	serial_out(up, UART_IER, iersave & ~iertest);
> +	if (!(serial_in(up, UART_IER) & iertest)) {
>  		/*
>  		 * OK it's in a known zero state, try writing and reading
>  		 * without disturbing the current state of the other bits.
>  		 */
> -		serial_out(up, UART_IER, iersave | UART_IER_UUE);
> -		if (serial_in(up, UART_IER) & UART_IER_UUE) {
> +		serial_out(up, UART_IER, iersave | iertest);
> +		if ((serial_in(up, UART_IER) & iertest) == iertest) {
>  			/*
>  			 * It's an Xscale.
>  			 * We'll leave the UART_IER_UUE bit set to 1 (enabled).

What does your change do to Xscale that do not do UART_IER_RTOIE?

Paul.
--

> 
