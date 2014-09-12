Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbaILXnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 19:43:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:52584 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbaILXny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 19:43:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,515,1406617200"; 
   d="asc'?scan'208";a="602268516"
From: "Rustad, Mark D" <mark.d.rustad@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Michal Nazarewicz <mina86@mina86.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hagen Paul Pfeifer <hagen@jauu.net>,
        "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] kernel.h: use __COUNTER__ in min and max macros to
 avoid -Wshadow warnings
Thread-Topic: [PATCH 2/2] kernel.h: use __COUNTER__ in min and max macros to
 avoid -Wshadow warnings
Thread-Index: AQHPzgjr4XQh5i+Ls0OYfXxAxZdst5v+jk6AgAARxwA=
Date: Fri, 12 Sep 2014 23:43:51 +0000
Message-ID: <19E5FFA3-9630-4FD7-8E8A-2754D14AFEC2@intel.com>
References: <1410471576-12053-1-git-send-email-mina86@mina86.com>
 <1410471576-12053-2-git-send-email-mina86@mina86.com>
 <20140912154013.47dad90e7519146c6da115e5@linux-foundation.org>
In-Reply-To: <20140912154013.47dad90e7519146c6da115e5@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [134.134.176.172]
Content-Type: multipart/signed;
	boundary="Apple-Mail=_EF550AB8-022E-452B-8461-3B6C62B588F0";
	protocol="application/pgp-signature"; micalg=pgp-sha1
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Apple-Mail=_EF550AB8-022E-452B-8461-3B6C62B588F0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Sep 12, 2014, at 3:40 PM, Andrew Morton <akpm@linux-foundation.org> =
wrote:

> On Thu, 11 Sep 2014 23:39:36 +0200 Michal Nazarewicz =
<mina86@mina86.com> wrote:
>=20
>> Because min and max macros use the same variable names no matter
>> how many times they are called (or how deep the nesting of their
>> calls), each time min or max calls are nested, the same variables
>> are declared.  This is especially noisy after min3 and max3 have
>> been changed to nest min/max calls.
>>=20
>> Using __COUNTER__ solves the problem since each variable will get
>> a unique number aadded to it.  The code will still work even if
>> the compiler does not support __COUNTER__, but then the protection
>> from shadow warning won't work.
>>=20
>> The same applies to min_t and max_t macros.
>>=20
>> ...
>>=20
>> --- a/include/linux/kernel.h
>> +++ b/include/linux/kernel.h
>> @@ -695,15 +695,27 @@ static inline void ftrace_dump(enum =
ftrace_dump_mode oops_dump_mode) { }
>> #endif /* CONFIG_TRACING */
>>=20
>> /*
>> + * Preprocessor magic generating unique identifiers to avoid =
-Wshadow warnings
>> + * used by min, max, min_t and max_t macros.  cnt is __COUNTER__, op =
is the
>> + * comparison operator; tx (ty) is type of the first (second) =
argument,
>> + * xx (yy) is name of a temporary variable to hold the first =
(second) argument,
>> + * and x (y) is the first (second) argument.
>> + */
>> +#define _min_max_var(cnt, base) _mm_ ## cnt ## base
>> +#define _min_max__(op, tx, xx, x, ty, yy, y) ({		\
>> +	tx xx =3D (x);					\
>> +	ty yy =3D (y);					\
>> +	(void) (&xx =3D=3D &yy);				\
>> +	xx op yy ? xx : yy; })
>> +#define _min_max_(cnt, op, tx, x, ty, y)		\
>> +	_min_max__(op, tx, _min_max_var(cnt, a), x, ty, =
_min_max_var(cnt, b), y)
>> +#define _min_max(...) _min_max_(__COUNTER__, __VA_ARGS__)
>=20
> The fact that __COUNTER__ is used in compiler-gcc4.h but not in
> compiler-gcc3.h makes me suspicious about its availability?

AFAICT not having __COUNTER__ simply means that the shadow warnings will =
appear in W=3D2 builds,
so it is no worse off than before. That is, __COUNTER__ will simply =
expand as __COUNTER__. No
error will result from this kind of use.

> I do think that [1/2] made the code significantly worse-looking and
> this one is getting crazy.

It is a little crazy, but I find that I would feel differently about it =
if I had come up with
the idea. Actually, I am really impressed with the discoveries that =
arose from my original patch,
including recognizing that the min3/max3 generated worse code than =
nested macro calls. I had
never considered that possibility.

