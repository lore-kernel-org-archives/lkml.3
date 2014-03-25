Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbaCYDCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 23:02:37 -0400
Received: from ozlabs.org ([203.10.76.45]:40411 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbaCYDCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 23:02:36 -0400
Date: Tue, 25 Mar 2014 14:02:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>, Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        William Hubbs <w.d.hubbs@gmail.com>
Subject: linux-next: build failure after merge of the modules tree
Message-Id: <20140325140226.bb363b52de048346cf01a179@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Mar_2014_14_02_26_+1100_q.E_j9SZa5i4Dkyx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Mar_2014_14_02_26_+1100_q.E_j9SZa5i4Dkyx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

After merging the modules tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from include/linux/thread_info.h:11:0,
                 from arch/x86/include/asm/preempt.h:6,
                 from include/linux/preempt.h:18,
                 from include/linux/spinlock.h:50,
                 from include/linux/wait.h:8,
                 from include/linux/fs.h:6,
                 from drivers/staging/speakup/spk_types.h:9,
                 from drivers/staging/speakup/spk_priv.h:27,
                 from drivers/staging/speakup/speakup_acntsa.c:26:
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
drivers/staging/speakup/speakup_acntsa.c:50:2: note: in expansion of macro =
'__ATTR'
  __ATTR(caps_start, USER_RW, spk_var_show, spk_var_store);
  ^

And many more ...

Exposed by commit 58f86cc89c33 ("VERIFY_OCTAL_PERMISSIONS: stricter
checking for sysfs perms").

drivers/staging/speakup/speakup.h has

#define USER_RW (S_IFREG|S_IRUGO|S_IWUGO)
and others

which are used in many attribute definitions (and only in those
definitions).  So I added this fixup patch (Rusty you might like to add
this to your tree):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 25 Mar 2014 13:54:38 +1100
Subject: [PATCH] VERIFY_OCTAL_PERMISSIONS: fix up for staging/speakup

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/staging/speakup/speakup.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/speakup/speakup.h b/drivers/staging/speakup/sp=
eakup.h
index 0126f714821a..578824a9829d 100644
--- a/drivers/staging/speakup/speakup.h
+++ b/drivers/staging/speakup/speakup.h
@@ -10,10 +10,10 @@
 #define MAX_DESC_LEN 72
=20
 /* proc permissions */
-#define USER_R (S_IFREG|S_IRUGO)
-#define USER_W (S_IFREG|S_IWUGO)
-#define USER_RW (S_IFREG|S_IRUGO|S_IWUGO)
-#define ROOT_W (S_IFREG|S_IRUGO|S_IWUSR)
+#define USER_R S_IRUGO
+#define USER_W S_IWUGO
+#define USER_RW (S_IRUGO|S_IWUGO)
+#define ROOT_W (S_IRUGO|S_IWUSR)
=20
 #define TOGGLE_0 .u.n =3D {NULL, 0, 0, 1, 0, 0, NULL }
 #define TOGGLE_1 .u.n =3D {NULL, 1, 0, 1, 0, 0, NULL }
--=20
1.9.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__25_Mar_2014_14_02_26_+1100_q.E_j9SZa5i4Dkyx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTMPHHAAoJEMDTa8Ir7ZwVhw4P/jk79DkUr2ph2RncFH+1wGP4
auPFBAQ4wKSgPDi9Nr3JIcr4qVU05B/uOVsMv/80PeU5L8j/1lQwmSDOFYOiEMGH
W5x5kT/qH5mUGrJfjJrlIBSucUhhDKNnsg4PwSukdrg4WciamOH1myiEE+HAkfVp
2xI98KpNLzdOOr32Qo08REXl6Eliol6BJ989lnNX5cCvQ+IbKBgLg61qxRlcckQ0
yKfpoMpOmnX13uZYMmPugEnBJcc3EdPyK2E6T6iTW5IUu6eBSeMQ7+XfTZiqyu0o
9CGHRnaQJg1LVNmdzzH5Thq1Yoi3kCG0/wqf829KDD1ECQaf5CEEUI2qKFHF/4cD
MVmeMSDOA8PbIuhzwESRDMA+kvoLaIpG76L2dVaj5AcxMdVXsR6kS1vpec7tCVMn
DlrNDzN34ORQikFmeIFsY6yu60fIX0lUiCsTOHe6L7Tqyzh4jhbSCNK8Raxs1x5J
ZL6Ns0sVd9EJ2gr9poy5SySTwoRKQsSbdP85lX8Cl0Hz8ORtdtjFldx2Rk5UAFBU
ZayyIMLfPvghlkvvWRoT8jqSgDXimhjTDKUWrh158qwyskWiSONNBAFFBqKkXiQb
GA2kAdoaFThouo8nmYMz9bXDRun7c18N8jvDx/J9H8itB5XSTTxsjupNkdmDwUV9
IeW3Vut1wctcs6dW8WZI
=dYpb
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Mar_2014_14_02_26_+1100_q.E_j9SZa5i4Dkyx--
