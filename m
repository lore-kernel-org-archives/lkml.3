Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419AbaHGJyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 05:54:21 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:42730 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932AbaHGJyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 05:54:18 -0400
MIME-Version: 1.0
In-Reply-To: <20140731115644.GB12627@ulmo>
References: <1406806970-12561-1-git-send-email-thierry.reding@gmail.com>
	<20140731115644.GB12627@ulmo>
Date: Thu, 7 Aug 2014 15:24:17 +0530
Message-ID: <CAEC9eQNRCRBr7THFdu9=qtzcTn=oxVO8jRQWL3WCa8q70aagTQ@mail.gmail.com>
Subject: Re: [RFC] pwm-backlight: Allow backlight to remain disabled on boot
From: Ajay kumar <ajaynumb@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Eric Miao <eric.y.miao@gmail.com>,
        Ajay Kumar <ajaykumar.rs@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

Thanks for adding me.

On Thu, Jul 31, 2014 at 5:26 PM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> Cc'ing Ajay (who raised this on a different thread recently), therefore
> quoting all of the original email.
>
> Thierry
>
> On Thu, Jul 31, 2014 at 01:42:50PM +0200, Thierry Reding wrote:
>> From: Thierry Reding <treding@nvidia.com>
>>
>> The default for backlight devices is to be enabled immediately when
>> registering with the backlight core. This can be useful for setups that
>> use a simple framebuffer device and where the backlight cannot otherwise
>> be hooked up to the panel.
>>
>> However, when dealing with more complex setups, such as those of recent
>> ARM SoCs, this can be problematic. Since the backlight is usually setup
>> separately from the display controller, the probe order is not usually
>> deterministic. That can lead to situations where the backlight will be
>> powered up and the panel will show an uninitialized framebuffer.
>>
>> Furthermore, subsystems such as DRM have advanced functionality to set
>> the power mode of a panel. In order to allow such setups to power up the
>> panel at exactly the right moment, a way is needed to prevent the
>> backlight core from powering the backlight up automatically when it is
>> registered.
>>
>> This commit introduces a new boot_off field in the platform data (and
>> also implements getting the same information from device tree). When set
>> the initial backlight power mode will be set to "off".
>>
>> Signed-off-by: Thierry Reding <treding@nvidia.com>
>> ---
>> I've been meaning to send this for a while but was always holding back
>> because of the indoctrination that this type of configuration shouldn't
>> be part of device tree. However this issue was recently raised again in
>> the context of power up sequences for display panels. As described above
>> the issue is that panel datasheets recommend that the backlight attached
>> to a panel be turned on at the very last step to avoid visual glitches
>> during the panel's power up sequence. With the current implementation it
>> is typical for the backlight to be probed before the display panel. That
>> has, in many cases, the side-effect of enabling the backlight, therefore
>> making the screen content visible before it's actually initialized.
>>
>> Some panels come up with random garbage when uninitialized, others show
>> all white. With some luck the panel will be all black and users won't
>> really notice.
Right, most of the DSI panels are lucky. But the case is not the same
with few eDP/LVDS panels.

>> This patch is an attempt to enable boards to override the default of
>> turning on the backlight for the pwm-backlight driver. I'm not sure if
>> there was a specific reason to turn on the backlight by default when
>> this driver was initially written, but the fact is that since it has
>> pretty much always been like this we can't really go and change the
>> default, otherwise a lot of people may end up with no backlight and no
>> clue as to how to enable it. So the only reasonable thing we can do is
>> to keep the old behaviour and give new boards a way to override it if
>> they know that some other part of the stack will enable it at the right
>> moment.
Agreed! And, I have tested this patch.
This resolves the only remaining problem for display on peach_pi.
I cannot see the boot time glitch anymore :)

Ajay

>>  .../devicetree/bindings/video/backlight/pwm-backlight.txt         | 1 +
>>  drivers/video/backlight/pwm_bl.c                                  | 8 ++++++++
>>  include/linux/pwm_backlight.h                                     | 2 ++
>>  3 files changed, 11 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
>> index 764db86d441a..65e001a1733d 100644
>> --- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
>> +++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
>> @@ -17,6 +17,7 @@ Optional properties:
>>                 "pwms" property (see PWM binding[0])
>>    - enable-gpios: contains a single GPIO specifier for the GPIO which enables
>>                    and disables the backlight (see GPIO binding[1])
>> +  - backlight-boot-off: keep the backlight disabled on boot
>>
>>  [0]: Documentation/devicetree/bindings/pwm/pwm.txt
>>  [1]: Documentation/devicetree/bindings/gpio/gpio.txt
>> diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
>> index d7a3d13e72ec..62adfc9d37a7 100644
>> --- a/drivers/video/backlight/pwm_bl.c
>> +++ b/drivers/video/backlight/pwm_bl.c
>> @@ -173,6 +173,8 @@ static int pwm_backlight_parse_dt(struct device *dev,
>>               data->max_brightness--;
>>       }
>>
>> +     data->boot_off = of_property_read_bool(node, "backlight-boot-off");
>> +
>>       return 0;
>>  }
>>
>> @@ -317,6 +319,12 @@ static int pwm_backlight_probe(struct platform_device *pdev)
>>       }
>>
>>       bl->props.brightness = data->dft_brightness;
>> +
>> +     if (data->boot_off)
>> +             bl->props.power = FB_BLANK_POWERDOWN;
>> +     else
>> +             bl->props.power = FB_BLANK_UNBLANK;
>> +
>>       backlight_update_status(bl);
>>
>>       platform_set_drvdata(pdev, bl);
>> diff --git a/include/linux/pwm_backlight.h b/include/linux/pwm_backlight.h
>> index efdd9227a49c..1fc14989da4a 100644
>> --- a/include/linux/pwm_backlight.h
>> +++ b/include/linux/pwm_backlight.h
>> @@ -15,6 +15,8 @@ struct platform_pwm_backlight_data {
>>       unsigned int *levels;
>>       /* TODO remove once all users are switched to gpiod_* API */
>>       int enable_gpio;
>> +     bool boot_off;
>> +
>>       int (*init)(struct device *dev);
>>       int (*notify)(struct device *dev, int brightness);
>>       void (*notify_after)(struct device *dev, int brightness);
>> --
>> 2.0.3
>>
