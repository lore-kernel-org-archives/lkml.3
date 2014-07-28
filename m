Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439AbaG1REV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:04:21 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38660 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaG1REU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:04:20 -0400
Date: Mon, 28 Jul 2014 19:04:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf: invalid memory access in perf_swevent_del
Message-ID: <20140728170406.GV6758@twins.programming.kicks-ass.net>
References: <536EB79C.2080308@oracle.com>
 <53D313A3.2090201@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IcjWnDSMZlCA27rX"
Content-Disposition: inline
In-Reply-To: <53D313A3.2090201@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IcjWnDSMZlCA27rX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 25, 2014 at 10:34:11PM -0400, Sasha Levin wrote:
> On 05/10/2014 07:34 PM, Sasha Levin wrote:
> > Hi all,
> >=20
> > While fuzzing with trinity inside a KVM tools guest running the latest =
-next
> > kernel I've stumbled on the following spew:
>=20
> Ping? I'm still seeing corruption on perf_swevent_del and perf_swevent_in=
it:
>=20
> [  488.092839] AddressSanitizer: use after free in perf_swevent_del+0x33/=
0x70 at addr ffff8805f430ea48

> [  488.100020] Call Trace:
> [  488.100020] dump_stack (lib/dump_stack.c:52)
> [  488.100020] kasan_report_error (mm/kasan/report.c:98 mm/kasan/report.c=
:166)
> [  488.100020] __asan_store8 (mm/kasan/kasan.c:400)
> [  488.100020] perf_swevent_del (include/linux/list.h:618 include/linux/r=
culist.h:345 kernel/events/core.c:5758)
> [  488.100020] event_sched_out.isra.49 (kernel/events/core.c:1416)
> [  488.100020] group_sched_out (kernel/events/core.c:1442)
> [  488.100020] ctx_sched_out (kernel/events/core.c:2185 (discriminator 3))
> [  488.100020] __perf_event_task_sched_out (kernel/events/core.c:2360 ker=
nel/events/core.c:2385)
> [  488.100020] perf_event_task_sched_out (include/linux/perf_event.h:702)

> [  488.100020] Write of size 8 by thread T9306:
> [  488.100020] Memory state around the buggy address:
> [  488.100020]  ffff8805f430e780: fc fc fc fc fc fc fb fb fb fb fb fb fb =
fb fb fb
> [  488.100020]  ffff8805f430e800: fb fb fb fb fb fb fb fb fb fb fb fb fb =
fb fb fb
> [  488.100020]  ffff8805f430e880: fb fb fb fb fb fb fb fb fb fb fb fb fb =
fb fb fb
> [  488.100020]  ffff8805f430e900: fb fb fb fb fb fb fb fb fb fb fb fb fb =
fb fb fb
> [  488.100020]  ffff8805f430e980: fb fb fb fb fb fb fb fb fb fb fb fb fb =
fb fb fb
> [  488.100020] >ffff8805f430ea00: fb fb fb fb fb fb fb fb fb fb fb fb fb =
fb fb fb
> [  488.100020]                                               ^
> [  488.100020]  ffff8805f430ea80: fb fb fb fb fb fb fb fb fb fb fb fb fb =
fb fb fb
> [  488.100020]  ffff8805f430eb00: fb fb fb fb fb fb fb fb fb fb fb fb fb =
fb fb fb
> [  488.100020]  ffff8805f430eb80: fb fb fb fb fb fb fb fb fb fb fb fb fb =
fb fb fb
> [  488.100020]  ffff8805f430ec00: fb fb fb fb fb fb fb fb fb fb fb fb fb =
fb fb fb
> [  488.100020]  ffff8805f430ec80: fb fb fb fb fb fb fb fb fb fb fb fb fb =
fb fb fb

Useful, that kasan doesn't use POISON_FREE... :/

