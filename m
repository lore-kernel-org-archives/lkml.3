Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab3BOIYG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 03:24:06 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15245 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab3BOIYE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 03:24:04 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 15 Feb 2013 00:20:00 -0800
Message-ID: <511DF09F.3070401@nvidia.com>
Date: Fri, 15 Feb 2013 17:23:59 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130109 Thunderbird/17.0.2
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: USB list <linux-usb@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: usb_wwan_write() called while device still being resumed
References: <511CBCE8.9070204@nvidia.com> <87ehgivlmg.fsf@nemi.mork.no>
In-Reply-To: <87ehgivlmg.fsf@nemi.mork.no>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjørn, thanks for the reply!

On 02/15/2013 02:41 AM, Bjørn Mork wrote:
> I believe the usb_autopm_get_interface_async() failing is OK in this
> case, but that should not cause the modem to stop working.
>
> Wonder if this patch solves the problem? :
>
> From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
> Date: Thu, 14 Feb 2013 18:34:48 +0100
> Subject: [PATCH] USB: usb_wwan: clear port busy state on error
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
>
> Reported-by: Alex Courbot <acourbot@nvidia.com>
> Signed-off-by: Bjørn Mork <bjorn@mork.no>
> ---
>   drivers/usb/serial/usb_wwan.c |    4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
> index 01c94aa..44e106d 100644
> --- a/drivers/usb/serial/usb_wwan.c
> +++ b/drivers/usb/serial/usb_wwan.c
> @@ -230,8 +230,10 @@ int usb_wwan_write(struct tty_struct *tty, struct usb_serial_port *port,
>   			usb_pipeendpoint(this_urb->pipe), i);
>
>   		err = usb_autopm_get_interface_async(port->serial->interface);
> -		if (err < 0)
> +		if (err < 0) {
> +			clear_bit(i, &portdata->out_busy);
>   			break;
> +		}
>
>   		/* send the data */
>   		memcpy(this_urb->transfer_buffer, buf, todo);
>

Unfortunately it does not, and fails the same way. On the other hand, I 
do not see the issue when doing the following:

diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index e4fad5e..1490029 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -238,8 +238,6 @@ int usb_wwan_write(struct tty_struct *tty, struct 
usb_serial_port *port,
                     usb_pipeendpoint(this_urb->pipe), i);

                 err = 
usb_autopm_get_interface_async(port->serial->interface);
-               if (err < 0)
-                       break;

                 /* send the data */
                 memcpy(this_urb->transfer_buffer, buf, todo);

After doing this I don't see this issue anymore. It looks wrong though. 
But it seems to work despite the obvious unbalance in autopm calls that 
results.

If I understand you correctly, usb_wwan_write() failing here is not a 
problem in itself, and the ack should just be sent again later?

 > that should not cause the modem to stop working.

Actually it might also be that the network stack ends up in a bad state 
and remains stuck in it. I don't think the modem by itself is affected. 
All I observe is that no network traffic takes place after this. I'm not 
familiar enough with networking to make any stronger assumption.

FWIW, when usb_autopm_get_interface_async() returns -EACCES, the power 
parameters of port->serial->interface->dev are as follows:

disable_depth = 1
is_suspended = 1
runtime_status = 2 (RPM_SUSPENDED)

Thanks,
Alex.

