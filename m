Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbaDCPXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 11:23:35 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:52802 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbaDCPXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 11:23:32 -0400
Message-ID: <533D7CF0.2000702@monstr.eu>
Date: Thu, 03 Apr 2014 17:23:28 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: balbi@ti.com
CC: Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
Subject: Re: [PATCH v2 2/2] usb: gadget: Add xilinx axi usb2 device support
References: <1396510519-8555-1-git-send-email-sbhatta@xilinx.com> <113d0620-4003-417d-806b-0b79ae692829@VA3EHSMHS023.ehs.local> <20140403145853.GD14162@saruman.home>
In-Reply-To: <20140403145853.GD14162@saruman.home>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Qmqqjql0u45rP78ulg2Rt6JUj4mdnbQ3g"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Qmqqjql0u45rP78ulg2Rt6JUj4mdnbQ3g
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

>> +struct xusb_udc {
>> +	struct usb_gadget gadget;
>> +	struct xusb_ep ep[8];
>> +	struct usb_gadget_driver *driver;
>> +	struct cmdbuf ch9cmd;
>> +	u32 usb_state;
>> +	u32 remote_wkp;
>> +	unsigned int (*read_fn)(void __iomem *);
>> +	void (*write_fn)(void __iomem *, u32, u32);
>=20
> why do you need these to be function pointers ? Because of endianness ?=

> generic readl()/writel() already take care of that.

readl from asm-generic/io.h is converting value from little endian IO
to cpu endianness.
This IP exists also in big endian version.
It means we have to support all possible combinations.
IP little and reading it on little or big endian CPU
IP big and reading it on little or big endian CPU.

Look below.

>> +	spin_lock_init(&udc->lock);
>> +
>> +	/* Check for IP endianness */
>> +	udc->write_fn =3D xudc_write32_be;
>> +	udc->read_fn =3D xudc_read32_be;
>> +	udc->write_fn(udc->base_address, XUSB_TESTMODE_OFFSET, TEST_J);
>> +	if ((udc->read_fn(udc->base_address + XUSB_TESTMODE_OFFSET))
>> +			!=3D TEST_J) {
>> +		udc->write_fn =3D xudc_write32;
>> +		udc->read_fn =3D xudc_read32;
>> +	}
>=20
> hmm... isn't there a configuration register to check this out ?

Sundeep can tell us if there is any configuration register but
I don't think so in connection to my experience with Xilinx soft IPs.

Endian detection directly on IP itself came from my discussion
on drivers/spi/spi-xilinx.c that this is only one way how to do it.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--Qmqqjql0u45rP78ulg2Rt6JUj4mdnbQ3g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlM9fPAACgkQykllyylKDCFJrQCggMKoMv6XE196Um8z0I95Yh6P
o+EAnAu61OcHvjfvWdSMduA2uC6YLCSX
=D8lF
-----END PGP SIGNATURE-----

--Qmqqjql0u45rP78ulg2Rt6JUj4mdnbQ3g--
