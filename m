Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217AbbAFCLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 21:11:09 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:32920 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754158AbbAFCLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 21:11:08 -0500
Date: Mon, 5 Jan 2015 20:10:05 -0600
From: Felipe Balbi <balbi@ti.com>
To: Dave Gerlach <d-gerlach@ti.com>
CC: <balbi@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Benoit Cousson <bcousson@baylibre.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Suman Anna <s-anna@ti.com>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 2/3] soc: ti: Add wkup_m3_ipc driver
Message-ID: <20150106021005.GC24980@saruman>
Reply-To: <balbi@ti.com>
References: <1420228817-41310-1-git-send-email-d-gerlach@ti.com>
 <1420228817-41310-3-git-send-email-d-gerlach@ti.com>
 <20150102201643.GE4920@saruman>
 <54AB14E4.2010607@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tqI+Z3u+9OQ7kwn0"
Content-Disposition: inline
In-Reply-To: <54AB14E4.2010607@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--tqI+Z3u+9OQ7kwn0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jan 05, 2015 at 04:49:08PM -0600, Dave Gerlach wrote:
> >> +	/*
> >> +	 * Write a dummy message to the mailbox in order to trigger the RX
> >> +	 * interrupt to alert the M3 that data is available in the IPC
> >> +	 * registers. We must enable the IRQ here and disable it after in
> >> +	 * the RX callback to avoid multiple interrupts being received
> >> +	 * by the CM3.
> >> +	 */
> >> +	omap_mbox_enable_irq(m3_ipc_state.mbox, IRQ_RX);
> >> +	ret =3D mbox_send_message(m3_ipc_state.mbox, (void *)dummy_msg);
> >=20
> > unnecessary cast.
>=20
> I get a compiler warning without this one, may need it.

right, try with:

	ret =3D mbox_send_mesage(m3->mbox, &dummy_msg);

Another option is to just get rid of mbox_msg_t altogether since that's
just a u32 anyway. Then fix omap-mailbox.c::omap_mbox_chan_send_data()
so it knows it's receiving a void *, then it could:

	u32 data =3D *(u32 *)mssg;

but as Tony said, better not to add more dependencies to this series.

> >> +	m3_rproc =3D rproc_get_by_phandle(rproc_phandle);
> >> +	if (!m3_rproc) {
> >> +		dev_err(&pdev->dev, "could not get rproc handle\n");
> >> +		ret =3D -EPROBE_DEFER;
> >> +		goto err;
> >> +	}
> >> +
> >> +	m3_ipc_state.rproc =3D m3_rproc;
> >> +	m3_ipc_state.dev =3D dev;
> >> +	m3_ipc_state.state =3D M3_STATE_RESET;
> >> +
> >> +	/*
> >> +	 * Wait for firmware loading completion in a thread so we
> >> +	 * can boot the wkup_m3 as soon as it's ready without holding
> >> +	 * up kernel boot
> >> +	 */
> >> +	task =3D kthread_run((void *)wkup_m3_rproc_boot_thread, m3_rproc,
> >> +			   "wkup_m3_rproc_loader");
> >=20
> > I wonder two things:
> >=20
> > 1) This thread will only be used during boot up. Do we really need a
> > thread or would request_firmware_nowait() be enough ?
> >=20
> > 2) what's the size of the firmware ? Is it really so large that we must
> > run this as a separate thread ? Meaning, why isn't request_firmware()
> > enough ? How much time would we be waiting ?
>=20
> The issue here comes from the case where you attempt to load a firmware s=
tored
> in the rootfs which is the typical use case for this. Remoteproc core req=
uests
> the firmware twice, first with _nowait to load the resource table and the=
n again

sounds like a bug to me. Or am I missing something ?

> without nowait to boot the rproc. rproc_boot requires the resource table =
to be
> loaded. The thread is really to wait for the firmware loaded completion, =
which
> gets set after the resource table has been loaded, to let boot proceed. S=
ystem
> boot will get stuck otherwise as this driver can probe before rootfs is a=
vailable.

IMO, that should be fixed in remoteproc, but it probably goes towards
"let's not add more dependencies".

--=20
balbi

--tqI+Z3u+9OQ7kwn0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUq0P9AAoJEIaOsuA1yqREfF0P/1bYVgB1qApdE8LwfUibbQxy
aYwBkluXZrxsHqdNT9KIjH8druqQLQYMpN52g/CXebZMZubr5X2UxyIqoaxYQFe1
E1ffjVyuz6/C/ywS/sFMZFHuq/dEPdzD0FrDADbUhBOSiX+RCpq4RvVeTds6W3bh
LP7KIMbmye+afiA3VuMho3dfiiIMBOwMwSCOYrGH5tPc64LmgwDwvJBvW0xG9VVN
mZVRfvrUKWzSsmZuy7Vg2wUcGCcFv80y58/J7C0hjQZRiDs4+mwAPsQvOqjP38Zf
XnnnCDr+pp+C5w2gsDybVaIEw3MdHscVsBw8KtY6IywY154bmVfoCbwGTbrX9dcs
8CRDokcQfB4ZzyTlKN3bZECMx1fc304u5cq+xuU4xzfIQuj0F//OE4IkW/i6fALl
g0QhZ3hb24KV/tBdkojcRlP4jjtrkHLj1VgrH9+F8Qop+RPi3ZpnBduZW3dCIMf1
lNuEgS4GkWf2Ho9omalZhVXpnU4HZoOQJEeMZBvaOAvjAx7H9sS02dzvK6DUZAlS
RYVvE2N5ps6PoBYKzSeRl5zaveYw4sHvEM/tr45sjsINs0QyCJ7wB2bgv3bk+KmJ
jefDxNpRqYQTuplXcDuk2CRav9s8nh4Y8noMJVA2PWhVvAnqaBzw6Ea6iSrzOZ65
01C9kTk0Vr/tgFja5MQi
=ujDN
-----END PGP SIGNATURE-----

--tqI+Z3u+9OQ7kwn0--
