Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbaILLms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 07:42:48 -0400
Received: from mout.gmx.net ([212.227.17.21]:65416 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728AbaILLmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 07:42:46 -0400
From: Marc Dietrich <marvin24@gmx.de>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean Delvare <jdelvare@suse.de>, Magnus Damm <magnus.damm@gmail.com>,
        Andrey Danin <danindrey@mail.ru>, devicetree@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [RFC 4/4] ARM: shmobile: r8a7790: adapt DTS for I2C slave support
Date: Fri, 12 Sep 2014 13:42:33 +0200
Message-ID: <1921859.32moD2F04k@fb07-iapwap2>
User-Agent: KMail/4.13.3 (Linux/3.17.0-rc4-12.gfc9498b-desktop+; KDE/4.13.3; x86_64; ; )
In-Reply-To: <20140912095821.GB1930@katana>
References: <1410274470-12712-1-git-send-email-wsa@the-dreams.de> <7627175.tG5quZH0VN@fb07-iapwap2> <20140912095821.GB1930@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart282107212.igu25S7V2Q"; micalg="pgp-sha1"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:bqU9e4gdh+GgJW1AKUxI0+mTyfkITQk9efJGan6/8Vtpp94jZJy
 gS6yHU72Br9gNFh9F7IQSvEnI2TgqoFGLMirKl95LdTzpGr8LffiDyuMHO4wBgSrDjfjYEk
 VxfFV4KxJ1O2UjN3vc//xjpHgqmn4N+BciZzauKMlzcs4fbxEJB/v9Elmcp+jKFc5rp4UwR
 +O9K2Y942D+AvnhSCeJ+Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart282107212.igu25S7V2Q
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"

Am Freitag, 12. September 2014, 11:58:21 schrieb Wolfram Sang:
> > ok, take our embedded controller driver (in staging/nvec) as an example.
> > It's basicly an MFD connecting keyboard, mouse, power, gpio, and some
> > other stuff to the soc. The MFD operates in master mode while the SOC is
> > the I2C slave. Theoretically, these roles could also switch (but that's
> > not defined in the nvec protocol).
> 
> I see these cases currently:
> 
> 1) my current case
> 
> The I2C slave is not needed for board bringup, mainly for development or
> playing around. It can have this or that functionality on this or that
> address. -> does not belong into DT, should be done in userspace
> 
> 2) Slave mode is needed for board bringup
> 
> Some other components need a specific I2C slave to be present before
> userspace is available, otherwise the system is unusable. This is IMO
> then a hardware description and justifies DT entries:
> 
> DT pseudocode:
> 
> 	i2c {
> 		compatible = "nvidia, tegra-i2c";
> 
> 		ec-slave@42 {
> 			compatible = "nvidia, ax100-ec-slave";
> 			reg = <0x42>;
> 		};
> 	};
> 
> Of course, an MFD driver providing "nvidia, ax100-ec-slave" is needed
> which uses the I2C slave mode of the tegra controller.
> 
> 3) Master + slave mode is needed for board bringup:
> 
> Again, IMO a hardware description, so we could use:
> 
> 	i2c {
> 		compatible = "nvidia, tegra-i2c";
> 
> 		ec@64 {
> 			compatible = "nvidia, ax100-ec";
> 			reg = <0x64>;
> 		};
> 	};
> 
> This is a standard I2C device driver (using the MFD framework) where
> i2c-tegra would act as a master on the client for 0x64. However, its
> probe function can fill an i2c_board_device (the driver should know the
> slave device address because of the protocol), get a new client using
> i2c_new_device, and register that as a I2C slave client. It then has an
> address where it listens and an address where it can send to. When to do
> what is protocol implementation.
> 
> Am I missing something? Board properties can be encoded within the
> compatible entries ("ax100-ec", "ax200-ec"...). I'd think this means
> mostly different protocols, though.

well, ac100 is the name of the board and nvec is the name of the protocol. 
Anyway, I'm fine with encoding the mode to use in the compatible property. 
Like you said before, a hypothetical driver supporting both modes could also 
register two compatibility strings (eg. nvidia,nvec and nvidia,nvec-slave) and 
use the mode (and hence the meaning of the reg value) according to this 
string.

Thanks,

Marc

--nextPart282107212.igu25S7V2Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAABAgAGBQJUEtwpAAoJEKyeR39HFBtoVGYH/3X351c+h8pLFgPgMMKrei0c
VumAw7B3XGzSZACoEfMrgNnhUqx9OGJlU5/kzcECC/epuntrumhGZt8xJssSv7HC
pK3zz/yrvZwEmiTscbgK0wHeLAWxTECTFLUgj4n8k11otpOjqvz3DZHtWya3LGn2
9MUU7bwNqxEvM4PosiGWqweF1O6IDbyw62/2hj4i7qkosq2OeY+SaH+LaHzXMuWL
dpXlT6AufznyRulMqKUZTZYayd6P4UcZ75FAkgFKZL0dsBD87JlRpnYmSfx+WngZ
gAwhu3QaT2PuhbA/T/robkXwyYDSwkwOZL44p968pSsuaZh5Yw+r3xh3XuhunDc=
=BTjE
-----END PGP SIGNATURE-----

--nextPart282107212.igu25S7V2Q--

