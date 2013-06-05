Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164Ab3FEUbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 16:31:45 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:9468 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932065Ab3FEUbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:31:44 -0400
Message-ID: <51AFA02B.3000604@itdev.co.uk>
Date: Wed, 05 Jun 2013 21:31:39 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Subject: Re: [PATCH 10/53] Input: atmel_mxt_ts - Add memory access interface
 via sysfs
References: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk> <7380889.l4hHqCT0mm@dtor-d630.eng.vmware.com> <51AF8730.4010507@itdev.co.uk> <1717403.GgHsbyUkDZ@dtor-d630.eng.vmware.com>
In-Reply-To: <1717403.GgHsbyUkDZ@dtor-d630.eng.vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
>> We have made a deliberate choice to implement this via sysfs rather than
>> debugfs since it needs to work on devices that don't have debugfs enabled.
> 
> Then they will have to enable it. Re-implementing something because
> someone might not enable needed subsystem is not a good idea. Let's
> say somebody disabled I2C - will you write your own implementation because
> of that? Of course not, you just say that for given functionality it
> is a prerequisite.

debugfs is a debug filesystem. This interface is useful for purposes which
are not debug. I have to be pragmatic: I don't see debugfs enabled on most
shipping Android devices, and however much I tell them to enable debugfs
doesn't seem to hold much weight.

It's partly path dependence - it was implemented like this because regmap
wasn't in mainline at the point when I wrote it. Having a dependency on
regmap would now be a API break complicating support of customers using
older kernels than mainline. I would also have to update a bunch of
software and documentation and people to know about the two different APIs.
The existing implementation already appears in shipping devices, so it is
well tested.

>> In addition, there are some quirks about the way in which we have to
>> read/write registers which means regmap isn't a good fit.
> 
> Could you please elaborate more on this?

- the mxt chip caches the I2C read pointer, so you can get a performance
optimisation by not sending the address on every read/write (I haven't
implemented this yet but plan to)
- the address pointer can wrap around when you read the T5 message
processor, which would confuse regmap
- we require I2C retries in some cases due to way the chip handles sleep states
- I can't see how to map the object protocol (used on mxt chips) into the
way regmap treats register ranges

I can look into porting on top of regmap. But it seems a pity to pepper
regmap with atmel_mxt_ts quirks just to save on three small functions in
the driver.

Thanks for your time to look at this.

N
