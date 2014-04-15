Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbaDOB0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 21:26:48 -0400
Received: from ozlabs.org ([103.22.144.67]:38126 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaDOB0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 21:26:46 -0400
Date: Tue, 15 Apr 2014 11:26:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@intel.com>,
        Ville =?UTF-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Subject: linux-next: manual merge of the drm-intel tree with the  tree
Message-Id: <20140415112638.6c05845b810c49702985bc2f@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__15_Apr_2014_11_26_38_+1000_BPnAXbClhMGv4s.d"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__15_Apr_2014_11_26_38_+1000_BPnAXbClhMGv4s.d
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-intel tree got a conflict in
drivers/gpu/drm/i915/i915_gem_context.c between commit 691e6415c891
("drm/i915: Always use kref tracking for all contexts") from the
drm-intel-fixes tree and commit ad2ac08bf34b ("drm/i915: Make contexts
non-snooped on non-LLC platforms") from the drm-intel tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/i915_gem_context.c
index d72db15afa02,30b355afb362..000000000000
--- a/drivers/gpu/drm/i915/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/i915_gem_context.c
@@@ -231,32 -232,40 +231,40 @@@ __create_hw_context(struct drm_device *
  		return ERR_PTR(-ENOMEM);
 =20
  	kref_init(&ctx->ref);
 -	ctx->obj =3D i915_gem_alloc_object(dev, dev_priv->hw_context_size);
 -	INIT_LIST_HEAD(&ctx->link);
 -	if (ctx->obj =3D=3D NULL) {
 -		kfree(ctx);
 -		DRM_DEBUG_DRIVER("Context object allocated failed\n");
 -		return ERR_PTR(-ENOMEM);
 -	}
 +	list_add_tail(&ctx->link, &dev_priv->context_list);
 =20
 -	/*
 -	 * Try to make the context utilize L3 as well as LLC.
 -	 *
 -	 * On VLV we don't have L3 controls in the PTEs so we
 -	 * shouldn't touch the cache level, especially as that
 -	 * would make the object snooped which might have a
 -	 * negative performance impact.
 -	 */
 -	if (INTEL_INFO(dev)->gen >=3D 7 && !IS_VALLEYVIEW(dev)) {
 -		ret =3D i915_gem_object_set_cache_level(ctx->obj,
 -						      I915_CACHE_L3_LLC);
 -		/* Failure shouldn't ever happen this early */
 -		if (WARN_ON(ret))
 +	if (dev_priv->hw_context_size) {
 +		ctx->obj =3D i915_gem_alloc_object(dev, dev_priv->hw_context_size);
 +		if (ctx->obj =3D=3D NULL) {
 +			ret =3D -ENOMEM;
  			goto err_out;
 -	}
 +		}
 =20
- 		if (INTEL_INFO(dev)->gen >=3D 7) {
 -	list_add_tail(&ctx->link, &dev_priv->context_list);
++		/*
++		 * Try to make the context utilize L3 as well as LLC.
++		 *
++		 * On VLV we don't have L3 controls in the PTEs so we
++		 * shouldn't touch the cache level, especially as that
++		 * would make the object snooped which might have a
++		 * negative performance impact.
++		 */
++		if (INTEL_INFO(dev)->gen >=3D 7 && !IS_VALLEYVIEW(dev)) {
 +			ret =3D i915_gem_object_set_cache_level(ctx->obj,
 +							      I915_CACHE_L3_LLC);
 +			/* Failure shouldn't ever happen this early */
 +			if (WARN_ON(ret))
 +				goto err_out;
 +		}
 +	}
 =20
  	/* Default context will never have a file_priv */
 -	if (file_priv =3D=3D NULL)
 -		return ctx;
 -
 -	ret =3D idr_alloc(&file_priv->context_idr, ctx, DEFAULT_CONTEXT_ID, 0,
 -			GFP_KERNEL);
 -	if (ret < 0)
 -		goto err_out;
 +	if (file_priv !=3D NULL) {
 +		ret =3D idr_alloc(&file_priv->context_idr, ctx,
 +				DEFAULT_CONTEXT_ID, 0, GFP_KERNEL);
 +		if (ret < 0)
 +			goto err_out;
 +	} else
 +		ret =3D DEFAULT_CONTEXT_ID;
 =20
  	ctx->file_priv =3D file_priv;
  	ctx->id =3D ret;

--Signature=_Tue__15_Apr_2014_11_26_38_+1000_BPnAXbClhMGv4s.d
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTTIrSAAoJEMDTa8Ir7ZwVPicP/R1ba5Fk8Vp3UcuHhA8ht8ZB
tagjJDSyYvtDrp/MbKFkCxNKMFRRNaSFVBKb6iXOsY/Eh17r07V6LTXBR1Ir3+Ov
aQmoV59TrV+8Cf4l2fmz/9dV3wOh5iksbCiYzZNP7bFOGAY01cmddeux9QMIVBfD
5Om+g21n7qHr404YDmCnKWW0POnEJA9cOdVP5aulo/9jkfZyR1YhS++Th+vYILZC
AK3VB/A5gLq+o7dGJLa3gV3dovZVsn2fV1HDbbcN3HIRlc8t5bihAUAcX+DcsCVY
i5bEfmY9g6TRaLEbUUcVh6Q5zCzzJgavQAGlGmfDKZBSPYF6Jy7Fr4Mv0BCKYiRG
uOONThm34S+vLAeES56Rj5QZkPtXQXT1LqTOlF0QiP9k2MngSgPQU3mLMPo5nB6N
YiM6CaLEO/ZKx7saDSBL0u1PFcN4JVpIEzvyh/uowxuMSR1NU3c50UIx6tCiAuTW
qZxqKmqce7AQ19gas1SJA5f8PutFOWnNcD1iVcWaw82/IIFmhLvIyUy6LSWpl0dG
u4Be7bxpAdO6aUUyFTnBs+xMjUIFt19bmTdaaK5hwYYhHdbcE/hn2zAw8PHnQ/7k
rOKOgPSrPk0ofwLQsdwy1qxwEAnbmmQ1ALo7bJhb8EfzAwa3S9hJ0ZrQrJgO6gjS
VTwrMu12G2FNSImjkxHV
=uYHu
-----END PGP SIGNATURE-----

--Signature=_Tue__15_Apr_2014_11_26_38_+1000_BPnAXbClhMGv4s.d--
