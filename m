Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab3GXXMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 19:12:13 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:54457 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752775Ab3GXXMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 19:12:12 -0400
Message-ID: <51F05F49.60609@hurleysoftware.com>
Date: Wed, 24 Jul 2013 19:12:09 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dean Jenkins <Dean_Jenkins@mentor.com>
CC: Andre Naujoks <nautsch2@gmail.com>, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/5] Bluetooth: Add RFCOMM TTY write return error codes
References: <1372779094-11730-1-git-send-email-Dean_Jenkins@mentor.com> <1372779094-11730-2-git-send-email-Dean_Jenkins@mentor.com>
In-Reply-To: <1372779094-11730-2-git-send-email-Dean_Jenkins@mentor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2013 11:31 AM, Dean Jenkins wrote:
> It appears that rfcomm_tty_write() does not check that the
> passed in TTY device_data is not NULL and also does not check
> that the RFCOMM DLC serial data link pointer is not NULL.
>
> A kernel crash was observed whilst SLIP was bound to /dev/rfcomm0
> but the /dev/rfcomm0 had subsequently disconnected. Unfortunately,
> SLIP attempted to write to the now non-existant RFCOMM TTY device
> which caused a NULL pointer dereference because the device_data
> no longer existed.
>
> Therefore, add NULL pointer checks for the dev and dlc pointers
> and output kernel error debug to show that NULL had been detected.

Dean,

Sorry, I didn't see these until just now.

> Signed-off-by: Dean Jenkins <Dean_Jenkins@mentor.com>
> ---
>   net/bluetooth/rfcomm/tty.c | 14 +++++++++++++-
>   1 file changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
> index b6e44ad..56d28d1 100644
> --- a/net/bluetooth/rfcomm/tty.c
> +++ b/net/bluetooth/rfcomm/tty.c
> @@ -761,12 +761,24 @@ static void rfcomm_tty_close(struct tty_struct *tty, struct file *filp)
>   static int rfcomm_tty_write(struct tty_struct *tty, const unsigned char *buf, int count)
>   {
>   	struct rfcomm_dev *dev = (struct rfcomm_dev *) tty->driver_data;
> -	struct rfcomm_dlc *dlc = dev->dlc;
> +	struct rfcomm_dlc *dlc;
>   	struct sk_buff *skb;
>   	int err = 0, sent = 0, size;
>
>   	BT_DBG("tty %p count %d", tty, count);
>
> +	if (!dev) {
> +		BT_ERR("RFCOMM TTY device data structure does not exist");
> +		return -ENODEV;
> +	}
> +
> +	dlc = dev->dlc;
> +
> +	if (!dlc) {
> +		BT_ERR("RFCOMM serial data link does not exist");
> +		return -ENOLINK;
> +	}
> +

A number of bugs in rfcomm contributed to the crash you observed.
Several other reporters have also noted crashes stemming from
device disconnect. The rfcomm device must not disappear while a tty
is in-use.

Fixes for these are in-progress in a patch series by Gianluca Anzolin
on linux-bluetooth ML.

Also, for the future, kernel bluetooth patches go to:
   Gustavo Padovan <gustavo@padovan.org>
with cc's to:
   Johan Hedberg <johan.hedberg@gmail.com>
   Marcel Holtmann <marcel@holtmann.org>
   linux-bluetooth@vger.kernel.org

Regards,
Peter Hurley

