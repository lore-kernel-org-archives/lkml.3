Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbaHPDgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 23:36:13 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:50697 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaHPDgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 23:36:12 -0400
Content-Type: multipart/signed; boundary="Apple-Mail=_15FFDA2A-7FD6-4C26-911C-CB3E46375519"; protocol="application/pgp-signature"; micalg=pgp-sha1
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: Overriding -Werror
From: Mark D Rustad <mrustad@gmail.com>
In-Reply-To: <20140815193144.GG18411@ld-irv-0074>
Date: Fri, 15 Aug 2014 20:36:07 -0700
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
Message-Id: <46D9023C-636A-4A09-88DC-9061567B1BAC@gmail.com>
References: <20140814222119.GD18411@ld-irv-0074> <CAL3LdT7-Ai7Dv93vrDP1o2BSVrmFAyTN=UAwE8n5+PVjpN1h0Q@mail.gmail.com> <20140815193144.GG18411@ld-irv-0074>
To: Brian Norris <computersforpeace@gmail.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail=_15FFDA2A-7FD6-4C26-911C-CB3E46375519
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Brian,

On Aug 15, 2014, at 12:33 PM, Brian Norris <computersforpeace@gmail.com> =
wrote:

> Hi,
>=20
> On Fri, Aug 15, 2014 at 02:30:49AM -0700, Jeff Kirsher wrote:
>> Funny that you bring this up because I have ~60 patches in my queue =
to
>> resolve several thousand of these warnings.  Half of the patches
>> actually resolve warnings that can be resolved and the other half
>> implement compiler diagnostic control macros to help silence =
warnings.
>> All these were the work of a co-worker Mark Rustad, below is the =
patch
>> he put together to implement the compiler diagnostic control macros.
>=20
> While fixing warnings is usually a good thing (at least when done =
right;
> there are plenty of ways to fight with the compiler over silly things,
> but that's another discussion),

I have said at some presentations on the subject that resolving warnings =
is not something you want an intern to do.

> I think that my issue is still
> orthogonal to the one you're addressing. In my estimation, it is
> impossible to guarantee that the entire kernel (including drivers) =
will
> build without any warnings, across all levels of warning verbosity.
> Thus, even with a valiant effort to fix or annotate all warnings, we
> still won't get to the point where I can build 'make ARCH=3Dmips W=3D1',=
 if
> -Werror is active.

Actually, some years ago, I got a MIPS Linux kernel to compile clean =
with even more warnings than W=3D12 provides. It can be done, but it =
certainly is not a state that is required and cannot be maintained =
across all configurations, architectures and compiler versions. This is =
the real world.

> Besides, when testing *new* code, it's even more likely to have new
> warnings, and I'd like to see as many as possible, without -Werror
> getting in the way.

I have to say that I rather like -Werror. One thing that not a lot of =
people are aware of is that you can selectively allow some warnings. =
-Wno-error=3Dshadow would allow shadow warnings to be reported without =
being treated as errors.

> So I still think -Werror is fundamentally wrong in some cases, and I
> would like to pursue some approach like in my original post.
>=20
> BTW, for a little more context: I realize the output of 'make W=3D[123]'=

> may not be very useful on its own, sometimes, but it's actually pretty
> useful to quickly catch potential issues in new code, by diff'ing the
> warnings in the before/after build logs. In this case, it's not =
helpful
> at all if the first build "fails" due to dubious warnings. I'm doing
> this in the context of Aiaiai [1]. Right now, I have to keep around a
> few local patches to remove -Werror from arch/{mips,sh}.

The problem is that when a kernel build throws over 125,000 warnings, it =
just becomes completely useless. That was what kind of set me off. I did =
wind up pushing this rock further up the hill than I really meant to. =
Still, I got the build under 1,400 warnings, and I now know how to =
address most of them in a systematic way.

>> commit 7b9aace02b2405f0714bc08c424b72e6962f1c2e
>> Author: Mark Rustad <mark.d.rustad@intel.com>
>> Date:   Fri Aug 15 01:43:44 2014 -0700
>>=20
>>    compiler: Add diagnostic control macros
>>=20
>>    Add macros to control diagnostic messages where needed. These
>>    are used to silence warning messages that are expected, normal
>>    and do not indicate any sort of problem. Reducing the stream
>>    of messages in this way helps possible problems to stand out.
>>=20
>>    The macros provided are:
>>        DIAG_PUSH() - to save diagnostic settings
>>        DIAG_POP() - to restore diagnostic settings
>>        DIAG_IGNORE(option) - to ignore a particular warning
>>        DIAG_GCC_IGNORE(option) - DIAG_IGNORE for gcc only
>>        DIAG_CLANG_IGNORE(option) - DIAG_IGNORE for clang only
>>=20
>>    Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
>>=20
>> diff --git a/include/linux/compiler-clang.h =
b/include/linux/compiler-clang.h
>> index d1e49d5..039b112 100644
>> --- a/include/linux/compiler-clang.h
>> +++ b/include/linux/compiler-clang.h
>> @@ -10,3 +10,29 @@
>> #undef uninitialized_var
>> #define uninitialized_var(x) x =3D *(&(x))
>> #endif
>> +
>> +/*
>> + * Provide macros to manipulate diagnostic messages when possible.
>> + * DIAG_PUSH pushes the diagnostic settings
>> + * DIAG_POP pops the diagnostic settings
>> + * DIAG_IGNORE(x) changes the given diagnostic setting to ignore
>> + *
>> + * Example:
>> + *    DIAG_PUSH DIAG_IGNORE(aggregate-return)
>> + *    struct timespec ns_to_timespec(const s64 nsec)
>> + *    {
>> + *        ...
>> + *    }
>> + *    DIAG_POP
>> + *
>> + * Will prevent the warning on compilation of the function. Other
>> + * steps are necessary to do the same thing for the call sites.
>> + */
>=20
> While I do not want to disparage your/Mark's work here, my first =
thought
> about this kind of annotation is that it seems to be a pretty big =
burden
> to have to annotate all code with these sorts of things.

I wouldn't suggest annotating everything. However note that the =
annotations can serve as a notice that something has been analyzed and =
deemed ok. That can be useful as long as that is really true. I wouldn't =
take new code from a new developer that included such annotations.

> While it could
> help for some core parts of the kernel that can be closely scrutinized
> and defended against false/useless warnings, from my perspective it
> seems like people are bound to get it wrong when it comes to the long
> tail of scattered device drivers.

Yes, it is VERY valuable for addressing warnings thrown by core kernel =
includes. Just a few static inlines with warnings produced about 50,000 =
of those 125,000 warnings.

> But I'm not really the right voice for that topic. Feel free to send
> your work and see what the rest of the community thinks.

I look forward to the discussion. I have no illusion about all my =
patches going in. In fact there are instances where I used the =
diagnostic control macros to silence a bunch of warnings because it made =
for a much smaller patch - a patch to resolve them would have had to =
replace an entire table, so I guess I hope to get a request to do that. =
The exchanges I have had with the few patches that have been sent thus =
far have been productive, so I hope for more like that.

I do think that the diagnostic control macros serve a useful purpose if =
used well. I agree that they can be abused, like anything else, but some =
rules about their use should help. Maybe checkpatch should warn on =
patches that add them...

--=20
Mark Rustad, MRustad@gmail.com


--Apple-Mail=_15FFDA2A-7FD6-4C26-911C-CB3E46375519
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJT7tGnAAoJEDwO/+eO4+5uOfUP/1Q1gYB2OjRXywkQRfZSGcdg
sHEeT/ODCTD/GcnUQGjNkgpZ0YJk9kXlfCjl5qoVU9Kpe70sIK0MM/1ns/icdTWL
CCZt4f54nZv2cKSL3WGrHBt6DycpiATymLs4ziDw3at9EXJeQ6+zsZvCLAn9vb5o
HzCwFR5aF0IbAQJ9fffCMJdjKlMXVBfnkwb2giMRTd+doxTnMUiJw5J4g29RUunx
oOU2ByZ1RWaMNBC5D+bd7OeVogLE3Dsp5MLxv3/8d4R41FvxT/fw+QGHZBmscu4E
P23bgl6Nt62XVV8C4193S4KZjebbm63ReQSkA+5wxw2uJ9NahbcpjkKhNnljDDhc
7/2ZjO78I2MhMLQlVxNzYPL8Mqa9FhbxWJnTHKwMKE7c/2O8UqLfkha0FxQ7k7rT
k4G1/orlYjcYqLqhy9lf9P9Hik1+TgWmMdgDEbo58f62xbOK4mTk0T1THXCRO3Nf
ZMCvTq2FzkXnmMjewzl0Dl4Tu/2QimGJEGU91HoVsFqmNRFzofw1xwP7EH4y1o5C
OnKLWQw6bqsniaKNusLSGBWAdxc6sfw52gA0AoDE8cs+Cprd+7ecZjSiHz+WSFiv
c4hy2qSoPT3jsZ5mF3D7b5u02G5EDOHUeujYtDldYI8rZFwCdhiPV9y1hucmSBnN
iY4B5gUqoVj4SBX+BNqW
=X+nn
-----END PGP SIGNATURE-----

--Apple-Mail=_15FFDA2A-7FD6-4C26-911C-CB3E46375519--
