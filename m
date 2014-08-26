Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934365AbaHZJ5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 05:57:25 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:50421 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757363AbaHZJ5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 05:57:22 -0400
Message-ID: <53FC59E4.8000306@ahsoftware.de>
Date: Tue, 26 Aug 2014 11:56:52 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>, Jon Loeliger <jdl@jdl.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Mark Rutland <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 0/9] dt: dependencies (for deterministic driver initialization
 order based on the DT)
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>	<20140514141914.446F7C4153D@trevor.secretlab.ca>	<20140821140211.GD19293@ulmo.nvidia.com> <53F64624.5000403@ahsoftware.de>	<20140822131919.GX21734@leverpostej> <20140825093931.GB2399@ulmo>	<E1XLu15-0002DP-6o@jdl.com> <20140826085128.958A9C40989@trevor.secretlab.ca>
In-Reply-To: <20140826085128.958A9C40989@trevor.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.08.2014 10:51, schrieb Grant Likely:
> On Mon, 25 Aug 2014 08:08:59 -0500, Jon Loeliger <jdl@jdl.com> wrote:
>>>
>>
>>> Anyway, instead of going back and forth between "deferred probe is good"
>>> and "deferred probe is bad", how about we do something useful now and
>>> concentrate on how to make use of the information we have in DT with the
>>> goal to reduce the number of cases where deferred probing is required?
>>
>> Good idea.
>>
>> The proposal on the table is to allow the probe code
>> to make a topological sort of the devices based on
>> dependency information either implied, explicitly stated
>> or both.  That is likely a fundamentally correct approach.
>>
>> I believe some of the issues that need to be resolved are:
>>
>>      1) What constitutes a dependency?
>>      2) How is that dependency expressed?
>>      3) How do we add missing dependencies?
>>      4) Backward compatability problems.
>>
>> There are other questions, of course.  Is it a topsort
>> per bus?  Are there required "early devices"?  Should
>> the inter-node dependencies be expressed at each node,
>> or in a separate hierarchy within the DTS?  Others.

Topsort by bus wouldn't work. That would imply that nothing uses 
something involved with another bus. And early devices are handled fine 
by normal dependencies too (as long as they are complete), so there is 
no need to make an distinction.


> Getting the dependency tree I think is only half the problem. The other
> have is how to get the driver model to actually order probing using that
> list. That problem is hard because the order drivers are probed is
> currently determined by the interaction of driver link order, driver
> initcall level, and device registration order. The first devices are
> registered at an early initcall, before their drivers, and therefore
> bind order is primarily determined by initcall level and driver link
> order. However, later devices (ie. i2c clients) are registered by the
> bus driver (ie. again, i2c) and probe order may be primarily link order
> (if the driver is not yet registered) or registration order (if the
> driver was registered before the parent bus).

That's why I've invented those "well-done"-initcalls. These are 
initcalls which just register a driver and don't probe it. Thats 
necessary to build a catalog of existing in-kernel-drivers (you have to 
know what you are sorting). Fortunately most drivers are already of that 
type. And those which aren't can be either just used like before (if it 
works) or they can be changed.

Changing them can be done per board (only enable dependency based order 
for a board if necessary drivers have changed).

Regards,

Alexander Holler
