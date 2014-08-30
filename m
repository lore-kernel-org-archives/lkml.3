Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287AbaH3Jar (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 05:30:47 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:60358 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbaH3Jao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 05:30:44 -0400
Message-ID: <540199BD.7000504@kernel.org>
Date: Sat, 30 Aug 2014 10:30:37 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Huang Tao <huangtao@rock-chips.com>,
        "edubezval@gmail.com" <edubezval@gmail.com>,
        =?UTF-8?B?6LW15Luq5bOw?= <zyf@rock-chips.com>
CC: =?UTF-8?B?SGVpa29TdMO8Ym5lcg==?= <heiko@sntech.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Caesar Wang <caesar.wang@rock-chips.com>,
        "rui.zhang" <rui.zhang@intel.com>,
        "grant.likely" <grant.likely@linaro.org>, robh+dt <robh+dt@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-doc <linux-doc@vger.kernel.org>,
        =?UTF-8?B?6JSh5p6r?= <cf@rock-chips.com>,
        dianders <dianders@chromium.org>, dtor <dtor@chromium.org>,
        =?UTF-8?B?6ZKf5YuH5rGq?= <zyw@rock-chips.com>,
        "addy.ke@rock-chips.com" <addy.ke@rock-chips.com>,
        "dmitry.torokhov" <dmitry.torokhov@gmail.com>,
        linux-iio <linux-iio@vger.kernel.org>
Subject: Re: [PATCH v3 1/4] thermal: rockchip: add driver for thermal
References: <1409187562-12370-1-git-send-email-caesar.wang@rock-chips.com>	<2852853.mfRZfFVSev@wuerfel>	<20140828143733.GA18084@developer>	<3440260.edal29kzlR@diego>	<2014082909531345696848@rock-chips.com> <CAC-25o-winy6jVjh9_hQ-t2VO2UfxG67pW5DpOve8A2o39EJSw@mail.gmail.com> <54006D4C.2070404@rock-chips.com>
In-Reply-To: <54006D4C.2070404@rock-chips.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/08/14 13:08, Huang Tao wrote:
> Dear Eduardo Bezerra Valentin:
> 
> 在 2014年08月29日 19:39, edubezval@gmail.com 写道:
>> Hello Zhao,
>>
>> On Thu, Aug 28, 2014 at 9:54 PM, 赵仪峰 <zyf@rock-chips.com> wrote:
>>> Hi Heiko，
>>>
>>>    The TS-ADC on RK3288 has two component, a tsadc and a tsadc controller.
>>> The tsadc controller is similar like the thermal manager unit on other SOCs.
>>> We followed the naming of 3066, but not named as the Thermal Manager.
>>>
>>>    Moreover,there is only one set of apb registers to access the tsadc
>>> controller,and the tsadc is controlled by the tsadc controller,could not
>>> access directly. If we write a general tsadc driver by accessed tsadc
>>> controller registers, and it hardly to write a driver for the tsadc
>>> controller.
>> As suggested by Arnd, you can use the generic driver as interface
>> between thermal framework and IIO layer. The driver you are going to
>> write to your ADC is going to be in the IIO subsystem. The only
>> difference is that the generic driver would work for any ADC driver in
>> the IIO subsystem.
>> https://lkml.org/lkml/2014/2/5/810
>>
>> In fact, there is already a generic driver. We just need to get it up
>> to date.  I see some testing has been already done, and results sound
>> promising.
> This iio_thermal driver only support get temperature from the ADC IIO
> channel.
> It dose not support any advanced feature such as configure the
> temperature when system should be reset.
> So if we adapt it, we will access the register form both TSADC IIO
> driver and  thermal driver.
> I don't thank this is a good ideal.

Interesting bit of functionality.  I agree this doesn't fit overwelmingly well
into an iio consumer driver as things currently stand.

Looking briefly at your code, this is basically a threshold interrupt?
If so then we do have threshold type event handling in IIO (simply termed
events).  The snag is that it is the one area that doesn't currently have
any in kernel interfaces.

Such an interface would be similar to that used for the buffered data access (raw
data stream - we should probably rename that as it isn't always buffered anymore).
The nasty bit (as it was with the buffered interface) is writing a reasonably
efficient demux that can split out the data to those devices that have registered
their interest in it. It would involve some additional code in iio_push_event and
some indirection in the code that controls what events are enabled.
Actually, you could probably skip this an just squirt all events recieved out through
the direct IIO to userspace interface (nothing prevents another process turning
more on anyway!).  We could event for now specify that any in kernel users might
get other events and it is up to them to sanity check them.

We'd also need to add some basic access functions to set limits etc.

I'm afraid the 'events' bit of IIO is one of our least developed elements and is
lagging way behind the work done on the main data flows. It's been on the
list for a while, particularly as we need it to finish separating the
userspace interfaces of IIO from the backend.

So, looking at the wider picture, with a few additions to IIO we can support
some ADC based thermal drivers - whether all of them is a bit dependent on
whether they have weird and wonderful domain specific hardware (which I might
have missed here, but does not seem to be present).

Note this is based on a rather brief scan read so I may well have missed some
important details!
> 
> In fact, we should ignore the "ADC" stuff. This sensor use ADC internal,
> but it is transparent to software, especially in automatic mode.
Is this adc ever used for anything else?  If so, then there is your reason to
go through the pain of a generic driver.

Jonathan

p.s. I'd never seen the driver Arnd highlighted.  Could anyone working on
IIO clients cc linux-iio@vger.kernel.org as it's useful to know what people
are using the interfaces for (particularly as they might change so it is
good to know what is in the pipeline).
>>
>>>    So, I do not agree to write a generic adc driver for the rk3288-tsadc.
>>>
>>> ________________________________
>>> Yifeng Zhao
>>>
>>>
> 
> 
