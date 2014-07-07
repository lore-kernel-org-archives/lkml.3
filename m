Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaGGUGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 16:06:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:51570 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaGGUF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 16:05:59 -0400
Date: Mon, 7 Jul 2014 22:05:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: sched: spinlock recursion in sched_rr_get_interval
Message-ID: <20140707200550.GA6758@twins.programming.kicks-ass.net>
References: <53B98709.3090603@oracle.com>
 <20140707083016.GA19379@twins.programming.kicks-ass.net>
 <53BAA6DF.5060409@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C2AE+UNCNp5RBAjn"
Content-Disposition: inline
In-Reply-To: <53BAA6DF.5060409@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C2AE+UNCNp5RBAjn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 07, 2014 at 09:55:43AM -0400, Sasha Levin wrote:
> I've also had this one, which looks similar:
>=20
> [10375.005884] BUG: spinlock recursion on CPU#0, modprobe/10965
> [10375.006573]  lock: 0xffff8803a0fd7740, .magic: dead4ead, .owner: modpr=
obe/10965, .owner_cpu: 15
> [10375.007412] CPU: 0 PID: 10965 Comm: modprobe Tainted: G        W      =
3.16.0-rc3-next-20140704-sasha-00023-g26c0906-dirty #765

Something's fucked; so we have:

debug_spin_lock_before()
	SPIN_BUG_ON(lock->owner =3D=3D current, "recursion");

Causing that, _HOWEVER_ look at .owner_cpu and the reporting cpu!! How
can the lock owner, own the lock on cpu 15 and again contend with it on
CPU 0. That's impossible.

About when-ish did you start seeing things like this? Lemme go stare
hard at recent changes.

--C2AE+UNCNp5RBAjn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTuv2eAAoJEHZH4aRLwOS6UJkQAKhk6ehFbBtjLp/RkkhsE05A
RouX/ZdI1cC7l6n2U3CsWF0Vs7t5o3ls8baaJC/gjkJeoTZq67GElzTnbolX1HSH
mlEuG1uihOlr6gRDYw3RkxXzJfz9WQHAaFS5GDzb/vPHBozjs0HuYC+KL1umPgAZ
65MTAY3eWx4m8p73XV+pAgpMlGWFCNBffhu3xdEyrm3osIofbqHDLKp24UJCfAHR
cybHRr+EGFCnaQQOcq8aEnh9UBtgOIg63VLVToXmRp+AXCNpIy0I2esCU31v5ZeV
yP/KmaCZM2hwZxu0ki1hp1fXJx+i+QeXqcJ/O67/TanyniUGIQCpBAPFLMOEGlJn
VWgTmatTPKYZFvzd8xvCVU5MpXpLOCdZeY+VgdIqhM1pVilfK06ppxaCd7i4yTHn
xwTg9HhRGeFi4qiGDlPZOHk47ewM5uN8Xnp5wHBpkNC5OsTz9LzE/vqQKvKPlGwZ
eOEYAhIn7kRJh8ovYUpdIqRytT8sM+vQVplS1r8x4TzM9Fx0DSf5edlpSppvRQWx
F/m8lclDjsOAF6t8ho9wHPQrNuR6wWOmEdapF/htPQLCmPdqfcY2bc+htzoehcp9
3lgJCkIWlfrUXf4f/U9hBrgrqujqWJ2XD21clUukejvz6OTmh1R+m/LyNKaZCtKu
1RdAOjzYwvJ6bjc9IrTq
=IQnx
-----END PGP SIGNATURE-----

--C2AE+UNCNp5RBAjn--
