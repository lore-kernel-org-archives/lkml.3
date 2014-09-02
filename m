Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbaIBVuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 17:50:22 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47167 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbaIBVuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 17:50:19 -0400
Message-ID: <54063BA1.2030206@ti.com>
Date: Tue, 2 Sep 2014 17:50:25 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH 01/26] Revert "serial: uart: add hw flow control support
 configuration"
References: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com> <1409693975-1028-2-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1409693975-1028-2-git-send-email-peter@hurleysoftware.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

On 09/02/2014 05:39 PM, Peter Hurley wrote:
>  Finally, this patch
> supposes to fix existing bugs in the serial core for auto CTS-enabled
> hardware, but does not include the class of hardware for which these
> bugs exist.

What is this? What class of hardware are you referring to?

As discussed, I will send an updated patch for this as discussed..

Regards,

Murali
>
> CC: Murali Karicheri<m-karicheri2@ti.com>
> CC: Rob Herring<robh+dt@kernel.org>
> Signed-off-by: Peter Hurley<peter@hurleysoftware.com>
> ---
>   Documentation/devicetree/bindings/serial/of-serial.txt |  1 -
>   drivers/tty/serial/8250/8250_core.c                    |  6 ++----
>   drivers/tty/serial/of_serial.c                         |  4 ----
>   drivers/tty/serial/serial_core.c                       | 12 +++---------
>   4 files changed, 5 insertions(+), 18 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/serial/of-serial.txt b/Documentation/devicetree/bindings/serial/of-serial.txt
> index 7705477..1928a3e 100644
> --- a/Documentation/devicetree/bindings/serial/of-serial.txt
> +++ b/Documentation/devicetree/bindings/serial/of-serial.txt
> @@ -37,7 +37,6 @@ Optional properties:
>   - auto-flow-control: one way to enable automatic flow control support. The
>     driver is allowed to detect support for the capability even without this
>     property.
> -- has-hw-flow-control: the hardware has flow control capability.
>
>   Example:
>
> diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
> index 7a91c6d..109da60 100644
> --- a/drivers/tty/serial/8250/8250_core.c
> +++ b/drivers/tty/serial/8250/8250_core.c
> @@ -2333,11 +2333,9 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
>   	 * the trigger, or the MCR RTS bit is cleared.  In the case where
>   	 * the remote UART is not using CTS auto flow control, we must
>   	 * have sufficient FIFO entries for the latency of the remote
> -	 * UART to respond.  IOW, at least 32 bytes of FIFO. Also enable
> -	 * AFE if hw flow control is supported
> +	 * UART to respond.  IOW, at least 32 bytes of FIFO.
>   	 */
> -	if ((up->capabilities&  UART_CAP_AFE&&  (port->fifosize>= 32)) ||
> -	    (port->flags&  UPF_HARD_FLOW)) {
> +	if (up->capabilities&  UART_CAP_AFE&&  port->fifosize>= 32) {
>   		up->mcr&= ~UART_MCR_AFE;
>   		if (termios->c_cflag&  CRTSCTS)
>   			up->mcr |= UART_MCR_AFE;
> diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
> index 68d4455..27981e2 100644
> --- a/drivers/tty/serial/of_serial.c
> +++ b/drivers/tty/serial/of_serial.c
> @@ -183,10 +183,6 @@ static int of_platform_serial_probe(struct platform_device *ofdev)
>   					  "auto-flow-control"))
>   			port8250.capabilities |= UART_CAP_AFE;
>
> -		if (of_property_read_bool(ofdev->dev.of_node,
> -					  "has-hw-flow-control"))
> -			port8250.port.flags |= UPF_HARD_FLOW;
> -
>   		ret = serial8250_register_8250_port(&port8250);
>   		break;
>   	}
> diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
> index c2f90ec..261e49e 100644
> --- a/drivers/tty/serial/serial_core.c
> +++ b/drivers/tty/serial/serial_core.c
> @@ -174,12 +174,8 @@ static int uart_port_startup(struct tty_struct *tty, struct uart_state *state,
>   			if (tty->termios.c_cflag&  CBAUD)
>   				uart_set_mctrl(uport, TIOCM_RTS | TIOCM_DTR);
>   		}
> -		/*
> -		 * if hw support flow control without software intervention,
> -		 * then skip the below check
> -		 */
> -		if (tty_port_cts_enabled(port)&&
> -		    !(uport->flags&  UPF_HARD_FLOW)) {
> +
> +		if (tty_port_cts_enabled(port)) {
>   			spin_lock_irq(&uport->lock);
>   			if (!(uport->ops->get_mctrl(uport)&  TIOCM_CTS))
>   				tty->hw_stopped = 1;
> @@ -2777,9 +2773,7 @@ void uart_handle_cts_change(struct uart_port *uport, unsigned int status)
>
>   	uport->icount.cts++;
>
> -	/* skip below code if the hw flow control is supported */
> -	if (tty_port_cts_enabled(port)&&
> -	    !(uport->flags&  UPF_HARD_FLOW)) {
> +	if (tty_port_cts_enabled(port)) {
>   		if (tty->hw_stopped) {
>   			if (status) {
>   				tty->hw_stopped = 0;

