Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbaJUGq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 02:46:29 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:60020 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaJUGq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 02:46:27 -0400
Message-ID: <54460140.50805@gmail.com>
Date: Tue, 21 Oct 2014 08:46:24 +0200
From: =?UTF-8?B?UGhpbGlwcGUgUsOpdG9ybmF6?= <philippe.retornaz@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org
CC: linux-pm@vger.kernel.org, Alan Cox <gnomes@lxorguk.ukuu.org.uk>,
        Alexander Graf <agraf@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Heiko Stuebner <heiko@sntech.de>, Lee Jones <lee.jones@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH v2 01/47] kernel: Add support for poweroff handler call
 chain
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net> <1413864783-3271-2-git-send-email-linux@roeck-us.net>
In-Reply-To: <1413864783-3271-2-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

[...]
> - Use raw notifiers protected by spinlocks instead of atomic notifiers
[...]

> +/**
> + *	do_kernel_power_off - Execute kernel poweroff handler call chain
> + *
> + *	Calls functions registered with register_power_off_handler.
> + *
> + *	Expected to be called from machine_power_off as last step of
> + *	the poweroff sequence.
> + *
> + *	Powers off the system immediately if a poweroff handler function
> + *	has been registered. Otherwise does nothing.
> + */
> +void do_kernel_power_off(void)
> +{
> +	spin_lock(&power_off_handler_lock);
> +	raw_notifier_call_chain(&power_off_handler_list, 0, NULL);
> +	spin_unlock(&power_off_handler_lock);
> +}

I don't get it. You are still in atomic context inside the poweroff callback
since you lock it with a spinlock.

It does not change much from the atomic notifier which was doing exactly the
same thing but with RCU:

    rcu_read_lock();
    ret = notifier_call_chain(&nh->head, val, v, nr_to_call, nr_calls);
    rcu_read_unlock();

Why not using the blocking_notifier_* family ?
It will lock with a read-write semaphore under which you can sleep.

For instance, twl4030_power_off will sleep, since it is doing I2C access.
So you cannot call it in atomic context.

Thanks,

Philippe

