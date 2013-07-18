Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301Ab3GRGET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 02:04:19 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60867 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758232Ab3GRGER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 02:04:17 -0400
Message-ID: <51E78525.9000802@ti.com>
Date: Thu, 18 Jul 2013 11:33:17 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <grant.likely@linaro.org>, <tony@atomide.com>, <balbi@ti.com>,
        <arnd@arndb.de>, <swarren@nvidia.com>, <sylvester.nawrocki@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <akpm@linux-foundation.org>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <linux@arm.linux.org.uk>,
        <benoit.cousson@linaro.org>, <mchehab@redhat.com>, <cesarb@cesarb.net>,
        <davem@davemloft.net>, <rnayak@ti.com>, <shawn.guo@linaro.org>,
        <santosh.shilimkar@ti.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <nsekhar@ti.com>, <balajitk@ti.com>,
        <george.cherian@ti.com>
Subject: Re: [PATCH v9 1/8] drivers: phy: add generic PHY framework
References: <1372247257-30186-1-git-send-email-kishon@ti.com> <1372247257-30186-2-git-send-email-kishon@ti.com> <20130717062944.GA24968@kroah.com> <51E664CB.8050906@ti.com> <20130717172510.GB17093@kroah.com>
In-Reply-To: <20130717172510.GB17093@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 17 July 2013 10:55 PM, Greg KH wrote:
> On Wed, Jul 17, 2013 at 03:02:59PM +0530, Kishon Vijay Abraham I wrote:
>> Hi,
>>
>> On Wednesday 17 July 2013 11:59 AM, Greg KH wrote:
>>> On Wed, Jun 26, 2013 at 05:17:29PM +0530, Kishon Vijay Abraham I wrote:
>>>> +menuconfig GENERIC_PHY
>>>> +	tristate "PHY Subsystem"
>>>> +	help
>>>> +	  Generic PHY support.
>>>> +
>>>> +	  This framework is designed to provide a generic interface for PHY
>>>> +	  devices present in the kernel. This layer will have the generic
>>>> +	  API by which phy drivers can create PHY using the phy framework and
>>>> +	  phy users can obtain reference to the PHY.
>>>
>>> Shouldn't this be something that other drivers select?  How will anyone
>>> know if they need this or not?
>>
>> All the PHY drivers should go here. So only if *GENERIC_PHY* is enabled those
>> PHY drivers can be selected like in [1].
>> The PHY consumer driver should ideally use *depends on* in their Kconfig.
>>
>> [1] ->
>> http://archive.arm.linux.org.uk/lurker/message/20130628.134308.4a8f7668.ca.html
> 
> No, switch it around the other way.  How would I even _know_ that I need
> to enable the generic PHY subsystem in the first place?  How can I
> determine that I need this for my hardware?  You need to give hints to
> someone who doesn't even know what a PHY is, otherwise they will always
> disable it and move on.
> 
>>>> --- /dev/null
>>>> +++ b/drivers/phy/phy-core.c
>>>> @@ -0,0 +1,544 @@
>>>> +/*
>>>> + * phy-core.c  --  Generic Phy framework.
>>>> + *
>>>> + * Copyright (C) 2013 Texas Instruments
>>>> + *
>>>> + * Author: Kishon Vijay Abraham I <kishon@ti.com>
>>>> + *
>>>> + * This program is free software; you can redistribute  it and/or modify it
>>>> + * under  the terms of  the GNU General  Public License as published by the
>>>> + * Free Software Foundation;  either version 2 of the  License, or (at your
>>>> + * option) any later version.
>>>
>>> You really mean "any later version" (I have to ask)?
>>
>> That was copied from somewhere :-s
> 
> So, is that what you really mean to have for this code?

indeed.
> 
>>>> + * This program is distributed in the hope that it will be useful,
>>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>> + * GNU General Public License for more details.
>>>> + *
>>>> + * You should have received a copy of the GNU General Public License
>>>> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>>>
>>> Are these two paragraphs needed?  This isn't a "program", and they got a
>>> copy of the GPL already with the kernel.
>>
>> hmm.. I can remove that.
>>>
>>>> +static struct class *phy_class;
>>>
>>> Why do you need a class?
>>
>> Wanted to group all the PHY drivers to be used by different subsystems
>> (SATA/USB/PCIE/HDMI/VIDEO) into a single entity. There were some comments in my
>> initial version [3] on using a bus_type instead of class but then it was
>> decided to go with class itself.
>>
>> [3] -> http://lkml.indiana.edu/hypermail/linux/kernel/1302.2/01389.html
> 
> Ok, but what does the class usage get you?

hmm.. actually I use class only to iterate through the list of devices in *phy*
class which could very well be implemented using list. Just that I wont have a
/sys/class/phy/ entry to find the list of phys added in the system. I dont
think I want to add any other stuff to expose to the user space at this point
of time.
> 
>>> When modifying/adding new sysfs stuff, you need a Documentation/ABI/
>>> entry as well.
>>
>> I'm not actually adding any new sysfs entry other than what a *class_create*
>> must have created. Do I need to add one for that?
> 
> If you are not creating anything in sysfs at all, why use the driver
> model?  (hint, I think you need to do something here to justify it...)

Well.. it helps me to use pm_runtime to enable clocks utilizing the
parent-child relationship.

Thanks
Kishon
