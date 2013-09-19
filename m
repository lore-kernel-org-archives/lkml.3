Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab3ISKB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 06:01:26 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:65261 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab3ISKBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 06:01:24 -0400
Message-ID: <523ACB70.2020000@monstr.eu>
Date: Thu, 19 Sep 2013 12:01:20 +0200
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
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        "David S. Miller" <davem@davemloft.net>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        David Brown <davidb@codeaurora.org>, Dom Cobley <popcornmix@gmail.com>
Subject: Re: [RFC PATCH] fpga: Introduce new fpga subsystem
References: <cover.1379519753.git.michal.simek@xilinx.com>  <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com> <1379520665.1787.40.camel@joe-AO722>
In-Reply-To: <1379520665.1787.40.camel@joe-AO722>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="MXRir3bQaJsTfhIn6WrsBmlofgMIBvT0P"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MXRir3bQaJsTfhIn6WrsBmlofgMIBvT0P
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Joe,

On 09/18/2013 06:11 PM, Joe Perches wrote:
> On Wed, 2013-09-18 at 17:56 +0200, Michal Simek wrote:
>> This new subsystem should unify all fpga drivers which
>> do the same things. Load configuration data to fpga
>> or another programmable logic through common interface.
>> It doesn't matter if it is MMIO device, gpio bitbanging,
>> etc. connection. The point is to have the same
>> inteface for these drivers.
>=20
> Is this really a "driver".
> Perhaps it's more of a core kernel function
> and belongs in kernel.

This is not a driver just kernel subsystem and real drivers
will register itself in this subsystem.

>=20
>> diff --git a/drivers/fpga/fpga-mgr.c b/drivers/fpga/fpga-mgr.c
>=20
> The error messages are a little shouty with all
> the unnecessary "!" uses. =20
>=20
> []

Fixed.

>=20
>> +/**
>> + * fpga_mgr_read - Read data from fpga
>> + * @mgr: Pointer to the fpga manager structure
>> + * @buf: Pointer to the buffer location
>> + * @count: Pointer to the number of copied bytes
>> + *
>> + * Function reads fpga bitstream and copy them to output buffer.
>> + *
>> + * Returns the number of bytes copied to @buf, a negative error numbe=
r otherwise
>> + */
>> +static int fpga_mgr_read(struct fpga_manager *mgr, char *buf, ssize_t=
 *count)
