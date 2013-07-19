Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760847Ab3GSPyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 11:54:37 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37832 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760094Ab3GSPye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 11:54:34 -0400
Message-ID: <51E96135.9090108@wwwdotorg.org>
Date: Fri, 19 Jul 2013 09:54:29 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: Greg KH <gregkh@linuxfoundation.org>, linux-fbdev@vger.kernel.org,
        linux-doc@vger.kernel.org, nsekhar@ti.com, s.nawrocki@samsung.com,
        kgene.kim@samsung.com, swarren@nvidia.com, jg1.han@samsung.com,
        grant.likely@linaro.org, linux-media@vger.kernel.org,
        george.cherian@ti.com, devicetree-discuss@lists.ozlabs.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, balajitk@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        kyungmin.park@samsung.com, akpm@linux-foundation.org
Subject: Re: [PATCH 01/15] drivers: phy: add generic PHY framework
References: <1374129984-765-1-git-send-email-kishon@ti.com> <1374129984-765-2-git-send-email-kishon@ti.com> <20130718072004.GA16720@kroah.com> <51E7AE88.3050007@ti.com> <20130718154954.GA31961@kroah.com> <51E8D086.809@ti.com> <20130719054311.GA14638@kroah.com> <51E8D4E0.8060200@ti.com> <20130719062941.GA23611@kroah.com> <51E8DE51.1060404@ti.com>
In-Reply-To: <51E8DE51.1060404@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 12:36 AM, Kishon Vijay Abraham I wrote:
> Hi,
> 
> On Friday 19 July 2013 11:59 AM, Greg KH wrote:
>> On Fri, Jul 19, 2013 at 11:25:44AM +0530, Kishon Vijay Abraham I wrote:
>>> Hi,
>>>
>>> On Friday 19 July 2013 11:13 AM, Greg KH wrote:
>>>> On Fri, Jul 19, 2013 at 11:07:10AM +0530, Kishon Vijay Abraham I wrote:
>>>>>>>>> +	ret = dev_set_name(&phy->dev, "%s.%d", dev_name(dev), id);
>>>>>>>>
>>>>>>>> Your naming is odd, no "phy" anywhere in it?  You rely on the sender to
>>>>>>>> never send a duplicate name.id pair?  Why not create your own ids based
>>>>>>>> on the number of phys in the system, like almost all other classes and
>>>>>>>> subsystems do?
>>>>>>>
>>>>>>> hmm.. some PHY drivers use the id they provide to perform some of their
>>>>>>> internal operation as in [1] (This is used only if a single PHY provider
>>>>>>> implements multiple PHYS). Probably I'll add an option like PLATFORM_DEVID_AUTO
>>>>>>> to give the PHY drivers an option to use auto id.
>>>>>>>
>>>>>>> [1] ->
>>>>>>> http://archive.arm.linux.org.uk/lurker/message/20130628.134308.4a8f7668.ca.html
>>>>>>
>>>>>> No, who cares about the id?  No one outside of the phy core ever should,
>>>>>> because you pass back the only pointer that they really do care about,
>>>>>> if they need to do anything with the device.  Use that, and then you can
>>>>>
>>>>> hmm.. ok.
>>>>>
>>>>>> rip out all of the "search for a phy by a string" logic, as that's not
>>>>>
>>>>> Actually this is needed for non-dt boot case. In the case of dt boot, we use a
>>>>> phandle by which the controller can get a reference to the phy. But in the case
>>>>> of non-dt boot, the controller can get a reference to the phy only by label.
>>>>
>>>> I don't understand.  They registered the phy, and got back a pointer to
>>>> it.  Why can't they save it in their local structure to use it again
>>>> later if needed?  They should never have to "ask" for the device, as the
>>>
>>> One is a *PHY provider* driver which is a driver for some PHY device. This will
>>> use phy_create to create the phy.
>>> The other is a *PHY consumer* driver which might be any controller driver (can
>>> be USB/SATA/PCIE). The PHY consumer will use phy_get to get a reference to the
>>> phy (by *phandle* in the case of dt boot and *label* in the case of non-dt boot).
>>>> device id might be unknown if there are multiple devices in the system.
>>>
>>> I agree with you on the device id part. That need not be known to the PHY driver.
>>
>> How does a consumer know which "label" to use in a non-dt system if
>> there are multiple PHYs in the system?
> 
> That should be passed using platform data.

I don't think that's right. That's just like passing clock names in
platform data, which I believe is frowned upon.

Instead, why not take the approach that e.g. regulators have taken? Each
driver defines the names of the objects that it requires. There is a
table (registered by a board file) that has lookup key (device name,
regulator name), and the output is the regulator device (or global
regulator name).

This is almost the same way that DT works, except that in DT, the table
is represented as properties in the DT. The DT binding defines the names
of those properties, or the strings that must be in the foo-names
properties, just like a driver in non-DT Linux is going to define the
names it expects to be provided with.

That way, you don't need platform data to define the names.
