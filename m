Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbaEGIjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:39:37 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:52585 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819AbaEGIje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:39:34 -0400
MIME-Version: 1.0
In-Reply-To: <20140507081850.GB6362@ulmo>
References: <1393480414-19473-1-git-send-email-acourbot@nvidia.com>
 <1393480414-19473-3-git-send-email-acourbot@nvidia.com> <20140507081850.GB6362@ulmo>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 7 May 2014 17:39:13 +0900
Message-ID: <CAAVeFuKWoom82aMmPipkeqeAoNfz35bNTOs3deoYeNXZ0jq0cQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] pwm-backlight: switch to gpiod interface
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>, Jingoo Han <jg1.han@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2014 at 5:18 PM, Thierry Reding <thierry.reding@gmail.com> wrote:
> On Thu, Feb 27, 2014 at 02:53:34PM +0900, Alexandre Courbot wrote:
>> Switch to the new gpiod interface, which allows to handle GPIO
>> properties such as active low transparently and removes a whole bunch of
>> code.
>>
>> There are still a couple of users of this driver that rely on passing
>> the enable GPIO number through platform data, so a fallback mechanism
>> using a GPIO number is still available to avoid breaking them. It will
>> be removed once current users have switched to the GPIO lookup tables
>> provided by the gpiod interface.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> ---
>>  drivers/video/backlight/pwm_bl.c | 72 +++++++++++++++++-----------------------
>>  include/linux/pwm_backlight.h    |  5 +--
>>  2 files changed, 32 insertions(+), 45 deletions(-)
>
> I've applied this with two tiny changes, see below. Please shout if you
> think that's a bad idea.

I'm fine with both changes. Thanks for picking these two guys!

Alex.

>
>> diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
> [...]
>> @@ -256,8 +238,6 @@ static int pwm_backlight_probe(struct platform_device *pdev)
> [...]
>> +     pb->enable_gpio = devm_gpiod_get(&pdev->dev, "enable");
>> +     if (IS_ERR(pb->enable_gpio)) {
>> +             ret = PTR_ERR(pb->enable_gpio);
>> +             if (ret == -ENOENT) {
>> +                     pb->enable_gpio = NULL;
>> +                     ret = 0;
>> +             } else {
>> +                     goto err_alloc;
>> +             }
>
> I dropped the ret = 0 here because all error paths set it explicitly and
> the non-error path never uses it. Now all branches have a single
> statement and therefore the braces can be dropped.
>
>> +     /*
>> +      * Compatibility fallback for drivers still using the integer GPIO
>> +      * platform data. Must go away soon.
>> +      */
>> +     if (pb->enable_gpio == NULL && gpio_is_valid(data->enable_gpio)) {
>
> Changed the first condition to !pb->enable_gpio for consistency.
>
> Thierry
