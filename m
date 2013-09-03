Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760750Ab3ICUZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 16:25:57 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:32915 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932Ab3ICUZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 16:25:55 -0400
Message-ID: <522645D0.3030503@wwwdotorg.org>
Date: Tue, 03 Sep 2013 14:25:52 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] gpio: Fix crash in gpiod_set_debounce()
References: <1378204768-18013-1-git-send-email-treding@nvidia.com>
In-Reply-To: <1378204768-18013-1-git-send-email-treding@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2013 04:39 AM, Thierry Reding wrote:
> Return an error if neither the ->set() nor the ->set_debounce() function
> is implemented by the chip. Furthermore move locking further down so the
> lock doesn't have to be unlocked on error. This is safe to do because at
> this point the lock doesn't protect anything.

> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c

>  	chip = desc->chip;
>  	if (!chip->set || !chip->set_debounce) {
>  	  pr_warn("%s: missing set() or set_debounce() operations\n",
>  		  __func__);
> +		return -EIO;
>  	}

BTW, I'm not sure that error-path should pr_warn(). For example, if this
error-patch is taken due to a call from
gpio_keys.c:gpio_keys_setup_key(), then a timer will be used for
debounce instead, which is all perfectly valid, and probably not
something that should be spewed to the kernel log.
