Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbaILXsL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 19:48:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:41323 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbaILXsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 19:48:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,515,1406617200"; 
   d="asc'?scan'208";a="572549099"
From: "Rustad, Mark D" <mark.d.rustad@intel.com>
To: Michal Nazarewicz <mina86@mina86.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hagen Paul Pfeifer <hagen@jauu.net>,
        "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] kernel.h: use __COUNTER__ in min and max macros to
 avoid -Wshadow warnings
Thread-Topic: [PATCH 2/2] kernel.h: use __COUNTER__ in min and max macros to
 avoid -Wshadow warnings
Thread-Index: AQHPzgjr4XQh5i+Ls0OYfXxAxZdst5v+jk6AgAAQDgCAAALrgA==
Date: Fri, 12 Sep 2014 23:48:07 +0000
Message-ID: <77CB9570-C6D7-4111-89EF-5C9698959898@intel.com>
References: <1410471576-12053-1-git-send-email-mina86@mina86.com>
 <1410471576-12053-2-git-send-email-mina86@mina86.com>
 <20140912154013.47dad90e7519146c6da115e5@linux-foundation.org>
 <xa1tppf0xvej.fsf@mina86.com>
In-Reply-To: <xa1tppf0xvej.fsf@mina86.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [134.134.176.172]
Content-Type: multipart/signed;
	boundary="Apple-Mail=_3341F07E-3A32-4991-B15F-7BF612FAE952";
	protocol="application/pgp-signature"; micalg=pgp-sha1
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Apple-Mail=_3341F07E-3A32-4991-B15F-7BF612FAE952
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Michal,

On Sep 12, 2014, at 4:37 PM, Michal Nazarewicz <mina86@mina86.com> =
wrote:

> On Fri, Sep 12 2014, Andrew Morton <akpm@linux-foundation.org> wrote:
>> On Thu, 11 Sep 2014 23:39:36 +0200 Michal Nazarewicz =
<mina86@mina86.com> wrote:
>>=20
>>> Because min and max macros use the same variable names no matter
>>> how many times they are called (or how deep the nesting of their
>>> calls), each time min or max calls are nested, the same variables
>>> are declared.  This is especially noisy after min3 and max3 have
>>> been changed to nest min/max calls.
>>>=20
>>> Using __COUNTER__ solves the problem since each variable will get
>>> a unique number aadded to it.  The code will still work even if
>>> the compiler does not support __COUNTER__, but then the protection
>>> from shadow warning won't work.
>>>=20
>>> The same applies to min_t and max_t macros.
>>>=20
>>> ...
>>>=20
>>> --- a/include/linux/kernel.h
>>> +++ b/include/linux/kernel.h
>>> @@ -695,15 +695,27 @@ static inline void ftrace_dump(enum =
ftrace_dump_mode oops_dump_mode) { }
>>> #endif /* CONFIG_TRACING */
>>>=20
>>> /*
>>> + * Preprocessor magic generating unique identifiers to avoid =
-Wshadow warnings
>>> + * used by min, max, min_t and max_t macros.  cnt is __COUNTER__, =
op is the
>>> + * comparison operator; tx (ty) is type of the first (second) =
argument,
>>> + * xx (yy) is name of a temporary variable to hold the first =
(second) argument,
>>> + * and x (y) is the first (second) argument.
>>> + */
>>> +#define _min_max_var(cnt, base) _mm_ ## cnt ## base
>>> +#define _min_max__(op, tx, xx, x, ty, yy, y) ({		\
>>> +	tx xx =3D (x);					\
>>> +	ty yy =3D (y);					\
>>> +	(void) (&xx =3D=3D &yy);				\
>>> +	xx op yy ? xx : yy; })
>>> +#define _min_max_(cnt, op, tx, x, ty, y)		\
>>> +	_min_max__(op, tx, _min_max_var(cnt, a), x, ty, =
_min_max_var(cnt, b), y)
>>> +#define _min_max(...) _min_max_(__COUNTER__, __VA_ARGS__)
>>=20
>> The fact that __COUNTER__ is used in compiler-gcc4.h but not in
>> compiler-gcc3.h makes me suspicious about its availability?
>=20
> http://gcc.gnu.org/ml/gcc-patches/2007-05/msg01579.html so looks like =
it
> has 7 years.  But as the commit message says, the code will still =
work,
> even w/o working __COUNTER__.
>=20
>> I do think that [1/2] made the code significantly worse-looking
>=20
> Oh?  I actually thought [1/2] makes it nicer by having a single place
> where the min/max logic is implemented.

It does have that going for it.

>> and this one is getting crazy.  How useful is W=3D2 anyway?
>=20
> I actually do agree with that.  I didn't have high hopes about getting
> this patch accepted, but wanted to send it out to show that it can be
> done, if it's really deemed useful.

Well, I learned something from it. Thank you for teaching this old dog a =
new trick.

>> Has anyone found a bug using it?  The number of warnings in default
>> builds is already way too high :(

--=20
Mark Rustad, Networking Division, Intel Corporation


--Apple-Mail=_3341F07E-3A32-4991-B15F-7BF612FAE952
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJUE4Y3AAoJEDwO/+eO4+5uRzcP/RQO+FGAzikr3RscCZmTrvc8
kcsYQkDcpUUlx8Ba3N8pln+OwohG8edqx5kS7/tRkHovzmZ3PHDh5J/wFAB5PsKh
Em3MIoIwN1TsrAXV+v9tF39egGyim/ZzpZfUwt2RIUAZjKSITDIu4+VqNlnUEHC4
a2+GSc+J2XgWTHqNYHWo0zyDgp0LcWsvA6crMCuVxqiMbDq9JXBhf8cFstdEy2gd
Zx4/b1Z2+WCBNEZ3WDxzQE+nXJkrUq7TMFlmKe/4kLiYVehUyOVqScXUhIWVQfft
Lx5iC6vuZ00MOn9bjddxT7KIiiKqKr7IhtmXpNR5bUdg2jgUZPCwRyvQPsuh11HR
i0n1fCuR7/8MOEhcuu76R/VCIkP0bXmd2kHaEWnDagopmJQQy61oXpV+93Ft4+Pd
VteqRNj1GYjvDbDvA/W9nz60kxgVxK9QzEAhOn1kZH32NHmutByFfkaz2QBULoSs
F6DrbAi9REMOE6xaD/XBX1A4Vd2QeG+gcI+Nq6mguQBiGQJ5N/Ok01+IvOGl/aZ6
HQNxHk44ufM7b0fVBD8BLhVlnOUvZ2wlpO/hYewE42NWI65kbFHcSO0AUNR2ieK+
Ii5uKOPwqcFXJgqz4A5ycp1AwptsOu/u/DCc96xPjYbsb8s3wQZA8XXLbcFURpsd
Oeyn6SZrzUxtSZxSVWvD
=dAlh
-----END PGP SIGNATURE-----

--Apple-Mail=_3341F07E-3A32-4991-B15F-7BF612FAE952--
