Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbaDOMZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:25:27 -0400
Received: from smtp-out-048.synserver.de ([212.40.185.48]:1060 "EHLO
	smtp-out-027.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751558AbaDOMZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:25:25 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 18633
Message-ID: <534D252B.8060009@metafoo.de>
Date: Tue, 15 Apr 2014 14:25:15 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
CC: Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Chen-Yu Tsai <wens@csie.org>, Hans de Goede <hdegoede@redhat.com>,
        Carlo Caione <carlo@caione.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Subject: Re: [RFC PATCH v2] regmap: smbus: add support for regmap over SMBus
References: <1397292335-5516-1-git-send-email-boris.brezillon@free-electrons.com> <1397480885-11962-1-git-send-email-boris.brezillon@free-electrons.com> <20140414210429.GJ25182@sirena.org.uk> <534CE16D.8010508@free-electrons.com> <20140415100922.GN12304@sirena.org.uk> <534D1DDA.40207@free-electrons.com>
In-Reply-To: <534D1DDA.40207@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 01:54 PM, Boris BREZILLON wrote:
>
>
> On 15/04/2014 12:09, Mark Brown wrote:
>> On Tue, Apr 15, 2014 at 09:36:13AM +0200, Boris BREZILLON wrote:
>>> On 14/04/2014 23:04, Mark Brown wrote:
>
>>>> The transfer type gets set once per device at init time so why not
>>>> just parameterise based on val_bytes?
>
>>> Actually, you may want to transfer 1 byte registers using the block
>>> method (if your device only support block transfers). This depends on
>>> the device being accessed and what it supports, but I'm not sure we can
>>> assume 1 byte registers will always be transferred using SMBUS byte
>>> transfers.
>
>> OK, so if this a realistic issue then it seems like it's better to
>> implement three different buses - there is not really any common code
>> between the various paths.
>
> Okay, I'll create 4 different busses (one for each access type).
> BTW, should I keep these implementations in the same source file
> (regmap-smbus.c) ?
> And, should I keep one method to register an smbus regmap or should I
> provide one method per access type and get rid of the
> regmap_smbus_transfer_type enum ?

I don't think we should leave the decision which bus to use to the driver. 
Neither should the driver have to choose whether to use smbus or native I2C. 
We want to use native I2C when available, because it is more efficient than 
going through the smbus emulation layer. On the other hand we want to 
automatically switch to smbus when native I2C is not available and the 
device can work fine with smbus. Also I'm afraid that we'll otherwise soon 
see code popping up like:

if (of_property_read_bool(np, "use-smbus-regmap"))
	regmap = regmap_init_smbus(...)
else
	regmap = regmap_init_i2c(...)

My suggestion is that in regmap_init_i2c() you check the capabilities of the 
I2C adapter. If it supports native I2C you setup the regmap with the 
regmap_i2c struct just as it does right now. If the adapter does not support 
native I2C, check if the device can be supported by smbus (reg_bytes == 8 && 
val_bytes % 8 == 0). For each type of smbus operations have one regmap_bus 
struct, and if you can fallback to smbus choose the bus depending on the 
config's val_bytes.

- Lars
