Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbaH0BnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 21:43:09 -0400
Received: from mail.kernel.org ([198.145.19.201]:47057 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295AbaH0BnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 21:43:07 -0400
Date: Wed, 27 Aug 2014 03:43:00 +0200
From: Sebastian Reichel <sre@kernel.org>
To: David Riley <davidriley@chromium.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Guenter Roeck <linux@roeck-us.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Anton Vorontsov <anton@enomsg.org>,
        Marc Carino <marc.ceeeee@gmail.com>, Anders Berg <anders.berg@lsi.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Jamie Lentin <jm@lentin.co.uk>, Doug Anderson <dianders@chromium.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v1 1/1] power: Add simple gpio-restart driver
Message-ID: <20140827014300.GA29512@earth.universe>
References: <1409096705-24290-1-git-send-email-davidriley@chromium.org>
 <1409096705-24290-2-git-send-email-davidriley@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <1409096705-24290-2-git-send-email-davidriley@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi David,

On Tue, Aug 26, 2014 at 04:45:05PM -0700, David Riley wrote:
> This driver registers a restart handler to set a GPIO line high/low
> to reset a board based on devicetree bindings.

Driver looks fine to me. I have some comments about the
Documentation, though:

> [...]
> diff --git a/Documentation/devicetree/bindings/gpio/gpio-restart.txt b/Documentation/devicetree/bindings/gpio/gpio-restart.txt
> new file mode 100644
> index 0000000..7cd58788
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/gpio/gpio-restart.txt
> @@ -0,0 +1,48 @@
> +Driver a GPIO line that can be used to restart the system as a
> +restart handler.

Please fix the Typo (first word).

> [...]
> +
> +The driver supports both level triggered and edge triggered power off.
> +At driver load time, the driver will request the given gpio line and
> +install a restart handler.

The wording is too driver centric IMHO. You are supposed to document
the binding in a generic way. Maybe start with something like:

"This binding supports level and edge triggered reset."

(power off is the wrong word, since there is already gpio-poweroff).

> +If the optional properties 'input' is +not found, the GPIO line
> +will be driven in the inactive state. Otherwise its configured
> +as an input.

What is this needed for?

> +When do_kernel_restart is called the various restart handlers will be tried
> +in order.  The gpio is configured as an output, and drive active, so
> +triggering a level triggered power off condition. This will also cause an
> +inactive->active edge condition, so triggering positive edge triggered
> +power off. After a delay of 100ms, the GPIO is set to inactive, thus
> +causing an active->inactive edge, triggering negative edge triggered power
> +off. After another 100ms delay the GPIO is driver active again. If the
> +power is still on and the CPU still running after a 3000ms delay, a
> +WARN_ON(1) is emitted.

I really appreciate the description of the driver (it made it easier
to review it :)), but Documentation/devicetree should avoid
Linuxisms. In other words: this is the wrong location for the
description.

> +Required properties:
> +- compatible : should be "gpio-restart".
> +- gpios : The GPIO to set high/low, see "gpios property" in
> +  Documentation/devicetree/bindings/gpio/gpio.txt. If the pin should be
> +  low to power down the board set it to "Active Low", otherwise set
> +  gpio to "Active High".
> +
> +Optional properties:
> +- input : Initially configure the GPIO line as an input. Only reconfigure
> +  it to an output when the machine_restart function is called. If this optional
> +  property is not specified, the GPIO is initialized as an output in its
> +  inactive state.
> +- priority : A priority ranging from 0 to 255 (default 128) according to
> +  the following guidelines:
> +	0:	Restart handler of last resort, with limited restart
> +		capabilities
> +	128:	Default restart handler; use if no other restart handler is
> +		expected to be available, and/or if restart functionality is
> +		sufficient to restart the entire system
> +	255:	Highest priority restart handler, will preempt all other
> +		restart handlers

You should add a short information about the property type here
(e.g. "8 bit integer" for priority).

> +Examples:
> +
> +gpio-restart {
> +	compatible = "gpio-restart";
> +	gpios = <&gpio 4 0>;
> +	priority = /bits/ 8 <200>;
> +};
> [...]

-- Sebastian

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJT/TekAAoJENju1/PIO/qanrQQAKPg8+Qi5oPDFni3AZxhonI+
zrY+JR1rwRC0mdk9vNvbuyn3dscv8CJdlCVYcOEX/YB/x4216PfHrcw4kc0j4qjP
2dOPawDHLtGqW9BVLTQLh7iNHeEy0BpDbs0Aw0UDpNPBgirajSWsJcaKNbxnwovr
MtRvC07GtNZbIRR9xv9Ss4+S0a/kqrZY0GjseVL2GZf7ZoIo+I+Rjg30n4SGhgHJ
p8KCNfcaeDnF/NHBW/GRFfhtw+19t8It+CCd+bo5x9iELpe6dTzYJbw++gyVz6fP
+8iFwTANhBfNn5gEifYV8LP8nyOLU7EaSXp64nIHB9mdckReuPoFl5789Ny6QTyF
T5m6oWPrELnIJHBQL4MVDPTQ0dJkRD0fykrM69MRBtqt+otrxWcpb+LE/uxr/Zp9
64cjwi3lzam2Ph/ktNctG39juO0Ig+3i11Q2rmxMQWzLbQSYIeuhyB+sEK/rxpCI
MnlrFp0+ZTjeYFRNRHKP0Wr4Ec9f6hm/WhL/ry+ka54txad8whm+zagVyJaAlJwd
i75YhfpPnx+ZI2YyzPeGJYxwVlSQsuTFT3JAvCg94UaAO7zwVz7J6/vq62nr6W2V
o2BnR3Vnpi7jbQmWEdGgK7h1TOx6mLjlx7LBOSx8gBLEHWIt48DtQfFvsMQya6DH
f1nwkNggeV7gNGFZ/G01
=oWqb
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
