Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaCYHpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 03:45:42 -0400
Received: from ozlabs.org ([203.10.76.45]:47541 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbaCYHpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 03:45:05 -0400
Date: Tue, 25 Mar 2014 18:44:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: linux-next: build failure after merge of the akpm-current tree
Message-Id: <20140325184457.af6f08e9829e275100870b01@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Mar_2014_18_44_57_+1100_mQDsAeW8kiVT0gTQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Mar_2014_18_44_57_+1100_mQDsAeW8kiVT0gTQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from include/linux/thread_info.h:11:0,
                 from arch/x86/include/asm/preempt.h:6,
                 from include/linux/preempt.h:18,
                 from include/linux/spinlock.h:50,
                 from fs/ocfs2/stackglue.c:22:
include/linux/bug.h:33:45: error: negative width in bit-field '<anonymous>'
 #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
                                             ^
include/linux/kernel.h:848:3: note: in expansion of macro 'BUILD_BUG_ON_ZER=
O'
   BUILD_BUG_ON_ZERO((perms) > 0777) +    \
   ^
include/linux/sysfs.h:75:12: note: in expansion of macro 'VERIFY_OCTAL_PERM=
ISSIONS'
    .mode =3D VERIFY_OCTAL_PERMISSIONS(_mode) },  \
            ^
fs/ocfs2/stackglue.c:614:2: note: in expansion of macro '__ATTR'
  __ATTR(dlm_recover_callback_support, S_IFREG | S_IRUGO,
  ^

Caused by commit 88991182643c ("ocfs2: add dlm_recover_callback_support
in sysfs") interacting with commit 58f86cc89c33
("VERIFY_OCTAL_PERMISSIONS: stricter checking for sysfs perms") from the
modules tree.

I applied this fix up patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 25 Mar 2014 18:39:49 +1100
Subject: [PATCH] ocfs2: VERIFY_OCTAL_PERMISSIONS fix up

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/ocfs2/stackglue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index c8c9d54dabc5..5e4d314c854d 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -611,7 +611,7 @@ static ssize_t ocfs2_dlm_recover_show(struct kobject *k=
obj,
 }
=20
 static struct kobj_attribute ocfs2_attr_dlm_recover_support =3D
-	__ATTR(dlm_recover_callback_support, S_IFREG | S_IRUGO,
+	__ATTR(dlm_recover_callback_support, S_IRUGO,
 	       ocfs2_dlm_recover_show, NULL);
=20
 static struct attribute *ocfs2_attrs[] =3D {
--=20
1.9.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__25_Mar_2014_18_44_57_+1100_mQDsAeW8kiVT0gTQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTMTP/AAoJEMDTa8Ir7ZwVBksQAIlkczltLK/OyL/GW/i2Rknh
KVn/NbWqzRmvwejmsdSnuQsQhM4rOj4jkFA3ubqqOGDb4YjOBpibkZYGK2piJJRb
IH/X5kpQU0jRMD+g3ta4MxENgrxSmo1kseNUdBEGX6gMAMXA5Ck2/6jFAcMYyf1L
twBUqI471dmJfsA7Bgz3/SyDPcJIe6IVs/CY+N5cuDZYH8A9ZPMz/J4Tf+YDyejx
PeZjXeJPFAMnVD/luPnTTTcGgQfwcK59SuYTUuj0W48mjKo+AHIb92wI7l+hHF6D
Cz9eSopC+4hrN+dLMxqTuJYIBQMFIC2ZQ9h5jAOhpSAVV6xSXGI54WxF3Udfsu6K
UCfpe8D37RqOEaRofl0YUOWwcz/m2tqBkd5W9ojZFvw65qjrsl8vPYiIKP9tZN+y
e+VyfcC/2bfFjwFh7TytgP7Tsah/3VuGIre3K6SMzM+b9fXzCNqGeHuGY6UV0K/Q
hthhNOjrA/SvjpcCag4Cg10poUi9T3Ydsy5qPENxsB7/bXZxZY/nlQ1+NWWvIdlg
YjnQpeSKwlW8nu+iXNckEVn0g26esZ2A8RjN48ig6noecY8iUX0j/i6bSFI1heZk
KALAASdalMv5+JcZCY4D4gRA1aFyXWWfcvy3Tf3j+KWrTRcm5o+w51w8yM4U44ko
vk5Zj8nYAbU5w3FUk7WB
=FyKn
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Mar_2014_18_44_57_+1100_mQDsAeW8kiVT0gTQ--
