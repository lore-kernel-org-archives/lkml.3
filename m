Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab3IWN7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 09:59:13 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:24197 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab3IWN7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 09:59:12 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-07-5240492eae93
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] USB: gadget: s3c-hsotg: add isochronous transfers support
Date: Mon, 23 Sep 2013 15:59:05 +0200
Message-id: <1994765.6nlskCcuVy@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1379923632-11205-2-git-send-email-r.baldyga@samsung.com>
References: <1379923632-11205-1-git-send-email-r.baldyga@samsung.com>
 <1379923632-11205-2-git-send-email-r.baldyga@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t9jAV09T4cgg6f/hCwO3q+3aF68ns3i
	bNMbdovLu+awWSxa1spssfbIXXaLB4d3sjuwe+yfu4bdo2/LKkaP4ze2M3l83iQXwBLFZZOS
	mpNZllqkb5fAlbG6s75giXrFh7a17A2MLfJdjJwcEgImEtdmTmSBsMUkLtxbz9bFyMUhJLCI
	UWLXnHZmCKeFSaKpcw0bSBWbgJXExPZVjCC2iICWxJ2P89lBipgF1jFKzHvwGqxIWMBPoqvt
	C1ARBweLgKrE6h+2IGFeAU2J9hnbwXpFBTwlPk1aygxicwq4STx/OQVqWSOjxM+NjWwQDYIS
	PybfAzuPWUBeYt/+qawQto7E/tZpbBMYBWYhKZuFpGwWkrIFjMyrGEVTC5ILipPSc430ihNz
	i0vz0vWS83M3MYJD+5n0DsZVDRaHGAU4GJV4eCMT7YOEWBPLiitzDzFKcDArifAuUnQIEuJN
	SaysSi3Kjy8qzUktPsQozcGiJM57sNU6UEggPbEkNTs1tSC1CCbLxMEp1cDo9v/qosdlyX7O
	v0uSj6+buyP7xtZIz5dXH5/9sGXer44tS+On7pHTed2zUMqkzKd7YldhRtWCsw1JE175/uE9
	73Pk/cLuO4XJDaXu5XwHT0XtNBMqOr+INdvh//sNy+tVPv1fduB/qJenUFbX09ogXcmD18zW
	ZKX3xU+J2Mb57sz2lS/rt895rcRSnJFoqMVcVJwIABVbbXFpAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Robert,

On Monday, September 23, 2013 10:07:12 AM Robert Baldyga wrote:
> This patch adds isochronous transfer support. It adds few modifications:
> - Modify s3c_hsotg_write_fifo() function. It actually calculates transfer
>   size, taking into account Multi Count value, which indicates number of
>   transactions per microframe.
> - Fix s3c_hsotg_start_req() function by setting number of packets to Multi
>   Count field in DIEPTSIZ register for isochronous endpoints.
> - Fix s3c_hsotg_set_ep_maxpacket() function. Field wMaxPacketSize of endpoint
>   descriptor is now splitted into maximum packet size value and number of
>   additional transaction per microframe.
> - Modify s3c_hsotg_epint() function. Some interrupts are ignored for
>   isochronous endpoints, (e.g. INTknTXFEmpMsk) becouse isochronous request is
>   always transfered in single transaction, which ends with XferCompl interrupt.
>   Add Odd/Even microframe toggle to allow data transfering in each microframe.
> - Fix s3c_hsotg_ep_enable() function by supporting isochronous endpoint type.
> 
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/usb/gadget/s3c-hsotg.c |   74 +++++++++++++++++++++++++++++++---------
>  1 file changed, 57 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
> index d5d951d..d737452 100644
> --- a/drivers/usb/gadget/s3c-hsotg.c
> +++ b/drivers/usb/gadget/s3c-hsotg.c
> @@ -82,9 +82,12 @@ struct s3c_hsotg_req;
>   * @dir_in: Set to true if this endpoint is of the IN direction, which
>   *	    means that it is sending data to the Host.
>   * @index: The index for the endpoint registers.
> + * @mc: Multi Count - number of transactions per microframe
> + * @interval - Interval for periodic endpoints
>   * @name: The name array passed to the USB core.
>   * @halted: Set if the endpoint has been halted.
>   * @periodic: Set if this is a periodic ep, such as Interrupt
> + * @insochronous: Set if this is a isochronous ep

