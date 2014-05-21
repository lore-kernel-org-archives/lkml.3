Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaEUMEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 08:04:33 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:39557 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbaEUMEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 08:04:30 -0400
MIME-Version: 1.0
In-Reply-To: <20140521102515.GJ2708@katana>
References: <1398350916-885-1-git-send-email-ch.naveen@samsung.com>
 <20140424162558.GB12304@sirena.org.uk> <CAHfPSqB5+mLiC07jbEpeUgW63pZVk700SkYGxToO7GRAsFm_nQ@mail.gmail.com>
 <20140509135153.GM12304@sirena.org.uk> <CAHfPSqDSTyQXPT-NCZ2hE01qpdmaR54tbWCUYC_zSDGFp58+7g@mail.gmail.com>
 <20140509145425.GP12304@sirena.org.uk> <20140521102515.GJ2708@katana>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Wed, 21 May 2014 17:34:09 +0530
Message-ID: <CAHfPSqCOnW4YGPfMfpBMbLSaiSxRN=CHJK6kYdkXMujKvNwAPA@mail.gmail.com>
Subject: Re: [PATCH] i2c: exynos5: Initialise Samsung High Speed I2C
 controller early
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Mark Brown <broonie@kernel.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        sjg@chromium.org, grundler@chromium.org, linux-kernel@vger.kernel.org,
        cpgs@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Wolfram,

On 21 May 2014 15:55, Wolfram Sang <wsa@the-dreams.de> wrote:
> On Fri, May 09, 2014 at 03:54:25PM +0100, Mark Brown wrote:
>> On Fri, May 09, 2014 at 08:12:47PM +0530, Naveen Krishna Ch wrote:
>> > On 9 May 2014 19:21, Mark Brown <broonie@kernel.org> wrote:
>> > > On Fri, May 09, 2014 at 05:50:00PM +0530, Naveen Krishna Ch wrote:
>>
>> > >> DRM related drivers like DP, FIMD, HDMI, Mixer wants to be probed ASAP
>> > >> during the boot.
>> > >> The real problem comes when, one of these drivers do a regulator_get().
>>
>> > >> If the physical supply  is not enabled/hookedup the regulator_get() call
>> > >> assumes that physical supply is present and returns a
>> > >> "dummy_regulator" (But, not an error).
>>
>> > >> Because of which, Display and several other devices fails to work.
>>
>> > > These drivers are buggy, if they geniunely expect and handle a missing
>> > > supply then they should be using regulator_get_optional() to request the
>> > > regulator and even if they don't the use of subsys_initcall() is not
>> > > going to fix anything here - if a dummy regulator is going to be
>> > > returned the time things are probed won't make a difference.
>>
>> ...
>>
>> > If all the I2C, SPI, DMA, I2C_TUNNEL, DRM based LCD are all mod_probes()
>> > DRM drivers are probing a head of the PMIC probe. Which is causing the
>> > display drivers to get "dummy_regulators" instead of the real supplies.
>>
>> No, it really won't - I have no idea what you are doing but it's not
>> mainline.  If you are getting dummy regulators then you don't have a
>> supply present at all and probe ordering isn't going to make a blind
>> bit of difference.
>>
>> Please provide a specific technical description of the problem you are
>> seeing in mainline.
>
> +1 Unless we have a clear understanding that this is the only acceptable
> solution in mainline, this is really an out-of-tree patch.

Few of the DRM based devices need regulators during their probe and
DRM subsystem
wants to bring up LCD as fast as it could to give a better user experience.

Exynos DRM (few others for that matter) does platform_driver_register()
of devices in a sequence and finally binds them all together into one
blob or /dev/dri-0 device.
Which makes it hard to implement -EPROBE_DEFER. Even if -EPROBE_DEFER is
implemented in DRM, it adds lot of overhead during the boot up.

I've proposed to make exynos_drm_init() as late_initcall() instead of making
I2C, SPI, DMA and I2C-arbitrator and I2C-TUNNEL drivers as subsys_initcall()

http://www.spinics.net/lists/linux-samsung-soc/msg30858.html

Kindly, suggest a workable approach for all the subsystems.
>

-- 
Shine bright,
(: Nav :)
