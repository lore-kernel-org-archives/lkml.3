Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbaF2Ovp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 10:51:45 -0400
Received: from mout.web.de ([212.227.17.11]:64016 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbaF2Ovo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 10:51:44 -0400
Message-ID: <53B027E0.7040003@web.de>
Date: Sun, 29 Jun 2014 16:51:12 +0200
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
References: <53AFE2B3.5080300@web.de> <20140629102403.GE18167@minantech.com> <53AFEB16.5040608@web.de> <20140629105339.GF18167@minantech.com> <53AFF192.7020801@web.de> <20140629115143.GA4362@pd.tnic> <53B0050B.90104@web.de> <20140629131443.GA5199@pd.tnic> <20140629134247.GG18167@minantech.com> <20140629140104.GB12528@pd.tnic> <20140629142722.GH18167@minantech.com> <53B02395.8030505@web.de>
In-Reply-To: <53B02395.8030505@web.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="rjNFem96UA8MS487cOFa1r6LCMxcVBJhc"
X-Provags-ID: V03:K0:Lbp9VzVgtKqGvKEoNAvcUO+Lhv3ywJrtGHfEU0dn63uwJU1w1e4
 QUt+0ZUEDBBNV5IsdB5YEf5yHYrupkl6J8/3E0YIXxpBhOJ708BmiOaZoaYkQbDx5TdHtnX
 kxYPoHVwyxRotbpBn+/P3IVl5K9ULnw3TQY1pX8oNcf1nNZQpYpRrX08nqMJDurdS/WXfi2
 lW8PtetnfEYtIKxhLj5rg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rjNFem96UA8MS487cOFa1r6LCMxcVBJhc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2014-06-29 16:32, Jan Kiszka wrote:
> On 2014-06-29 16:27, Gleb Natapov wrote:
>> On Sun, Jun 29, 2014 at 04:01:04PM +0200, Borislav Petkov wrote:
>>> On Sun, Jun 29, 2014 at 04:42:47PM +0300, Gleb Natapov wrote:
>>>> Please do so and let us know.
>>>
>>> Yep, just did. Reverting ae9fedc793 fixes the issue.
>>>
>>>> reinj:1 means that previous injection failed due to another #PF that=

>>>> happened during the event injection itself This may happen if GDT or=
 fist
>>>> instruction of a fault handler is not mapped by shadow pages, but he=
re
>>>> it says that the new page fault is at the same address as the previo=
us
>>>> one as if GDT is or #PF handler is mapped there. Strange. Especially=

>>>> since #DF is injected successfully, so GDT should be fine. May be wr=
ong
>>>> cpl makes svm crazy?
>>>
>>> Well, I'm not going to even pretend to know kvm to know *when* we're
>>> saving VMCB state but if we're saving the wrong CPL and then doing th=
e
>>> pagetable walk, I can very well imagine if the walker gets confused. =
One
>>> possible issue could be U/S bit (bit 2) in the PTE bits which allows
>>> access to supervisor pages only when CPL < 3. I.e., CPL has effect on=

>>> pagetable walk and a wrong CPL level could break it.
>>>
>>> All a conjecture though...
>>>
>> Looks plausible, still strange that second #PF is at the same address =
as the first one though.
>> Anyway, not we have the commit to blame.
>=20
> I suspect there is a gap between cause and effect. I'm tracing CPL
> changes currently, and my first impression is that QEMU triggers an
> unwanted switch from CPL 3 to 0 on vmport access:
>=20
>  qemu-system-x86-11883 [001]  7493.378630: kvm_entry:            vcpu 0=

>  qemu-system-x86-11883 [001]  7493.378631: bprint:               svm_vc=
pu_run: entry cpl 0
>  qemu-system-x86-11883 [001]  7493.378636: bprint:               svm_vc=
pu_run: exit cpl 3
>  qemu-system-x86-11883 [001]  7493.378637: kvm_exit:             reason=
 io rip 0x400854 info 56580241 400855
>  qemu-system-x86-11883 [001]  7493.378640: kvm_emulate_insn:     0:4008=
54:ed (prot64)
>  qemu-system-x86-11883 [001]  7493.378642: kvm_userspace_exit:   reason=
 KVM_EXIT_IO (2)
>  qemu-system-x86-11883 [001]  7493.378655: bprint:               kvm_ar=
ch_vcpu_ioctl_get_sregs: ss.dpl 0
>  qemu-system-x86-11883 [001]  7493.378684: bprint:               kvm_ar=
ch_vcpu_ioctl_set_sregs: ss.dpl 0
>  qemu-system-x86-11883 [001]  7493.378685: bprint:               svm_se=
t_segment: cpl =3D 0
>  qemu-system-x86-11883 [001]  7493.378711: kvm_pio:              pio_re=
ad at 0x5658 size 4 count 1 val 0x3442554a=20
>=20
> Yeah... do we have to manually sync save.cpl into ss.dpl on get_sregs
> on AMD?
>=20

Applying this logic:

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ec8366c..b5e994a 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1462,6 +1462,7 @@ static void svm_get_segment(struct kvm_vcpu *vcpu,
 		 */
 		if (var->unusable)
 			var->db =3D 0;
+		var->dpl =3D to_svm(vcpu)->vmcb->save.cpl;
 		break;
 	}
 }

=2E..and my VM runs smoothly so far. Does it make sense in all scenarios?=


Jan


--rjNFem96UA8MS487cOFa1r6LCMxcVBJhc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlOwJ+EACgkQitSsb3rl5xRobwCg567iNYojNJeeIJ/MJWvgO7KC
3KoAoLXNkFJr8qxn7arrzMLOOuC5nSSU
=G6Wh
-----END PGP SIGNATURE-----

--rjNFem96UA8MS487cOFa1r6LCMxcVBJhc--
