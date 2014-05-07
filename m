Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807AbaEGMfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 08:35:39 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45034 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaEGMfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 08:35:37 -0400
Date: Wed, 7 May 2014 14:35:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] [RFC] perf: Fix a race between ring_buffer_detach() and
 ring_buffer_wakeup()
Message-ID: <20140507123526.GD13658@twins.programming.kicks-ass.net>
References: <1394199526-6400-1-git-send-email-alexander.shishkin@linux.intel.com>
 <20140313195816.GJ21124@linux.vnet.ibm.com>
 <20140314095033.GP27965@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
In-Reply-To: <20140314095033.GP27965@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 14, 2014 at 10:50:33AM +0100, Peter Zijlstra wrote:
> How about something like so that only does the sync_rcu() if really
> needed.

Paul reminded me we still have this issue open; I had another look and
the patch I proposed was completely broken, so I had to write me a new
one :-)

---
Subject: perf: Fix a race between ring_buffer_detach() and ring_buffer_atta=
ch()
=46rom: Peter Zijlstra <peterz@infradead.org>
Date: Fri, 14 Mar 2014 10:50:33 +0100

Alexander noticed that we use RCU iteration on rb->event_list but do
not use list_{add,del}_rcu() to add,remove entries to that list, nor
do we observe proper grace periods when re-using the entries.

Merge ring_buffer_detach() into ring_buffer_attach() such that
attaching to the NULL buffer is detaching.

Furthermore, ensure that between any 'detach' and 'attach' of the same
event we observe the required grace period, but only when strictly
required. In effect this means that only ioctl(.request =3D
PERF_EVENT_IOC_SET_OUTPUT) will wait for a grace period, while the
normal initial attach and final detach will not be delayed.

This patch should, I think, do the right thing under all
circumstances, the 'normal' cases all should never see the extra grace
period, but the two cases:

 1) PERF_EVENT_IOC_SET_OUTPUT on an event which already has a
    ring_buffer set, will now observe the required grace period between
    removing itself from the old and attaching itself to the new buffer.

    This case is 'simple' in that both buffers are present in
    perf_event_set_output() one could think an unconditional
    synchronize_rcu() would be sufficient; however...

 2) an event that has a buffer attached, the buffer is destroyed
    (munmap) and then the event is attached to a new/different buffer
    using PERF_EVENT_IOC_SET_OUTPUT.

    This case is more complex because the buffer destruction does:
      ring_buffer_attach(.rb =3D NULL)
    followed by the ioctl() doing:
      ring_buffer_attach(.rb =3D foo);

    and we still need to observe the grace period between these two
    calls due to us reusing the event->rb_entry list_head.

In order to make 2 happen we use Paul's latest cond_synchronize_rcu()
call.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Reported-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/perf_event.h |    2=20
 kernel/events/core.c       |  109 ++++++++++++++++++++--------------------=
-----
 2 files changed, 51 insertions(+), 60 deletions(-)

