Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbaETPww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 11:52:52 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:42833 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbaETPwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 11:52:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140520152551.GB9444@core.coreip.homeip.net>
References: <77BC725C9062764F874D79F51E1F1A8F40C14099@S04-MBX01-01.s04.local>
	<20140520034302.GB986@core.coreip.homeip.net>
	<1507406.BNOsJcxmP9@vostro.rjw.lan>
	<20140520152551.GB9444@core.coreip.homeip.net>
Date: Tue, 20 May 2014 08:52:50 -0700
Message-ID: <CANLzEkt1M2WuXZT56pQv7asFAWQKC6LqwTyuiz=P9VA0oYdG-w@mail.gmail.com>
Subject: Re: [PATCH 4/6] input: cyapa: enable/disable trackpad device based on
 LID state
From: Benson Leung <bleung@google.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Dudley Du <dudl@cypress.com>,
        Daniel Kurtz <djkurtz@google.com>, David Solda <dso@cypress.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry and Rafael,

I can provide more insight here since I implemented an early version
of this in the atmel and cyapa drivers that are used in the chromeos
kernel.

On Tue, May 20, 2014 at 8:25 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Tue, May 20, 2014 at 02:40:12PM +0200, Rafael J. Wysocki wrote:
>> On Monday, May 19, 2014 08:43:02 PM Dmitry Torokhov wrote:
>> > Hi Dudley,
>> >
>> > On Wed, Apr 16, 2014 at 08:39:34AM +0000, Dudley Du wrote:
>> > > Rely on EV_SW and SW_LID bits to identify a LID device, and hook
>> > > up our filter to listen for SW_LID events to enable/disable touchpad when
>> > > LID is open/closed.
>> > > TEST=test on Chomebooks.
>> >
>> > This is a policy and it does not belong in the kernel. Please work with
>> > Rafael to establish generic interface to put devices into low power mode
>> > (like accelerating runtime PM idle timeout)
>>
>> I'm not really sure what you mean here, care to be more specific?
>
> I think we chatted about this before - we need a uniform interface for
> userspace to put devices into low power mode on demand. As
> implementation detail I thought we could require runtime PM for that and
> simply pretend that the PM timeout expired early when userspace invokes
> that API.
>
>>
>> > and use it when userspace detects that lid is closed.
>>
>> I guess we get an event then, don't we?
>
> Right, userspace gets EV_SW/SW_LID input event and needs to react. In
> this particular case the desire is to power down touchpad (since it is
> unaccessible). I am not sure why system suspend (which I expect happen
> in reaction to lid closing) is not enough, but that's question for
> Dudley.


Waiting for system suspend isn't sufficient here because system
suspend takes some time to trigger from user space, and in that time,
the B panel of the laptop may couple with the active trackpad, or the
C panel with the active touchscreen. This may generate stray input
events, which may in turn cancel the suspend if the drivers use
pm_wakeup_event(), and those input events may trigger something
unwanted in the UI (think, accidentally one-click buy something on
Amazon, etc).

I came up with a requirement: When the lid is closed, as soon as
possible, the devices must be off. That's part of the reason why
Dudley's patch does it in the kernel rather than doing the round trip
to user space.

Furthermore, the policy on lid close is not always to enter suspend.
We have something called Docked Mode, which allows the system to not
suspend while the lid is closed if there's an external monitor
attached. In this case, the touch devices must be disabled as well as
again they risk generating stray events with the lid closed.

I'd prefer if there was some way to establish a relationship between
the lid and devices that must be power managed differently depending
on the state of the lid, rather than leaving it to user space to
manage the power management of these devices in real time and open up
the possibility of race conditions there if user space is too slow.

Thanks!

-- 
Benson Leung
Software Engineer, Chrome OS
Google Inc.
bleung@google.com
