Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbaCLCgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 22:36:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37360 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbaCLCgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 22:36:48 -0400
Date: Wed, 12 Mar 2014 13:36:38 +1100
From: NeilBrown <neilb@suse.de>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, "majianpeng" <majianpeng@gmail.com>
Subject: [PATCH] poll/wait/md: allow module to safely support 'poll' on
 /proc files
Message-ID: <20140312133638.1fd84632@notabene.brown>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/4h0xwM5dugq.bFxoPNuUjZA"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/4h0xwM5dugq.bFxoPNuUjZA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


The md driver currently supports 'poll' on /proc/mdstat.
This is unsafe as if the md-mod module is removed while a 'poll'
or 'select' is outstanding on /proc/mdstat, an oops occurs
when the syscall completes.
poll_freewait() will call remove_wait_queue() on a wait_queue_head_t
which was local to the module which no-longer exists.

This problem is particular to /proc.  Most filesystems do not
allow the module to be unloaded while any files are open on it.
/proc only blocks module unloading while a file_operations
call is currently active into the module, not while the file is open.
kernfs has this property too but kernfs allocates a wait_queue_head_t
in its internal data structures so the module doesn't need to provide
one.
(A previous patch to add a similar allocation to procfs was not
accepted).

This patch takes a different approach and allows a module to
disconnect the wait_queue_head_t that was passed to poll_wait()
from all the clients which are waiting on it.  Thus after calling
 proc_remove_entry("mdstat", NULL);
we simply call
 wait_queue_purge(&md_event_waiters);

and then know that it is safe to remove the module.

rcu infrastructure is used to avoid races.
poll_freewait() checks if the purge has happened under rcu_read_lock()
to ensure that it never touches any freed memory.  wait_queue_purge()
uses synchronize_rcu() to ensure no poll_freewait() could still be
looking at the wait_queue_head_t.

Reported-by: "majianpeng" <majianpeng@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4ad5cc4e63e8..e28c9d2a1166 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8681,6 +8681,7 @@ static __exit void md_exit(void)
 	unregister_reboot_notifier(&md_notifier);
 	unregister_sysctl_table(raid_table_header);
 	remove_proc_entry("mdstat", NULL);
+	wait_queue_purge(&md_event_waiters);
 	for_each_mddev(mddev, tmp) {
 		export_array(mddev);
 		mddev->hold_active =3D 0;
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index af903128891c..a095312d01e2 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -521,7 +521,7 @@ static void ep_remove_wait_queue(struct eppoll_entry *p=
wq)
 	/* If it is cleared by POLLFREE, it should be rcu-safe */
 	whead =3D rcu_dereference(pwq->whead);
 	if (whead)
-		remove_wait_queue(whead, &pwq->wait);
+		remove_wait_queue_purgeable(whead, &pwq->wait);
 	rcu_read_unlock();
 }
=20
diff --git a/fs/select.c b/fs/select.c
index 467bb1cb3ea5..7c35bcdbd94c 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -129,7 +129,7 @@ EXPORT_SYMBOL(poll_initwait);
=20
 static void free_poll_entry(struct poll_table_entry *entry)
 {
-	remove_wait_queue(entry->wait_address, &entry->wait);
+	remove_wait_queue_purgeable(entry->wait_address, &entry->wait);
 	fput(entry->filp);
 }
=20
diff --git a/include/linux/wait.h b/include/linux/wait.h
index 559044c79232..18d0d2fbf3bd 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -106,6 +106,8 @@ static inline int waitqueue_active(wait_queue_head_t *q)
 extern void add_wait_queue(wait_queue_head_t *q, wait_queue_t *wait);
 extern void add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t *w=
ait);
 extern void remove_wait_queue(wait_queue_head_t *q, wait_queue_t *wait);
+extern void wait_queue_purge(wait_queue_head_t *q);
+extern void remove_wait_queue_purgeable(wait_queue_head_t *q, wait_queue_t=
 *wait);
