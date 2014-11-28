Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbaK1WHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 17:07:17 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:56333 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaK1WHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 17:07:15 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Fri, 28 Nov 2014 23:09:09 +0100
From: Stefan Agner <stefan@agner.ch>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, shawn.guo@linaro.org,
        kernel@pengutronix.de, linux@roeck-us.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: imx: src: support vf610 system reset controller
In-Reply-To: <2716009.DOfHfaSPkY@wuerfel>
References: <1417193015-6033-1-git-send-email-stefan@agner.ch>
 <34359137.rt8QrS7shW@wuerfel> <7cd7c820d32cb04fa1d59889d16666a9@agner.ch>
 <2716009.DOfHfaSPkY@wuerfel>
Message-ID: <6341b31998ff843d236bc2a3e34537b0@agner.ch>
User-Agent: Roundcube Webmail/1.0.3
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Fri Nov 28 23:06:43 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5478f1f312814568020638
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-11-28 22:24, Arnd Bergmann wrote:
> On Friday 28 November 2014 22:02:01 Stefan Agner wrote:
>> On 2014-11-28 17:49, Arnd Bergmann wrote:
>> > On Friday 28 November 2014 17:43:35 Stefan Agner wrote:
>> >> Support Vybrid SoC's system reset controller (SRC). Currently we
>> >> don't register a reset controller but only support the imx_cpu_jump
>> >> and imx_cpu_arg functions.
>> >>
>> >> Signed-off-by: Stefan Agner <stefan@agner.ch>
>> >
>> > I think this should be a platform driver in drivers/power/reset.
>>
>> Yeah, I thought that too, see my cover letter. The problem is, in that
>> module are also some register which are of interest when implementing
>> suspend/resume support (see cover letter too). However, we could also
>> just make a dt entry for that reset register only, and create another dt
>> entry for the other registers.
> 
> Don't make a node with just one register, in this case, a syscon device
> would be best.

Syscon seems like a match here. Was not aware of that, thx!

> 
>> > If the SRC is also capable of resetting individual blocks instead of just
>> > the entire machine, it would be a reset driver in drivers/reset instead.
>>
>> Beside the system reset, there is only a mask functionality for the
>> watchdogs (there are two watchdogs, one for Cortex-A5 and one for the
>> M4). This makes the SRC module in the Vybrid a bit different then what
>> is available on other i.MX SoC's...
> 
> If you already have the watchdog registers in there and want to have
> a watchdog driver too, the easiest way would be to register the reboot
> handler from the watchdog driver.

Hm, not sure we speak about the same here. The SRC module has two
(multi-)bit fields to mask the watchdog reset event for each watchdog.
Beside that, there are two full watchdog register maps, which are in
different areas. There is already a driver for this watchdogs. I'm not
sure what the idea behind this is exactly, I guess it would easily allow
to (temporary) mask the other CPU's watchdog. However, I don't think we
need that functionality, so I don't care about that right now.

There is also a restart handler in the watchdog driver, but I prefer to
use the reset capabilities of the SRC since it has immediate effect. 

Lets get to the big picture again: I could register the whole SRC
register map as a syscon device and then access the registers from my
suspend/resume implementation later on. And similar in the restart
driver, I would use syscon_regmap_lookup_by_compatible to check if it
contains the vf610-src compatible string and register the restart
driver/handler if available.

--
Stefan

