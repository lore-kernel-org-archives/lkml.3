Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbaJ2BFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 21:05:13 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:59745 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751062AbaJ2BFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 21:05:12 -0400
Message-ID: <54503D44.4080908@hurleysoftware.com>
Date: Tue, 28 Oct 2014 21:05:08 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jim Paris <jim@jtan.com>, Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cdc-acm: ensure that termios get set when the port is
 opened
References: <20141028232649.GA1064@psychosis.jim.sh>
In-Reply-To: <20141028232649.GA1064@psychosis.jim.sh>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jim,

On 10/28/2014 07:26 PM, Jim Paris wrote:
> Do what other drivers like ftdi_sio do, and ensure that termios are
> written to the device when the port is first opened.
> 
> Signed-off-by: Jim Paris <jim@jtan.com>
> ---
> 
> Tested on v3.16.5.
> 
> I've seen a problem on two CDC-ACM systems based on a Segger J-Link
> where the port does not get initialized at the correct baudrate when
> opening (using e.g. python-serial).  I think this occurs when the tty
> device was previously opened at the same baudrate, then the device was
> unplugged and replugged.  While the port is open, manually switching
> to a different baudrate and back fixes it.
> 
> Debug output in the failing case is e.g.:
> 
>   Oct 28 18:37:45 pilot kernel: [1214446.586460] tty ttyACM0: acm_tty_install
>   Oct 28 18:37:45 pilot kernel: [1214446.586474] tty ttyACM0: acm_tty_open
>   Oct 28 18:37:45 pilot kernel: [1214446.586477] cdc_acm 1-2.7:1.0: acm_port_activate
>   Oct 28 18:37:45 pilot kernel: [1214446.586670] cdc_acm 1-2.7:1.0: acm_ctrl_msg - rq 0x22, val 0x3, len 0x0, result 0
> 
> which is missing the important:
> 
>   Oct 28 19:03:18 pilot kernel: [1215981.178020] cdc_acm 1-2.7:1.0: acm_tty_set_termios - set line: 38400 0 0 8
>   Oct 28 19:03:18 pilot kernel: [1215981.178135] cdc_acm 1-2.7:1.0: acm_ctrl_msg - rq 0x20, val 0x0, len 0x7, result 7
> 
> that I get when changing settings to something different than they
> previously were.
> 
> I don't really follow all of the termios and tty stuff, so I don't
> know if this is the right fix or the real cause.  I suspect it
> have to do with cached values associated with the particular TTY
> ("lazy saved data" in tty-io.c); this patch just does what I see in
> ftdi_sio and ensures that the termios settings are written to the
> device when the port is opened.

Yeah, you're right that the cdc-acm driver isn't properly configuring
the hardware for the current termios settings under all conditions.

But you don't want to do it for every tty open, only for opens
requiring port initialization, which is what the tty_port->activate()
method is for (ie., acm_port_activate()).

Note that the ftdi_sio driver is a usb serial port driver; ftdi_open()
is called from serial_port_activate(), which is the activate() method
for all usb serial drivers.

Regards,
Peter Hurley


> ---
>  drivers/usb/class/cdc-acm.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
> index e934e19f49f5..144bf43c9190 100644
> --- a/drivers/usb/class/cdc-acm.c
> +++ b/drivers/usb/class/cdc-acm.c
> @@ -495,15 +495,6 @@ error_init_termios:
>  	return retval;
>  }
>  
> -static int acm_tty_open(struct tty_struct *tty, struct file *filp)
> -{
> -	struct acm *acm = tty->driver_data;
> -
> -	dev_dbg(tty->dev, "%s\n", __func__);
> -
> -	return tty_port_open(&acm->port, tty, filp);
> -}
> -
>  static void acm_port_dtr_rts(struct tty_port *port, int raise)
>  {
>  	struct acm *acm = container_of(port, struct acm, port);
> @@ -1000,6 +991,18 @@ static void acm_tty_set_termios(struct tty_struct *tty,
>  	}
>  }
>  
> +static int acm_tty_open(struct tty_struct *tty, struct file *filp)
> +{
> +	struct acm *acm = tty->driver_data;
> +
> +	dev_dbg(tty->dev, "%s\n", __func__);
> +
> +	if (tty)
> +		acm_tty_set_termios(tty, NULL);
> +
> +	return tty_port_open(&acm->port, tty, filp);
> +}
> +
>  static const struct tty_port_operations acm_port_ops = {
>  	.dtr_rts = acm_port_dtr_rts,
>  	.shutdown = acm_port_shutdown,
> 

