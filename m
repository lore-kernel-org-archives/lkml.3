Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbaLVQez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 11:34:55 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:48512 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067AbaLVQey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 11:34:54 -0500
Date: Mon, 22 Dec 2014 10:34:30 -0600
From: Felipe Balbi <balbi@ti.com>
To: Robert Baldyga <r.baldyga@samsung.com>
CC: Peter Chen <peter.chen@freescale.com>, <balbi@ti.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <m.szyprowski@samsung.com>,
        <k.opasiak@samsung.com>
Subject: Re: [PATCH] usb: gadget: udc-core: call udc_stop() before gadget
 unbind
Message-ID: <20141222163430.GH12815@saruman>
Reply-To: <balbi@ti.com>
References: <1418390248-6254-1-git-send-email-r.baldyga@samsung.com>
 <20141215051317.GC25410@shlinux2>
 <548EB262.6040208@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HuscSE0D68UGttcd"
Content-Disposition: inline
In-Reply-To: <548EB262.6040208@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--HuscSE0D68UGttcd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 15, 2014 at 11:05:22AM +0100, Robert Baldyga wrote:
> On 12/15/2014 06:13 AM, Peter Chen wrote:
> > On Fri, Dec 12, 2014 at 02:17:28PM +0100, Robert Baldyga wrote:
> >> As usb function drivers assumes that all usb request will be completed
> >> before function unbind call, we should supply such behavior. In some
> >> cases ep_disable() won't kill all request effectively, because some
> >> IN requests can be in running state. In such situation it's possible
> >> to have unbind function called before last request completion, which
> >> can cause problems.
> >=20
> > Doesn't the function's disable/unbind should call usb_ep_dequeue to make
> > sure the transfer has ended?
>=20
> USB function drivers like ECM or HID surely doesn't. It looks like
> there's assumption that all requests will be completed by UDC driver.

that's a bug on those drivers :-)

> Function ep_disable() should complete requests in hardware driver, but
> at least in DWC2 driver not all requests are completed at this stage

and that's a bug on dwc2 :-)

> (request which are in hardware FIFO are omitted to give them chance to
> be transferred). Those requests are forced to complete in udc_stop()

that's wrong, we're disabling the endpoint anyway. Either dwc2 needs to
wait_for_completion() or forcibly cancel the request. The bottom line is
that control should not exit ep_disable() until all requests have been
quiesced.

> function, and that's why it's needed to be called before unbind.
>=20
> >=20
> > .udc_stop may stop the controller, and .unbind may still visit hardware.
>=20
> Hmm, indeed it can be problem.

yes, it will be :-)

--=20
balbi

--HuscSE0D68UGttcd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUmEgWAAoJEIaOsuA1yqREmTMP/1qfO4wlYHr3SgtUQ25dOdQw
2hRe5LAo1lq8yThKBIO7ORyvKB5TxdIWFLT0gpBKzeOuWirrpipZqBsMgs0yCgME
3bFNr869gvAnYt41FCIAUsbShjdO2jl+YpVmVSnGfhjMhDIxJmZppL9y+OaTwG1G
0UFJbJZcOLTa7UbSiO4X/eoxxF6lck1kjhwE85rTFvhQvtk9IaVuB5dx+QL0XzRf
C8t/gw5+ncFHPs5h6LWBuLT9bIGHBANnZUWrZjEZF4zoD2JcyE96vl9nTMKoxLoK
YHN3Efx4xw6q0IgIPCBeuAXnHckZUiW3nsr4SUq3Btuuj09y6JoNvlMR6PkjQVZW
q2A71MMjcTV1NqHogzmFG/mkg/q+Uvo3XM5SeGA5rOoF0Tz3U/UKhUdAaHifgtWo
VSushJvJLWUasOfOaK8RmYovgt3Ch9Xaty14BrM2l2jHggqaXDuSklYJk9xiZIVs
tiGacAZAbf1qzEkovfOXOVxy1XQD+WveBEb8ARvhtmtihsn4IamrSgq6c+0CFW5y
9R91uy60saSg+hsfnaXHd0prraQErCcefks17BKkLOpIN69tZ9aOqjNSERWlN4Rl
m2DJ3W9oJIDbOPtdIrkfh/eY4WeqeM5Mw9DcOJe6gOom12bq3AR5E7S7OruVAvna
jMNOKoXk8/h7uj/iibiX
=/dGA
-----END PGP SIGNATURE-----

--HuscSE0D68UGttcd--
