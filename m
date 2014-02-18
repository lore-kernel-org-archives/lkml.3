Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbaBRVc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:32:59 -0500
Received: from us-mx2.synaptics.com ([192.147.44.131]:40126 "EHLO
	us-mx2.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaBRVc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:32:56 -0500
X-PGP-Universal: processed;
	by securemail.synaptics.com on Tue, 18 Feb 2014 13:19:59 -0800
Message-ID: <5303D185.8020302@synaptics.com>
Date: Tue, 18 Feb 2014 13:32:53 -0800
From: Christopher Heiny <cheiny@synaptics.com>
Organization: Synaptics, Inc
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Andrew Duggan <aduggan@synaptics.com>,
        Vincent Huang <vincent.huang@tw.synaptics.com>,
        Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Linux Input <linux-input@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/11] Input: synaptics-rmi4 - do not update configuration
 in rmi_f01_probe()
References: <1392269277-16391-1-git-send-email-dmitry.torokhov@gmail.com> <1392269277-16391-3-git-send-email-dmitry.torokhov@gmail.com> <52FD1BC0.1050009@synaptics.com> <20140213215432.GA6225@core.coreip.homeip.net> <52FEA01B.7040604@synaptics.com> <20140217192321.GC19223@core.coreip.homeip.net>
In-Reply-To: <20140217192321.GC19223@core.coreip.homeip.net>
X-Originating-IP: [10.3.20.103]
X-Brightmail-Tracker: AAAAAQAAAWE=
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2014 11:23 AM, Dmitry Torokhov wrote:
> On Fri, Feb 14, 2014 at 03:00:43PM -0800, Christopher Heiny wrote:
>> On 02/13/2014 01:54 PM, Dmitry Torokhov wrote:
>>> On Thu, Feb 13, 2014 at 11:23:44AM -0800, Christopher Heiny wrote:
>>>>> On 02/12/2014 09:27 PM, Dmitry Torokhov wrote:
>>>>>>> Do not write configuration data in probe(), we have config() for that.
>>>>>
>>>>> Then we should call config() in rmi_function_probe() to ensure that
>>>>> any platform data or device tree configuration settings get written
>>>>> to the device.
>>>
>>> Well, yes, we may elect to update device configuration in probe, but
>>> then we should not be doing that 2nd time in ->config(). We shoudl pick
>>> either one or another.
>>
>> But as the code currently stands, config() is only called when a
>> device reset is detected, not during initialization.  So if there's
>> platform specific configuration data that needs to be written to a
>> function, it won't get written until after a device reset occurs,
>> which might never happen.  So either we need to write that data (or
>> call config()) in each function's probe(), or in
>> rmi_function_probe().
>
> Ah, I missed the fact that we do not normally call ->config() unless
> device was reset. BTW, if device was reset, shouldn't we tear down
> everything and then reenumerate all functions?

That's only required if the reset is a result of the device being 
reflashed.  Since we're dropping support for user-space control of 
reflash, and will instead use an in-driver reflash, we know which resets 
are the result of a reflash and which aren't. The reflash code will do 
the following sequence:

- tell the core to tear down the functions
- perform the reflash operation
- reset the device
- tell the core to re-enumerate the functions


					Chris
