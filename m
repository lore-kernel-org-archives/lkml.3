Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396Ab3FGQLc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:11:32 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:56201 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754981Ab3FGQLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:11:30 -0400
Message-ID: <51B20630.7000304@itdev.co.uk>
Date: Fri, 07 Jun 2013 17:11:28 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Subject: Re: [PATCH 10/53] Input: atmel_mxt_ts - Add memory access interface
 via sysfs
References: <20130605210715.GA16013@core.coreip.homeip.net> <51AFAF6D.7050204@itdev.co.uk> <20130606100346.GC1883@sirena.org.uk> <51B0651D.3090902@itdev.co.uk> <20130606105530.GT31367@sirena.org.uk> <51B06FE4.7040805@itdev.co.uk> <20130606131638.GX31367@sirena.org.uk> <51B0B52C.1090807@itdev.co.uk> <20130606164629.GG31367@sirena.org.uk> <51B1F859.1010504@itdev.co.uk> <20130607154134.GU31367@sirena.org.uk>
In-Reply-To: <20130607154134.GU31367@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
>> OK. But if user-space is talking to the device based on register numbers, a
>> binary attribute seems like the correct way to present that - isn't that
>> what they're designed for?
> 
> I thought there was this protocol you're concerned aboout, not raw
> registers?  Presenting the actual data in binary form seems sane, how
> one gets to the data is the issue.

OK, so we seem to have gone round in a circle here. Initially I understood
you to say that providing a binary read/write attribute for access to the
configuration data was not acceptable.

>> The chip itself will enforce which registers are read-only (by ignoring
>> writes) or write-only (by returning zeros if read). Encoding all this
>> information in the driver would just make it more brittle in the face of
>> touch controller firmware updates.
> 
> So not only do you interact with the firmware via this protocol but the
> actual hardware register map is unstable

The register map is fixed at firmware compile time. The driver contains
code which parses the object table and figures out the correct register
offsets which are used on the particular chip that it is talking to.

The user space tools that we have written contain an equivalent parser. Is
it the duplication of this code that is your concern?

> and there's nothing in the
> device that the driver itself actually interacts with, all it does is
> ferry these messages from the application layer to the device?  Given
> the number of other patches here that doesn't seem to be the case...

The driver does interact with a subset of the registers. It's main job is
reading a certain "object" (set of registers) when triggered by interrupt,
which contain the touch reports which are passed to user space.

There are other registers that the driver uses, eg screen parameters, power
control, telling the device to reset.

Are you saying that your concern is that user space shouldn't be able to
directly access these registers, for example to trigger a reset? In which
case, how should user space reset the chip if required?

>> It would be possible for the driver to intermediate for some of the
>> registers that it cares about. For example, if we change the screen width
>> then the driver could reinitialise the input device. But I can't see that
>> it makes sense if you are changing several settings in a row for the input
>> device to be reinitialised several times. It is far less buggy to provide a
>> single way of tearing down everything and reinitialising (which could be
>> simply triggered from user space) than to encode all of the dependencies
>> (which is bound to introduce bugs).
> 
> I am having an extremely hard time connecting anything you're talking
> about here with the discussion at hand I'm afraid...

I'm trying to provide the background to this design as you've requested, I
apologise if you find it confusing.

> Nobody is talking about changing the protocol for interacting with the
> device.  The discussion here is about the ABI the driver offers to the
> application layer.

OK. I think that the ABI offered to the application layer should also be
object protocol, implemented over a binary attribute, which is what the
patch under discussion does. Is the problem that I need to provide better
documentation of object protocol?
