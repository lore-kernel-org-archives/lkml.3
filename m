Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750947AbaDOHgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 03:36:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37664 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750838AbaDOHgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 03:36:16 -0400
Message-ID: <534CE16D.8010508@free-electrons.com>
Date: Tue, 15 Apr 2014 09:36:13 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Chen-Yu Tsai <wens@csie.org>, Hans de Goede <hdegoede@redhat.com>,
        Carlo Caione <carlo@caione.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Subject: Re: [RFC PATCH v2] regmap: smbus: add support for regmap over SMBus
References: <1397292335-5516-1-git-send-email-boris.brezillon@free-electrons.com> <1397480885-11962-1-git-send-email-boris.brezillon@free-electrons.com> <20140414210429.GJ25182@sirena.org.uk>
In-Reply-To: <20140414210429.GJ25182@sirena.org.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


On 14/04/2014 23:04, Mark Brown wrote:
> On Mon, Apr 14, 2014 at 03:08:05PM +0200, Boris BREZILLON wrote:
>> SMBus is a subset of the I2C protocol, oftenly used to access
registers on
>> external devices.
> 
> This is basically fine.  However...
> 
>> +    switch (ctx->transfer_type) { +    case
>> REGMAP_SMBUS_BYTE_TRANSFER: +        while (count > 0 && !ret) { 
>> +            ret = i2c_smbus_write_byte_data(ctx->i2c, reg++, +
>> *(u8 *)data++); + +            count--; +        } +
>> break;
> 
> The transfer type gets set once per device at init time so why not
> just parameterise based on val_bytes?

Actually, you may want to transfer 1 byte registers using the block
method (if your device only support block transfers). This depends on
the device being accessed and what it supports, but I'm not sure we can
assume 1 byte registers will always be transferred using SMBUS byte
transfers.

> 
> 
>> +    case REGMAP_SMBUS_I2C_BLOCK_TRANSFER: +        while (count
>> > 0 && !ret) { +            ret =
>> i2c_smbus_write_i2c_block_data(ctx->i2c, +
>> reg, +                                 ctx->val_bytes, +
>> (const u8 *)data);
> 
> Fix the const correctness of the API rather than casting.

The API is correct because the i2c_smbus_write_i2c_block does not modify
the data pointer.
Just removing the const keyword in the cast should be enough, because
you can safely cast a non const pointer to a const one.

> 
> 
>> +            reg += ctx->val_bytes; +            count -=
>> ctx->val_bytes; +            data += ctx->val_bytes; +        }
> 
> I'm assuming this will only be used if val_bytes isn't 1 or 2?

As explained earlier, this depends on the device being accessed, but it
might be used for smaller transfers (1 or 2 bytes).

Thanks for the review.

Best Regards,

Boris

- -- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTTOFkAAoJEHLimErDqMKyhlcH/jeKnphnxL9Sc+OKsd1sbvZ4
dgjwm0HVy/oQO4dwGHbGXDrvoqdcuPKjKJv0An1RAW0u8CBQHCHbn2xQZtHkrNhK
C4g+8ws3R050ppDAAvFGgnx2bIoS8+Elbcd0GNCQW+xYU/xOySH9qgPitFF7PgGw
X9wgM+o4x6W2Lo/NOxmkXeZVWl3UrfUL24UTXfqysJK6ciYtW7GDP1uInfK2eH1G
RL7eD7LanEH95bk8eQtVfZZzcoAZCo1ri2z6iPf2WS4Nep84fyAr6Q+B1Ltmhsus
QXZgXWnVY45ZYFRNjMX8axCUUoJf7DSn9ayi3Gil1i7fLmCPKhpxc8HNxWvIMkk=
=FFGW
-----END PGP SIGNATURE-----
