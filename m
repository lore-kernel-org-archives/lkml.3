Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313AbaDJXZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 19:25:36 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:54725 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205AbaDJXZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 19:25:34 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Possible issue with commit 6f008e72cd - locking/mutex: Fix debug checks.
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1397172208_2039P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 10 Apr 2014 19:23:28 -0400
Message-ID: <3817.1397172208@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1397172208_2039P
Content-Type: text/plain; charset=us-ascii

So recent linux-next lock up on my laptop due to a third-party module.
Bisection finds this as the source of the issue:

6f008e72cd111a119b5d8de8c5438d892aae99eb is the first bad commit
commit 6f008e72cd111a119b5d8de8c5438d892aae99eb
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Wed Mar 12 13:24:42 2014 +0100

    locking/mutex: Fix debug checks

    OK, so commit:

      1d8fe7dc8078 ("locking/mutexes: Unlock the mutex without the wait_lock")

    generates this boot warning when CONFIG_DEBUG_MUTEXES=y:

      WARNING: CPU: 0 PID: 139 at /usr/src/linux-2.6/kernel/locking/mutex-debug.

    And that makes sense, because as soon as we release the lock a
    new owner can come in...

    One would think that !__mutex_slowpath_needs_to_unlock()
    implementations suffer the same, but for DEBUG we fall back to
    mutex-null.h which has an unconditional 1 for that.

    The mutex debug code requires the mutex to be unlocked after
    doing the debug checks, otherwise it can find inconsistent
    state.

I was finally able to get netconsole to cough up what happened:

Apr 10 18:52:23 turing-police [  768.277732] INFO: trying to register non-static key.
Apr 10 18:52:23 turing-police [  768.277781] the code is fine but needs lockdep annotation.
Apr 10 18:52:23 turing-police [  768.277794] turning off the locking correctness validator.
Apr 10 18:52:23 turing-police [  768.277819] CPU: 0 PID: 1237 Comm: Xorg Tainted: G           O  3.14.0-next-20140409-dirty #202
Apr 10 18:52:23 turing-police [  768.277925] Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A11 03/12/2013
Apr 10 18:52:23 turing-police [  768.277938]  0000000000000000
Apr 10 18:52:23 turing-police  ffff8800c65c7c60
Apr 10 18:52:23 turing-police  ffffffff81668e5f
Apr 10 18:52:23 turing-police  0000000000000000
Apr 10 18:52:23 turing-police
Apr 10 18:52:23 turing-police [  768.277989]  ffff8800c65c7cd0
Apr 10 18:52:23 turing-police  ffffffff8107b9c0
Apr 10 18:52:23 turing-police  ffffffff822098d0
Apr 10 18:52:23 turing-police  ffff8800c74cd8f8
Apr 10 18:52:23 turing-police
Apr 10 18:52:23 turing-police [  768.278091]  ffff8800c74cd0d0
Apr 10 18:52:23 turing-police  0000000000000019
Apr 10 18:52:23 turing-police  0000000000000000
Apr 10 18:52:23 turing-police  ffffffff81c2d980
Apr 10 18:52:23 turing-police
Apr 10 18:52:23 turing-police [  768.278119] Call Trace:
Apr 10 18:52:23 turing-police [  768.278137]  [<ffffffff81668e5f>] dump_stack+0x4f/0xa2
Apr 10 18:52:23 turing-police [  768.278153]  [<ffffffff8107b9c0>] register_lock_class+0x10d/0x2bf
Apr 10 18:52:23 turing-police [  768.278166]  [<ffffffff8107d26b>] __lock_acquire+0x127/0xdd7
Apr 10 18:52:23 turing-police [  768.278182]  [<ffffffff816732aa>] ? _raw_spin_unlock+0x5b/0x67
Apr 10 18:52:23 turing-police [  768.278196]  [<ffffffff8107e25e>] lock_acquire+0xc9/0x156
Apr 10 18:52:23 turing-police [  768.278208]  [<ffffffff81079e4e>] ? down+0x11/0x55
Apr 10 18:52:23 turing-police [  768.278305]  [<ffffffff8167319e>] _raw_spin_lock_irqsave+0x44/0x55
Apr 10 18:52:23 turing-police [  768.278317]  [<ffffffff81079e4e>] ? down+0x11/0x55
Apr 10 18:52:23 turing-police [  768.278328]  [<ffffffff81079e4e>] down+0x11/0x55

A down() of an un-annotated lock (which I'll have to annotate, I guess).

But then the kernel goes off into the weeds with complaints like:

Apr 10 18:53:28 turing-police [  833.465272] INFO: rcu_preempt detected stalls on CPUs/tasks:
Apr 10 18:53:28 turing-police  {
Apr 10 18:53:28 turing-police }
Apr 10 18:53:28 turing-police (detected by 3, t=65004 jiffies, g=4552, c=4551, q=287)
Apr 10 18:53:28 turing-police [  833.465354] INFO: Stall ended before state dump start
Apr 10 18:55:34 turing-police [  958.896736] INFO: task systemd:1 blocked for more than 120 seconds.

from all *over* the place - systemd in a poll() syscall, ext4, snd_hda, and
a few other places.  All the symptoms of busted locking leaving something
with an unintended held lock. After a bit, the box doesn't even answer
ping anymore....

I can't be sure that it's the down() call - but nothing else actually gets
*logged*.  But the commit obviously changes the actual semantics of
*something*.  Was this intentional?




--==_Exmh_1397172208_2039P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU0cn8AdmEQWDXROgAQLwKQ//fzCSWiiaZzADsFtCxkzufIN6g1pzODHp
Zt3fZEagP8tca/LOOUDAGbXfyzHfsYNokquwFUVQxGmjaBMID2eqXFSO0X05CRDn
ulmYyNTHK1FNb5lC20zKGcDvYQIxj5GUv8mnlTPXel+8eWVihiEykseZwilrAS6x
xncEzfYld7Cq4R+v0OBNXFjEPnRhECOWfzphWZb9ZHRJcBpZCijhRNbN1/0qcTzq
uptXcgsP3GVWdXSnPFIh0Nd0iZ0yUnWAve51GcqBqt/4FA4TleSULLLMfs0J4gsi
GA7qToow36hlP7Nt5DkI8XvShNYOkGASxjwy5TJGROGLVodvbEZxoHuJQo/WyBe6
INMRSjWRtSiiw3TuSZN4Wg6XAelEEUsYMM+n6z1BR7po7X+nGgeLrseOfQv6/5gl
D0hfkkwKAECc2NyfbbreTja/enYEsNvJ6ZJcHSeSivLYh/Z1a1gdsMFJeqEwloKA
YnOqkLNA+7PDTNybuM9e2aZUibVrQnrj7LSOiSHQsM3Gq9hcrX3hJl4tWdHX2dNl
FZ5Wkrla8Zy8eQM+1nM6JfcNPqRxVIegNPQpB3NsVIkuqN5SRRW7//hTOLwl4Yie
qj9MZFU9zLu0YKf9z47Br15mjPUJQNbXTPOKf4d8oKCCAbGIjBRMAdyiPiHmG9BY
NinvrbBCSis=
=KSj4
-----END PGP SIGNATURE-----

--==_Exmh_1397172208_2039P--
