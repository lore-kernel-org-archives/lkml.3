Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab3FKMQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 08:16:34 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:10055 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754814Ab3FKMQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 08:16:33 -0400
Message-ID: <51B7151F.5070307@itdev.co.uk>
Date: Tue, 11 Jun 2013 13:16:31 +0100
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
References: <20130606105530.GT31367@sirena.org.uk> <51B06FE4.7040805@itdev.co.uk> <20130606131638.GX31367@sirena.org.uk> <51B0B52C.1090807@itdev.co.uk> <20130606164629.GG31367@sirena.org.uk> <51B1F859.1010504@itdev.co.uk> <20130607154134.GU31367@sirena.org.uk> <51B20630.7000304@itdev.co.uk> <20130607164700.GW31367@sirena.org.uk> <51B6FE69.6060505@itdev.co.uk> <20130611114727.GY1403@sirena.org.uk>
In-Reply-To: <20130611114727.GY1403@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
>> Essentially, the device is designed (and tested) on the assumption that
>> touch processing can be going on whilst various parameters are changed in a
>> live fashion. If poking around in the register map caused it to lock up or
>> behave oddly then that would be considered a firmware bug. In general it
>> will fail gracefully - for example if you write a configuration that is
>> invalid it will just stop and emit a CFGERR message.
> 
> That's not really it, it's the fact that this is being done with no
> abstraction - exposing the entire device register map directly to
> application layer so the application can totally ignore what's going on
> in the kernel doesn't seem like awesome design.

Without being able to name all of the registers (which would require a
large amount of architecture to keep up-to-date and would probably turn
into an unmaintainable mess), you can only split up the register map into
separate parts. You'd end up with binary attributes like this (refer to the
document I linked for explanation):

info_block
object_table
t5
t6
t9instance1
t9instance2
etc

Is that a nicer design from your point of view? I don't personally think
that is really gains anything functional other than making the API more
complex and increasing the number of read/write operations. I guess you
would stop bugs in user space code from accidentally writing into the wrong
object.

>> The absolute worst thing that I can think of is that you can try to beat
>> the interrupt handler to reading the "message processor" registers, which
>> would possibly leave touches stuck on screen. But even that operation is
>> useful in debugging interrupt line issues.
> 
> Well, there's also the potential issues with standard application layer
> code either not being able to do things that the hardware supports or
> getting into a fight with the magic custom stuff.

I think it's better to present a clean API cut at the right level. If you
look at the drivers in various Android trees for these maXTouch chips,
there's an awful lot of phone specific code which is not very general and
it would be impossible to mainline without having a 20,000 line driver full
of #ifdefs. Surely it's better for that to go into a userspace daemon if
possible?

>> On suspend the driver puts chip into "deep sleep" where touch acquisition
>> is halted and minimal power consumed. But it will still come out of its
>> sleep state temporarily to service I2C comms if necessary (although one
>> particular family requires that I2C retry for this case).
> 
> So these errors are just part of waking the chip up - in that case
> shouldn't the driver be waking the chip up automatically?

In the reference design for that particular model of chip (mXT1386), there
is a WAKEUP pin cross-wired to an I2C line. The only way of getting it to
wake up when it is asleep is by trying to perform an I2C operation, which
will fail, and then retrying before it times out and goes back to sleep
again. There isn't any other way of waking it up.