=20
 static inline void __add_wait_queue(wait_queue_head_t *head, wait_queue_t =
*new)
 {
diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index 7d50f794e248..12548730c6ed 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -52,6 +52,51 @@ void remove_wait_queue(wait_queue_head_t *q, wait_queue_=
t *wait)
 EXPORT_SYMBOL(remove_wait_queue);
=20
=20
+/**
+ * wait_queue_purge - remove all waiter from a wait_queue
+ * @q: The queue to be purged
+ *
+ * Unlink all pending waiters from the queue.
+ * This can be used prior to freeing a queue providing all waiters are
+ * prepared for queue purging.
+ * Waiters must call remove_wait_queue_puregeable() rather than
+ * remove_wait_queue().
+ *
+ */
+void wait_queue_purge(wait_queue_head_t *q)
+{
+	spin_lock(&q->lock);
+	while (!list_empty(&q->task_list))
+		list_del_init(q->task_list.next);
+	spin_unlock(&q->lock);
+	synchronize_rcu();
+}
+EXPORT_SYMBOL(wait_queue_purge);
+
+/**
+ * remove_wait_queue_puregeable - remove_wait_queue if wait_queue_purge mi=
ght be used.
+ * @q: the queue, which may already be purged, to remove from
+ * @wait: the waiter to remove
+ *
+ * Remove a waiter from a queue if it hasn't already been purged.
+ * If the queue has already been purged then task_list will be empty.
+ * If it isn't then it is still safe to lock the queue and remove
+ * the task.
+ */
+void remove_wait_queue_purgeable(wait_queue_head_t *q, wait_queue_t *wait)
+{
+	unsigned long flags;
+
+	rcu_read_lock();
+	if (!list_empty(&wait->task_list)) {
+		spin_lock_irqsave(&q->lock, flags);
+		list_del_init(&wait->task_list);
+		spin_unlock_irqrestore(&q->lock, flags);
+	}
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(remove_wait_queue_purgeable);
+
 /*
  * The core wakeup function. Non-exclusive wakeups (nr_exclusive =3D=3D 0)=
 just
  * wake everything up. If it's an exclusive wakeup (nr_exclusive =3D=3D sm=
all +ve

--Sig_/4h0xwM5dugq.bFxoPNuUjZA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUx/INjnsnt1WYoG5AQJzoRAAnOEH+smOXSOfC7T4zb3Kq5y3xS1lldlP
C1EksoLoQsrX1ymH0gblWzt1YdZpX4Bs5uMqnkEvKXQLaBiRkPmSrz+eMtospkPQ
FbgtNSfAnKjygyZeyMDPm9BWKp/Nf2H0uMrc22hnNLkpeyNpm26kJzSz8TZMU6/N
yK3v3LiwAnru68LaP81erecKj+/FwQ2JO89P0aPbHAJEPs/exrVTXCgiOarx6xOP
L/1In/AyLcgTRSrX7YQBX8/O9kldt2Vt3saS3M7l9egJ7ilHuEaQ2woPHQT1u0AU
STzFVrjq7g+R9X8sGtO2W/ExMaH+ASZBICsGfCVYP3zall7jJKqlwero/ewXXUsq
6aIdRelaAmoiWCPKhFeePQLRRh4qRPbDHBIlzBrJGfs1fnX1HqGtG2T8VXiBY4++
OmILlAk3+iZMqiN24vHiDZlwKQQDE7IGM/XjFeXg+0IY0k1mhyivCbGuPXQzTyuV
cq5tC8ZUdyY/l4/nzyXxvJeaTgW1cYCjPw0Ozrf9LWtVtwpFQozjk52GeFH2xN8w
ePcs3tvJR7yXOtttIi7gW/ns+lhK9jqnxGVFfWHVY0D+fNs6C1zj+eUsJUt5Cd6c
8+FXDLDNoYrgXPDjto6OJfkcCVXhxCbJO2cZQ7/UXm8DCx4CZturHhqVjbOLZEb6
3XJ3qLSJxSk=
=KxDO
-----END PGP SIGNATURE-----

--Sig_/4h0xwM5dugq.bFxoPNuUjZA--
