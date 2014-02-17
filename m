Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbaBQBs6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 20:48:58 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:61020 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbaBQBs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 20:48:57 -0500
MIME-Version: 1.0
In-Reply-To: <35710038.vGLtzuIoLe@avalon>
References: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<1790131.DSZsj6HrSK@avalon>
	<CANqRtoROALpUqi8rKWRpQk7LGc0BqU14AKg-2MgYBMNoEFGA4Q@mail.gmail.com>
	<35710038.vGLtzuIoLe@avalon>
Date: Mon, 17 Feb 2014 10:48:55 +0900
Message-ID: <CANqRtoRVCK0jgadwvreMRt1HVVyUmb-CLt5mFEGmvju_VFFbPQ@mail.gmail.com>
Subject: Re: [PATCH 23/27] clocksource: sh_cmt: Add DT support
From: Magnus Damm <magnus.damm@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Mon, Feb 17, 2014 at 10:45 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Magnus,
>
> On Saturday 15 February 2014 02:22:00 Magnus Damm wrote:
>> On Sat, Feb 15, 2014 at 1:12 AM, Laurent Pinchart wrote:
>> > On Saturday 15 February 2014 01:01:30 Magnus Damm wrote:
>> >> On Sat, Feb 15, 2014 at 12:53 AM, Laurent Pinchart wrote:
>> >> > On Friday 14 February 2014 10:58:22 Mark Rutland wrote:
>> >> >> On Fri, Feb 14, 2014 at 01:00:01AM +0000, Laurent Pinchart wrote:
>> >> >> > +Channels Optional Properties:
>> >> >> > +
>> >> >> > +  - clock-source-rating: rating of the timer as a clock source
>> >> >> > device.
>> >> >> > +  - clock-event-rating: rating of the timer as a clock event
>> >> >> > device.
>> >> >>
>> >> >> This feels like a leak of Linux internals. Why do you need this?
>> >> >
>> >> > You're right, it is. The clock source and clock event ratings are
>> >> > currently configured through platform data, I'll need to find a way to
>> >> > compute them in the driver instead.
>> >>
>> >> That would be very good!
>> >
>> > Any pointer would be appreciated :-) How did you compute the various
>> > ratings used in platform data all over the place ?
>>
>> Historically we used the rating to select between CMT and TMU. For
>> clock sources I suppose you also have the jiffy rating to consider.
>> And for the SMP parts we have ARM IP for TWD and arch timers that have
>> their ratings too. So you need to check all the timers on a particular
>> system and consider what you want to have operating by default. The
>> ARM IP timers should be preferred if available. For clock sources the
>> rule is probably the higher resolution the better.
>>
>> >> > There's still one piece of Linux-specific data I need though, as I need
>> >> > to specify for each channel whether to use it as a clock source device,
>> >> > a clock event device, both of them or none. That's configuration
>> >> > information that needs to be provided somehow.
>> >>
>> >> I think you can decide clock source or clock event assignment based on
>> >> number of channels available. If you have only a single channel then both
>> >> clock event and clock source need to be supported. Otherwise use one
>> >> channel for clock source and the rest for clock events.
>> >
>> > That won't match the current situation. Look at CMT0 in r8a7790 for
>> > instance. There's two hardware channels available, and we only use the
>> > first one, for clock events only.
>>
>> You are correct. The reason for that is that the CMT driver today is
>> optimized for combined clock event and clock source operation.
>>
>> Historically the hardware it initially was written for (sh-mobile on
>> the SH arch) only had a single timer channel so combined operation was
>> required for tickless to work. But since you're asking how to allocate
>> channels then I propose checking numbers of channels available and go
>> from there. With that the r8a7790 support can only get better. =)
>>
>> >> This is probably out of scope for this DT conversion, but it would be
>> >> neat if you somehow could specify the CPU affinity for a channel to tie a
>> >> clock event to an individual CPU core. This would make a a per-cpu timer
>> >> unless I'm mistaken. But that's more of a software policy than anything
>> >> else.
>> >
>> > Yes, that's a configuration that needs to be specified somewhere. I don't
>> > know where though.
>>
>> As long as you have per-channel interrupts described in DT you can
>> probably handle this in a generic way in the driver.
>
> But how do we decide whether to use a single timer channel or one channel per
> CPU ? Will the kernel use one clock event device per CPU automatically ? I
> have to confess I have no idea how this works.

I guess that's the tricky bit about timer support, it is a mix of
hardware description and software configuration. So it sounds to me
that we need some kind of software configuration interface. But it can
probably be considered when/if we add such kind of support to the
driver. Probably out of scope for now.

Regardless it seems to me that the hardware description in DT doesn't
need to care about this.

Cheers,

/ magnus
