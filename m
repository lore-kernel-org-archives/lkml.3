Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbaGQIE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 04:04:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44360 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754819AbaGQIEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 04:04:23 -0400
Date: Thu, 17 Jul 2014 18:04:14 +1000
From: NeilBrown <neilb@suse.de>
To: Ian Kent <raven@themaw.net>
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] autofs4: allow RCU-walk to walk through autofs4.
Message-ID: <20140717180414.2e2596d1@notabene.brown>
In-Reply-To: <1405573256.3002.25.camel@perseus.fritz.box>
References: <20140709233541.4525.25151.stgit@notabene.brown>
	<20140709234114.4525.46882.stgit@notabene.brown>
	<1405485857.2527.38.camel@perseus.fritz.box>
	<20140716155150.044c2ea3@notabene.brown>
	<1405493777.2527.72.camel@perseus.fritz.box>
	<1405573256.3002.25.camel@perseus.fritz.box>
X-Mailer: Claws Mail 3.10.1-123-gae895c (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/UhWAZHwk5YKXdx08TeedPTo"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/UhWAZHwk5YKXdx08TeedPTo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Jul 2014 13:00:56 +0800 Ian Kent <raven@themaw.net> wrote:

> On Wed, 2014-07-16 at 14:56 +0800, Ian Kent wrote:
> > > That looks a bit messy ... I wonder if we could have a new "ino" flag=
 which
> > > says "This dentry is mounted-on if it needs to be.  Gets set by ->loo=
kup
> > > and cleared by ->d_automount or when ->d_manage returns -EISDIR.
> >=20
> > At one point DCACHE_NEED_AUTOMOUNT and DCACHE_MANAGE_TRANSIT were
> > handled separately and DCACHE_NEED_AUTOMOUNT was cleared for rootless
> > multi-mount dentrys following a mount and set again at expire. Not
> > having to worry about managing that flag was also part of the
> > optimization.
> >=20
> > We could go back to managing DCACHE_NEED_AUTOMOUNT or add a new flag.
> > I'm not fussy how it's done as long as it works. IIRC there was one
> > quite convoluted if check (in the expire code) that was removed due to
> > the optimization.
>=20
> Umm ... using DCACHE_NEED_AUTOMOUNT rather than a new flag means using
> an additional lock so perhaps a new flag would be preferred since
> reducing lock overhead was the point of this.

Actually, I've managed to convince myself that there is nothing that needs
fixing here.

autofs4 already sets DCACHE_NEED_AUTOMOUNT on any directory that might need
to be mounted on.  It does this before the dentry is added to the dcache, so
before rcuwalk could possibly see the dentry.

If __follow_mount_rcu find that the dentry is d_mountpoint(), it will
follow down to the mounted directory, which is always correct.
If it isn't d_mountpoint, then lookup_fast, which is the only caller for
__follow_mount_rcu, will check if DCACHE_NEED_AUTOMOUNT is set, and if so
will goto unlazy, which drops back to refwalk and tries again.  So that is
always safe.

So it is currently either correct or safe.

I'm not 100% sure about the v4 code paths, but it seems OK.
If there some documentation about the interactions between the automountd a=
nd
the kernel?
It looks like:
 With V5, every name in the root directory gets something mounted on it,
      either another autofs or the target filesystem.
 With V4, you don't mount an autofs onto an autofs, but when a name in the
      root is automounted, all the names beneath there are created and the
      target filesystems are mounted before the top level automount is
      acknowledged.

Does that sound at all right (I suspect I haven't explained it very clearly=
).


Also I'd like to send a few of the simple patches to Andrew Morton now to g=
et
them out of the way.  Then the patches which need more thought and testing
can wait until we are ready.  I'm in no hurry - as long as there is
expectation of forward progress I don't need to target any particular relea=
se.

As well as the first two that you provided an Acked-by for, I'd like to send
akpm:

 - A revised version of the last patch which also avoids the spinlock for
   autofs4_lookup_active
 - A patch which removes some more unused 'inlines' from the header file.
 - a typo-fix.

I've included the changed one inline below.  If you are happy I'll send them
all to Andrew.

Thanks,
NeilBrown


=46rom 31b8be2565c72b053d0a92ec4fb2bfadd9545557 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Wed, 9 Jul 2014 12:33:15 +1000
Subject: [PATCH 1/3] autofs4: don't take spinlock when not needed in
 autofs4_lookup_expiring

If the expiring_list is empty, we can avoid a costly spinlock
in the rcu-walk path through autofs4_d_manage (once the rest
of the path becomes rcu-walk friendly).

Signed-off-by: NeilBrown <neilb@suse.de>
Acked-by: Ian Kent <raven@themaw.net>
---
 fs/autofs4/root.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index cc87c1abac97..fb202cadd4b3 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -166,8 +166,10 @@ static struct dentry *autofs4_lookup_active(struct den=
try *dentry)
 	const unsigned char *str =3D name->name;
 	struct list_head *p, *head;
=20
-	spin_lock(&sbi->lookup_lock);
 	head =3D &sbi->active_list;
+	if (list_empty(head))
+		return NULL;
+	spin_lock(&sbi->lookup_lock);
 	list_for_each(p, head) {
 		struct autofs_info *ino;
 		struct dentry *active;
@@ -218,8 +220,10 @@ static struct dentry *autofs4_lookup_expiring(struct d=
entry *dentry)
 	const unsigned char *str =3D name->name;
 	struct list_head *p, *head;
=20
-	spin_lock(&sbi->lookup_lock);
 	head =3D &sbi->expiring_list;
+	if (list_empty(head))
+		return NULL;
+	spin_lock(&sbi->lookup_lock);
 	list_for_each(p, head) {
 		struct autofs_info *ino;
 		struct dentry *expiring;
--=20
2.0.0

=46rom 7ea8366c9b2022e05c4a5bceee1d495bc6517bee Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Thu, 17 Jul 2014 14:49:37 +1000
Subject: [PATCH 2/3] AUTOFS: remove some unused inline functions.

{__,}manage_dentry_{set,clear}_{automount,transit}

are 4 unused inline functions.  Discard them.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 fs/autofs4/autofs_i.h | 49 -----------------------------------------------=
--
 1 file changed, 49 deletions(-)

diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index 22a280151e45..9e359fb20c0a 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -177,55 +177,6 @@ extern const struct file_operations autofs4_root_opera=
tions;
 extern const struct dentry_operations autofs4_dentry_operations;
=20
 /* VFS automount flags management functions */
-
-static inline void __managed_dentry_set_automount(struct dentry *dentry)
-{
-	dentry->d_flags |=3D DCACHE_NEED_AUTOMOUNT;
-}
-
-static inline void managed_dentry_set_automount(struct dentry *dentry)
-{
-	spin_lock(&dentry->d_lock);
-	__managed_dentry_set_automount(dentry);
-	spin_unlock(&dentry->d_lock);
-}
-
-static inline void __managed_dentry_clear_automount(struct dentry *dentry)
-{
-	dentry->d_flags &=3D ~DCACHE_NEED_AUTOMOUNT;
-}
-
-static inline void managed_dentry_clear_automount(struct dentry *dentry)
-{
-	spin_lock(&dentry->d_lock);
-	__managed_dentry_clear_automount(dentry);
-	spin_unlock(&dentry->d_lock);
-}
-
-static inline void __managed_dentry_set_transit(struct dentry *dentry)
-{
-	dentry->d_flags |=3D DCACHE_MANAGE_TRANSIT;
-}
-
-static inline void managed_dentry_set_transit(struct dentry *dentry)
-{
-	spin_lock(&dentry->d_lock);
-	__managed_dentry_set_transit(dentry);
-	spin_unlock(&dentry->d_lock);
-}
-
-static inline void __managed_dentry_clear_transit(struct dentry *dentry)
-{
-	dentry->d_flags &=3D ~DCACHE_MANAGE_TRANSIT;
-}
-
-static inline void managed_dentry_clear_transit(struct dentry *dentry)
-{
-	spin_lock(&dentry->d_lock);
-	__managed_dentry_clear_transit(dentry);
-	spin_unlock(&dentry->d_lock);
-}
-
 static inline void __managed_dentry_set_managed(struct dentry *dentry)
 {
 	dentry->d_flags |=3D (DCACHE_NEED_AUTOMOUNT|DCACHE_MANAGE_TRANSIT);
--=20
2.0.0

=46rom e1b74448bf2d0ab7e3c5d5b219d7a938bfd82d99 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Thu, 17 Jul 2014 14:58:08 +1000
Subject: [PATCH 3/3] AUTOFS: comment typo: remove a a doubled word.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 fs/autofs4/root.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index fb202cadd4b3..cdb25ebccc4c 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -377,7 +377,7 @@ static struct vfsmount *autofs4_d_automount(struct path=
 *path)
 		 * this because the leaves of the directory tree under the
 		 * mount never trigger mounts themselves (they have an autofs
 		 * trigger mount mounted on them). But v4 pseudo direct mounts
-		 * do need the leaves to to trigger mounts. In this case we
+		 * do need the leaves to trigger mounts. In this case we
 		 * have no choice but to use the list_empty() check and
 		 * require user space behave.
 		 */
--=20
2.0.0

=20

--Sig_/UhWAZHwk5YKXdx08TeedPTo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU8eDfjnsnt1WYoG5AQJ2wA//WPzVxC2rOYVopOA32DtrNJOlU6C/Ibrb
ehKjKUkPbV39KlspyJm4NsgpXUQVkCCi8cHMLF6DSS+2vQHdVSFzRFOmP+JfKjlg
gloZV5ZqIuG/pR7rXpivKePHuWzmZlcqe06qzqXGVBBPpQdILz9F4I9pH4altj96
ul006RvDInt+PCPR05yB7p9AMFKZRy1a+5jbqOCgb9Rr3+Vvw+u8CYISN6sulIhY
hC/CfAgBoty2etam2ZwC/L9H1W3HcILV5FR2bL7AC3MIhBmuDMYIibvCn3FUe2p8
84Bx5mr6k3MIlw0ymLNirS2aCKadkQzqhKmXA+gbtNagHnXFInDQg41lA5h0Mpju
CIt7dRTrv5FS+X5EB4M+2VcJaogv2C2abHM22NuaHtQaivbroPIPzihiUO/WwbFN
SCE/9tHK9qWJRsBoe8DmawlUSm5PHcH/tgvasGAji8YFx5OKmufj0e3S/rar4Vzj
Cd4lIMt0bEUK0TKlprlLcSW50YooMyvri0tbpxBSvzuaEoUvMxmOfUclOGV3VbLX
fgX/zok1d0n/wOiFqWqSOQkaQ6ukmyV44y1UcPeKFGgfClkFnbDKvNGjjzFBkj2X
ToARCtjvp7XW6pSZBMtOQ61Ag+Ym9bVVd/YLW07qDrc/ZeUvlDSp4vNdV/soU5Is
iQ0HhePxTAI=
=KERg
-----END PGP SIGNATURE-----

--Sig_/UhWAZHwk5YKXdx08TeedPTo--
