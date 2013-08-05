Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab3HEDw3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 23:52:29 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:46741 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597Ab3HEDw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 23:52:27 -0400
MIME-Version: 1.0
In-Reply-To: <1374163091-4750-1-git-send-email-enselic@gmail.com>
References: <1374163091-4750-1-git-send-email-enselic@gmail.com>
Date: Sun, 4 Aug 2013 20:52:26 -0700
X-Google-Sender-Auth: X4BAYovoni9wDsmW2sX2CIQ7v8A
Message-ID: <CANLzEksSsMY2pTYTfGzgntF-i_Kus+WeVPyNzW0U7APcGOv_5g@mail.gmail.com>
Subject: Re: [PATCH 0/1] Platform: x86: chromeos_laptop - convert to
 i2c_driver to handle i915 race
From: Benson Leung <bleung@chromium.org>
To: Martin Nordholts <enselic@gmail.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        Olof Johansson <olof@lixom.net>, Yufeng Shen <miletus@chromium.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,

Thank you for looking into this problem. Obviously, this is a problem
Olof and our team has been working on as well.

On Thu, Jul 18, 2013 at 8:58 AM,  <enselic@gmail.com> wrote:
> From: Martin Nordholts <enselic@gmail.com>
>
> Hello,
>
> I have looked into solving the "touchpad/touchscreen not working on
> boot"-problem on Chromebook Pixel, see for example Brock Tice's last
> comment on https://plus.google.com/+LinusTorvalds/posts/1iFsBWBqoYY
>
> I have seen Olof's attempt at a fix:
>
>   [PATCH] Platform: x86: chromeos_laptop: defer probing if no i2c busses found
>   https://lkml.org/lkml/2013/4/18/556
>
> At first, I tried Olofs suggestion at the end of the thread, namely to
> do bus_register_notifier() on i2c_bus_type, but it is a bit awkward:
> How do you know that the i2c_adapter you are notified about is ready
> to be interacted with? While investigating this, I noticed that the
> i2c_driver has a .detect() mechanism, which is exactly what we need: A
> callback when a newly added i2c_adapter is initialized and ready to be
> used.

I would be hesitant to use .detect(), as its use will have unintended
side effects. I'll give you a real world example of what can happen
with your driver.

Here I've run the i2cdetect command on an actual Chromebook platform.
The name of the bus is SMBus I801 adapter at 0400, so it will be
triggered by your detect.

localhost ~ # i2cdetect -y 8
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- 08 -- -- -- -- -- -- --
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
30: -- -- -- -- -- 35 -- -- -- -- -- -- -- -- -- --
40: -- -- -- -- 44 -- -- -- -- -- 4a 4b -- -- -- --
50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
70: -- -- -- -- -- -- -- --

Your driver will try to instantiate device 0x44, the isl29018 ambient
light sensor, device 0x4a, an Atmel touchscreen, and device 0x4b, an
Atmel touchpad.

The problem is that none of those devices actually exist on this
particular system's SMBus.
These are other i2c clients that just happen to share the same
addresses as devices on other buses on other supported systems. 0x44,
for example, is the Intel PCH SMBus's host Receive Slave Address
Register. It just happens to have the same address as the isl29018.

Your driver would result in three failed probes in 2 different drivers
on my board.

Furthermore, I would recommend reading the documentation on
instantiating i2c devices :
https://www.kernel.org/doc/Documentation/i2c/instantiating-devices

The documentation outlines the four methods that are supported for
instantiating i2c devices. "Detect" is method #3, but it comes with a
stern warning : Once again, method 3 should be avoided wherever
possible. Explicit device instantiation (methods 1 and 2) is much
preferred for it is safer and faster.

>
> Since all chromeos_laptop does is to instantiate i2c devices, I
> figured it would be nice to simply convert chromeos_laptop into a
> i2c_driver. The result is the patch in the next mail (based on
> v3.11-rc1).

That is actually not true. The intention is for chromeos_laptop to
eventually instantiate devices other than i2c devices, actually. The
chromeos-kernel version of this driver actually supports the
Chromebook Pixel's keyboard backlight, which is not an i2c device but
a platform device, so making this driver a platform driver is more
appropriate.

https://gerrit.chromium.org/gitweb/?p=chromiumos/third_party/kernel-next.git;a=blob;f=drivers/platform/x86/chromeos_laptop.c;hb=refs/heads/chromeos-3.8

>
> I have gone through the SubmitChecklist and done everything that
> applied. I have however only tested this patch on the Chromebook
> Pixel, as that is what I have. I will need help with verifying the
> patch on other Chromebooks.

As I mentioned before, the patch causes problems on other Chromebook
systems I have tested with devices with colliding addresses on SMBus.

>
> But first, what do you think about my patch?
>
> / Martin
>
> Martin Nordholts (1):
>   Platform: x86: chromeos_laptop - convert to i2c_driver to handle i915
>     race
>
>  drivers/platform/x86/chromeos_laptop.c |  426 +++++++++++++++-----------------
>  1 file changed, 194 insertions(+), 232 deletions(-)
>
> --
> 1.7.10.4
>



--
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
