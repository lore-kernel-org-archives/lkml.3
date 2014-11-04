Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbaKDUKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 15:10:51 -0500
Received: from mga03.intel.com ([134.134.136.65]:26838 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbaKDUKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 15:10:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,314,1413270000"; 
   d="asc'?scan'208";a="602244491"
From: "Rustad, Mark D" <mark.d.rustad@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC][PATCH 01/12 v3] x86/kvm/tracing: Use helper function
 trace_seq_buffer_ptr()
Thread-Topic: [RFC][PATCH 01/12 v3] x86/kvm/tracing: Use helper function
 trace_seq_buffer_ptr()
Thread-Index: AQHP+Ejxoqx4IykR8ECnWrUm/ou4UZxRO9yAgAAfgwCAAAcwAIAACYSA
Date: Tue, 4 Nov 2014 20:09:42 +0000
Message-ID: <6B853B85-57F8-4004-A33E-3B4199804277@intel.com>
References: <20141104155237.228431433@goodmis.org>
 <20141104160221.585025609@goodmis.org>
 <C664BE5A-1B30-454F-B7B8-DE4D5F5DF4B8@intel.com>
 <20141104140954.3a31ebe3@gandalf.local.home>
 <20141104143538.799e8716@gandalf.local.home>
In-Reply-To: <20141104143538.799e8716@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.25.101]
Content-Type: multipart/signed;
	boundary="Apple-Mail=_67AB09B8-E532-4A11-8F06-6C855826D043";
	protocol="application/pgp-signature"; micalg=pgp-sha1
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Apple-Mail=_67AB09B8-E532-4A11-8F06-6C855826D043
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 4, 2014, at 11:35 AM, Steven Rostedt <rostedt@goodmis.org> wrote:

> On Tue, 4 Nov 2014 14:09:54 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
>=20
>> On Tue, 4 Nov 2014 17:17:08 +0000
>> "Rustad, Mark D" <mark.d.rustad@intel.com> wrote:
>>=20
>>> On Nov 4, 2014, at 7:52 AM, Steven Rostedt <rostedt@goodmis.org> =
wrote:
>>>=20
>>>> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
>>>>=20
>>>> To allow for the restructiong of the trace_seq code, we need users
>>>> of it to use the helper functions instead of accessing the =
internals
>>>> of the trace_seq structure itself.
>>>>=20
>>>> Cc: Mark Rustad <mark.d.rustad@intel.com>
>>>> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>>>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>>>> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>>>> ---
>>>> arch/x86/kvm/mmutrace.h | 4 ++--
>>>> 1 file changed, 2 insertions(+), 2 deletions(-)
>>>>=20
>>>> diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
>>>> index 5aaf35641768..ce463a9cc8fb 100644
>>>> --- a/arch/x86/kvm/mmutrace.h
>>>> +++ b/arch/x86/kvm/mmutrace.h
>>>> @@ -22,7 +22,7 @@
>>>> 	__entry->unsync =3D sp->unsync;
>>>>=20
>>>> #define KVM_MMU_PAGE_PRINTK() ({				        =
\
>>>> -	const u32 saved_len =3D p->len;					=
\
>>>> +	const char *saved_ptr =3D trace_seq_buffer_ptr(p);		=
\
>>>=20
>>> I think the above should not be a const char *, because the location =
pointed to is surely being changed. It should either be a char * or a =
char * const.
>>=20
>> Ah right. It should be 'char * const'.
>>=20
>=20
> Actually, I take that back. The contents of saved_ptr should not be
> modified.

At least not by the caller of the macro. The subsequent call to =
trace_seq_printf will be changing the contents at that address, but not =
through use of that pointer.

> It may seem strange, but the update is done via the =
trace_seq_printf().
> Then that content is return back to the user. The user should
> definitely *not* modify the contents of saved_ptr.

Agreed.

> This patch is good as is. It should not be a char *, or char * const.

Yes. I did further checking and agree. Although that memory will be =
written, it isn't written through that pointer and it is the best type =
as a return value.

> -- Steve
>=20
>=20
>>=20
>>>=20
>>>> 	static const char *access_str[] =3D {			        =
\
>>>> 		"---", "--x", "w--", "w-x", "-u-", "-ux", "wu-", "wux"  =
\
>>>> 	};							        =
\
>>>> @@ -41,7 +41,7 @@
>>>> 			 role.nxe ? "" : "!",				=
\
>>>> 			 __entry->root_count,				=
\
>>>> 			 __entry->unsync ? "unsync" : "sync", 0);	=
\
>>>> -	p->buffer + saved_len;						=
\
>>>> +	saved_ptr;							=
\
>>>> 		})
>>>>=20
>>>> #define kvm_mmu_trace_pferr_flags       \
>>>> --=20
>>>> 2.1.1
>>>=20
>>=20
>=20

Acked-by: Mark Rustad <mark.d.rustad@intel.com>

--=20
Mark Rustad, Networking Division, Intel Corporation


--Apple-Mail=_67AB09B8-E532-4A11-8F06-6C855826D043
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJUWTKFAAoJEDwO/+eO4+5u8AEQAK6HjQJK8wV8Je0hsCCdqphd
CEmT7ND7DVtwINXmgwR++MocF6ScQpqtwL6qldAWN3nruGT/p3bZlkTgwYPAytin
39Qw1dx/w+JD6+dHW/zY+ipZw3ulhCSxw9nBV9Xw5556vMu5kV1GmBNY8arvOk2O
NyUXVmsWd25dcLQwyVaGb5MaYrln5Qmw+HRml+TPT7FESkKpv+TVZDjNVo9a0q8P
coGNyG9jcKN5YM6Wv4U4iAbIJ5jkHWIHrXtgueFZTiBTB9dtOu+H1MYenRZQW9Mg
PjYzcv3GkrUBxAvniSz8tBwxbEPBpA48FylcjKbjEq2YiLxVDNUcYBlemqjmMlVn
TQxR67HlP6c1R9MGvgD48UbfXckDxCAshywdpl2wFWZ2UlbHui+I5a+g6sH+YYgP
9y4Tv9VtiD3zb/IuQQMGK9HaZDKJVzmsZHCKzzd2ED0Gz80NhQ/5kLXMgQbrQHFR
cbUu74tvjaTxthyJ6aWllnMrFVrfuedhqlaUs+IPBLNeDQvt3XPDobyHycXaNOZp
8/Q3Sy/t7mtOAslKle7qwn3K/OgY+Os6rwdrYDCkPDWU/uB4hjd6rudLjU2wILtO
ac/r0C2bUUqRj3dF4k05MsGFOt8j7sTzc5E1Qa8PoxQbeJKKLF3aFEtPGe921fm8
gC4KP8zjZ9tQ+BM78gtu
=MMK/
-----END PGP SIGNATURE-----

--Apple-Mail=_67AB09B8-E532-4A11-8F06-6C855826D043--
