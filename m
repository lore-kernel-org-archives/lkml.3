Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab3KKTdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 14:33:37 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:49081 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321Ab3KKTd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 14:33:27 -0500
Message-ID: <52813100.1060500@wwwdotorg.org>
Date: Mon, 11 Nov 2013 12:33:20 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Gerlando Falauto <gerlando.falauto@keymile.com>
CC: Mark Brown <broonie@kernel.org>, Lars Poeschel <poeschel@lemonage.de>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH v3] gpio: interrupt consistency check for OF GPIO IRQs
References: <1377526030-32024-1-git-send-email-larsi@wh2.tu-dresden.de> <1521079.WSLhhfqBXl@lem-wkst-02> <52261BF0.4090106@wwwdotorg.org> <3144247.j2q6H0KWZx@lem-wkst-02> <52279524.8090006@wwwdotorg.org> <20130909161924.GT29403@sirena.org.uk> <528121D5.40403@keymile.com> <528127B2.80109@wwwdotorg.org> <52812D3A.2070107@keymile.com>
In-Reply-To: <52812D3A.2070107@keymile.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 12:17 PM, Gerlando Falauto wrote:
> Hi Stephan,
> 
> On 11/11/2013 07:53 PM, Stephen Warren wrote:
>> On 11/11/2013 11:28 AM, Gerlando Falauto wrote:
>>> Hi everyone,
>>>
>>> [jumping in on an old discussion]
>>>
>>> On 09/09/2013 06:19 PM, Mark Brown wrote:
>>>> On Wed, Sep 04, 2013 at 02:16:36PM -0600, Stephen Warren wrote:
>>>>> On 09/04/2013 03:05 AM, Lars Poeschel wrote:
>>>>
>>>>>> The driver that tries to use the GPIO requested by this patch before
>>>>>> HAS to
>>>>>> fail. This is exactly the intention of this patch. We don't want the
>>>>>> GPIO to
>>>>>> be requested any more, if it is used as an interrupt pin.
>>>>
>>>>> That will break existing drivers. There are drivers that request the
>>>>> same GPIO and IRQ. IIRC, the SDHCI CD (Card Detect) GPIO is requested
>>>>> that way.
>>>>
>>>> Yes, plus input devices and audio jack detection among others.  This
>>>> pattern is very common if the GPIO is actually being used as a GPIO, an
>>>> edge triggered interrupt is used to flag when something happens and the
>>>> state is determined by reading the GPIO state (often with some
>>>> debounce).
>>>
>>> I actually came across this thread while looking for an answer to the
>>> following (apparently trivial) question:
>>>
>>> If you were to write a new driver & binding, what would be, in general,
>>> the recommended DT binding for a cascade interrupt controller (or any
>>> other peripheral, for that matter), which is connected through a GPIO
>>> (to be used as IRQ)?
>>>
>>> a) Through gpios = <&gpio0 N>
>>> b) through interrupt-parent = <&gpio0> & interrupts <N
>>> IRQ_TYPE_LEVEL_LOW>, or
>>> c) both?
>>
>> (b) alone.
>>
>>  From the perspective of the child interrupt controller, its output is
>> purely an interrupt. The fact that the parent interrupt controller could
>> use that pin as a GPIO in some other context (e.g. on a different board)
>> isn't something that the child interrupt controller should know/care
>> about.
>>
> 
> Thanks for your answer. So it should be the parent driver to proactively
> configure the GPIO as input, active high etc..., when an IRQ for its
> GPIOs is requested, right?

That was the conclusion of this thread, or a similar thread, yes.

> Moving to a different target (actually Mark's original point), i.e. a
> generic device which is connected through a GPIO, using the IRQ to
> trigger an event, what would be the recommended way?

Again, the device that's the interrupt source is simply emitting an
interrupt signal, so that's all it should know about.

Now, if you're talking about a device that's emitting just some random
data signal, where the driver wants to be notified of changes in the
signal, then that should be modelled as a GPIO, which the driver can
then convert internally to an IRQ and request. That's because from the
HW perspective, the signal isn't an IRQ output.
