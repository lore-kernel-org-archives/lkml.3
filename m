Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbaDOTSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 15:18:20 -0400
Received: from smtp-out-049.synserver.de ([212.40.185.49]:1048 "EHLO
	smtp-out-027.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754298AbaDOTSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 15:18:16 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 10161
Message-ID: <534D85F3.5050009@metafoo.de>
Date: Tue, 15 Apr 2014 21:18:11 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Chen-Yu Tsai <wens@csie.org>, Hans de Goede <hdegoede@redhat.com>,
        Carlo Caione <carlo@caione.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Subject: Re: [RFC PATCH v2] regmap: smbus: add support for regmap over smbus
References: <1397292335-5516-1-git-send-email-boris.brezillon@free-electrons.com> <1397480885-11962-1-git-send-email-boris.brezillon@free-electrons.com> <20140414210429.GJ25182@sirena.org.uk> <534CE16D.8010508@free-electrons.com> <20140415100922.GN12304@sirena.org.uk> <534D1DDA.40207@free-electrons.com> <534D252B.8060009@metafoo.de> <20140415125654.GD12304@sirena.org.uk> <534D357F.9040906@metafoo.de> <20140415164613.GF12304@sirena.org.uk>
In-Reply-To: <20140415164613.GF12304@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 06:46 PM, Mark Brown wrote:
> On Tue, Apr 15, 2014 at 03:34:55PM +0200, Lars-Peter Clausen wrote:
>> On 04/15/2014 02:56 PM, Mark Brown wrote:
>
>>>   - Providing APIs for registering actual smbus devices as a convenience
>>>     for devices with that constraint, regardless of how that is done
>>>     behind the scenes.
>
>>>   - Having the I2C implementation automatically use the smbus APIs if
>>>     it can and either the controller is smbus only or it makes sense to
>>>     do so for optimisation.
>
>> I don't think it makes sense to expose smbus explicitly. We can already
>> describe smbus restricted devices just fine with the current regmap_config
>> and already support them with the current I2C regmap implementation. Using
>
> Please note what I said about convenience - if lots of devices have
> exactly the same set of constraints to set up it's possible sensible to
> have a standard way of specifying them.  It's going to be a bit easier
> to just say it's smbus than to remember exactly what that means.

Maybe, but the only shared constraint is reg_bits = 8 (and if it is pure 
smbus use_single_rw = true).

>
>> native I2C to access these devices will be more efficient than going through
>> the smbus emulation layer. The smbus emulation layer essentially does the
>> same as we do in regmap, so using the smbus emulation layer through regmap
>> means doing the same thing twice.
>
> Right, that's why I said it's probably only worth it if the controller
> does smbus natively.
>
>> As I see it there are currently 3 cases:
>
>> 1) Device is strictly smbus only and the controller supports native smbus
>>     => Use smbus
>> 2) The device is smbus compatible but has extensions (e.g. support for multi
>> register writes) and the controller supports only smbus.
>>     => Use smbus
>> 3) For every other case
>>     => Use native I2C.
>
> It's not clear to me that if the controller supports smbus we shouldn't
> use it; presumably it's adding some value to have written the code to
> take advantage of it.  That would mean another case for device is smbus
> only and controller has explicit smbus support.

Potentially yes, but not necessarily in the first version of the driver. 
It's a bit of an exotic case, there seem to be only two I2C controller 
drivers in the Linux kernel that have support for both raw I2C and native 
SMBus and neither of them don't seem to be fairly recent (i2c-powermac.c and 
i2c-pasemi.c). And on the other hand most devices are SMBus compatible have 
extensions like being able to write/read multiple register in one transfer 
if raw I2C access is available, which is something we want to make use of if 
available.

And the other thing to consider is that a client driver currently has no way 
to query whether the controller driver supports native SMBus or only 
emulated SMBus. This is surely something that can be added to the I2C core, 
but this is necessarily something that we require before any SMBus support 
is added to regmap.

So in conclusion I think the best way forward is to create a patch that 
checks if native I2C is available, and if not falls back to either 
SMBUS_{WRITE,READ}_BYTE or SMBUS_{WRITE,READ}_WORD operations (Depending on 
whether val_bits is 8 or 16). Such a patch, I think, has the most effect for 
the least amount of work since it is rather simple and self contained and 
allows all devices which are SMBus compatible to be used with SMBus-only 
controllers. Everything else discussed in this thread (optimizations for 
special cases, convince helpers) can then be implemented on top of that.

- Lars
