Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbaHEDnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 23:43:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40966 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753953AbaHEDSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 23:18:09 -0400
Date: Tue, 5 Aug 2014 13:17:58 +1000
From: NeilBrown <neilb@suse.de>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Is lockref_get_not_zero() really correct in dget_parent()
Message-ID: <20140805131758.3afa6b0b@notabene.brown>
X-Mailer: Claws Mail 3.10.1-123-gae895c (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/lOvzDt56sFO2tXlDr8hFgLT"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/lOvzDt56sFO2tXlDr8hFgLT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi,
 I've been looking at last year's change to dentry refcounting which sets t=
he
 refcount to -128 (mark_dead()) when the dentry is gone.

 As this is an "unsigned long" and there are several places where
 d_lockref.count is compared e.g. "> 1", I start feeling uncomfortable, as
 "-128" is greater than "1".

 Most of them look safe because there is locking in place and
 d_lockref.count will never be seen as "-128" unless you get the reference
 with only rcu_read_lock().

 That brings me to dget_parent().  It only has rcu_read_lock() protection, =
and
 yet uses lockref_get_not_zero().  This doesn't seem safe.

 Is there a reason that it is safe that I'm not seeing?  Or is the following
 needed?

Thanks,
NeilBrown

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/fs/dcache.c b/fs/dcache.c
index 06f65857a855..c48ce95a38f2 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -699,7 +699,7 @@ struct dentry *dget_parent(struct dentry *dentry)
 	 */
 	rcu_read_lock();
 	ret =3D ACCESS_ONCE(dentry->d_parent);
-	gotref =3D lockref_get_not_zero(&ret->d_lockref);
+	gotref =3D lockref_get_not_dead(&ret->d_lockref);
 	rcu_read_unlock();
 	if (likely(gotref)) {
 		if (likely(ret =3D=3D ACCESS_ONCE(dentry->d_parent)))

--Sig_/lOvzDt56sFO2tXlDr8hFgLT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU+BM5jnsnt1WYoG5AQKODg/+MNjSb1W+fgKNXzeYpO+xe6bHEiWJCvmN
GPvSyA96fl+5lm1mUBYLj7zk2R4dJ3rCZ0+Yp0b5W0mMpy+RpQbf7UrGNaTUmh7k
Prit8XbpAILOGx4avC6V4La0Gr+xyYMoyqAMUu3JI9OyQlPeiZfitmS3iBuQVdFQ
l7NWfN8wslNM8Rcmvc/xZ9e8YRol10IQGLdgbRUP9mjvlW9Q+erN24RnQ5uEFPRy
8QO5Dvm06hG7ZjRguOuQDh/JsGUDz5n43PkWhDTuDFjpSffVYzo27n7s7ESL3Wgv
fz6QXLSqwf+AvReo284WuO2u96gAG6SVxL9QDaWzV2Zggpdsp9PClO0zMuqLsZ4S
dIITg43qjRYMDyLTfLjTI12Hb26slX5csLdCzd0mqhbtge98d8zRG6E7+jdGsl2j
RoNZ1gikoU1AZAiBStwC7UQDn6VA2MwwmFagMKjr9lTTrv6FhrzL4/9HOwd1LOAP
LYtQ0Cj76/H3nLT6bttIGitl/WXxSOgrtvEzhVh1NAeifz90mP6bmWb2g8eYefCQ
g+f1A6M3rKxO/ELbsxg8C4uomxEBa+zRsWIACv/+xHI89WzkKzYzJKjwJfSYjNv2
8Akc/S7uN472FSDpTPol1ou2J6ntfWYzeE9h1bEEfVM3/5Bc80c8WCSRuiPaOap4
knoU6Tlif4w=
=oaZg
-----END PGP SIGNATURE-----

--Sig_/lOvzDt56sFO2tXlDr8hFgLT--
