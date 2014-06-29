Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015AbaF2LAK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 07:00:10 -0400
Received: from mout.web.de ([212.227.17.12]:52678 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877AbaF2LAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 07:00:08 -0400
Message-ID: <53AFF192.7020801@web.de>
Date: Sun, 29 Jun 2014 12:59:30 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Gleb Natapov <gleb@kernel.org>
CC: Borislav Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86-ml <x86@kernel.org>,
        kvm@vger.kernel.org,
        =?ISO-8859-1?Q?J=F6rg_R=F6?= =?ISO-8859-1?Q?del?= 
	<joro@8bytes.org>
Subject: Re: __schedule #DF splat
References: <20140627101831.GB23153@pd.tnic> <53AD586A.40900@redhat.com> <20140627115545.GC23153@pd.tnic> <53AD5D27.2090505@redhat.com> <20140627121053.GD23153@pd.tnic> <20140628114431.GB4373@pd.tnic> <20140629064626.GD18167@minantech.com> <53AFE2B3.5080300@web.de> <20140629102403.GE18167@minantech.com> <53AFEB16.5040608@web.de> <20140629105339.GF18167@minantech.com>
In-Reply-To: <20140629105339.GF18167@minantech.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="1bltKXRgKGRo6fbMlScKxr3tmt2AL7WqI"
X-Provags-ID: V03:K0:PYj41/hn9Qyw6VLLleVIvgTz+OFlyJsqwOY80ExMvSvcC17Jojk
 +iBpMTox7Qc5gQbhwK3IfNC4dF6VGfPXzYc5v2Sbrgtl2kVyCApaS8VPEuxNYNuh9GgHJHK
 hR/QxnQLCaUAUVKUMDfPESvgxFCLn+jCiCnoFo5iIwI9VxE96XgInPoNJe1kudrUZAT6M+r
 cobK68EiNIV05MT218nDQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1bltKXRgKGRo6fbMlScKxr3tmt2AL7WqI
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2014-06-29 12:53, Gleb Natapov wrote:
> On Sun, Jun 29, 2014 at 12:31:50PM +0200, Jan Kiszka wrote:
>> On 2014-06-29 12:24, Gleb Natapov wrote:
>>> On Sun, Jun 29, 2014 at 11:56:03AM +0200, Jan Kiszka wrote:
>>>> On 2014-06-29 08:46, Gleb Natapov wrote:
>>>>> On Sat, Jun 28, 2014 at 01:44:31PM +0200, Borislav Petkov wrote:
>>>>>>  qemu-system-x86-20240 [006] ...1  9406.484134: kvm_page_fault: ad=
dress 7fffb62ba318 error_code 2
>>>>>>  qemu-system-x86-20240 [006] ...1  9406.484136: kvm_inj_exception:=
 #PF (0x2)a
>>>>>>
>>>>>> kvm injects the #PF into the guest.
>>>>>>
>>>>>>  qemu-system-x86-20240 [006] d..2  9406.484136: kvm_entry: vcpu 1
>>>>>>  qemu-system-x86-20240 [006] d..2  9406.484137: kvm_exit: reason P=
F excp rip 0xffffffff8161130f info 2 7fffb62ba318
>>>>>>  qemu-system-x86-20240 [006] ...1  9406.484138: kvm_page_fault: ad=
dress 7fffb62ba318 error_code 2
>>>>>>  qemu-system-x86-20240 [006] ...1  9406.484141: kvm_inj_exception:=
 #DF (0x0)
>>>>>>
>>>>>> Second #PF at the same address and kvm injects the #DF.
>>>>>>
>>>>>> BUT(!), why?
>>>>>>
>>>>>> I probably am missing something but WTH are we pagefaulting at a
>>>>>> user address in context_switch() while doing a lockdep call, i.e.
>>>>>> spin_release? We're not touching any userspace gunk there AFAICT.
>>>>>>
>>>>>> Is this an async pagefault or so which kvm is doing so that the gu=
est
>>>>>> rip is actually pointing at the wrong place?
>>>>>>
>>>>> There is nothing in the trace that point to async pagefault as far =
as I see.
>>>>>
>>>>>> Or something else I'm missing, most probably...
>>>>>>
>>>>> Strange indeed. Can you also enable kvmmmu tracing? You can also in=
strument
>>>>> kvm_multiple_exception() to see which two exception are combined in=
to #DF.
>>>>>
>>>>
>>>> FWIW, I'm seeing the same issue here (likely) on an E-450 APU. It
>>>> disappears with older KVM (didn't bisect yet, some 3.11 is fine) and=

>>>> when patch-disabling the vmport in QEMU.
>>>>
>>>> Let me know if I can help with the analysis.
>>>>
>>> Bisection would be great of course. Once thing that is special about
>>> vmport that comes to mind is that it reads vcpu registers to userspac=
e and
>>> write them back. IIRC "info registers" does the same. Can you see if =
the
>>> problem is reproducible with disabled vmport, but doing "info registe=
rs"
>>> in qemu console? Although trace does not should any exists to userspa=
ce
>>> near the failure...
>>
>> Yes, info registers crashes the guest after a while as well (with
>> different backtrace due to different context).
>>
> Oh crap. Bisection would be most helpful. Just to be absolutely sure
> that this is not QEMU problem: does exactly same QEMU version work with=

> older kernels?

Yes, that was the case last time I tried (I'm on today's git head with
QEMU right now).

Will see what I can do regarding bisecting. That host is a bit slow
(netbook), so it may take a while. Boris will probably beat me in this.

Jan



--1bltKXRgKGRo6fbMlScKxr3tmt2AL7WqI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlOv8ZIACgkQitSsb3rl5xT5PQCgzX/SdxjKFM14322WGkSmaBER
rJ0AoKMgSEv6h5aClYGz4yX4vo9fJad3
=WrTX
-----END PGP SIGNATURE-----

--1bltKXRgKGRo6fbMlScKxr3tmt2AL7WqI--
