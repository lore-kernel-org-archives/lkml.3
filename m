Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbaFSWnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 18:43:51 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:44604 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077AbaFSWnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 18:43:49 -0400
MIME-Version: 1.0
In-Reply-To: <7h8uosyc3k.fsf@paris.lan>
References: <1403155273-1057-1-git-send-email-dianders@chromium.org>
	<7h8uosyc3k.fsf@paris.lan>
Date: Thu, 19 Jun 2014 15:43:48 -0700
X-Google-Sender-Auth: jtu3FfAADDxZ_cE3l5EKKlnjOTM
Message-ID: <CAD=FV=XxNVmF+N5HF4SnZoJRJvkSUkpEx6ct4v2gtmAQ9n28-Q@mail.gmail.com>
Subject: Re: [PATCH] i2c: exynos5: Properly use the "noirq" variants of suspend/resume
From: Doug Anderson <dianders@chromium.org>
To: Kevin Hilman <khilman@linaro.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, Kukjin Kim <kgene.kim@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        naveen krishna <ch.naveen@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>, Jean Delvare <jdelvare@suse.de>,
        Simon Glass <sjg@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>, standby24x7@gmail.com,
        Sachin Kamat <sachin.kamat@linaro.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin,

On Thu, Jun 19, 2014 at 11:43 AM, Kevin Hilman <khilman@linaro.org> wrote:
> Doug Anderson <dianders@chromium.org> writes:
>
>> The original code for the exynos i2c controller registered for the
>> "noirq" variants.  However during review feedback it was moved to
>> SIMPLE_DEV_PM_OPS without anyone noticing that it meant we were no
>> longer actually "noirq" (despite functions named
>> exynos5_i2c_suspend_noirq and exynos5_i2c_resume_noirq).
>>
>> i2c controllers that might have wakeup sources on them seem to need to
>> resume at noirq time so that the individual drivers can actually read
>> the i2c bus to handle their wakeup.
>
> I suspect usage of the noirq variants pre-dates the existence of the
> late/early callbacks in the PM core, but based on the description above,
> I suspect what you actually want is the late/early callbacks.

I think it actually really needs noirq.  ;)

Specifically as soon as IRQs are enabled one of our children might get
an interrupt.  To respond to that interrupt it might want to do an i2c
transfer.

Here's a snippet from me moving it to "resume early".  You can see
that max77686 failed pretty much right away (the dummy is just the
max77686 RTC for various reasons).  Note that the max77686 isn't doing
anything tricky.  It uses regmap_irq (as per Javier's patches) and
calls enable_irq_wake() at suspend time.  It uses a simple threaded
IRQ:

[  117.968055] PM: noirq resume of devices complete after 1.391 msecs
[  117.968200] max77686 0-0009: Failed to read IRQ status: -5
[  117.968697] dummy 0-0006: Failed to read IRQ status: -5
[  117.968793] calling  12c60000.i2c+ @ 5891, parent: none
[  117.968805] s3c-i2c 12c60000.i2c: slave address 0x00
[  117.968814] s3c-i2c 12c60000.i2c: bus frequency set to 378 KHz
[  117.968824] call 12c60000.i2c+ returned 0 after 23 usecs
[  117.968831] calling  12c70000.i2c+ @ 5891, parent: none
[  117.968841] s3c-i2c 12c70000.i2c: slave address 0x00
[  117.968849] s3c-i2c 12c70000.i2c: bus frequency set to 378 KHz
[  117.968858] call 12c70000.i2c+ returned 0 after 20 usecs
[  117.968864] calling  12c80000.i2c+ @ 5891, parent: none
[  117.968874] s3c-i2c 12c80000.i2c: slave address 0x00
[  117.968882] s3c-i2c 12c80000.i2c: bus frequency set to 65 KHz
[  117.968891] call 12c80000.i2c+ returned 0 after 20 usecs
[  117.968897] calling  12c90000.i2c+ @ 5891, parent: none
[  117.968907] s3c-i2c 12c90000.i2c: slave address 0x00
[  117.968915] s3c-i2c 12c90000.i2c: bus frequency set to 65 KHz
[  117.968923] call 12c90000.i2c+ returned 0 after 19 usecs
[  117.968930] calling  12ca0000.i2c+ @ 5891, parent: none
[  117.968940] s3c-i2c 12ca0000.i2c: slave address 0x00
[  117.968948] s3c-i2c 12ca0000.i2c: bus frequency set to 65 KHz
[  117.968957] call 12ca0000.i2c+ returned 0 after 20 usecs
[  117.968964] calling  12cb0000.i2c+ @ 5891, parent: none
[  117.968974] s3c-i2c 12cb0000.i2c: slave address 0x00
[  117.968982] s3c-i2c 12cb0000.i2c: bus frequency set to 65 KHz
[  117.968990] call 12cb0000.i2c+ returned 0 after 20 usecs
[  117.968997] calling  12cd0000.i2c+ @ 5891, parent: none
[  117.969006] s3c-i2c 12cd0000.i2c: slave address 0x00
[  117.969014] s3c-i2c 12cd0000.i2c: bus frequency set to 65 KHz
[  117.969022] call 12cd0000.i2c+ returned 0 after 19 usecs
[  117.969029] calling  12ce0000.i2c+ @ 5891, parent: none
[  117.969039] s3c-i2c 12ce0000.i2c: slave address 0x00
[  117.969048] s3c-i2c 12ce0000.i2c: bus frequency set to 378 KHz
[  117.969056] call 12ce0000.i2c+ returned 0 after 20 usecs
[  117.969625] PM: early resume of devices complete after 1.469 msecs
