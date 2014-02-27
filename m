Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbaB0GY7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 01:24:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57867 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbaB0GY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 01:24:57 -0500
Date: Thu, 27 Feb 2014 17:24:45 +1100
From: NeilBrown <neilb@suse.de>
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux RAID <linux-raid@vger.kernel.org>,
        "majianpeng" <majianpeng@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] md / procfs: avoid Oops if md-mod removed while
 /proc/mdstat is being polled.
Message-ID: <20140227172445.13644477@notabene.brown>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/go0y1zVCsVM/NqISGITolbd"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/go0y1zVCsVM/NqISGITolbd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable



If poll or select is waiting on /proc/mdstat when md-mod is unloaded
an oops will ensure when the poll/select completes.

This is because the wait_queue_head which is registered with poll_wait()
is local to the module and no longer exists when the poll completes and
detaches that wait_queue_head (in poll_free_wait -> remove_wait_queue).

To fix this we need the wait_queue_head to have (at least) the same life
time as the proc_dir_entry.  So this patch places it in that structure.

We:
  - add pde_poll_wait to struct proc_dir_entry
  - call poll_wait() passing this when poll() is called on the proc file
  - export a function proc_wake_up which will call wake_up() on pde_poll_wa=
it

and make use of all that in md.c

Reported-by: "majianpeng" <majianpeng@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>

--

Do we have a maintainer for fs/proc ??
If I could get a couple of Acks, or constructive comments, on this,
I would  appreciate it.
Thanks,
NeilBrown


diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4ad5cc4e63e8..1bf70d9c55d3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -193,12 +193,12 @@ EXPORT_SYMBOL_GPL(bio_clone_mddev);
  *  start array, stop array, error, add device, remove device,
  *  start build, activate spare
  */
-static DECLARE_WAIT_QUEUE_HEAD(md_event_waiters);
+static struct proc_dir_entry *mdstat_pde;
 static atomic_t md_event_count;
 void md_new_event(struct mddev *mddev)
 {
 	atomic_inc(&md_event_count);
-	wake_up(&md_event_waiters);
+	proc_wake_up(mdstat_pde);
 }
 EXPORT_SYMBOL_GPL(md_new_event);
=20
@@ -208,7 +208,7 @@ EXPORT_SYMBOL_GPL(md_new_event);
 static void md_new_event_inintr(struct mddev *mddev)
 {
 	atomic_inc(&md_event_count);
-	wake_up(&md_event_waiters);
+	proc_wake_up(mdstat_pde);
 }
=20
 /*
@@ -7187,8 +7187,6 @@ static unsigned int mdstat_poll(struct file *filp, po=
ll_table *wait)
 	struct seq_file *seq =3D filp->private_data;
 	int mask;
=20
-	poll_wait(filp, &md_event_waiters, wait);
-
 	/* always allow read */
 	mask =3D POLLIN | POLLRDNORM;
=20
@@ -8557,7 +8555,7 @@ static void md_geninit(void)
 {
 	pr_debug("md: sizeof(mdp_super_t) =3D %d\n", (int)sizeof(mdp_super_t));
=20
-	proc_create("mdstat", S_IRUGO, NULL, &md_seq_fops);
+	mdstat_pde =3D proc_create("mdstat", S_IRUGO, NULL, &md_seq_fops);
 }
=20
 static int __init md_init(void)
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index b7f268eb5f45..c579da4cd765 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -357,6 +357,7 @@ static struct proc_dir_entry *__proc_create(struct proc=
_dir_entry **parent,
 	atomic_set(&ent->count, 1);
 	spin_lock_init(&ent->pde_unload_lock);
 	INIT_LIST_HEAD(&ent->pde_openers);
+	init_waitqueue_head(&ent->pde_poll_wait);
 out:
 	return ent;
 }
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 124fc43c7090..353fc199e8b5 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -234,13 +234,21 @@ static unsigned int proc_reg_poll(struct file *file, =
struct poll_table_struct *p
 	unsigned int (*poll)(struct file *, struct poll_table_struct *);
 	if (use_pde(pde)) {
 		poll =3D pde->proc_fops->poll;
-		if (poll)
+		if (poll) {
+			poll_wait(file, &pde->pde_poll_wait, pts);
 			rv =3D poll(file, pts);
+		}
 		unuse_pde(pde);
 	}
 	return rv;
 }
=20
+void proc_wake_up(struct proc_dir_entry *pde)
+{
+	wake_up(&pde->pde_poll_wait);
+}
+EXPORT_SYMBOL_GPL(proc_wake_up);
+
 static long proc_reg_unlocked_ioctl(struct file *file, unsigned int cmd, u=
nsigned long arg)
 {
 	struct proc_dir_entry *pde =3D PDE(file_inode(file));
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 651d09a11dde..6f9f84eecded 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -46,6 +46,7 @@ struct proc_dir_entry {
 	struct completion *pde_unload_completion;
 	struct list_head pde_openers;	/* who did ->open, but not ->release */
 	spinlock_t pde_unload_lock; /* proc_fops checks and pde_users bumps */
+	wait_queue_head_t pde_poll_wait; /* For proc_reg_poll */
 	u8 namelen;
 	char name[];
 };
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 608e60a74c3c..a4a3d5f001ef 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -34,6 +34,7 @@ static inline struct proc_dir_entry *proc_create(
 	return proc_create_data(name, mode, parent, proc_fops, NULL);
 }
=20
+extern void proc_wake_up(struct proc_dir_entry *pde);
 extern void proc_set_size(struct proc_dir_entry *, loff_t);
 extern void proc_set_user(struct proc_dir_entry *, kuid_t, kgid_t);
 extern void *PDE_DATA(const struct inode *);

--Sig_/go0y1zVCsVM/NqISGITolbd
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUw7aLTnsnt1WYoG5AQK1Vw/9GY0co1BnJ4ceZzVAw+25O2ch9SQXKDij
hVzMQbJDNregPSTkmHhYQ4URr0W0qszFV6vaYOTyCBGb+1uYWRWemqHupp+wUgoJ
kZxsDBQwaDIX6gL6mZTIHGQqBbUSnoImgw1kNFiZB8OI1+gvVx9SeHAVmsYOaTyb
dGyfqdfAkiB/B+mDAvXIR9ma7a4y3b/p4h/QcTSozn2+5m263mlVCRbKqFI2WjSf
y/XTnYnQ1l8P5k7yQlLrf+2WjeR3Fua3X2YHrjp2n6ngjggp5TydwbvWxnfU1zol
2WM5wiDWCJWij/6KSuDldAlLRXYUNQcv/uKkhzE4gCZbhPsHZlguvpvGQOM4r4G2
XUTYm5ISvGqV1oU53mf50r9jmUROLWYVuytWJosAFOREeEfXj9RN3AYaHYKNnG/B
cnfj6f9s+3tSyJFRGtSiFDKWKZR3A5gFSAl2Ch6jGxwbGiSnWz6pDYkZjN/OvhxG
ii92U5/2qAmwgBfImGvXxZtvmc5n9yHkFMyBINXRRR/mD4n7xKnRLk9nziGn1AqL
Nt1eiZ9M7KJbwP8rGtYXyHU4z22Mp0s/wecW56ndayH6x9LnaCpT3DZ8czVX+/Gv
/BxEHtsCY1YQkK+Dg5yty5yhVhxh3MfpuJgVEAzxFdWafyTEIierPdnHZ74TVguF
/CcvLryUmlU=
=8/OW
-----END PGP SIGNATURE-----

--Sig_/go0y1zVCsVM/NqISGITolbd--
