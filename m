Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512AbaK1Xr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 18:47:58 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:3029 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbaK1Xr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 18:47:56 -0500
X-IronPort-AV: E=Sophos;i="5.07,480,1413270000"; 
   d="scan'208";a="52034674"
Message-ID: <547909B0.2090408@broadcom.com>
Date: Fri, 28 Nov 2014 15:48:00 -0800
From: Arun Ramamurthy <arun.ramamurthy@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Tim Kryger <tim.kryger@gmail.com>, Scott Branden <sbranden@broadcom.com>
CC: Thierry Reding <thierry.reding@gmail.com>, Ray Jui <rjui@broadcom.com>,
        Arun Ramamurthy <arunrama@broadcom.com>,
        <bcm-kernel-feedback-list@broadcom.com>, <linux-pwm@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/4] pwm: kona: Fix incorrect enable after channel
 polarity change
References: <sbranden@broadcom.com>	<1416944441-12066-1-git-send-email-sbranden@broadcom.com>	<1416944441-12066-3-git-send-email-sbranden@broadcom.com> <CAD7vxxKgcu9QLY8qH8WR0b_5WBu+MNxcemmZ8syYa__JaC6tsQ@mail.gmail.com>
In-Reply-To: <CAD7vxxKgcu9QLY8qH8WR0b_5WBu+MNxcemmZ8syYa__JaC6tsQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 14-11-25 10:22 PM, Tim Kryger wrote:
> On Tue, Nov 25, 2014 at 11:40 AM, Scott Branden <sbranden@broadcom.com> wrote:
>> From: Arun Ramamurthy <arunrama@broadcom.com>
>>
>> The pwm core code requires a separate call for enabling the channel
>> and hence the driver does not need to set pwm_trigger after a
>> polarity change
>
> The framework does restrict when polarity changes can occur but it
> isn't clear to me that there is any reason to delay applying the
> polarity change.
I examined several other drivers such as pwm-atmel-tcb.c, pwm-ep93xx.c, 
pwm-renesas-tpu.c, pwm-samsung.c in the 3.17 kernel tree and none of 
them enable the channel after changing polarity. We would be the first 
driver to do so.

> Keep in mind that polarity matters even when a PWM
> is disabled.  While disabled, the output should be equivalent to an
> enabled configuration with zero duty.  Thus for normal polarity the
> output is constant low and for inversed polarity the output is
> constant high.
The driver does set the duty cycle to zero when disabling the pwm 
channel.However since the frame work prevents polarity change when the 
pwm is enabled, I don’t see how one could expect the polarity change to 
be reflected immediately without a separate call to pwm enable.


I believe there is an expectation that the output is
> updated to reflect the requested polarity change prior to returning to
> the caller.

Once again I disagree with this based on other pwm drivers which only 
change the polarity and do not enable the channel when their set 
polarity functions are called.

>
>>
>> Signed-off-by: Arun Ramamurthy <arunrama@broadcom.com>
>> Reviewed-by: Ray Jui <rjui@broadcom.com>
>> Signed-off-by: Scott Branden <sbranden@broadcom.com>
>> ---
>>   drivers/pwm/pwm-bcm-kona.c | 5 -----
>>   1 file changed, 5 deletions(-)
>>
>> diff --git a/drivers/pwm/pwm-bcm-kona.c b/drivers/pwm/pwm-bcm-kona.c
>> index 29eef9e..fa0b5bf 100644
>> --- a/drivers/pwm/pwm-bcm-kona.c
>> +++ b/drivers/pwm/pwm-bcm-kona.c
>> @@ -173,11 +173,6 @@ static int kona_pwmc_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
>>
>>          writel(value, kp->base + PWM_CONTROL_OFFSET);
>>
>> -       kona_pwmc_apply_settings(kp, chan);
>> -
>> -       /* Wait for waveform to settle before gating off the clock */
>> -       ndelay(400);
>> -
>>          clk_disable_unprepare(kp->clk);
>>
>>          return 0;
>> --
>> 2.1.3
>>
