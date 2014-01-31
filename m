Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932847AbaAaTVO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 14:21:14 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53312 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932292AbaAaTVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 14:21:13 -0500
Message-ID: <52EBF790.3090407@ti.com>
Date: Fri, 31 Jan 2014 14:20:48 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: Grygorii Strashko <grygorii.strashko@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <ivan.khoronzhuk@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: keystone: switch to use runtime pm
References: <1391174426-13773-1-git-send-email-grygorii.strashko@ti.com> <20140131151955.GB20736@saruman.home> <52EBC499.2070302@ti.com> <20140131154721.GD20736@saruman.home> <52EBC650.50305@ti.com> <20140131164534.GL20736@saruman.home>
In-Reply-To: <20140131164534.GL20736@saruman.home>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 January 2014 11:45 AM, Felipe Balbi wrote:
> On Fri, Jan 31, 2014 at 10:50:40AM -0500, Santosh Shilimkar wrote:
>> On Friday 31 January 2014 10:47 AM, Felipe Balbi wrote:
>>> On Fri, Jan 31, 2014 at 10:43:21AM -0500, Santosh Shilimkar wrote:
>>>> On Friday 31 January 2014 10:19 AM, Felipe Balbi wrote:
>>>>> Hi,
>>>>>
>>>>> On Fri, Jan 31, 2014 at 03:20:26PM +0200, Grygorii Strashko wrote:
>>>>>> The Keystone PM management layer has been implemented using PM bus for
>>>>>> power management clocks. As result, most of Keystone drivers don't need
>>>>>> to manage clocks directly. They just need to enable runtime PM and use it
>>>>>> to handle their PM state and clocks.
>>>>>>
>>>>>> Hence, remove clock management code and switch to use runtime PM.
>>>>>>
>>>>>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>>>>>
>>>>> quite a few weeks back I sent a series enabling runtime pm for all glue
>>>>> layers. I'll use that version instead, sorry.
>>>>>
>>>> That should be fine but you need to drop clk_*() related code
>>>> from that patch. I assume you will send refresh version of it then.
>>>
>>> why ? it makes no difference if you enable twice and disable twice.
>>>
>> Sure but why do you want to have the clock node handling code in drivers
>> if it is not needed. Isn't that better ?
> 
> It might, but then way that I wanted to see it is so that I can make
> assumptions about the device state. From a driver perspective, what I
> would love to see is the ability to assume that when my probe gets
> called the device is already enabled. So if you can make sure that
> clk_enable() happens before my probe and that you call
> pm_runtime_set_active() before my probe too, then I can more than
> hapilly remove clk_* calls from the driver ;-)
> 
> either that or maintain the driver like so:
> 
> probe()
> {
> 	...
> 
> 	clk_get(dev, "fck");
> 	clk_prepare(clk);
> 	clk_enable(clk);
> 	pm_runtime_set_active(dev);
> 	pm_runtime_enable(dev);
> 	pm_runtime_get_sync(dev);
> 	...
> }
> 
> runtime_suspend()
> {
> 	clk_disable(dev);
> }
> 
> runtime_resume()
> {
> 	clk_enable(dev);
> }
> 
> note that because of pm_runtime_set_active() that first
> pm_runtime_get_sync() in probe() will simply increase the reference
> counter without calling my ->runtime_resume() callback, which is exactly
> what we want, as that would completely avoid situations of bad context
> being restored because of that initial pm_runtime_get_sync().
> 
Thanks for making your point bit clear. 

> Then, we can even make pm_runtime completely async easily, because
> clk_prepare() was called only on probe() (or before it, for that
> matter).
> 
> Bottomline is, if you can guarantee me that clk_get(), clk_prepare(),
> clk_enable() and pm_runtime_set_active() will be called properly before
> my probe, i'll be more than happy to comply with your request above as
> that will greatly simplify my driver.
> 
Which is the case at least I see on Keystone. And hence the patch from
Grygorii works. I also noticed your proposal for wider platform to
enforce above behavior which seems to be a good idea.

> Just make, also, that if this clock is shared between dwc3-keystone
> wrapper and dwc3 core, you clk_get() on both driver's probe.
> 
I understand. In summary, whichever patch you pick(yours) or Grygorii's,
its completely safe to remove the clock handling from Keystone USB driver.

Regards,
Santosh
