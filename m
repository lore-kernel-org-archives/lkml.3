Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab3BLCwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 21:52:12 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:43180 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab3BLCwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 21:52:11 -0500
MIME-Version: 1.0
In-Reply-To: <20130211151038.8421aa54.akpm@linux-foundation.org>
References: <1360429077-14616-1-git-send-email-haojian.zhuang@linaro.org>
	<20130211151038.8421aa54.akpm@linux-foundation.org>
Date: Tue, 12 Feb 2013 10:52:10 +0800
Message-ID: <CAD6h2NRGiD=hDOjF8CBDrKuBZm-ALOdcj8mT=h6Cde4PuU=AHw@mail.gmail.com>
Subject: Re: [PATCH] driver core: add wait event for deferred probe
From: Haojian Zhuang <haojian.zhuang@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, viro@zeniv.linux.org.uk,
        rusty@rustcorp.com.au, hpa@linux.intel.com, jim.cromie@gmail.com,
        linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>, arnd@arndb.de,
        broonie@opensource.wolfsonmicro.com,
        Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 February 2013 07:10, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sun, 10 Feb 2013 00:57:57 +0800
> Haojian Zhuang <haojian.zhuang@linaro.org> wrote:
>
>> do_initcalls() could call all driver initialization code in kernel_init
>> thread. It means that probe() function will be also called from that
>> time. After this, kernel could access console & release __init section
>> in the same thread.
>>
>> But if device probe fails and moves into deferred probe list, a new
>> thread is created to reinvoke probe. If the device is serial console,
>> kernel has to open console failure & release __init section before
>> reinvoking failure. Because there's no synchronization mechanism.
>> Now add wait event to synchronize after do_initcalls().
>
> It sounds like this:
>
> static int __ref kernel_init(void *unused)
> {
>         kernel_init_freeable();
>         /* need to finish all async __init code before freeing the memory */
>         async_synchronize_full();
>
> is designed to prevent the problem you describe?
>
It can't prevent the problem that I described. Because deferred_probe()
is introduced recently.

All synchronization should be finished just after do_initcalls(). Since
load_default_modules() is also called in the end of kernel_init_freeable(),
I'm not sure that whether I could remove async_synchronize_full()
here. So I didn't touch it.

>> --- a/init/main.c
>> +++ b/init/main.c
>> @@ -786,6 +786,7 @@ static void __init do_basic_setup(void)
>>       do_ctors();
>>       usermodehelper_enable();
>>       do_initcalls();
>> +     wait_for_device_probe();
>>  }
>
> Needs a nice comment here explaining what's going on.

No problem. I'll add comment here.

Regards
Haojian
