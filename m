Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400Ab3IKLlC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 07:41:02 -0400
Received: from smtp.newsguy.com ([74.209.136.69]:52628 "EHLO smtp.newsguy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182Ab3IKLlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 07:41:00 -0400
Message-ID: <523056A6.5060000@newsguy.com>
Date: Wed, 11 Sep 2013 04:40:22 -0700
From: Mike Dunn <mikedunn@newsguy.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-pwm@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Robert Jarzmik <robert.jarzmik@free.fr>,
        Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] pwm-backlight: add support for device tree gpio control
References: <1378236372-15711-1-git-send-email-mikedunn@newsguy.com> <20130910172130.GC22111@ulmo>
In-Reply-To: <20130910172130.GC22111@ulmo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 10:21 AM, Thierry Reding wrote:
> On Tue, Sep 03, 2013 at 12:26:12PM -0700, Mike Dunn wrote:
>> This patch adds support for controlling an arbitrary number of gpios to the
>> pwm-backlight driver.  This was left as a TODO when initial device tree support
>> was added by Thierry a while back.  This functionality replaces the callbacks
>> that are passed in the platform data for non-DT cases.  Users can avail
>> themselves of this feature by adding a 'gpios' property to the 'backlight' node.
>> When the update_status() callback in backlight_ops runs, the gpios listed in the
>> property are asserted/deasserted if the specified brightness is non-zero/zero.
>>
>> Tested on a pxa270-based Palm Treo 680.
>>
>> Signed-off-by: Mike Dunn <mikedunn@newsguy.com>
>> ---
>>
>> Thanks for looking!
>>
>>  .../bindings/video/backlight/pwm-backlight.txt     |   4 +
>>  drivers/video/backlight/pwm_bl.c                   | 128 ++++++++++++++++++---
>>  2 files changed, 113 insertions(+), 19 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
>> index 1e4fc72..4583e68 100644
>> --- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
>> +++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
>> @@ -14,6 +14,9 @@ Required properties:
>>  Optional properties:
>>    - pwm-names: a list of names for the PWM devices specified in the
>>                 "pwms" property (see PWM binding[0])
>> +  - gpios:     An arbitrary number of gpios that must be asserted when the
>> +               backlight is on, and de-asserted when off.  They will be asserted
>> +               in the order they appear, and de-asserted in reverse order.
> 
> Do you have a real setup that actually needs multiple GPIOs? Usually
> such a setup requires some kind of timing or other additional constraint
> which can't be represented by this simple binding.
> 
> Looking at the Palm Treo code it seems like the reason why multiple
> GPIOs are needed is because one is to enable the backlight, while the
> other is in fact used to enable the LCD panel. 


There are actually four GPIOs involved!  (There is an embarrasingly horrible
hack in arch/arm/mach-pxa/palmtreo.c that handles the others.)  One is almost
certainly simply backlight power.  The other three are probably LCD related.
Timing doesn't seem to be an issue, but the order is important.  This is
reverse-engineered without any schematics, and honestly, I'm still guessing with
regard to how the board is wired.  It probably is not appropriate to manage all
four gpios in the backlight driver, but at least one needs to be, so I thought
I'd go ahead and prepare a patch that adds gpio support.  From what you are
telling me, I guess my approach was too simplistic.


> I have been working on a
> patch series to provide simple panel support, specifically to allow the
> separation of backlight and panel power sequencing. Would such a method
> work for your use-case as well? 


Sounds like it would, from what I know.


> The work that I'm doing is somewhat DRM
> centric, and I don't think there's a DRM driver for PXA, but perhaps it
> would be a good occasion to look at converting the PXA display drivers
> to DRM... =)


OK, thanks.  I'll look into it.  I'm clueless about DRM...  All I can say at
this point is that I'm not using X windows, and there is not really any hardware
acceleration in the pxa's lcd controller.


> 
> That said, I've had a patch similar to yours in a local tree (in fact in
> the same branch as the panel work I've been doing) for quite some time,
> which allows a single "enable" GPIO to be specified. I haven't gotten
> around to sending it out yet, but I'll do that shortly. The patch is a
> little more involved because it exposes the GPIO via platform data as
> well and therefore has to update a number of board files, too. While
> going over the various board files I found only a single board which can
> actually make use of the new functionality (which I also converted in
> the patch). Any other cases couldn't be implemented by the simple change
> so I suspect they can't either using your proposed binding.


Really?  Are we talking about the callbacks in struct
platform_pwm_backlight_data?  I thought the majority of them just
requested/released a gpio in init()/exit(), and wiggled it in notify().  I must
be missing something.


> 
> I've been trying for a while to come up with a way to support more use-
> cases, and I keep coming back to the same solution. Since the DT binding
> for power sequences was shot down some time ago, we probably have to
> represent any kind of sequencing in C code. So instead of trying to fit
> everything into a single binding, I think a more maintainable solution
> would be to create separate drivers for the more complex use-cases. That
> could either be done by using separate compatible values within the
> pwm-backlight driver or via completely different drivers. In the latter
> case we should probably think about exporting some of the pwm-backlight
> functionality so that drivers can easily reuse some of the code.


I guess I'll wait for your patch and for everything else to shake out... I may
be able to help out if you want to delegate some things.  Thanks for the reviews
and the info.  Any other pointers appreciated.  BTW, I'm working on a simple
patch to the pwm-backlight driver that will fix my inverted pwm output problem.

Thanks again,
Mike
