Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965515Ab3CZPgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:36:11 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:53973 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965163Ab3CZPgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:36:06 -0400
MIME-Version: 1.0
In-Reply-To: <20130325010532.611847650@decadent.org.uk>
References: <20130325010524.240972766@decadent.org.uk>
	<20130325010532.611847650@decadent.org.uk>
Date: Tue, 26 Mar 2013 16:36:04 +0100
Message-ID: <CAMgPeKXMgdQ1CUBtXCgmFse7uQaeEM0aNB5n09ubASVfobQ_BA@mail.gmail.com>
Subject: Re: [ 084/104] USB: serial: add modem-status-change wait queue
From: Johan Hovold <jhovold@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 2:06 AM, Ben Hutchings <ben@decadent.org.uk> wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me know.

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
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  include/linux/usb/serial.h |    2 ++
>  1 file changed, 2 insertions(+)
>
> --- a/include/linux/usb/serial.h
> +++ b/include/linux/usb/serial.h
> @@ -71,6 +71,7 @@ enum port_dev_state {
>   *     port.
>   * @flags: usb serial port flags
>   * @write_wait: a wait_queue_head_t used by the port.
> + * @delta_msr_wait: modem-status-change wait queue
>   * @work: work queue entry for the line discipline waking up.
>   * @throttled: nonzero if the read urb is inactive to throttle the device
>   * @throttle_req: nonzero if the tty wants to throttle us
> @@ -114,6 +115,7 @@ struct usb_serial_port {
>
>         unsigned long           flags;
>         wait_queue_head_t       write_wait;
> +       wait_queue_head_t       delta_msr_wait;
>         struct work_struct      work;
>         char                    throttled;
>         char                    throttle_req;
>
>
