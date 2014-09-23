Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbaIWUnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 16:43:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:25053 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756803AbaIWUnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 16:43:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="asc'?scan'208";a="390574730"
From: "Rustad, Mark D" <mark.d.rustad@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "sparse@chrisli.org" <sparse@chrisli.org>,
        "linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] Silence even more W=2 warnings
Thread-Topic: [PATCH 0/7] Silence even more W=2 warnings
Thread-Index: AQHP1B6ZqT8VjyQkzkipcFe03W/rTpwNwlkAgAAZ2ACAABpfgIAABS8AgAAGSQCAAAZEgIAAA7mAgAADVoCAAAa4AIAAFZkAgACwXoCAAJd/AIAAFoIAgAAhEAA=
Date: Tue, 23 Sep 2014 20:43:17 +0000
Message-ID: <E460C326-08DC-4E38-8E3B-9050F9E03A17@intel.com>
References: <20140922184049.GB4709@pd.tnic>
 <3199350A-89CE-4BE7-8FE4-CA8CE4F87622@intel.com>
 <20140922192152.GD4709@pd.tnic>
 <1411415057.2513.8.camel@jtkirshe-mobl.jf.intel.com>
 <20140922195737.GE4709@pd.tnic>
 <1411416573.2513.19.camel@jtkirshe-mobl.jf.intel.com>
 <20140922203336.GF4709@pd.tnic>
 <A05C31E6-7AD2-482A-B590-A5ED57D028B3@intel.com>
 <20140923082209.GB22072@pd.tnic>
 <029E2CFB-C001-4E16-B1F7-A3FB193E3138@intel.com>
 <20140923184456.GA16467@pd.tnic>
In-Reply-To: <20140923184456.GA16467@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [134.134.176.72]
Content-Type: multipart/signed;
	boundary="Apple-Mail=_46E1991D-F7B7-4740-BCE9-1F7CD61C77AB";
	protocol="application/pgp-signature"; micalg=pgp-sha1
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Apple-Mail=_46E1991D-F7B7-4740-BCE9-1F7CD61C77AB
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Sep 23, 2014, at 11:44 AM, Borislav Petkov <bp@alien8.de> wrote:

> On Tue, Sep 23, 2014 at 05:24:22PM +0000, Rustad, Mark D wrote:
>> Yes, but I think there are a few cases where it could be helpful. =
When
>> there is something exceptional that will throw a warning. In one of =
the
>> patches that Jeff sent, I used the DIAG_CLANG_IGNORE macro to =
suppress
>> the warning that is thrown for every entry of the syscall table when
>> compiled with clang. The code is right and doing exactly what is =
wanted,
>> so note the exception and make it shut up.
>=20
> So we're doing some dancing around solely to shut up the compiler? =
Even
> if the code is correct?!? Sorry, this is just ass backwards.

Well, please consider the specifics. The entire syscall table is =
initialized
with a constant pattern to be sure that every item is initialized. Then =
each
syscall is initialized into its proper place. The compiler is =
complaining that
entries are being initialized twice.

Most of the time, that is not done, and so it may catch a patch foulup =
or
something. In this particular case, it is normal and intended. There is
nothing wrong, so there is no reason to throw a warning for every single
entry in the table. Which is what happens with clang today.

So the code is correct, but in general the warning can reveal certain =
issues.
Just not in this particular usage. This happens to be a warning specific =
to
clang at the moment.

> If it were me, I'd say even one is too much. Because the very thing
> of adding code just to shut up the compiler which generates otherwise
> correct code is simply very very wrong in my book.
>=20
> Bear in mind that even if initially you have a low number of macro
> invocations, that number will grow because people will start using it =
in
> other places too. And all of a sudden, the thing has spread like weed
> and there's no removing it anymore. So we better not start in the =
first
> place.

That is why it would be more than reasonable for checkpatch to warn on =
the
macro introductions. It is certainly a more significant thing than a
line > 80 characters.

> Again, we should take compiler warnings with a grain of salt and judge
> them only by the quality of the generated code. IMO.

I think more than the nature of the executable code matters. The =
namespace
issues revealed by -Wshadow can certainly create nasty surprises over =
time.
But we can't get that value from them when they are lost in an ocean of
warnings that are always there and are not the source of any trouble.

The problem is that when so many warnings are generated, particularly by
include files, even useful warnings will not be seen. Specifically
silencing ones that are deemed to be "ok" will help in seeing ones that
are not. The silencing has the greatest effect in the include files,
since there is such a multiplier effect.

Warnings that no one looks at, or bother to generate at all, have
absolutely no value. Even a silenced warning continues to wear its
shame attribute (macro). Hmm. Maybe instead of DIAG_* they should be
named SHAME_*.

Most of the time, it is new instances of warnings that are most likely =
to
reveal a problem. Hiding them in a flood of "normal" warnings prevents
them from ever being seen. And that is a shame.

--=20
Mark Rustad, Networking Division, Intel Corporation


--Apple-Mail=_46E1991D-F7B7-4740-BCE9-1F7CD61C77AB
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJUIdtkAAoJEDwO/+eO4+5ub5sP/1uRzxeag4QnGf7/boR7mBJw
vdEVRLuEIyK7Vy8khnfBIsqcgp8mL+0Q/QoNJXz9nucv6xb99Xrq/1qAfj4kxW8H
SnL7M2HE6SevHs+/R5+G+fdVgv5B6FmUrzzHpGc9betj214Mk33PbRxJTDN16zx8
KndDaw8cndtkP6YllJyNZqiYAmu/YsCNl/phXEBDtntZVJPBVIHTOsGrEeKuoqIn
MkO6HUHWazfi2sDJVJ7yDHHogQS6JbqPU8GaXmK1WZcx6i4va2JlnNTvHKHJGVSx
6GMpd6fuYW0M+/LlfenLiSS82NbGSH3L/jwsj72IO/ZKuQS/ZG/yVx9IKatx/IzN
Cmf8uyJbZ4X2NO3f+9tx0mlJTEeiJ0WP2HxqRTAQDwjtnzq8iwDynO/8SVGa+RM6
PK5OOY9JFWR0bxsceIQqifuI04qvpe5Dd2B6YOPNkkmCvXV+Vwy5KyiY1wmSXCLg
jOWVr8uRxWNDrfpOeoES9CyfrUgxw8R9RfvQLoXo7sVJ3UGyhvRgT35EWFDF+Pw1
uK7Hph1wRk6HuoVZYBkd2y1usImB5J6IMaSWNRiaCyzU542lvhyzOqA5Vc4hojCH
9BrQnK5Ha2A4apjlIWnKfr1S7WCCdFoeyWHMTkr9nDbX7Ema0PsdW6VfNIjqz7r/
wisTaLEi+eKejgmnJldy
=FAdM
-----END PGP SIGNATURE-----

--Apple-Mail=_46E1991D-F7B7-4740-BCE9-1F7CD61C77AB--
