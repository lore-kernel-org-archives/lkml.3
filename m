Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab3FKScW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 14:32:22 -0400
Received: from mail-bk0-f68.google.com ([209.85.214.68]:34453 "EHLO
	mail-bk0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab3FKScU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 14:32:20 -0400
Date: Tue, 11 Jun 2013 20:32:16 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-pwm@vger.kernel.org,
        linux-doc@vger.kernel.org, poeschel@lemonage.de, rob@landley.net
Subject: Re: [PATCH v4] pwm: add sysfs interface
Message-ID: <20130611183216.GB29842@mithrandir>
References: <201306101612.07708.hartleys@visionengravers.com>
 <20130611101432.GA932@manwe>
 <51B709F5.8070909@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CdrF4e02JqNVZeln"
Content-Disposition: inline
In-Reply-To: <51B709F5.8070909@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CdrF4e02JqNVZeln
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 11, 2013 at 09:28:53PM +1000, Ryan Mallon wrote:
> On 11/06/13 20:14, Thierry Reding wrote:
>=20
> > On Mon, Jun 10, 2013 at 04:12:07PM -0700, H Hartley Sweeten wrote:
[...]
> >> +config PWM_SYSFS
> >> +	bool "/sys/class/pwm/... (sysfs interface)"
> >> +	depends on SYSFS
> >> +	help
> >> +	  Say Y here to provide a sysfs interface to control PWMs.
> >> +
> >> +	  For every instance of a PWM device there is a pwmchipN directory
> >> +	  created in /sys/class/pwm. Use the export attribute to request
> >> +	  a PWM to be accessible from userspace and the unexport attribute
> >> +	  to return the PWM to the kernel. Each exported PWM will have a
> >> +	  pwmX directory in the pwmchipN it is associated with.
> >=20
> > I have a small quibble with this. Introducing options like this make it
> > increasingly difficult to compile-test all the various combinations, so
> > I'd like to see this converted to a form that will play well with the
> > IS_ENABLED() macro. We already have the same issue with DEBUG_FS, only
> > to a lesser degree because it doesn't have an additional PWM-specific
> > Kconfig option.
> >=20
> > In order not to burden you with too much work, one option for now would
> > be to unconditionally build the sysfs.c file and use something along
> > these lines in pwmchip_sysfs_{,un}export():
> >=20
> > 	if (!IS_ENABLED(CONFIG_PWM_SYSFS))
> > 		return;
> >=20
> > Which should allow the compiler to throw away all PWM_SYSFS-related
> > code in that file, leaving an empty function.
>=20
>=20
> Won't that also cause the compiler to spew a bunch of warnings about
> unreachable code in the !CONFIG_PWM_SYSFS case? We have the
> unreachable() macro, but that isn't supported nicely by all compilers.

No, I don't think it does. We have other code already in the PWM
subsystem which uses a similar approach and I haven't seen any such
warning.

> If CONFIG_SYSFS is not enabled and sysfs.c is using functions that now
> do not exist, that will cause compile errors, since the compiler will
> still attempt to compile all of the code, even though it will remove
> most of it after doing so.

include/linux/sysfs.h defines all of the public functions as static
inline dummies if CONFIG_SYSFS isn't enabled so everything should be
fine.

> Also, any functions that are extern will also end up generating empty
> functions in the kernel binary (static linkage functions should
> disappear completely). This is obviously very negligible in size,
> but using a proper Kconfig option results in zero size if the option
> is compiled out.

That's correct. Ultimately my intention is to move the sysfs.c code back
into core.c and use static linkage in order for the unused code to
disappear completely. That'll make core.c bigger of course, but I think
I can handle that.

Perhaps most of the code can even remain in sysfs.c if we move just the
pwmchip_sysfs_export() and pwmchip_sysfs_unexport() into core.c and call
into functions from sysfs.c from there. That way we can make them static
and the compiler can throw them away if PWM_SYSFS isn't selected. The
linker should then be clever enough to notice that none of the code in
sysfs.c is actually used and drop it as well.

> > It's not the optimal
> > solution, which would require the sysfs code to go into core.c and be
> > conditionalized there, but it's good enough. I can always go and clean
> > up that code later (maybe doing the same for DEBUG_FS while at it).
>=20
> >=20
>=20
> > The big advantage of this is that we get full compile coverage of the
> > sysfs interface, whether it's enabled or not. Calling an empty function
> > once when the chip is registered is an acceptable overhead.
>=20
>=20
> Why not just make CONFIG_PWM_SYSFS default y, so that if CONFIG_SYSFS is
> enabled (which should be true for the vast majority of test configs) that
> pwm sysfs is also enabled?

In that case there's little sense in using a separate option in the
first place. Instead we could just conditionalize on CONFIG_SYSFS.

> The IS_ENABLED method just seems very messy for a very small gain.

Note that I'm not proposing anything new here. IS_ENABLED() has become
pretty popular recently precisely because it allows all of the code to
be always compiled while at the same time throwing it away if it is
unused. This makes life a lot easier for everyone because you get
compiler errors immediately, and not only when some randconfig builder
decides to build a particular combination that nobody bothered to test.

Thierry

--CdrF4e02JqNVZeln
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRt20wAAoJEN0jrNd/PrOhRn8QAIWl88wHrWO8xN71chQO0Ypi
CKZi5YTM8XOnOnXEo6tDYmxPisw7l+lvx1GEeTtYWak+sz9gjPVpZxszTISJCfds
C7PxuEYNMj03Fgk4YqpziQ/KwhpQICGcldExnszTXG63s9mDk/TR1D6k7sqOq+ji
9M4wQQW82fA2VF39dny/tExr3LOrwXEdwXuYpW5LmFLQM7KW8xdRbbe5FA8yJNw9
dt5DLXYy00y3hpHQ8a8dq/XNKLk8/uW1fVq7l1UJ9x52Ub9ObXPvmvQV+nrLLb77
ZTK/AbzB7Rb7a6uRvGcMvkrVOiPS1TUEkalbcyc9FYqsVVlfGoc8rNvALw+hFe0O
HYalmyJmpbOj1y3SXzyibx/bg0Vyiu0mO+Uz+hqstJUWT/JKsAub1rLtJpjq3vUT
T+eGpF43pBgTwnCIhao3Ft/Umxyjlzsm/tGrcms+D0R2mSdJ954y8b1jSxvZH1qU
Iv6OLu0JaoOcmEof1IrR6WaVodtCUtJAZCxTgozuEuWDKX2U+zrNeJwMMBJLo878
17qBfHSVuYHlzDn9nZu9Gz378XNFW+kxJao5YKjnQD4kkBndX03k7Ul5vzOeddbn
WoDgFsLFM4ZBRrS/crUdZ39buJn3gOHAlJEFqrhUWjulx7C+kbSBohW3QTBostgP
aFfK3mNsq2rZwsoiixVv
=QUte
-----END PGP SIGNATURE-----

--CdrF4e02JqNVZeln--
