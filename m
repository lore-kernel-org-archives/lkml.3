Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700Ab3FFLfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 07:35:01 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:56679 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932374Ab3FFLfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 07:35:00 -0400
Message-ID: <51B073E1.30108@itdev.co.uk>
Date: Thu, 06 Jun 2013 12:34:57 +0100
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
References: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk> <7380889.l4hHqCT0mm@dtor-d630.eng.vmware.com> <51AF8730.4010507@itdev.co.uk> <1717403.GgHsbyUkDZ@dtor-d630.eng.vmware.com> <51AFA02B.3000604@itdev.co.uk> <20130605210715.GA16013@core.coreip.homeip.net> <20130606094822.GB1883@sirena.org.uk> <51B06732.2050701@itdev.co.uk> <20130606104651.GS31367@sirena.org.uk> <51B06BE6.80909@itdev.co.uk> <20130606111437.GV31367@sirena.org.uk>
In-Reply-To: <20130606111437.GV31367@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Thu, Jun 06, 2013 at 12:00:54PM +0100, Nick Dyer wrote:
>> Mark Brown wrote:
> 
>>> The retries can just be done further up the stack?  All regmap is doing
>>> with I/O errors is punting them straight back up to the caller so the
>>> caller can retry just as well using regmap as it can using the raw I/O
>>> protocol.
> 
>> It would have to be put into users of the debugfs interface as well.
>> There's quite tight timing required to make it work properly (see patch
>> [40/53]).
> 
> This is yet another reason for implementing the protocol properly
> instead of trying to bodge around the kernel.  It really seems like
> the biggest problem here is the decision to try to bodge the entire
> thing into userspace with no kernel support.

With the interface I am proposing it is handled properly, in the kernel driver.

>From an Atmel perspective, Linux is just another platform and we want to
use our existing investment in tools and documentation to manage & debug
chips embedded in Linux based devices. So providing a bridge using a
relatively simple API between the tools and the kernel driver is the
correct decision. I can't provide a 3D graph of live touch data in the
kernel driver, for instance.

>>> Without seeing the address thing it's hard to comment.
> 
>> Patch [36/53]. If the T5 message processor is from address 100-110, you can
>> do a read of 50 bytes starting at address 100, and it will return 10
>> messages, but anything in regmap that tries to do bounds checking would get
>> confused, I think.
> 
> That's just not going to be supported, sorry.  You can implement custom
> locks and access the device directly where you need to do stuff like
> that while still using regmap for actual registers though.

OK, fair enough.

>> Also, we would like to implement address pointer caching. maXTouch allows
>> us to skip the address part of the i2c transaction if the address pointer
>> in the chip hasn't changed. This speeds up interrupt handler slightly. But
>> it requires extra housekeeping at a low level to remember what the address
>> pointer was on the previous transaction to know whether to send it or not.
> 
> That sounded like what you were talking about, it's pretty common and is
> sane enough for reads.

The address pointer is shared between reads and writes on maXTouch, but I
guess that's not a huge problem.
