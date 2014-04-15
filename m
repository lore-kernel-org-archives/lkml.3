Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbaDONfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:35:06 -0400
Received: from smtp-out-049.synserver.de ([212.40.185.49]:1077 "EHLO
	smtp-out-027.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750898AbaDONfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:35:02 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 9998
Message-ID: <534D357F.9040906@metafoo.de>
Date: Tue, 15 Apr 2014 15:34:55 +0200
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
References: <1397292335-5516-1-git-send-email-boris.brezillon@free-electrons.com> <1397480885-11962-1-git-send-email-boris.brezillon@free-electrons.com> <20140414210429.GJ25182@sirena.org.uk> <534CE16D.8010508@free-electrons.com> <20140415100922.GN12304@sirena.org.uk> <534D1DDA.40207@free-electrons.com> <534D252B.8060009@metafoo.de> <20140415125654.GD12304@sirena.org.uk>
In-Reply-To: <20140415125654.GD12304@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 02:56 PM, Mark Brown wrote:
[...]
>> My suggestion is that in regmap_init_i2c() you check the capabilities of the
>> I2C adapter. If it supports native I2C you setup the regmap with the
>> regmap_i2c struct just as it does right now. If the adapter does not support
>> native I2C, check if the device can be supported by smbus (reg_bytes == 8 &&
>> val_bytes % 8 == 0). For each type of smbus operations have one regmap_bus
>> struct, and if you can fallback to smbus choose the bus depending on the
>> config's val_bytes.
>
> That'd definitely be useful but potentially orthogonal, we can also do
> both and expose smbus explicitly with I2C falling back to it
> transparently.
>
> If the device *is* limited to smbus and the controller supports both
> (some do) I'd naively have expected that the native smbus support would
> do a little better - otherwise why bother using it?  We could identify
> the constraint set automatically for I2C devices though it's more for
> the client driver to specify.
>
> This means there's two changes to consider here:
>
>   - Providing APIs for registering actual smbus devices as a convenience
>     for devices with that constraint, regardless of how that is done
>     behind the scenes.
>
>   - Having the I2C implementation automatically use the smbus APIs if
>     it can and either the controller is smbus only or it makes sense to
>     do so for optimisation.
>
> both of which are independently useful.
>

I don't think it makes sense to expose smbus explicitly. We can already 
describe smbus restricted devices just fine with the current regmap_config 
and already support them with the current I2C regmap implementation. Using 
native I2C to access these devices will be more efficient than going through 
the smbus emulation layer. The smbus emulation layer essentially does the 
same as we do in regmap, so using the smbus emulation layer through regmap 
means doing the same thing twice.

What we currently do not support is devices which are restricted to block 
transfers and I think adding support for this should be handled by a 
separate patchset. As far as I understood it this patchset is about making 
it possible to use smbus controllers with regmap devices which are smbus 
compatible.

As I see it there are currently 3 cases:

1) Device is strictly smbus only and the controller supports native smbus
    => Use smbus
2) The device is smbus compatible but has extensions (e.g. support for multi 
register writes) and the controller supports only smbus.
    => Use smbus
3) For every other case
    => Use native I2C.

- Lars
