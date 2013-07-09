Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab3GINkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 09:40:35 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:43276 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab3GINkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 09:40:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAE7qMrosUkhF3Yak11Mh81NcGhYduUKRoHiUwH4RbTN1KXqi8A@mail.gmail.com>
References: <1315638713-3731-1-git-send-email-benjamin.tissoires@gmail.com>
	<20110910072826.GA1611@x4.trippels.de>
	<CAN+gG=H2jfT2zdn5H19hyn9JtDU7U1ensX_aUDgv0jk4d81jXg@mail.gmail.com>
	<CAN+gG=E90-y--6C-Ok8TibcFZGAaL2X-KxnchquDLCUUniip1Q@mail.gmail.com>
	<alpine.LNX.2.00.1306271513180.3538@pobox.suse.cz>
	<CAE7qMrosUkhF3Yak11Mh81NcGhYduUKRoHiUwH4RbTN1KXqi8A@mail.gmail.com>
Date: Tue, 9 Jul 2013 15:40:31 +0200
Message-ID: <CAN+gG=HNSzg_W-26vMb2seWNU+QcO3+wv4Z1AmZ36LqPhbzdEg@mail.gmail.com>
Subject: Re: Logitech M705: Thumb button (was Re: [PATCH v4] HID: Add full
 support for Logitech Unifying receivers)
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Nestor Lopez Casado <nlopezcasad@logitech.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Richard Titmuss <rtitmuss@logitech.com>,
        Olivier Gay <ogay@logitech.com>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Daniel Zanone <jzanone@logitech.com>,
        =?UTF-8?Q?Franti=C5=A1ek_Fuka?= <fuka@fuxoft.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nestor,

On Wed, Jul 3, 2013 at 12:46 PM, Nestor Lopez Casado
<nlopezcasad@logitech.com> wrote:
> Hi all,
>
> Sorry it took me some time to answer.
>
> I extended the Logitech HIDPP10 specification here:
> https://drive.google.com/folderview?id=0BxbRzx7vEV7eWmgwazJ3NUFfQ28&usp=sharing

Thanks :)

> [...]
>> Let me resurrect this 2 years old thread, as I have received multiple
>> reports since then, stating that some revisions of M705 don't have working
>> thumb button.
>>
>> Question mostly to the Logitech guys: Nestor, Olivier, could you please
>> provide us with the sequence that needs to be sent to (certain revisisons
>> of) M705 to let enter the debug mode, making the thumb button actually
>> emit a USB message?
>
>
> There are two versions of FW in the field:
>
> 1) Version 17.01.Build 0017.
> This version reports the thumb button by default as HID button 6.
>
> 2) Version 17.00.Build 0015
> This version does not report the thumb button by default.
>
> It is possible to enable the M705 with FW 17.00.Build 0015 to send the
> thumb button as HID button 6 via HIDPP10 command. But this will have a
> (undesirable ?) side effect.
> Once the button 6 is enabled, the buttons aside to the wheel (tilt
> buttons) will no longer be reported as AC pan HID usage, they will be
> reported as buttons 7 & 8. This might disrupt some users that rely on
> the mouse AC pan feature.

This side effect can be solved by handling the magic sequence in the
kernel, and do the mapping in the kernel also.
This would need to add a special driver for the M705 though. The good
point is that both the firmware behave the same way when they are
switched to the special mode, meaning that we don't need to check the
build number and do the switch as soon as we see the M705 PID.

>
> To enable HID button 6 reporting from thumb button we need to clear
> the bit 1 (Special button function) in register 0x01 on the M705
> READ register: 10 IDX 81 01 r0 r1 r2
> Clear Bit1: r0 &= 0xFD;
> Write back register: 10 IDX 80 01 r0 r1 r2
>
> IDX is the device index on the Unifying receiver.
>
> Note that if the command is sent to all M705 devices, users that have
> the  17.01.Build 0017 will lose the Ac pan and will gain nothing.
>

For those who wants to try, I have set up a project [1] to implement
part of the spec Nestor released.
I implemented various features: list devices paired to a receiver,
pair/unpair a device, and toggle the button 6 on M705 mouse with the
faulty firmware.
When switching mode for the M705, as Nestor said, we lose the AC
panning ability until the correct remapping is done in the kernel.

Cheers,
Benjamin


[1] https://github.com/bentiss/uLogitech
