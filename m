Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaF2J5s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 05:57:48 -0400
Received: from mout.web.de ([212.227.15.4]:54286 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbaF2J5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 05:57:46 -0400
Message-ID: <53AFE2B3.5080300@web.de>
Date: Sun, 29 Jun 2014 11:56:03 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Gleb Natapov <gleb@kernel.org>, Borislav Petkov <bp@alien8.de>
CC: Paolo Bonzini <pbonzini@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86-ml <x86@kernel.org>,
        kvm@vger.kernel.org,
        =?ISO-8859-1?Q?J=F6rg_R=F6?= =?ISO-8859-1?Q?del?= 
	<joro@8bytes.org>
Subject: Re: __schedule #DF splat
References: <20140625153227.GA13845@pd.tnic> <20140625202650.GC13845@pd.tnic> <20140627101831.GB23153@pd.tnic> <53AD586A.40900@redhat.com> <20140627115545.GC23153@pd.tnic> <53AD5D27.2090505@redhat.com> <20140627121053.GD23153@pd.tnic> <20140628114431.GB4373@pd.tnic> <20140629064626.GD18167@minantech.com>
In-Reply-To: <20140629064626.GD18167@minantech.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="QAlNSXRhDWBOxdsN6aCdxLJ5exSqeNqcc"
X-Provags-ID: V03:K0:GP59Femaulm+48e+6swNQxrIPKL8VicQE4HgrdiEfdQtjSJWkzF
 gCQpKA3Zve5UvAe19XxllhVIHJ6Z7L87nKhxbp2CFQyobUQ+rCKQ6Jn47krIVtBZU8c795F
 yn3LQB7lwLxtlPGNcJV32Q9NcbHxFYmq1V9YoGGiQXG1ryaBnfjExRa0QszwPLXDS+gOgAU
 fvFajr5ARKdPklWLMm6MQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QAlNSXRhDWBOxdsN6aCdxLJ5exSqeNqcc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2014-06-29 08:46, Gleb Natapov wrote:
> On Sat, Jun 28, 2014 at 01:44:31PM +0200, Borislav Petkov wrote:
>>  qemu-system-x86-20240 [006] ...1  9406.484134: kvm_page_fault: addres=
s 7fffb62ba318 error_code 2
>>  qemu-system-x86-20240 [006] ...1  9406.484136: kvm_inj_exception: #PF=
 (0x2)a
>>
>> kvm injects the #PF into the guest.
>>
>>  qemu-system-x86-20240 [006] d..2  9406.484136: kvm_entry: vcpu 1
>>  qemu-system-x86-20240 [006] d..2  9406.484137: kvm_exit: reason PF ex=
cp rip 0xffffffff8161130f info 2 7fffb62ba318
>>  qemu-system-x86-20240 [006] ...1  9406.484138: kvm_page_fault: addres=
s 7fffb62ba318 error_code 2
>>  qemu-system-x86-20240 [006] ...1  9406.484141: kvm_inj_exception: #DF=
 (0x0)
>>
>> Second #PF at the same address and kvm injects the #DF.
>>
>> BUT(!), why?
>>
>> I probably am missing something but WTH are we pagefaulting at a
>> user address in context_switch() while doing a lockdep call, i.e.
>> spin_release? We're not touching any userspace gunk there AFAICT.
>>
>> Is this an async pagefault or so which kvm is doing so that the guest
>> rip is actually pointing at the wrong place?
>>
> There is nothing in the trace that point to async pagefault as far as I=
 see.
>=20
>> Or something else I'm missing, most probably...
>>
> Strange indeed. Can you also enable kvmmmu tracing? You can also instru=
ment
> kvm_multiple_exception() to see which two exception are combined into #=
DF.
>=20

FWIW, I'm seeing the same issue here (likely) on an E-450 APU. It
disappears with older KVM (didn't bisect yet, some 3.11 is fine) and
when patch-disabling the vmport in QEMU.

Let me know if I can help with the analysis.

Jan



--QAlNSXRhDWBOxdsN6aCdxLJ5exSqeNqcc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlOv4rsACgkQitSsb3rl5xTV9QCfU62QxfAbivpi6MpMrwsvdoyX
BYoAoIjqwFqgdjT0GRpjsAJMP7gSRrGk
=2iA4
-----END PGP SIGNATURE-----

--QAlNSXRhDWBOxdsN6aCdxLJ5exSqeNqcc--
