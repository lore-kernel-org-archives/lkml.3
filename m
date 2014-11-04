Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbaKDLpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:45:23 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49222 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaKDLpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:45:20 -0500
Message-ID: <5458BC0B.1040803@ti.com>
Date: Tue, 4 Nov 2014 17:14:11 +0530
From: Vignesh R <vigneshr@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Griffis, Brad" <bgriffis@ti.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        "Balbi, Felipe" <balbi@ti.com>, Jan Kardell <jan.kardell@telliq.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [PATCH 0/4] Touchscreen performance related fixes
References: <1414408111-2631-1-git-send-email-vigneshr@ti.com> <544E821D.5040004@linutronix.de> <912A29987EAE174BA6CF187D7CDFA9CE26F46B2B@DLEE08.ent.ti.com> <54577258.9080508@linutronix.de>
In-Reply-To: <54577258.9080508@linutronix.de>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Monday 03 November 2014 05:47 PM, Sebastian Andrzej Siewior wrote:
> On 10/27/2014 08:02 PM, Griffis, Brad wrote:
>> On 10/27/2014 12:34 PM, Sebastian Andrzej Siewior wrote:
>>> Do we really need #3 (and then #4)? Given the complexity we have already, is there any benefit by decreasing this value? 
>>
>> I specifically requested we add ti,charge-delay to the device tree because it is THE critical value to tune for a given design.  Although I think the current value of 0xB000 will be suitable for a great many designs, I expect that many users will need to adjust this value for their hardware.  Details such as which touchscreen vendor is being used and how the touchscreen is connected (header vs cable) have an effect on what's appropriate here.
> 
> Oh. That is one knob I hoped we could avoid since I haven't seen it
> before on other TSCs. But okay. Please make sure that there is a
> message printed if the default value is used. And lets hope the user
> will do something about his.
> 
>>> Would  someone want to increase it? Can we safely determine a value which works for everyone?
>>
>> This value represents a hardware delay before checking for the pen-up event.  So in the scenario where someone is seeing excessive false pen-up events they will want to increase this parameter.  The downsize of making this larger is that it decreases the overall sampling speed of both the touchscreen as well as the standalone ADC samples.  At one point I tried making it huge, but that made the touchscreen overly sluggish because the sampling became too slow.  So there is a definite trade-off that if you make it too large the touchscreen becomes sluggish, and if you make it too small then you may see false pen-up events.  The optimal value will need to be tuned for a given design.
> 
> I applied the patches from this series and did the following test on my
> am335x-evm: A mug on the touchscreen (to make sure the events are
> coming), evtest on the event node to see that the events and loop of
> 
> 	cat /sys/bus/iio/devices/iio\:device0/in_voltage4_raw
> 
> In the past I was able lock up the TSC/ADC HW that way (see commit
> 7ca6740cd1 ("mfd: input: iio: ti_amm335x: Rework TSC/ADC
> synchronization")) for details.
> With this patches applied I don't seen any TSC events once the IIO
> interface is (heavily) used. Can this be fixed?

I ran following commands
$ evtest /dev/input/touchscreen0 &
(with heavy item on touchscreen)
 and
$ cat /sys/bus/iio/devices/iio\:device0/scan_elements/in_voltage4_en
(in a busy loop)
I tried above experiment on my board but I didn't hit any problem even
after running for close to 30 minutes. I was unable to reproduce failure

The problem may be in configuring correct charge-delay value. Please run:
$ ts_test > /dev/null
and let me know if pen events are being detected properly.

> 
> Sebastian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
