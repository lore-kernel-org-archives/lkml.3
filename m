Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966518AbaFRM6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 08:58:51 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:51019 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966162AbaFRM6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 08:58:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, mark.brown@linaro.org,
        Tomasz Figa <t.figa@samsung.com>, linux-samsung-soc@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>, linux-kernel@vger.kernel.org,
        joshi@samsung.com, vikas.sajjan@samsung.com, chow.kim@samsung.com,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH RFC] mfd: syscon: Decouple syscon interface from syscon devices
Date: Wed, 18 Jun 2014 14:57:47 +0200
Message-ID: <5537724.LlmJ2hxcKn@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53A0B27E.5010708@gmail.com>
References: <53A05E2D.6020702@samsung.com> <5027740.B7iVUcUX2T@wuerfel> <53A0B27E.5010708@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:apMeJ233hgExA9//3C1AO83OZiWse4Brwhf8khZHF7Y
 BKGT7ttNKHu7MCBElUHkNMllwIB2ZkxWY0nmltSCjJTlLhh0KG
 0ZWpfixvPb5JatIlC5nOK4qnKm7PYjgjPlOGbc+e7dyH0u8Qb2
 CmcvLWe8yo3sl0whqEL6tCRSatK51a40a61OBHMwMT+hBWeE5n
 XpnSPlKllmB+sagjQLRjIuxVQUQcRqseTJhKq482TkspLsSQx1
 0DjM6yz/jCWhn57rREyNC+rT8LUKqiFGHjs+X+2NcSz68RXZEy
 S5nmMGTumrPUsxZr4x2jrO4AZ5snGT+Z885QMJ8JQXhKtfZooy
 KEvGdgnF2DQsbXHIWti4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 June 2014 23:26:22 Tomasz Figa wrote:
> On 17.06.2014 17:42, Arnd Bergmann wrote:
> > This seems like a reasonable way of solving the problem, but I think
> > there is an even better one that we have about in the past: if we
> > promote syscon from a platform driver into a a drivers/base/ helper
> > that is independent of the platform device matching, we can use
> > call syscon_regmap_lookup_* for any device node, whether it's already
> > bound to a driver or not, which do what you need. It would also make
> > it easier to call the syscon code before the platform_device
> > infrastructure gets initialized, which is something a number of
> > people have asked for, e.g. for using regmap to do SMP bringup
> > or for clock registration.
> 
> Basically, unless I'm missing your point, this is what my patch does,
> except that I don't move it to drivers/base/ and the registration
> function I added require a pointer to struct device. Indeed, decoupling
> it further from the driver model, by adding of_syscon_register() should
> be useful for early users.

I believe the part you are missing is that with the approach I suggested,
there would be no registration function at all. You can easily do the
lookup from the client drivers using the DT data structures, with no
need for the device at all. The only exception today is the clps711x
platform using syscon_regmap_lookup_by_pdevname(), but that should be
solved in 3.17 when clps711x becomes DT-only.

> Should I move this to drivers/base/, even though from current location
> it can be used outside the platform driver anyway?

Thinking about it some more, drivers/of might be better than drivers/base.
It depends a bit where we are heading with this, in particular if we
expect to see non-DT users in the future.

	Arnd
