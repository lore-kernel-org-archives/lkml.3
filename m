Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab3HESUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 14:20:40 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:51169 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483Ab3HESUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 14:20:38 -0400
Date: Mon, 5 Aug 2013 21:20:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rupesh Gujare <rupesh.gujare@atmel.com>
Cc: devel@linuxdriverproject.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] staging: ozwpan: Fixes crash due to invalid port
 aceess.
Message-ID: <20130805182023.GK5051@mwanda>
References: <1375724415-10801-1-git-send-email-rupesh.gujare@atmel.com>
 <1375724415-10801-2-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375724415-10801-2-git-send-email-rupesh.gujare@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 06:40:12PM +0100, Rupesh Gujare wrote:
> This patch fixes kernel crash issue, when we receive URB request
> after de-enumerating device.
> 

In other words we were getting a NULL dereference dereferencing
"ep".  There is an existing check already, which should be cleaned
up.

drivers/staging/ozwpan/ozhcd.c
   498  
   499          if (ep && port->hpd) {
                    ^^
This useless existing check should be removed.

   500                  list_add_tail(&urbl->link, &ep->urb_list);
   501                  if (!in_dir && ep_addr && (ep->credit < 0)) {
   502                          getrawmonotonic(&ep->timestamp);
   503                          ep->credit = 0;
   504                  }
   505          } else {
   506                  err = -EPIPE;
   507          }

I'm not sure that think -ENOMEM is the correct error code but I
also don't know what else to use.

I had a style nit pick as well, below.

> Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
> ---
>  drivers/staging/ozwpan/ozhcd.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
> index ed63868..d313a63 100644
> --- a/drivers/staging/ozwpan/ozhcd.c
> +++ b/drivers/staging/ozwpan/ozhcd.c
> @@ -480,10 +480,14 @@ static int oz_enqueue_ep_urb(struct oz_port *port, u8 ep_addr, int in_dir,
>  		oz_free_urb_link(urbl);
>  		return 0;
>  	}
> -	if (in_dir)
> +	if (in_dir && port->in_ep[ep_addr])
>  		ep = port->in_ep[ep_addr];
> -	else
> +	else if (!in_dir && port->out_ep[ep_addr])
>  		ep = port->out_ep[ep_addr];

In the future, use kernel braces style.  If one side of the if else
statement gets a brace then they both get one.  So it's like this:

	if (in_dir && port->in_ep[ep_addr]) {
		ep = port->in_ep[ep_addr];
	} else if (!in_dir && port->out_ep[ep_addr]) {
		ep = port->out_ep[ep_addr];
	} else {
		err = -ENOMEM;
		goto out;
	}

Or another simpler way to write this would be:

	ep = NULL;
	if (in_dir)
		ep = port->in_ep[ep_addr];
	else
		ep = port->out_ep[ep_addr];
	if (!ep) {
		err = -ENOMEM;
		goto unlock;
	}

regards,
dan carpenter

