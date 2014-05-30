Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbaE3FGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 01:06:17 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57630 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbaE3FGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 01:06:16 -0400
Message-ID: <538811A9.1080800@ti.com>
Date: Fri, 30 May 2014 10:35:45 +0530
From: Satish Patel <satish.patel@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <rob@landley.net>, <tony@atomide.com>, <grant.likely@linaro.org>,
        <robh+dt@kernel.org>
Subject: Re: [PATCH v3 1/5] sc_phy:SmartCard(SC) PHY interface to SC controller
References: <1401267437-22489-1-git-send-email-satish.patel@ti.com> <1401267437-22489-2-git-send-email-satish.patel@ti.com> <20140528184408.GC30031@kroah.com> <5386F657.9040805@ti.com> <20140529155122.GA32214@kroah.com>
In-Reply-To: <20140529155122.GA32214@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 5/29/2014 9:21 PM, Greg KH wrote:
> On Thu, May 29, 2014 at 02:26:55PM +0530, Satish Patel wrote:
>>
>>
>> On 5/29/2014 12:14 AM, Greg KH wrote:
>>> On Wed, May 28, 2014 at 02:27:13PM +0530, Satish Patel wrote:
>>>> +/**
>>>> + * struct sc_phy - The basic smart card phy structure
>>>> + *
>>>> + * @dev: phy device
>>>> + * @pdata: pointer to phy's private data structure
>>>> + * @set_config: called to set phy's configuration
>>>> + * @get_config: called to get phy's configuration
>>>> + * @activate_card: perform smart card activation
>>>> + * @deactivate_card: perform smart card de-activation
>>>> + * @warm_reset: execute smart card warm reset sequence
>>>> + * @register_card_activity_cb: register call back to phy device.
>>>> + * This call back will be called on card insert or remove event
>>>> + *
>>>> + * smart card controller uses this interface to communicate with
>>>> + * smart card via phy.Some smart card phy has multiple slots for
>>>> + * cards. This inerface also enables controller to communicate with
>>>> + * one or more smart card connected over phy.
>>>> + */
>>>> +struct sc_phy {
>>>> +	/* phy's device pointer */
>>>> +	struct device *dev;
>>>
>>> So this is the "parent", right?  Why not embed a struct device into this
>>> structure as well, further streaching out the device tree.
>>>
>> Do you mean to use "dev->p" for pdata ?
>
> No, use the device itself.
>
>> I have kept it outside, to give easeness/pragmatic focal for new phy driver
>> development. Driver can make this pointer null and use above pointer.
>
> Ick, no, that's not how the driver model works.  Each device in the
> system needs a struct device, don't try to "chain" off of an existing
> device like this.  Make it a "real" one.
>
>>>> +
>>>> +	/* phy's private data */
>>>> +	void *pdata;
>>>
>>> If you do the above, then this pointer is not needed.
>>>
>>>
>>>> +
>>>> +	/* notify data, passed by interface user as a part of
>>>> +	 * register_notify API. Data should be passed back when
>>>> +	 * notification raised to the interface user
>>>> +	 */
>>>> +	void *notify_data;
>>>
>>> What makes this different from the pdata?
>> pdata is phy's private data, while notify_data is something phy will send to
>> smart card controller on some event, like card remove/insert/timeout etc..
>
> That doesn't make much sense to me, why not just put that in the notify
> function callback itself?
>
Little correction over here..
Here is brief flow
USIM(Smart Card Controller) register notification callback to smarcard phy.

usim->phy->register_notify(<phy handle>, <callback fn>, <notify_data>);
notify_data : pass back when callback function will be called by PHY


Smartcard PHY -> USIM
blocking_notifier_call_chain(<notifier>, action, <notify_data>);

action : card insert/remove/overheat etc..
notify data: USIM data passing back (supplied at the time of cb 
registration)


> Please either use the existing phy layer of the kernel, or make a "real"
> subsystem here, don't try to put a tiny shim on top of an existing
> struct device for this driver, that's not how subsystems in Linux are
> done.
Why I am not using exiting PHY framework ?

We will be more than happy to adapt generic phy if it
includes/add support for smart card requirements like

1) Some smart card phy (TDA8026-NxP) has multiple slots for smart
cards. This interface enables controller to communicate with specific
smart card inserted to the specific phy's slot.
2) Warm reset to smart card inserted to phy slot.
3) Bit banging of smart card pins to support vendor specific memory
cards.
4) Notification of card insert/remove/overheat etc.
5) synchronous and asynchronous modes for smart card transaction


>
> thanks,
>
> greg k-h
>
