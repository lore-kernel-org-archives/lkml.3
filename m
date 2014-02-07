Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaBGQsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 11:48:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:38292 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbaBGQsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 11:48:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,801,1384329600"; 
   d="asc'?scan'208";a="471490366"
Message-ID: <1391791674.21697.2.camel@intelbox>
Subject: Re: intel_sdvo_init: trying to register non-static key
From: Imre Deak <imre.deak@intel.com>
Reply-To: imre.deak@intel.com
To: Borislav Petkov <bp@alien8.de>
Cc: Daniel Vetter <daniel@ffwll.ch>, Jani Nikula <jani.nikula@linux.intel.com>,
        intel-gfx@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Date: Fri, 07 Feb 2014 18:47:54 +0200
In-Reply-To: <20140207154911.GK24395@pd.tnic>
References: <20140207093205.GA24395@pd.tnic> <87d2iz18vi.fsf@intel.com>
	 <1391771542.5669.6.camel@intelbox> <20140207112809.GG24395@pd.tnic>
	 <20140207145149.GZ17001@phenom.ffwll.local>
	 <1391787126.5669.11.camel@intelbox> <20140207154911.GK24395@pd.tnic>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-6vlXWJ9hRpVp3iWWyqvy"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6vlXWJ9hRpVp3iWWyqvy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2014-02-07 at 16:49 +0100, Borislav Petkov wrote:
> On Fri, Feb 07, 2014 at 05:32:06PM +0200, Imre Deak wrote:
> > I just realized it's a different issue, since it's on the init path.
> > Also we set the drm device as the parent for the sdvo i2c adapter as
> > opposed to the dp i2c adapter where it's the connector device. So the
> > above patch won't help in Borislav's case.

Ok, not sure why the sdvo initialization fails, but the lockdep warning
is probably fixed by the below patch. Could you try it and send a dmesg
with drm.debug=3D0xe?

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 5104cf5..bd6e18b 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -187,19 +187,23 @@ static void kernfs_deactivate(struct kernfs_node
*kn)
=20
 	kn->u.completion =3D (void *)&wait;
=20
-	rwsem_acquire(&kn->dep_map, 0, 0, _RET_IP_);
+	if (kn->flags & KERNFS_LOCKDEP)
+		rwsem_acquire(&kn->dep_map, 0, 0, _RET_IP_);
 	/* atomic_add_return() is a mb(), put_active() will always see
 	 * the updated kn->u.completion.
 	 */
 	v =3D atomic_add_return(KN_DEACTIVATED_BIAS, &kn->active);
=20
 	if (v !=3D KN_DEACTIVATED_BIAS) {
-		lock_contended(&kn->dep_map, _RET_IP_);
+		if (kn->flags & KERNFS_LOCKDEP)
+			lock_contended(&kn->dep_map, _RET_IP_);
 		wait_for_completion(&wait);
 	}
=20
-	lock_acquired(&kn->dep_map, _RET_IP_);
-	rwsem_release(&kn->dep_map, 1, _RET_IP_);
+	if (kn->flags & KERNFS_LOCKDEP) {
+		lock_acquired(&kn->dep_map, _RET_IP_);
+		rwsem_release(&kn->dep_map, 1, _RET_IP_);
+	}
 }
=20



--=-6vlXWJ9hRpVp3iWWyqvy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJS9Q46AAoJEORIIAnNuWDFgyIH/2l0DhaHdIJ07uwLz09CMhw5
AAdb4nZF0Lgys6f/+rZdxZtcmMY4yNW6K4H2faiCwdNB6exgZGkaY8U3YOt+WDq1
n/p0/Gvuaz17ZUQHB4tod3Rp4uKbrrk9S3S3/AxxvCHmhZAS3kYAJOA4L8EPDGMK
U58BbSIDM005GmH+UTcVVEMXyTp7fjDF8TUZFzR/JGLDwm+fCAeVmjpMkSGLHuAm
KtvGGbKiOjNiHiNq+jekySv0zYRwdpZn1nJF7rxES7glStZmP2ctXPhcuXvWRIy6
BAtTG2xSJqCkDrrfrID9j5J3gTCea/NH/3XsyBAR/Gl1BfqBrYvrQy9HfMpkeFU=
=3pxW
-----END PGP SIGNATURE-----

--=-6vlXWJ9hRpVp3iWWyqvy--

