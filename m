Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965869Ab3E2SyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 14:54:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25921 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757319Ab3E2SyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 14:54:14 -0400
X-Authority-Analysis: v=2.0 cv=MNbiabll c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=n89D5_BD_5kA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=FHKjsnXOVhEA:10 a=VwQbUJbxAAAA:8 a=Osd0_VOj9OoNO9OJXPEA:9 a=QEXdDO2ut3YA:10 a=10PR9zEG5xMrMTqHefQA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130529185300.403107512@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 29 May 2013 14:53:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 0/2] [GIT PULL] rcu/ftrace: Fix livelock from overhead of RCU debugging
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Linus,

[ If you don't care to read the background of these patches,
  just jump down to the "Please pull" line. I included this
  description in the tag as well. ]

I was testing a config for one bug and triggered a livelock lockup. A
NMI watchdog dump showed what was happening:

[   65.972000] NMI backtrace for cpu 2
[   65.972000] CPU: 2 PID: 48 Comm: kworker/2:1 Not tainted 3.10.0-rc2-test=
+ #151
[   65.972000] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M.=
/To be filled by O.E.M., BIOS SDBLI944.86P 05/08/2007
[   65.972000] task: ffff880078dc2140 ti: ffff880078dc4000 task.ti: ffff880=
078dc4000
[   65.972000] RIP: 0010:[<ffffffff810c2259>]  [<ffffffff810c2259>] ftrace_=
ops_list_func+0x144/0x151
[   65.972000] RSP: 0000:ffff880078dc5ac8  EFLAGS: 00000006
[   65.972000] RAX: 0000000000008000 RBX: 0000000000000001 RCX: 00000000000=
0000f
[   65.972000] RDX: 0000000000000002 RSI: ffffffff810c0e9f RDI: ffffffff810=
b73f7
[   65.972000] RBP: ffff880078dc5af8 R08: ffff880078dc5be0 R09: ffff880078d=
c5bb0
[   65.972000] R10: ffffffff81a3c730 R11: 0000000000000001 R12: 00000000000=
08000
[   65.972000] R13: ffffffff810b73f7 R14: 0000000000000000 R15: ffffffff810=
c0e9f
[   65.972000] FS:  0000000000000000(0000) GS:ffff88007aa00000(0000) knlGS:=
0000000000000000
[   65.972000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   65.972000] CR2: 0000000000000168 CR3: 0000000001a0b000 CR4: 00000000000=
007e0
[   65.972000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[   65.972000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[   65.972000] Stack:
[   65.972000]  ffff880078d97480 0000000000000001 ffffffff810b9148 ffff8800=
78d97480
[   65.972000]  0000000000000000 ffffffff810bb6ba ffff880078dc5bd0 ffffffff=
814fa7c0
[   65.972000]  0000000000000000 ffffffff810bb6ba ffff880078dc5c00 ffffffff=
814fa7c0
[   65.972000] Call Trace:
[   65.972000]  [<ffffffff810b9148>] ? check_for_new_grace_period+0x115/0x1=
15
[   65.972000]  [<ffffffff810bb6ba>] ? rcu_note_context_switch+0x20e/0x260
[   65.972000]  [<ffffffff814fa7c0>] ftrace_call+0x5/0x2f
[   65.972000]  [<ffffffff810bb6ba>] ? rcu_note_context_switch+0x20e/0x260
[   65.972000]  [<ffffffff814fa7c0>] ? ftrace_call+0x5/0x2f
[   65.972000]  [<ffffffff810b73fc>] ? rcu_is_cpu_idle+0x5/0x69
[   65.972000]  [<ffffffff810558d3>] ? debug_lockdep_rcu_enabled+0x5/0x35
[   65.972000]  [<ffffffff810b73fc>] ? rcu_is_cpu_idle+0x5/0x69
[   65.972000]  [<ffffffff810c0e9f>] ? rcu_read_lock_held+0x19/0x3c
[   65.972000]  [<ffffffff810c0f90>] ftrace_ops_test+0x47/0x93
[   65.972000]  [<ffffffff810b9148>] ? check_for_new_grace_period+0x115/0x1=
15
[   65.972000]  [<ffffffff810c21e1>] ftrace_ops_list_func+0xcc/0x151
[   65.972000]  [<ffffffff814fa7c0>] ftrace_call+0x5/0x2f
[   65.972000]  [<ffffffff810c2234>] ? ftrace_ops_list_func+0x11f/0x151
[   65.972000]  [<ffffffff810bb6b2>] ? rcu_note_context_switch+0x206/0x260
[   67.972000]  [<ffffffff810b914d>] ? rcu_preempt_qs+0x5/0x53
[   65.972000]  [<ffffffff81086f41>] ? trace_hardirqs_off+0xd/0xf
[   65.972000]  [<ffffffff810b914d>] ? rcu_preempt_qs+0x5/0x53
[   65.972000]  [<ffffffff810bb6ba>] ? rcu_note_context_switch+0x20e/0x260
[   65.972000]  [<ffffffff814f2bca>] ? schedule+0x64/0x66
[   65.972000]  [<ffffffff814f246e>] __schedule+0x67/0x710
[   65.972000]  [<ffffffff81052e5e>] ? worker_thread+0x1e9/0x1f3
[   65.972000]  [<ffffffff81052e5e>] ? worker_thread+0x1e9/0x1f3
[   65.972000]  [<ffffffff814f2bca>] schedule+0x64/0x66
[   65.972000]  [<ffffffff81052e63>] worker_thread+0x1ee/0x1f3
[   65.972000]  [<ffffffff81052c75>] ? rescuer_thread+0x26c/0x26c
[   65.972000]  [<ffffffff8105a8bf>] kthread+0xb1/0xb9
[   65.972000]  [<ffffffff81064b3c>] ? finish_task_switch+0x7c/0xf8
[   65.972000]  [<ffffffff8105a80e>] ? __init_kthread_worker+0x59/0x59
[   65.972000]  [<ffffffff814faadc>] ret_from_fork+0x7c/0xb0
[   65.972000]  [<ffffffff8105a80e>] ? __init_kthread_worker+0x59/0x59

What happened was that ftrace's function tracer uses
hlist_for_each_entry_rcu() which uses rcu_dereference_raw(), and also
calls rcu_dereference_raw() directly. As this macro is defined as
rcu_dereference_check() and will call rcu_read_lock_sched_held() which
does various rcu checks as well as lockdep and such, when it happens for
*every* function call in the kernel it slows the system down where it
can live lock (interrupts taking too long to finish, before another
interrupt is triggered).

To give an idea of the abuse that function tracing is taking, every
function that is traced can do the following:

in __ftrace_ops_list_func() we have:

        do_for_each_ftrace_op(op, ftrace_ops_list) {
                if (ftrace_ops_test(op, ip))
                        op->func(ip, parent_ip, op, regs);
        } while_for_each_ftrace_op(op);

Where:

#define do_for_each_ftrace_op(op, list)                 \
        op =3D rcu_dereference_raw(list);                 \
        do

and

#define while_for_each_ftrace_op(op)                            \
        while (likely(op =3D rcu_dereference_raw((op)->next)) &&  \
               unlikely((op) !=3D &ftrace_list_end))

And ftrace_ops_test() has:

        filter_hash =3D rcu_dereference_raw(ops->filter_hash);
        notrace_hash =3D rcu_dereference_raw(ops->notrace_hash);

        if ((ftrace_hash_empty(filter_hash) ||
             ftrace_lookup_ip(filter_hash, ip)) &&
            (ftrace_hash_empty(notrace_hash) ||
             !ftrace_lookup_ip(notrace_hash, ip)))
                ret =3D 1;

Where ftrace_lookup_ip() has:

        hlist_for_each_entry_rcu(entry, hhd, hlist) {

Now that is 6 calls to rcu_dereference_raw() that happens for every
single function that is traced! And this doesn't count possibly more by
the callbacks that were registered by the function tracer, or multiple
loops by while_for_each_ftrace_op(). When rcu debugging is on, that's 6
calls to rcu_read_lock_sched_held() which not only does several calls
that is traced by the function tracer (luckily the recursion protection
catches those), but those calls also call preempt_disable/enable (that
gets traced by the function tracer). Worse yet, lock_is_held() is called
that disables and then re-enables interrupts, and does a search for
locks held.

All this overhead that is done for every function call that is traced
(which could be most of the functions in the kernel) and does it at
least 6 times. This can drastically slow things down so much that we get
a live lock in the system.

Now, we could put a bunch of notrace in the RCU code, but as RCU is a
more critical subsystem than tracing, and used more often, I find that
it is advantageous to be able to trace RCU. RCU is also a more complex
subsystem than tracing, and having that ability to trace RCU is an asset
to help debug it and give us better confidence that it works. Thus, I
believe it is better to remove some of the debugability from the tracing
infrastructure than to remove it from RCU. Not to mention, even
eliminating the recursive calls by the RCU being traced, it doesn't
remove the RCU functions being called or the lockdep function being
called 6 times for every function traced.

After discussing this with Paul McKenney, I added two new RCU interfaces:

 rcu_dereference_raw_notrace()
 hlist_for_each_entry_raw_notrace()

The function tracer now uses these and this prevents the live lock.


Please pull the latest trace-fixes-v3.10-rc3-v2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-v3.10-rc3-v2

Tag SHA1: 066277682313adbca025f177cff8a211f2b4f46d
Head SHA1: 1bb539ca36e21c2f4fce0865e11df384bc7b7656


Steven Rostedt (2):
      rcu: Add _notrace variation of rcu_dereference_raw() and hlist_for_ea=
ch_entry_rcu()
      ftrace: Use the rcu _notrace variants for rcu_dereference_raw() and f=
riends

----
 include/linux/rculist.h  |   20 ++++++++++++++++++++
 include/linux/rcupdate.h |    9 +++++++++
 kernel/trace/ftrace.c    |   18 +++++++++---------
 3 files changed, 38 insertions(+), 9 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRpk7SAAoJEOdOSU1xswtM1+4IAIG4eVaJ8KEcBOS0UiKeo3VZ
E13Vd1EDS2HlDQzKZB+f7BrBC9Ptm397jPodrcSbD0ajzXmw+hQTkJhRAo+vf9Mf
nu8ddJp44w4weNpu8I1gBWaSzykv3mOfLSJ69Ru3u/mgn+lKdRcx9XhwwjyyrI1D
IzeIWUxAYkUiY+1PZRknIzDx8urD6CtZO1oAXEXf6YzZ60YQXMFMcjHzNHD/HOLc
r1nC6/4InG4uc5zSAo1IAmScpOAV3QWWXAvXfCF5+zFkU7e+tqNEKqgjCxN4TZP3
XDvcgDcGn89BtAmRcXEN/CyI0v6HEFV7ZO8x9Z3bVBE3kCIxPjxpGI0MhDDz2J0=
=oePX
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
