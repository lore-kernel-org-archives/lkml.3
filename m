Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbaCNSoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 14:44:01 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38222 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144AbaCNSn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 14:43:59 -0400
Date: Fri, 14 Mar 2014 18:43:47 +0000
From: Mark Brown <broonie@kernel.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140314184347.GY366@sirena.org.uk>
References: <20140314183653.0a4a750f0b72080e3b982104@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KCLoHzx0Ylaw/v4x"
Content-Disposition: inline
In-Reply-To: <20140314183653.0a4a750f0b72080e3b982104@kernel.org>
X-Cookie: Some assembly required.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: manual merge of the compat tree with the  tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KCLoHzx0Ylaw/v4x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 14, 2014 at 06:36:53PM +0000, Mark Brown wrote:

> Today's linux-next merge of the compat tree got a conflict in  between
> commit 81993e81a99 ("compat: Get rid of
> (get|put)_compat_time(val|spec)") from the tip tree and commit
> 932602e23832 ("fs/compat: convert to COMPAT_SYSCALL_DEFINE with
> changing parameter types") from the compat tree.

> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

And essentially the same thing in ipc/compat_mq.c:

diff --cc ipc/compat_mq.c
index a9cf16378d7a,d58747293772..000000000000
--- a/ipc/compat_mq.c
+++ b/ipc/compat_mq.c
@@@ -64,10 -64,24 +64,10 @@@ COMPAT_SYSCALL_DEFINE4(mq_open, const c
  	return sys_mq_open(u_name, oflag, mode, p);
  }
 =20
- asmlinkage long compat_sys_mq_timedsend(mqd_t mqdes,
- 			const char __user *u_msg_ptr,
- 			size_t msg_len, unsigned int msg_prio,
- 			const struct compat_timespec __user *u_abs_timeout)
 -static int compat_prepare_timeout(struct timespec __user **p,
 -				  const struct compat_timespec __user *u)
 -{
 -	struct timespec ts;
 -	if (!u) {
 -		*p =3D NULL;
 -		return 0;
 -	}
 -	*p =3D compat_alloc_user_space(sizeof(ts));
 -	if (get_compat_timespec(&ts, u) || copy_to_user(*p, &ts, sizeof(ts)))
 -		return -EFAULT;
 -	return 0;
 -}
 -
+ COMPAT_SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqdes,
+ 		       const char __user *, u_msg_ptr,
+ 		       compat_size_t, msg_len, unsigned int, msg_prio,
+ 		       const struct compat_timespec __user *, u_abs_timeout)
  {
  	struct timespec __user *u_ts;
 =20
@@@ -78,14 -92,13 +78,14 @@@
  			msg_prio, u_ts);
  }
 =20
- asmlinkage ssize_t compat_sys_mq_timedreceive(mqd_t mqdes,
- 			char __user *u_msg_ptr,
- 			size_t msg_len, unsigned int __user *u_msg_prio,
- 			const struct compat_timespec __user *u_abs_timeout)
+ COMPAT_SYSCALL_DEFINE5(mq_timedreceive, mqd_t, mqdes,
+ 		       char __user *, u_msg_ptr,
+ 		       compat_size_t, msg_len, unsigned int __user *, u_msg_prio,
+ 		       const struct compat_timespec __user *, u_abs_timeout)
  {
  	struct timespec __user *u_ts;
 -	if (compat_prepare_timeout(&u_ts, u_abs_timeout))
 +
 +	if (compat_convert_timespec(&u_ts, u_abs_timeout))
  		return -EFAULT;
 =20
  	return sys_mq_timedreceive(mqdes, u_msg_ptr, msg_len,

--KCLoHzx0Ylaw/v4x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTI03gAAoJELSic+t+oim9yzYQAJcL61P53DUvAOlBS4j9Euxe
ZfqT0TQ4IPByZh1I4MCTErv+dC6C0K6S3dwso5pCfaJPkwZ3yXW8xOxao3NFX/DP
MhCr3bDic5cDSdIdmbtO72ylorXELnHYuZiigdIDoPCNc+eiIjmIvp1+kbu/RTqQ
finpZN4Rw5A9fKVT6/zUTfFbv7kXjW1VvtixBHKpPuBeo9nv9gRfQ6VnnLqmuyOu
PpQJWP8xvBkNoidUbrLTAwkAZXQjioHOwsbhH8tDZuqmcIfysDOUfky1ydZY0Kfa
arcjM2AmzgLwo5Q8GTDLczbh/d6/VSBSoOOTHlGAx2EFKIJQ4+Q/1OC41WhAr3o/
DI1KwG29QpLhU0jfPDUOP07uJ9jmMF+95VznPkAtbLsDyiak0m41uyz5aC3y+WXi
4LJdChIhRDWFRyyUveWJ2Exi24NgrQ63PyHqQjQYBz52yKX5O8Vm5My+Pqtm/x3B
jC24Vf0EKAB050PQDA8kb0Ws2j+HabTcl+AGuyO9vTz98JOYyptYtyMveXpMeQoj
6vn7STT2HjXVvEgP2Jgy9Zq6f8kaDZUhdboQ4JmjuV6iQAffck9bYXNopHZWdiAy
4nRrlY3TMgBy4wEi2320HKzVjgHsS6hb6V/aYfRe/FcuRM5QPjHerOwACPy8FiRp
FIiOCxOFedFCjqXmUUAV
=GM/W
-----END PGP SIGNATURE-----

--KCLoHzx0Ylaw/v4x--
