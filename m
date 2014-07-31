Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642AbaGaN4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:56:31 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49298 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaGaN4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:56:30 -0400
Date: Thu, 31 Jul 2014 15:56:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Ilya Dryomov <ilya.dryomov@inktank.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>, davidlohr@hp.com,
        jason.low2@hp.com
Subject: Re: [PATCH] locking/mutexes: Revert "locking/mutexes: Add extra
 reschedule point"
Message-ID: <20140731135616.GU19379@twins.programming.kicks-ass.net>
References: <1406801797-20139-1-git-send-email-ilya.dryomov@inktank.com>
 <20140731115759.GS19379@twins.programming.kicks-ass.net>
 <CALFYKtBGQpxaZ0EFXbdvuEHeDeASeU-7XxQ_1a6ZDM=aJS651w@mail.gmail.com>
 <20140731131331.GT19379@twins.programming.kicks-ass.net>
 <20140731134411.GA12050@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kg2J3k9IiiSZbiqb"
Content-Disposition: inline
In-Reply-To: <20140731134411.GA12050@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kg2J3k9IiiSZbiqb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 31, 2014 at 03:44:11PM +0200, Ingo Molnar wrote:
>=20
> > diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
> > index ae712b25e492..3d726fdaa764 100644
> > --- a/kernel/locking/mutex.c
> > +++ b/kernel/locking/mutex.c
> > @@ -473,8 +473,12 @@ __mutex_lock_common(struct mutex *lock, long state=
, unsigned int subclass,
> >  	 * reschedule now, before we try-lock the mutex. This avoids getting
> >  	 * scheduled out right after we obtained the mutex.
> >  	 */
> > -	if (need_resched())
> > +	if (need_resched()) {
> > +		if (WARN_ON_ONCE(current->state !=3D TASK_RUNNING))
> > +			__set_current_state(TASK_RUNNING);
> > +
> >  		schedule_preempt_disabled();
> > +	}
>=20
> Might make sense to add that debug check under mutex debugging or so,=20
> with a sensible kernel message printed.

Something like so? I suppose we should do a similar one for rwsem,
semaphores and possibly wait_event*() too.

---
Subject: locking/mutex: Add debug check for task state

Calling blocking locks with current->state !=3D TASK_RUNNING is a bug.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/locking/mutex.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index ae712b25e492..d5daf8c38899 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -375,6 +375,17 @@ __mutex_lock_common(struct mutex *lock, long state, un=
signed int subclass,
 	unsigned long flags;
 	int ret;
=20
+#ifdef CONFIG_DEBUG_MUTEXES
+	/*
+	 * Blocking primitives (including this one) will set (and therefore
+	 * destroy) current->state, since we will exit with TASK_RUNNING
+	 * make sure we enter with it, otherwise we will destroy state.
+	 */
+	if (WARN_ONCE(current->state !=3D TASK_RUNNING,
+			"do not call blocking locks when !TASK_RUNNING\n"))
+		__set_current_state(TASK_RUNNING);
+#endif
+
 	preempt_disable();
 	mutex_acquire_nest(&lock->dep_map, subclass, 0, nest_lock, ip);
=20

--Kg2J3k9IiiSZbiqb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT2ksAAAoJEHZH4aRLwOS6SQcP/3K2BQUGSVZ/TEqFw2jwgDcW
VpU1FhFwVy+VvmxLlPqnGKMEkVZgXSLlbNM+qam4i+pjs3VGrW510FPMByXJj1j7
JeXwWiWQFo2VQaihpsgQyYtTs5Rn91YQ4OfVF4pNszLA8NEaOK8blFb3MExufotG
6cFUUVXfxTuDAnazKKzX1pD9SMKfH4JzwT2UxMqYF3uSQuDoaohOgM/n7HOz2G7C
B6zVbH1aMMOuraqBXuwLeowlDv0FEmXPAxE+kd0dLx4vCdY6BOJoUZmQnaLo+X9p
IGmwMlvthzU/nd8EEltSVrEaSu+cnWG5rYlqwnuQAwpNmTGt/hZsd0Sm3ylV05vh
ohY0BC+4olSzn/wFPKC+QbB6NFUlhwcrcOAoZaJOZ54O+0YhG3WPM7GVbuHT0ln3
Juz7oMkObw+vkqntnasT8CrqWc6K0g2nC+H3oVvG+Fl2GDIs2rw7bOzxNGBMKYmg
appNjd5tg18BCAYlwF8SdDeXs2BYU/hn8ry8heqim+/Mwo7864p6WUhtuXh4JXjZ
vpEEK8To1qhpnYLTX8+QYHnAWWyZCoOh7UMFUqHvneXrhoRicPlu8UiLCWEISIMM
lDzbNvYIPMtpwWDQQK99/CrtLTk2/ZhD+i9PlCdTM+2RIA8uwqkOZ1l00TgZYEvA
v9OO9CwA4f8G8Dx9E4eh
=xf9e
-----END PGP SIGNATURE-----

--Kg2J3k9IiiSZbiqb--
