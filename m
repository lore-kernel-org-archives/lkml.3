Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbaLVH2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 02:28:00 -0500
Received: from mail-qg0-f52.google.com ([209.85.192.52]:47685 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbaLVH16 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 02:27:58 -0500
MIME-Version: 1.0
In-Reply-To: <2697957.miSb4Rm7HK@xps13>
References: <1416755361-17357-1-git-send-email-pali.rohar@gmail.com>
	<94523420.RuhoUzmTQs@xps13>
	<201412052223.25059@pali>
	<2697957.miSb4Rm7HK@xps13>
Date: Mon, 22 Dec 2014 15:27:57 +0800
Message-ID: <CAJ=jqubEggcXs0kvegGUpVh8PNh-GmdcnXkXUjqv4fHD-zXdEA@mail.gmail.com>
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

= Testing =

I tested six Dell systems for two sets of patches for dell radio
button - two system with radio slider and four with radio hotkey.
There are also two systems with working ARBT method.

== Basic Information ==
Based OS: Ubuntu 14.10 (kernel 3.16 [1]) and kernel 3.18 [2]

Patches:
1. dell-wireless v3 = original v2 + Gabriele's suggestion [3]
2. dell-rbtn [4]

Method:
1. run "rfkill list" and press hotkey / toggle slider during runtime
2. run "rfkill list" and toggle slider during S3

== Results ==

I summarized the tests in Google sheet as below. Please advise if
anyone has problem reading it.

https://docs.google.com/spreadsheets/d/1voffS6dNglwAExSGh3UmG__UAO2qfZ829CkJLPo06aI/edit?usp=sharing

PS. The document will stay as long as possible for future references.

== Summary ==

1. I did not observed a duplicated event. However, keycode 240
(unknown) is generated on many UUT. It is not issued by dell-laptop or
del-wmi. I am suspecting it is the other event Pali observes but it
can be the result of different distro.

2. Some system issues scancode "0xe0 0x73 0xe0 0xf3". It can also be
used toggle wireless state but this can also be distro-dependent. This
scancode does nothing on Ubuntu 14.10.

2. There are two systems with working ARBT (XPS 13 9333 and Inspiron
7447). Calling ARBT(1) changes BIOS behaviours, and this matches to
Dell's document. We should include it in the patch for maximum
capability.


[1] dell-wireless is only tested 3.16.
[2] dell-rbtn is tested on 3.16 and 3.18, but no differences are observed.
[3] http://people.canonical.com/~alexhung/dell-wireless/
[4] http://people.canonical.com/~alexhung/dell-rbtn/

On Sat, Dec 6, 2014 at 5:49 AM, Gabriele Mazzotta
<gabriele.mzt@gmail.com> wrote:
> On Friday 05 December 2014 22:23:25 Pali Rohár wrote:
>> On Friday 05 December 2014 22:12:42 Gabriele Mazzotta wrote:
>> > On Friday 05 December 2014 22:03:24 Pali Rohár wrote:
>> > > On Friday 05 December 2014 21:53:10 Gabriele Mazzotta wrote:
>> > > > On Friday 05 December 2014 21:38:17 Pali Rohár wrote:
>> > > > > On Wednesday 03 December 2014 14:00:23 Darren Hart wrote:
>> > > > > > On Thu, Dec 04, 2014 at 10:55:32AM +0100, Pali Rohár
>> wrote:
>> > > > > > > Darren, I think that if we do not solve problem with
>> > > > > > > duplicate key events (in dell-wireless.c) we should
>> > > > > > > postpone these patches to later kernel version. It
>> > > > > > > is better to not have such regression as it confuse
>> > > > > > > software like NetworkManager which is widely used.
>> > > > > >
>> > > > > > OK, that's what I needed. Thanks. Ignore my previous
>> > > > > > request, you answered it here. I will drop
>> > > > > > dell-wireless.c and look for a combined solution from
>> > > > > > you and Alex for the next release.
>> > > > > >
>> > > > > > Thanks,
>> > > > >
>> > > > > And according to discussion about Side effect of
>> > > > > pressing special keys at [1] [2] we should not report
>> > > > > this wireless key event (as input device) to userspace.
>> > > > > And Alex's driver is doing that.
>> > > > >
>> > > > > [1] -
>> > > > > http://www.spinics.net/lists/platform-driver-x86/msg0592
>> > > > > 2.h tml [2] -
>> > > > > http://www.spinics.net/lists/platform-driver-x86/msg0592
>> > > > > 4.h tml
>> > > >
>> > > > Alex's patch is for those laptop whose BIOS only sends a
>> > > > notification to DELLABCE when Fn keys are pressed. His
>> > > > patch simply translates these ACPI notifications to
>> > > > KEY_RFKILL keypresses.
>> > >
>> > > Yes, and your last patch disables sending such KEY events to
>> > > userspace (in dell-wmi driver). BIOS already handle changes,
>> > > so key press should not be reported to userspace... [1]
>> > > (from previous email).
>> >
>> > This is not true if ARBT (with 1 as parameter) is called. When
>> > this is done, the BIOS stops managing the radio devices
>> > completely and reporting KEY_RFKILL to userspace becomes a
>> > necessity. I guess that the laptops on which this patch was
>> > tested behaved like mine after ARBT is called, given that the
>> > call was missing completely in the original patch.
>> >
>>
>> Ok. It means that at least original Alex patch needs to be
>> reworked (so we will do not see duplicate events problem and
>> problem described in previous email).
>>
>> But my other question is... If ARBT(1) is called then it disables
>> BIOS support for managing radio devices on your laptop. Why we
>> need patch which disabling useful functionality (= ability to
>> disable wifi rfkill)? We still do not have patch which can
>> correctly set rfkill state by software on laptops of your fn key
>> type.
>
> That's what happens on my laptop, but Alex said that the laptops on
> which he worked, ARBT was empty, so I guess it's not always a choice.
> In order not to break things, all the laptops that support both the
> methods must be set to the correct mode through ARBT when the module
> is loaded. If this is not done, then what you say is correct, we should
> not report KEY_RFKILL, or at least do it selectively, but I guess that
> this is not be possible without a whitelist (that we don't have).
>
>> > > > Correct if I'm wrong, but shouldn't his patch have no
>> > > > effects on your laptop? If I'm not wrong, CRBT returns 2
>> > > > on your laptop, so the input device is not even created.
>> > > > Am I missing something?
>> > > >
>> > > > Gabriele
>> > >
>> > > Yes, it has no effect for my laptop.
>>
>>
>



-- 
Cheers,
Alex Hung
