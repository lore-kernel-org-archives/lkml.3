Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934350Ab3FSJno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 05:43:44 -0400
Received: from sauhun.de ([89.238.76.85]:41084 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933755Ab3FSJnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 05:43:42 -0400
Date: Wed, 19 Jun 2013 11:45:40 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
Subject: Re: [PATCH REBASE] i2c-designware: make SDA hold time configurable
Message-ID: <20130619094540.GA2950@katana>
References: <20130514110745.GA10906@intel.com>
 <1368536642-7158-1-git-send-email-christian.ruppert@abilis.com>
 <20130610152954.GE2987@katana>
 <20130612144743.GB8102@ab42.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
In-Reply-To: <20130612144743.GB8102@ab42.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jun 12, 2013 at 04:47:45PM +0200, Christian Ruppert wrote:
> On Mon, Jun 10, 2013 at 05:29:55PM +0200, Wolfram Sang wrote:
> > On Tue, May 14, 2013 at 03:04:02PM +0200, Christian Ruppert wrote:
> > > This patch makes the SDA hold time configurable through device tree.
> > >=20
> > > [rebased to i2c-current/i2c-next/mainline-3.10-rc1]
> > >=20
> > > Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> > > Signed-off-by: Pierrick Hascoet <pierrick.hascoet@abilis.com>
> >=20
> > Hmm, I really have problems adding a generic property. I need to better
> > understand why this is needed? What is the usecase? Can't a safe value
> > be calculated depending on the bus-speed? Is there a public datasheet
> > available somewhere?
>=20
> I checked with our PCB/Applications team and the data sheets for the
> peripherals in question (DVB demodulator front ends) are under NDA.
> Mika, you seem to be interested in this patch as well. Do you know of
> any publicly available data sheets for hardware requiring this
> adjustment?

So, I looked around and found:
http://www.maximintegrated.com/app-notes/index.mvp/id/3268

which after thinking further about it gives me the following
conclusions:

- sda-hold-time is a property/requirement of a device not following
  the I2C spec. It is not a property of the master!

- It should not be encoded in the devicetree, since the flaw is implicit
  to the device, so only the driver needs to know about it. I wonder
  about something like this in the i2c slave driver:

	ret =3D i2c_request_sda_hold_time(client);

  The core then can collect the requests and forward them to the host
  driver. This driver then can set up the hardware or return -EOPNOTSUPP
  and we can even warn the user that there might be problems ahead.

- I wonder if we really need to have a parameter time-in-ns? The
  specs cleary say 300ns, so I'd think this is the value we should
  always use. This is from a theorhetical pov though, maybe your
  practical experience is different. What values do you need?


> In the case of the Designware block, the parameter both changes SDA and
> START hold times, however, and you'll find lots of data sheets for
> hardware with START hold time requirements on the net, e.g.
> http://ww1.microchip.com/downloads/en/DeviceDoc/21805B.pdf

What I couldn't find is a reference manual for a designware IP that
supports sda hold time? I found some spear SoC which do not have that
register, so that should surely be reflected in the patchset, too.

> The empirical solution in the function i2c_dw_scl_hcnt does not seem to
> work in all cases: Our lab guys confirmed that we have several PCB
> designs which do not work without adjusting the sda-hold-time parameter
> to an appropriate value. The value seems to be different for different
> PCBs.

I'd hope that 300ns is a safe value for all PCBs?

> I suspect that this kind of configurability is not the same for all i2c
> bus master hardware.

Yeah, maybe some do sda-holding by default? Dunno, never checked for
that detail.

Regards,

   Wolfram


--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwX3EAAoJEBQN5MwUoCm28H0P/RCZ2J9z31lMdR3TRfIgZMxa
+Le41EkmTG43pe5vw6yVM4smwYFuSMriScx0PHbOWzNxgcT/0cV8KT0WbTTt83Iz
qkeglUpEk9uswMzHBU9pzSCoJvs5kgjH3im3/rcCrerfhWE/zKzWBpy5CqDpGCNi
i5QReF1dv18xlBusq/eQMsl25IF3QM1s70UHvNS7/XUo25tDsEbz5nqjxIV/wrQV
MlMcDQyvPQsuyYbBieR7dtOXGgSwYQmggx4H6xPFou+4hbRTydlQJHV2LWsaU0+v
jtzQ68hwScx+oaz+SI6whnaTxgHnRPwEthL2oVL7Ang3cGSWM5ZsCTAyw2tdwFrI
ahQNNwqViKpMLI0cEtacMg2fb+o0lpQVsbyQyDrKxJHJRAWYllL7K1K4jkoVG3gC
z3ar4AIBu/stvGWB1GXodjCEJZGnOdNWTyrZ4KjtC5MPIzxKMoY4XwbFez4ggf3T
O1qlhDJNU5k5/T+cX3MX3yyYlkB6pjlnnTDKhN+X/1q5bmQocb5LjclgBvIUesi+
C/xC0sQ96oIRvhAfqoaVws3XG5syIvA2rH1ZnKtZdlYdXk5MQosCdDhZbDSmKfPG
HmgZ7OqkpPTAYnmfd55idthHAmV83soARv0gHtnI07CNjfDzzBGm/c8Yg1E8WJob
lfEmt2EUm4MaWxC2+cb/
=++zS
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
