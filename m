Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbaGaNNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:13:45 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36876 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaGaNNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:13:44 -0400
Date: Thu, 31 Jul 2014 15:13:31 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ilya Dryomov <ilya.dryomov@inktank.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>, davidlohr@hp.com,
        jason.low2@hp.com
Subject: Re: [PATCH] locking/mutexes: Revert "locking/mutexes: Add extra
 reschedule point"
Message-ID: <20140731131331.GT19379@twins.programming.kicks-ass.net>
References: <1406801797-20139-1-git-send-email-ilya.dryomov@inktank.com>
 <20140731115759.GS19379@twins.programming.kicks-ass.net>
 <CALFYKtBGQpxaZ0EFXbdvuEHeDeASeU-7XxQ_1a6ZDM=aJS651w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sBjycZIcBwEtFqBK"
Content-Disposition: inline
In-Reply-To: <CALFYKtBGQpxaZ0EFXbdvuEHeDeASeU-7XxQ_1a6ZDM=aJS651w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sBjycZIcBwEtFqBK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 31, 2014 at 04:37:29PM +0400, Ilya Dryomov wrote:

> This didn't make sense to me at first too, and I'll be happy to be
> proven wrong, but we can reproduce this with rbd very reliably under
> higher than usual load, and the revert makes it go away.  What we are
> seeing in the rbd scenario is the following.

This is drivers/block/rbd.c ? I can find but a single mutex_lock() in
there.

> Suppose foo needs mutexes A and B, bar needs mutex B.  foo acquires
> A and then wants to acquire B, but B is held by bar.  foo spins
> a little and ends up calling schedule_preempt_disabled() on line 484
> above, but that call never returns, even though a hundred usecs later
> bar releases B.  foo ends up stuck in mutex_lock() indefinitely, but
> still holds A and everybody else who needs A gets behind A.  Given that
> this A happens to be a central libceph mutex all rbd activity halts.
> Deadlock may not be the best term for this, but never returning from
> mutex_lock(&B) even though B has been unlocked is *a* problem.
>=20
> This obviously doesn't happen every time schedule_preempt_disabled() on
> line 484 is called, so there must be some sort of race here.  I'll send
> along the actual rbd stack traces shortly.

Smells like maybe current->state !=3D TASK_RUNNING, does the below
trigger?

If so, you've wrecked something in whatever...

---
 kernel/locking/mutex.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index ae712b25e492..3d726fdaa764 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -473,8 +473,12 @@ __mutex_lock_common(struct mutex *lock, long state, un=
signed int subclass,
 	 * reschedule now, before we try-lock the mutex. This avoids getting
 	 * scheduled out right after we obtained the mutex.
 	 */
-	if (need_resched())
+	if (need_resched()) {
+		if (WARN_ON_ONCE(current->state !=3D TASK_RUNNING))
+			__set_current_state(TASK_RUNNING);
+
 		schedule_preempt_disabled();
+	}
 #endif
 	spin_lock_mutex(&lock->wait_lock, flags);
=20

--sBjycZIcBwEtFqBK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT2kD6AAoJEHZH4aRLwOS6WoEQAIdDHtilwraCEWm0I+ftpltP
uxRXHS86sgZOzeRqtMR+ZDtqSVnjhsWTdZ/zTvBrFPq9ZANmNLa8OiuxNsiNVgyW
Nmh8YKSi2aFW4dyXWs9GCo6U/PWA0S5+WFVaUEj7yptY3XkKMYR4qUh/RFPi07/c
hkjsIQib0d4l9aBr1/OYsdX9s+rZnUtsfzTtnq428JmDnJ1DamxqRZINpIHE5N8l
ejHQ2AtVgftQIheBcn3yXYyArL663JVVVlr/JmpAZAr0hbMs+VcGq5go9wUoQZM2
Yjdyp7d/bXwlsrD9gaZW9uH0xy8raUEHoDLCxYDk46Ibh7yk1w7sK+4wsSrdcQZF
OMC9llNJ6hWJEXE0Dn8KuAFzyJ7Z81/OMrY8x1Ee3PHLs+qo5jF/CWk4qV6roI0Y
7HZ+k37nmBUiacJeFoWZiAcLCl09AwNk7/6NpgKSJoPdGWgSWPPwpVs3KE+y5UqP
zlhV6OdBneFPtPRKiqG3BBXdyQ1pga58MAaIUwIMwghZUox2PkJbchCudxBapISf
C0s8x56IqLegx+77RNyHa2Yc++tM98LXkQ1XtBAUSjgOyoR3h3QnMPAgWPhmnTCt
vfn/2C8ZhwHsguJi8Q4TmUUOj8y0Ahlqh77BFUwyG9vAwnax0q6dKTjHRc1biTQ+
34nQao01b5qz/HByMQCf
=X6jY
-----END PGP SIGNATURE-----

--sBjycZIcBwEtFqBK--
