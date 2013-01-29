Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab3A2MKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 07:10:45 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33521 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756552Ab3A2MKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 07:10:40 -0500
Message-ID: <5107BC2B.5080400@ti.com>
Date: Tue, 29 Jan 2013 13:10:19 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130115 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH 1/4] pwm_backlight: Fix PWM levels support in non DT case
References: <1358861996-27194-1-git-send-email-peter.ujfalusi@ti.com> <1358861996-27194-2-git-send-email-peter.ujfalusi@ti.com> <20130128210123.GA24673@avionic-0098.mockup.avionic-design.de> <51078580.2000808@ti.com> <20130129101709.GC16746@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130129101709.GC16746@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2013 11:17 AM, Thierry Reding wrote:
> On Tue, Jan 29, 2013 at 09:17:04AM +0100, Peter Ujfalusi wrote:
>> On 01/28/2013 10:01 PM, Thierry Reding wrote:
>>> On Tue, Jan 22, 2013 at 02:39:53PM +0100, Peter Ujfalusi wrote:
>>>> It is expected that board files would have:
>>>> static unsigned int bl_levels[] = { 0, 50, 100, 150, 200, 250, };
>>>>
>>>> static struct platform_pwm_backlight_data bl_data = {
>>>> 	.levels = bl_levels,
>>>> 	.max_brightness = ARRAY_SIZE(bl_levels),
>>>> 	.dft_brightness = 4,
>>>> 	.pwm_period_ns = 7812500,
>>>> };
>>>>
>>>> In this case the max_brightness would be out of range in the levels array.
>>>> Decrement the received max_brightness in every case (DT or non DT) when the
>>>> levels has been provided.
>>>
>>> What's wrong with specifying .max_brightness = ARRAY_SIZE(bl_levels) - 1
>>> instead?
>>
>> There is nothing wrong with that either but IMHO it is more natural for board
>> files to use just ARRAY_SIZE(bl_levels). In this way the handling of
>> data->max_brightness among non DT and DT booted kernel is more uniform in the
>> driver itself.
> 
> The .max_brightness field is defined to be the maximum value that you
> can set the brightness to. If you use .levels and set .max_brightness to
> ARRAY_SIZE() then that's no longer true because the maximum value for
> the brightness will actually be ARRAY_SIZE() - 1.

Yes, in conjunction with .levels it would be better to have .nr_levels instead
reusing the max_brightness.

> The reason why in the DT case we decrement .max_brightness is that it is
> used as a temporary variable to keep the number of levels, which
> corresponds to ARRAY_SIZE() in your example, and adjust it later on to
> match the definition. That's an implementation detail.
> 
> Platform data content should be encoded properly without knowledge of
> the internal implementation.
> 
>> Right now all board files are using only the .max_brightness to specify the
>> maximum value, I could not find any users of .levels in the kernel.
> 
> Yes. But this is the legacy mode which should be considered deprecated.
> The reason why the concept of brightness-levels was introduced back when
> the DT bindings were created was that pretty much no hardware in
> existence actually works that way. This was a topic of discussion at the
> time when I first proposed these changes, see for example:
> 
> 	http://www.mail-archive.com/devicetree-discuss@lists.ozlabs.org/msg09472.html

Right. Now I know the background.
However I do not agree with the conclusion. Probably it is fine in some cases
to limit the number of configurable duty cycles to have only distinct steps.
To not go too far, on my laptop I have:
# cat /sys/class/backlight/acpi_video0/max_brightness
15
# cat /sys/class/backlight/intel_backlight/max_brightness
93

In this case I would be more happier if the user space would use the
intel_backlight than the acpi_video0. I'm fine if user space decides to allow
me only 15 distinct steps on the intel_backlight but I would expect it to do
so in a way when I change the brightness in the UI it would step down or up to
the next user configurable level. Right now it uses the acpi_video0 to control
the levels which means that I have (ugly) jumps in the backlight every time I
adjust it.

In my phone and tablet all transitions between backlight levels are smooth.
This is not a case in my laptop (with exception when the backlight is set to
auto, FW controlled).

The perceived brightness change depends on the surrounding environment, you
can not say that in high level you would need less steps or you need to have
less steps in low brightness. If you in a dark room the low changes can be
observed, while the same change when you are outside in a sunny day would not
reflect the same.

Sure we could do the ramps in driver, but what are the parameters? how many
step between the two level? What is the time between the steps?

If you are about to make a product you will end up specifying all the possible
steps to provide the best user experience. So if the PWM have 127 duty cycle
you will have levels from 0, 1, 2, 3, ...., 125, 126, 127.

-- 
Péter
