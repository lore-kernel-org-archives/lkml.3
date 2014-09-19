Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458AbaISV00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 17:26:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:35287 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932234AbaISV0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 17:26:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,557,1406617200"; 
   d="asc'?scan'208";a="605592121"
From: "Rustad, Mark D" <mark.d.rustad@intel.com>
To: Josh Triplett <josh@joshtriplett.org>
CC: Oleg Nesterov <oleg@redhat.com>, Richard Weinberger <richard@nod.at>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "sparse@chrisli.org" <sparse@chrisli.org>,
        "linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Brian Norris <computersforpeace@gmail.com>
Subject: Re: [PATCH 5/7] signal: Silence nested-externs warnings
Thread-Topic: [PATCH 5/7] signal: Silence nested-externs warnings
Thread-Index: AQHP1B6dSPV3r4SNyUy3CpkS8cenGpwJC+SAgAAAbACAAAB1AIAAHFwAgABDUwCAAAFZgA==
Date: Fri, 19 Sep 2014 21:26:20 +0000
Message-ID: <DCC876B0-D2AC-44F0-A774-D8DFA6F17905@intel.com>
References: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
 <1411140580-20909-6-git-send-email-jeffrey.t.kirsher@intel.com>
 <541C4D57.9050507@nod.at> <1411141042.2513.3.camel@jtkirshe-mobl>
 <541C4E14.9010000@nod.at> <20140919172030.GA22293@redhat.com>
 <20140919212128.GP26432@jtriplet-mobl1>
In-Reply-To: <20140919212128.GP26432@jtriplet-mobl1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [134.134.176.66]
Content-Type: multipart/signed;
	boundary="Apple-Mail=_39C6AC14-3000-424C-B0F0-6CE1F08FE247";
	protocol="application/pgp-signature"; micalg=pgp-sha1
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Apple-Mail=_39C6AC14-3000-424C-B0F0-6CE1F08FE247
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Sep 19, 2014, at 2:21 PM, Josh Triplett <josh@joshtriplett.org> =
wrote:

> On Fri, Sep 19, 2014 at 07:20:30PM +0200, Oleg Nesterov wrote:
>> On 09/19, Richard Weinberger wrote:
>>>=20
>>> Am 19.09.2014 17:37, schrieb Jeff Kirsher:
>>>>=20
>>>> See patch 1 of the series.
>>>=20
>>> I was not CC'ed...
>>=20
>> Me too, and thus I don't understand this patch.
>>=20
>> But I have to admit it looks a bit ugly to me anyway.
>> Can't we simply kill _NSIG_WORDS_is_unsupported_size ?
>=20
> This looks quite preferable.  Can you post that with a commit message
> and signoff?  Also, the indentation on the second of the three =
BUILD_BUG
> calls has some spaces in it, which it shouldn't.  With those fixed:
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

I haven't tried this patch myself yet, but assuming that it works, it is =
a far better way to go.

