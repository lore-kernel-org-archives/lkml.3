Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbaDOLyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:54:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39816 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750838AbaDOLyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:54:04 -0400
Message-ID: <534D1DDA.40207@free-electrons.com>
Date: Tue, 15 Apr 2014 13:54:02 +0200
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
References: <1397292335-5516-1-git-send-email-boris.brezillon@free-electrons.com> <1397480885-11962-1-git-send-email-boris.brezillon@free-electrons.com> <20140414210429.GJ25182@sirena.org.uk> <534CE16D.8010508@free-electrons.com> <20140415100922.GN12304@sirena.org.uk>
In-Reply-To: <20140415100922.GN12304@sirena.org.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


On 15/04/2014 12:09, Mark Brown wrote:
> On Tue, Apr 15, 2014 at 09:36:13AM +0200, Boris BREZILLON wrote:
>> On 14/04/2014 23:04, Mark Brown wrote:
>
>>> The transfer type gets set once per device at init time so why not
>>> just parameterise based on val_bytes?
>
>> Actually, you may want to transfer 1 byte registers using the block
>> method (if your device only support block transfers). This depends on
>> the device being accessed and what it supports, but I'm not sure we can
>> assume 1 byte registers will always be transferred using SMBUS byte
>> transfers.
>
> OK, so if this a realistic issue then it seems like it's better to
> implement three different buses - there is not really any common code
> between the various paths.

Okay, I'll create 4 different busses (one for each access type).
BTW, should I keep these implementations in the same source file
(regmap-smbus.c) ?
And, should I keep one method to register an smbus regmap or should I
provide one method per access type and get rid of the
regmap_smbus_transfer_type enum ?

>   This would also mean that you avoid having
> gather write when it can't be implemented.

Correct me if I'm wrong, but they all support gather write.

>
>
> The code is also not validating the lengths for two byte values.

I'm not sure I get this one.
Do you mean I should check that val_size is a 2 byte multiple ?
If this is what you meant, then I should also check it for block transfers.

>
>
>>>> +    case REGMAP_SMBUS_I2C_BLOCK_TRANSFER: +        while (count
>>>>> 0 && !ret) { +            ret =
>>>> i2c_smbus_write_i2c_block_data(ctx->i2c, +
>>>> reg, +                                 ctx->val_bytes, +
>>>> (const u8 *)data);
>
>>> Fix the const correctness of the API rather than casting.
>
>> The API is correct because the i2c_smbus_write_i2c_block does not modify
>> the data pointer.
>> Just removing the const keyword in the cast should be enough, because
>> you can safely cast a non const pointer to a const one.
>
> If you need to cast away from void at all something is going wrong (and
> we appear to be always passing in write buffers as const too, I can't
> remember which operation this was though).

You're right, removing the cast when passing the val argument to the i2c
block transfer functions works.

Best Regards,

Boris

- -- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTTR3aAAoJEHLimErDqMKy3w0H/07ZyPXLB5YB3irMT0+eOqtS
spxzeZDv3OKT2Rggsz7wAjkRhFbFT9rAMtGJyrmo2js7CPh5cXEg+oWWeTeLpqjF
xeCyJW6yoihI0JbF2fsYlkuLqGIKrFYTeGzSWgP1DlLdxwJ//lxqQrayOMzd5exS
KbQglfzUEVJ5W5n65CGjmNBYW2/QWasAQGwzgypv3gWVLfQzd+n/vCnHBvn81bfe
Ry8nTMEOLpV3rJSGiNZZQL1TIsDiAUQuxKh+n4mc2ntIgLZcb2l6mjGA/36ziQaA
Gfpc1zTGTQWaY4ZdQuvljAEOl2yBUZrkuf+ZVrv26l6saIQv9ekxSCmVRP/CmbY=
=Bt4h
-----END PGP SIGNATURE-----

