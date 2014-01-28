Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbaA1IqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 03:46:23 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42835 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbaA1IqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 03:46:21 -0500
Message-ID: <52E76E3A.8030807@ti.com>
Date: Tue, 28 Jan 2014 10:45:46 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        "Kristo, Tero" <t-kristo@ti.com>
Subject: Re: [PATCH] clk: divider: fix rate calculation for fractional rates
References: <1383736008-22764-1-git-send-email-tomi.valkeinen@ti.com> <20131106111534.GW16735@n2100.arm.linux.org.uk> <527A2C9C.4080409@ti.com> <20131106161911.GA16735@n2100.arm.linux.org.uk>
In-Reply-To: <20131106161911.GA16735@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="sMaeGXcOjeewFsFu9XaOLvtjRqgH2VUeB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--sMaeGXcOjeewFsFu9XaOLvtjRqgH2VUeB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Mike, Russell,

On 2013-11-06 18:19, Russell King - ARM Linux wrote:
> On Wed, Nov 06, 2013 at 01:48:44PM +0200, Tomi Valkeinen wrote:
>> On 2013-11-06 13:15, Russell King - ARM Linux wrote:
>>> On Wed, Nov 06, 2013 at 01:06:48PM +0200, Tomi Valkeinen wrote:
>>>> This means that the following code works a bit oddly:
>>>>
>>>> rate =3D clk_round_rate(clk, 123428572);
>>>> clk_set_rate(clk, rate);
>>>
>>> You're right, but the above sequence is quite a crass thing to do.  W=
hy?
>>
>> Do you mean that you think the fix is right, but the above example
>> sequence is silly, or that the fix is not needed either?
>=20
> I think a fix _is) required, because:
>=20
> 	rate =3D clk_get_rate(clk);
> 	clk_set_rate(clk, rate);
> 	assert(clk_get_rate(clk) =3D=3D rate);
>=20
> If not, there's something quite wrong.  However, I am saying that the
> sequence you provided was nevertheless silly - I've seen it in real cod=
e
> in the kernel, which is why I've commented about it.

I just ran into this issue again with omap3, and so I'm resurrecting the
thread.

Mike, can you review the patch?

Russell, I'd like to understand why you think the original example is bad=
:

	rate =3D clk_round_rate(clk, rate);
	clk_set_rate(clk, rate);

If the definition of clk_round_rate is basically "clk_set_rate without
actually setting the rate", I agree that the above code is not good as
it might not work correctly.

However, if  the following code you gave should work:

	rate =3D clk_get_rate(clk);
	clk_set_rate(clk, rate);
	assert(clk_get_rate(clk) =3D=3D rate);

then the original example should also always work, as it's almost the
same as:

	/* this is the "round" part */
	clk_set_rate(clk, rate);
	rate =3D clk_get_rate(clk);

	clk_set_rate(clk, rate);
	assert(clk_get_rate(clk) =3D=3D rate);

Why I'm asking this is that for me (and probably for others also if
you've seen it used in the kernel code) it feels natural to have code lik=
e:

	rate =3D clk_round_rate(clk, rate);
=09
	/* Verify the rounded rate here to see it's ok for the IP etc */

	/* The rate is ok, so set it */
	clk_set_rate(clk, rate);

This could be rewritten as:

	rounded_rate =3D clk_round_rate(clk, rate);
=09
	/* Verify the rounded rate here to see it's ok for the IP etc */

	/* The rounded rate is ok, so set the original rate */
	clk_set_rate(clk, rate);

But it just feels unnecessary complication to keep both the original
rate and the rounded rate around.

 Tomi



--sMaeGXcOjeewFsFu9XaOLvtjRqgH2VUeB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS5246AAoJEPo9qoy8lh71GsUP/2CtkABLXxGs9YCgJm6Cgde2
Ew+i0mqm5/qQuhud5eLLp7jUf8sYmnqemMhlWA14oaviWTjiDwC6pxd57rcSiiG3
/pIKkFlGgDXgBAlA0D9Q2txu398kLva0F1KPcBLCg3Uf6bVmqgG6pnkGS3GF3y7u
qPliPr9ji5WS5otNsFX4qGElODUCk8fCf9BeI0wIsQQBFTPt2nZ+CJYe25qfUFwU
POv6LfHzEOaCexrWTfotBpsBumNTSsh9CE0rAqCJruvIl4/0MJXAE7g+i8yMpKk6
2BHyX/GrNE5RtQdPqOuK2DSX/iSjbfpWN3I7oJq/+SSxoV/Ma8BwA6WQiWNdSweu
Ln8tQ6rddou7d15nZgnx+Mfe4dyO09oRfIhDxwOHTt9oR9Izzx2+k7bfFzBymWav
8z90agzsTzqy+B6MPJEzWzmO7pEY5x3drZlrLUPYKdd8mNZ20p7X+pF61AqncsaW
8VA11wczKRuTtJzR1BTPBGD2anIJYRwzwp62Iyo5jeu9hQx3bB2L/O36tFVtpKMe
qZF6Hpa4sD5cIY4kJniNohhMjkDOvgNLlYmf4DleCnmBFZJNA8zHnfyXyg7/FU/J
R52n5HBd29Oe1pxXEklHpc4BOa7ZrF2ZOXDATbNgXQF4AwZz66aX7veIVXSqteWP
b8xtxzDitkMUGrcSAqgo
=PmDU
-----END PGP SIGNATURE-----

--sMaeGXcOjeewFsFu9XaOLvtjRqgH2VUeB--
