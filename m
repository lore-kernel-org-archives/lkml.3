Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab3FKKjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 06:39:42 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:8735 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754065Ab3FKKjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 06:39:40 -0400
Message-ID: <51B6FE69.6060505@itdev.co.uk>
Date: Tue, 11 Jun 2013 11:39:37 +0100
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
References: <20130606100346.GC1883@sirena.org.uk> <51B0651D.3090902@itdev.co.uk> <20130606105530.GT31367@sirena.org.uk> <51B06FE4.7040805@itdev.co.uk> <20130606131638.GX31367@sirena.org.uk> <51B0B52C.1090807@itdev.co.uk> <20130606164629.GG31367@sirena.org.uk> <51B1F859.1010504@itdev.co.uk> <20130607154134.GU31367@sirena.org.uk> <51B20630.7000304@itdev.co.uk> <20130607164700.GW31367@sirena.org.uk>
In-Reply-To: <20130607164700.GW31367@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> I don't think you're using the usual definition of "register map" here.
> You seem to be switching between talking about this object model the
> device has and device registers - perhaps the objects are also registers
> sometimes?

Yes, in Atmel Object Protocol "instances" of "objects" do each have an
assigned register range (they do also correspond to modules of code in the
firmware).

This document is a better description of it than I can give:
http://www.atmel.com/Images/Atmel-9626-AT42-QTouch-BSW-AT421085-Object-Protocol-Guide_Datasheet.pdf

That's a rather old chip now, but the same system is used throughout
maXTouch series chips, and also on some non-touch chips now.

> You appear to be assuming a great deal of familiarity with the specifics
> of this device here.  Where does all thi stuff about reinitialsing the
> device come from?  What are these dependencies and what does all this
> have to do with setting parameters?

I think you're uncomfortable with the idea of giving full access by
default. I'm not sure how I can convince you that that is OK by design, I
can only assert it.

Essentially, the device is designed (and tested) on the assumption that
touch processing can be going on whilst various parameters are changed in a
live fashion. If poking around in the register map caused it to lock up or
behave oddly then that would be considered a firmware bug. In general it
will fail gracefully - for example if you write a configuration that is
invalid it will just stop and emit a CFGERR message.

In my previous messages in this thread, I tried to answer some of the
particular cases in which you might expect the driver to have to cope with
the configuration changing "under it". It's difficult to be exhaustive
without having to impart a huge amount of domain knowledge first.

In the patch under discussion, the driver would have to trap writes to
particular registers and take appropriate action, or provide a mechanism to
be told that it needs to reinitialise itself. In practice (it's been widely
tested outside of mainline) I haven't found a case where doing this has
been essential, although there's nothing about this patch that stops us
adding them.

The absolute worst thing that I can think of is that you can try to beat
the interrupt handler to reading the "message processor" registers, which
would possibly leave touches stuck on screen. But even that operation is
useful in debugging interrupt line issues.

>> OK. I think that the ABI offered to the application layer should also be
>> object protocol, implemented over a binary attribute, which is what the
>> patch under discussion does. Is the problem that I need to provide better
>> documentation of object protocol?
> 
> As Greg says you do need to document any new sysfs ABIs you're adding
> anyway.  However if this is some stateful protocol you're implementing
> then does it really map onto sysfs well, sysfs attributes are normally
> more just data values?

Perhaps it is a little unusual. There was an older ioctl-based
implementation, but I think that would be rejected for different reasons.

> Won't the driver end up getting into a fight with the magic userspace
> stuff if the driver has no idea what the magic userspace is doing?  How
> would suspend and resume work?

On suspend the driver puts chip into "deep sleep" where touch acquisition
is halted and minimal power consumed. But it will still come out of its
sleep state temporarily to service I2C comms if necessary (although one
particular family requires that I2C retry for this case).
