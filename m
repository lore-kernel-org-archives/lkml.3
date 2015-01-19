Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527AbbASEVA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 23:21:00 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:52089 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbbASEU6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 23:20:58 -0500
MIME-Version: 1.0
In-Reply-To: <a4610e13d0094d40b7e0574992509ec6@BN1AFFO11FD044.protection.gbl>
References: <1421351389-11660-1-git-send-email-soren.brinkmann@xilinx.com>
 <20150116111108.GG30960@localhost> <a4610e13d0094d40b7e0574992509ec6@BN1AFFO11FD044.protection.gbl>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Mon, 19 Jan 2015 13:20:36 +0900
Message-ID: <CAAVeFu+K0W96mi0=QR8JGSe9BpH2nC5WV_9qbSvm6LJGA8gc7Q@mail.gmail.com>
Subject: Re: [PATCH v4] gpio: lib-sysfs: Add 'wakeup' attribute
To: =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
Cc: Johan Hovold <johan@kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
        linux-api@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2015 at 1:49 AM, Sören Brinkmann
<soren.brinkmann@xilinx.com> wrote:
> On Fri, 2015-01-16 at 12:11PM +0100, Johan Hovold wrote:
>> On Thu, Jan 15, 2015 at 11:49:49AM -0800, Soren Brinkmann wrote:
>> > Add an attribute 'wakeup' to the GPIO sysfs interface which allows
>> > marking/unmarking a GPIO as wake IRQ.
>> > The file 'wakeup' is created in each exported GPIOs directory, if an IRQ
>> > is associated with that GPIO and the irqchip implements set_wake().
>> > Writing 'enabled' to that file will enable wake for that GPIO, while
>> > writing 'disabled' will disable wake.
>> > Reading that file will return either 'disabled' or 'enabled' depening on
>> > the currently set flag for the GPIO's IRQ.
>> >
>> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>> > Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
>> > ---
>> > Hi Linus, Johan,
>> >
>> > I rebased my patch. And things look good.
>>
>> I took at closer look at this patch now and I really don't think it
>> should be merged at all.
>>
>> We have a mechanism for handling wake-up sources (documented in
>> Documentation/power/devices.txt) as well as an ABI to enable/disable
>> them using the power/wakeup device attribute from userspace.
>
> Doesn't work for GPIOs AFAIK.
>
>>
>> Implementing proper wakeup support for unclaimed GPIOs would take some
>> work (if at all desired), but that is not a reason to be adding custom
>> implementations that violates the kernel's power policies and new ABIs
>> that would need to be maintained forever.
>
> These are claimed, by the sysfs interface.
>
>>
>> [ And we really shouldn't be adding anything to the broken gpio sysfs
>> interface until it's been redesigned. ]
>>
>> Meanwhile you can (should) use gpio-keys if you need to wake your system
>> on gpio events.
>
> We had that discussion and I don't think GPIO keys is the right solution
> for every use-case.

Sorry, it has been a while - can you remind us of why?

>>
>> > But the 'is_visible' things does not behave the way I expected it to.
>> > It seems to be only triggered on an export but not when attributes
>> > change. Hence, in my case, everything was visiible since the inital
>> > state matches that, but even when changing the direction or things
>> > like that, attributes don't disappear. Is that something still worked
>> > on? Expected
>>
>> That's expected. We generally don't want attributes to appear or
>> disappear after the device has been registered (although there is a
>> mechanism for cases were it makes sense). This is no different from
>> how your v3 patch worked either.
>
> Sure, but the is_visible thing is effectively broken for GPIO. I think a
> GPIO is in a defined state when exported and the checks all work on that
> state during export. But then this state can be changed through the
> sysfs interface. So, if the initial state hides something it becomes
> unavailable for all times and, vice versa, if the initial state makes
> something visible, it will stay even when it is no longer a valid
> property to change.

Is there anything that prevents you from patching other GPIO sysfs
hooks to remove/reenable the wakeup property as needed?
