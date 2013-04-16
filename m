Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab3DPH0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 03:26:09 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55583 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298Ab3DPH0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 03:26:07 -0400
Date: Tue, 16 Apr 2013 17:25:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20130416172556.46cb5439c5f6d0b3da12bb15@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__16_Apr_2013_17_25_56_+1000_32G/5+t686QJWT.+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__16_Apr_2013_17_25_56_+1000_32G/5+t686QJWT.+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
kernel/kthread.c between commit f2530dc71cf0 ("kthread: Prevent unpark
race which puts threads on the wrong cpu") from Linus' tree and commit
"kthread: kill task_get_live_kthread()" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/kthread.c
index e820aa6,b9db231..0000000
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@@ -324,28 -324,6 +324,22 @@@ struct task_struct *kthread_create_on_c
  	return p;
  }
 =20
- static struct kthread *task_get_live_kthread(struct task_struct *k)
- {
- 	get_task_struct(k);
- 	return to_live_kthread(k);
- }
-=20
 +static void __kthread_unpark(struct task_struct *k, struct kthread *kthre=
ad)
 +{
 +	clear_bit(KTHREAD_SHOULD_PARK, &kthread->flags);
 +	/*
 +	 * We clear the IS_PARKED bit here as we don't wait
 +	 * until the task has left the park code. So if we'd
 +	 * park before that happens we'd see the IS_PARKED bit
 +	 * which might be about to be cleared.
 +	 */
 +	if (test_and_clear_bit(KTHREAD_IS_PARKED, &kthread->flags)) {
 +		if (test_bit(KTHREAD_IS_PER_CPU, &kthread->flags))
 +			__kthread_bind(k, kthread->cpu, TASK_PARKED);
 +		wake_up_state(k, TASK_PARKED);
 +	}
 +}
 +
  /**
   * kthread_unpark - unpark a thread created by kthread_create().
   * @k:		thread created by kthread_create().
@@@ -356,11 -334,22 +350,10 @@@
   */
  void kthread_unpark(struct task_struct *k)
  {
- 	struct kthread *kthread =3D task_get_live_kthread(k);
+ 	struct kthread *kthread =3D to_live_kthread(k);
 =20
 -	if (kthread) {
 -		clear_bit(KTHREAD_SHOULD_PARK, &kthread->flags);
 -		/*
 -		 * We clear the IS_PARKED bit here as we don't wait
 -		 * until the task has left the park code. So if we'd
 -		 * park before that happens we'd see the IS_PARKED bit
 -		 * which might be about to be cleared.
 -		 */
 -		if (test_and_clear_bit(KTHREAD_IS_PARKED, &kthread->flags)) {
 -			if (test_bit(KTHREAD_IS_PER_CPU, &kthread->flags))
 -				__kthread_bind(k, kthread->cpu);
 -			wake_up_process(k);
 -		}
 -	}
 +	if (kthread)
 +		__kthread_unpark(k, kthread);
- 	put_task_struct(k);
  }
 =20
  /**
@@@ -415,9 -403,12 +407,12 @@@ int kthread_stop(struct task_struct *k
  	int ret;
 =20
  	trace_sched_kthread_stop(k);
+=20
+ 	get_task_struct(k);
+ 	kthread =3D to_live_kthread(k);
  	if (kthread) {
  		set_bit(KTHREAD_SHOULD_STOP, &kthread->flags);
 -		clear_bit(KTHREAD_SHOULD_PARK, &kthread->flags);
 +		__kthread_unpark(k, kthread);
  		wake_up_process(k);
  		wait_for_completion(&kthread->exited);
  	}

--Signature=_Tue__16_Apr_2013_17_25_56_+1000_32G/5+t686QJWT.+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRbP0EAAoJEECxmPOUX5FEHqkQAJi3vTCoSwLTA97xokQcP6VA
qx1aQMzNkzMaXKAQG3w+8284XJz4+YPCbXYU8LszF+PWSh/mEQQfHQW7qL5BwU82
x23WCYFBAETp7jSDKuLy+3nqe+Q4I/QKLkLw+A4rHvyiOeddjShRLeLaGD8dLNR3
ngtlGNSK/T8jwRNuNcm/s2bJW7/tmh3gtERlLFaYIJFeWeyltqUwwZuJ46YaD3SN
Qi0wAIvAemyb1wpVDo99WinZhi7xjm5gzBMa89ETc+g7w0MvdrvMw831UTmq+Vw9
vvamTSCz0VkFYUMHLskTdb2D6TkSfFNAD8J0m7eVPNMAaDliG048Fi1RHTakQXOm
L7GC/mvQ9JG40mdc540oViT3lMH2fEpgKERfsdYVjUQLOJGPPDNL1oHzUJUkTKQd
0NmXgliGoo0Xeyo/JuXUpDU3zbDjVWpwQkq1kATD2pr+o5QTMAtjNjGLDd/FrBdz
Q7h1z3aFEKxwP4unouHKYTzRhtVBXORn95Rlb4UKPH4HlRWuK2NErUajLVtjBXOQ
MW8V/PRPpbvz17yy8wKHgshkOzLzbmU0uxWuaqDvfAgX3QcSGVggXzOUEeo74SfI
l+etlW5gSKF6Ixab6Tt0MyIbsooJA/Dx0uaqoZtGqgfQIGNlbJRLMKrBgU6KqKeH
JvPnZh6CeKqqPPKq63W+
=o0F9
-----END PGP SIGNATURE-----

--Signature=_Tue__16_Apr_2013_17_25_56_+1000_32G/5+t686QJWT.+--
