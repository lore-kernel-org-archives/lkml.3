Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbaGBQS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:18:28 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55018 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbaGBQS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:18:26 -0400
Message-ID: <53B430CE.5040905@wwwdotorg.org>
Date: Wed, 02 Jul 2014 10:18:22 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Philipp Zabel <p.zabel@pengutronix.de>,
        linux-usb@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, tuomas.tynkkynen@iki.fi
Subject: Re: [PATCH 0/3] Tegra USB probe order issue fix
References: <Pine.LNX.4.44L0.1407021204570.874-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1407021204570.874-100000@iolanthe.rowland.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2014 10:09 AM, Alan Stern wrote:
> On Wed, 2 Jul 2014, Stephen Warren wrote:
> 
>> On 07/02/2014 08:02 AM, Alan Stern wrote:
>>> On Wed, 2 Jul 2014, Tuomas Tynkkynen wrote:
>>>
>>>> Hi all,
>>>>
>>>> This series fixes a probe order issue with the Tegra EHCI driver.
>>>> Basically, the register area of the 1st USB controller contains some
>>>> registers that are global to all of the controllers, but that are also
>>>> cleared when reset is asserted to the 1st controller. So if (say) the
>>>> 3rd controller would be the first one to finish probing successfully,
>>>> then the reset that happens during the 1st controller's probe would
>>>> result in broken USB. So the before doing anything with the USB HW,
>>>> we should reset the 1st controller once, and then never ever reset
>>>> it again.
>>>
>>> This sounds very much like the sort of thing that ought to be described 
>>> in DT.  It is a hardware dependence, and DT exists for the purpose of 
>>> describing the hardware.
>>
>> DT is more about describing the HW, not how SW has to use the HW.
> 
> Tuomas wrote: "the register area of the 1st USB controller contains
> some registers that are global to all of the controllers, but that are
> also cleared when reset is asserted to the 1st controller."  That is
> very much an attribute of the hardware and so DT should describe it.

So you want to add a Boolean DT property to the first USB controller
node indicating that it has the "shared" reset? That would be fine, but
would only replace the content of tegra_find_usb1_node(); much of the
rest of the patch would remain the same.

I guess in this case, it's fine to require DT changes to enable the new
feature of fixing this issue, so long as the code continues to work the
same as it currently does with old DTs. Due to the backwards
compatibility requirement, the patch will end up slightly more complex,
but hopefully not too bad.

>> probe() ordering is a SW issue, not a HW description. It's driver
>> knowledge that the HW resets have to run in a certain order, and if the
>> driver didn't actually reset the HW ever (but rather, re-programmed all
>> registers so reset was never needed), then order wouldn't be relevant
>>
>> DT certainly doesn't have any mechanism for describing probe order or
>> anything like that, although you can fake it out by adding phandles
>> between nodes, and having SW wait for the driver for the referenced node
>> to probe first. That won't work here though, since there's no guarantee
>> that the USB1 node will actually be enabled (that USB port might not be
>> hooked up on the board, hence the DT node will be disabled), so we can't
>> rely on a driver for it ever appearing.
> 
> I wasn't talking about probe order; I was talking about the fact that 
> registers pertinent to the later controllers are in the reset domain of 
> the first controller.
> 
> Alan Stern