>> diff --git a/include/linux/signal.h b/include/linux/signal.h
>> index 750196f..679c9b4 100644
>> --- a/include/linux/signal.h
>> +++ b/include/linux/signal.h
>> @@ -67,7 +67,6 @@ static inline int sigismember(sigset_t *set, int =
_sig)
>>=20
>> static inline int sigisemptyset(sigset_t *set)
>> {
>> -	extern void _NSIG_WORDS_is_unsupported_size(void);
>> 	switch (_NSIG_WORDS) {
>> 	case 4:
>> 		return (set->sig[3] | set->sig[2] |
>> @@ -77,7 +76,7 @@ static inline int sigisemptyset(sigset_t *set)
>> 	case 1:
>> 		return set->sig[0] =3D=3D 0;
>> 	default:
>> -		_NSIG_WORDS_is_unsupported_size();
>> +		BUILD_BUG();
>> 		return 0;
>> 	}
>> }
>> @@ -90,7 +89,6 @@ static inline int sigisemptyset(sigset_t *set)
>> #define _SIG_SET_BINOP(name, op)					=
\
>> static inline void name(sigset_t *r, const sigset_t *a, const =
sigset_t *b) \
>> {									=
\
>> -	extern void _NSIG_WORDS_is_unsupported_size(void);		=
\
>> 	unsigned long a0, a1, a2, a3, b0, b1, b2, b3;			=
\
>> 									=
\
>> 	switch (_NSIG_WORDS) {						=
\
>> @@ -107,7 +105,7 @@ static inline void name(sigset_t *r, const =
sigset_t *a, const sigset_t *b) \
>> 		r->sig[0] =3D op(a0, b0);					=
\
>> 		break;							=
\
>> 	    default:							=
\
>> -		_NSIG_WORDS_is_unsupported_size();			=
\
>> +	    	BUILD_BUG();						=
\
>> 	}								=
\
>> }
>>=20
>> @@ -128,8 +126,6 @@ _SIG_SET_BINOP(sigandnsets, _sig_andn)
>> #define _SIG_SET_OP(name, op)						=
\
>> static inline void name(sigset_t *set)					=
\
>> {									=
\
>> -	extern void _NSIG_WORDS_is_unsupported_size(void);		=
\
>> -									=
\
>> 	switch (_NSIG_WORDS) {						=
\
>> 	    case 4: set->sig[3] =3D op(set->sig[3]);			=
\
>> 		    set->sig[2] =3D op(set->sig[2]);			=
\
>> @@ -137,7 +133,7 @@ static inline void name(sigset_t *set)			=
		\
>> 	    case 1: set->sig[0] =3D op(set->sig[0]);			=
\
>> 		    break;						=
\
>> 	    default:							=
\
>> -		_NSIG_WORDS_is_unsupported_size();			=
\
>> +		BUILD_BUG();						=
\
>> 	}								=
\
>> }

--=20
Mark Rustad, Networking Division, Intel Corporation


--Apple-Mail=_39C6AC14-3000-424C-B0F0-6CE1F08FE247
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJUHJ95AAoJEDwO/+eO4+5uh+IP/28hXL8cFCfeaavuo5hJxuKm
8Ef08NYGmvPCpkNWNjiCTaXKCTqzsOjjmBNgrEcUrXa0mitvMOPidSj9rRtPDtAg
x9hTAG1uihTxFsCXxei0I0nLNRd+Phu9ENDzty0zHypUcQg9GqOCWdM0bj4iiVMM
hvRsUyIDj3h9JqvWKj+TsgGB+iN7QykFAbPwIqx13XxEHkJYEmGjeBPj4f2uTgcX
kpcTMWZo+JQ5jsYeJ7ir0xqHDmeT9+t/qHkfM/jFseQm3PjbPsO8tAVFM6I5gIKD
bYdJM8ln5skN0B+1NqWM7iBFk0jYhI2VLW0Wf+7fhXqG8iwXDFK6cJP3z1lYqCLT
NReDtkq6x9HdEYt1lCo/Z1iOf5M/prCnlvGq2j3jZsvzVRtLfcyRS/Db7wbcUC0f
DJJiaTgh1FvigVOZLJbWgTYEFdAA3CoywJCUdEKea1McB7W5vm7z34OMAkvfKGiW
q1uZOMDCsKzwmOQCTHFXDnb+Cev2kd5yrz+QsWIhXc9dusZV9kQpGjbEUCEsf2gk
/CGX05JB6ydw3TqFBGobH/lBsNtf0sfV16hhmZnQpiyvsHk8FLCKizdH3cXZI+Az
8BUl/5qXmtQ42vv23JSlY9E+uSRep7Go+Af12OlTIzo2qqMy49/JVBn0XVU8r9II
WMcmTrZTLpeVZJUnb78P
=IlWe
-----END PGP SIGNATURE-----

--Apple-Mail=_39C6AC14-3000-424C-B0F0-6CE1F08FE247--
