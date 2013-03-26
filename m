Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759581Ab3CZMFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 08:05:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757082Ab3CZMFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 08:05:30 -0400
Date: Tue, 26 Mar 2013 09:04:52 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>, Greg KH <greg@kroah.com>
Subject: Re: linux-next: build failure after merge of the final tree
 (v4l-dvb tree related)
Message-ID: <20130326090452.01550c37@redhat.com>
In-Reply-To: <20130326171847.18cd41b85d3caee6373d9447@canb.auug.org.au>
References: <20130326171847.18cd41b85d3caee6373d9447@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/NV.2uLdp9ckhxZ9sXrmp4H5"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/NV.2uLdp9ckhxZ9sXrmp4H5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Em Tue, 26 Mar 2013 17:18:47 +1100
Stephen Rothwell <sfr@canb.auug.org.au> escreveu:

> Hi all,
>=20
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
>=20
> drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c: In function 'solo_enc=
_default':
> drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c:1031:7: error: case la=
bel does not reduce to an integer constant
> drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c:1035:7: error: case la=
bel does not reduce to an integer constant
>=20
> I am not sure why this has suddenly appeared, but I have disabled the
> driver for now using this patch:

Well, solo6x10 didn't use to have its own private ioctl's until now.
Still, that's strange, as there are other drivers also using vidioc_default.

I suspect that those _IO* have its highest bit equal to 1 on powerpc
being too big for int. If so, the enclosed patch should fix.=20
I'm still wandering why it didn't cause any compilation problems here.

Ok, I didn't try to compile it on powerpc, but still integers have 32
bits on ppc, right?

Anyway, could you please try the enclosed patch?

-

[PATCH] [media] ioctl numbers are unsigned int

As reported by Stephen Rothwell <sfr@canb.auug.org.au>:
> drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c: In function 'solo_enc=
_default':
> drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c:1031:7: error: case la=
bel does not reduce to an integer constant
> drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c:1035:7: error: case la=
bel does not reduce to an integer constant

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/pci/cx18/cx18-ioctl.c b/drivers/media/pci/cx18/c=
x18-ioctl.c
index 7dbd5a9..aee7b6d 100644
--- a/drivers/media/pci/cx18/cx18-ioctl.c
+++ b/drivers/media/pci/cx18/cx18-ioctl.c
@@ -1110,7 +1110,7 @@ static int cx18_log_status(struct file *file, void *f=
h)
 }
=20
 static long cx18_default(struct file *file, void *fh, bool valid_prio,
-							int cmd, void *arg)
+			 unsigned int cmd, void *arg)
 {
 	struct cx18 *cx =3D fh2id(fh)->cx;
=20
diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/i=
vtv-ioctl.c
index 50379b2..9cbbce0 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.c
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
@@ -1807,7 +1807,7 @@ static int ivtv_decoder_ioctls(struct file *filp, uns=
igned int cmd, void *arg)
 }
=20
 static long ivtv_default(struct file *file, void *fh, bool valid_prio,
-			 int cmd, void *arg)
+			 unsigned int cmd, void *arg)
 {
 	struct ivtv *itv =3D fh2id(fh)->itv;
=20
diff --git a/drivers/media/pci/meye/meye.c b/drivers/media/pci/meye/meye.c
index 7859c43..2381b05 100644
--- a/drivers/media/pci/meye/meye.c
+++ b/drivers/media/pci/meye/meye.c
@@ -1410,7 +1410,7 @@ static int vidioc_streamoff(struct file *file, void *=
fh, enum v4l2_buf_type i)
 }
