Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992445AbaEPTYD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 15:24:03 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:62119 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932446AbaEPTX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 15:23:58 -0400
MIME-Version: 1.0
In-Reply-To: <20140430231307.GA10250@e106331-lin.cambridge.arm.com>
References: <CANCKTBuOK41=ZxHcDRthc0uc81-nDr_66veeQvUDNjsKq85OSw@mail.gmail.com>
 <20140430231307.GA10250@e106331-lin.cambridge.arm.com>
From: Mike Turquette <mturquette@linaro.org>
Date: Fri, 16 May 2014 12:23:37 -0700
Message-ID: <CAPtuhTissRRQ6bPG0pp_e-NZ+ReaMtxWefAGq2kjFEcdmh_LEg@mail.gmail.com>
Subject: Re: [RFC] Linux common clock framework: device with many clocks
To: Mark Rutland <mark.rutland@arm.com>
Cc: Jim Quinlan <jim2101024@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 4:13 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> Hi,

Thanks for Cc'ing me Mark.

>
> On Wed, Apr 30, 2014 at 09:39:11PM +0100, Jim Quinlan wrote:
>> In most examples of .dtsi files I have perused, a device is associated with
>> typically one clock, maybe two.  In the SoC I'm working on, some devices
>> need to turn off multiple clocks for PM, as many as 13.   The driver gets
>> the clocks from the device tree, and when the driver wants to turn off
>> clocks to the device, it loops through all 13 clocks.
>>
>> I'm wondering if is possible to abstract a group of many clocks into one
>> "software clock". Invoking clk_disable() on said software clock would
>> effect the iteration of clk_disable() on all 13 of the clocks it governs.
>>  Enabling would effect clk_enable() on all 13.  This would make the driver
>> writer's life a little simpler.
>>
>> I've looked at the Linux Common Clock Framework, and it doesn't really
>> accommodate multiple active parents as it's somewhat contrary to its
>> design.  Also, playing with the innards of clk.c is ill-advised.  Should I
>> just stick to putting iteration over the clocks in all my drivers, or is
>> there a better way?
>
> This doesn't strike me as a DT issue. The DT should describe all the
> clocks that a given block takes, and the representation of said clocks
> in the DT is completely separate matter from the management of said
> clocks in any given driver.
>
> If you want a helpful abstraction for combining clocks for management
> purposes you'd be better off talking to Mike Turquette (CC'd), as he's
> in charge of the common clock framework.

Jim emailed me privately. Here is my response for posterity:



On Wed, May 7, 2014 at 8:59 AM, Jim Quinlan <jquinlan@broadcom.com> wrote:
> Hi Mike,

Hi Jim,

<snip>

> In most examples of .dtsi files I have perused, a device is associated with
> typically one clock, maybe two.  In the SoC I'm working on, some devices
> need to turn off multiple clocks for PM, as many as 13.   The driver gets
> the clocks from the device tree, and when the driver wants to turn on/off
> clocks to the device, it loops through all 13 clocks.

Is it possible for you to share a data sheet or TRM for this part? I'd
like to better understand your 13 clock requirement.

Is your device driver upstream? If not, can you share a link to bcom's
public vendor git tree with the driver in question?

> I'm wondering if is possible to abstract a group of many clocks into one
> "software clock". Invoking clk_disable() on said software clock would
> effect the iteration of clk_disable() on all 13 of the clocks it governs.

I oppose "software clocks", "virtual clocks" or any kind of struct clk
that doesn't map onto real clock hardware directly.

> Enabling would effect clk_enable() on all 13.  This would make the driver
> writer's life a little simpler.

What you are asking for is an abstraction. We already have this in the
form of Runtime PM where a driver calls pm_runtime_get() and
pm_runtime_put() without having to worry about the details of enabling
and disabling those 13 clocks. Runtime PM is *the* abstraction you are
looking for.

You should check out the RPM stuff as well as the power_domain and
gen_pd stuff. OMAP, SH-Mobile and Ux500 have interesting
implementations of all of this stuff for rather complex SoCs.

> I've looked at the Linux Common Clock Framework, and it doesn't really
> accommodate multiple active parents as it's somewhat contrary to its
> design.  Also, playing with the innards of clk.c is ill-advised.  Should I
> just stick to putting iteration over the clocks in all my drivers, or is
> there a better way?

Can you elaborate on "multiple active parents"? What does that mean?

Regards,
Mike



>
> Cheers,
> Mark.
