Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbaBKSfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:35:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41272 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbaBKSe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:34:59 -0500
Message-ID: <52FA6D4B.7020709@canonical.com>
Date: Tue, 11 Feb 2014 19:34:51 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org
Subject: Another preempt folding issue?
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="fSxTdVX4c8RPDFqCCIKkqUDTrIK0ElF4s"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fSxTdVX4c8RPDFqCCIKkqUDTrIK0ElF4s
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi Peter,

I am currently looking at a weird issue that manifest itself when trying =
to run
kvm enabled qemu on a i386 host (v3.13 kernel, oh and potentially importa=
nt the
cpu is 64bit capable, so qemu-system-x86_64 is called). Sooner or later t=
his
causes softlockup messages on the host. I tracked this down to __vcpu_run=
 in
arch/x86/kvm/x86.c which does a loop which in that case never seems to ma=
ke
progress or exit.

What I found is that vcpu_enter_guest will exit quickly without causing t=
he loop
to exit when need_resched() is true. Looking at a crash dump I took, this=
 was
the case (thread_info->flags had TIF_NEED_RESCHED set). So after immediat=
ely
returning __vcpu_run has the following code:

        if (need_resched()) {
                srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
                kvm_resched(vcpu); // now cond_resched();
                vcpu->srcu_idx =3D srcu_read_lock(&kvm->srcu);
        }

The kvm_resched basically would end up doing a cond_resched() which now c=
hecks
preempt_count() to be 0. If that is zero it will do the reschedule, other=
wise it
just does nothing. Looking at the percpu variables in the dump, I saw tha=
t
the preempt_count was 0x8000000 (actually it was 0x80110000 but that was =
me
triggering the kexec crashdump with sysrq-c).

I saw that there have been some changes in the upstream kernel and have p=
icked
the following:
1) x86, acpi, idle: Restructure the mwait idle routines
2) x86, idle: Use static_cpu_has() for CLFLUSH workaround, add barriers
3) sched/preempt: Fix up missed PREEMPT_NEED_RESCHED folding
4) sched/preempt/x86: Fix voluntary preempt for x86

Patch 1) and 2) as dependencies of 3) (to get the mwait function correct =
and to
the other file). Finally 4) is fixing up 3). [maybe worth suggesting to d=
o for
3.13.y stable].

Still, with all those I got the softlockup. Since I knew from the dump in=
fo that
something is wrong with the folding, I made the pragmatic approach and ad=
ded the
following:

        if (need_resched()) {
                srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
+               preempt_fold_need_resched();
                kvm_resched(vcpu); // now cond_resched();
                vcpu->srcu_idx =3D srcu_read_lock(&kvm->srcu);
        }

And this lets the kvm guest run without the softlockups! However I am les=
s than
convinced that this is the right thing to do. Somehow something done when=

converting the preempt_count into percpu has caused at least the i386 sid=
e to
get into this mess (as there has not been any whining about 64bit). Just =
fail to
see what.

-Stefan


--fSxTdVX4c8RPDFqCCIKkqUDTrIK0ElF4s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJS+m1LAAoJEOhnXe7L7s6jgOwP/0JJ+OkIuvpHDiQm1vovP471
dnr8rNwbLpq7p/nw4flKxENQ/oe7W9Vsuf23J6/wBf5OHFmEiri332NuJu9clfeF
UZ7YnLEnkb1cmeGouxJdXhl/o1skzAAKhJWqSmNMbZ3FWtYzq7zmzYbXNSmM/GWj
vjFpZ2mpwSkQp4biRoe4TE/7Rv/SB2y3mPzYukLHZVnwPpH9s0OCFfusHAN48giT
H2VREVL5u2Lx76R7eoXbJQnmB7aXWhD776U/AaNMrsf6VM04UxhEZ+zB/mFSF3td
8r3uKx/YBIbhWj7grPE57uprmyXfESGRWTihDxrsFx/Zj0ugOnBC9WECiIQ7BFEF
3LeJlwFvG+URXImWAR8Ufv6AJU9ryo5EfK501oMom7v24/5vAC1BhFImI2RhRJDQ
WNhOJcqxVlQjvOLvHQN1xg6FL3SXlDxYQ0s+Ed+zQwK19UHi0UPs4Yq8hD2b69t5
EEpUDHAJ/KcTtAVHPuM6zchgj/Ul+yD7RXHARxnagz1eeHZBMchr03cX0sLeBFnY
1dPs6/LdR96uleYR/pCE4TxkuV8JKAVgeAgFXdbfMJ69Dyzr7wuGakoHKhVMhrbE
wxbdvUhBePVIcSJs4jWEH4l4yCynI9y7flsJf6dUdDpMkYz1x50Y8rttYYPqB6zL
8Q904TdPe+GnZB+Ezxur
=SzOQ
-----END PGP SIGNATURE-----

--fSxTdVX4c8RPDFqCCIKkqUDTrIK0ElF4s--
