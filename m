Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbaCFVk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 16:40:28 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59121 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655AbaCFVkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 16:40:23 -0500
Message-ID: <5318EB2E.8040707@pengutronix.de>
Date: Thu, 06 Mar 2014 22:39:58 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.3.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] net: sched: dev_deactivate_many(): use msleep(1) instead
 of yield() to wait for outstanding qdisc_run calls
References: <1393976987-23555-1-git-send-email-mkl@pengutronix.de> <20140306.160622.59358366688518505.davem@davemloft.net>
In-Reply-To: <20140306.160622.59358366688518505.davem@davemloft.net>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="PF9TBigp9pdO7JoQ4tqtIL4ebrJu55W6k"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PF9TBigp9pdO7JoQ4tqtIL4ebrJu55W6k
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 03/06/2014 10:06 PM, David Miller wrote:
> From: Marc Kleine-Budde <mkl@pengutronix.de>
> Date: Wed,  5 Mar 2014 00:49:47 +0100
>=20
>> @@ -839,7 +839,7 @@ void dev_deactivate_many(struct list_head *head)
>>  	/* Wait for outstanding qdisc_run calls. */
>>  	list_for_each_entry(dev, head, unreg_list)
>>  		while (some_qdisc_is_busy(dev))
>> -			yield();
>> +			msleep(1)
>>  }
>=20
> I don't understand this.
>=20
> yield() should really _mean_ yield.
>=20
> The intent of a yield() call, like this one here, is unambiguously
> that the current thread cannot do anything until some other thread
> gets onto the cpu and makes forward progress.
>=20
> Therefore it should allow lower priority threads to run, not just
> equal or higher priority ones.

Yes, we need a call that does what you described, however I'm not sure
if yield() really does that. According to:

http://lxr.free-electrons.com/source/kernel/sched/core.c#L3599

> * Typical broken usage is:
> *
> * while (!event)
> *      yield();
> *
> * where one assumes that yield() will let 'the other' process run that =
will
> * make event true. If the current task is a SCHED_FIFO task that will n=
ever
> * happen. Never use yield() as a progress guarantee!!

My Process runs with SCHED_FIFO and prio > 50, with IRQ at default prio,
which is 50.

Maybe the RT guys can comment on this. I found another interesting
function in the RT patch set: cpu_chill().

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--PF9TBigp9pdO7JoQ4tqtIL4ebrJu55W6k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlMY6zQACgkQjTAFq1RaXHMH9gCgle0A5xzXc6/5/ajU1GJenwVg
yW8An0Q9pOVl7qrcUoK7zLwDdpKRPB0k
=JQqD
-----END PGP SIGNATURE-----

--PF9TBigp9pdO7JoQ4tqtIL4ebrJu55W6k--
