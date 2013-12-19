Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab3LSR3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 12:29:17 -0500
Received: from 9.mo3.mail-out.ovh.net ([87.98.184.141]:60627 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753517Ab3LSR3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 12:29:11 -0500
Message-ID: <52B32920.1030506@overkiz.com>
Date: Thu, 19 Dec 2013 18:13:04 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Rob Landley <rob@landley.net>, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        Ben Gamari <bgamari.foss@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [RFC PATCH] gpio: add GPIO hogging mechanism
References: <1387463671-1164-1-git-send-email-b.brezillon@overkiz.com> <1387463671-1164-2-git-send-email-b.brezillon@overkiz.com> <20131219164109.GB27409@kroah.com>
In-Reply-To: <20131219164109.GB27409@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 2969842481227004022
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrtdefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrtdefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

On 19/12/2013 17:41, Greg Kroah-Hartman wrote:
> On Thu, Dec 19, 2013 at 03:34:31PM +0100, Boris BREZILLON wrote:
>> GPIO hogging is a way to request and configure specific GPIO without
>> explicitly requesting it in the device driver.
>>
>> The request and configuration procedure is handled in the core device
>> driver code before the driver probe function is called.
>>
>> It allows specific GPIOs to be configured without any driver specific code.
>>
>> Particularly usefull when a external device is connected to a bus and the
>> bus connections depends on an external switch controlled by a GPIO pin.
>> Or when some GPIOs have to be exported to sysfs without any userspace
>> intervention.
>>
>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>> ---
>>   Documentation/devicetree/bindings/gpio/gpio.txt |   47 ++++++++
>>   drivers/base/Makefile                           |    1 +
>>   drivers/base/dd.c                               |    5 +
>>   drivers/base/gpio.c                             |   59 ++++++++++
> I don't understand what makes GPIO's "special" enough to get included in
> the driver core like this, and called for each and every device that is
> added to the system.


> What's wrong with the generic device callbacks/notifiers we already
> have?  Why does this need to be in the driver core?  And what exactly
> are you doing all of this for in the first place?

Nothing's wrong with the generic device callbacks/notifiers, but in some
cases we don't want a generic driver to handle board specificities.

This is the case for the at91rm9200ek board (see this thread:
https://www.mail-archive.com/devicetree@vger.kernel.org/msg06838.html).

Since we are moving all boards to dt, we can't configure each board at
startup, and the rm9200ek board used to set a pin to a specific value 
(this pin
is connected to an external switch which connects MMC signals to the MMC
connector or SPI signals to an SPI device depending on the pin value) in 
order
to enable the MMC0 port or an SPI device.

I first proposed to handle this using a pinctrl pinconf definition (with 
pinctrl
output-high config). As pinctrl are requesting pinconf before calling 
driver probe
function, this was absolutely transparent to the generic driver.
But, as Linus pointed out, this pin is not really related to the SPI or 
MMC device
itself.
This is why Linus suggested the GPIO hog approach.

Anyway, I'm open to any other solution that wouldn't introduce specific
cases in arch specific code or generic drivers.

Best Regards,

Boris
> greg k-h

