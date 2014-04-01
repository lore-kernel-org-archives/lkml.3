Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbaDALUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:20:46 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:59029 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbaDALUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:20:37 -0400
Message-ID: <533AA0F7.2080304@monstr.eu>
Date: Tue, 01 Apr 2014 13:20:23 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Harini Katakam <harinik@xilinx.com>, grant.likely@linaro.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        michals@xilinx.com, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/2] watchdog: Add Cadence WDT driver
References: <1396002720-7105-1-git-send-email-harinik@xilinx.com> <533A0937.9030505@roeck-us.net>
In-Reply-To: <533A0937.9030505@roeck-us.net>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="1UdlIJ8W0cQa8K6g1X9WRF86iF9EJRsnS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1UdlIJ8W0cQa8K6g1X9WRF86iF9EJRsnS
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Guenter,

>> +/**
>> + * struct cdns_wdt - Watchdog device structure
>> + * @regs: baseaddress of device
>> + * @rst: reset flag
>> + * @clk: struct clk * of a clock source
>> + * @prescaler: for saving prescaler value
>> + * @ctrl_clksel: counter clock prescaler selection
>> + * @io_lock: spinlock for IO register access
>> + * @cdns_wdt_device: watchdog device structure
>> + * @cdns_wdt_notifier: notifier structure
>> + *
>> + * Structure containing parameters specific to cadence watchdog.
>> + */
>> +struct cdns_wdt {
>> +    void __iomem        *regs;
>> +    u32            rst;
>> +    struct clk        *clk;
>> +    u32            prescaler;
>> +    u32            ctrl_clksel;
>> +    spinlock_t        io_lock;
>> +    struct watchdog_device    cdns_wdt_device;
>> +    struct notifier_block    cdns_wdt_notifier;
>> +};
>> +
>> +/* Write access to Registers */
>> +static inline void cdns_wdt_writereg(void __iomem *offset, u32 val)
>> +{
>> +    writel_relaxed(val, offset);
>> +}
>> +
>=20
> Not really sure if this function provides any value.

I can't see any problem to use this helper IO function
but maybe we could do it a little bit differently.
Currently implementation is just passing values to writel_relaxed()

What about to do it like this?

static inline void cdns_wdt_writereg(struct cdns_wdt *wdt, u32 offset, u3=
2 val)
{
    writel_relaxed(val, wdt->regs + offset);
}

This solution was suggested by Mark here too.
https://lkml.org/lkml/2014/3/17/234

The reason for having one IO helper function is
1. Simper debugging when you add printks to one location and
you get full list for accesses
2. This driver can be also used by BE Linux on Microblaze in PL
that's why there could be a need to autodetect endianess directly
on the IP itself. Then using helper function is necessary.
3. We have met with secure monitor implementation where all these
io accesses should be done via smc calls and having
IO helper function is easier for change.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--1UdlIJ8W0cQa8K6g1X9WRF86iF9EJRsnS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlM6oPcACgkQykllyylKDCGltwCfark82XZsx3xg6RW1TJZq48xk
tpkAn0em/Tpp9YxxOa5d8fVlcD7JOtJN
=ihri
-----END PGP SIGNATURE-----

--1UdlIJ8W0cQa8K6g1X9WRF86iF9EJRsnS--
