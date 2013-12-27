Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab3L0Rly (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 12:41:54 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:59814 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab3L0Rlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 12:41:52 -0500
Date: Fri, 27 Dec 2013 12:41:50 -0500 (EST)
Message-Id: <20131227.124150.654187539741639427.davem@davemloft.net>
To: levex@linux.com
Cc: linux-kernel@vger.kernel.org, ursula.braun@de.ibm.com, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 20/38] net: iucv: add missing put_device call
From: David Miller <davem@davemloft.net>
In-Reply-To: <1387465429-3568-21-git-send-email-levex@linux.com>
References: <1387465429-3568-2-git-send-email-levex@linux.com>
	<1387465429-3568-21-git-send-email-levex@linux.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 27 Dec 2013 09:41:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Levente Kurusa <levex@linux.com>
Date: Thu, 19 Dec 2013 16:03:31 +0100

> This is required so that we give up the last reference to the device.
> 
> Signed-off-by: Levente Kurusa <levex@linux.com>
 ...
> @@ -2377,8 +2377,10 @@ static int afiucv_iucv_init(void)
>  	af_iucv_dev->release = (void (*)(struct device *))kfree;
>  	af_iucv_dev->driver = &af_iucv_driver;
>  	err = device_register(af_iucv_dev);
> -	if (err)
> +	if (err) {
> +		put_device(af_iucv_dev);
>  		goto out_driver;
> +	}

This has the same problem as the ATM patch, there is no reference held on
af_iucv_dev, I mean look at where it comes from:

	af_iucv_dev = kzalloc(sizeof(struct device), GFP_KERNEL);
 ...
	dev_set_name(af_iucv_dev, "af_iucv");
	af_iucv_dev->bus = pr_iucv->bus;
	af_iucv_dev->parent = pr_iucv->root;
	af_iucv_dev->release = (void (*)(struct device *))kfree;
	af_iucv_dev->driver = &af_iucv_driver;

No reference count is incremented or set to one for af_iucv_dev.

Please study these code paths more carefully, thank you.