--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -403,6 +403,8 @@ struct perf_event {
=20
 	struct ring_buffer		*rb;
 	struct list_head		rb_entry;
+	unsigned long			rcu_batches;
+	int				rcu_pending;
=20
 	/* poll related */
 	wait_queue_head_t		waitq;
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3179,7 +3179,8 @@ static void free_event_rcu(struct rcu_he
 }
=20
 static void ring_buffer_put(struct ring_buffer *rb);
-static void ring_buffer_detach(struct perf_event *event, struct ring_buffe=
r *rb);
+static void ring_buffer_attach(struct perf_event *event,
+			       struct ring_buffer *rb);
=20
 static void unaccount_event_cpu(struct perf_event *event, int cpu)
 {
@@ -3242,8 +3243,6 @@ static void free_event(struct perf_event
 	unaccount_event(event);
=20
 	if (event->rb) {
-		struct ring_buffer *rb;
-
 		/*
 		 * Can happen when we close an event with re-directed output.
 		 *
@@ -3251,12 +3250,7 @@ static void free_event(struct perf_event
 		 * over us; possibly making our ring_buffer_put() the last.
 		 */
 		mutex_lock(&event->mmap_mutex);
-		rb =3D event->rb;
-		if (rb) {
-			rcu_assign_pointer(event->rb, NULL);
-			ring_buffer_detach(event, rb);
-			ring_buffer_put(rb); /* could be last */
-		}
+		ring_buffer_attach(event, NULL);
 		mutex_unlock(&event->mmap_mutex);
 	}
=20
@@ -3843,28 +3837,47 @@ static int perf_mmap_fault(struct vm_are
 static void ring_buffer_attach(struct perf_event *event,
 			       struct ring_buffer *rb)
 {
+	struct ring_buffer *old_rb =3D NULL;
 	unsigned long flags;
=20
-	if (!list_empty(&event->rb_entry))
-		return;
+	if (event->rb) {
+		/*
+		 * Should be impossible, we set this when removing
+		 * event->rb_entry and wait/clear when adding event->rb_entry.
+		 */
+		WARN_ON_ONCE(event->rcu_pending);
=20
-	spin_lock_irqsave(&rb->event_lock, flags);
-	if (list_empty(&event->rb_entry))
-		list_add(&event->rb_entry, &rb->event_list);
-	spin_unlock_irqrestore(&rb->event_lock, flags);
-}
+		old_rb =3D event->rb;
+		event->rcu_batches =3D get_state_synchronize_rcu();
+		event->rcu_pending =3D 1;
=20
-static void ring_buffer_detach(struct perf_event *event, struct ring_buffe=
r *rb)
-{
-	unsigned long flags;
+		spin_lock_irqsave(&rb->event_lock, flags);
+		list_del_rcu(&event->rb_entry);
+		spin_unlock_irqrestore(&rb->event_lock, flags);
+	}
=20
-	if (list_empty(&event->rb_entry))
-		return;
+	if (event->rcu_pending && rb) {
+		cond_synchronize_rcu(event->rcu_batches);
+		event->rcu_pending =3D 0;
+	}
=20
-	spin_lock_irqsave(&rb->event_lock, flags);
-	list_del_init(&event->rb_entry);
-	wake_up_all(&event->waitq);
-	spin_unlock_irqrestore(&rb->event_lock, flags);
+	if (rb) {
+		spin_lock_irqsave(&rb->event_lock, flags);
+		list_add_rcu(&event->rb_entry, &rb->event_list);
+		spin_unlock_irqrestore(&rb->event_lock, flags);
+	}
+
+	rcu_assign_pointer(event->rb, rb);
+
+	if (old_rb) {
+		ring_buffer_put(old_rb);
+		/*
+		 * Since we detached before setting the new rb, so that we
+		 * could attach the new rb, we could have missed a wakeup.
+		 * Provide it now.
+		 */
+		wake_up_all(&event->waitq);
+	}
 }
=20
 static void ring_buffer_wakeup(struct perf_event *event)
@@ -3933,7 +3946,7 @@ static void perf_mmap_close(struct vm_ar
 {
 	struct perf_event *event =3D vma->vm_file->private_data;
=20
-	struct ring_buffer *rb =3D event->rb;
+	struct ring_buffer *rb =3D ring_buffer_get(event);
 	struct user_struct *mmap_user =3D rb->mmap_user;
 	int mmap_locked =3D rb->mmap_locked;
 	unsigned long size =3D perf_data_size(rb);
@@ -3941,18 +3954,14 @@ static void perf_mmap_close(struct vm_ar
 	atomic_dec(&rb->mmap_count);
=20
 	if (!atomic_dec_and_mutex_lock(&event->mmap_count, &event->mmap_mutex))
-		return;
+		goto out_put;
=20
-	/* Detach current event from the buffer. */
-	rcu_assign_pointer(event->rb, NULL);
-	ring_buffer_detach(event, rb);
+	ring_buffer_attach(event, NULL);
 	mutex_unlock(&event->mmap_mutex);
=20
 	/* If there's still other mmap()s of this buffer, we're done. */
-	if (atomic_read(&rb->mmap_count)) {
-		ring_buffer_put(rb); /* can't be last */
-		return;
-	}
+	if (atomic_read(&rb->mmap_count))
+		goto out_put;
=20
 	/*
 	 * No other mmap()s, detach from all other events that might redirect
@@ -3982,11 +3991,9 @@ static void perf_mmap_close(struct vm_ar
 		 * still restart the iteration to make sure we're not now
 		 * iterating the wrong list.
 		 */
-		if (event->rb =3D=3D rb) {
-			rcu_assign_pointer(event->rb, NULL);
-			ring_buffer_detach(event, rb);
-			ring_buffer_put(rb); /* can't be last, we still have one */
-		}
+		if (event->rb =3D=3D rb)
+			ring_buffer_attach(event, NULL);
+
 		mutex_unlock(&event->mmap_mutex);
 		put_event(event);
=20
@@ -4011,6 +4018,7 @@ static void perf_mmap_close(struct vm_ar
 	vma->vm_mm->pinned_vm -=3D mmap_locked;
 	free_uid(mmap_user);
=20
+out_put:
 	ring_buffer_put(rb); /* could be last */
 }
=20
@@ -4128,7 +4136,6 @@ static int perf_mmap(struct file *file,
 	vma->vm_mm->pinned_vm +=3D extra;
=20
 	ring_buffer_attach(event, rb);
-	rcu_assign_pointer(event->rb, rb);
=20
 	perf_event_init_userpage(event);
 	perf_event_update_userpage(event);
@@ -6929,7 +6936,7 @@ static int perf_copy_attr(struct perf_ev
 static int
 perf_event_set_output(struct perf_event *event, struct perf_event *output_=
event)
 {
-	struct ring_buffer *rb =3D NULL, *old_rb =3D NULL;
+	struct ring_buffer *rb =3D NULL;
 	int ret =3D -EINVAL;
=20
 	if (!output_event)
@@ -6957,8 +6964,6 @@ perf_event_set_output(struct perf_event
 	if (atomic_read(&event->mmap_count))
 		goto unlock;
=20
-	old_rb =3D event->rb;
-
 	if (output_event) {
 		/* get the rb we want to redirect to */
 		rb =3D ring_buffer_get(output_event);
@@ -6966,23 +6971,7 @@ perf_event_set_output(struct perf_event
 			goto unlock;
 	}
=20
-	if (old_rb)
-		ring_buffer_detach(event, old_rb);
-
-	if (rb)
-		ring_buffer_attach(event, rb);
-
-	rcu_assign_pointer(event->rb, rb);
-
-	if (old_rb) {
-		ring_buffer_put(old_rb);
-		/*
-		 * Since we detached before setting the new rb, so that we
-		 * could attach the new rb, we could have missed a wakeup.
-		 * Provide it now.
-		 */
-		wake_up_all(&event->waitq);
-	}
+	ring_buffer_attach(event, rb);
=20
 	ret =3D 0;
 unlock:

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTaiiIAAoJEHZH4aRLwOS6GuAP/i+nwCjJXC7jvY8M0qZjssne
LuKO5vqHF8cVmuey1o2E7bw5GsfngurfgazGeuuPDJtrBH9GHXmqi/GWVL7oVv9X
q19MP1M9uQlzUJF+F+JG+io2MnXtp/19D3hnn2T8olTznutSX6LUIy/ye2Xu/nQj
vBKUsXyR3kyyDZ7RbwO3gOV/lEeM77rNSp99pM8ALxuxmHMHbrlFXmS751ZaakGu
GaHqaPAe2hljxxvbo24q2rPsI5LMqFxXtWw4Gm/ivxLg4tyeH6/5u6A7rYi9wC5Z
41dDyCiD9mlU9F5oA50c8Q7bERjdy54A0DURfYYjylePlTpyBSsj2MwFd25cq+tM
LoUbtkBNrotrA/7zQ2bh93Xa5K3RWm7xN8J3Kp6aI6khZrpag9f8wZajUoYd45fw
Eg7wv0YOw8hd/l/6NDHLEMrlWTZBTjJ6b8Dc8Xzus0YyBEx9Qawu/oO9EDzBpob0
x392fvue2nAUFwIocOlH/QvTXw+DyV7cLoNayYG8pt2RnUAYter1xX+UWjtbj3AD
AwFqbLvO6JXzr1qVcMkUloE8NyZHkQaJ/ihWt85SfK5r4SWOFTyPGGP/3MjH2v5l
r0QFZ/KEZOpbTGJZ6FAfBJEGL5PFrl2snKBBNG47DPQoDDiWdbePDmPblUzMrVUQ
k8djWOj9wKxt68UdLRSp
=g1Va
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
