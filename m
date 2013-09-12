Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab3ILEo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 00:44:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43347 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661Ab3ILEo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 00:44:27 -0400
Date: Thu, 12 Sep 2013 14:44:14 +1000
From: NeilBrown <neilb@suse.de>
To: ycbzzjlby@gmail.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bian Yu <bianyu@kedacom.com>
Subject: Re: [PATCH v2] md/raid5: avoid deadlock when raid5 array has unack
 badblocks during md_stop_writes.
Message-ID: <20130912144414.53fb8727@notabene.brown>
In-Reply-To: <1378098595-11536-1-git-send-email-ycbzzjlby@gmail.com>
References: <1378098595-11536-1-git-send-email-ycbzzjlby@gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/J3YKB/oNp9C+LODG00mya7Y"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/J3YKB/oNp9C+LODG00mya7Y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon,  2 Sep 2013 01:09:55 -0400 ycbzzjlby@gmail.com wrote:

> From: Bian Yu <bianyu@kedacom.com>
>=20
> When raid5 hit a fresh badblock, this badblock will flagged as unack
> badblock until md_update_sb is called.
> But md_stop/reboot/md_set_readonly will avoid raid5d call md_update_sb
> in md_check_recovery, the badblock will always be unack, so raid5d
> thread enter a infinite loop and never can unregister sync_thread
> that cause deadlock.
>=20
> To solve this, before md_stop_writes call md_unregister_thread, set
> MD_STOPPING_WRITES on mddev->flags. In raid5.c analyse_stripe judge
> MD_STOPPING_WRITES bit on mddev->flags, if setted don't block rdev
> to wait md_update_sb. so raid5d thread can be stopped.
>=20
> I can reproduce it by using follow way:
> When raid5 array is recovering and hit a fresh badblock, then shutdown ar=
ray at once.
>=20
> [  480.850203]       Not tainted 3.11.0-next-20130906+ #4
> [  480.852344] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
> [  480.854380]  [<ffffffff8153b324>] md_do_sync+0x7e4/0xe60
> [  480.854386]  [<ffffffff81747fcb>] ? _raw_spin_unlock_irq+0x2b/0x40
> [  480.854395]  [<ffffffff81536fa0>] ? md_unregister_thread+0x90/0x90
> [  480.854400]  [<ffffffff810a716d>] ? trace_hardirqs_on+0xd/0x10
> [  480.854405]  [<ffffffff815370bf>] md_thread+0x11f/0x170
> [  480.854410]  [<ffffffff81536fa0>] ? md_unregister_thread+0x90/0x90
> [  480.854415]  [<ffffffff8106d956>] kthread+0xd6/0xe0
> [  480.854423]  [<ffffffff8106d880>] ? __init_kthread_worker+0x70/0x70
> [  480.854428]  [<ffffffff8174ff2c>] ret_from_fork+0x7c/0xb0
> [  480.854432]  [<ffffffff8106d880>] ? __init_kthread_worker+0x70/0x70
> [  480.854435] no locks held by md0_resync/3246.
> [  480.854437] INFO: task mdadm:3257 blocked for more than 120 seconds.
> [  480.854438]       Not tainted 3.11.0-next-20130906+ #4
> [  480.854439] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
> [  480.854442] mdadm           D 0000000000000000  5024  3257   3209 0x00=
000080
> [  480.854445]  ffff880138c37b18 0000000000000046 00000000ffffffff ffff88=
0037d3b120
> [  480.854447]  ffff88013a038720 ffff88013a038000 0000000000013500 ffff88=
0138c37fd8
> [  480.854449]  ffff880138c36010 0000000000013500 0000000000013500 ffff88=
0138c37fd8
> [  480.854449] Call Trace:
> [  480.854452]  [<ffffffff81745fa4>] schedule+0x24/0x70
> [  480.854453]  [<ffffffff81742725>] schedule_timeout+0x175/0x200
> [  480.854455]  [<ffffffff810a6d30>] ? mark_held_locks+0x80/0x130
> [  480.854457]  [<ffffffff81747fcb>] ? _raw_spin_unlock_irq+0x2b/0x40
> [  480.854459]  [<ffffffff810a709d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
> [  480.854461]  [<ffffffff810a716d>] ? trace_hardirqs_on+0xd/0x10
> [  480.854463]  [<ffffffff81746600>] wait_for_completion+0xa0/0x110
> [  480.854465]  [<ffffffff8107d160>] ? try_to_wake_up+0x300/0x300
> [  480.854467]  [<ffffffff8106ddbc>] kthread_stop+0x4c/0xe0
> [  480.854468]  [<ffffffff81536f5e>] md_unregister_thread+0x4e/0x90
> [  480.854470]  [<ffffffff8153965d>] md_reap_sync_thread+0x1d/0x140
> [  480.854472]  [<ffffffff815397ab>] __md_stop_writes+0x2b/0x80
> [  480.854473]  [<ffffffff8153c911>] do_md_stop+0x91/0x4d0
> [  480.854475]  [<ffffffff8153e8a7>] ? md_ioctl+0xf7/0x15c0
> [  480.854477]  [<ffffffff810a716d>] ? trace_hardirqs_on+0xd/0x10
> [  480.854479]  [<ffffffff8153f6a9>] md_ioctl+0xef9/0x15c0
> [  480.854481]  [<ffffffff8113145d>] ? handle_mm_fault+0x17d/0x920
>=20
> Signed-off-by: Bian Yu <bianyu@kedacom.com>
> ---
>  drivers/md/md.c    |    2 ++
>  drivers/md/md.h    |    4 ++++
>  drivers/md/raid5.c |    3 ++-
>  3 files changed, 8 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index adf4d7e..54ef71f 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5278,6 +5278,7 @@ static void md_clean(struct mddev *mddev)
>  static void __md_stop_writes(struct mddev *mddev)
>  {
>  	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> +	set_bit(MD_STOPPING_WRITES, &mddev->flags);
>  	if (mddev->sync_thread) {
>  		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>  		md_reap_sync_thread(mddev);
> @@ -5294,6 +5295,7 @@ static void __md_stop_writes(struct mddev *mddev)
>  		mddev->in_sync =3D 1;
>  		md_update_sb(mddev, 1);
>  	}
> +	clear_bit(MD_STOPPING_WRITES, &mddev->flags);
>  }
> =20
>  void md_stop_writes(struct mddev *mddev)
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 608050c..a24ae1d 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -214,6 +214,10 @@ struct mddev {
>  #define MD_STILL_CLOSED	4	/* If set, then array has not been opened since
>  				 * md_ioctl checked on it.
>  				 */
> +#define MD_STOPPING_WRITES 5	/* If set, raid5 shouldn't set unacknowledg=
ed
> +				 * badblock blocked in analyse_stripe to avoid
> +				 * infinite loop.
> +				 */
> =20
>  	int				suspended;
>  	atomic_t			active_io;
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index f9972e2..ff1aecf 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3446,7 +3446,8 @@ static void analyse_stripe(struct stripe_head *sh, =
struct stripe_head_state *s)
>  		if (rdev) {
>  			is_bad =3D is_badblock(rdev, sh->sector, STRIPE_SECTORS,
>  					     &first_bad, &bad_sectors);
> -			if (s->blocked_rdev =3D=3D NULL
> +			if (!test_bit(MD_STOPPING_WRITES, &conf->mddev->flags)
> +			    && s->blocked_rdev =3D=3D NULL
>  			    && (test_bit(Blocked, &rdev->flags)
>  				|| is_bad < 0)) {
>  				if (is_bad < 0)


Thanks for including the extra details in the patch, but it wasn't only that
I didn't think it should be needed (I was wrong there).  I also don't like
the patch.  It isn't at all clear to me that it will do the right thing.
There is a reason that we block until the bad block lists has been updated,
and to just not block because it is inconvenient just doesn't seem right.

I would rather change the sequencing so that the badblock list can be updat=
ed
at this point.
Something like that patch below, but I'm not 100% sure of it yet and I'm
about to go on leave so I'm not sure I'll be able to commit to it for a whi=
le.

If you could review and test I would appreciate it.

Thanks,
NeilBrown

diff --git a/drivers/md/md.c b/drivers/md/md.c
index adf4d7e..e4d78c0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3170,6 +3170,9 @@ rdev_attr_store(struct kobject *kobj, struct attribut=
e *attr,
 		return -EACCES;
 	rv =3D mddev ? mddev_lock(mddev): -EBUSY;
 	if (!rv) {
+		mutex_lock(&mddev->open_mutex);
+		clear_bit(MD_STILL_CLOSED, &mddev->flags);
+		mutex_unlock(&mddev->open_mutex);
 		if (rdev->mddev =3D=3D NULL)
 			rv =3D -EBUSY;
 		else
@@ -4764,6 +4767,9 @@ md_attr_store(struct kobject *kobj, struct attribute =
*attr,
 		flush_workqueue(md_misc_wq);
 	rv =3D mddev_lock(mddev);
 	if (!rv) {
+		mutex_lock(&mddev->open_mutex);
+		clear_bit(MD_STILL_CLOSED, &mddev->flags);
+		mutex_unlock(&mddev->open_mutex);
 		rv =3D entry->store(mddev, page, length);
 		mddev_unlock(mddev);
 	}
@@ -5279,8 +5285,10 @@ static void __md_stop_writes(struct mddev *mddev)
 {
 	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 	if (mddev->sync_thread) {
+		mddev_unlock(&mddev);
 		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 		md_reap_sync_thread(mddev);
+		mddev_lock(&mddev);
 	}
=20
 	del_timer_sync(&mddev->safemode_timer);
@@ -5337,7 +5345,9 @@ static int md_set_readonly(struct mddev *mddev, struc=
t block_device *bdev)
 		err =3D -EBUSY;
 		goto out;
 	}
-	if (bdev && !test_bit(MD_STILL_CLOSED, &mddev->flags)) {
+	if (mddev->pers)
+		__md_stop_writes(mddev);
+	if (!test_bit(MD_STILL_CLOSED, &mddev->flags)) {
 		/* Someone opened the device since we flushed it
 		 * so page cache could be dirty and it is too late
 		 * to flush.  So abort
@@ -5346,8 +5356,6 @@ static int md_set_readonly(struct mddev *mddev, struc=
t block_device *bdev)
 		return -EBUSY;
 	}
 	if (mddev->pers) {
-		__md_stop_writes(mddev);
-
 		err  =3D -ENXIO;
 		if (mddev->ro=3D=3D1)
 			goto out;
@@ -5379,7 +5387,9 @@ static int do_md_stop(struct mddev * mddev, int mode,
 		mutex_unlock(&mddev->open_mutex);
 		return -EBUSY;
 	}
-	if (bdev && !test_bit(MD_STILL_CLOSED, &mddev->flags)) {
+	if (mddev->pers)
+		__md_stop_writes(mddev);
+	if (!test_bit(MD_STILL_CLOSED, &mddev->flags)) {
 		/* Someone opened the device since we flushed it
 		 * so page cache could be dirty and it is too late
 		 * to flush.  So abort
@@ -5391,7 +5401,6 @@ static int do_md_stop(struct mddev * mddev, int mode,
 		if (mddev->ro)
 			set_disk_ro(disk, 0);
=20
-		__md_stop_writes(mddev);
 		__md_stop(mddev);
 		mddev->queue->merge_bvec_fn =3D NULL;
 		mddev->queue->backing_dev_info.congested_fn =3D NULL;

--Sig_/J3YKB/oNp9C+LODG00mya7Y
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUjFGnjnsnt1WYoG5AQJKFQ//UDDDxB6o1LxyVPMe9YRphg+hnpawaru8
UdPs5SsIcuSppuWm81V/b5n3JLlv6APvgIc+nHoJjjv+odaoT2mem6uxYjIn98xn
YZFYY24udjxOA6Jab1yPbl/yRm7u6dt7cD08pn68TPT6qrK6WoBPkb+t+/8vv08u
FKs/tO3ITiK9PFxbFyzGx4ZFmZnnMZL+L3H9lfSmiNmifjMlTsUlO4cB457RSDXt
WrQtwq2P4KZdXnk5LAIMqLj+FBpjLCZHE1fVVQlSfhmBXwxIksOlsizWtskF/U04
c7dw5qdva+ijdhe9Jy5eUQgrxITlbGQMnrPUgObJq6FIATLrUYJgDa3OrFlVj+NW
/DAOBWUErVdC3eL7wdqz5VoSl5Gd4+c1Bn+G/GB/Lm0TfL9FK8rEHEuOG0rIN18r
hf6dZ+pw989n3WLUehWlR60vpZ+vkLMMJZUcCM31Piko+IoC3J38E+MLOemKtKSS
gEK4aeH2SkdDlxTVlgQDUvTi8R7Mj6ttwS1QUA6lKglNKPsbiPviy4gH9TiDGVlf
iuqIIctSWDC/Ikid9boyM7tEmKGn44B2FUqjH2MThXHPfZgaNc7Xk+uxrG1LnMTs
Cp7j0NK/4Hcia/0/F2SCyt7b00oJnQqtG2WeqArKRxSPQZPjXDqJfWZdaXyU2FZp
++Qf/qFF2bA=
=RKaG
-----END PGP SIGNATURE-----

--Sig_/J3YKB/oNp9C+LODG00mya7Y--