> How useful is W=3D2 anyway?  Has anyone found
> a bug using it?

Yes. But it is really hard to find anything useful when my normal kernel =
build throws 125000
warnings - for completely expected things - in W=3D2 builds. We do =
routinely build our drivers
with W=3D12, but we have a special hack to ignore the large number of =
warnings that the kernel
include files generate, while still getting warnings from our driver's =
code and include files.
They do sometimes catch problems.

> The number of warnings in default builds is already way
> too high :(

Do you mean the number of warnings enabled, or the number of warning =
messages being generated?
I am a fan of enabling lots of warnings, but it is not effective if =
doing so emits thousands of
messages. Back in the 2.4 kernel era, there was a time when I maintained =
a MIPS-based kernel
that built completely cleanly with way more warnings enabled than W=3D12 =
uses today. It took work
to get to that state, but we were able to maintain that for several =
kernel versions for our particular environment. These days, the kernel =
as a whole is in a much better state than we
started with for that old 2.4 kernel.

I'll say that there aren't really that many warnings that are the result =
of nested min/max
macros. There are *much* heavier hitters out there. For example "nested =
externs" account for
tens of thousands of warnings in W=3D2 builds. Such noise makes using =
W=3D2 kind of ridiculous
on the whole kernel. I'd like it to not be so ridiculous eventually. =
Some 60 patches got my
build down under 1400 W=3D2 warnings. Then I realized that I had pushed =
that rock too far up the
hill without getting feedback on what I was doing.

I have been working on patches that add macros to allow disabling =
certain warnings in select
pieces of code. In that way the warning is silenced, but the macro =
remains as a sign to the
reader that there is something special going on. Unfortunately, those =
macros fail miserably
in the expansion of any macro called in the parameter of other macros, =
as the compile time
asserts sometimes are. And the compile time asserts make use of a nested =
extern by design.

It is enough to make me want to suggest dropping the nested externs =
warning from W=3D2, but
recognize that every nested extern that actually calls a function is a =
redundant prototype
declaration that could get to be inconsistent with the function it =
calls. They have disentangled
the include files some, but added a bit of risk and maintenance burden.

This whole area is full of judgement calls, so people will disagree. =
Hopefully any debate will
be worthwhile. My first reaction to the patch above was that it was kind =
of wild, but it does
well and truly fix the problem and does no harm on compilers that don't =
have __COUNTER__, so
I am ok with it. Yes, I have compiled it.

--=20
Mark Rustad, Networking Division, Intel Corporation


--Apple-Mail=_EF550AB8-022E-452B-8461-3B6C62B588F0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJUE4U3AAoJEDwO/+eO4+5uGr0P/2axQtwqdOnLxs01j62t4XBr
5aMNfywA2joU4OXBNYVoiKbIZFbWFxyIxEych5z+KeClkG7UeIs76FcyVPjvvOMo
KaICh0yhP1L47bgrxarEIxxGhe2LMmQw0rMvOS0FChHtnjnBaquEMBLdjhhGs3mA
djUyV/8UThoVTECR4Bk+u2Y2N52oIO7ZwqrfmRAcOhAPUQSgYA0iUSMXMbFVkSZt
svoXJhV47qmMGhGTaKhwUJSGeASKFek6ct/OAJplIF80yIwtjMqcY67ubBy7OTW/
v4WsCSQe9ZErPXXUugX/dk1fNxEW8Oczb2iRXAzSFLNFOqYn3eXIgxOjoOL1CjGd
OtgrATA6WEUbRIhtpv82z0E1CnRUCEesqvzLZ84IvEVExFWPXQsETWW+R3yNTqPX
5cJK1hVAmkyEh4hzKM9L3mkftSAGIzCjSyDfTU+7KVSAs0u7kM3XHn2wn8w38TRq
+wC0HuhH2Ni68JsYRsmqHRC9hQSGuB9ZB+5RI5Dka9QZk7Mjvtt/MC6W7/tnkx3V
WSvFMJobkxKp7rh5lopdcMwRKHkcv6yf+pS80ahVGhvWnwrD3FaXSPfuaqVWWXSa
2T2VSW/P6FqD8gW7BXpVrmaYjmiGSo6r1YlRrOhGFcNYJAM3kErZtcZ3mx1B9Kkz
uQB0ZAbEsrSO9QmU80gw
=GHAf
-----END PGP SIGNATURE-----

--Apple-Mail=_EF550AB8-022E-452B-8461-3B6C62B588F0--
