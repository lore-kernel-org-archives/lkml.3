Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbaJGQjD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 12:39:03 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:35062 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244AbaJGQjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 12:39:00 -0400
Date: Tue, 7 Oct 2014 09:38:56 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: linux-kernel@vger.kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: adp5588-keys: cancel workqueue in failure path
Message-ID: <20141007163856.GE16469@dtor-ws>
References: <1412667049-6128-1-git-send-email-pramod.gurav@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412667049-6128-1-git-send-email-pramod.gurav@smartplayin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 01:00:49PM +0530, Pramod Gurav wrote:
> This change introduces a label to call cancel_delayed_work_sync in
> failure path.
> 
> Cc: Michael Hennerich <michael.hennerich@analog.com>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: linux-input@vger.kernel.org
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> ---
>  drivers/input/keyboard/adp5588-keys.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/input/keyboard/adp5588-keys.c b/drivers/input/keyboard/adp5588-keys.c
> index 5ef7fcf..b494062 100644
> --- a/drivers/input/keyboard/adp5588-keys.c
> +++ b/drivers/input/keyboard/adp5588-keys.c
> @@ -559,7 +559,7 @@ static int adp5588_probe(struct i2c_client *client,
>  	error = input_register_device(input);
>  	if (error) {
>  		dev_err(&client->dev, "unable to register input device\n");
> -		goto err_free_mem;
> +		goto err_delayed_work;
>  	}
>  
>  	error = request_irq(client->irq, adp5588_irq,
> @@ -592,6 +592,8 @@ static int adp5588_probe(struct i2c_client *client,
>   err_unreg_dev:
>  	input_unregister_device(input);
>  	input = NULL;
> + err_delayed_work:
> +	cancel_delayed_work_sync(&kpad->work);

We do not need to have a separate label, just need to cancel workqueue
after freeing interrupt. I adjusted the patch and applied.

Thanks.

-- 
Dmitry
