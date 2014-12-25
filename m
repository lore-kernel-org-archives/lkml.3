Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaLYDNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 22:13:06 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:49340 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbaLYDNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 22:13:04 -0500
MIME-Version: 1.0
In-Reply-To: <5019255.GNGyxISxsX@xps13>
References: <1416755361-17357-1-git-send-email-pali.rohar@gmail.com>
	<1675821.m9zcYReJQs@xps13>
	<CAJ=jquawd2u4eFfA+8ytA9Na18vs-t1dPUJ-huMQmhPZ_tcGyA@mail.gmail.com>
	<5019255.GNGyxISxsX@xps13>
Date: Thu, 25 Dec 2014 11:13:02 +0800
Message-ID: <CAJ=jquaeyz4NnT2Wg7MaLHrLF1+ARXfds-Z-hRvYyk8SvQGTKQ@mail.gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I usually prefer to stick with formal document as everything else can
be changed without reasons.

I am not certain whether the keypress is defined in Dell's document,
and I will confirm with Dell. If this keypress is well defined, it is
a good idea to use it.


On Wed, Dec 24, 2014 at 7:40 PM, Gabriele Mazzotta
<gabriele.mzt@gmail.com> wrote:
> On Wednesday 24 December 2014 17:13:45 Alex Hung wrote:
>> I uploaded acpidump files [1] (except for XPS 13 which is not
>> available), and this should help clarify what has been tested.
>>
>> Does Inspirion 5721 does not have either DELLABCE or DELRBTN. It is
>> used for comparison. My apologies that I did not point this out in
>> previous email.
>>
>> When calling ARBT(1), BIOS will no longer issue scancode and will not
>> pull low hardware pin "W_DISABLE#" on mini card. This essentially
>> gives all wireless control to OS. This is likely the answer to
>> Microsoft's Windows Certification Program
>> System.Client.RadioManagement.HardwareButton [2] as below:
>>
>> =============================================
>> If a PC has a physical (hardware) button switch on a PC that turns
>> wireless radios on and off, it must be software controllable and
>> interact appropriately with the Radio Management UI
>> =============================================
>>
>> Dell's BIOS does issue a notify(RBTN, 0x80). This is done purposely to
>> re-enumerate the state of radio switch which may be changed when
>> system is in S3 or S4. I think this should not occur when CRBT returns
>> 0 or 1 (for hotkey that cannot be changed during S3 or S4), but that's
>> how it is done currently.
>
> The notification is sent on my XPS13 (CRBT returns 0), toggling the WiFi
> state on resume.
>
>> dell-wireless does not handle this notification in S3 or S4 for
>> following reasons:
>>
>> 1. dell-wireless does not handle slider (i.e. CRBT = 2 or 3). Device
>> drivers should read the hardware pin, "W_DISABLE#" on mini spec and
>> change hard block accordingly. This pin is commonly used by OEM today.
>>
>> 2. it is not possible to distinguish the notification (0x80) from
>> hotkey press or S3/S4. I also concerned this may mis-trigger state
>> change when resuming from S3 or S4, but it does not. Does any know how
>> to ignore this notification during resume only?
>>
>> dell-rbtn can use this notification + method (GRBT) [2] to solve the
>> problem that slider state.
>
> Unfortunately this won't solve the problem for me. After ARBT is called
> with 1 as parameter, it seems that GRBT always returns 1.
>
> I don't know how to ignore the notification on resume, if not through
> a flag set by a PM callback.
>
> Given that all the tested laptops reported a keypress on the i8042
> bus, isn't it better to rely on that instead?
>
>> [1] http://people.canonical.com/~alexhung/dell-acpidump/
>> [2] http://msdn.microsoft.com/en-us/library/windows/hardware/jj128256.aspx
>> [3] It seems GRBT may not always be implemented...
>>
>> I'd love to do more tests and share the results on any particular
>> systems, but I may need some more detailed instructions.
>>
>>
>>
>> On Tue, Dec 23, 2014 at 3:16 AM, Gabriele Mazzotta
>> <gabriele.mzt@gmail.com> wrote:
>> > On Monday 22 December 2014 15:27:57 Alex Hung wrote:
>> >> = Testing =
>> >>
>> >> I tested six Dell systems for two sets of patches for dell radio
>> >> button - two system with radio slider and four with radio hotkey.
>> >> There are also two systems with working ARBT method.
>> >>
>> >> == Basic Information ==
>> >> Based OS: Ubuntu 14.10 (kernel 3.16 [1]) and kernel 3.18 [2]
>> >>
>> >> Patches:
>> >> 1. dell-wireless v3 = original v2 + Gabriele's suggestion [3]
>> >> 2. dell-rbtn [4]
>> >>
>> >> Method:
>> >> 1. run "rfkill list" and press hotkey / toggle slider during runtime
>> >> 2. run "rfkill list" and toggle slider during S3
>> >>
>> >> == Results ==
>> >>
>> >> I summarized the tests in Google sheet as below. Please advise if
>> >> anyone has problem reading it.
>> >>
>> >> https://docs.google.com/spreadsheets/d/1voffS6dNglwAExSGh3UmG__UAO2qfZ829CkJLPo06aI/edit?usp=sharing
>> >>
>> >> PS. The document will stay as long as possible for future references.
>> >>
>> >> == Summary ==
>> >>
>> >> 1. I did not observed a duplicated event. However, keycode 240
>> >> (unknown) is generated on many UUT. It is not issued by dell-laptop or
>> >> del-wmi. I am suspecting it is the other event Pali observes but it
>> >> can be the result of different distro.
>> >>
>> >> 2. Some system issues scancode "0xe0 0x73 0xe0 0xf3". It can also be
>> >> used toggle wireless state but this can also be distro-dependent. This
>> >> scancode does nothing on Ubuntu 14.10.
>> >>
>> >> 2. There are two systems with working ARBT (XPS 13 9333 and Inspiron
>> >> 7447). Calling ARBT(1) changes BIOS behaviours, and this matches to
>> >> Dell's document. We should include it in the patch for maximum
>> >> capability.
>> >>
>> >>
>> >> [1] dell-wireless is only tested 3.16.
>> >> [2] dell-rbtn is tested on 3.16 and 3.18, but no differences are observed.
>> >> [3] http://people.canonical.com/~alexhung/dell-wireless/
>> >> [4] http://people.canonical.com/~alexhung/dell-rbtn/
>> >
>> > I've just tried the last revision of dell-wireless and noticed that a
>> > notification (0x80) is sent to DELLABCE after a transition from S3 to
>> > S0, causing dell-wireless to send KEY_RFKILL. This shouldn't happen.
>> > Same thing for transitions from S4 to S0.
>> >
>> > Gabriele
>>
>>
>>
>>



-- 
Cheers,
Alex Hung
