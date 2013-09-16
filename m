Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab3IPPHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 11:07:04 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:59153 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab3IPPHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 11:07:01 -0400
Date: Mon, 16 Sep 2013 08:06:57 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Manish Badarkhe <badarkhe.manish@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        josh.wu@atmel.com
Subject: Re: [PATCH] Input: atmel_mxt_ts - update to devm_* API
Message-ID: <20130916150657.GA12105@core.coreip.homeip.net>
References: <1379343016-6354-1-git-send-email-badarkhe.manish@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379343016-6354-1-git-send-email-badarkhe.manish@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manish,

On Mon, Sep 16, 2013 at 08:20:16PM +0530, Manish Badarkhe wrote:
> @@ -1264,10 +1261,8 @@ static int mxt_remove(struct i2c_client *client)
>  	struct mxt_data *data = i2c_get_clientdata(client);
>  
>  	sysfs_remove_group(&client->dev.kobj, &mxt_attr_group);
> -	free_irq(data->irq, data);
>  	input_unregister_device(data->input_dev);
>  	kfree(data->object_table);
> -	kfree(data);

YOu need to be _very_ careful when mixing devm_* and non-devm-managed
resources, especially when interrupt is involved. In this particular
case you are offloading freeing of the interrupt (and disabling it) to
devm, which will happen later, bu you are freeing object table
immediately. This may cause driver crash if interrupt comes while device
is being unbound.

That said, there is a large outstanding series to the driver from Nick
Dryer that I am trying to merge, you may want to coordinate this change
with him.

Thanks.

-- 
Dmitry
