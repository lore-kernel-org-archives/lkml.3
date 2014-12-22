Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbaLVRFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 12:05:41 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:64837 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868AbaLVRFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 12:05:39 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1412221101540.23710-100000@netrider.rowland.org>
References: <1419244588-5227-3-git-send-email-wulf@rock-chips.com>
	<Pine.LNX.4.44L0.1412221101540.23710-100000@netrider.rowland.org>
Date: Mon, 22 Dec 2014 09:05:38 -0800
Message-ID: <CAD=FV=UWOOwr3K6vPbAiHTUuv1DdbVRQ1yKKWWS6KOv6J4B51w@mail.gmail.com>
Subject: Re: [PATCH 2/2] USB: ehci-platform: Support ehci reset after resume quirk
From: Doug Anderson <dianders@google.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Wu Liang feng <wulf@rock-chips.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Tao Huang <huangtao@rock-chips.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        Eddie Cai <eddie.cai@rock-chips.com>, Roy Li <roy.li@rock-chips.com>,
        Chris <zyw@rock-chips.com>, Julius Werner <jwerner@google.com>,
        Pawel Osciak <posciak@google.com>, Tomasz Figa <tfiga@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

On Mon, Dec 22, 2014 at 8:06 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Mon, 22 Dec 2014, Wu Liang feng wrote:
>
>> The EHCI controller doesn't properly detect the case when
>
> "The" EHCI controller?  I don't know what EHCI controller you're
> talking about, but my controllers don't have any trouble detecting
> device removal during suspend.

This is specifically the EHCI controller on rk3288.  Not sure why Wu
Liang feng removed that part of the description.


>> a device is removed during suspend. Specifically,when we
>> resume from suspend the EHCI controller maintaining the
>> USB state (FLAG_CF is 1 Current Connect Status is 1) but
>> a USB device (like a USB camera on rk3288) may have been
>> disconnected actually.
>>
>> Let's add a quirk to force ehci to go into the
>> usb_root_hub_lost_power() path and reset after resume.
>> This should generally reset the whole controller and all
>> ports and initialize everything cleanly again, and bring
>> the devices back up.
>
> Isn't this solution too extreme?  What if the device was a flash
> storage drive and it wasn't unplugged during suspend?  This patch would
> force it to be removed, messing up any mounted filesystems, when there
> was no need.

I'm told by Julius (CCed, who knows the USB stack infinitely better
than I do) that you can work around this using "persist".  I would
imagine that anyone on a machine using hibernation would run into the
same problem, right?


> Can you find a better way to work around the problem?

We asked a lot about this and you can find a whole set of detailed
discussion at:

https://chromium-review.googlesource.com/#/c/232077/1/drivers/usb/host/ehci-platform.c


Since I don't know the USB subsystem particularly well, my review
isn't terribly meaningful, but just in case:

Reviewed-by: Doug Anderson <dianders@chromium.org>


On rk3288-pinky I have tested that without this patch the EHCI
controller flips out when a USB webcam is plugged into the port and is
power cycled across suspend/resume.  With this patch the controller
properly unplugs / replugs the webcam.

Tested-by: Doug Anderson <dianders@chromium.org>


-Doug
