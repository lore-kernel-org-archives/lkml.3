Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933627Ab3DJFzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 01:55:06 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45667 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061Ab3DJFzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 01:55:04 -0400
Date: Wed, 10 Apr 2013 15:54:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Joe Perches <joe@perches.com>
Subject: linux-next: manual merge of the staging tree with the vfs tree
Message-Id: <20130410155451.2792f82efeaf37b6e5889ea8@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__10_Apr_2013_15_54_51_+1000_4EKBFpOp7kwXhZHq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Apr_2013_15_54_51_+1000_4EKBFpOp7kwXhZHq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/vt6655/device_main.c between commit f805442e130c
("vt6655: slightly clean reading config file") from the vfs tree and
commits 915006cddc79 ("staging:vt6655:device_main: Whitespace cleanups")
and 5e0cc8a231be ("staging: vt6655: Convert to kernel brace style") from
the staging tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/vt6655/device_main.c
index a89ab9b,be4f6c2..0000000
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@@ -2933,39 -2723,61 +2724,39 @@@ static inline u32 ether_crc(int length
 =20
  //2008-8-4 <add> by chester
  static int Config_FileGetParameter(unsigned char *string,
- 		unsigned char *dest, unsigned char *source)
+ 				   unsigned char *dest, unsigned char *source)
  {
-   unsigned char buf1[100];
-   int source_len =3D strlen(source);
+ 	unsigned char buf1[100];
+ 	int source_len =3D strlen(source);
 =20
-     memset(buf1,0,100);
-     strcat(buf1, string);
-     strcat(buf1, "=3D");
-     source+=3Dstrlen(buf1);
+ 	memset(buf1, 0, 100);
+ 	strcat(buf1, string);
+ 	strcat(buf1, "=3D");
+ 	source +=3D strlen(buf1);
 =20
-    memcpy(dest,source,source_len-strlen(buf1));
-  return true;
+ 	memcpy(dest, source, source_len - strlen(buf1));
+ 	return true;
  }
 =20
- int Config_FileOperation(PSDevice pDevice,bool fwrite,unsigned char *Para=
meter)
 -int Config_FileOperation(PSDevice pDevice, bool fwrite, unsigned char *Pa=
rameter) {
 -	unsigned char *config_path =3D CONFIG_PATH;
 -	unsigned char *buffer =3D NULL;
++int Config_FileOperation(PSDevice pDevice, bool fwrite, unsigned char *Pa=
rameter)
 +{
 +	unsigned char *buffer =3D kmalloc(1024, GFP_KERNEL);
  	unsigned char tmpbuffer[20];
 -	struct file   *filp =3D NULL;
 -	mm_segment_t old_fs =3D get_fs();
 -	//int oldfsuid=3D0,oldfsgid=3D0;
 +	struct file *file;
- 	int result=3D0;
+ 	int result =3D 0;
 =20
 -	set_fs(KERNEL_DS);
 -
 -	/* Can't do this anymore, so we rely on correct filesystem permissions:
 -	//Make sure a caller can read or write power as root
 -	oldfsuid=3Dcurrent->cred->fsuid;
 -	oldfsgid=3Dcurrent->cred->fsgid;
 -	current->cred->fsuid =3D 0;
 -	current->cred->fsgid =3D 0;
 -	*/
 -
 -	//open file
 -	filp =3D filp_open(config_path, O_RDWR, 0);
 -	if (IS_ERR(filp)) {
 -		printk("Config_FileOperation:open file fail?\n");
 -		result =3D -1;
 -		goto error2;
 -	}
 -
 -	if (!(filp->f_op) || !(filp->f_op->read) || !(filp->f_op->write)) {
 -		printk("file %s cann't readable or writable?\n", config_path);
 -		result =3D -1;
 -		goto error1;
 -	}
 -
 -	buffer =3D kmalloc(1024, GFP_KERNEL);
 -	if (buffer =3D=3D NULL) {
 +	if (!buffer) {
  		printk("allocate mem for file fail?\n");
 -		result =3D -1;
 -		goto error1;
 +		return -1;
 +	}
 +	file =3D filp_open(CONFIG_PATH, O_RDONLY, 0);
 +	if (IS_ERR(file)) {
 +		kfree(buffer);
 +		printk("Config_FileOperation:open file fail?\n");
 +		return -1;
  	}
 =20
 -	if (filp->f_op->read(filp, buffer, 1024, &filp->f_pos) < 0) {
 +	if (kernel_read(file, 0, buffer, 1024) < 0) {
  		printk("read file error?\n");
  		result =3D -1;
  		goto error1;

--Signature=_Wed__10_Apr_2013_15_54_51_+1000_4EKBFpOp7kwXhZHq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRZP6rAAoJEECxmPOUX5FEymoP/iLNFVZBiCQFcL6Nm/eG/Oqy
/iGCZiGBTwbp06iverk1iDlRWeWeaRjxieqmTjJYrjpawqi6PhX4O3A2FmkpRSNQ
LALAExC/4EtKkdRMYz9Rn2g/Gm4QjS/l0znGJQ+DSA6luH9BJnwCoWXmlPsJw7Dj
TbdGhIuU0m/IT9xyXJhfdavxsKWyj74G0mzS9Jwd9cOYcZR+fvwQifRv065r0QIr
mChg4MiOWaaQheWBpPQjaJxZEBGdcpf9+RknTO+EU3L70bn8oWISdk3z8EIa/O86
RcljlTkZtUjkc/wGg3+/LvW4fMvcNb2gWS8h88yNegU1fM1afTu8LIg0HcCuaNYG
LP+WFDoLFoEwmw1Z3lhmFtHgFb1nM4NTQGX6EohR1PMQCZQ5I7CtzevwZlHDiiSr
UoNG4Q343Shx+M3DVFIR0AnmK1cGqkBiqfV6yKuxGXcDLil7wLdz+6iXsYfRbyNw
zrrogDhrEInsbRX4yuOqZARi8VXS/eH48hprcP4JOqQr1CI7oHtEWkk8sA7FPX59
VI2CX5oR4vlHFFuw4jOr7HGbAyodbi/Uw0GNE56NbNiRFhmqvwx2kM/Tm2AmY1+N
RVIb4z6Bofjtan/P8zRjh4ZnXuhRqqxv8zCf80WGVCfHZStY1kng/ARD0xGdNAlG
NswUpfsil4sKtsSlSedJ
=APHh
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Apr_2013_15_54_51_+1000_4EKBFpOp7kwXhZHq--
