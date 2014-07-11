Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbaGKQP5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:15:57 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:47880 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754807AbaGKQPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:15:55 -0400
Message-ID: <53C00DB5.600@hurleysoftware.com>
Date: Fri, 11 Jul 2014 12:15:49 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH tty-next 21/22] serial: core: Remove superfluous ldisc
 flush from uart_close()
References: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com> <1402924639-5164-22-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1402924639-5164-22-git-send-email-peter@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2014 09:17 AM, Peter Hurley wrote:
> The tty_ldisc_flush() after port hardware shutdown is unnecessary;
> the ldisc flush was just performed before the hardware shutdown
> in tty_port_close_start() and the ldisc will be released when
> uart_close() returns (because the last port close implies the
> last tty close).
>
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>   drivers/tty/serial/serial_core.c | 3 ---
>   1 file changed, 3 deletions(-)
>
> diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
> index 212ee07..15212d7 100644
> --- a/drivers/tty/serial/serial_core.c
> +++ b/drivers/tty/serial/serial_core.c
> @@ -1351,9 +1351,6 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
>
>   	mutex_lock(&port->mutex);
>   	uart_shutdown(tty, state);
> -
> -	tty_ldisc_flush(tty);
> -

This isn't exactly correct. There is a small window of time between the
ldisc flush being performed in tty_port_close_start() and the
subsequent stop_rx() in uart_close(). This might allow for data to be
received, and a racing tty reopen to receive that stale data. Unlikely, but
possible.

>   	tty_port_tty_set(port, NULL);
>   	tty->closing = 0;
>   	spin_lock_irqsave(&port->lock, flags);
>

