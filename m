Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbaF2OdI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 10:33:08 -0400
Received: from mout.web.de ([212.227.17.12]:60299 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbaF2OdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 10:33:07 -0400
Message-ID: <53B02395.8030505@web.de>
Date: Sun, 29 Jun 2014 16:32:53 +0200
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
References: <53AFE2B3.5080300@web.de> <20140629102403.GE18167@minantech.com> <53AFEB16.5040608@web.de> <20140629105339.GF18167@minantech.com> <53AFF192.7020801@web.de> <20140629115143.GA4362@pd.tnic> <53B0050B.90104@web.de> <20140629131443.GA5199@pd.tnic> <20140629134247.GG18167@minantech.com> <20140629140104.GB12528@pd.tnic> <20140629142722.GH18167@minantech.com>
In-Reply-To: <20140629142722.GH18167@minantech.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="QX0Wroexpa1WvLtVL2CBqRrEAdUuPcerE"
X-Provags-ID: V03:K0:zTI8YhcoZVxrF9xjt4elYqPqTrG727YGYMxzIPksT6hmhzv4xqS
 V8dvZUzCzFH+AYQpHiYBZ9VJI12MwtXiU80dxCN3Pvd8p+dg9Y4x1dli001A35fSFJ1lTG4
 oKMds7ygrbNtyAyuxwA6SafV6SQrks2ArpjjJAdmvxmq/dr1eMvU6TPnCo+YP5ll/D/+0eE
 FfU1wo3x9gwSoL98oyEVw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QX0Wroexpa1WvLtVL2CBqRrEAdUuPcerE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2014-06-29 16:27, Gleb Natapov wrote:
> On Sun, Jun 29, 2014 at 04:01:04PM +0200, Borislav Petkov wrote:
>> On Sun, Jun 29, 2014 at 04:42:47PM +0300, Gleb Natapov wrote:
>>> Please do so and let us know.
>>
>> Yep, just did. Reverting ae9fedc793 fixes the issue.
>>
>>> reinj:1 means that previous injection failed due to another #PF that
>>> happened during the event injection itself This may happen if GDT or =
fist
>>> instruction of a fault handler is not mapped by shadow pages, but her=
e
>>> it says that the new page fault is at the same address as the previou=
s
>>> one as if GDT is or #PF handler is mapped there. Strange. Especially
>>> since #DF is injected successfully, so GDT should be fine. May be wro=
ng
>>> cpl makes svm crazy?
>>
>> Well, I'm not going to even pretend to know kvm to know *when* we're
>> saving VMCB state but if we're saving the wrong CPL and then doing the=

>> pagetable walk, I can very well imagine if the walker gets confused. O=
ne
>> possible issue could be U/S bit (bit 2) in the PTE bits which allows
>> access to supervisor pages only when CPL < 3. I.e., CPL has effect on
>> pagetable walk and a wrong CPL level could break it.
>>
>> All a conjecture though...
>>
> Looks plausible, still strange that second #PF is at the same address a=
s the first one though.
> Anyway, not we have the commit to blame.

I suspect there is a gap between cause and effect. I'm tracing CPL
changes currently, and my first impression is that QEMU triggers an
unwanted switch from CPL 3 to 0 on vmport access:

 qemu-system-x86-11883 [001]  7493.378630: kvm_entry:            vcpu 0
 qemu-system-x86-11883 [001]  7493.378631: bprint:               svm_vcpu=
_run: entry cpl 0
 qemu-system-x86-11883 [001]  7493.378636: bprint:               svm_vcpu=
_run: exit cpl 3
 qemu-system-x86-11883 [001]  7493.378637: kvm_exit:             reason i=
o rip 0x400854 info 56580241 400855
 qemu-system-x86-11883 [001]  7493.378640: kvm_emulate_insn:     0:400854=
:ed (prot64)
 qemu-system-x86-11883 [001]  7493.378642: kvm_userspace_exit:   reason K=
VM_EXIT_IO (2)
 qemu-system-x86-11883 [001]  7493.378655: bprint:               kvm_arch=
_vcpu_ioctl_get_sregs: ss.dpl 0
 qemu-system-x86-11883 [001]  7493.378684: bprint:               kvm_arch=
_vcpu_ioctl_set_sregs: ss.dpl 0
 qemu-system-x86-11883 [001]  7493.378685: bprint:               svm_set_=
segment: cpl =3D 0
 qemu-system-x86-11883 [001]  7493.378711: kvm_pio:              pio_read=
 at 0x5658 size 4 count 1 val 0x3442554a=20

Yeah... do we have to manually sync save.cpl into ss.dpl on get_sregs
on AMD?

Jan



--QX0Wroexpa1WvLtVL2CBqRrEAdUuPcerE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlOwI5UACgkQitSsb3rl5xQlkwCgqPtrTKo+/D7ckIxgTStKmOp7
mNoAn1/GbmtFHlDqL0mfcIr1fYiVfZCf
=UJ8Z
-----END PGP SIGNATURE-----

--QX0Wroexpa1WvLtVL2CBqRrEAdUuPcerE--
