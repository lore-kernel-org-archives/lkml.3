Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024AbaHGQzy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 12:55:54 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:61080 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567AbaHGQzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 12:55:50 -0400
Date: Thu, 7 Aug 2014 09:55:45 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: nick.dyer@itdev.co.uk
Cc: Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Sekhar Nori <nsekhar@ti.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 1/2] Input: atmel_mxt_ts - Fix double free of input device
Message-ID: <20140807165545.GB22421@core.coreip.homeip.net>
References: <1407420438-6289-1-git-send-email-nick.dyer@itdev.co.uk>
 <1407420438-6289-2-git-send-email-nick.dyer@itdev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407420438-6289-2-git-send-email-nick.dyer@itdev.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 03:07:17PM +0100, nick.dyer@itdev.co.uk wrote:
> From: Stephen Warren <swarren@wwwdotorg.org>
> 
> Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
> ---
>  drivers/input/touchscreen/atmel_mxt_ts.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
> index 03b8571..da497db 100644
> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> @@ -1353,8 +1353,10 @@ static int mxt_get_info(struct mxt_data *data)
>  
>  static void mxt_free_object_table(struct mxt_data *data)
>  {
> -	input_unregister_device(data->input_dev);
> -	data->input_dev = NULL;
> +	if (data->input_dev) {
> +		input_unregister_device(data->input_dev);
> +		data->input_dev = NULL;
> +	}
>  
>  	kfree(data->object_table);
>  	data->object_table = NULL;
> @@ -2194,7 +2196,6 @@ static int mxt_remove(struct i2c_client *client)
>  
>  	sysfs_remove_group(&client->dev.kobj, &mxt_attr_group);
>  	free_irq(data->irq, data);
> -	input_unregister_device(data->input_dev);
>  	mxt_free_object_table(data);
>  	kfree(data);

No. Let's have mxt_free_object_table() only free object table, and let's
call input_unregister_device() explicitly where needed, like we do in
mxt_remove().

Thanks.

-- 
Dmitry
