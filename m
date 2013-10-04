Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab3JDQPf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 12:15:35 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:39544 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729Ab3JDQPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 12:15:33 -0400
Message-ID: <524EE9A0.2020404@monstr.eu>
Date: Fri, 04 Oct 2013 18:15:28 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Alan Tull <atull@altera.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>,
        Kyle Teske <kyle.teske@ni.com>, Josh Cartwright <joshc@eso.teric.us>,
        Rob Landley <rob@landley.net>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        "David S. Miller" <davem@davemloft.net>,
        David Brown <davidb@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Nicolas Pitre <nico@linaro.org>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Felipe Balbi <balbi@ti.com>, linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH v2] fpga: Introduce new fpga subsystem
References: <cover.1380727889.git.michal.simek@xilinx.com>  <fe4f34387011339efe9f5868a7eec9d549462d8f.1380727889.git.michal.simek@xilinx.com> <1380729996.2081.59.camel@joe-AO722>
In-Reply-To: <1380729996.2081.59.camel@joe-AO722>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="jxINEbSujp8uRUK2QaNwX02v2cWQwrCIW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jxINEbSujp8uRUK2QaNwX02v2cWQwrCIW
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Joe,

On 10/02/2013 06:06 PM, Joe Perches wrote:
> On Wed, 2013-10-02 at 17:35 +0200, Michal Simek wrote:
>> This new fpga subsystem core should unify all fpga drivers/managers wh=
ich
>> do the same things. Load configuration data to fpga or another program=
mable
>> logic through common interface. It doesn't matter if it is MMIO device=
,
>> gpio bitbanging, etc. connection. The point is to have the same
>> interface for these drivers.
>=20
> Does this interface support partial reprogramming/configuration
> for FPGAs that can do that?

Currently we have two interfaces and third one is around (char driver)
that's why I didn't look at this support.
But for Xilinx devices init and complete phase is different.

We can use one more flag parameter for init and complete functions.

It means we can simple extend config states with write_init_partial, etc
Or the second option is to create new sysfs file to indicate
that we will work with partial bitstreams.

> trivial notes:
>=20
> There are a _lot_ of dev_dbg statements.
>=20
> I hope some of these would be removed one day,
> especially the function tracing style ones, because
> there's already a generic kernel mechanism for that.
>=20
> Maybe perf/trace support could be added eventually.

Are you talking about trace_printk?

>> diff --git a/drivers/fpga/fpga-mgr.c b/drivers/fpga/fpga-mgr.c
> []
>> +/**
>> + * fpga_mgr_status_write - Write fpga manager status
>> + * @dev: Pointer to the device structure
>> + * @attr: Pointer to the device attribute structure
>> + * @buf: Pointer to the buffer location
>> + * @count: Number of characters in @buf
>> + *
>> + * Returns the number of bytes copied to @buf, a negative error numbe=
r otherwise
>> + */
>> +static ssize_t fpga_mgr_status_write(struct device *dev,
>> +				     struct device_attribute *attr,
>> +				     const char *buf, size_t count)
>> +{
>> +	struct fpga_manager *mgr =3D dev_get_drvdata(dev);
>> +	int ret;
>> +
>> +	if (test_and_set_bit_lock(FPGA_MGR_DEV_BUSY, &mgr->flags))
>> +		return -EBUSY;
>> +
>> +	ret =3D strcmp(buf, "write_init");
>> +	if (!ret) {
>> +		ret =3D fpga_mgr_write_init(mgr);
>> +		goto out;
>> +	}
>> +
>> +	ret =3D strcmp(buf, "write_complete");
>> +	if (!ret) {
>> +		ret =3D fpga_mgr_write_complete(mgr);
>> +		goto out;
>> +	}
>> +
>> +	ret =3D strcmp(buf, "read_init");
>> +	if (!ret) {
>> +		ret =3D fpga_mgr_read_init(mgr);
>> +		goto out;
>> +	}
>> +
>> +	ret =3D strcmp(buf, "read_complete");
>> +	if (!ret) {
>> +		ret =3D fpga_mgr_read_complete(mgr);
>> +		goto out;
>> +	}
>> +
>> +	ret =3D -EINVAL;
>> +out:
>> +	clear_bit_unlock(FPGA_MGR_DEV_BUSY, &mgr->flags);
>> +
>> +	return ret ? : count;
>> +}
>=20
> I think this style is awkward and this would be
> better written as:
>=20
> 	if (!strcmp(buf, "write_init"))
> 		ret =3D fpga_mgr_write_init(mgr);
> 	else if (!strcmp(buf, "write_complete"))
> 		ret =3D fpga_mgr_write_complete(mgr);
> 	else if (!strcmp(buf, "read_init"))
> 		ret =3D fpga_mgr_read_init(mgr);
> 	else if (!strcmp(buf, "read_complete"))
> 		ret =3D fpga_mgr_read_complete(mgr);
> 	else
> 		ret =3D -EINVAL;
>=20
> 	clear_bit_unlock(FPGA_MGR_DEV_BUSY, &mgr->flags);
>=20
> 	if (ret)
> 		return ret;
>=20
> 	return count;
> }
>=20
> Maybe use (strcmp(...) =3D=3D 0) if you prefer that.
> Both styles are commonly used in linux.


sure.


> Probably all of the "return ret ?: count;" uses
> would be more easily understood on 3 lines.

This structure is also quite common in the kernel
git grep "? :"  | wc -l
415

git grep "?:"  | wc -l
541

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--jxINEbSujp8uRUK2QaNwX02v2cWQwrCIW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJO6aEACgkQykllyylKDCFh6wCbB7zCka5IcrYIbTtjhxS7TcMv
tUIAn2Y02thKAoB675Mm5vXqG2PRGk2g
=toci
-----END PGP SIGNATURE-----

--jxINEbSujp8uRUK2QaNwX02v2cWQwrCIW--