s/insochronous/isochronous/

>   * @sent_zlp: Set if we've sent a zero-length packet.
>   * @total_data: The total number of data bytes done.
>   * @fifo_size: The size of the FIFO (for periodic IN endpoints)
> @@ -120,9 +123,12 @@ struct s3c_hsotg_ep {
>  
>  	unsigned char		dir_in;
>  	unsigned char		index;
> +	unsigned char		mc;
> +	unsigned char		interval;
>  
>  	unsigned int		halted:1;
>  	unsigned int		periodic:1;
> +	unsigned int		isochronous:1;
>  	unsigned int		sent_zlp:1;
>  
>  	char			name[10];
> @@ -467,6 +473,7 @@ static int s3c_hsotg_write_fifo(struct s3c_hsotg *hsotg,
>  	void *data;
>  	int can_write;
>  	int pkt_round;
> +	int max_transfer;
>  
>  	to_write -= (buf_pos - hs_ep->last_load);
>  
> @@ -534,15 +541,17 @@ static int s3c_hsotg_write_fifo(struct s3c_hsotg *hsotg,
>  		can_write *= 4;	/* fifo size is in 32bit quantities. */
>  	}
>  
> -	dev_dbg(hsotg->dev, "%s: GNPTXSTS=%08x, can=%d, to=%d, mps %d\n",
> -		 __func__, gnptxsts, can_write, to_write, hs_ep->ep.maxpacket);
> +	max_transfer = hs_ep->ep.maxpacket * hs_ep->mc;
> +
> +	dev_dbg(hsotg->dev, "%s: GNPTXSTS=%08x, can=%d, to=%d, max_transfer %d\n",
> +		 __func__, gnptxsts, can_write, to_write, max_transfer);
>  
>  	/*
>  	 * limit to 512 bytes of data, it seems at least on the non-periodic
>  	 * FIFO, requests of >512 cause the endpoint to get stuck with a
>  	 * fragment of the end of the transfer in it.
>  	 */
> -	if (can_write > 512)
> +	if (can_write > 512 && !periodic)
>  		can_write = 512;

Doesn't it also affect non-isochronous transfers?

If so this change should be in a separate preparatory patch.

>  	/*
> @@ -550,8 +559,8 @@ static int s3c_hsotg_write_fifo(struct s3c_hsotg *hsotg,
>  	 * the transfer to return that it did not run out of fifo space
>  	 * doing it.
>  	 */
> -	if (to_write > hs_ep->ep.maxpacket) {
> -		to_write = hs_ep->ep.maxpacket;
> +	if (to_write > max_transfer) {
> +		to_write = max_transfer;
>  
>  		/* it's needed only when we do not use dedicated fifos */
>  		if (!hsotg->dedicated_fifos)
> @@ -564,7 +573,7 @@ static int s3c_hsotg_write_fifo(struct s3c_hsotg *hsotg,
>  
>  	if (to_write > can_write) {
>  		to_write = can_write;
> -		pkt_round = to_write % hs_ep->ep.maxpacket;
> +		pkt_round = to_write % max_transfer;
>  
>  		/*
>  		 * Round the write down to an
> @@ -730,8 +739,16 @@ static void s3c_hsotg_start_req(struct s3c_hsotg *hsotg,
>  	else
>  		packets = 1;	/* send one packet if length is zero. */
>  
> +	if (length > (hs_ep->mc * hs_ep->ep.maxpacket) && hs_ep->isochronous) {

Wouldn't checking hs_ep->isonchronous first be better?

> +		dev_err(hsotg->dev, "req length > maxpacket*mc\n");
> +		return;
> +	}

The rest of the patch looks good to me.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

