Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297AbaHSK5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 06:57:04 -0400
Received: from smtprelay02.ispgateway.de ([80.67.31.25]:41519 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbaHSK5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 06:57:02 -0400
Message-ID: <53F32D79.8050401@ladisch.de>
Date: Tue, 19 Aug 2014 12:56:57 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arjun Sreedharan <arjun024@gmail.com>
CC: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: use kcalloc instead of kzalloc
References: <1408444681-1601-1-git-send-email-arjun024@gmail.com>
In-Reply-To: <1408444681-1601-1-git-send-email-arjun024@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjun Sreedharan wrote:
> kcalloc has protection from integer overflows
> which could arise from the multiplication of
> number of elements and size.

You are implying that such an overflow could arise in this code.
This is false.

> @@ -380,8 +380,7 @@ static int usb_parse_interface(struct device *ddev, int cfgno,
>
>  	if (num_ep > 0) {
>  		/* Can't allocate 0 bytes */
> -		len = sizeof(struct usb_host_endpoint) * num_ep;
> -		alt->endpoint = kzalloc(len, GFP_KERNEL);
> +		alt->endpoint = kcalloc(num_ep, sizeof(struct usb_host_endpoint), GFP_KERNEL);

bNumEndpoints is an unsigned 8-bit integer.

And even if you did not notice this, you should have noticed the if()
directly before this one.

> @@ -683,13 +682,11 @@ int usb_get_configuration(struct usb_device *dev)
>  		return -EINVAL;
>  	}
>
> -	length = ncfg * sizeof(struct usb_host_config);
> -	dev->config = kzalloc(length, GFP_KERNEL);
> +	dev->config = kcalloc(ncfg, sizeof(struct usb_host_config), GFP_KERNEL);
>  	if (!dev->config)
>  		goto err2;
>
> -	length = ncfg * sizeof(char *);
> -	dev->rawdescriptors = kzalloc(length, GFP_KERNEL);
> +	dev->rawdescriptors = kcalloc(ncfg, sizeof(char *), GFP_KERNEL);

Same oversights here.


Regards,
Clemens
