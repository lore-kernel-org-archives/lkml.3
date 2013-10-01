Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390Ab3JAQAC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 12:00:02 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:43773 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab3JAP77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 11:59:59 -0400
Message-ID: <524AF17C.2040105@monstr.eu>
Date: Tue, 01 Oct 2013 17:59:56 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Jason Cooper <jason@lakedaemon.net>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Alan Tull <atull@altera.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        David Brown <davidb@codeaurora.org>, Dom Cobley <popcornmix@gmail.com>
Subject: Re: [RFC PATCH] fpga: Introduce new fpga subsystem
References: <cover.1379519753.git.michal.simek@xilinx.com> <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com> <20130918191517.GQ19937@titan.lakedaemon.net> <20130918203247.GA11181@obsidianresearch.com> <524588C9.1090600@monstr.eu> <20130930171256.GA28898@obsidianresearch.com>
In-Reply-To: <20130930171256.GA28898@obsidianresearch.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="eWHE6me8wLHLJKFD5UaSrirfTkpIJh73o"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--eWHE6me8wLHLJKFD5UaSrirfTkpIJh73o
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09/30/2013 07:12 PM, Jason Gunthorpe wrote:
> On Fri, Sep 27, 2013 at 03:31:53PM +0200, Michal Simek wrote:
>=20
>> I expect that you are detecting/specifying in the driver which
>> fpga is connected and you also need to know size of this device.
>> Then your driver allocate buffer with this size in the kernel
>> and streming data to this buffer. When this is done you are
>> using another sysfs files to control device programming.
>=20
> No, it just streams:
>=20
> static ssize_t fpga_config_write(struct file *filp,struct kobject *kobj=
,
>                                  struct bin_attribute *attr,
>                                  char *buf, loff_t off, size_t len)
> {
>         struct device *dev =3D container_of(kobj, struct device, kobj);=

>         struct platform_device *pdev =3D to_platform_device(dev);
>         struct fpga_priv *priv =3D platform_get_drvdata(pdev);
>         uint8_t *cur =3D buf;
>         size_t total =3D len;
>         unsigned int bit;
>=20
>         for (; len !=3D 0; len--, cur++) {
>                 gpio_set_value(priv->gpio[GPIO_CCLK],0);
>=20
>                 for (bit =3D 0; bit !=3D 8; bit++)
>                         gpio_set_value(priv->data_gpio[bit],
>                                        (*cur & (1<<bit)) !=3D 0);
>=20
>                 gpio_set_value(priv->gpio[GPIO_CCLK],1);
>=20
>                 if (gpio_get_value(priv->gpio[GPIO_INIT_B]) =3D=3D 0)
>                         return -EIO;
>         }
>         return total;
> }
>=20
> static struct bin_attribute dev_attr_config_data =3D {
>         .attr =3D {
>                 .name =3D "config_data",
>                 .mode =3D 0600,
>         },
>         .size =3D 0,
>         .write =3D fpga_config_write,
> };
>=20
> User space does as many writes as necessary to send the entire
> bitstream, the sysfs layer chunks things into PAGE_SIZE blocks, so it
> acts much like a socket with O_NONBLOCK set.
>=20
> We are controlling the other related GPIOs from userspace, but for
> your purposes I would pair the data sysfs file with a control sysfs
> file much like request firwmare does.
>=20
> Here is a suggestion.
> - Two files fpga_config_state, fpga_config_data
> - fpga_config_state is a one value text string values are like
>    initializing, clearing, programming, operating, error_clear_failed,
>    error_bistream_crc
> - Userspace writes to fpga_config_state which causes the kernel FSM
>   to move to that state. The normal progression would be initializing,
>   clearing, programming and finally operating
> - The kernel can move to an error_* state if it detects a problem
> - The programming state data from fpga_config_data to the
>   configuration bus and userspace writes 'operating' once the stream
>   is done to perform the post-configuration actions.

yes, there is necessary to provide also any state to be able to control
the flow. For your case above with streams this is not necessary.

Thanks for this description I wanted to make sure that we are on the same=
 page.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--eWHE6me8wLHLJKFD5UaSrirfTkpIJh73o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJK8XwACgkQykllyylKDCFX0ACfYbdRy7LsZbSLsGnqtOdEbUzQ
Bi0AnibrmQHyKQr6FPRsk9QFyOam+VOJ
=P450
-----END PGP SIGNATURE-----

--eWHE6me8wLHLJKFD5UaSrirfTkpIJh73o--
