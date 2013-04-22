Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab3DVTzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 15:55:45 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41260 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823Ab3DVTzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 15:55:44 -0400
Message-ID: <517595B7.1030000@pengutronix.de>
Date: Mon, 22 Apr 2013 21:55:35 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Steffen Trumtrar <s.trumtrar@pengutronix.de>, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [BUG] increased us/sys-load due to tty-layer in 2.6.38+ ?!
References: <20130408092558.GD25003@pengutronix.de> <20130408150611.GB13824@kroah.com>
In-Reply-To: <20130408150611.GB13824@kroah.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2FMQLJBUWAFNKGOTVAQPD"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2FMQLJBUWAFNKGOTVAQPD
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

(resent without attached scope screen shots)

On 04/08/2013 05:06 PM, Greg Kroah-Hartman wrote:
> On Mon, Apr 08, 2013 at 11:25:58AM +0200, Steffen Trumtrar wrote:
>> Hi!
>>
>> I noticed a problem with the tty subsystem on ARM. Starting with 2.6.3=
8+ load
>> on the serial connection causes a 10-15% increase in system/userspace =
load.
>> This doesn't change up to v3.9-rc4.
>>
>> The following setup was used:
>>
>>   telnet && screen microcom -p /dev/ttyUSB0
>>         |                           +--------+
>>         |-------------->------------|----+   |
>>     +-------+<---------<------------|----+   |
>>     |       |       +------+        |        |
>>     |  UUT  |<-USB->| FTDI |<-UART->|        |
>>     |       |       +------+        |   PC   |
>>     +-------+                       +--------+
>>         ^
>>         |
>>   telnet && top -d1
>>
>> The unit under test (UUT) is connected via USB->FTDI->UART to a PC. On=
 the PC
>> a "while true; do find /; done" produces some random output.
>> I connect to the UUT via telnet and then open a serial connection to t=
he PC
>> in a screen session, seeing the output produced on the PC. Then screen=
 gets
>> detached. So, basically, what I'm trying to do is producing load only =
on the
>> USB->FTDI->UART connection and not on the UUT itself.
>> Then another telnet connection is opened, to monitor the UUT with "top=
 -d1".
>> As UUT an imx27, kirkwood and an AT91 were used.
>>
>> To find the "offending" code, I bisected v2.6.38..v3.0 which gave the =
following
>> top output (non-scientifically, I know. But the switch in load distrib=
ution is
>> obvious nevertheless):
>>
>> 2.6.38           Cpu(s):  3.8%us,  1.9%sy,  0.0%ni, 94.3%id
>> 2.6.38+          Cpu(s):  1.9%us,  3.8%sy,  0.0%ni, 94.3%id
>> last good commit Cpu(s):  1.9%us,  2.8%sy,  0.0%ni, 95.3%id
>> first bad commit Cpu(s):  4.8%us, 14.5%sy,  0.0%ni, 80.6%id
>> 2.6.39-rc4       Cpu(s): 10.5%us,  8.9%sy,  0.0%ni, 79.8%id
>> 3.0              Cpu(s): 15.9%us, 19.6%sy,  0.0%ni, 62.3%id
>>
>> This resulted in
>>         f23eb2b2b28547fc70df82dd5049eb39bec5ba12
>>         tty: stop using "delayed_work" in the tty layer
>>
>> as possible cause. Reverting this commit by hand in v3.8 showed a load=
 distribution
>> similar to 2.6.38.
>> What I haven't done, is measure if the load is really increasing or if=
 top only
>> tells me so. Maybe the algorithm to calculate this somehow produces di=
fferent
>> results because of the switch from schedule_delayed_work to schedule_w=
ork?
>> So, is this a bug, a feature, a symptom,...?
>=20
> It's a "fake" load (i.e. no extra cpu is being used, just a "busy" wait=

> is happening.)

In order to have a more objective measurement, we hooked a scope to a
LED, which is triggered via the cpu0 trigger (echo cpu0 >
/sys/class/leds/led1/trigger) or the 'old' LED framework on the older
kernels.

The scope calculated the average voltage over a period of 10 seconds,
where 0 V equals 100% busy and 3.24 V means idle.

2.6.38 (good)    2,38V
2.6.38 (bad)     1,71V

2.6.38 bad is "f23eb2b tty: stop using "delayed_work" in the tty layer"
2.6.38 good is f23eb2b^ =3D=3D "f741a79 Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse"

Another test was to measure how long it takes to calculate 10 k digits
of PI. Less time means less load on the system by the tty layer:

                idle         tty open     serial load

v2.6.38-good    20.9s        22.3s        32.8s
v2.6.38-bad     20.9s        22.3s        51.5s

We repeated the measurements on a recent kernel:

v3.9-rc8        20.8s        22.6s        36.3s
v3.9-rc8-revert 20.8s        22.6s        26.8s

v3.9-rc8-revert is v3.9-rc8 with

    f23eb2b tty: stop using "delayed_work" in the tty layer

manually reverted.

On stock v3.9-rc8 we see input overruns, but I'll write a separate mail
once we've investigated the problem further. However the input overruns
disappear on our v3.9-rc8-revert.

> You should see an increased throughput with that patch applied, have yo=
u
> tested a real workload?

We've saturated the serial link which runs at 115200 baud. The problem
was originally observed by a customer of us in his real workload.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |



------enig2FMQLJBUWAFNKGOTVAQPD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlF1lbgACgkQjTAFq1RaXHP2EQCcDGQuVRBjkm7h2ZHSgCNz0s7Q
7XYAnjW8NWcrprXzkwiMUPKKEh3SubgJ
=WZ8J
-----END PGP SIGNATURE-----

------enig2FMQLJBUWAFNKGOTVAQPD--
