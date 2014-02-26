Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbaBZHcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 02:32:15 -0500
Received: from ozlabs.org ([203.10.76.45]:45544 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbaBZHcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 02:32:13 -0500
Date: Wed, 26 Feb 2014 18:32:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the akpm-current tree with the ext3
 tree
Message-Id: <20140226183204.4ea7969f087360c565ac3d4e@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__26_Feb_2014_18_32_04_+1100_PFCBYfwc=c==r3VX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__26_Feb_2014_18_32_04_+1100_PFCBYfwc=c==r3VX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
fs/notify/fanotify/fanotify_user.c between commit ff57cd5863cf
("fsnotify: Allocate overflow events with proper type") from the ext3
tree and commit c40e3490382b ("fanotify: convert access_mutex to
spinlock") from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/notify/fanotify/fanotify_user.c
index 287a22c04149,c3406d633925..000000000000
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@@ -731,21 -690,9 +691,21 @@@ SYSCALL_DEFINE2(fanotify_init, unsigne
  	group->fanotify_data.user =3D user;
  	atomic_inc(&user->fanotify_listeners);
 =20
 +	oevent =3D kmem_cache_alloc(fanotify_event_cachep, GFP_KERNEL);
 +	if (unlikely(!oevent)) {
 +		fd =3D -ENOMEM;
 +		goto out_destroy_group;
 +	}
 +	group->overflow_event =3D &oevent->fse;
 +	fsnotify_init_event(group->overflow_event, NULL, FS_Q_OVERFLOW);
 +	oevent->tgid =3D get_pid(task_tgid(current));
 +	oevent->path.mnt =3D NULL;
 +	oevent->path.dentry =3D NULL;
 +
  	group->fanotify_data.f_flags =3D event_f_flags;
  #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
 +	oevent->response =3D 0;
- 	mutex_init(&group->fanotify_data.access_mutex);
+ 	spin_lock_init(&group->fanotify_data.access_lock);
  	init_waitqueue_head(&group->fanotify_data.access_waitq);
  	INIT_LIST_HEAD(&group->fanotify_data.access_list);
  	atomic_set(&group->fanotify_data.bypass_perm, 0);

--Signature=_Wed__26_Feb_2014_18_32_04_+1100_PFCBYfwc=c==r3VX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTDZh8AAoJEMDTa8Ir7ZwVSuEQAIYbKmcIxOm69xgB8ad4kKuF
vQ0MJFb3e1ytk7FOC+tJRO9OwpYeegmEtORwiGEVNdkgKrmN/qB/rM6cLdrJCKFR
BhqoovptyHrGtm7KQQxdRbKZAYmXxiKOV4YtV+qypt+qBoSqyRiYf5E7GYQzSKkZ
xCHdoJuX75QYp0Cbh+waoMy1e7NiOzSy/mmqUYUlZP6JB3IvL0Z1PoQzEOCGj1H7
/3XtZM44OenkWYjO7YpwwDF41Q7l2ud1M2J58NXnB5F8oiRLu02XPOvcEWIhehx+
qaDH4Gt4xKubaHbBdxueYuX7x/Sv3jhubSU3CM77GVQd5oLXN54+rbn+dN3CIeJI
d93OIruzFDe0B28WicNHnxB1VP/wLwT1XDNn3nCIpuhxiMobZIbpkVnJqL81VIr9
KaJl/dpl+yPTbOQMariowZivRbk/eicRGv9vqoj3lG8Zz+nxQWdwVTIBId8Gn1Q4
D3QG1mjFznBbo65SBpwhxWQCNcJTbJQURxUUas7HV+ugNGspkJ7cs2J6vclKPv1K
ZIe/FUqhXLDTs3FGKlMfwrTx9pGJlG4wlR5anXKJDBhHBAr+Vpath2n+vKgTgb7V
M93Aj8UJf2vuuvXWP3mAKLrOpriIhz0VOrV5skM7mNeTgAczKWLHYR9AydzfqvSR
OS4IKgav6lixpy8dTELY
=Zqvu
-----END PGP SIGNATURE-----

--Signature=_Wed__26_Feb_2014_18_32_04_+1100_PFCBYfwc=c==r3VX--
