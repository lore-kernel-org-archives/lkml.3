Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518Ab3FFLA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 07:00:58 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:8616 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751521Ab3FFLA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 07:00:57 -0400
Message-ID: <51B06BE6.80909@itdev.co.uk>
Date: Thu, 06 Jun 2013 12:00:54 +0100
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
References: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk> <7380889.l4hHqCT0mm@dtor-d630.eng.vmware.com> <51AF8730.4010507@itdev.co.uk> <1717403.GgHsbyUkDZ@dtor-d630.eng.vmware.com> <51AFA02B.3000604@itdev.co.uk> <20130605210715.GA16013@core.coreip.homeip.net> <20130606094822.GB1883@sirena.org.uk> <51B06732.2050701@itdev.co.uk> <20130606104651.GS31367@sirena.org.uk>
In-Reply-To: <20130606104651.GS31367@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Thu, Jun 06, 2013 at 11:40:50AM +0100, Nick Dyer wrote:
> 
>> I am more worried about the address pointer handling and the I2C retries.
> 
> The retries can just be done further up the stack?  All regmap is doing
> with I/O errors is punting them straight back up to the caller so the
> caller can retry just as well using regmap as it can using the raw I/O
> protocol.

It would have to be put into users of the debugfs interface as well.
There's quite tight timing required to make it work properly (see patch
[40/53]).

> Without seeing the address thing it's hard to comment.

Patch [36/53]. If the T5 message processor is from address 100-110, you can
do a read of 50 bytes starting at address 100, and it will return 10
messages, but anything in regmap that tries to do bounds checking would get
confused, I think.

Also, we would like to implement address pointer caching. maXTouch allows
us to skip the address part of the i2c transaction if the address pointer
in the chip hasn't changed. This speeds up interrupt handler slightly. But
it requires extra housekeeping at a low level to remember what the address
pointer was on the previous transaction to know whether to send it or not.
