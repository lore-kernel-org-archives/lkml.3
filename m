Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbaKOUs6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 15:48:58 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:40786 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567AbaKOUs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 15:48:57 -0500
Date: Sat, 15 Nov 2014 21:48:51 +0100
From: Christophe RICARD <christophe.ricard@gmail.com>
To: Dmitry Torokhov <dtor@chromium.org>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfc@ml01.01.org
Subject: Re: [PATCH] NFC: st21nfca: fix error handling of
 irq_of_parse_and_map
Message-ID: <20141115214851.182e9cb5@toffy-MacBookPro>
In-Reply-To: <20141114223224.GA1448@dtor-ws>
References: <20141114223224.GA1448@dtor-ws>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

Thank you for your feedback.
A patch got already pushed earlier this month:
https://lists.01.org/pipermail/linux-nfc/2014-November/003123.html

The i2c-core is already running the i2c_of_parse_and_map function when
registering the slave device when using dts. This step got removed for
this reason. 

However, i will take into account your second point in order to report
devm_gpio_request_one instead of -ENODEV in a future patchset.

Best Regards
Christophe 

On Fri, 14 Nov 2014 14:32:24 -0800
Dmitry Torokhov <dtor@chromium.org> wrote:

> Return value of irq_of_parse_and_map() is unsigned int, with 0
> indicating failure, so testing for negative result never works.
> 
> Also report error returned by devm_gpio_request_one instead of
> clobbering it with -ENODEV.
> 
> Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
> ---
>  drivers/nfc/st21nfca/i2c.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/nfc/st21nfca/i2c.c b/drivers/nfc/st21nfca/i2c.c
> index 0ea756b..6d6d282 100644
> --- a/drivers/nfc/st21nfca/i2c.c
> +++ b/drivers/nfc/st21nfca/i2c.c
> @@ -531,20 +531,19 @@ static int
> st21nfca_hci_i2c_of_request_resources(struct i2c_client *client)
> "clf_enable"); if (r) {
>  		nfc_err(&client->dev, "Failed to request enable
> pin\n");
> -		return -ENODEV;
> +		return r;
>  	}
>  
>  	phy->gpio_ena = gpio;
>  
>  	/* IRQ */
> -	r = irq_of_parse_and_map(pp, 0);
> -	if (r < 0) {
> -		nfc_err(&client->dev, "Unable to get irq, error:
> %d\n", r);
> -		return r;
> +	client->irq = irq_of_parse_and_map(pp, 0);
> +	if (!client->irq) {
> +		nfc_err(&client->dev, "Unable to get irq\n");
> +		return -EINVAL;
>  	}
>  
>  	phy->irq_polarity = irq_get_trigger_type(r);
> -	client->irq = r;
>  
>  	return 0;
>  }

