Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab3GQNHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 09:07:10 -0400
Received: from mout.web.de ([212.227.15.4]:55829 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767Ab3GQNHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 09:07:08 -0400
From: Martin Walch <walch.martin@web.de>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [kconfig] results of some syntactical checks
Date: Wed, 17 Jul 2013 15:07:05 +0200
Message-ID: <98150748.1bixKSE5hB@tacticalops>
User-Agent: KMail/4.10.5 (Linux/3.9.9-gentoo-gnu; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1374042658.26384.31.camel@x61.thuisdomein>
References: <7121962.G9xfZAqBSy@tacticalops> <1374016680.26384.22.camel@x61.thuisdomein> <1374042658.26384.31.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2066309.85Ng5ExefY"; micalg="pgp-sha1"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:xEKZa5lvEd1yqk2wPvTvPN2Qw2jjc0zQ+w8qSt2G38aTWmOuQUX
 SLWzswkMOMOvCmr993EQOIDRgz9IhJf7oMvCGRwKWxHvpzrpgbjsumef0K6VmYH+X5GmTJa
 ec/vbfC6r+eeiKkxvIxXP8X9xHrQ7vuQu5bHi2Y0Tui0B5nUrk6DSlDEtIpnDmIdh950qB8
 jQmW2SRQ6RHtVuRtTUOEg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart2066309.85Ng5ExefY
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

On Wednesday 17 July 2013 01:18:00 Paul Bolle wrote:
> On Wed, 2013-07-17 at 00:34 +0200, Martin Walch wrote:
> > As I am working on yet another project for analyzing LKC's input files, I
> > have some intermediate results from simple syntactical checks.
> 
> Naive question: LKC?

Sorry, I thought the abbreviation of the kconfig system "LinuxKernelConf" was 
common.

> > The results below are an excerpt from a run against tche current master.
> 
> One thing I noticed is that it is practical to be able to parse
> arbitrary tags (commits) in the git tree. So you can quickly parse a
> tree you don't actually have checked out in git. But perhaps your
> checker also does that.

Actually no, it does not. So far, a tree has to be checked out and a branch 
has to be manually selected.

> > Actually defined symbols with dangerous names: 2
> > 
> >   8260 at
> >   
> >     arch/powerpc/platforms/82xx/Kconfig:55:0
> >   
> >   8272 at
> >   
> >     arch/powerpc/platforms/82xx/Kconfig:64:0
> 
> I've wondered for some time what happens when one uses either of these
> numbers as the value for an "int" Kconfig symbol. I've never tried.

I would not expect anything bad to happen when the user manually assigns a 
value like 8260. However, it can break a range value like this:

config FOO
        int "FOO"
        range 8260 8272

On ARCH=powerpc, this will effectively make LKC print a warning "range is 
invalid" and pin down the value of FOO to 0.

Similar problems occur with default values:

config FOO
        int "FOO" if n
        default 8260

This will raise a warning "'FOO': number is invalid" and default FOO to 0.

No warning will show up if the symbol with the integer name would be actually 
an int:

config 4711
        int "4711"

config FOO
        int "FOO" if n
        default 4711

In this case, FOO will be set to whatever 4711 is set to.

All this can be avoided by quoting values, i. e.

	range "8260" "8272"

and

        default "4711"

Also, avoiding integers (and hex values) as symbol names looks like a 
reasonable idea.

> >   Symbol: PLATFORM_MICROBLAZE_AUTO at
> >   
> >     arch/microblaze/platform/Kconfig.platform:10:0
> 
> This is a default of a "choice". There used to be quite a lot of invalid
> "choice" defaults, so I stopped checking those. (But I didn't bother to
> look how my local script now handles these.) In practice these are
> treated as "no default", aren't they?

As far as I can tell, yes. Such a default line will be basically just ignored.


On Wednesday 17 July 2013 08:30:58 Paul Bolle wrote:
> > My script currently finds 28 undefined symbols. That equals this result
> > (given you have 2 false positive and 1 undefined choice default.)
> 
> So those 2 were actually correct positives.

I am glad that our results match. So they are presumably correct.
-- 

--nextPart2066309.85Ng5ExefY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iEYEABECAAYFAlHmlvkACgkQM6S4K8IXn9fbwgCfVDceQQLZ/zRhzpeJBfJjhaXb
vn4An1OR6MBLRcA3V5l6Jt9TC+SvzwJ4
=WGvF
-----END PGP SIGNATURE-----

--nextPart2066309.85Ng5ExefY--

