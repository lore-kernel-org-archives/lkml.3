Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbaGNJFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 05:05:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:50990 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaGNJFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 05:05:01 -0400
Date: Mon, 14 Jul 2014 11:04:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: sched, timers: use after free in __lock_task_sighand when
 exiting a process
Message-ID: <20140714090449.GL9918@twins.programming.kicks-ass.net>
References: <53C2FF4D.3020606@oracle.com>
 <53C31A34.8030500@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vTUhhhdwRI43FzeR"
Content-Disposition: inline
In-Reply-To: <53C31A34.8030500@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vTUhhhdwRI43FzeR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 13, 2014 at 07:45:56PM -0400, Sasha Levin wrote:
> On 07/13/2014 05:51 PM, Sasha Levin wrote:
> > Hi all,
> >=20
> > While fuzzing with trinity inside a KVM tools guest running the latest =
-next
> > kernel with the KASAN patchset, I've stumbled on the following spew:

WTH is a KASAN?

> Alrighty, I don't think it has anything to do with timers:
>=20
> [  876.319044] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [  876.319044] AddressSanitizer: use after free in do_raw_spin_unlock+0x4=
b/0x1a0 at addr ffff8803e48cec18
> [  876.319044] page:ffffea000f923380 count:0 mapcount:0 mapping:         =
 (null) index:0x0
> [  876.319044] page flags: 0x2fffff80008000(tail)
> [  876.319044] page dumped because: kasan error
> [  876.319044] CPU: 26 PID: 8749 Comm: trinity-watchdo Tainted: G        =
W      3.16.0-rc4-next-20140711-sasha-00046-g07d3099-dirty #817
> [  876.319044]  00000000000000fb 0000000000000000 ffffea000f923380 ffff88=
05c417fc70
> [  876.319044]  ffffffff9de47068 ffff8805c417fd40 ffff8805c417fd30 ffffff=
ff99426f5c
> [  876.319044]  0000000000000010 0000000000000000 ffff8805c417fc9d 666666=
20000000a8
> [  876.319044] Call Trace:
> [  876.319044] dump_stack (lib/dump_stack.c:52)
> [  876.319044] kasan_report_error (mm/kasan/report.c:98 mm/kasan/report.c=
:166)
> [  876.319044] __asan_load8 (mm/kasan/kasan.c:364)
> [  876.319044] do_raw_spin_unlock (./arch/x86/include/asm/current.h:14 ke=
rnel/locking/spinlock_debug.c:99 kernel/locking/spinlock_debug.c:158)
> [  876.319044] _raw_spin_unlock (include/linux/spinlock_api_smp.h:152 ker=
nel/locking/spinlock.c:183)
> [  876.319044] __lock_task_sighand (include/linux/rcupdate.h:858 kernel/s=
ignal.c:1285)
> [  876.319044] do_send_sig_info (kernel/signal.c:1191)
> [  876.319044] group_send_sig_info (kernel/signal.c:1304)
> [  876.319044] kill_pid_info (kernel/signal.c:1339)
> [  876.319044] SYSC_kill (kernel/signal.c:1423 kernel/signal.c:2900)

Oleg, what guarantees the RCU free of task-struct and sighand?

The only RCU I can find is delayed_put_task_struct() but that's not
often used. TASK_DEAD etc. use regular put_task_struct() and that
doesn't seem to involve RCU.

Could be I'm a moron, its Monday, and its relatively early, so I'll go
have another look..


--vTUhhhdwRI43FzeR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTw50xAAoJEHZH4aRLwOS6AOIQAKKCw411xAT91TPC2YTrww+e
dhQGZqTlE4JwsW7iNdQR16ngDxsDZbyKRN+RqaOxg1/ApbOYkkVblHkuQJITnxOF
0NtT8z8OYX+ycdd6nsWfMPsR4f5CHGb+iUrZXohN9t28LHbMZ+5YtV4/k8M5GcjI
iCiWLwKdL09QU2UOG+YP6axC+/FCakifRf4hz3vnofLQljqDNhmqJ9Ms8asnzZbr
kGTbLAC4luA92YLSKWxiDAohoh4Ze0O8totAwESDpzPetdZsxBxGgUO1G5I/bEC4
OsBl8kOlazqoQ1Kl0wKSoSNkHnZzlWMWNO6/HVrPcR8L9WujSEXRbp/i2xdi+/k2
GxxO6V74K0LbPvO4dwjcAaQKbgcHeGmskVVzjKV1pk7SVuWTEUmjdcyb+H9DU2/V
ts8GojVtfH6wZy+gKrO2Pj/ChX589J7Yeq77h8YQxwPnFgAi9XTu67tv4io18SAy
ZJLiLqRH/yreNr5WcVVAXQoLKvt30HYjIS60YXm4kYrH9aBOThyz63m+B9JXCf6u
vOLHP40FanOcw7yiwEKhc3ilqJ/+N11R6pV9zmHVdPLfxMy2oxYeAjRh/kgASyvL
Bx5I2eclsGKSU26nYo5sEBnZ7b+fQQL4B4ZQSWdrQKFDC9yOdSkZjTP+s8CrjM8A
WAe3vEkr3HBc1Sd8oaMB
=4goo
-----END PGP SIGNATURE-----

--vTUhhhdwRI43FzeR--
