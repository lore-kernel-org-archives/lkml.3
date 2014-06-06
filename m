Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbaFFJtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 05:49:09 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53563 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbaFFJtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 05:49:06 -0400
Date: Fri, 6 Jun 2014 11:48:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>, Brad Mouring <bmouring@ni.com>
Subject: Re: [patch 2/2] rtmutex: Detect changes in the pi lock chain
Message-ID: <20140606094859.GW6758@twins.programming.kicks-ass.net>
References: <20140605152544.641846795@linutronix.de>
 <20140605152801.930031935@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Wt10+cXOThorkX0z"
Content-Disposition: inline
In-Reply-To: <20140605152801.930031935@linutronix.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Wt10+cXOThorkX0z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



hehe, I can almost follow this code :-)

How about something like this on top?

---
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -260,6 +260,11 @@ static void rt_mutex_adjust_prio(struct
  */
 int max_lock_depth =3D 1024;
=20
+static inline struct rt_mutex *task_blocked_on(struct task_struct *p)
+{
+	return p->pi_blocked_on ? p->pi_blocked_on->lock : NULL;
+}
+
 /*
  * Adjust the priority chain. Also used for deadlock detection.
  * Decreases task's usage by one - may thus free the task.
@@ -443,10 +448,7 @@ static int rt_mutex_adjust_prio_chain(st
 	 * blocked itself. If yes we store a pointer to the lock for
 	 * the lock chain change detection above.
 	 */
-	if (task->pi_blocked_on)
-		next_lock =3D task->pi_blocked_on->lock;
-	else
-		next_lock =3D NULL;
+	next_lock =3D task_blocked_on(task);
=20
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
=20
@@ -569,7 +571,7 @@ static int task_blocks_on_rt_mutex(struc
 {
 	struct task_struct *owner =3D rt_mutex_owner(lock);
 	struct rt_mutex_waiter *top_waiter =3D waiter;
-	struct rt_mutex *next_lock =3D NULL;
+	struct rt_mutex *next_lock;
 	unsigned long flags;
 	int chain_walk, res;
=20
@@ -614,8 +616,8 @@ static int task_blocks_on_rt_mutex(struc
 	} else if (debug_rt_mutex_detect_deadlock(waiter, detect_deadlock)) {
 		chain_walk =3D 1;
 	}
-	if (owner->pi_blocked_on)
-		next_lock =3D owner->pi_blocked_on->lock;
+
+	next_lock =3D task_blocked_on(owner);
=20
 	raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
 	if (!chain_walk)
@@ -705,8 +707,7 @@ static void remove_waiter(struct rt_mute
 		}
 		__rt_mutex_adjust_prio(owner);
=20
-		if (owner->pi_blocked_on)
-			next_lock =3D owner->pi_blocked_on->lock;
+		next_lock =3D task_blocked_on(owner);
=20
 		raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
 	}

--Wt10+cXOThorkX0z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkY6LAAoJEHZH4aRLwOS6QkIP/3zHhX1VmbDp+UaM0Jf9KKDZ
amjA6OH79Hlrpyv6M91rrm8vKfMX/IoiDhdYtHefQKd7TJ784MV/8hDw5zYcENw7
ccK47bFTnT7WN2V+wmyr4f7P9Zy2mYRb9jaa3a9DM1RJxOc2PoI7BJmXfl1DMbmd
KULO2EHXuxmx1llUgPO+n/oxgrVs7OCJyqEcs+OW7ZW8CeBkemPcxeyWYxOquQOS
k5qNqbqul0tmBHiuMCFU0GcVVYtFoJ5srHbyn03EIC8BWb1huymd4mlxZ50q1dZl
O+3TGvFp3f1pgo4w3A0dRzD7iBS3sBS+UWRbir8NpchxSEDuUOHTt5OU52pKyDwk
BIKZ4CE+A6l0IGdckc+EkU6E5OG/oS3WziNO0eoZ/lqBH9RtspXmTgrm49DYO+/L
VEc9IEBt3KWVEhGoYmdgAaVcecGEK3WU6xxrqFFYqEuS+iyGaj8semyhMnQOaAZY
tVoKbLVqemHBiPH8Cn87qCCCip5+njanwU05R9l2uvun2bFMT5Ztiemdt/SjMPnh
lqGyo+4n/V18VhzwyGOyZef+qP3E6yP/Xqev4iZMkAfa6aAYEt3Gg9iBhyJbahFH
PGUuilN35Yvvz+Dt4ZjGL7se7u7exIF+TJII8MGygkAHAbWczOt/iNOwUC4YGUQF
Dhf0c3SKMbAJWVo5tWEh
=OtJ1
-----END PGP SIGNATURE-----

--Wt10+cXOThorkX0z--
