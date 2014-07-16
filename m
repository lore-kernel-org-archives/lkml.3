Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934396AbaGPFwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 01:52:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36635 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934383AbaGPFwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 01:52:00 -0400
Date: Wed, 16 Jul 2014 15:51:50 +1000
From: NeilBrown <neilb@suse.de>
To: Ian Kent <raven@themaw.net>
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] autofs4: allow RCU-walk to walk through autofs4.
Message-ID: <20140716155150.044c2ea3@notabene.brown>
In-Reply-To: <1405485857.2527.38.camel@perseus.fritz.box>
References: <20140709233541.4525.25151.stgit@notabene.brown>
	<20140709234114.4525.46882.stgit@notabene.brown>
	<1405485857.2527.38.camel@perseus.fritz.box>
X-Mailer: Claws Mail 3.10.1-123-gae895c (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/ld+yfUcABObObzU=Jv40KfB"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ld+yfUcABObObzU=Jv40KfB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 16 Jul 2014 12:44:17 +0800 Ian Kent <raven@themaw.net> wrote:

> On Thu, 2014-07-10 at 09:41 +1000, NeilBrown wrote:
> > Any attempt to look up a pathname that passes though an
> > autofs4 mount is currently forced out of RCU-walk into
> > REF-walk.
> >=20
> > This can significantly hurt performance of many-thread work
> > loads on many-core systems, especially if the automounted
> > filesystem supports RCU-walk but doesn't get to benefit from
> > it.
> >=20
> > So if autofs4_d_manage is called with rcu_walk set, only
> > fail with -ECHILD if it is necessary to wait longer than
> > a spinlock, and avoid even the spinlock in one trivial case.
>=20
> I've looked more closely at this one now and mostly it looks good to me.
>=20
> But I'm probably a bit slow, there's just one place where I can't work
> out the reasoning ....
>=20
> >=20
> > Signed-off-by: NeilBrown <neilb@suse.de>
> > ---
> >  fs/autofs4/autofs_i.h  |    2 +-
> >  fs/autofs4/dev-ioctl.c |    2 +-
> >  fs/autofs4/expire.c    |    4 +++-
> >  fs/autofs4/root.c      |   44 +++++++++++++++++++++++++++++-----------=
----
> >  4 files changed, 34 insertions(+), 18 deletions(-)
> >=20
> > diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
> > index 22a280151e45..99dbb05d6148 100644
> > --- a/fs/autofs4/autofs_i.h
> > +++ b/fs/autofs4/autofs_i.h
> > @@ -148,7 +148,7 @@ void autofs4_free_ino(struct autofs_info *);
> > =20
> >  /* Expiration */
> >  int is_autofs4_dentry(struct dentry *);
> > -int autofs4_expire_wait(struct dentry *dentry);
> > +int autofs4_expire_wait(struct dentry *dentry, int rcu_walk);
> >  int autofs4_expire_run(struct super_block *, struct vfsmount *,
> >  			struct autofs_sb_info *,
> >  			struct autofs_packet_expire __user *);
> > diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
> > index 5b570b6efa28..aaf96cb25452 100644
> > --- a/fs/autofs4/dev-ioctl.c
> > +++ b/fs/autofs4/dev-ioctl.c
> > @@ -450,7 +450,7 @@ static int autofs_dev_ioctl_requester(struct file *=
fp,
> >  	ino =3D autofs4_dentry_ino(path.dentry);
> >  	if (ino) {
> >  		err =3D 0;
> > -		autofs4_expire_wait(path.dentry);
> > +		autofs4_expire_wait(path.dentry, 0);
> >  		spin_lock(&sbi->fs_lock);
> >  		param->requester.uid =3D from_kuid_munged(current_user_ns(), ino->ui=
d);
> >  		param->requester.gid =3D from_kgid_munged(current_user_ns(), ino->gi=
d);
> > diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
> > index a7be57e39be7..7e2f22ce6954 100644
> > --- a/fs/autofs4/expire.c
> > +++ b/fs/autofs4/expire.c
> > @@ -467,7 +467,7 @@ found:
> >  	return expired;
> >  }
> > =20
> > -int autofs4_expire_wait(struct dentry *dentry)
> > +int autofs4_expire_wait(struct dentry *dentry, int rcu_walk)
> >  {
> >  	struct autofs_sb_info *sbi =3D autofs4_sbi(dentry->d_sb);
> >  	struct autofs_info *ino =3D autofs4_dentry_ino(dentry);
> > @@ -477,6 +477,8 @@ int autofs4_expire_wait(struct dentry *dentry)
> >  	spin_lock(&sbi->fs_lock);
> >  	if (ino->flags & AUTOFS_INF_EXPIRING) {
> >  		spin_unlock(&sbi->fs_lock);
> > +		if (rcu_walk)
> > +			return -ECHILD;
> > =20
> >  		DPRINTK("waiting for expire %p name=3D%.*s",
> >  			 dentry, dentry->d_name.len, dentry->d_name.name);
> > diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
> > index cc87c1abac97..1ad119407e2f 100644
> > --- a/fs/autofs4/root.c
> > +++ b/fs/autofs4/root.c
> > @@ -208,7 +208,8 @@ next:
> >  	return NULL;
> >  }
> > =20
> > -static struct dentry *autofs4_lookup_expiring(struct dentry *dentry)
> > +static struct dentry *autofs4_lookup_expiring(struct dentry *dentry,
> > +					      bool rcu_walk)
> >  {
> >  	struct autofs_sb_info *sbi =3D autofs4_sbi(dentry->d_sb);
> >  	struct dentry *parent =3D dentry->d_parent;
> > @@ -225,6 +226,11 @@ static struct dentry *autofs4_lookup_expiring(stru=
ct dentry *dentry)
> >  		struct dentry *expiring;
> >  		struct qstr *qstr;
> > =20
> > +		if (rcu_walk) {
> > +			spin_unlock(&sbi->lookup_lock);
> > +			return ERR_PTR(-ECHILD);
> > +		}
> > +
> >  		ino =3D list_entry(p, struct autofs_info, expiring);
> >  		expiring =3D ino->dentry;
> > =20
> > @@ -260,13 +266,15 @@ next:
> >  	return NULL;
> >  }
> > =20
> > -static int autofs4_mount_wait(struct dentry *dentry)
> > +static int autofs4_mount_wait(struct dentry *dentry, bool rcu_walk)
> >  {
> >  	struct autofs_sb_info *sbi =3D autofs4_sbi(dentry->d_sb);
> >  	struct autofs_info *ino =3D autofs4_dentry_ino(dentry);
> >  	int status =3D 0;
> > =20
> >  	if (ino->flags & AUTOFS_INF_PENDING) {
> > +		if (rcu_walk)
> > +			return -ECHILD;
> >  		DPRINTK("waiting for mount name=3D%.*s",
> >  			dentry->d_name.len, dentry->d_name.name);
> >  		status =3D autofs4_wait(sbi, dentry, NFY_MOUNT);
> > @@ -276,20 +284,22 @@ static int autofs4_mount_wait(struct dentry *dent=
ry)
> >  	return status;
> >  }
> > =20
> > -static int do_expire_wait(struct dentry *dentry)
> > +static int do_expire_wait(struct dentry *dentry, bool rcu_walk)
> >  {
> >  	struct dentry *expiring;
> > =20
> > -	expiring =3D autofs4_lookup_expiring(dentry);
> > +	expiring =3D autofs4_lookup_expiring(dentry, rcu_walk);
> > +	if (IS_ERR(expiring))
> > +		return PTR_ERR(expiring);
> >  	if (!expiring)
> > -		return autofs4_expire_wait(dentry);
> > +		return autofs4_expire_wait(dentry, rcu_walk);
> >  	else {
> >  		/*
> >  		 * If we are racing with expire the request might not
> >  		 * be quite complete, but the directory has been removed
> >  		 * so it must have been successful, just wait for it.
> >  		 */
> > -		autofs4_expire_wait(expiring);
> > +		autofs4_expire_wait(expiring, 0);
> >  		autofs4_del_expiring(expiring);
> >  		dput(expiring);
> >  	}
> > @@ -341,7 +351,7 @@ static struct vfsmount *autofs4_d_automount(struct =
path *path)
> >  	 * and the directory was removed, so just go ahead and try
> >  	 * the mount.
> >  	 */
> > -	status =3D do_expire_wait(dentry);
> > +	status =3D do_expire_wait(dentry, 0);
> >  	if (status && status !=3D -EAGAIN)
> >  		return NULL;
> > =20
> > @@ -349,7 +359,7 @@ static struct vfsmount *autofs4_d_automount(struct =
path *path)
> >  	spin_lock(&sbi->fs_lock);
> >  	if (ino->flags & AUTOFS_INF_PENDING) {
> >  		spin_unlock(&sbi->fs_lock);
> > -		status =3D autofs4_mount_wait(dentry);
> > +		status =3D autofs4_mount_wait(dentry, 0);
> >  		if (status)
> >  			return ERR_PTR(status);
> >  		goto done;
> > @@ -390,7 +400,7 @@ static struct vfsmount *autofs4_d_automount(struct =
path *path)
> >  		}
> >  		ino->flags |=3D AUTOFS_INF_PENDING;
> >  		spin_unlock(&sbi->fs_lock);
> > -		status =3D autofs4_mount_wait(dentry);
> > +		status =3D autofs4_mount_wait(dentry, 0);
> >  		spin_lock(&sbi->fs_lock);
> >  		ino->flags &=3D ~AUTOFS_INF_PENDING;
> >  		if (status) {
> > @@ -426,21 +436,25 @@ static int autofs4_d_manage(struct dentry *dentry=
, bool rcu_walk)
> >  		return 0;
> >  	}
> > =20
> > -	/* We need to sleep, so we need pathwalk to be in ref-mode */
> > -	if (rcu_walk)
> > -		return -ECHILD;
> > -
> >  	/* Wait for pending expires */
> > -	do_expire_wait(dentry);
> > +	if (do_expire_wait(dentry, rcu_walk) =3D=3D -ECHILD)
> > +		return -ECHILD;
> > =20
> >  	/*
> >  	 * This dentry may be under construction so wait on mount
> >  	 * completion.
> >  	 */
> > -	status =3D autofs4_mount_wait(dentry);
> > +	status =3D autofs4_mount_wait(dentry, rcu_walk);
> >  	if (status)
> >  		return status;
> > =20
> > +	if (rcu_walk)
> > +		/* No need to consider returning -EISDIR as
> > +		 * there is no risk that ->d_automount will
> > +		 * be called
> > +		 */
> > +		return status;
> > +
>=20
> This bit here.
>=20
> The test below says (accepting that d_mountpoint() is unreliable in a
> multi-namespace environment and needs to be fixed), if this dentry isn't
> being expired and it's not a mount and the directory isn't empty then we
> can walk straight through the dentry.
>=20
> For certain automount map constructs it's possible for a dentry that is
> not itself a mount point to be expired in the same way a mount or mount
> tree is expired.
>=20
> What's the thinking behind this one please?

I admit that I don't fully understand the role of -EISDIR being returned by
d_manage.
However the comment below suggests that it is an optimisation.  It tells the
VFS not to even bother calling ->d_automount on this dentry.
In RCU-walk this doesn't apply.  ->d_automount will not be called if
->d_manage returns zero.  So the optimisation is not needed.

I might have missed a subtlety here but it looks like:

in rcu_walk mode:
   ->d_manage returns zero if everything is stable, no automount is
                      needed, and nothing is expiring
        and returns non-zero (-ECHILD) if anything doesn't quite look right
        and we need to re-try with in refwalk mode with spinlocks etc.

while in refwalk mode:
   ->d_manage returns zero, possibly after waiting, if everything looks
        stable and ->d_automount is needed
     or it returns -EISDIR if the dentry never needs automounting

So while the 'success' condition is similar, the 'error' case is quite
different.  The errors that make sense in one case don't make sense in the
other.

So this patch fragment is avoiding a refwalk error return in the rcuwalk ca=
se.

On reflection, there might be something wrong here.
If a dentry should eventually be mounted on but isn't yet, ->d_manage needs
to fail.
So if !d_mountpoint and simple_empty(), maybe d_manage should fail in rcuwa=
lk
mode.
That looks a bit messy ... I wonder if we could have a new "ino" flag which
says "This dentry is mounted-on if it needs to be.  Gets set by ->lookup
and cleared by ->d_automount or when ->d_manage returns -EISDIR.
Then set again when it expires.
I'll probably have to understand the code more deeply before I can be sure.

Thanks,
NeilBrown


>=20
> >  	spin_lock(&sbi->fs_lock);
> >  	/*
> >  	 * If the dentry has been selected for expire while we slept
> >=20
> >=20
>=20


--Sig_/ld+yfUcABObObzU=Jv40KfB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU8YS9jnsnt1WYoG5AQIStw//aZ/8EHmHpQcTBHSds9sLAqBfRhQrgIIS
T48ASfTaPpVhW2j+PWxFvtJj6DkXXSM+4BOQcKbUDdhyiVIr0V+WhtJCBUD/vvGK
Q4ksmLzlHj8lc7hZHm4ph+bX4dQfeJlSMzDnKnoLNPqkvas8Y+hkf7jU+ek5EvFN
a3s3EC6t46yow6vEb0/KUFRFyS8qOgpOqyrYAmJ5b5ZWHAKeU/ZRxVVi07DinwcC
CJnIscreN7FamWTznbzF+e7ahx7b+ZatK9wMDlDRmpnZYtBc3vnoRUyBh142ZLLX
3xzJVMkXe2I1sIfXs7ua6KrgPpemG6Kx+oDKs1h73dYlMq9QQ83lp5h9DKUzQnSx
LJfY+uE99OCBT/8p7uOyyU45zL/wSdfw5LC3hTjxtusIuj6ATiTz7yGfGN69LnKA
Rsom6KJY0eR1fL+YHBcx7p2OxP4KUQj4SeW43kttPeQ7vqrtrjG+V3hgJvW4Tp0b
ogyBufyJWN+8oim8NIC7NguUgQ4JvuFu8lNc1ej3wAzVOmQfOzvKdwZrR9/UTfiG
lOekg7nWjudIThfccODmZvvM6AR+GlKiBzwSoG3IqxyMYmcCagaVVgg7zTxs4MOa
xNf0asJcIxFHD69GJNT/nPJxRhMOqcAss1WuxXy17JtPJnK4Job4HLJ9E+Ho+pjD
d9LrlnWqyV4=
=eF1x
-----END PGP SIGNATURE-----

--Sig_/ld+yfUcABObObzU=Jv40KfB--
