Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092AbaHGJDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 05:03:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:46229 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbaHGJDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 05:03:45 -0400
Date: Thu, 7 Aug 2014 11:03:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Subject: nohz fail (was: perf related boot hang.)
Message-ID: <20140807090333.GL19379@twins.programming.kicks-ass.net>
References: <20140806143621.GA13832@redhat.com>
 <20140806161934.GF19379@twins.programming.kicks-ass.net>
 <20140806194656.GA11570@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8PsaJ3itJd/8Ap6i"
Content-Disposition: inline
In-Reply-To: <20140806194656.GA11570@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8PsaJ3itJd/8Ap6i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 06, 2014 at 03:46:56PM -0400, Dave Jones wrote:
> This one happened during runtime, but I got a whole stack..
>=20
>=20
>  Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 2
>  CPU: 2 PID: 7538 Comm: kworker/u8:8 Not tainted 3.16.0+ #34
>  Workqueue: btrfs-endio-write normal_work_helper [btrfs]
>   ffff880244c06c88 000000001b486fe1 ffff880244c06bf0 ffffffff8a7f1e37
>   ffffffff8ac52a18 ffff880244c06c78 ffffffff8a7ef928 0000000000000010
>   ffff880244c06c88 ffff880244c06c20 000000001b486fe1 0000000000000000
>  Call Trace:
>   <NMI>  [<ffffffff8a7f1e37>] dump_stack+0x4e/0x7a
>   [<ffffffff8a7ef928>] panic+0xd4/0x207
>   [<ffffffff8a1450e8>] watchdog_overflow_callback+0x118/0x120
>   [<ffffffff8a186b0e>] __perf_event_overflow+0xae/0x350
>   [<ffffffff8a184f80>] ? perf_event_task_disable+0xa0/0xa0
>   [<ffffffff8a01a4cf>] ? x86_perf_event_set_period+0xbf/0x150
>   [<ffffffff8a187934>] perf_event_overflow+0x14/0x20
>   [<ffffffff8a020386>] intel_pmu_handle_irq+0x206/0x410
>   [<ffffffff8a01937b>] perf_event_nmi_handler+0x2b/0x50
>   [<ffffffff8a007b72>] nmi_handle+0xd2/0x390
>   [<ffffffff8a007aa5>] ? nmi_handle+0x5/0x390
>   [<ffffffff8a0cb7f8>] ? match_held_lock+0x8/0x1b0
>   [<ffffffff8a008062>] default_do_nmi+0x72/0x1c0
>   [<ffffffff8a008268>] do_nmi+0xb8/0x100
>   [<ffffffff8a7ff66a>] end_repeat_nmi+0x1e/0x2e
>   [<ffffffff8a0cb7f8>] ? match_held_lock+0x8/0x1b0
>   [<ffffffff8a0cb7f8>] ? match_held_lock+0x8/0x1b0
>   [<ffffffff8a0cb7f8>] ? match_held_lock+0x8/0x1b0

Ok so that part is just the watchdog triggering, so the below part is
the screwy bit:

>   <<EOE>>  <IRQ>  [<ffffffff8a0ccd2f>] lock_acquired+0xaf/0x450
>   [<ffffffff8a0f74c5>] ? lock_hrtimer_base.isra.20+0x25/0x50
>   [<ffffffff8a7fc678>] _raw_spin_lock_irqsave+0x78/0x90
>   [<ffffffff8a0f74c5>] ? lock_hrtimer_base.isra.20+0x25/0x50
>   [<ffffffff8a0f74c5>] lock_hrtimer_base.isra.20+0x25/0x50
>   [<ffffffff8a0f7723>] hrtimer_try_to_cancel+0x33/0x1e0
>   [<ffffffff8a0f78ea>] hrtimer_cancel+0x1a/0x30
>   [<ffffffff8a109237>] tick_nohz_restart+0x17/0x90
>   [<ffffffff8a10a213>] __tick_nohz_full_check+0xc3/0x100
>   [<ffffffff8a10a25e>] nohz_full_kick_work_func+0xe/0x10
>   [<ffffffff8a17c884>] irq_work_run_list+0x44/0x70
>   [<ffffffff8a17c8da>] irq_work_run+0x2a/0x50
>   [<ffffffff8a0f700b>] update_process_times+0x5b/0x70
>   [<ffffffff8a109005>] tick_sched_handle.isra.21+0x25/0x60
>   [<ffffffff8a109b81>] tick_sched_timer+0x41/0x60
>   [<ffffffff8a0f7aa2>] __run_hrtimer+0x72/0x470
>   [<ffffffff8a109b40>] ? tick_sched_do_timer+0xb0/0xb0
>   [<ffffffff8a0f8707>] hrtimer_interrupt+0x117/0x270
>   [<ffffffff8a034357>] local_apic_timer_interrupt+0x37/0x60
>   [<ffffffff8a80010f>] smp_apic_timer_interrupt+0x3f/0x50
>   [<ffffffff8a7fe52f>] apic_timer_interrupt+0x6f/0x80

And that looks like someone trying to cancel a timer from a timer, I
guess that won't work, seeing how cancel will wait for the timer handler
completion etc.

This is because of the fallback irq_work_run() in the tick
(update_process_times).


--8PsaJ3itJd/8Ap6i
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT40DlAAoJEHZH4aRLwOS6VVoQAKBrZU0xscMJT7ZwREp8tUxY
/BinSYmEoPzU8Q4uYMBCpeu6wi0Q88cifFaa8DzBLeavaV5jd6Z9bmXFSQ9VwPow
5C8iSJl5hCm8qICntLRjejIhfLMWi4sOtMM+yltAD/PxzXlB3by/5QemPHj56Q00
vJshs0ElRfUhyY1OvScQWKRVjg1oXbN9yDEhFuhPLV2ZPZLd0cjOnZHmj5Rvy+Vj
PGoWpj/QodB1cWsGgvSon1O7KGJJe55YEOJPBiwyzp7P6Jwr6FDwjM6DvReJaHP/
vOpUNbAcAv2rfT5bbQgXVUflgHaRv+HslUhcSikOsubWQSSFXH3a64QYgw5Q0v4Y
qN2nTYKXeGKLqZAiI4FMNxASMiiBbwSIdFgneDkwWRnRV00M0+jhrXcy1b4uyPhX
v8aPQ3FGabZWmm/paU+PYfaku5lPFW2gXlHIJ6jKGOHutSM15dK81elMBTzkJAtc
rOW5DGFLfMFI18eSPULn3Gs0bgaZ28QkeT5yJCbZ715Ejiyxojs0hwT6X3Xw0fz6
Wlf6J7sdQIb4FMbOij78q/+uV0Wdxj5olludwKhgD0GX7wgpfwNUBtpCtLccvbBb
hTSdWL39zApE9DLP1Dwh0q/vhaQMHK4KZOxro9wwIliOaxy5ePJN8pb48Z9EIKdM
6vYdJ6F+t8jkf9uZXZWX
=JkA4
-----END PGP SIGNATURE-----

--8PsaJ3itJd/8Ap6i--
