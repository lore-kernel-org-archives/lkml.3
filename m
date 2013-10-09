Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab3JILOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 07:14:50 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39028 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752502Ab3JILOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 07:14:48 -0400
Message-ID: <52553AA4.4000400@free-electrons.com>
Date: Wed, 09 Oct 2013 13:14:44 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Organization: Free Electrons
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: linux-pwm@vger.kernel.org, voice.shen@atmel.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] PWM: atmel-pwm: use request/free instead of enable/disable
References: <1380554553-25676-1-git-send-email-alexandre.belloni@free-electrons.com> <20131008120516.GA16196@ulmo.nvidia.com>
In-Reply-To: <20131008120516.GA16196@ulmo.nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 08/10/2013 14:05, Thierry Reding wrote:
> On Mon, Sep 30, 2013 at 05:22:33PM +0200, Alexandre Belloni wrote:
>> I found that disabling a pwm while it is at a low level will actually
put it
>> back at a high level. The main symptom is that leds-pwm is calling
pwm_disable()
>> after setting the duty cycle to 0. Hence, instead of getting a
switched off LED,
>> you get an LED lit up at full brightness.
>
> I wonder why that's the case. What's causing the PWM to go back to full
> duty cycle when disabled? There was a similar issue with some other PWM
> driver a while back and the cause was tracked down to be that you had to
> wait for a full period to make sure the signal was constantly low before
> switching off the clock. Perhaps something similar is the issue here?

I tried letting enabling/disabling the PWM channel in
pwm_enable/pwm_disable and enabling/disabling the clock in
pwm_request/pwm_free. The issue is still there.

- From the datasheet (also it seems something is fishy there, wrt CPOL):

"Waveforms are fixed at 0 when:
- - CDTY = CPRD and CPOL = 0
- - CDTY = 0 and CPOL = 1
Waveforms are fixed at 1 (once the channel is enabled) when:
- - CDTY = 0 and CPOL = 0
- - CDTY = CPRD and CPOL = 1
The waveform polarity must be set before enabling the channel. This
immediately affects the channel output level."

So, while I agree with you that it makes us keep the pwm clock enabled
forever, it makes me believe that we have to let the PWM enabled to get
that working correctly.


I also tried changing the polarity and setting pull down on the pin but
the level seems to be driven high. One thing that is working though is
setting the override value before disabling the PWM. Then the level that
is set is still kept when the pwm is disabled. Unfortunately, that
feature is only available since the sama5.

>
>> Solve that by using the request and free callbacks to enable and
disable the
>> pwm channels and the clock.
>
> "pwm" -> "PWM",  please.
>
>> diff --git a/drivers/pwm/pwm-atmel.c b/drivers/pwm/pwm-atmel.c
> [...]
>> +static int atmel_pwm_enable(struct pwm_chip *chip, struct pwm_device
*pwm)
>> +{
>> +    /*
>> +     * This is a dummy function, required to be able to register the pwm
>> +     * chip, see pwmadd_chip() in pwm/core.c
>> +     */
>> +    return 0;
>> +}
>> +
>> +static void atmel_pwm_disable(struct pwm_chip *chip, struct
pwm_device *pwm)
>> +{
>> +    /*
>> +     * This is a dummy function, required to be able to register the pwm
>> +     * chip, see pwmadd_chip() in pwm/core.c
>> +     */
>> +}
>
> This just doesn't feel right. Can somebody please investigate what the
> real reason is for the behaviour described in the commit message and see
> if we can't solve this in some other way? .request() and .free() are
> typically called very early or very late, respectively, so this patch
> will keep the PWM clock on forever (pretty much).
>
> Thierry


- -- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJSVTqjAAoJEKbNnwlvZCyzzE4P/igeF8UBUPdEQAYpgG3avTTh
93oEGu8sHoNSbUJY6O51x5f+96QiwrZF62rjy4PO8BtHR6fGgUt94RtyMacut/aY
NfRwdwfe24wYwHNpwOCv9uD1ZtiLyD9wAMeIEsoYy57A9XPPuuTOmJamN7jzsh/K
OvjdmjWcJQPymSTABdus4Zt7ccIgPqMsai8HQYiNqnKbPDUXx20/+QH5Kw2hPxi0
YPK36xEeEW0pB+v9fVU54abAV3Bh4tEOIJ/7wqWeDxN9WBK8LEG20pb6ZNFI3GJO
KzEO7Y4fZzPc85RCPfigyyDnOvzHRP5vc1vfSIOxwPqhZLZL6ceBlCHWhAr+CYSU
mWtNruBP9dhJfRDKtchDv3D63YBDip4DTDh/0jiqT6Qw6LTjSU+bWi1RVlrpa6HY
Wv6siL0gy4USKk8DJEl/pWBi3SlSbPynT+sZLKrWpz2E3oLjgDNALPIZtMM38xYj
X7LzZX1v8t6psksnH13Q4yAgyuiIUcJWXTn7wMPZ70DhJ98JpcsV3o9kZQnGTN+A
sp9/pZTd/7sK5LzZx+aMnMItNLgWy85LRLfHzH2c3vAKETVVPx+Vqgojw0sWMC8E
U3oA71/nYOFUssCs9kzCNvU/n7p16bGxyPzbHH2D+2CowiFdYVwJhX1iT4TFTkQJ
ymqGpRABiFB6bmhf4WRg
=zebD
-----END PGP SIGNATURE-----

