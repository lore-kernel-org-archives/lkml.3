Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab3FDIoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 04:44:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:1426 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab3FDIoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 04:44:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,798,1363158000"; 
   d="asc'?scan'208";a="323927893"
Date: Tue, 4 Jun 2013 04:36:44 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: Betty Dall <betty.dall@hp.com>
Cc: rjw@sisk.pl, bhelgaas@google.com, ying.huang@intel.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 3/3] PCI/AER: Provide reset_link for firmware first
 root port
Message-ID: <20130604083644.GD20448@gchen.bj.intel.com>
Mail-Followup-To: Betty Dall <betty.dall@hp.com>, rjw@sisk.pl,
	bhelgaas@google.com, ying.huang@intel.com,
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org
References: <1369924769-17183-1-git-send-email-betty.dall@hp.com>
 <1369924769-17183-4-git-send-email-betty.dall@hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OaZoDhBhXzo6bW1J"
Content-Disposition: inline
In-Reply-To: <1369924769-17183-4-git-send-email-betty.dall@hp.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OaZoDhBhXzo6bW1J
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2013 at 08:39:29AM -0600, Betty Dall wrote:
> Date:	Thu, 30 May 2013 08:39:29 -0600
> From: Betty Dall <betty.dall@hp.com>
> To: rjw@sisk.pl, bhelgaas@google.com
> Cc: ying.huang@intel.com, linux-acpi@vger.kernel.org,
>  linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, Betty Dall
>  <betty.dall@hp.com>
> Subject: [PATCH v2 3/3] PCI/AER: Provide reset_link for firmware first ro=
ot
>  port
> X-Mailer: git-send-email 1.7.7.6
>=20
> The firmware first path does not install the aerdrv root port
> service driver, so the firmware first root port does not have
> a reset_link callback. When a firmware first root port does not have
> a reset_link callback, use a new default reset_link similar to what
> we already do for the default_downstream_reset_link(). The firmware
> first default reset_link brings the root port out of SBR if firmware
> left it in SBR.
>=20
> Changes since v1:
> Removed incorrect setting of p2p_ctrl after the read.
>=20
> Signed-off-by: Betty Dall <betty.dall@hp.com>
> ---
>=20
>  drivers/pci/pcie/aer/aerdrv_core.c |   36 ++++++++++++++++++++++++++++++=
++++++
>  1 files changed, 36 insertions(+), 0 deletions(-)
>=20
>=20
> diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/ae=
rdrv_core.c
> index 8ec8b4f..72f76cd 100644
> --- a/drivers/pci/pcie/aer/aerdrv_core.c
> +++ b/drivers/pci/pcie/aer/aerdrv_core.c
> @@ -413,6 +413,39 @@ static pci_ers_result_t default_downstream_reset_lin=
k(struct pci_dev *dev)
>  	return PCI_ERS_RESULT_RECOVERED;
>  }
> =20
> +/**
> + * default_ff_root_port_reset_link - default reset function for firmware
> + *		first Root Port
> + * @dev: pointer to root port's pci_dev data structure
> + *
> + * Invoked when performing link reset at Root Port w/ no aer driver.
> + * This happens through the firmware first path. Firmware may leave
> + * the Root Port in SBR and it is the OS responsiblity to bring it out
> + * of SBR.
> + */
> +static pci_ers_result_t default_ff_root_port_reset_link(struct pci_dev *=
dev)
> +{
> +	u16 p2p_ctrl;
> +
> +	/* Read Secondary Bus Reset */
> +	pci_read_config_word(dev, PCI_BRIDGE_CONTROL, &p2p_ctrl);
> +
> +	/* De-assert Secondary Bus Reset, if it is set */
> +	if (p2p_ctrl & PCI_BRIDGE_CTL_BUS_RESET) {
> +		p2p_ctrl &=3D ~PCI_BRIDGE_CTL_BUS_RESET;
> +		pci_write_config_word(dev, PCI_BRIDGE_CONTROL, p2p_ctrl);
> +
> +		/*
> +		 * System software must wait for at least 100ms from the end
> +		 * of a reset of one or more device before it is permitted
> +		 * to issue Configuration Requests to those devices.
> +		 */
> +		msleep(200);
> +		dev_dbg(&dev->dev, "Root Port link has been reset\n");
> +	}
> +	return PCI_ERS_RESULT_RECOVERED;
> +}

I don't think this function is OK.
1) You don't really reset the 2nd Bus but just checking its status.
I think you should have following steps to reset 2nd Bus:

a. Assert 2nd Bus Reset
b. wait for some time until this message has been broadcasted well
c. De-assert 2nd Bus Reset
d. wait for Trst time

IOW, since we have aer_do_secondary_bus_reset to perform secondary bus
reset, why you repeat it again?

2) msleep(200) is too long for kernel. You'd better yield the CPU when
sleep.

> +
>  static int find_aer_service_iter(struct device *device, void *data)
>  {
>  	struct pcie_port_service_driver *service_driver, **drv;
> @@ -460,6 +493,9 @@ static pci_ers_result_t reset_link(struct pci_dev *de=
v)
>  		status =3D driver->reset_link(udev);
>  	} else if (pci_pcie_type(udev) =3D=3D PCI_EXP_TYPE_DOWNSTREAM) {
>  		status =3D default_downstream_reset_link(udev);
> +	} else if (pci_pcie_type(udev) =3D=3D PCI_EXP_TYPE_ROOT_PORT &&
> +		pcie_aer_get_firmware_first(udev)) {
> +		status =3D default_ff_root_port_reset_link(udev);
>  	} else {
>  		dev_printk(KERN_DEBUG, &dev->dev,
>  			"no link-reset support at upstream device %s\n",
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--OaZoDhBhXzo6bW1J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRraccAAoJEI01n1+kOSLHRTkP/0jhUh5xVIuY3/kD1aOlyxqe
eHiMbAD+w4Dzm/Oq17znVp2SWrllri6A/1qxoV5sqCXYHxScfDAg5VwqzzR4WNZ5
Gtsu64jFkvA1B4qw5K6hpPqNeeTCZfgMM2ahadAhTfMAFgnwD6D6UDOpcbWHvqi6
qZcFNGQAfAP0j/7iSOYXD9LfqXl20hMkPgwXRvw96IKfnVpmmi6DOIS/TcA8uTgn
e7lD6TfaMZsa4fWQrruLZ9hBrDRZFbXEy6WvIJdOJ9I//eMN/1j79yxYtslObZSi
Al26EIMeOEF6MR5iMIc9+BjnYbXF/iZTPxrQ1mNyoqg2H872YdJ6J7Ca+WaWb3uF
+9gfR/Ai/Llt/j1BASgvFMHDFdm2SyXFMm0mBC97bVoIU0AIg/jgf8tD3Lm+fTs/
U5V67MlCuQMr+S8aOtOVaSmTLnP5+Jux2xP2B6i5ECYRAnxF0mUivjFiLQvivPbn
d1wRnS/kdGoIo2WREbuD6IamSj0z7DHIqRJa/9XDzz5mkJYuVYsjPDMkJcUo+8eK
eu+PqTozJBJ+ZMBLJBfmKfozpw34Hu1A/go5FOD6+hYGaGkoHtQztE/bXbigAiRK
A6og0C2yI9znnipKb/n8M5/GDbFgEKFBXPujvL6BM/b/tUg3GmV4uI5tEn+PL9y7
1kEQWJ2rewiP9JtEWy3X
=GpEw
-----END PGP SIGNATURE-----

--OaZoDhBhXzo6bW1J--