>> +{
>> +	int ret;
>> +
>> +	if (test_and_set_bit_lock(FPGA_MGR_DEV_BUSY, &mgr->flags))
>> +		return -EBUSY;
>> +
>> +	if (!mgr->mops || !mgr->mops->read) {
>> +		dev_err(mgr->dev,
>> +			"Controller doesn't support read operations!\n");
>> +		return -EPERM;
>> +	}
>> +
>> +	if (mgr->mops->read_init) {
>> +		ret =3D mgr->mops->read_init(mgr);
>> +		if (ret) {
>> +			dev_err(mgr->dev, "Failed in read-init!\n");
>> +			return ret;
>> +		}
>> +	}
>> +
>> +	if (mgr->mops->read) {
>> +		ret =3D mgr->mops->read(mgr, buf, count);
>> +		if (ret) {
>> +			dev_err(mgr->dev, "Failed to read firmware!\n");
>> +			return ret;
>> +		}
>> +	}
>> +
>> +	if (mgr->mops->read_complete) {
>> +		ret =3D mgr->mops->read_complete(mgr);
>> +		if (ret) {
>> +			dev_err(mgr->dev, "Failed in read-complete!\n");
>> +			return ret;
>> +		}
>> +	}
>> +
>> +	clear_bit_unlock(FPGA_MGR_DEV_BUSY, &mgr->flags);
>> +
>> +	return 0;
>> +}
>> +
>> +/**
>> + * fpga_mgr_attr_read - Read data from fpga
>> + * @dev: Pointer to the device structure
>> + * @attr: Pointer to the device attribute structure
>> + * @buf: Pointer to the buffer location
>> + *
>> + * Function reads fpga bitstream and copy them to output buffer
>> + *
>> + * Returns the number of bytes copied to @buf, a negative error numbe=
r otherwise
>> + */
>> +static ssize_t fpga_mgr_attr_read(struct device *dev,
>> +				   struct device_attribute *attr, char *buf)
>> +{
>> +	struct fpga_manager *mgr =3D dev_get_drvdata(dev);
>> +	ssize_t count;
>> +	int ret;
>> +
>> +	if (mgr && mgr->fpga_read)
>> +		ret =3D mgr->fpga_read(mgr, buf, &count);
>> +
>> +	return ret =3D=3D 0 ? count : -EPERM;
>=20
> EPERM isn't the only error return from fpga_read.

Yeah I know. Will revisit all return codes.


>> +}
>> +
>> +/**
>> + * fpga_mgr_write - Write data to fpga
>> + * @mgr: Pointer to the fpga manager structure
>> + * @fw_name: Pointer to the buffer location with bistream firmware fi=
lename
>> + *
>> + * @buf contains firmware filename which is loading through firmware
>> + * interface and passed to the fpga driver.
>> + *
>> + * Returns string lenght added to @fw_name, a negative error number o=
therwise
>> + */
>> +static int fpga_mgr_write(struct fpga_manager *mgr, const char *fw_na=
me)
>> +{
>> +	int ret =3D 0;
>> +	const struct firmware *fw;
>> +
>> +	if (!fw_name || !strlen(fw_name)) {
>> +		dev_err(mgr->dev, "Firmware name is not specified!\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (!mgr->mops || !mgr->mops->write) {
>> +		dev_err(mgr->dev,
>> +			"Controller doesn't support write operations!\n");
>> +		return -EPERM;
>=20
> I think you should revisit the return codes.

yap

>=20
>=20
>> +/**
>> + * fpga_mgr_attr_write - Write data to fpga
>> + * @dev: Pointer to the device structure
>> + * @attr: Pointer to the device attribute structure
>> + * @buf: Pointer to the buffer location with bistream firmware filena=
me
>> + * @count: Number of characters in @buf
>> + *
>> + * @buf contains firmware filename which is loading through firmware
>> + * interface and passed to the fpga driver.
>> + *
>> + * Returns string lenght added to @buf, a negative error number other=
wise
>> + */
>> +static ssize_t fpga_mgr_attr_write(struct device *dev,
>> +				   struct device_attribute *attr,
>> +				   const char *buf, size_t count)
>> +{
>> +	struct fpga_manager *mgr =3D dev_get_drvdata(dev);
>> +	int ret;
>> +
>> +	if (mgr && mgr->fpga_write)
>> +		ret =3D mgr->fpga_write(mgr, buf);
>> +
>> +	return ret =3D=3D 0 ? strlen(buf) : -EPERM;
>> +}
>=20
> Same -EPERM issue as read

yap

>=20
>> +	mgr =3D devm_kzalloc(&pdev->dev, sizeof(*mgr), GFP_KERNEL);
>> +	if (!mgr) {
>> +		dev_err(&pdev->dev, "Failed to alloc mgr struct!\n");
>=20
> Unnecessary OOM message as there's a general dump_stack()
> already done on any OOM without GFP_NOWARN
>=20
>> diff --git a/include/linux/fpga.h b/include/linux/fpga.h
> []
>> +struct fpga_manager {
>> +	char name[48];
>=20
> Maybe a #define instead of 48?

There is another comment to fix this by pointer which is sensible solutio=
n too.

Thanks for review,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--MXRir3bQaJsTfhIn6WrsBmlofgMIBvT0P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlI6y3AACgkQykllyylKDCGXsQCeIyIyr+/4b3UX+gPhCP0b0JNm
tMYAnAqLqXF5Hifpjp7DKXRVLc1ONwsi
=SKlB
-----END PGP SIGNATURE-----

--MXRir3bQaJsTfhIn6WrsBmlofgMIBvT0P--