=20
 static long vidioc_default(struct file *file, void *fh, bool valid_prio,
-						int cmd, void *arg)
+			   unsigned int cmd, void *arg)
 {
 	switch (cmd) {
 	case MEYEIOC_G_PARAMS:
diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/=
platform/davinci/vpfe_capture.c
index 20db8a0..8c50d30 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -1686,7 +1686,7 @@ unlock_out:
=20
=20
 static long vpfe_param_handler(struct file *file, void *priv,
-		bool valid_prio, int cmd, void *param)
+		bool valid_prio, unsigned int cmd, void *param)
 {
 	struct vpfe_device *vpfe_dev =3D video_drvdata(file);
 	int ret =3D 0;
diff --git a/drivers/media/radio/radio-si4713.c b/drivers/media/radio/radio=
-si4713.c
index 2a2d21e..38b3f15 100644
--- a/drivers/media/radio/radio-si4713.c
+++ b/drivers/media/radio/radio-si4713.c
@@ -222,7 +222,7 @@ static int radio_si4713_s_frequency(struct file *file, =
void *p,
 }
=20
 static long radio_si4713_default(struct file *file, void *p,
-				 bool valid_prio, int cmd, void *arg)
+				 bool valid_prio, unsigned int cmd, void *arg)
 {
 	return v4l2_device_call_until_err(get_v4l2_dev(file), 0, core,
 					  ioctl, cmd, arg);
diff --git a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c b/drivers/s=
taging/media/solo6x10/solo6x10-v4l2-enc.c
index 39a8fb2..6c7d20f 100644
--- a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
@@ -1021,7 +1021,7 @@ static int solo_s_parm(struct file *file, void *priv,
 }
=20
 static long solo_enc_default(struct file *file, void *fh,
-			bool valid_prio, int cmd, void *arg)
+			bool valid_prio, unsigned int cmd, void *arg)
 {
 	struct solo_enc_dev *solo_enc =3D video_drvdata(file);
 	struct solo_dev *solo_dev =3D solo_enc->solo_dev;
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 75a7dfc..b273f0e 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -275,7 +275,7 @@ struct v4l2_ioctl_ops {
=20
 	/* For other private ioctls */
 	long (*vidioc_default)	       (struct file *file, void *fh,
-					bool valid_prio, int cmd, void *arg);
+					bool valid_prio, unsigned int cmd, void *arg);
 };
=20
=20

--Sig_/NV.2uLdp9ckhxZ9sXrmp4H5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRUY73AAoJEGO08Bl/PELnoMgQAIO+OUM1Mc47oIkdwkjirAD9
mPIs9IPTmjNFXb/Jfy01OlG86QkHQfB8eBoA8Zl7RX3R9B9fjxfvPI1V6lRkRTXf
wfNL+C2v1lTLup9qYE+oOkRirHABSBJUJX5hz3l0VGZEgErljSBwKpqH8Vt681I6
Picb13oMBN3tdRFpi9LV5RlG1CEaWSY9AGu59F/JPIMAWypGC+fB3xJY7UXvWgFb
DZhGMLjvRg0eqiypzZPmkmrpvAetShQr7rJcUl5lamKNqG8cetKmd68VvmiU5dAT
JpfzBDkfzV0BizZhHRZSG9cCu7bk2jHjDL1IQZfvEqZS9oL/C+Lj7qNBHXZPvdXF
yoHqBkRJbgUM4pYRk0K6FcNhhHBMQM32Ysnznja8+EoWJRD/jrACs36s3OUIBrzA
CvEze8XM4g4BUMeUlTXqTzMOwQ1sysHFbFBhMCJOGgWFEAGEZVBHL90vjipewpxu
lk3MnmJHQW+eGlrpomsOfNmUkpNCpJJ7wblX7j+BCbs5HnZjgfkgeU1UHJf1v0sD
8TynkQ9kvtNpQZIvPE1Nhh1RS6et/xupHTn2WBZHLTNx2Q+wPb6SOEcqKndpnJzH
IvHoUbl+L2ORCQq6B+sSf1M4ONNdmDu5E31qq1qNH9RUPGVS+ra3GdAYEQdi+zpW
ZvlQF8nehwomEsHh6dtv
=vQ55
-----END PGP SIGNATURE-----

--Sig_/NV.2uLdp9ckhxZ9sXrmp4H5--