> [  517.616094] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> [  517.619549] BUG kmalloc-4096 (Not tainted): Poison overwritten
> [  517.621321] ----------------------------------------------------------=
-------------------
> [  517.621321]
> [  517.621321] Disabling lock debugging due to kernel taint
> [  517.621321] INFO: 0xffff8805f430ea48-0xffff8805f430eb77. First byte 0x=
0 instead of 0x6b
> [  517.621321] INFO: Allocated in perf_swevent_init+0x29f/0x440 age=3D140=
82 cpu=3D17 pid=3D9306
> [  517.621321]  __slab_alloc+0x65e/0x740
> [  517.621321]  kmem_cache_alloc_trace+0x17c/0x3a0
> [  517.621321]  perf_swevent_init+0x29f/0x440
> [  517.621321]  perf_init_event+0x293/0x340
> [  517.621321]  perf_event_alloc+0x5b8/0x6e0
> [  517.621321]  SYSC_perf_event_open+0x39b/0xf50
> [  517.621321]  SyS_perf_event_open+0x9/0x10
> [  517.621321]  tracesys+0xe1/0xe6

So this would be swevent_hlist_get_cpu()'s swevent_hlist allocation.

> [  517.621321] INFO: Freed in rcu_nocb_kthread+0x911/0x13f0 age=3D2958 cp=
u=3D3 pid=3D25
> [  517.621321]  __slab_free+0x276/0x3e0
> [  517.621321]  kfree+0x31a/0x390
> [  517.621321]  rcu_nocb_kthread+0x911/0x13f0
> [  517.621321]  kthread+0x144/0x170
> [  517.621321]  ret_from_fork+0x7c/0xb0
> [  517.621321] INFO: Slab 0xffffea0017d0c200 objects=3D7 used=3D7 fp=3D0x=
          (null) flags=3D0x6fffff80004080
> [  517.621321] INFO: Object 0xffff8805f430e7b0 @offset=3D26544 fp=3D0xfff=
f8805f4308000

And this would be the corresponding free:

  sw_perf_event_destroy()
  swevent_hlist_put()
  swevent_hlist_put_cpu()
  swevent_hlist_release()

Which would suggest a refcounting boo-boo, cute.


Does your trinity do hotplug while creating/destroying events?

--IcjWnDSMZlCA27rX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT1oKGAAoJEHZH4aRLwOS620gP/3zVLwmLasUfdq3IJBb8pakZ
LpKMePZ/lFN3BY3jAx7oHuAIzAjpglftWmW3IieuJLAa+BlPYeAI4xKMMJqrKvny
bbuefYK1qdUWZj8vgiuYun1ykl+Ihoynm/G/X/+KXR+QxUOwgxjXGuOq0ckDUqlm
pnr1txICBvOL7e5cysh2udLXRFJoGJxLizAsOcLfmSw3V4zQfRXpitBw37k6OdTk
3fp1RH37tUPQ+YXSK9KNCh/g9WdBxjszJ9R7WlQg6WB+hlW+lETAngFA/15vijtA
jxb4vk4Wm0BsJkM5kdWlHevz7bzRL5BgxefL6z+aZ7oJmpcGkAnthwYyieDEJIgV
+ojAgTevOu26j1um/59bj7ZA+e6Tm8yCeup5QjFIfBxvjhy/8XzjFryhBuleTLbb
CU+0dw8PCnXyIJUCUz7edoxWY51YVqEwPqAjTm8QBaGN2s65ITBj4623j30A+77a
P5h3iyqD01lQfu6ieTNxoFCpcDIdS6gGO7HnV0Phc2kRFtJLWzZKxx4zj1WVZlwh
tKiUGw93jY/EZGizXufqTp/BE9V8xYuEmIwhpqL5TGhTWaYuL0dE5tGxQZfnWQtI
77X67PGSY2n3AfvW8thcj0wfvZ4wHFhK7qyAlV4bDD74Vpvc5NEl4YvJaRVLHHjq
aFor/VSmrIywNifCrMe5
=jAZE
-----END PGP SIGNATURE-----

--IcjWnDSMZlCA27rX--
