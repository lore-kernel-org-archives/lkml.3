Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbbATNNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 08:13:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50929 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839AbbATNNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 08:13:30 -0500
Message-ID: <1421759597.29486.22.camel@linux-0dmf.site>
Subject: Re: [PATCH 04/11] hso: fix memory leak in hso_create_rfkill()
From: Oliver Neukum <oneukum@suse.de>
To: Olivier Sobrie <olivier@sobrie.be>
Cc: Jan Dumon <j.dumon@option.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Date: Tue, 20 Jan 2015 14:13:17 +0100
In-Reply-To: <1421756978-4093-5-git-send-email-olivier@sobrie.be>
References: <1421756978-4093-1-git-send-email-olivier@sobrie.be>
	 <1421756978-4093-2-git-send-email-olivier@sobrie.be>
	 <1421756978-4093-3-git-send-email-olivier@sobrie.be>
	 <1421756978-4093-4-git-send-email-olivier@sobrie.be>
	 <1421756978-4093-5-git-send-email-olivier@sobrie.be>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-20 at 13:29 +0100, Olivier Sobrie wrote:
> When the rfkill interface was created, a buffer containing the name
> of the rfkill node was allocated. This buffer was never freed when the
> device disappears.
> 
> To fix the problem, we put the name given to rfkill_alloc() in
> the hso_net structure.
> 
> Signed-off-by: Olivier Sobrie <olivier@sobrie.be>
> ---
>  drivers/net/usb/hso.c | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
> index 470ef9e..a49ac2e 100644
> --- a/drivers/net/usb/hso.c
> +++ b/drivers/net/usb/hso.c
> @@ -153,6 +153,7 @@ struct hso_net {
>  	struct hso_device *parent;
>  	struct net_device *net;
>  	struct rfkill *rfkill;
> +	char name[8];
>  
>  	struct usb_endpoint_descriptor *in_endp;
>  	struct usb_endpoint_descriptor *out_endp;
> @@ -2467,27 +2468,20 @@ static void hso_create_rfkill(struct hso_device *hso_dev,
>  {
>  	struct hso_net *hso_net = dev2net(hso_dev);
>  	struct device *dev = &hso_net->net->dev;
> -	char *rfkn;
>  
> -	rfkn = kzalloc(20, GFP_KERNEL);
> -	if (!rfkn)
> -		dev_err(dev, "%s - Out of memory\n", __func__);
> -
> -	snprintf(rfkn, 20, "hso-%d",
> +	snprintf(hso_net->name, sizeof(hso_net->name), "hso-%d",
>  		 interface->altsetting->desc.bInterfaceNumber);

That number is not unique. Indeed it will be identical for all devices.

	Regards
		Oliver

-- 
Oliver Neukum <oneukum@suse.de>

