Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbaL2H1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 02:27:25 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:49513 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaL2H1X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 02:27:23 -0500
MIME-Version: 1.0
In-Reply-To: <4278344.duCujNBB8t@xps13>
References: <1416755361-17357-1-git-send-email-pali.rohar@gmail.com>
	<CAJ=jquaeyz4NnT2Wg7MaLHrLF1+ARXfds-Z-hRvYyk8SvQGTKQ@mail.gmail.com>
	<201412252111.06004@pali>
	<4278344.duCujNBB8t@xps13>
Date: Mon, 29 Dec 2014 15:27:21 +0800
Message-ID: <CAJ=jqubG0ETuF_86M7=zbD4dDnaDcq-=4tGBL-PkoquNpWpwoA@mail.gmail.com>
Subject: Re: [PATCH 0/3] Dell Airplane Mode Switch driver
From: Alex Hung <alex.hung@canonical.com>
To: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Cc: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Darren Hart <dvhart@infradead.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2014 at 5:55 AM, Gabriele Mazzotta
<gabriele.mzt@gmail.com> wrote:
> On Thursday 25 December 2014 21:11:05 Pali Rohár wrote:
>> I will try to recap all information which we have...
>>
>> *) We should not send wireless key press to userspace when BIOS
>> already handles wireless state (and enable/disable wifi):
>> http://www.spinics.net/lists/platform-driver-x86/msg05922.html
>>
>> *) some tested dell machines does not implement GRBT method (or
>> report constant value) which could return state of wireless
>> (enabled/disabled) -- e.g. Inspiron 7447
>>
>> *) dell-wireless driver is doing nothing on devices which have
>> wireless slider switch (except calling CRBT/ARBT methods)
>>
>> *) all tested machines emit key with keycode 240 (scancode is
>> probably 136 = 0x88) to userspace via i8042 bus/AT keyboard when
>> wireless button/slider is pressed/switched
>>
>> *) both drivers dell-wireless and dell-rbtn do not implement
>> setting soft rfkill state (or change wifi state)
>>
>> So in my opinion: if we decide to use driver for acpi DELLABCE
>> device we should use dell-rbnt for devices with hw slider switch
>> and dell-wireless for devices with fn button. I think it does not
>> make sense to use dell-wireless for devices with hw slider
>> because it do nothing and dell-rbtn for devices with fn key
>> button as GRBT does not working properly.
>
> Here the problem. We are determining which laptop has an hardware
> slider and which doesn't calling CRBT. If the returned value is 2
> or 3, then the laptop has an hardware slider. However, it cannot be
> assumed the opposite if the returned value is 0 or 1.

The spec defines as below:
1. When CRBT returns 0 or 1, a system has a toggle, ex. hotkey, radio button.
2. When CRBT returns 2 or 3, a system has a slider switch

The only difference of 0 and 1 (or 2 and 3) is the presence of a
wireless LED. However I believe this is defined according to
Microsoft's hardware requirement.


>
> See the acpidumps Alex uploaded. The Inspiron 3543 returns 0 when
> CRBT is called and so does the Inspiron 7447. However, the former
> doesn't have a working ARBT method and, if I'm not wrong, its BIOS
> doesn't handle radio devices. The BIOS of the latter can handle
> radio and has a working ARBT method to make it stop from doing that.
>
> Since we determine when the BIOS might not be able to control radio
> devices through CRBT and we can't say it for sure (in the example
> above, CRBT returned the same value), we make sure that the BIOS
> doesn't handle radio devices by calling ARBT. We can ensure this
> (e.g. Inspirong 7447), but we can't ensure the opposite (e.g.
> Inspiron 3453).
>
> If there was a way to determine which laptop really needs
> dell-wireless, calling ARBT wouldn't have been necessary, but that's
> not the case. Users can always blacklist the module if they know
> their laptop can work as expected without it, but we have to ensure
> that everything always works.
>
> This is what I understood by looking at the acpidumps, so I could
> be wrong.
>

I think ARBT acts as a switch for changing BIOS behaviours:

When ARBT is not called or is called with ARBT(0), BIOS's default
behaviour is to change wireless states by hardware pin. When ARBT(1)
is called by driver or userspace application (ex. required in Windows
8), wireless state is controlled by OS. Similar functions are defined
in ASUS ATK and HP WMI. Such implementation will provide maximum
capability for different OS with / without dedicate drivers.

The reality is never such wonderful; especially many systems are only
tested with Win8 + driver (some may tested with Win7 - and
acpi_osi=!Windows 2012 / 2013 will probably work). In this case, we
probably need to be more compatible with Windows 8 / 8.1.

>> And second note: Do we need some driver for acpi DELLABCE device?
>> Which problem is trying acpi DELLABCE device to solve? Is not
>> everything working fine without driver for DELLABCE device?
>
> As I wrote above, DELLABCE is for those systems whose BIOS doesn't
> handle radio devices and expects the OS do everything when Fn keys
> are pressed.
> (Well, it actually seems that something is done by the keyboard
> controller, but this is not certain yet)
>
>> My dell-rbtn approach is trying to export rfkill interface from
>> DELLABCE device and eliminate using i8042 hook function in smbios
>> dell-laptop driver.
>>
>> Alex, can you check if scancode of wireless change generated by
>> BIOS is on all machines same: 136 (0x88)? And is send by keyboard
>> controller (not acpi/wmi)?
>
> I can say that on my XPS13 the scancode is 0x88 and it is sent by
> the keyboard controller.
>
> Gabriele

Just before I check the scancode, I looked up the scancode table
(http://download.microsoft.com/download/1/6/1/161ba512-40e2-4cc9-843a-923143f3456c/translate.pdf)
and found 0x88 is already used - it is the "break" ("release" in Linux
term) code for "7" (the one above Y/U, not number pad). It can be
verified by "showkey -s": 0x08 for press and 0x88 for release. It is
not the best idea to map this scancode to anything else.

I also sent emails for this scancode last week but it is a holiday
season but I don't expect to receive any feedback this year...

-- 
Cheers,
Alex Hung
