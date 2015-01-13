Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459AbbAMMFD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 07:05:03 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:43360 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbbAMME7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 07:04:59 -0500
From: Jeff Layton <jeff.layton@primarydata.com>
X-Google-Original-From: Jeff Layton <jlayton@primarydata.com>
Date: Tue, 13 Jan 2015 07:04:50 -0500
To: NeilBrown <neilb@suse.de>
Cc: Jeff Layton <jeff.layton@primarydata.com>, "L. A. Walsh" <suse@tlinx.org>,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] locks: fix NULL-deref in generic_delete_lease
Message-ID: <20150113070450.60f912f6@tlielax.poochiereds.net>
In-Reply-To: <20150113151743.7c260163@notabene.brown>
References: <20150113151743.7c260163@notabene.brown>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/xR4MQ25LRzLgx/hZZ_co=zb"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/xR4MQ25LRzLgx/hZZ_co=zb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 13 Jan 2015 15:17:43 +1300
NeilBrown <neilb@suse.de> wrote:

>=20
>=20
> commit 0efaa7e82f02fe69c05ad28e905f31fc86e6f08e
>   locks: generic_delete_lease doesn't need a file_lock at all
>=20
> moves the call to fl->fl_lmops->lm_change() to a place in the
> code where fl might be a non-lease lock.
> When that happens, fl_lmops is NULL and an Oops ensures.
>=20
> So add an extra test to restore correct functioning.
>=20
> Reported-by: Linda Walsh <suse@tlinx.org>
> Link: https://bugzilla.suse.com/show_bug.cgi?id=3D912569
> Cc: stable@vger.kernel.org (v3.18)
> Fixes: 0efaa7e82f02fe69c05ad28e905f31fc86e6f08e
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>  fs/locks.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/locks.c b/fs/locks.c
> index 735b8d3fa78c..59e2f905e4ff 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -1702,7 +1702,7 @@ static int generic_delete_lease(struct file *filp)
>  			break;
>  	}
>  	trace_generic_delete_lease(inode, fl);
> -	if (fl)
> +	if (fl && IS_LEASE(fl))
>  		error =3D fl->fl_lmops->lm_change(before, F_UNLCK, &dispose);
>  	spin_unlock(&inode->i_lock);
>  	locks_dispose_list(&dispose);

Looks good. I'll merge and do a bit of testing on it today and send it
along to Linus in the next day or so.

Thanks!
--=20
Jeff Layton <jlayton@primarydata.com>

--Sig_/xR4MQ25LRzLgx/hZZ_co=zb
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUtQnoAAoJEAAOaEEZVoIVEqkP/09Z0Z49/0XhTxJOKR31zS8J
uNz3dMTjbDl0CBnZPQ7i+iNE8xSTIjr9CZozIbf/uyoJ8IYjjyyoFN2RCbQll+1s
hVGxgQdBkkL4lt7dnc6uAj+SdRt8aE7/n5qcNHeMNUJOI/6+tkfwO7JZlCN8CXD1
+i0jvhMctzpfNWqj8BwdIRFTGrvdiRL+AKqx82tW3lxZUf3DUWse2JT+RcvPqq8s
rLXEQz2H/aGeCzRL9RcvociJuXeIln2FZEBkAQIRFGeJ1wl3V4bjXNltNIpwdcKg
ZnqlE2NjPIEgpJwWRVRgzWcUo7L3Zv2bs1wJerXQI4darKiXyyAMGLOUntwLXoGC
TqSQCiN33AbVrC7daKZEKsQPPEhXVyTBUsx8g4qXp47l7OqjG2XkvtW2WXquR2QV
8Dbz7pdUoJerNbXyxrANixT+NDHZYtmnYLOPuYNIu3Yl+S42G82mjAYBZaew6Efy
fweMB+NfIM4Cw5HdRQP1OOu4ZEG/BSaJeNE+IiMXUvOBJsm4TKV/rtQsWsjEBoPH
Ls25JovpCiNk+sehhFeABoaPpqpa9zktFPNktx2w0qPufsnEArZND+AXjbdY0yCt
O5vBBgF8OjfFiCoFvx7u4SVXJVOIi6yVX9B3OTVFeplrQY/6j9ayq9fnORNyIjX3
Ph6zPvem4oD64Juytluo
=SpA2
-----END PGP SIGNATURE-----

--Sig_/xR4MQ25LRzLgx/hZZ_co=zb--
