Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421AbaKKPKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 10:10:37 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:64134 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaKKPKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 10:10:35 -0500
MIME-Version: 1.0
In-Reply-To: <20141103232913.GA7454@kroah.com>
References: <20141006194418.GA399@debian>
	<1412679771-8293-1-git-send-email-ghorbel@pivasoftware.com>
	<54576545.8030300@ti.com>
	<20141103232913.GA7454@kroah.com>
Date: Tue, 11 Nov 2014 16:10:34 +0100
Message-ID: <CAFqH_51SVdKkP4Hfzz-Nc3zSvMn=M3xxkZNbyQff_YWkqh0jDQ@mail.gmail.com>
Subject: Re: [PATCHv2] phy: omap-usb2: Enable runtime PM of omap-usb2 phy properly
From: Enric Balletbo Serra <eballetbo@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Oussama Ghorbel <ghorbel@pivasoftware.com>,
        Rabin Vincent <rabin@rab.in>, rogerq@ti.com,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Angelo Dureghello <angelo70@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

2014-11-04 0:29 GMT+01:00 Greg KH <gregkh@linuxfoundation.org>:
> On Mon, Nov 03, 2014 at 04:51:41PM +0530, Kishon Vijay Abraham I wrote:
>> Hi Greg,
>>
>> On Tuesday 07 October 2014 04:32 PM, Oussama Ghorbel wrote:
>> > The USB OTG port does not work since v3.16 on omap platform.
>> > This is a regression introduced by the commit
>> > eb82a3d846fa (phy: omap-usb2: Balance pm_runtime_enable() on probe failure
>> >  and remove).
>> > This because the call to pm_runtime_enable() function is moved after the
>> > call to devm_phy_create() function, which has side effect since later in
>> > the subsequent calls of devm_phy_create() there is a check with
>> > pm_runtime_enabled() to configure few things.
>>
>> This is the only fix for this -rc cycle in the PHY susbsystem. So can you take
>> this directly? Or else I can prepare a pull request. Let me know.
>>
>> Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
>
> I don't have this in my archives anymore, please resend so that I can
> apply it from an email.
>
> thanks,
>
> greg k-h

I'm trying to use the OTG port as HOST on OMAP3-based platform
(IGEPv2), I saw that this patch is already applied in kernel
3.18.0-rc4 so I expected it to work, but I've some problems. To
explain the situation let me propose some test cases.

The first tests I made were configuring the MUSB OTG as HOST only
mode,In this mode test case A fails and test case B and C succeed.

USB Mode Selection (HOST only mode)
    Test case A) Boot the system :
        mode : b_idle
        vbus : Vbus off, timeout 1100 msec
        1) Ground ID-pin
            mode : a_idle
            vbus : Vbus off, timeout 1100 msec
        2) Plug pendrive
            mode : a_idle
            vbus : Vbus off, timeout 1100 msec
        Failed: Pendrive is not detected.

    Test case B) Boot with ID-pin grounded :
        mode : a_idle
        vbus : Vbus off, timeout 1100 msec
        1) Plug pendrive
            mode : a_host
            vbus : Vbus off, timeout 1100 msec
        Success: Pendrive is detected

    Test case C) Boot with ID-pin grounded and pendrive
        mode : a_host
        vbus : Vbus off, timeout 1100 msec
        Success: Pendrive is detected

The second tests I made were configuring the MUSB OTG as Dual Role
mode,In this mode all test cases failed.

MUSB Mode Selection (Dual Role mode)
    Test case A) Boot the system :
        mode : b_idle
        vbus : Vbus off, timeout 1100 msec
        1) Ground ID-pin:
            mode : a_idle
            mode : Vbus off, timeout 1100 msec
        2) Plug pendrive
            mode : a_idle
            vbus : Vbus off, timeout 1100 msec
        Failed: Pendrive is not detected.

    Test case B) Boot with ID-pin grounded :
        mode : b_idle
        vbus : Vbus off, timeout 1100 msec
        1) Plug pendrive
            mode : b_idle
            vbus : Vbus off, timeout 1100 msec
        Failed: Pendrive is not detected.

    Test case C) Boot with ID-pin grounded and pendrive
        mode : b_idle
        vbus : Vbus off, timeout 1100 msec
        Failed: Pendrive is not detected.

I got the mode and vbus values from sysfs:

    cat /sys/bus/platform/drivers/musb-hdrc/musb-hdrc.0.auto/mode
    cat /sys/bus/platform/drivers/musb-hdrc/musb-hdrc.0.auto/vbus

Did anybody test these test cases ?

I'm a bit surprised with the vbus status because always reports Vbus
off, although pendrive is working. I'm missing something ?

Note that if you see at the mode transitions something looks wrong.
For example, in Dual Role Mode test case B and C the mode is b_idle
instead of a_idle.

Thanks,
   Enric
