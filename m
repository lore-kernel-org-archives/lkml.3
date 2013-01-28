Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab3A1QO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:14:58 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:57338 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841Ab3A1QO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 11:14:56 -0500
Message-ID: <5106A39A.5010402@ti.com>
Date: Mon, 28 Jan 2013 18:13:14 +0200
From: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: [RFC PATCH] Input: gpio_keys: Fix suspend/resume press event
 lost
References: <1358774114-8281-1-git-send-email-ivan.khoronzhuk@ti.com> <20130121235718.GB16638@core.coreip.homeip.net> <20130122162434.5bcf3e14@notabene.brown>
In-Reply-To: <20130122162434.5bcf3e14@notabene.brown>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.128]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2013 07:24 AM, NeilBrown wrote:
> On Mon, 21 Jan 2013 15:57:18 -0800 Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
>
>> Hi Ivan,
>>
>> On Mon, Jan 21, 2013 at 03:15:14PM +0200, Ivan Khoronzhuk wrote:
>>> Rebased on linux_omap/master.
>>>
>>> During suspend/resume the key press can be lost if time of resume
>>> sequence is significant.
>>>
>>> If press event cannot be remembered then the driver can read the
>>> current button state only in time of interrupt handling. But in some
>>> cases when time between IRQ and IRQ handler is significant we can
>>> read incorrect state. As a particular case, when device is in suspend
>>> we press wakupable key and up it back in a jiffy, the interrupt
>>> handler read the state of up but the interrupt source is press indeed.
>>> As a result, in a OS like android, we resume then suspend right away
>>> because the key state is not changed.
>>>
>>> This patch add to gpio_keys framework opportunity to recover lost of
>>> press key event at resuming. The variable "key_pressed" from
>>> gpio_button_data structure is not used for gpio keys, it is only used
>>> for gpio irq keys, so it is logically used to remember press lost
>>> while resuming.
>> The same could happen if you delay processing of interrupt long enough
>> during normal operation. If key is released by the time you get around
>> to reading it you will not see a key press.
>>
>> To me this sounds like you need to speed up your resume process so that
>> you can start serving interrupts quicker.
>>
> Agreed.  When I was looking at this I found that any genuine button press
> would have at least 70msec between press and release, while the device could
> wake up to the point of being able to handle interrupts in about 14msec.
> That is enough of a gap to make it pointless to try to 'fix' the code.
>
> With enough verbose debugging enabled that 14msec can easily grow to
> hundreds, but then if  you have debugging enabled to can discipline yourself
> to hold the button for longer.
>
> Ivan: What sort of delay are you seeing between the button press and the
> interrupt routine running?  And can you measure how long the button is
> typically down for?
>
> NeilBrown

In my case I have the delay between the button press and the ISR
about 145ms. If the button down for 120ms the IRQ press event is
lost and if 160ms event is captured. I cannot speed up resume
process enough to guarantee correct work, so I wrote this fix.

-- 
Regards,
Ivan Khoronzhuk

