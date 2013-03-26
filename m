Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965460Ab3CZPcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:32:19 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:41235 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964868Ab3CZPcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:32:15 -0400
Date: Tue, 26 Mar 2013 16:31:18 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 098/150] USB: serial: add modem-status-change wait queue
Message-ID: <20130326153118.GE9739@localhost>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
 <1364311249-14454-99-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364311249-14454-99-git-send-email-luis.henriques@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 03:19:57PM +0000, Luis Henriques wrote:
> 3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

This patch is incorrect as the wait-queue initialisation is missing. A
fix has been posted to linux-usb:

	http://marc.info/?l=linux-usb&m=136428758202815&w=2

and should show up in 3.9-rc5. This patch and the following
use-after-free patches should not be applied without that fix.

Johan

> ------------------
> 
> From: Johan Hovold <jhovold@gmail.com>
> 
> commit e5b33dc9d16053c2ae4c2c669cf008829530364b upstream.
> 
> Add modem-status-change wait queue to struct usb_serial_port that
> subdrivers can use to implement TIOCMIWAIT.
> 
> Currently subdrivers use a private wait queue which may have been
> released when waking up after device disconnected.
> 
> Note that we're adding a new wait queue rather than reusing the tty-port
> one as we do not want to get woken up at hangup (yet).
> 
> Signed-off-by: Johan Hovold <jhovold@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
> ---
>  include/linux/usb/serial.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
> index 86c0b45..0b61f01 100644
> --- a/include/linux/usb/serial.h
> +++ b/include/linux/usb/serial.h
> @@ -66,6 +66,7 @@
>   *	port.
>   * @flags: usb serial port flags
>   * @write_wait: a wait_queue_head_t used by the port.
> + * @delta_msr_wait: modem-status-change wait queue
>   * @work: work queue entry for the line discipline waking up.
>   * @throttled: nonzero if the read urb is inactive to throttle the device
>   * @throttle_req: nonzero if the tty wants to throttle us
> @@ -112,6 +113,7 @@ struct usb_serial_port {
>  
>  	unsigned long		flags;
>  	wait_queue_head_t	write_wait;
> +	wait_queue_head_t	delta_msr_wait;
>  	struct work_struct	work;
>  	char			throttled;
>  	char			throttle_req;
