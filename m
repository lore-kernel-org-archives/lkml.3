Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab3AZJtj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 04:49:39 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36514 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753084Ab3AZJtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 04:49:36 -0500
Date: Sat, 26 Jan 2013 17:49:29 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 11/19] regmap: avoid undefined return from
 regmap_read_debugfs
Message-ID: <20130126094855.GI30594@opensource.wolfsonmicro.com>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
 <1359123276-15833-12-git-send-email-arnd@arndb.de>
 <20130126044219.GA10580@opensource.wolfsonmicro.com>
 <201301260917.28028.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="I/5syFLg1Ed7r+1G"
Content-Disposition: inline
In-Reply-To: <201301260917.28028.arnd@arndb.de>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--I/5syFLg1Ed7r+1G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 26, 2013 at 09:17:27AM +0000, Arnd Bergmann wrote:
> On Saturday 26 January 2013, Mark Brown wrote:
> > On Fri, Jan 25, 2013 at 02:14:28PM +0000, Arnd Bergmann wrote:

> > > Gcc warns about the case where regmap_read_debugfs tries

> > Are you sure about that function name?

> Yes, regmap_read_debugfs uses the return value from
> regmap_debugfs_get_dump_start, for which gcc found
> a path that returns the uninitialized value.

> > > to walk an empty map->debugfs_off_cache list, which results
> > > in uninitialized variable getting returned.

This is the bit that makes me think you're talking about the wrong
function - regmap_debugfs_read() never looks at the off_cache list.

> > > Setting this variable to 0 first avoids the warning and
> > > the potentially undefined value.

> > This probably won't apply against current code as there's already a
> > better fix there, in general just picking a value to initialise masks
> > errors.

> I agree on the general rule not to do this, and I'm trying to avoid it
> in the cases where I can find a better fix, but here I could not
> (mostly because I could not figure out what this code actually
> does. Thanks for taking a look.

> Which code is the current version? Is your fix headed for 3.8 inclusion?

It's all in mainline already.

> I still see the warning in 3.8-rc5 as well as yesterday's linux-next,
> with gcc-4.6, 4.7 and 4.8-pre.

Oh, ffs.  This is a false positive from the compiler - there is no case
where it can actually do this as we will bail out before the walk if the
list is empty so we'll always take at least one trip through our
list_for_each_entry() and either return or set ret.  It should be smart
enough to work out that the list_empty() means list_for_each_entry()
will iterate over at least one entry or more conservative in what it
warns about.

In any case, your change will break things - this is an example of why
just picking a random value to assign is unhelpful.  You'd need to
return base to avoid confusing the callers but even then doing it at the
start of the function is overkill, it excludes a bunch of paths.  I
guess we can work around it by putting a redundant assignment of pos and
ret before the loop :/

--I/5syFLg1Ed7r+1G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRA6abAAoJELSic+t+oim959kP/RQjJmHt0XAjuX5HR1KNHE/M
tFOPxQM/1tCsE/HXWdqCYi6vS7F7SKLS7b44Dc37v+b0o1NMQFUrToGGV4AZvR+x
YIrWPeCmkYebtB7uJBQtXR87u7G+5cR7EvrmBv7GToso5yMWoK0IN2eticTTDqtl
52HZYMJmIC9H6b8p7rKTLVNrgN9AXYP5Ej4vd1+F9v3Pg5YKns7zoiDiW95ZHdaF
CiW+/wKJ2ryCSYOTO1DDN1158Cb0HZWis9H7s8L9S+6pd9JxoHeAM6TxJkVV+FTX
2R7yv5NPKz1jYuJkEbQYRMj8DOVPpY6OAPeB8G/QF3ig+6Xz7y9WjDohrs1dONS1
c8oINsJNv1EqsYmehRkJ6l+oCn6tSeSm99vinV9KxTCDeo1KwJha4Zzl22WcRghU
+oBv3y1dOvF03rYPV6CorsWFo8HLuH+OPJGZ3Z+YQFItPEeQedvpBbm43MPxai4T
cGkrGjWfzseEdXPES8QT8ehC8dhWEIWixl4EYP06ay8UvYpilUWOylgwuzmBGGd0
FBtz2aHOyUFQ6EZ4iwniqxYvndGw7y3OzEjm6Q2+BOkkQ73qkoLzDH3Rh6a8b0HA
KSFdaGZ1Nqu8YFfGNltYPp7qcRnfrDUlgoSlLhf0uTatihwsNk+ujtGuX15/xhDU
vkqoGwpZVl39wFLrd4b/
=b39x
-----END PGP SIGNATURE-----

--I/5syFLg1Ed7r+1G--
